# 당황Zero 구현 전 확정 문서

## 1. 프로젝트 한 줄 정의

당황Zero는 사용자가 평소에 차량과 연락처 등 기본 정보를 등록해두고, 사고 발생 시 앱이 단계별 질문과 쉬운 UI 입력을 통해 현재 상황을 유추하며 필요한 사진, 위치, 시간, 사고 상황을 빠뜨리지 않고 기록하도록 돕는 모바일 앱이다.

## 2. 핵심 원칙

- 사고 판단 앱이 아니라 초기 대응 보조 앱으로 만든다.
- 과실비율, 법적 책임, 보험금, 사고 원인 판단은 하지 않는다.
- AI는 분석, 상황 후보 분류, 정리, 재질문까지만 담당한다.
- 최종 안내 문구는 AI가 자유 생성하지 않고 체크리스트 DB에서 가져온다.
- CV는 확정 판단이 아니라 사진 항목 확인과 보조 탐지만 담당한다.
- MVP는 AI/CV 모델에 의존하지 않고도 단계형 질문과 규칙 기반 유추로 끝까지 동작해야 한다.
- 사진 분석 결과는 `PhotoFacts`라는 고정 형식으로 다음 단계에 전달한다.
- 앱이 보여줄 다음 행동은 `NextAction`이라는 고정 형식 1개로 전달한다.
- 실제 비전 API가 없어도 mock/replay로 핵심 흐름을 검증할 수 있어야 한다.

## 3. MVP 범위

### 포함

- 차량 정보 사전 등록
- 보험사, 긴급 연락처, 운전자 기본 정보 사전 등록
- 사고 대응 시작
- 현재 위치와 시간 저장
- 사고 유형 직접 선택이 아닌 단계형 상황 파악
- 버튼, 체크박스, 카드형 질문을 통한 사고 상황 유추
- 안전 확인 우선 흐름
- 사진 촬영 또는 업로드
- 필수 사진 항목 체크
- 누락 사진 항목 안내
- PhotoFacts/NextAction 기반 mock 검증
- 사고 유형별 체크리스트 추천
- 사고 기록 요약
- 데모용 사고 기록 조회

### 제외

- 과실비율 판단
- 법적 책임 판단
- 보험금 판단
- 112/119 신고 대체
- 보험사 공식 접수 대체
- 경찰/보험사 실시간 연동
- 번호판 자동 인식 확정 저장
- 파손 여부 확정 판단
- React/Web 전제 디버그 화면
- 특정 비전 API 필수 의존

## 4. 최종 데모 시나리오

최종 데모는 5분 이하로 구성한다. 앱 조작만으로 3분 안에 핵심 가치가 보여야 한다.

### 데모 스토리

경미한 접촉사고가 발생했고, 사용자는 당황한 상태에서 본인이 어떤 상황인지 정확히 판단하기 어렵다. 당황Zero는 사용자가 미리 등록한 차량/보험/연락처 정보를 불러오고, 사고 직후에는 쉬운 질문과 버튼형 UI로 현재 상태를 파악하며, 위치와 시간을 저장하고 필요한 사진을 순서대로 안내한다. 앱은 입력된 정보와 사진 항목을 바탕으로 상황을 유추한 뒤 초기 대응 체크리스트와 사고 요약을 보여준다.

### 라이브 데모 흐름

1. 앱 실행
2. `사고 대응 시작` 선택
3. 등록된 내 차량/보험/긴급 연락처 정보 자동 불러오기
4. 위치/시간 자동 저장 확인
5. 앱의 첫 질문에 버튼으로 응답
   - 다친 사람이 있나요?
   - 차량이 움직일 수 있나요?
   - 상대 차량이 있나요?
   - 시설물이 파손되었나요?
6. 앱이 `접촉사고 가능성 높음`처럼 상황 후보를 표시
7. 사진 항목 화면 진입
8. 전체 현장, 파손 부위, 번호판 사진 중 일부 업로드
9. 누락 항목 표시 확인
10. 체크리스트 추천 결과 확인
11. 사고 요약 화면 확인
12. 기록 저장 완료 확인

### 예비 데모

라이브 데모 실패에 대비해 다음을 준비한다.

- 2분 이내 시연 영상
- 주요 화면 스크린샷
- 데모용 더미 사고 데이터
- 네트워크 실패 시 보여줄 로컬 결과 화면
- mock PhotoFacts 기반 자동 모드
- 미리 저장한 비전 응답 replay 모드

### 데모 성공 기준

