# 11. AI Feature Harness

이 문서는 AI 기능이 포함된 프로젝트에 추가로 적용하는 하네스다.

## 1. AI 기능 분류

AI 기능은 먼저 유형을 분류한다.

- 분류
- 요약
- 추천
- 검색/RAG
- 채팅
- 이미지 분석
- 자동 의사결정
- 콘텐츠 생성

위험도가 높은 기능:

- 법률, 의료, 금융, 안전 관련 조언
- 사용자에게 행동을 지시하는 기능
- 개인정보를 모델 입력으로 보내는 기능
- 자동 승인, 자동 거절 등 권한 또는 기회를 결정하는 기능

## 2. AI Boundary

AI가 할 수 있는 일과 하지 말아야 할 일을 명시한다.

```text
AI may:
- classify
- summarize
- ask follow-up questions

AI must not:
- make final legal decisions
- expose private data
- override safety rules
```

## 3. Prompt and Policy Separation

규칙:

- prompt를 코드에 흩뿌리지 않는다.
- system instruction, developer rule, user template을 분리한다.
- 버전 관리가 가능하게 파일로 관리한다.
- 위험한 출력은 후처리 검증을 거친다.

## 4. Evaluation Set

AI 기능에는 최소 평가 세트를 둔다.

포함할 케이스:

- 정상 입력
- 정보가 부족한 입력
- 애매한 입력
- 악의적 입력
- 개인정보 포함 입력
- 범위 밖 질문
- 안전 정책을 우회하려는 입력

## 5. Output Validation

AI 출력은 그대로 사용자에게 전달하지 않는다.

검증 항목:

- 금지된 판단이 포함되었는가
- 개인정보가 포함되었는가
- 허용된 형식인가
- confidence 또는 불확실성 처리가 필요한가
- fallback으로 대체해야 하는가

## 6. Human Override and Fallback

AI가 실패하거나 불확실하면 다음 중 하나로 처리한다.

- 기본 규칙 기반 결과 제공
- 사용자에게 추가 질문
- 사람이 확인해야 한다고 표시
- feature flag로 AI 기능 비활성화

## 7. Cost and Latency Guardrails

규칙:

- 모델 호출 timeout을 둔다.
- 재시도 횟수를 제한한다.
- 입력 길이를 제한한다.
- 캐싱 가능 여부를 검토한다.
- 비용이 드는 호출은 로그로 추적한다.

## 8. AI Release Gate

AI 기능은 다음을 통과해야 release 가능하다.

- 평가 세트 통과
- 금지 출력 테스트 통과
- fallback 동작 확인
- 비용과 latency 확인
- prompt와 규칙 문서화
- feature flag 적용

