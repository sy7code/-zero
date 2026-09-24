# 06. Review and Fix Loop

## 1. Code Review Standard

코드 리뷰의 목적은 단순히 버그를 찾는 것이 아니라 코드베이스의 장기 건강성을 높이는 것이다.

리뷰 기준:

- correctness
- readability
- maintainability
- security
- testability
- performance where relevant
- consistency with local conventions

## 2. Review Checklist

기능 리뷰:

- 요구사항을 충족하는가
- 범위 밖 기능이 들어가지 않았는가
- 정상 경로와 실패 경로가 있는가
- 사용자 메시지가 안전하고 이해 가능한가

구조 리뷰:

- 책임이 분리되어 있는가
- 함수와 클래스가 너무 많은 일을 하지 않는가
- 중복이 과도하지 않은가
- 새 기능 추가 시 기존 코드를 과하게 수정하지 않아도 되는가

보안 리뷰:

- secret이 없는가
- 입력 검증이 있는가
- 권한 검사가 있는가
- 로그에 민감정보가 없는가
- 에러 응답이 안전한가

테스트 리뷰:

- 핵심 로직 테스트가 있는가
- 실패 경로 테스트가 있는가
- 외부 연동은 mock 또는 fallback으로 검증되는가
- 수동 검증 결과가 기록되었는가

## 3. Change Size Rules

좋은 변경:

- 하나의 목적을 가진다.
- 리뷰 가능한 크기다.
- 테스트와 문서 갱신을 포함한다.
- 위험한 변경은 feature flag를 둔다.

피해야 할 변경:

- 리팩터링과 기능 추가를 한 PR에 섞는다.
- 관련 없는 파일을 많이 수정한다.
- 대량 포맷팅과 로직 변경을 섞는다.
- 임시 디버그 코드를 포함한다.

## 4. Fix Loop

문제가 발견되면 다음 순서를 따른다.

```text
1. Reproduce
2. Isolate
3. Minimize
4. Patch
5. Verify
6. Prevent Regression
7. Document
```

### Reproduce

- 재현 조건을 기록한다.
- 입력값, 환경, 계정, 브랜치, commit을 적는다.

### Isolate

- 프론트 문제인지, 백엔드 문제인지, DB 문제인지, 외부 연동 문제인지 분리한다.

### Minimize

- 문제와 관련 없는 리팩터링을 하지 않는다.
- 수정 범위를 줄인다.

### Patch

- 가장 작은 안전한 수정부터 적용한다.
- 보안 문제는 우선순위를 높인다.

### Verify

- 원래 문제를 다시 실행한다.
- 관련 정상 흐름도 다시 확인한다.

### Prevent Regression

- 가능하면 테스트를 추가한다.
- 자동화가 어렵다면 수동 체크리스트를 추가한다.

### Document

- 원인과 수정 내용을 기록한다.
- known issue 또는 README가 필요하면 갱신한다.

## 5. Merge Criteria

merge 조건:

- 관련 테스트 통과
- lint 또는 analyze 통과
- 보안 체크 통과
- 리뷰 승인
- 문서 갱신
- feature flag 필요 시 적용

