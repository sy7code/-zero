# 21. Demo Evaluation Harness

이 문서는 외부 평가자, 교수, 심사위원, 사용자에게 프로젝트를 보여줄 때 필요한 시연/평가 하네스다. 실제 프로덕션 배포가 아니어도, 평가 환경에서 안정적으로 보여주는 것을 목표로 한다.

## 1. Entry Criteria

데모/평가 준비를 시작하려면 다음이 있어야 한다.

- 핵심 사용자 흐름 1개 이상
- 실행 가능한 앱, 웹, API, 또는 영상 데모
- 평가자가 볼 수 있는 산출물 목록
- known issue 목록

## 2. Required Outputs

- Demo Script
- Evaluation Criteria Map
- Demo Data Set
- Fallback Demo Plan
- Demo Environment Checklist
- Q&A Risk List

## 3. Demo Pipeline

```text
Evaluation goal
  -> Demo scenario
  -> Demo data
  -> Environment setup
  -> Rehearsal
  -> Failure fallback
  -> Evidence pack
```

## 4. Measurable Defaults

Demo Script:

- 핵심 데모는 5분 이하를 목표로 한다.
- 예비 설명 없이도 3분 안에 핵심 가치가 보여야 한다.
- 클릭/탭 단계는 12단계 이하를 목표로 한다.

Rehearsal:

- 발표 전 동일한 환경에서 3회 연속 성공해야 한다.
- 실패가 1회라도 발생하면 원인과 fallback을 기록한다.

Evaluation Criteria:

- 평가 기준이 있으면 각 기준에 대응하는 기능 또는 증거를 1개 이상 매핑한다.
- 평가 기준이 없으면 기능성, 완성도, 차별성, 안정성, 발표 가능성 5개 기준을 기본으로 둔다.

Fallback:

- 라이브 데모 실패에 대비해 녹화 영상 또는 스크린샷 흐름을 준비한다.
- 네트워크가 필요한 기능은 offline 설명 자료를 준비한다.

## 5. Demo Gate

다음 조건을 만족해야 외부 평가에 가져간다.

- 핵심 시나리오가 3회 연속 성공했다.
- demo data에 실제 개인정보가 없다.
- fallback demo가 준비되어 있다.
- known issue가 발표자가 설명 가능한 수준으로 정리되어 있다.
- 평가 기준과 기능 매핑이 작성되어 있다.

실패 시 조치:

- 불안정한 기능은 feature flag로 끈다.
- 라이브 데모 범위를 줄인다.
- 영상 또는 스크린샷 fallback으로 대체한다.

