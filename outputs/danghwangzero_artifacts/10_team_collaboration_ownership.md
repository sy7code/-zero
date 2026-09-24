# 당황Zero Team Collaboration and Ownership

이 문서는 4명이 함께 작업할 때 각 파트의 소유권과 변경 권한을 정한다. 목적은 다른 사람의 작업을 임의로 덮어쓰지 않고, API/DB/화면 계약 변경을 안전하게 공유하는 것이다.

## 1. Work Mode

당황Zero는 Team Mode로 진행한다.

규칙:

- main 브랜치에 직접 push하지 않는다.
- 기능별 브랜치를 사용한다.
- 담당 영역 밖의 큰 수정은 owner에게 먼저 알린다.
- API, DB, 공통 타입, feature flag 변경은 관련 담당자 리뷰를 받는다.

## 2. Ownership Map

| 영역 | Owner | 주요 책임 |
| --- | --- | --- |
| Flutter app | 프론트엔드 담당 | 화면, 상태, 위치/카메라, API 연동 |
| FastAPI backend | 백엔드 담당 | API, service, repository, validation |
| Supabase schema/storage | 백엔드 담당 | DB, Storage, migration, access rule |
| AI rule module | AI 담당 | 상황 후보 유추, 체크리스트 매칭, 요약/재질문 |
| CV validation module | CV 담당 | 사진 항목 상태, 품질 검사, PhotoFacts 후보 생성, 선택적 객체 탐지 |
| API contract | 프론트 + 백엔드 | request/response 합의 |
| Data contracts | AI + CV + 백엔드 | PhotoFacts, NextAction, scenario YAML 합의 |
| Demo scenario | 전원 | 발표 흐름, 데모 데이터, fallback |
| Evidence docs | 전원, PM 역할 | README, 테스트 근거, known issue |

## 2.1 실제 팀원 배정표

구현 시작 전에는 아래 표를 팀원 실제 이름으로 채운다. 이름이 확정되기 전에는 `팀원 A/B/C/D`로 두되, 각자의 숙련도와 백업 담당은 반드시 적는다.

| 역할 | 실제 담당자 | 숙련도 기준 | 주요 산출물 | 백업 담당 | 구현 전 확인 |
| --- | --- | --- | --- | --- | --- |
| 프론트엔드 | 미정 | Flutter 또는 모바일 UI 구현 가능 | 화면 구현, 상태 관리, 권한 처리, API 연동 | 미정 | Android 실행 환경, 카메라/위치 권한 테스트 가능 여부 |
| 백엔드/DB | 미정 | Python API와 DB CRUD 구현 가능 | FastAPI, Supabase schema, Storage 연동, API 문서 | 미정 | Supabase 프로젝트 접근 권한, `.env` 관리 방식 |
| AI 규칙/요약 | 미정 | Python 로직, JSON rule 설계 가능 | 상황 후보 점수화, 체크리스트 매칭, 요약/재질문 | 미정 | AI API 사용 여부, feature flag 기본값 |
| CV/사진 검증 | 미정 | OpenCV 또는 이미지 처리 기초 가능 | 사진 항목 누락 체크, 이미지 품질 검사, PhotoFacts 변환, 비전 후보 실험 | 미정 | 모델 없이 동작하는 fallback 범위 |
| PM/통합 관리 | 미정 | 일정/문서/발표 흐름 정리 가능 | 데모 시나리오, evidence pack, 일정표, 최종 발표 자료 | 미정 | 최종 발표일, 중간 점검일, 평가 방식 |

배정 원칙:

- Flutter 경험자가 있으면 프론트엔드에 우선 배정한다.
- Python 경험자가 있으면 백엔드 또는 AI에 우선 배정한다.
- CV 경험자가 없으면 CV 담당은 `사진 항목 누락 체크 + OpenCV 품질 검사 + mock PhotoFacts`까지만 맡고, Cloud Vision/Gemini/YOLO는 선택 실험으로 둔다.
- 한 사람이 PM/통합 관리를 겸할 수 있지만, 최종 데모 전 1주는 코드 구현보다 통합 안정화와 발표 준비를 우선한다.
- 백업 담당은 같은 파트를 대신 완성하는 사람이 아니라, 해당 파트가 막혔을 때 API 계약과 데모 흐름을 이해하고 도와줄 사람이다.