- 핵심 시나리오 3회 연속 성공
- 실제 개인정보 0개
- 앱 crash 0회
- 네트워크 실패 시 fallback 화면 표시
- 발표자가 known issue를 설명 가능

## 5. 추천 기술 스택

### 프론트엔드

- Flutter
- Dart
- `camera` 또는 `image_picker`
- `geolocator`
- `dio` 또는 `http`
- `shared_preferences` 또는 `flutter_secure_storage`

선택 이유:

- 모바일 앱 데모에 적합하다.
- 카메라, 위치, 권한 처리 구현이 쉽다.
- Android APK 시연이 가능하다.

### 백엔드

- FastAPI
- Python
- Pydantic
- Uvicorn

선택 이유:

- AI/CV 모듈과 Python 생태계가 잘 맞는다.
- Swagger 문서가 자동 생성된다.
- MVP API 구현 속도가 빠르다.

### DB/Storage

- Supabase PostgreSQL
- Supabase Storage

선택 이유:

- 사고 기록은 관계형 데이터로 관리하기 좋다.
- 사진은 Storage에 저장하고 DB에는 path만 저장할 수 있다.
- 무료 범위 MVP에 적합하다.

### AI

MVP:

- Python 규칙 기반 케이스 매칭
- 체크리스트 DB
- 사고 유형별 조건 로직

고도화:

- OpenAI API 또는 Gemini API
- 사고 요약
- 누락 정보 재질문
- 사용자 입력 구조화

### CV

MVP:

- 수동 사진 항목 체크
- 사진 업로드 상태 관리
- PhotoFacts mock 입력

고도화:

- OpenCV 품질 검사
- Google Cloud Vision 후보 실험
- Gemini 기반 PhotoFacts 보완, 선택
- YOLO pretrained 객체 탐지
- 차량, 사람, 신호등, 표지판 탐지

보류:

- 파손 부위 학습 모델
- 번호판 OCR 확정 저장
- YOLO fine-tuning

## 6. 시스템 구조

```text
Flutter App
  -> FastAPI Backend
      -> Supabase PostgreSQL
      -> Supabase Storage
      -> AI Rule Module
      -> CV Validation Module
      -> PhotoFacts / NextAction Contracts
```

AI/CV는 별도 서버로 시작하지 않는다. 백엔드 내부 모듈로 두고, 나중에 필요할 때만 분리한다.

핵심 모듈은 다음처럼 나눈다.

```text
session -> preprocess -> vision(optional) -> textualize(PhotoFacts)
        -> state -> safety -> classify -> gaps -> plan(NextAction) -> report
```

## 7. 4명 역할 분담

## 7.1 프론트엔드 담당

### 책임

- Flutter 앱 화면 구현
- 사용자 입력 흐름 구현
- 카메라/사진 업로드 UI
- 위치/시간 표시
- 체크리스트 결과 화면
- 사고 요약 화면

### 구현 기능

- 홈 화면
- 차량 정보 등록 화면
- 사고 시작 화면
- 단계형 상황 파악 화면
- 사진 항목 촬영 화면
- 누락 항목 표시 화면
- 체크리스트 결과 화면
- 사고 요약 화면

### 사용 기술

- Flutter
- Dart
- `camera` 또는 `image_picker`
- `geolocator`
- `dio`
- `flutter_secure_storage`, 선택

### 완료 기준

- 핵심 데모 흐름을 3분 이내 완료
- 위치 권한 거부 시 수동 입력 가능
- 사진 업로드 실패 시 재시도 가능
- 로딩, 실패, 빈 상태 화면 존재
- 사고 유형을 사용자가 처음부터 직접 고르지 않아도 진행 가능
- 질문은 채팅창보다 버튼, 칩, 체크박스, 카드형 UI를 우선 사용

## 7.2 백엔드/DB 담당

### 책임

- FastAPI 서버 구현
- API 계약 관리
- Supabase DB/Storage 연동
- 사고 기록 저장
- 사진 path 저장
- AI/CV 모듈 호출 연결

### 구현 기능

- 차량 정보 등록 API
- 사고 기록 생성 API
- 사진 업로드 API
- 체크리스트 조회 API
- 사고 요약 조회 API
- 데모 데이터 초기화 API, 선택

### 사용 기술

- Python
- FastAPI
- Pydantic
- Supabase Python client
- PostgreSQL
- Supabase Storage

### 완료 기준

