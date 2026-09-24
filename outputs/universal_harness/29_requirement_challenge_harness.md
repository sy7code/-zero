# 29. Requirement Challenge Harness

이 문서는 요구사항을 무조건 수용하지 않고, 구현 전에 비판적으로 검토하기 위한 하네스다. 목적은 사용자의 의도를 무시하는 것이 아니라, 목표에 맞지 않거나 위험하거나 검증 불가능한 요구사항을 더 안전하고 작은 형태로 바꾸는 것이다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 적용한다.

- 새로운 기능 요구사항이 추가된다.
- MVP 범위가 커진다.
- 사용자가 원하는 기능이 안전, 개인정보, 법률, 비용, 일정 위험을 만든다.
- 요구사항이 모호하거나 검증 기준이 없다.
- 요구사항의 근거가 출처 없는 추정이다.

## 2. Required Outputs

- Requirement Statement
- User Goal
- Risk Review
- Acceptance Criteria
- Smaller Alternative
- Decision: Accept | Modify | Defer | Reject
- Reason

## 3. Challenge Questions

각 요구사항마다 다음을 확인한다.

- 어떤 사용자 문제를 해결하는가
- MVP 데모에 반드시 필요한가
- 없으면 핵심 흐름이 깨지는가
- 검증 가능한 완료 기준이 있는가
- 더 작은 기능으로 같은 가치를 보여줄 수 있는가
- 개인정보, 보안, 안전, 법률 위험이 있는가
- 출처나 테스트 근거가 필요한가
- 실패했을 때 fallback이 있는가

## 4. Decision Labels

Accept:

- MVP 목표에 직접 필요하다.
- 위험이 낮거나 통제 가능하다.
- acceptance criteria가 명확하다.

Modify:

- 방향은 맞지만 범위, 표현, UX, 안전 기준을 조정해야 한다.

Defer:

- 좋은 기능이지만 MVP 또는 현재 일정에는 과하다.
- should-have 또는 could-have로 이동한다.

Reject:

- 프로젝트 목표와 맞지 않는다.
- 위험이 크고 완화가 어렵다.
- 공식 판단이나 법적 책임 같은 금지 영역에 해당한다.

## 5. Measurable Defaults

- must-have 기능은 5개 이하를 유지한다.
- 한 요구사항은 acceptance criteria 1개 이상을 가진다.
- high-risk 요구사항은 fallback 1개 이상을 가진다.
- 출처가 필요한 요구사항은 source 1개 이상을 가진다.
- 구현 기간이 1주를 넘는 요구사항은 더 작은 대안 1개 이상을 제시한다.

## 6. Requirement Challenge Gate

다음 조건을 만족해야 요구사항을 구현한다.

- 요구사항의 사용자 목표가 적혀 있다.
- acceptance criteria가 있다.
- 위험과 fallback이 검토되었다.
- source 또는 assumption이 구분되어 있다.
- Accept 또는 Modify 결정이 내려졌다.

실패 시 조치:

- 요구사항을 보류한다.
- 사용자에게 부족한 정보를 질문한다.
- 더 작은 대안을 제시한다.
- 위험한 요구사항은 MVP 밖으로 이동한다.

