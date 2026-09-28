# 당황Zero Local Data Model and Data Dictionary

## Storage Policy

MVP의 원본 데이터는 Flutter 앱의 로컬 저장소에 저장한다. 구조화 데이터는 Hive box에 저장하고, 사진 파일은 앱 문서 디렉터리에 저장한다. FastAPI는 분석 결과를 계산해 반환하며, 데모 replay fixture 외의 실제 사고 기록과 사진 원본을 장기 저장하지 않는다.

## Local Store Overview

```text
vehicles 1 -> N accidents
accidents 1 -> N triage_answers
accidents 1 -> N situation_candidates
accidents 1 -> N accident_photos
accident_photos 1 -> N photo_facts
accidents 1 -> N checklist_results
accidents 1 -> N action_logs
checklist_templates 1 -> N checklist_results
```

## Entity Summary

| Store/Box | Primary Key | 주요 Field | 관계 | Owner |
| --- | --- | --- | --- | --- |
| vehicles | id | plate_number, car_model, insurance_company, emergency_contact | vehicles 1:N accidents | local user |
| accidents | id | vehicle_id, occurred_at, location, status | accidents N:1 vehicles | local user |
| triage_answers | id | accident_id, question_key, answer_value | triage_answers N:1 accidents | local user |
| situation_candidates | id | accident_id, candidate_type, confidence_level, reason_codes | situation_candidates N:1 accidents | local user |
| accident_photos | id | accident_id, slot, local_path, status, quality_json | accident_photos N:1 accidents | local user |
| photo_facts | id | photo_id, provider, facts_json, raw_ref | photo_facts N:1 accident_photos | local user |
| checklist_templates | id | accident_type, text, priority, source_ref | static reference | app |
| checklist_results | id | accident_id, checklist_item_id, status | checklist_results N:1 accidents | local user |
| action_logs | id | accident_id, action_kind, payload_json, because_json | action_logs N:1 accidents | local user |
| replay_fixtures | id | scenario_id, raw_ref, masked | dev/demo only | team |

## vehicles

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_uuid | Internal | 차량 식별 | 사용자가 삭제할 때까지 |
| plate_number | string | yes | 12가3456 | Personal | 사고 기록 식별 보조 | 사용자가 삭제할 때까지 |
| car_model | string | no | Avante | Personal | 차량 정보 표시 | 사용자가 삭제할 때까지 |
| insurance_company | string | no | Demo Insurance | Personal | 이동 후 연락 항목 표시 | 사용자가 삭제할 때까지 |
| emergency_contact | string | no | 010-0000-0000 | Personal | 연락처 카드 표시 | 사용자가 삭제할 때까지 |
| created_at | string | yes | 2026-09-28T14:00:00+09:00 | Internal | 생성 시각 | 사용자가 삭제할 때까지 |
| updated_at | string | yes | 2026-09-28T14:00:00+09:00 | Internal | 수정 시각 | 사용자가 삭제할 때까지 |

## accidents

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_uuid | Internal | 사고 식별 | 사용자가 삭제할 때까지 |
| vehicle_id | string | no | local_vehicle_id | Internal | 차량 연결 | 사용자가 삭제할 때까지 |
| occurred_at | string | yes | 2026-09-28T14:30:00+09:00 | Personal | 사고 시간 기록 | 사용자가 삭제할 때까지 |
| location_source | string | yes | gps | Internal | 위치 출처 | 사용자가 삭제할 때까지 |
| latitude | number | no | 37.5665 | Sensitive | 위치 기록 | 사용자가 삭제할 때까지 |
| longitude | number | no | 126.9780 | Sensitive | 위치 기록 | 사용자가 삭제할 때까지 |
| accuracy_m | number | no | 25 | Internal | 위치 정확도 표시 | 사용자가 삭제할 때까지 |
| location_text | string | no | 서울시 중구 예시 도로 | Sensitive | 수동 위치 메모 | 사용자가 삭제할 때까지 |
| status | string | yes | active | Internal | 흐름 상태 | 사용자가 삭제할 때까지 |