- Swagger에서 주요 API 확인 가능
- 실패 응답에 `code`, `message`, `request_id` 포함
- 이미지 파일 확장자, MIME type, 크기 검증
- secret이 코드에 없음
- 개인정보가 로그에 남지 않음

## 7.3 AI 담당

### 책임

- 사고 유형별 규칙 설계
- 체크리스트 DB 설계
- 사고 상황 분석/후보 분류/정리
- 누락 정보 재질문
- 사고 요약 생성

### 구현 기능

- 단계형 입력 기반 사고 상황 유추 로직
- 사고 유형 후보 분류 로직
- 긴급도 후보 분류 로직
- 체크리스트 매칭 로직
- 사고 요약 생성 로직
- 부족한 정보 질문 생성

### 사용 기술

- Python
- 규칙 기반 로직
- JSON 또는 DB 기반 체크리스트
- OpenAI API 또는 Gemini API, 선택

### 완료 기준

- AI 없이도 규칙 기반 추천 동작
- 안내 문구는 체크리스트 DB에서만 제공
- 법적 판단, 과실비율, 보험금 판단 없음
- AI 기능은 feature flag로 끌 수 있음
- 상황은 단정하지 않고 `가능성 높음`, `추가 확인 필요`로 표현

## 7.4 CV 담당

### 책임

- 사진 항목 분류 구조 설계
- 필수 사진 누락 체크
- 이미지 품질 검사
- 선택적 객체 탐지 데모

### 구현 기능

- 사진 항목 상태 관리
- 필수 사진 누락 판단
- 흐림/어두움 검사, 선택
- YOLO pretrained 객체 탐지, 선택

### 사용 기술

- Python
- OpenCV
- Ultralytics YOLO, 선택
- Google Colab, 선택

### 완료 기준

- 모델 없이도 사진 항목 누락 체크 가능
- CV 실패 시 기본 체크리스트 흐름 유지
- CV 결과는 확정 표현 금지
- 객체 탐지는 고도화 기능으로 분리

## 8. 구현 단계와 기간

아래 기간은 6주 기준이다. 학기 일정이 짧으면 1, 2단계를 합치고 AI/CV 고도화를 줄인다.

## 8.1 1주차: 기획/계약 확정

목표:

- 구현 전에 범위와 계약을 고정한다.

작업:

- MVP 범위 확정
- 화면 흐름 확정
- 사고 직후 단계형 질문 흐름 확정
- PhotoFacts/NextAction JSON 계약 확정
- 요구표와 지식베이스 초안 작성
- mock 시나리오 12개 초안 작성
- API 목록 확정
- DB 테이블 초안 작성
- 체크리스트 항목 초안 작성
- 데모 시나리오 확정

산출물:

- 화면 흐름도
- 상황 유추 질문 플로우
- API 계약 초안
- DB schema 초안
- 체크리스트 초안
- 데이터 계약 문서
- mock/replay 시나리오 초안
- 역할별 task list

Gate:

- 핵심 흐름이 7단계 이하로 설명됨
- must-have 기능 5개 이하로 정리됨
- 제외 기능 명시됨
- mock PhotoFacts만으로 핵심 흐름을 설명할 수 있음

## 8.2 2주차: 프로젝트 골격 구축

목표:

- 앱, 서버, DB가 최소 연결된다.

작업:

- Flutter 프로젝트 생성
- FastAPI 프로젝트 생성
- Supabase 프로젝트 생성
- `.env.example` 작성
- health check API 구현
- 앱에서 health check 호출
- 기본 테이블 생성

산출물:

- 실행 가능한 앱
- 실행 가능한 백엔드
- Supabase 연결
- README 실행 방법

Gate:

- 앱에서 백엔드 호출 성공
- 백엔드에서 DB 연결 성공
- secret이 코드에 없음

## 8.3 3주차: 최소 동작 흐름 완성

목표:

- AI/CV 없이도 사고 기록 흐름이 끝까지 동작하고, mock PhotoFacts로 누락 분석까지 검증한다.

작업:

- 차량 정보 등록
- 사고 기록 생성
- 위치/시간 저장
- 단계형 질문 응답 저장
- 규칙 기반 상황 후보 유추
- PhotoFacts mock 저장
- NextAction 반환
- 사진 업로드
- 사진 path 저장
- 기본 체크리스트 반환

산출물:

- end-to-end vertical slice
- mock 시나리오 실행 결과

Gate:

- 사고 시작부터 체크리스트 화면까지 동작
- 사진 업로드 실패 시 재시도 가능
- 위치 권한 거부 시 수동 입력 가능
- 핵심 mock 시나리오 8개 이상 통과

