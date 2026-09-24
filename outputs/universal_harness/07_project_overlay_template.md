# 07. Project Overlay Template

이 파일은 프로젝트별로 채워 넣는 오버레이 템플릿이다. 범용 하네스는 그대로 두고, 프로젝트 특화 내용만 이 파일에 적는다.

## 1. Project Summary

프로젝트 이름:

한 줄 목표:

주 사용자:

핵심 사용자 흐름:

## 2. Tech Stack

Frontend:

Backend:

Database:

Storage:

Auth:

AI/ML:

Deployment:

## 3. Architecture

```text
여기에 프로젝트 구조를 적는다.
```

## 4. MVP Scope

포함:

- 

제외:

- 

## 5. Data Classification

민감정보:

- 

개인정보:

- 

일반 데이터:

- 

저장하지 않을 데이터:

- 

## 6. External Integrations

외부 서비스:

- 

각 서비스별 확인 항목:

- 인증 방식
- timeout
- retry
- fallback
- 비용
- rate limit

## 7. Feature Flags

```text
ENABLE_EXPERIMENTAL_FEATURE=false
```

## 8. API Contracts

주요 API:

```text
METHOD /path
request:
response:
error:
```

## 9. Database Contracts

주요 테이블:

- 

마이그레이션 주의사항:

- 

## 10. Test Scenarios

정상 시나리오:

- 

실패 시나리오:

- 

권한 시나리오:

- 

## 11. Release Checklist

- README 최신화
- 환경변수 확인
- 테스트 통과
- 보안 체크 통과
- 데모 또는 운영 시나리오 확인
- rollback 또는 fallback 확인

