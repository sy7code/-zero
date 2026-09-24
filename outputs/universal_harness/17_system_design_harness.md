# 17. System Design Harness

이 문서는 어떤 구조와 계약으로 만들지 결정하는 설계 하네스다. 병렬 구현 전에 UI, API, 데이터, 외부 연동, 보안 경계를 고정한다.

## 1. Entry Criteria

설계를 시작하려면 다음이 준비되어 있어야 한다.

- MVP scope
- 핵심 사용자 흐름
- must-have 기능 목록
- 주요 데이터 종류
- 외부 연동 후보

## 2. Required Outputs

설계 단계의 필수 산출물:

- System Context
- Component Boundary
- Data Flow
- API Contract
- Data Model
- Auth and Authorization Model
- External Integration Contract
- Failure and Fallback Policy
- Security and Privacy Notes
- ADR for major decisions

## 3. Architecture Pipeline

```text
Context and boundaries
  -> Component split
  -> Data model
  -> API contracts
  -> Auth and privacy design
  -> External integration design
  -> Failure and fallback design
  -> ADR review
```

## 4. Measurable Defaults

Component Design:

- MVP에서는 runtime component를 5개 이하로 유지한다.
- 새 component를 추가하면 책임, 입력, 출력, failure mode를 적는다.

API Contract:

- 각 endpoint는 request schema, success response, failure response를 가진다.
- 실패 응답은 `code`, `message`, `request_id`를 포함한다.
- API 변경은 프론트/백엔드 병렬 구현 전에 문서화한다.

Data Model:

- 주요 entity는 id, owner 또는 접근 범위, created_at, updated_at 필요 여부를 검토한다.
- 개인정보 필드는 저장 목적과 보관 기간을 적는다.
- user-owned resource는 owner check 방식을 명시한다.

External Integration:

- timeout, retry, fallback, rate limit, cost owner를 적는다.
- 외부 연동이 실패해도 유지해야 하는 기본 흐름을 적는다.

ADR:

- DB, auth, cloud, AI/ML model, payment, deployment, major framework 선택은 ADR 대상이다.
- ADR은 선택한 대안과 버린 대안을 최소 1개씩 적는다.

## 5. System Design Gate

다음 조건을 만족해야 구현 단계로 넘어간다.

- 시스템 구성요소와 책임이 문서화되었다.
- 핵심 API 계약이 정의되었다.
- 핵심 데이터 모델이 정의되었다.
- 인증/인가가 필요한 리소스가 표시되었다.
- 외부 연동의 timeout, retry, fallback이 정의되었다.
- 주요 기술 선택은 ADR로 기록되었다.
- 실패 시나리오 3개 이상과 대응이 적혀 있다.

실패 시 조치:

- 구현을 시작하지 않는다.
- 계약 없는 병렬 개발을 중단한다.
- 변경 위험이 큰 기술 선택은 ADR로 먼저 정리한다.

## 6. Design Review Questions

- 이 구조는 MVP에 비해 과하게 복잡하지 않은가
- 각 component의 책임이 한 문장으로 설명되는가
- 데이터 소유권과 접근 권한이 명확한가
- 외부 서비스가 실패해도 핵심 흐름이 유지되는가
- 나중에 교체 가능해야 하는 구현체가 직접 결합되어 있지 않은가