## 8.4 4주차: AI/CV 기본 기능 추가

목표:

- 규칙 기반 추천, 사진 누락 체크, 선택적 사진 품질 검사를 붙인다.

작업:

- 사고 유형별 규칙 구현
- 체크리스트 DB 정리
- 단계형 질문에 따른 상황 후보 점수화
- 사고 요약 생성
- 누락 정보 재질문
- 사진 항목 누락 체크
- OpenCV 품질 검사, 선택
- 비전 후보 30장 시험, 선택
- replay 응답 저장, 선택

산출물:

- AI rule module
- CV validation module
- PhotoFacts 변환 규칙 초안
- replay fixture, 선택

Gate:

- AI/CV 실패 시 기본 체크리스트 반환
- 법적 판단 문구 없음
- CV 확정 판단 없음
- 비전 API 실패 시 replay 또는 수동 확인 fallback

## 8.5 5주차: 데모 안정화와 테스트

목표:

- 외부 평가용으로 안정화한다.

작업:

- 오류/빈 상태/로딩 상태 보완
- API 실패 fallback 보완
- 데모 데이터 생성
- 주요 실패 시나리오 테스트
- 개인정보 로그 확인
- README 갱신

산출물:

- test evidence
- demo data
- known issue list

Gate:

- 핵심 시나리오 3회 연속 성공
- 실패 시나리오 2개 이상 확인
- 실제 개인정보 0개

## 8.6 6주차: 발표/평가 패키지 완성

목표:

- 평가자가 이해하고 재현할 수 있게 만든다.

작업:

- 데모 영상 준비
- 스크린샷 준비
- 아키텍처 요약 작성
- 기능 목록 작성
- known issue 정리
- 발표 Q&A 준비

산출물:

- evidence pack
- demo video
- presentation-ready demo

Gate:

- 라이브 데모 fallback 준비
- README 최신화
- 평가 기준과 기능 매핑 완료

## 9. 구현 전 반드시 정할 것

### 제품 결정

- 최종 사고 유형: 접촉사고, 시설물 파손
- 긴급 상황 처리 문구
- 체크리스트 출처
- 데모 시나리오 1개
- 범위 밖 기능

### 화면/UX 결정

- 홈 화면 구성
- 차량 정보 입력 항목
- 사고 직후 첫 질문 항목
- 버튼/칩/체크박스/카드형 입력 컴포넌트
- 채팅 UI를 사용할 조건
- 사진 항목 목록
- 체크리스트 결과 화면 구성
- 사고 요약 화면 구성

### API 결정

```text
GET /health
POST /vehicles
GET /vehicles
POST /accidents
POST /accidents/{accident_id}/triage-answers
GET /accidents/{accident_id}/situation
GET /accidents/{accident_id}
POST /accidents/{accident_id}/photos
POST /accidents/{accident_id}/photo-facts
GET /accidents/{accident_id}/next-action
GET /accidents/{accident_id}/checklist
GET /accidents/{accident_id}/summary
```

### DB 결정

예상 테이블:

- `vehicles`
- `accidents`
- `triage_questions`
- `triage_answers`
- `situation_candidates`
- `accident_photos`
- `photo_facts`
- `checklist_items`
- `checklist_results`
- `accident_type_rules`
- `action_logs`

### 보안/데이터 결정

- 데모 데이터는 전부 가짜 데이터 사용
- 실제 차량번호, 전화번호, 실제 사고 사진 금지
- 사진 파일명은 UUID 사용
- 로그에 차량번호, 전화번호, 위치 원문 출력 금지
- `.env`는 Git에 올리지 않음

### AI/CV 결정

- AI/CV는 기본 흐름의 필수 의존성이 아니다.
- AI summary, AI follow-up, CV analysis, YOLO detection은 feature flag로 분리한다.
- 모델 성능이 부족하면 단계형 질문과 규칙 기반 상황 후보만 보여준다.
- 사용자가 사고 유형을 처음부터 직접 선택하는 방식은 보조/수정 기능으로만 둔다.

추천 feature flags:

```text
ENABLE_AI_SUMMARY=false
ENABLE_AI_FOLLOWUP=false
ENABLE_CV_ANALYSIS=false
ENABLE_CLOUD_VISION=false
ENABLE_GEMINI_PHOTOFACTS=false
ENABLE_YOLO_DETECTION=false
ENABLE_DIRECT_ACCIDENT_TYPE_SELECT=false
```

