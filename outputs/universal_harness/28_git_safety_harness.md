# 28. Git Safety Harness

이 문서는 코드 수정 전후의 Git 안전 기준을 정의한다. 목적은 사용자 변경사항을 보호하고, 큰 수정 전 복구 지점을 만들고, 실패했을 때 되돌아갈 수 있는 경로를 확보하는 것이다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 이 하네스를 적용한다.

- 코드 파일을 수정한다.
- 여러 파일을 한 번에 바꾼다.
- 리팩터링, 마이그레이션, 구조 변경을 한다.
- 생성된 코드를 기존 코드베이스에 통합한다.
- 실패 시 되돌려야 할 가능성이 있다.

## 2. Required Checks Before Editing

수정 전 반드시 확인한다.

```text
git status
git branch --show-current
git diff --stat
```

확인할 것:

- 현재 브랜치
- uncommitted changes
- 내가 만들지 않은 변경사항
- 수정 대상 파일의 기존 diff
- 작업 범위 밖 변경사항

## 3. User Change Protection

규칙:

- 사용자가 만든 변경사항을 임의로 되돌리지 않는다.
- 작업 범위 밖 파일은 수정하지 않는다.
- 이미 수정된 파일을 건드려야 하면 먼저 diff를 읽고 기존 변경의 의도를 파악한다.
- 충돌이 있으면 내 변경을 최소화하고 사용자 변경을 보존한다.
- `git reset --hard`, `git checkout --`, `git restore .`는 명시 요청 없이 사용하지 않는다.

## 4. Backup Strategy

작업 위험도에 따라 백업 방식을 다르게 쓴다.

### Small Change

대상:

- 파일 1개에서 3개
- 로직 변경 100 lines 이하
- 되돌리기 쉬운 수정

필수:

- `git status`
- `git diff`

백업:

- 별도 백업 커밋은 선택

### Medium Change

대상:

- 파일 4개에서 15개
- 로직 변경 100에서 400 lines
- 여러 계층을 건드리는 기능 추가

필수:

- 작업 브랜치 사용
- 수정 전 diff 확인
- 기능 단위 커밋

권장 백업:

```text
git switch -c feature/<work-name>
```

또는 이미 브랜치가 있으면:

```text
git branch backup/<work-name>-before
```

### High-risk Change

대상:

- 15개 초과 파일
- 400 lines 초과 로직 변경
- DB migration
- auth/permission 변경
- 파일 삭제/이동
- 대규모 리팩터링

필수 백업:

```text
git branch backup/<work-name>-before
```

또는 사용자가 요청한 경우:

```text
git tag backup-<work-name>-before
```

추가 기준:

- 변경을 여러 PR 또는 여러 커밋으로 분할한다.
- rollback 방법을 PR 또는 작업 노트에 적는다.
- migration은 forward-fix와 rollback 중 하나를 문서화한다.

## 5. Commit Strategy

커밋 기준:

- 커밋 하나는 한 가지 의도를 가진다.
- 포맷팅 변경과 로직 변경은 분리한다.
- 테스트 추가와 구현 변경은 같은 기능 단위 안에서는 함께 둘 수 있다.
- WIP 커밋은 merge 전 정리한다.

커밋 메시지:

```text
feat: 사고 기록 생성 API 추가
fix: 사진 업로드 실패 처리
refactor: 체크리스트 매칭 로직 분리
docs: 데모 시나리오 문서 추가
test: 사고 기록 생성 테스트 추가
```

## 6. Post-edit Verification

수정 후 확인한다.

```text
git diff --stat
git diff
```

확인할 것:

- 의도한 파일만 바뀌었는가
- secret이나 개인정보가 들어가지 않았는가
- 생성 파일, 빌드 산출물, 캐시 파일이 섞이지 않았는가
- 포맷팅 변경이 과도하지 않은가

## 7. Rollback Rules

문제가 생겼을 때:

1. 어떤 변경이 문제인지 diff로 확인한다.
2. 관련 파일만 되돌린다.
3. 사용자 변경사항은 보존한다.
4. backup branch/tag가 있으면 비교 기준으로 사용한다.
5. destructive command는 사용자 명시 요청 없이는 사용하지 않는다.

금지:

```text
git reset --hard
git checkout -- .
git restore .
```

사용자가 명시적으로 요청한 경우에만 사용할 수 있다.

## 8. Git Safety Gate

다음 조건을 만족해야 큰 수정을 시작한다.

- 현재 브랜치를 확인했다.
- uncommitted changes를 확인했다.
- 사용자 변경사항을 파악했다.
- medium 이상 변경은 작업 브랜치 또는 backup branch가 있다.
- high-risk 변경은 rollback 방법이 있다.

실패 시 조치:

- 수정을 시작하지 않는다.
- 사용자에게 branch/backup 필요성을 알린다.
- 변경 범위를 줄인다.

