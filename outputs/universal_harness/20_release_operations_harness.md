# 20. Release Operations Harness

이 문서는 배포, 발표, 운영, 장애 대응을 관리하는 릴리스/운영 하네스다. 코드가 완성된 뒤 실제 환경에서 안전하게 굴러가게 하는 기준을 다룬다.

## 1. Entry Criteria

릴리스 준비를 시작하려면 다음이 있어야 한다.

- QA gate 통과 기록
- release candidate 또는 demo build
- 환경변수 목록
- known issue 목록
- rollback 또는 fallback 방법

## 2. Required Outputs

릴리스/운영 단계의 필수 산출물:

- Release Checklist
- Deployment Plan
- Smoke Test Result
- Rollback Plan
- Monitoring and Log Plan
- Incident Response Path
- Post-release Review

## 3. Release Pipeline

```text
Release candidate
  -> Environment check
  -> Build
  -> Deploy
  -> Smoke test
  -> Monitor
  -> Rollback or proceed
  -> Post-release review
```

## 4. Measurable Defaults

Environment:

- 필수 환경변수는 `.env.example` 또는 배포 플랫폼 secret 목록에 있어야 한다.
- production secret은 repository에 없어야 한다.

Smoke Test:

- health check 1개 이상
- 핵심 사용자 흐름 1개 이상
- write path 1개 이상, 저장 기능이 있는 경우
- auth path 1개 이상, 인증 기능이 있는 경우

Monitoring:

- API 실패 응답은 request_id를 포함한다.
- 핵심 API 5xx가 10분 동안 5회 이상이면 조사한다.
- 개인정보 노출 가능성은 1회 의심만으로 incident로 분류한다.

Rollback:

- feature flag가 있는 기능은 rollback보다 flag off를 먼저 검토한다.
- DB migration은 rollback 또는 forward-fix 방법을 문서화한다.
- 배포 후 smoke test 실패 시 이전 안정 버전으로 되돌린다.

## 5. Release Gate

다음 조건을 만족해야 릴리스한다.

- QA gate를 통과했다.
- S0/S1 bug가 0개다.
- 환경변수와 secret이 확인되었다.
- smoke test 시나리오가 준비되었다.
- rollback 또는 feature flag off 경로가 있다.
- README 또는 운영 문서가 최신이다.

실패 시 조치:

- release를 중단한다.
- 불안정 기능은 feature flag로 끈다.
- 안정적인 최소 흐름만 배포 또는 발표한다.

## 6. Post-release Gate

릴리스 후 다음을 확인한다.

- health check 성공
- 핵심 시나리오 성공
- error log 확인
- 외부 API 실패율 확인
- 사용자 피드백 또는 데모 이슈 기록

## 7. Incident Response

장애 발생 시 순서:

```text
Impact 확인
  -> 사용자 영향 완화
  -> 원인 후보 분리
  -> rollback 또는 flag off
  -> 최소 수정
  -> 검증
  -> incident report
```

Incident report는 `13_templates.md`의 양식을 사용한다.