## 9.1 사고 직후 상황 유추 UX

### UX 원칙

- 사용자가 사고 유형을 먼저 고르지 않게 한다.
- 채팅보다 버튼, 칩, 체크박스, 카드형 질문을 우선한다.
- 한 화면에 질문은 1개에서 3개까지만 보여준다.
- 각 질문은 5초 안에 답할 수 있어야 한다.
- 사용자가 모르면 `잘 모르겠음`을 선택할 수 있어야 한다.
- 앱은 단정하지 않고 상황 후보와 필요한 다음 행동을 보여준다.

### 첫 질문 세트

1. 다친 사람이 있나요?
   - 있음
   - 없음
   - 잘 모르겠음

2. 차량을 움직일 수 있나요?
   - 가능
   - 불가능
   - 위험해서 판단 어려움

3. 상대 차량이 있나요?
   - 있음
   - 없음
   - 모르겠음

4. 도로 시설물이나 구조물이 파손되었나요?
   - 있음
   - 없음
   - 잘 모르겠음

5. 현장이 위험한가요?
   - 2차 사고 위험 있음
   - 통행 방해 있음
   - 비교적 안전함

### 상황 후보 예시

- 인명 피해 가능성 있음
- 경미한 접촉사고 가능성 높음
- 시설물 파손 사고 가능성 높음
- 단독 사고 가능성 있음
- 긴급 신고 후 기록 필요 상황

### 상황 유추 방식

MVP에서는 점수 기반 규칙을 사용한다.

```text
상대 차량 있음 + 파손 부위 있음 -> 접촉사고 후보 +2
시설물 파손 있음 -> 시설물 파손 후보 +3
다친 사람 있음 또는 잘 모르겠음 -> 긴급 확인 후보 +3
차량 이동 불가 -> 위험 상황 후보 +2
```

가장 높은 후보를 `가능성 높음`으로 보여주고, 동점이면 추가 질문을 한다.

## 10. 체크리스트 초안

### 접촉사고 체크리스트

- 안전한 장소 확보
- 인명 피해 여부 확인
- 112/119 신고 필요 여부 확인
- 전체 현장 사진 촬영
- 양쪽 차량 번호판 촬영
- 파손 부위 촬영
- 신호등, 표지판, 차선 등 주변 환경 촬영
- 사고 위치와 시간 기록
- 보험사 연락

### 시설물 파손 체크리스트

- 인명 피해 여부 확인
- 추가 사고 위험 여부 확인
- 파손 시설물 전체 사진 촬영
- 세부 파손 부위 촬영
- 위치와 시간 기록
- 주변 표지판 또는 관리 주체 정보 촬영
- 경찰 또는 시설 관리자 신고 필요 여부 확인
- 보험사 연락

## 11. 테스트 시나리오

정상:

- 접촉사고 기록 생성
- 시설물 파손 기록 생성
- 사진 업로드 후 체크리스트 조회
- 사고 요약 조회

실패:

- 위치 권한 거부
- 사진 업로드 실패
- 잘못된 파일 업로드
- AI/CV 비활성화
- 네트워크 오류

보안/개인정보:

- `.env` Git 제외 확인
- 로그 개인정보 확인
- 데모 데이터 실제 개인정보 0개 확인

## 12. 최종 데모 평가 기준

- 기능성: 사고 기록 흐름이 끝까지 동작한다.
- 완성도: 앱 화면이 모바일에서 깨지지 않는다.
- 차별성: 일반 AI 챗봇과 달리 구조화된 사고 대응 흐름을 제공한다.
- 안정성: 핵심 데모 3회 연속 성공한다.
- 안전성: AI/CV가 위험한 확정 판단을 하지 않는다.
- 설명력: 3분 안에 문제와 해결 흐름이 설명된다.

## 13. 우선순위

### Must Have

1. 사고 기록 생성
2. 위치/시간 저장
3. 사진 업로드
4. 체크리스트 추천
5. 사고 요약

### Should Have

1. 사진 항목 누락 체크
2. 차량 정보 사전 등록
3. 누락 정보 재질문
4. 데모 데이터 초기화

### Could Have

1. OpenCV 사진 품질 검사
2. LLM 요약
3. YOLO pretrained 탐지

### Won't Have for MVP

1. 과실비율 판단
2. 보험사 실시간 연동
3. 경찰 시스템 연동
4. 파손 모델 직접 학습
5. 번호판 OCR 확정 저장
