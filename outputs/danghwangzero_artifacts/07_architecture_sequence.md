# 당황Zero Architecture and Sequence

## System Architecture

```text
Flutter App
  - 화면 표시
  - 위치/카메라 권한 처리
  - 버튼형 상황 파악 UI
  - 사진 촬영/업로드
  - 체크리스트/요약 표시

FastAPI Backend
  - API request/response 처리
  - 입력값 검증
  - 사고 기록 service
  - 사진 업로드 service
  - 중앙 조정자(orchestrator)
  - AI/CV 모듈을 고정 JSON 계약으로 호출

Supabase PostgreSQL
  - 차량 정보
  - 사고 기록
  - 단계형 질문 답변
  - 상황 후보
  - 체크리스트 결과

Supabase Storage
  - 사고 사진 저장

AI/CV Modules
  - session: 시간/위치 기반 사고 기록 생성
  - preprocess: 회전, 크기, 밝기, 흔들림 검사
  - vision: Cloud Vision/Gemini/YOLO/mock/replay 중 하나
  - textualize: 원본 응답을 PhotoFacts로 변환
  - state: 이벤트를 사고 기록 상태에 반영
  - safety: 긴급 후보 규칙
  - classify: 규칙 기반 상황 후보, 애매할 때만 LLM 후보
  - gaps: 요구표 기반 누락 항목 분석
  - plan: NextAction 1개 선택
  - report: 사고 기록 카드 생성
```

## Component Boundary

| Component | 책임 | 입력 | 출력 | Failure Mode | Fallback |
| --- | --- | --- | --- | --- | --- |
| Flutter App | 사용자 입력과 결과 표시 | 사용자 입력, 사진, 위치 | API 요청 | 권한 거부, 네트워크 실패 | 수동 입력, 재시도, 로컬 안내 |
| FastAPI Backend | 비즈니스 로직과 저장 연결 | API 요청 | API 응답 | DB 실패, 파일 실패 | 안전한 실패 응답 |
| Supabase DB | 구조화 데이터 저장 | 사고/차량/답변 데이터 | 조회 결과 | 연결 실패 | 재시도, 사용자 안내 |
| Supabase Storage | 사진 저장 | 이미지 파일 | storage path | 업로드 실패 | 재시도 |
| AI Rule Module | 상황 후보/체크리스트 매칭 | 질문 답변, 사진 상태 | 후보, 체크리스트 | 규칙 매칭 실패 | 기본 체크리스트 |
| CV Module | 사진 항목/품질 보조 | 이미지 | 분석 결과 | 분석 실패 | 수동 사진 항목 유지 |
| PhotoFacts Contract | 사진에서 관찰한 사실만 전달 | 비전 원본 응답, mock | PhotoFacts JSON | 항목 unknown | 사용자 질문 또는 수동 항목 유지 |
| NextAction Contract | 앱이 그릴 다음 행동 1개 선택 | 사고 상태, 누락 목록 | NextAction JSON | 결정 실패 | 기본 사진 요청 또는 기본 체크리스트 |

## Module Rules

- 모듈끼리 직접 서로 호출하지 않고 FastAPI orchestrator가 순서를 조정한다.
- 외부 서비스를 부르는 곳은 주소 변환, vision, 선택적 LLM 분류, 선택적 LLM 요약으로 제한한다.
- `preprocess`, `textualize`, `safety`, `classify` 규칙, `gaps`, `plan`은 같은 입력이면 같은 출력을 내야 한다.
- 외부 서비스 모듈은 `real`, `mock`, `replay` 구현을 같은 interface로 둔다.
- 사고 한 건의 주요 이벤트는 JSONL 형태로 재생 가능하게 남긴다. 단, 차량번호, 전화번호, 실제 위치 원문은 마스킹한다.

## Core Sequence: 사고 대응 시작부터 체크리스트까지

```text
User
  -> Flutter App: 사고 대응 시작
  -> Flutter App: 위치/시간 수집
  -> FastAPI: POST /accidents
  -> Supabase DB: accidents 저장
  -> FastAPI: accident_id 반환
  -> Flutter App: 단계형 질문 표시
  -> User: 버튼/칩 답변
  -> FastAPI: POST /accidents/{id}/triage-answers
  -> Supabase DB: triage_answers 저장
  -> AI Rule Module: situation 후보 계산
  -> Supabase DB: situation_candidates 저장
  -> Flutter App: 상황 후보 표시
  -> User: 사진 업로드
  -> FastAPI: POST /accidents/{id}/photos
  -> Preprocess: 품질 검사
  -> Supabase Storage: 이미지 저장
  -> Supabase DB: accident_photos 저장
  -> Vision/Textualize, optional: PhotoFacts 생성
  -> Gaps Module: 요구표 기반 누락 항목 계산
  -> Plan Module: NextAction 선택
  -> FastAPI: GET /accidents/{id}/checklist
  -> Flutter App: 체크리스트 표시
```

## Core Sequence: PhotoFacts 기반 사진 처리

```text
Flutter App
  -> FastAPI: POST /accidents/{id}/photos
  -> Preprocess: rotate/resize/blur/brightness
  -> FastAPI: 품질 불합격이면 다시 촬영 요청
  -> Vision Adapter: real/mock/replay 중 하나 실행
  -> Textualize Module: raw response -> PhotoFacts
  -> State Module: PhotoFacts를 사고 상태에 반영
  -> Gaps Module: 요구표에서 남은 항목 계산
  -> Plan Module: NextAction 생성
  -> Flutter App: 현재 요청 1개 표시
```

## Failure Sequence: AI/CV 실패

```text
Flutter App
  -> FastAPI: 체크리스트 요청
  -> AI/CV Module: 분석 실패
  -> FastAPI: PhotoFacts 없이 수동 사진 상태와 질문 답변으로 gaps 계산
  -> FastAPI: 기본 NextAction 또는 기본 체크리스트 fallback
  -> Flutter App: 기본 안내와 "추가 확인 필요" 표시
```

## Failure Sequence: 비전 API 불안정

```text
FastAPI
  -> Vision Adapter: timeout 또는 quota error
  -> Replay Adapter: 녹화 응답이 있으면 재생
  -> Manual Fallback: 없으면 사용자가 직접 항목을 확인하는 choice action 반환
  -> Flutter App: 수동 확인 UI 표시
```

## Failure Sequence: 위치 권한 거부

```text
Flutter App
  -> User: 위치 권한 요청
  -> User: 거부
  -> Flutter App: 수동 위치 입력 표시
  -> User: 위치 메모 입력
  -> FastAPI: POST /accidents location_source=manual
  -> Supabase DB: 사고 기록 저장
```

## Security Notes

- Flutter 앱에 server secret을 넣지 않는다.
- 모든 사진 파일명은 UUID 기반으로 저장한다.
- 로그에 차량번호, 전화번호, 위치 원문, storage path를 과도하게 남기지 않는다.
- 데모 데이터에는 실제 개인정보를 사용하지 않는다.
