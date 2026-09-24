# Development Harness Review

## 결론

현재 `development-harness`는 다른 프로젝트에서도 재사용 가능한 software delivery lifecycle harness로 정리되어 있다. 한 파일에 모든 내용을 넣지 않고, 작업 유형별로 필요한 reference만 읽도록 계층화되어 있으며, 모호한 기준을 줄이기 위한 수치 기준도 포함한다.

## 구조 검토

통과:

- `SKILL.md`는 짧은 라우터 역할만 한다.
- 세부 기준은 `references/` 아래로 분리되어 있다.
- `00_how_to_use.md`가 작업 유형별 진입점 역할을 한다.
- `15_measurable_defaults.md`가 기본 수치와 통과 기준을 제공한다.
- 프로젝트별 내용은 범용 문서가 아니라 overlay로 분리하는 구조다.
- `13_templates.md`는 복사해서 쓸 수 있는 issue, PR, ADR, test evidence, incident template을 포함한다.
- AI 기능은 일반 하네스와 분리된 `11_ai_feature_harness.md`로 관리한다.
- 현업식 단계 구분을 위해 다음 lifecycle harness를 추가했다.
  - `16_product_planning_harness.md`
  - `17_system_design_harness.md`
  - `18_implementation_harness.md`
  - `19_quality_assurance_harness.md`
  - `20_release_operations_harness.md`
- 외부 평가/시연 준비를 위해 다음 Level 2 확장팩을 추가했다.
  - `21_demo_evaluation_harness.md`
  - `22_privacy_data_harness.md`
  - `23_accessibility_usability_harness.md`
  - `24_performance_reliability_harness.md`
  - `25_evidence_pack_harness.md`

보완한 사항:

- `02_agent_roles.md`가 `SKILL.md` 라우팅에서 빠져 있던 문제를 수정했다.
- `13_templates.md`의 중첩 코드블록 렌더링 문제를 수정했다.
- 전역 Codex skill로 `C:\Users\sy7co\.codex\skills\development-harness`에 설치했다.
- 기존 구현 중심 라우팅을 product planning, system design, implementation, QA, release/operations 기준으로 재구성했다.
- 외부 평가, 발표, 사용자 테스트, 비프로덕션 시연 준비 라우팅을 추가했다.

## 검증 결과

- `PyYAML` 설치 후 공식 `quick_validate.py`를 실행했고 통과했다.

```text
Skill is valid!
```

- 추가로 다음 수동 검증을 수행했다.
  - `SKILL.md` frontmatter 확인
  - `TODO`/placeholder 잔여물 검색
  - 모든 reference가 `SKILL.md`에서 라우팅되는지 확인
  - 템플릿 코드블록 균형 확인

추가 검증:

- `TODO`, `[TODO]`, `placeholder`, `example file` 검색 결과 없음
- `SKILL.md`에서 `00`부터 `25`까지 모든 reference 라우팅 확인

## 사용 방법

다른 Codex 창에서 다음처럼 요청하면 된다.

```text
$development-harness를 기준으로 이 프로젝트를 기획, 설계, 구현, 검증, 릴리스 단계로 나눠 진행해줘.
```

또는 자연어로 다음처럼 말해도 된다.

```text
개발 하네스 기준으로 계획, 구현, 검증, 리뷰까지 진행해줘.
```

프로젝트별 특화 내용은 `07_project_overlay_template.md`를 복사해 overlay로 작성한다.
