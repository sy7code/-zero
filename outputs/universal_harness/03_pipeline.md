# 03. Pipeline

## 1. 표준 작업 파이프라인

모든 기능은 아래 파이프라인을 따른다.

```text
1. Request Intake
2. Scope and Risk Check
3. Contract First
4. Implementation
5. Local Verification
6. Integration Verification
7. Security and Privacy Review
8. Fix Loop
9. Release Readiness
10. Merge or Release
```

## 2. Request Intake

해야 할 일:

- 사용자 요청 또는 issue를 기능 단위로 정리한다.
- 완료 조건을 적는다.
- 범위 밖을 적는다.

산출물:

- 기능 설명
- 완료 조건
- 비기능 요구사항

## 3. Scope and Risk Check

해야 할 일:

- 보안, 개인정보, 외부 연동, 비용, 성능 위험을 확인한다.
- 위험한 기능은 feature flag 또는 fallback을 요구한다.

산출물:

- 위험 목록
- 완화 방안
- feature flag 필요 여부

## 4. Contract First

해야 할 일:

- 화면 입력/출력
- API request/response
- DB schema
- 외부 API timeout/retry 정책
- 에러 코드

규칙:

- 계약 없이 프론트와 백엔드가 동시에 구현하지 않는다.
- 계약 변경 시 관련 담당자에게 알려야 한다.

## 5. Implementation

해야 할 일:

- 작은 단위로 구현한다.
- 계층 구조를 지킨다.
- 입력 검증과 실패 처리를 함께 작성한다.
- 테스트 가능하게 함수 경계를 나눈다.

금지:

- router/controller에 모든 로직 작성
- secret 하드코딩
- 외부 API 결과를 무조건 신뢰
- 임시 코드를 merge

## 6. Local Verification

해야 할 일:

- formatter
- lint
- type/import check
- unit test
- local run

통과하지 못하면 통합 단계로 넘어가지 않는다.

## 7. Integration Verification

해야 할 일:

- 프론트와 백엔드 연결
- 백엔드와 DB 연결
- 외부 API mock 또는 실제 호출 검증
- 실패 경로 검증

검증 항목:

- 정상 입력
- 잘못된 입력
- 권한 없는 요청
- 외부 연동 실패
- 네트워크 실패

## 8. Security and Privacy Review

해야 할 일:

- secret scan
- 개인정보 로그 확인
- 인증/인가 확인
- 파일 업로드 검증
- 에러 응답 확인

보안 문제가 있으면 기능 완성보다 먼저 수정한다.

## 9. Fix Loop

해야 할 일:

- 재현 조건 기록
- 원인 범위 분리
- 최소 수정
- 테스트 추가 또는 갱신
- 회귀 검증

## 10. Release Readiness

해야 할 일:

- 릴리스 체크리스트 확인
- 문서 갱신
- 데모 또는 운영 시나리오 실행
- rollback 또는 fallback 준비

## 11. Merge or Release

조건:

- 모든 필수 게이트 통과
- 리뷰 승인
- 문서 갱신
- known issue 기록