## 2.2 파트별 소유 파일 예시

실제 repository가 만들어지면 아래 경로는 프로젝트 구조에 맞게 수정한다.

| 경로/문서 | Primary owner | Review owner | 변경 등급 |
| --- | --- | --- | --- |
| `app/lib/screens/` | 프론트엔드 | PM/통합 관리 | Level B |
| `app/lib/services/api_client.dart` | 프론트엔드 | 백엔드/DB | Level B |
| `backend/app/api/` | 백엔드/DB | 프론트엔드 | Level B |
| `backend/app/models/` | 백엔드/DB | AI, 프론트엔드 | Level B |
| `backend/app/services/rules/` | AI 규칙/요약 | 백엔드/DB | Level B |
| `backend/app/services/cv/` | CV/사진 검증 | 백엔드/DB | Level B |
| `backend/app/contracts/` 또는 `docs/contracts/` | AI + CV + 백엔드 | 프론트엔드 | Level B |
| `tests/scenarios/` | AI + QA/PM | 전원 | Level B |
| `database/migrations/` | 백엔드/DB | PM/통합 관리 | Level C |
| `docs/api_spec.md` | 백엔드/DB | 프론트엔드 | Level B |
| `docs/demo_plan.md` | PM/통합 관리 | 전원 | Level B |
| `.env.example`, dependency, lockfile | 해당 변경자 | 관련 owner | Level C |

## 3. Change Permission Levels

## Level A: 자유 수정

조건:

- 본인 담당 파일
- 문서 오타
- 데모 문구 수정
- 테스트 데이터 수정

요구:

- self review
- commit message 명확히 작성

## Level B: 수정 전 공유

조건:

- API request/response 변경
- 화면 흐름 변경
- 체크리스트 항목 변경
- 공통 상수 변경
- README 실행 방법 변경

요구:

- 관련 담당자에게 변경 의도 공유
- PR 또는 커밋 메시지에 영향 범위 작성

## Level C: 승인 필요

조건:

- DB schema 변경
- Storage 구조 변경
- auth/permission 변경
- dependency 추가/삭제
- feature flag 변경
- 다른 담당자 파일 대규모 수정

요구:

- owner 승인
- rollback 또는 복구 방법 작성
- 관련 기능 테스트

## 4. Branch Naming

```text
feature/frontend-triage-flow
feature/backend-accident-api
feature/ai-situation-rules
feature/cv-photo-validation
fix/photo-upload-retry
docs/demo-plan
```

## 5. Shared Contract Files

아래는 shared contract로 보고 단독 수정하지 않는다.

- API spec
- DB schema
- feature flags
- checklist item seed data
- situation rule definitions
- README 실행 방법
- demo scenario

## 6. Conflict Rules

충돌 발생 시:

1. 충돌 파일 owner를 확인한다.
2. 내 변경과 상대 변경을 구분한다.
3. 상대 변경을 임의로 삭제하지 않는다.
4. 의도가 불명확하면 owner에게 확인한다.
5. 해결 후 관련 테스트를 실행한다.

금지:

- 상대 코드를 통째로 삭제
- schema conflict 임의 선택
- lockfile conflict 덮어쓰기
- generated file로 수동 변경 덮어쓰기

## 7. Communication Template

```text
변경하려는 것:
이유:
영향 받는 파트:
필요한 리뷰어:
완료 예상:
```

## 8. Team Gate

구현 시작 전 다음을 확정한다.

- 각 팀원의 실제 이름과 담당 파트
- 팀원별 숙련도와 백업 담당
- Git repository 위치
- main 보호 여부
- PR 리뷰 방식
- API contract 작성 위치
- DB schema 변경 승인자
- 최종 데모 담당자

현재 단계에서는 실제 팀원 배정표 확정까지만 먼저 진행한다. 공식 출처 수집과 threat model은 구현 전 조사/보안 점검 단계에서 별도 진행한다.
