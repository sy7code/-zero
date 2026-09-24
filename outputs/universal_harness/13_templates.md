# 13. Templates

이 문서는 프로젝트 운영에 바로 사용할 수 있는 템플릿 모음이다.

## 1. Feature Issue Template

````markdown
# Feature: 기능 이름

## Purpose

이 기능이 필요한 이유를 한 문장으로 적는다.

## Scope

### Included

- 

### Excluded

- 

## User Flow

1. 
2. 
3. 

## API Changes

- [ ] 없음
- [ ] 있음:

## DB Changes

- [ ] 없음
- [ ] 있음:

## Security/Privacy Impact

- [ ] 없음
- [ ] 있음:

## Failure Cases

- 
- 

## Acceptance Criteria

- [ ] 
- [ ] 

## Test Plan

- 
````

## 2. Bug Issue Template

````markdown
# Bug: 버그 이름

## Summary

무슨 문제가 발생했는지 한 문장으로 적는다.

## Reproduction Steps

1. 
2. 
3. 

## Expected Result


## Actual Result


## Environment

- Branch:
- Commit:
- Device/OS:
- Account/Test data:

## Impact

- [ ] 낮음
- [ ] 중간
- [ ] 높음
- [ ] 보안/개인정보 영향 있음

## Suspected Area

- [ ] Frontend
- [ ] Backend
- [ ] DB
- [ ] External API
- [ ] AI/ML
- [ ] Unknown

## Fix Verification

- [ ] 재현 시나리오가 더 이상 실패하지 않음
- [ ] 관련 정상 흐름 확인
- [ ] 회귀 테스트 추가 또는 수동 체크리스트 갱신
````

## 3. Pull Request Template

````markdown
# Summary

무엇을 바꿨는지 짧게 적는다.

## Changes

- 
- 

## Why

왜 이 변경이 필요한지 적는다.

## Risk

- [ ] 낮음
- [ ] 중간
- [ ] 높음

위험 설명:

## Security/Privacy

- [ ] secret 없음
- [ ] 개인정보 로그 없음
- [ ] 입력값 검증 있음
- [ ] 권한 확인 필요 없음
- [ ] 권한 확인 있음

## Test Evidence

실행한 테스트와 결과:

```text
여기에 명령어와 결과를 적는다.
```

## Screenshots or Demo

필요하면 첨부한다.

## Checklist

- [ ] 작은 단위 변경이다.
- [ ] 관련 없는 리팩터링을 섞지 않았다.
- [ ] 문서를 갱신했다.
- [ ] 실패 경로를 확인했다.
- [ ] feature flag가 필요한 기능은 flag를 적용했다.
````

## 4. ADR Template

````markdown
# ADR-0000: 결정 제목

## Status

Proposed | Accepted | Superseded | Deprecated

## Context

왜 결정이 필요한지 적는다.

## Decision

무엇을 선택했는지 적는다.

## Alternatives

- 대안 1:
- 대안 2:

## Consequences

### Positive

- 

### Negative

- 

### Follow-up

- 

## Review Trigger

언제 다시 검토할지 적는다.
````

## 5. Test Evidence Template

````markdown
# Test Evidence

## Target

검증 대상:

## Environment

- Branch:
- Commit:
- Backend URL:
- App version:
- Test account:

## Automated Tests

```text
명령어:
결과:
```

## Manual Scenarios

| Scenario | Result | Notes |
| --- | --- | --- |
| 정상 흐름 | Pass/Fail |  |
| 실패 흐름 | Pass/Fail |  |
| 권한 확인 | Pass/Fail |  |

## Known Issues

- 

## Decision

- [ ] Merge 가능
- [ ] 수정 후 재검증 필요
````

## 6. Incident Report Template

````markdown
# Incident Report

## Summary


## Impact


## Timeline

- Detected:
- Mitigated:
- Resolved:

## Root Cause


## Resolution


## Prevention

- 
````