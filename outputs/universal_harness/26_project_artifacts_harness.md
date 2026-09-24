# 26. Project Artifacts Harness

이 문서는 구현 전에 만들어야 하는 프로젝트 산출물의 기준을 정의한다. MVP, ERD, 화면 구성, 기능별 시나리오, 아키텍처처럼 평가자와 개발자가 함께 보는 산출물을 빠짐없이 만든다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 이 하네스를 적용한다.

- 팀 프로젝트를 시작한다.
- 구현 전에 범위와 구조를 확정해야 한다.
- 발표, 평가, 심사, 리뷰를 위해 산출물을 제출한다.
- 여러 명이 프론트, 백엔드, AI, 데이터 작업을 나눠 맡는다.

## 2. Required Artifacts

구현 전에 최소 다음 산출물을 만든다.

- MVP Scope
- Feature List
- User Flow
- Screen Map
- Screen-by-Screen Specification
- Feature Scenario
- API List
- ERD
- Data Dictionary
- System Architecture
- Sequence Flow for Core Scenario
- Risk and Out-of-Scope List

## 3. MVP Scope

MVP 문서는 다음을 포함한다.

- 한 줄 목표
- primary user 1개
- must-have 기능 5개 이하
- should-have 기능 5개 이하
- MVP 제외 기능
- 데모 성공 기준 2개 이상

MVP Gate:

- must-have 없이 핵심 데모가 불가능한 기능만 must-have에 둔다.
- nice-to-have는 구현 일정에 넣지 않는다.
- 제외 기능이 최소 3개 이상 적혀 있다.

## 4. Screen Map

화면 구성 문서는 다음 형식으로 작성한다.

```text
화면명:
목적:
진입 경로:
주요 UI:
사용자 입력:
호출 API:
성공 상태:
실패 상태:
다음 화면:
```

기본 기준:

- MVP 화면은 8개 이하를 목표로 한다.
- 각 화면은 목적을 1문장으로 설명한다.
- 각 화면에는 로딩, 실패, 빈 상태 필요 여부를 표시한다.
- 모바일 앱은 최소 360px 너비 기준으로 깨지지 않아야 한다.

## 5. Feature Scenario

기능별 시나리오는 다음 형식으로 작성한다.

```text
기능명:
사용자 목표:
선행 조건:
정상 흐름:
실패 흐름:
저장 데이터:
관련 화면:
관련 API:
완료 기준:
```

기본 기준:

- must-have 기능마다 정상 시나리오 1개 이상을 작성한다.
- must-have 기능마다 실패 시나리오 1개 이상을 작성한다.
- 개인정보 또는 파일 업로드 기능은 보안 시나리오 1개 이상을 작성한다.

## 6. ERD and Data Dictionary

ERD는 다음을 포함한다.

- entity 이름
- primary key
- foreign key
- 주요 field
- 관계 cardinality
- user-owned resource 여부

Data Dictionary는 다음을 포함한다.

```text
테이블:
컬럼:
타입:
필수 여부:
예시 값:
분류: Public | Internal | Personal | Sensitive | Secret
저장 목적:
보관 기간:
```

기본 기준:

- 모든 테이블은 owner 또는 접근 범위를 명시한다.
- 개인정보 필드는 분류와 저장 목적을 적는다.
- demo data에는 실제 개인정보 0개를 요구한다.

## 7. Architecture Artifact

아키텍처 문서는 다음을 포함한다.

- 시스템 구성요소
- 각 구성요소 책임
- 데이터 흐름
- 외부 연동
- 인증/인가 위치
- 실패 시 fallback

기본 기준:

- MVP runtime component는 5개 이하를 목표로 한다.
- 각 component는 책임을 1문장으로 설명한다.
- 외부 연동은 timeout, retry, fallback을 적는다.

## 8. Core Sequence Flow

핵심 시나리오 1개 이상에 대해 sequence flow를 작성한다.

```text
User
  -> Frontend
  -> Backend
  -> Database/Storage
  -> Optional AI/CV
  -> Backend
  -> Frontend
```

기본 기준:

- 핵심 데모 시나리오 1개는 반드시 sequence flow를 가진다.
- 실패 흐름 1개 이상도 간단히 작성한다.

## 9. Artifact Gate

다음 조건을 만족해야 구현을 시작한다.

- MVP scope가 작성되었다.
- 화면별 명세가 작성되었다.
- must-have 기능별 시나리오가 작성되었다.
- ERD와 data dictionary 초안이 작성되었다.
- 시스템 아키텍처가 작성되었다.
- 핵심 sequence flow가 작성되었다.
- out-of-scope가 작성되었다.

실패 시 조치:

- 구현을 시작하지 않는다.
- 빠진 산출물을 최소 초안 수준으로 작성한다.
- 범위가 큰 경우 MVP 기능 수를 줄인다.

