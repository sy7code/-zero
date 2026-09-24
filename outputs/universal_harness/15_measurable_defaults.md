# 15. Measurable Defaults

이 문서는 모호한 기준을 줄이기 위한 기본 수치와 통과 기준이다. 프로젝트 특성상 맞지 않으면 project overlay에 대체 기준과 이유를 적는다.

## 1. Change Size Defaults

Pull request 기본 기준:

- 목표는 1개만 가진다.
- 변경 파일은 15개 이하를 권장한다.
- 로직 변경은 400 lines changed 이하를 권장한다.
- 800 lines changed를 넘으면 분할 사유를 PR에 적는다.
- 포맷팅 변경과 로직 변경은 같은 PR에 섞지 않는다.

Commit 기본 기준:

- 커밋 하나는 한 가지 의도를 가진다.
- 커밋 메시지는 Conventional Commits 형식을 따른다.
- WIP 커밋은 merge 전 정리한다.

## 2. Code Structure Defaults

함수:

- 함수는 40줄 이하를 목표로 한다.
- 80줄을 넘으면 분리 여부를 검토하고, 유지할 경우 이유를 주석 또는 PR에 적는다.
- 매개변수는 5개 이하를 권장한다. 넘으면 request object 또는 config object를 검토한다.

파일:

- 일반 소스 파일은 300줄 이하를 권장한다.
- 500줄을 넘으면 모듈 분리를 검토한다.
- generated file, migration, fixture는 예외로 둘 수 있다.

복잡도:

- 중첩 depth는 3단계 이하를 권장한다.
- 같은 조건 분기가 3곳 이상 반복되면 공통 함수 또는 정책 객체로 분리한다.

## 3. API Defaults

응답 시간 목표:

- 일반 read API: p95 500ms 이하
- 일반 write API: p95 1000ms 이하
- 파일 업로드 API: p95 5000ms 이하
- AI/ML 호출 포함 API: timeout 15초 이하

Timeout:

- 내부 DB 요청: 3초 이하
- 외부 HTTP API: 10초 이하
- AI/ML API: 15초 이하
- 파일 업로드: 30초 이하

Retry:

- 기본 재시도 횟수는 2회 이하
- 4xx는 재시도하지 않는다.
- 429, 502, 503, 504만 재시도를 검토한다.
- 재시도에는 backoff를 둔다.

응답 형식:

- 모든 실패 응답은 `code`, `message`, `request_id`를 포함한다.
- 사용자에게 stack trace를 반환하지 않는다.

## 4. File Upload Defaults

기본 허용:

- 이미지: `jpg`, `jpeg`, `png`, `webp`
- 문서: 프로젝트에서 명시한 경우만 허용

기본 제한:

- 프로필 이미지: 5MB 이하
- 일반 이미지 업로드: 10MB 이하
- 문서 업로드: 20MB 이하
- 동영상 업로드: 별도 정책 없으면 허용하지 않는다.

검증:

- 확장자 검사
- MIME type 검사
- 파일 크기 검사
- 원본 파일명 저장 금지
- UUID 또는 hash 기반 파일명 사용

## 5. Security Defaults

Secret:

- `.env` 파일은 repository에 포함되면 실패다.
- client 앱 또는 frontend bundle에 server secret이 포함되면 실패다.
- secret 노출 의심 시 해당 키를 즉시 회전한다.

Authentication:

- 사용자 데이터 생성, 조회, 수정, 삭제 API는 기본적으로 인증을 요구한다.
- 공개 API는 overlay에 공개 사유를 적는다.

Authorization:

- 사용자 소유 리소스는 owner check를 반드시 수행한다.
- 권한 없는 접근은 `403` 또는 정책에 맞는 오류로 차단한다.

Logging:

- access token, refresh token, API key, password는 로그에 남기면 실패다.
- 개인정보 원문 로그는 기본 금지다.
- 디버깅 필요 시 마스킹하거나 request_id로 추적한다.

## 6. Test Defaults

단위 테스트:

- 순수 비즈니스 규칙은 unit test를 우선 작성한다.
- 버그 수정 시 재현 테스트를 1개 이상 추가한다. 자동화가 어렵다면 수동 회귀 체크를 기록한다.

통합 테스트:

- 핵심 API는 정상 케이스 1개, 실패 케이스 1개 이상을 가진다.
- 권한이 있는 리소스는 unauthorized 또는 forbidden 케이스를 1개 이상 가진다.

릴리스 전 smoke test:

- 핵심 사용자 흐름 1개 이상 성공해야 한다.
- 실패 흐름 2개 이상을 확인해야 한다.
- demo/release 환경에서 직접 실행해야 한다.

Coverage:

- 강제 coverage 기준이 없으면 전체 퍼센트보다 핵심 로직 테스트 유무를 우선한다.
- coverage 기준을 둔다면 line coverage 70%를 최소 시작점으로 삼는다.
- 결제, 권한, 개인정보, 안전 관련 로직은 80% 이상 또는 동등한 수동 검증 근거를 요구한다.

## 7. AI/ML Defaults

Feature flag:

- AI/ML 기능은 기본적으로 feature flag를 가진다.
- AI/ML을 꺼도 핵심 기본 흐름은 동작해야 한다.

Evaluation set:

- 최소 20개 케이스를 둔다.
- 정상 입력 5개 이상
- 애매한 입력 5개 이상
- 악의적 또는 정책 우회 입력 5개 이상
- 범위 밖 질문 3개 이상
- 개인정보 포함 입력 2개 이상

Output validation:

- 금지된 결론 또는 위험 문구가 있으면 fallback으로 대체한다.
- 모델 출력이 JSON 계약을 어기면 1회까지만 재시도하고 실패 처리한다.

Latency and cost:

- AI 호출 timeout은 기본 15초다.
- 한 사용자 요청에서 모델 호출은 기본 2회 이하로 제한한다.
- 비용이 있는 모델 호출은 request_id와 함께 호출 횟수만 기록한다. 민감한 원문 입력은 저장하지 않는다.

Human/safety fallback:

- 안전, 법률, 의료, 금융 판단은 "전문가 또는 공식 기관 확인" fallback을 둔다.
- 모델 confidence가 없거나 낮으면 확정 표현을 금지한다.

## 8. Observability Defaults

Request tracing:

- 외부 요청을 받는 API는 `request_id`를 생성하거나 전달받는다.
- 실패 응답에는 `request_id`를 포함한다.

Log level:

- 정상 요청 요약: info
- 사용자 입력 오류: warning 또는 info
- 서버 오류: error
- secret 또는 개인정보 원문 출력: 금지

Incident threshold:

- 핵심 API 5xx가 10분 동안 5회 이상이면 조사한다.
- 로그인, 결제, 데이터 저장 실패는 1회라도 재현 가능하면 우선 조사한다.
- 개인정보 노출 가능성은 즉시 incident로 분류한다.

## 9. Documentation Defaults

README 필수 항목:

- 프로젝트 목적
- 기술 스택
- 로컬 실행 방법
- 환경변수 목록
- 테스트 실행 방법
- 주요 API 또는 화면 흐름
- known issues

PR 필수 항목:

- 변경 요약
- 테스트 근거
- 보안/개인정보 영향
- rollback 또는 fallback 필요 여부

ADR 작성 기준:

- 되돌리기 어려운 기술 선택은 ADR을 작성한다.
- 클라우드, DB, 인증, AI/ML 모델, 결제, 배포 구조 선택은 ADR 대상이다.

