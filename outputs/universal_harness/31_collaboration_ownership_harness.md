# 31. Collaboration Ownership Harness

이 문서는 개인 작업과 공동 작업을 구분하고, 팀 프로젝트에서 파일 소유권, 변경 권한, 리뷰, 충돌 처리 기준을 정하는 하네스다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 적용한다.

- 프로젝트에 2명 이상이 참여한다.
- 역할이 프론트, 백엔드, AI, CV, 디자인, 문서 등으로 나뉘어 있다.
- 같은 repository에서 여러 명이 작업한다.
- 다른 사람이 만든 파일을 수정해야 한다.
- merge conflict 가능성이 있다.

## 2. Work Mode

작업 시작 전에 mode를 정한다.

Solo Mode:

- 혼자 작업한다.
- 모든 파일을 수정할 수 있지만, 변경 범위와 rollback은 기록한다.
- 큰 변경 전 backup branch를 만든다.

Team Mode:

- 여러 명이 작업한다.
- 파일/모듈 소유권을 존중한다.
- 자기 담당 범위 밖 변경은 사전 합의 또는 리뷰를 거친다.
- main에 직접 push하지 않는다.

## 3. Ownership Rules

팀 프로젝트에서는 `OWNERS` 또는 문서로 담당 영역을 정한다.

예:

```text
frontend/       -> Frontend owner
backend/        -> Backend owner
ai/             -> AI owner
cv/             -> CV owner
database/       -> Backend/Data owner
docs/           -> PM or shared
```

규칙:

- owner가 있는 파일은 owner 리뷰 없이 큰 수정하지 않는다.
- 긴급 수정이 아니면 담당자에게 변경 의도를 먼저 알린다.
- shared 파일은 수정 전 영향 범위를 확인한다.
- 설정 파일, lockfile, schema, API contract는 cross-owner review 대상이다.

## 4. Change Permission Levels

### Level A: Free Change

조건:

- 본인 담당 파일
- 문서 오타
- 테스트 데이터
- 작은 UI 문구

요구:

- self review
- commit message 명확히 작성

### Level B: Notify Before Change

조건:

- 다른 파트와 연결된 API contract
- shared type/model
- 공통 utility
- README 실행 방법
- 테스트 fixture

요구:

- 담당자에게 변경 의도 공유
- PR 설명에 영향 범위 작성

### Level C: Approval Required

조건:

- DB schema
- auth/permission
- deployment config
- package/dependency
- lockfile
- public API breaking change
- shared architecture
- 다른 팀원의 담당 파일 대규모 수정

요구:

- owner 승인
- migration/rollback 계획
- 관련 담당자 리뷰

## 5. Branch and PR Rules for Team Mode

규칙:

- main에 직접 push하지 않는다.
- 기능별 branch를 사용한다.
- PR은 한 가지 목표만 가진다.
- cross-owner 변경은 해당 owner를 reviewer로 지정한다.
- merge 전 conflict를 해결하고 테스트 근거를 남긴다.

브랜치 예시:

```text
feature/frontend-triage-flow
feature/backend-accident-api
feature/ai-checklist-rules
fix/photo-upload-retry
docs/demo-plan
```

## 6. Conflict Rules

충돌 발생 시:

1. 충돌 파일 owner를 확인한다.
2. 내 변경과 상대 변경을 구분한다.
3. 상대 변경을 임의로 삭제하지 않는다.
4. 의도가 불명확하면 owner에게 확인한다.
5. 해결 후 관련 테스트를 실행한다.

금지:

- conflict 해결을 위해 상대 코드를 통째로 삭제
- lockfile conflict를 내용 이해 없이 덮어쓰기
- schema conflict를 임의로 한쪽 선택
- generated file로 수동 변경 덮어쓰기

## 7. Communication Rules

다음 변경은 사전 공유한다.

- API request/response 변경
- DB schema 변경
- 화면 흐름 변경
- 공통 타입 변경
- dependency 추가/삭제
- feature flag 변경
- 데모 시나리오 변경

공유 형식:

```text
변경하려는 것:
이유:
영향 받는 파트:
필요한 리뷰어:
완료 예상:
```

## 8. Team Gate

팀 프로젝트에서 구현을 시작하기 전 다음을 정한다.

- work mode: Solo 또는 Team
- 역할별 owner
- shared file 목록
- approval required 변경 목록
- branch naming 규칙
- PR review 규칙

실패 시 조치:

- 구현을 시작하지 않는다.
- 최소 owner 표를 먼저 만든다.
- shared contract 변경부터 합의한다.

