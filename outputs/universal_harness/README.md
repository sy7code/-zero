# Universal Development Harness

이 디렉터리는 앱, 웹, 백엔드, AI 기능이 포함된 대부분의 소프트웨어 프로젝트에 재사용할 수 있는 개발 하네스 템플릿이다.

하네스의 목적은 "코드를 잘 짜자"에서 끝나는 것이 아니라, 다음을 한 번에 관리하는 것이다.

- 누가 어떤 관점으로 일하는가
- 어떤 순서로 기능을 만든다
- 어떤 계약을 먼저 고정한다
- 어떤 검증을 통과해야 merge한다
- 실패하면 어떤 루프로 수정한다
- 보안과 유지보수 기준을 어디서 확인한다

## 파일 구성

- `00_how_to_use.md`: 필요한 문서만 읽기 위한 진입점과 적용 레벨
- `01_operating_model.md`: 전체 개발 운영 방식
- `02_agent_roles.md`: 서브 에이전트와 리뷰 역할
- `03_pipeline.md`: 요구사항부터 릴리스까지의 파이프라인
- `04_quality_gates.md`: 단계별 품질 게이트
- `05_security_and_supply_chain.md`: 보안, 개인정보, 의존성, 공급망 기준
- `06_review_and_fix_loop.md`: 코드 리뷰와 수정 루프
- `07_project_overlay_template.md`: 프로젝트별로 채워 넣는 오버레이 템플릿
- `08_decision_records.md`: 아키텍처 의사결정 기록 기준
- `09_testing_strategy.md`: 테스트 피라미드와 검증 전략
- `10_observability_and_incident.md`: 로그, 메트릭, 장애 대응 기준
- `11_ai_feature_harness.md`: AI 기능이 포함된 프로젝트의 추가 하네스
- `12_execution_checklists.md`: 실제 작업자가 그대로 따라가는 실행 체크리스트
- `13_templates.md`: issue, PR, ADR, test evidence 템플릿
- `14_ci_cd_blueprint.md`: CI/CD와 자동 검증 예시
- `15_measurable_defaults.md`: 모호한 표현을 줄이기 위한 기본 수치와 통과 기준
- `16_product_planning_harness.md`: 문제 정의, 사용자, MVP, 요구사항을 다루는 기획 하네스
- `17_system_design_harness.md`: 아키텍처, API, 데이터, 연동 설계를 다루는 설계 하네스
- `18_implementation_harness.md`: 코드 작성, 브랜치, 계층 분리, PR 운영을 다루는 구현 하네스
- `19_quality_assurance_harness.md`: 테스트 전략, 결함 관리, 품질 게이트를 다루는 검증 하네스
- `20_release_operations_harness.md`: 배포, 운영, 관측성, 장애 대응을 다루는 릴리스/운영 하네스
- `21_demo_evaluation_harness.md`: 외부 평가, 발표, 시연 안정성을 다루는 데모/평가 하네스
- `22_privacy_data_harness.md`: 개인정보, 데이터 최소화, 보관/삭제 기준을 다루는 데이터 보호 하네스
- `23_accessibility_usability_harness.md`: 접근성, 사용성, 모바일 시연 품질 기준을 다루는 UX 검증 하네스
- `24_performance_reliability_harness.md`: 성능 예산, 안정성, 장애 허용 기준을 다루는 성능/신뢰성 하네스
- `25_evidence_pack_harness.md`: 평가자에게 제출할 증거 패키지와 데모 자료를 다루는 문서화 하네스
- `26_project_artifacts_harness.md`: MVP, ERD, 화면 구성, 기능별 시나리오, 아키텍처 산출물 기준
- `27_research_decision_harness.md`: 자료조사, 출처 검증, 부족 정보 처리, 의사결정 근거 기준
- `28_git_safety_harness.md`: 수정 전 Git 상태 확인, 백업 브랜치, 사용자 변경 보호, rollback 기준
- `29_requirement_challenge_harness.md`: 요구사항을 비판적으로 검토하고 수용/수정/보류/거절하는 기준
- `30_failure_loop_harness.md`: 반복 실패, 무한 루프, 대안 전환, 사용자 보고 기준
- `31_collaboration_ownership_harness.md`: 개인/팀 작업 모드, 파일 소유권, 변경 권한, 리뷰 기준

## 적용 방식

새 프로젝트를 시작할 때는 이 순서로 쓴다.

1. `00_how_to_use.md`에서 현재 작업에 필요한 문서만 고른다.
2. `07_project_overlay_template.md`를 복사해서 프로젝트 전용 오버레이를 만든다.
3. 프로젝트의 기술 스택, 데이터, 외부 연동, 위험 기능을 채운다.
4. 구현 전 `03_pipeline.md`의 Foundation 단계까지 완료한다.
5. 기능별로 `04_quality_gates.md`의 게이트를 통과시킨다.
6. PR 또는 merge 전 `06_review_and_fix_loop.md`의 리뷰 기준을 확인한다.

## 참고 기준

이 하네스는 다음 공개 기준과 실무 관행을 참고해 만든다.

- NIST SSDF: secure software development practices
- OWASP SAMM: secure development lifecycle maturity model
- SLSA: software supply chain security levels
- Google Engineering Practices: code review and change author practices

## 적용 수준

작은 팀 프로젝트는 `00`, `01`, `04`, `07`, `12`, `15`와 필요한 lifecycle 파일 하나만 적용해도 충분하다.

AI, 외부 API, 개인정보, 실제 배포가 포함된 프로젝트는 `08`부터 `11`까지 함께 적용한다.

실제로 팀 운영에 바로 쓰려면 `12`부터 `14`까지를 같이 적용한다. 이 파일들은 원칙이 아니라 실행 양식과 자동화 예시를 제공한다.

모호한 표현이 나오면 `15_measurable_defaults.md`의 기본 수치를 우선 적용하고, 프로젝트 특성상 맞지 않으면 overlay에 예외와 이유를 기록한다.

현업식 단계 분리가 필요하면 `16`부터 `20`까지를 lifecycle harness로 사용한다. 이 5개 파일은 다음 책임을 가진다.

```text
16 Product Planning      -> 무엇을 왜 만들지
17 System Design         -> 어떤 구조와 계약으로 만들지
18 Implementation        -> 어떻게 코드를 만들고 리뷰할지
19 Quality Assurance     -> 무엇을 어떻게 검증할지
20 Release Operations    -> 어떻게 배포하고 운영할지
```

외부 평가, 심사, 사용자 테스트, 발표 시연처럼 실제 배포는 아니지만 남에게 보여줘야 하는 프로젝트는 `21`부터 `25`까지를 Level 2 확장팩으로 함께 적용한다.

```text
21 Demo Evaluation       -> 평가/시연 성공 기준
22 Privacy Data          -> 개인정보와 테스트 데이터 통제
23 Accessibility UX      -> 평가자가 실제로 써볼 때의 사용성
24 Performance Reliability -> 시연 중 멈추지 않는 안정성
25 Evidence Pack         -> 제출/발표용 증거 자료
```
