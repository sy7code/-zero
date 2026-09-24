# 24. Performance Reliability Harness

이 문서는 시연과 평가 중 앱이 멈추거나 느려져 실패하지 않도록 성능과 안정성을 관리하는 하네스다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 적용한다.

- 네트워크 요청이 있다.
- 파일 업로드가 있다.
- AI/ML 호출이 있다.
- 외부 API를 사용한다.
- 평가자가 라이브 데모를 본다.

## 2. Required Outputs

- Performance Budget
- Reliability Scenarios
- Timeout and Retry Policy
- Fallback Matrix
- Demo Stability Checklist

## 3. Measurable Defaults

Response Time:

- 일반 화면 전환은 1초 이하를 목표로 한다.
- 일반 API는 p95 1초 이하를 목표로 한다.
- 파일 업로드는 5초 이하를 목표로 하되, 진행 상태를 표시한다.
- AI/ML 호출은 15초 timeout을 둔다.

Loading:

- 500ms 이상 걸리는 작업은 loading 상태를 표시한다.
- 3초 이상 걸리는 작업은 진행 중 메시지를 표시한다.
- 10초 이상 걸리는 작업은 취소, 재시도, fallback 중 하나를 제공한다.

Reliability:

- 핵심 데모 시나리오는 3회 연속 성공해야 한다.
- 외부 API 실패 시 기본 결과 또는 안내 메시지가 나와야 한다.
- 네트워크 실패 시 앱이 crash되면 release blocker다.

## 4. Reliability Gate

다음 조건을 만족해야 라이브 데모에 사용한다.

- 핵심 시나리오 3회 연속 성공
- 네트워크 실패 fallback 확인
- 외부 API timeout 확인
- 파일 업로드 실패 fallback 확인, 업로드 기능이 있는 경우
- AI/ML 실패 fallback 확인, AI/ML 기능이 있는 경우

실패 시 조치:

- 불안정한 기능을 feature flag로 끈다.
- demo data를 로컬/사전 저장 방식으로 준비한다.
- 라이브 호출 대신 녹화 또는 스크린샷 fallback을 사용한다.

