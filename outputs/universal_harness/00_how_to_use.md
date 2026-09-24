# 00. How To Use This Harness

이 문서는 하네스를 한 번에 전부 읽지 않기 위한 진입점이다. 현재 작업에 필요한 파일만 읽고 적용한다.

## 1. 기본 규칙

- 모든 문서를 한 번에 읽지 않는다.
- 현재 작업 유형에 필요한 문서만 읽는다.
- 프로젝트별 예외는 overlay에 기록한다.
- 모호한 기준은 `15_measurable_defaults.md`의 기본 수치를 따른다.
- 기본 수치를 바꾸려면 이유와 대체 기준을 overlay에 적는다.

## 2. 작업 유형별 읽을 파일

### 새 프로젝트 시작

필수:

- `31_collaboration_ownership_harness.md`
- `27_research_decision_harness.md`
- `29_requirement_challenge_harness.md`
- `01_operating_model.md`
- `16_product_planning_harness.md`
- `17_system_design_harness.md`
- `26_project_artifacts_harness.md`
- `03_pipeline.md`
- `04_quality_gates.md`
- `07_project_overlay_template.md`
- `15_measurable_defaults.md`

선택:

- AI 기능 있음: `11_ai_feature_harness.md`
- 외부 API/배포 있음: `05_security_and_supply_chain.md`, `14_ci_cd_blueprint.md`

### 기능 하나 추가

필수:

- `31_collaboration_ownership_harness.md`
- `29_requirement_challenge_harness.md`
- `30_failure_loop_harness.md`
- `28_git_safety_harness.md`
- `18_implementation_harness.md`
- `03_pipeline.md`
- `04_quality_gates.md`
- `06_review_and_fix_loop.md`
- `12_execution_checklists.md`
- `15_measurable_defaults.md`

선택:

- 외부 자료 기반 결정 있음: `27_research_decision_harness.md`
- DB 변경 있음: `05_security_and_supply_chain.md`
- AI 기능 있음: `11_ai_feature_harness.md`
- 주요 기술 결정 있음: `08_decision_records.md`

### 버그 수정

필수:

- `30_failure_loop_harness.md`
- `28_git_safety_harness.md`
- `19_quality_assurance_harness.md`
- `06_review_and_fix_loop.md`
- `09_testing_strategy.md`
- `12_execution_checklists.md`

선택:

- 장애 또는 사용자 영향 있음: `10_observability_and_incident.md`

### 보안/개인정보 영향 변경

필수:

- `27_research_decision_harness.md`
- `05_security_and_supply_chain.md`
- `04_quality_gates.md`
- `12_execution_checklists.md`
- `15_measurable_defaults.md`

선택:

- 외부 모델 또는 AI 사용: `11_ai_feature_harness.md`

### 릴리스 또는 발표 전

필수:

- `20_release_operations_harness.md`
- `21_demo_evaluation_harness.md`
- `25_evidence_pack_harness.md`
- `04_quality_gates.md`
- `09_testing_strategy.md`
- `10_observability_and_incident.md`
- `12_execution_checklists.md`
- `14_ci_cd_blueprint.md`

선택:

- 개인정보 또는 실제 사용자 데이터 있음: `22_privacy_data_harness.md`
- 앱/웹을 직접 써보게 함: `23_accessibility_usability_harness.md`
- 네트워크/AI/업로드 등 실패 위험 있음: `24_performance_reliability_harness.md`

### 외부 평가 또는 시연 준비

필수:

- `27_research_decision_harness.md`
- `26_project_artifacts_harness.md`
- `21_demo_evaluation_harness.md`
- `22_privacy_data_harness.md`
- `23_accessibility_usability_harness.md`
- `24_performance_reliability_harness.md`
- `25_evidence_pack_harness.md`

선택:

- AI 기능 있음: `11_ai_feature_harness.md`
- 실제 배포 있음: `20_release_operations_harness.md`

## 3. 적용 레벨

### Level 1: Small Project

대상:

- 팀 프로젝트
- MVP
- 내부 데모
- 실제 사용자가 적은 서비스

필수 파일:

- `01`
- `16`
- `18`
- `03`
- `04`
- `06`
- `07`
- `12`
- `15`

### Level 2: Product Prototype

대상:

- 외부 사용자 테스트
- 개인정보 저장
- 외부 API 사용
- 배포 환경 있음
- 외부 평가자에게 시연 또는 제출

필수 파일:

- Level 1 전체
- `05`
- `08`
- `09`
- `10`
- `13`
- `14`
- `17`
- `19`
- `20`
- `21`
- `22`
- `23`
- `24`
- `25`
- `27`

### Level 3: AI or Safety-Critical Prototype

대상:

- AI 응답이 사용자 행동에 영향을 줌
- 의료, 금융, 법률, 안전 관련 조언
- 이미지/문서/개인정보가 모델 입력으로 들어감

필수 파일:

- Level 2 전체
- `11`

## 4. Lifecycle Harness Map

현업식으로 프로젝트를 나눌 때는 다음 기준을 사용한다.

| 단계 | 목적 | 필수 산출물 | 다음 단계 진입 조건 |
| --- | --- | --- | --- |
| Product Planning | 무엇을 왜 만들지 결정 | PRD, MVP scope, acceptance criteria | MVP와 범위 밖 항목이 승인됨 |
| System Design | 구조와 계약 결정 | architecture brief, API contract, data model, ADR | UI/API/DB 계약이 변경 추적 가능함 |
| Implementation | 코드 작성과 리뷰 | PR, implementation notes, test evidence | PR gate 통과 |
| Quality Assurance | 기능/회귀/보안 검증 | test plan, bug list, quality report | release blocker 0개 |
| Release Operations | 배포와 운영 | release checklist, rollback plan, incident path | smoke test 통과 |
| Demo Evaluation | 외부 평가와 시연 | demo script, scoring map, fallback demo | 평가 시나리오 3회 연속 성공 |
| Privacy Data | 데이터 보호 | data inventory, retention rule, demo data | 실제 개인정보 0개 |
| Accessibility UX | 사용성 검증 | usability checklist, device matrix | 핵심 흐름 3분 이내 완료 |
| Performance Reliability | 안정성 검증 | performance budget, reliability tests | demo blocker 0개 |
| Evidence Pack | 제출 증거 | README, screenshots, test evidence, decision log | 평가자가 재현 가능 |
| Research Decision | 자료 기반 의사결정 | source list, assumptions, missing info, decision record | 출처와 가정이 구분됨 |
| Requirement Challenge | 요구사항 비판 검토 | risk review, smaller alternative, decision label | Accept 또는 Modify 결정 |
| Collaboration Ownership | 공동 작업 통제 | owner map, change permission, PR review rule | owner와 승인 기준 확정 |

단계별 상세 기준은 `16`부터 `20`까지의 파일을 읽는다.

외부 평가가 있으면 `21`부터 `25`까지도 읽는다.

## 5. 문서 작성 원칙

하네스와 프로젝트 규칙 문서를 작성할 때 다음 원칙을 따른다.

- "적절히", "충분히", "가능하면", "잘" 같은 표현만 쓰지 않는다.
- 기본값, 수치, 통과 조건, 실패 시 조치를 함께 쓴다.
- 한 파일에 모든 내용을 넣지 않는다.
- 자주 보는 실행 체크리스트와 드물게 보는 배경 원칙을 분리한다.
- 프로젝트별 내용은 범용 문서에 넣지 않고 overlay에 넣는다.
- 예외는 "무엇을 바꾸는지"와 "왜 바꾸는지"를 같이 적는다.
