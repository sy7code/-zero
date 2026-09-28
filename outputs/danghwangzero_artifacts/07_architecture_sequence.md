# 당황Zero Architecture and Sequence

## System Architecture

```text
Flutter App
  - 화면, 상태, 라우팅
  - 카메라/위치/음성 읽기/공유
  - Hive에 차량 정보, 사고 기록, 사진 메타데이터 저장
  - app documents directory에 사고 사진 파일 저장
  - NextAction을 화면 컴포넌트로 렌더링

FastAPI Backend
  - Pydantic 계약 검증
  - 사진 품질 검사, PhotoFacts 변환, NextAction 계산
  - real/mock/replay adapter 선택
  - 서버 장기 저장 없이 계산 결과 반환

Decision Core
  - safety guard
  - situation candidate rule
  - gap analysis
  - checklist selector
  - next-action planner

Vision Pipeline, optional
  - Pillow/OpenCV preprocess
  - Google Cloud Vision 후보
  - 보조 모델 후보
  - raw response -> PhotoFacts

Scenario Validation
  - PyYAML scenario
  - pytest
  - replay fixture
  - 30장 사진 시험
```

## Component Boundary

| Component | 책임 | 입력 | 출력 | Failure Mode | Fallback |
| --- | --- | --- | --- | --- | --- |
| Flutter App | 사용자 입력, 화면, 로컬 저장 | 버튼, 사진, 위치 | AccidentSnapshot, local record | 권한 거부, 기기 API 실패 | 수동 입력, 기본 체크리스트 |
| Hive Local Storage | 사용자 기기 기록 저장 | 차량/사고/사진 메타데이터 | 로컬 조회 결과 | 저장 실패, 용량 부족 | 사용자에게 저장 실패 표시 |
| FastAPI | 계산 API와 계약 검증 | AccidentSnapshot, image, replay_ref | PhotoFacts, NextAction | timeout, validation error | mock/replay/manual 결과 |
| Decision Core | 상황 후보와 다음 행동 선택 | 질문 답변, PhotoFacts, 요구표 | SituationCandidate, NextAction | 규칙 매칭 실패 | 기본 촬영 요청 또는 기본 체크리스트 |
| Vision Adapter | 사진 관찰 후보 생성 | 이미지 또는 fixture | raw response | API 실패, 비용/쿼터 초과 | replay 또는 manual PhotoFacts |
| Scenario Runner | 데모 검증 자동화 | YAML scenario | pass/fail report | fixture 누락 | 실패 케이스 기록 |

## Module Rules

- 기록의 source of truth는 Flutter 앱 로컬 저장소다.
- FastAPI는 실제 사고 기록을 장기 저장하지 않는다.
- 외부 API 호출 결과는 PhotoFacts로 정규화한 뒤에만 Decision Core로 넘긴다.
- AI/CV는 긴급도를 낮추거나 공식 판단을 대체할 수 없다.
- `PhotoFacts`의 `unknown`은 `no`가 아니다.
- 전화는 자동 실행하지 않고 사용자가 직접 버튼을 누를 때만 연결한다.
- 정식 배포 전 전화 버튼은 실제 112/119가 아니라 데모 번호로만 연결한다.
- 로그에는 request_id, module, elapsed_ms, rule_id만 남기고 번호판, 전화번호, 상세 주소 원문은 남기지 않는다.

## Core Sequence: 시작부터 사고 기록 카드까지

```text
User
  -> Flutter App: 사고 대응 시작
  -> Device APIs: 위치/시각 수집
  -> Hive: accident 생성
  -> Flutter App: 안전 확인 질문
  -> Decision Core, local or API: 긴급 후보 계산
  -> Flutter App: 전경 사진 요청
  -> User: 사진 촬영
  -> FastAPI, optional: POST /analyze/photo
  -> Vision or Replay: PhotoFacts 생성
  -> Decision Core: gaps 계산
  -> Flutter App: 쉬운 질문 또는 다음 사진 요청
  -> Hive: answers, photo_facts, action_logs 저장
  -> Flutter App: 사고 기록 카드 표시
```

## Core Sequence: AI/CV 없이 검증

```text
Scenario YAML
  -> Scenario Runner: 고정 시각/위치 주입
  -> Decision Core: NextAction 생성
  -> Mock PhotoFacts: 사진 관찰 주입
  -> Gap Analysis: 누락 항목 계산
  -> NextAction: 다음 요청 1개 반환
  -> pytest: expected action과 비교
```

## Failure Sequence: 비전 API 실패

```text
Flutter App
  -> FastAPI: 사진 분석 요청
  -> Vision Adapter: timeout 또는 quota error
  -> Replay Adapter: fixture 있으면 재생
  -> Manual Fallback: 없으면 choice action 반환
  -> Flutter App: 사용자가 직접 확인하는 버튼 UI 표시
```

## Failure Sequence: 위치 권한 거부

```text
Flutter App
  -> User: 위치 권한 요청
  -> User: 거부
  -> Flutter App: 수동 위치 입력 표시
  -> User: 위치 메모 입력
  -> Hive: location_source=manual로 사고 기록 저장
```

## Security and Privacy Notes

- 서버 secret은 Flutter 앱 bundle, asset, 설정 파일에 넣지 않는다.
- 실제 번호판, 전화번호, 상세 주소는 서버 로그와 발표 자료에서 마스킹한다.
- 외부 AI 테스트에는 실제 개인정보가 포함된 사진을 보내지 않는다.
- 데모 데이터는 모두 가짜 값으로 만든다.
- 앱 로컬 저장 데이터와 사진 파일 삭제 방법을 데모 전후에 확인한다.