## triage_answers

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_uuid | Internal | 답변 식별 | 사용자가 삭제할 때까지 |
| accident_id | string | yes | local_uuid | Internal | 사고 연결 | 사용자가 삭제할 때까지 |
| question_key | string | yes | injury_exists | Internal | 규칙 매칭 | 사용자가 삭제할 때까지 |
| answer_value | string | yes | unknown | Sensitive | 상황 후보 계산 | 사용자가 삭제할 때까지 |
| answered_at | string | yes | 2026-09-28T14:31:00+09:00 | Internal | 답변 시각 | 사용자가 삭제할 때까지 |

## accident_photos

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_photo_id | Internal | 사진 식별 | 사용자가 삭제할 때까지 |
| accident_id | string | yes | local_uuid | Internal | 사고 연결 | 사용자가 삭제할 때까지 |
| slot | string | yes | other_plate | Internal | 누락 확인 | 사용자가 삭제할 때까지 |
| local_path | string | no | app_documents/accidents/photo.jpg | Sensitive | 사진 파일 참조 | 사용자가 삭제할 때까지 |
| status | string | yes | done | Internal | 촬영 상태 | 사용자가 삭제할 때까지 |
| quality_json | json | no | {"status":"pass"} | Internal | 품질 검사 결과 | 사용자가 삭제할 때까지 |
| captured_at | string | yes | 2026-09-28T14:35:00+09:00 | Internal | 촬영 시각 | 사용자가 삭제할 때까지 |

## photo_facts

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_fact_id | Internal | 관찰 결과 식별 | 사용자가 삭제할 때까지 |
| photo_id | string | yes | local_photo_id | Internal | 사진 연결 | 사용자가 삭제할 때까지 |
| provider | string | yes | mock | Internal | 제공자 구분 | 사용자가 삭제할 때까지 |
| raw_ref | string | no | fixtures/vision_raw/3f9a.json | Internal | replay 참조 | 데모 종료 후 삭제 |
| facts_json | json | yes | {"vehicles":{"count":1}} | Sensitive | 사진 관찰 결과 | 사용자가 삭제할 때까지 |
| created_at | string | yes | 2026-09-28T14:36:00+09:00 | Internal | 생성 시각 | 사용자가 삭제할 때까지 |

## checklist_templates

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | check_injury | Public | 체크리스트 식별 | 프로젝트 유지 기간 |
| accident_type | string | yes | vehicle_vehicle | Public | 매칭 조건 | 프로젝트 유지 기간 |
| text | string | yes | 다친 사람이 있는지 확인하세요. | Public | 안내 표시 | 프로젝트 유지 기간 |
| priority | string | yes | high | Public | 정렬 | 프로젝트 유지 기간 |
| source_ref | string | no | source_required | Public | 출처 표시 | 프로젝트 유지 기간 |

## checklist_results

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_uuid | Internal | 결과 식별 | 사용자가 삭제할 때까지 |
| accident_id | string | yes | local_uuid | Internal | 사고 연결 | 사용자가 삭제할 때까지 |
| checklist_item_id | string | yes | check_injury | Internal | 체크리스트 연결 | 사용자가 삭제할 때까지 |
| status | string | yes | pending | Internal | 완료 상태 | 사용자가 삭제할 때까지 |

## action_logs

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | local_uuid | Internal | 행동 로그 식별 | 사용자가 삭제할 때까지 |
| accident_id | string | yes | local_uuid | Internal | 사고 연결 | 사용자가 삭제할 때까지 |
| action_kind | string | yes | capture | Internal | NextAction 종류 | 사용자가 삭제할 때까지 |
| payload_json | json | yes | {"slot":"other_plate"} | Internal | 화면 재현 | 사용자가 삭제할 때까지 |
| because_json | json | no | ["gap=other_plate"] | Internal | 결정 근거 추적 | 사용자가 삭제할 때까지 |
| created_at | string | yes | 2026-09-28T14:37:00+09:00 | Internal | 생성 시각 | 사용자가 삭제할 때까지 |

## Data Rules

- 실제 개인정보가 들어간 fixture는 만들지 않는다.
- 발표용 화면과 로그는 번호판, 전화번호, 상세 주소를 마스킹한다.
- 외부 API로 보낼 사진은 데모용 가짜 사진 또는 개인정보 제거 사진으로 제한한다.
- 사용자가 기록 삭제를 누르면 관련 Hive box 데이터와 앱 문서 디렉터리의 사진 파일이 함께 삭제되어야 한다.
