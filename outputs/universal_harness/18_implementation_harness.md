# 18. Implementation Harness

이 문서는 코드를 어떻게 작성하고 리뷰할지 정하는 구현 하네스다. 설계 계약을 실제 코드로 옮길 때 작은 변경, 계층 분리, 검증 가능한 PR을 강제한다.

## 1. Entry Criteria

구현을 시작하려면 다음이 있어야 한다.

- 기능 목적
- acceptance criteria
- API 또는 UI 계약
- DB 변경 여부
- 테스트 계획
- 보안/개인정보 영향 여부

## 2. Required Outputs

구현 단계의 필수 산출물:

- feature branch
- code changes
- unit or integration tests, or written manual evidence
- updated docs when contracts changed
- PR with risk and validation notes

## 3. Implementation Pipeline

```text
Task slice
  -> Branch
  -> Contract check
  -> Code
  -> Local verify
  -> Self review
  -> PR
  -> Reviewer feedback
  -> Fix loop
```

## 4. Measurable Defaults

Task Size:

- 하나의 작업은 목표 1개만 가진다.
- PR은 변경 파일 15개 이하, 로직 변경 400 lines changed 이하를 목표로 한다.
- 800 lines changed를 넘으면 분할 사유를 PR에 적는다.

Code Shape:

- 함수는 40줄 이하를 목표로 한다.
- 80줄을 넘으면 분리 여부를 검토한다.
- 일반 소스 파일은 300줄 이하를 권장한다.
- 중첩 depth는 3단계 이하를 목표로 한다.

Branch and Commit:

- main에 직접 push하지 않는다.
- 브랜치는 `feature/`, `fix/`, `refactor/`, `docs/` 중 하나로 시작한다.
- 커밋 메시지는 Conventional Commits 형식을 따른다.

Layering:

- controller/router는 request/response만 담당한다.
- service는 비즈니스 로직을 담당한다.
- repository는 DB 접근만 담당한다.
- external client는 외부 API/SDK 호출만 담당한다.

## 5. Implementation Gate

다음 조건을 만족해야 PR 리뷰로 넘어간다.

- acceptance criteria를 만족한다.
- 입력 검증이 구현되었다.
- 실패 경로가 1개 이상 처리되었다.
- secret이 코드에 없다.
- 관련 문서가 갱신되었다.
- 테스트 또는 수동 검증 근거가 있다.
- 기존 핵심 흐름이 깨지지 않았음을 확인했다.

실패 시 조치:

- PR을 draft로 유지한다.
- 누락된 검증 또는 문서를 먼저 보완한다.
- 큰 PR은 작은 PR로 분리한다.

## 6. Implementation Review Questions

- 이 변경은 한 가지 목적만 가지는가
- 설계 계약을 어기지 않았는가
- 계층 경계를 넘는 코드가 있는가
- 실패했을 때 사용자가 복구할 수 있는가
- 테스트 없이 믿고 있는 로직이 있는가

