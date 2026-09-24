# 10. Observability and Incident

이 문서는 로그, 메트릭, 장애 대응 기준을 정의한다.

## 1. Observability 원칙

운영 또는 발표 중 문제가 생겼을 때 다음 질문에 답할 수 있어야 한다.

- 어떤 요청이 실패했는가
- 어느 계층에서 실패했는가
- 사용자의 입력 문제인가, 서버 문제인가, 외부 연동 문제인가
- 같은 문제가 반복되는가
- 사용자가 복구할 수 있는가

## 2. Logging

로그에 남길 것:

- request_id
- user_id 또는 익명화된 사용자 식별자
- endpoint
- status code
- error code
- 처리 시간
- 외부 API 호출 성공/실패

로그에 남기지 말 것:

- password
- access token
- refresh token
- API key
- secret
- 카드 정보
- 주민등록번호
- 민감한 원문 데이터
- 필요 이상의 위치 정보

## 3. Error Code

사용자 메시지와 내부 에러를 분리한다.

예:

```json
{
  "success": false,
  "message": "요청을 처리하지 못했습니다",
  "code": "PHOTO_UPLOAD_FAILED",
  "request_id": "req_..."
}
```

규칙:

- 사용자에게 stack trace를 보여주지 않는다.
- request_id로 서버 로그를 추적할 수 있게 한다.
- 같은 종류의 실패는 같은 error code를 사용한다.

## 4. Metrics

가능하면 다음을 측정한다.

- 요청 수
- 실패율
- 평균 응답 시간
- 외부 API 실패율
- 파일 업로드 실패율
- AI/ML fallback 발생 횟수

## 5. Incident Response

장애 발생 시 순서:

```text
1. 영향 범위 확인
2. 사용자 영향 차단 또는 완화
3. 원인 후보 분리
4. rollback 또는 feature flag off
5. 최소 수정
6. 검증
7. 재발 방지 기록
```

## 6. Incident Report Template

```text
# Incident Report

## Summary

무슨 문제가 있었는지 한 문장으로 적는다.

## Impact

누가, 얼마나, 어떤 영향을 받았는지 적는다.

## Timeline

발생, 감지, 완화, 복구 시간을 적는다.

## Root Cause

직접 원인과 근본 원인을 구분해 적는다.

## Resolution

어떻게 복구했는지 적는다.

## Prevention

재발 방지 조치를 적는다.
```

