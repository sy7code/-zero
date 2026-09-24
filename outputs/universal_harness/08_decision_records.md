# 08. Decision Records

이 문서는 프로젝트에서 중요한 기술 결정을 기록하는 기준이다. 의사결정 기록은 나중에 "왜 이렇게 만들었는지"를 추적하기 위한 장치다.

## 1. ADR이 필요한 경우

ADR, Architecture Decision Record는 다음 상황에서 작성한다.

- 주요 기술 스택을 선택할 때
- DB나 저장소를 선택할 때
- 외부 API나 클라우드 서비스를 도입할 때
- 인증 방식을 선택할 때
- AI/ML 모델 또는 규칙 기반 방식을 선택할 때
- 비용, 보안, 성능에 큰 영향을 주는 결정을 할 때
- 되돌리기 어려운 구조 변경을 할 때

## 2. ADR 형식

```text
# ADR-0001: 결정 제목

## Status

Proposed | Accepted | Superseded | Deprecated

## Context

어떤 문제나 제약 때문에 결정이 필요한지 적는다.

## Decision

무엇을 선택했는지 적는다.

## Alternatives

검토한 다른 선택지를 적는다.

## Consequences

좋아지는 점, 나빠지는 점, 나중에 감수해야 할 비용을 적는다.

## Review Date

다시 검토할 날짜나 조건을 적는다.
```

## 3. 작성 원칙

- 결정의 정답을 포장하지 않는다.
- 선택하지 않은 대안도 기록한다.
- 장점만 쓰지 않고 단점과 비용을 함께 적는다.
- 결정이 바뀌면 기존 ADR을 지우지 않고 새 ADR로 대체한다.

## 4. 예시

```text
# ADR-0001: 백엔드 프레임워크로 FastAPI를 사용한다

## Status

Accepted

## Context

프로젝트에 이미지 처리와 AI 연동이 포함되어 Python 생태계와의 연결이 중요하다.

## Decision

백엔드는 FastAPI를 사용한다.

## Alternatives

- Spring Boot
- Firebase Functions

## Consequences

AI/CV 연동은 쉬워진다. 대규모 엔터프라이즈 기능은 Spring Boot보다 직접 구성해야 할 수 있다.

## Review Date

MVP 이후 운영 배포가 필요할 때 재검토한다.
```
