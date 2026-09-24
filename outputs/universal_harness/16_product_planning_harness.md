# 16. Product Planning Harness

이 문서는 무엇을 왜 만들지 결정하는 기획 하네스다. 구현 방법을 정하기 전에 문제, 사용자, 범위, 성공 기준을 고정한다.

## 1. Entry Criteria

기획을 시작하려면 다음 정보가 최소한 있어야 한다.

- 문제 또는 기회가 한 문장으로 적혀 있다.
- 예상 사용자가 1개 이상 정의되어 있다.
- 프로젝트 제약이 1개 이상 적혀 있다. 예: 기간, 팀원 수, 비용, 플랫폼

정보가 없으면 먼저 discovery 질문을 3개 이하로 정리한다.

## 2. Required Outputs

기획 단계의 필수 산출물:

- Problem Statement
- Target Users
- User Jobs and Pain Points
- Current Alternatives
- Value Proposition
- MVP Scope
- Out of Scope
- User Flow
- Functional Requirements
- Non-functional Requirements
- Acceptance Criteria
- Success Metrics
- Product Risks

## 3. Product Planning Pipeline

```text
Problem framing
  -> User and context definition
  -> Alternative and competitor review
  -> Value proposition
  -> MVP slicing
  -> Requirement writing
  -> Acceptance criteria
  -> Risk and out-of-scope review
```

## 4. Measurable Defaults

Problem Statement:

- 1문장, 30단어 이하를 목표로 한다.
- 사용자, 상황, 문제를 포함해야 한다.

Target Users:

- MVP에서는 primary user 1개, secondary user 최대 2개만 둔다.
- 각 user에는 목표와 pain point를 각각 1개 이상 적는다.

MVP Scope:

- 핵심 사용자 흐름은 7단계 이하로 작성한다.
- MVP 기능은 must-have 5개 이하를 목표로 한다.
- nice-to-have는 MVP 밖으로 분리한다.

Requirements:

- 기능 요구사항은 `사용자는 ...할 수 있다` 형식으로 쓴다.
- 각 요구사항은 acceptance criteria 1개 이상을 가진다.
- acceptance criteria는 관찰 가능한 결과로 쓴다.

Success Metrics:

- 정량 지표 1개 이상, 정성 기준 1개 이상을 둔다.
- 학생/프로토타입 프로젝트는 운영 지표 대신 데모 성공 기준을 사용할 수 있다.

## 5. Product Gate

다음 조건을 만족해야 설계 단계로 넘어간다.

- 문제 정의가 1문장으로 고정되었다.
- primary user가 1개 이상 정의되었다.
- MVP 포함 기능과 제외 기능이 분리되었다.
- 핵심 사용자 흐름이 7단계 이하로 설명된다.
- 각 must-have 기능에 acceptance criteria가 있다.
- 성공 기준이 최소 2개 있다.
- 가장 큰 제품 리스크 3개와 완화 방안이 적혀 있다.

실패 시 조치:

- MVP 기능 수를 줄인다.
- 사용자 유형을 줄인다.
- 검증 불가능한 요구사항을 다시 작성한다.

## 6. Product Review Questions

- 이 기능이 실제 사용자 문제와 직접 연결되는가
- 지금 만들지 않아도 되는 기능이 MVP에 들어갔는가
- 발표나 사용자 테스트에서 3분 안에 가치가 설명되는가
- 성공과 실패를 구분할 기준이 있는가
- 위험하거나 오해될 수 있는 약속을 하고 있지 않은가

