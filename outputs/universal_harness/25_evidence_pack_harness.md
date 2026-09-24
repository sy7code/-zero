# 25. Evidence Pack Harness

이 문서는 외부 평가자에게 제출하거나 발표 때 보여줄 증거 패키지를 구성하는 하네스다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 적용한다.

- 발표자료를 만든다.
- 평가자가 프로젝트를 검토한다.
- 데모 영상, README, 테스트 결과, 설계 문서를 제출한다.

## 2. Required Outputs

- Project Summary
- Architecture Snapshot
- Feature List
- Demo Script
- Test Evidence
- Security and Privacy Notes
- Known Issues
- Setup or Reproduction Guide
- Decision Log

## 3. Evidence Pack Structure

```text
evidence-pack/
  README.md
  architecture.md
  demo-script.md
  test-evidence.md
  security-privacy.md
  known-issues.md
  decisions.md
  screenshots/
```

## 4. Measurable Defaults

README:

- 5분 안에 프로젝트 목적, 실행 방법, 핵심 기능을 이해할 수 있어야 한다.
- 로컬 실행 명령을 포함한다.
- 환경변수 목록을 포함한다.

Architecture:

- 시스템 구성요소는 1개 다이어그램 또는 1개 텍스트 블록으로 설명한다.
- 각 구성요소의 책임을 1문장으로 적는다.

Test Evidence:

- 핵심 정상 시나리오 1개 이상
- 실패 시나리오 2개 이상
- 보안/개인정보 체크 1개 이상
- 실행 날짜와 환경 포함

Known Issues:

- 알려진 문제는 숨기지 않는다.
- 각 known issue에는 영향도, 우회 방법, 수정 계획을 적는다.

## 5. Evidence Gate

다음 조건을 만족해야 제출한다.

- README가 최신이다.
- 데모 스크립트가 있다.
- 테스트 증거가 있다.
- 실제 개인정보가 포함되지 않았다.
- known issue가 정리되어 있다.
- 평가자가 재현할 수 있는 실행 방법이 있다.

실패 시 조치:

- 제출 범위를 줄인다.
- 재현 불가능한 기능은 영상 또는 스크린샷으로 대체한다.
- 민감정보가 포함된 자료는 교체한다.

