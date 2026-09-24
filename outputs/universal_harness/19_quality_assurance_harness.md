# 19. Quality Assurance Harness

이 문서는 만든 것이 제대로 작동하는지 검증하는 QA 하네스다. 정상 흐름뿐 아니라 실패 흐름, 회귀, 보안, 성능 기준을 확인한다.

## 1. Entry Criteria

QA를 시작하려면 다음이 있어야 한다.

- acceptance criteria
- 테스트 가능한 빌드 또는 실행 환경
- 핵심 사용자 시나리오
- known risk 목록

## 2. Required Outputs

QA 단계의 필수 산출물:

- Test Plan
- Test Cases
- Test Evidence
- Bug List
- Regression Checklist
- Release Blocker Status

## 3. QA Pipeline

```text
Test planning
  -> Requirement challenge
  -> Unit and integration checks
  -> Manual scenario checks
  -> Failure-path checks
  -> Security checks
  -> Regression checks
  -> Bug triage
  -> Quality report
```

## 4. Measurable Defaults

Test Coverage by Risk:

- 핵심 비즈니스 규칙은 unit test 1개 이상을 가진다.
- 핵심 API는 정상 케이스 1개, 실패 케이스 1개 이상을 가진다.
- 권한이 있는 리소스는 unauthorized 또는 forbidden 케이스 1개 이상을 가진다.
- 버그 수정은 재현 테스트 1개 이상을 추가한다. 자동화가 어렵다면 수동 회귀 체크를 기록한다.

Manual Test:

- 릴리스 전 핵심 사용자 흐름 1개 이상을 실제 환경에서 실행한다.
- 실패 흐름 2개 이상을 확인한다.
- 테스트 계정과 테스트 데이터를 기록한다.

Requirement Challenge:

- must-have 기능마다 "이 기능이 없어도 핵심 데모가 가능한가"를 확인한다.
- 요구사항마다 검증 가능한 acceptance criteria가 있어야 한다.
- 출처 없는 사실을 전제로 한 요구사항은 `가정`으로 표시한다.
- 사용자에게 위험한 판단을 하게 만드는 요구사항은 대안을 제시한다.
- 구현 비용이 큰 요구사항은 더 작은 MVP 대안을 1개 이상 적는다.

Bug Severity:

- S0: 데이터 손실, 보안/개인정보 노출, 서비스 전체 불능
- S1: 핵심 흐름 불능, 인증/결제/저장 실패
- S2: 주요 기능 일부 실패, 우회 가능
- S3: UI/문구/비핵심 문제

Release Rule:

- S0, S1은 0개여야 release 가능하다.
- S2는 owner가 승인한 known issue일 때만 허용한다.

## 5. QA Gate

다음 조건을 만족해야 릴리스 단계로 넘어간다.

- 요구사항이 목표, 범위, 위험 기준으로 검토되었다.
- acceptance criteria가 모두 검증되었다.
- 핵심 정상 흐름이 성공했다.
- 실패 흐름 2개 이상이 검증되었다.
- S0/S1 bug가 0개다.
- 보안/개인정보 영향 항목이 확인되었다.
- test evidence가 남아 있다.

실패 시 조치:

- release blocker를 등록한다.
- 원인 영역을 분리한다.
- 수정 후 회귀 테스트를 다시 수행한다.

## 6. QA Review Questions

- 이 요구사항은 구현할 가치가 있는 요구사항인가
- 요구사항을 더 작고 안전하게 바꿀 수 있는가
- 사용자가 실제로 수행하는 흐름을 검증했는가
- 실패 경로가 문서가 아니라 실제로 실행되었는가
- 보안/권한 테스트가 포함되었는가
- 수정한 버그가 다시 생기지 않도록 회귀 항목이 추가되었는가
- 릴리스 가능한 known issue와 blocker가 분리되었는가
