# 당황Zero ERD and Data Dictionary

## ERD Overview

```text
vehicles 1 ── N accidents
accidents 1 ── N triage_answers
accidents 1 ── N situation_candidates
accidents 1 ── N accident_photos
accident_photos 1 ── N photo_facts
accidents 1 ── N checklist_results
checklist_items 1 ── N checklist_results
triage_questions 1 ── N triage_answers
accidents 1 ── N action_logs
```

## Entity Summary

| Entity | Primary Key | 주요 Field | 관계 | User-owned |
| --- | --- | --- | --- | --- |
| vehicles | id | plate_number, car_model, insurance_company, emergency_contact | vehicles 1:N accidents | Yes |
| accidents | id | vehicle_id, occurred_at, latitude, longitude, location_text | accidents N:1 vehicles | Yes |
| triage_questions | id | question_key, text, answer_options | triage_questions 1:N triage_answers | No |
| triage_answers | id | accident_id, question_key, answer_value | triage_answers N:1 accidents | Yes |
| situation_candidates | id | accident_id, candidate_type, score, label | situation_candidates N:1 accidents | Yes |
| accident_photos | id | accident_id, photo_type, storage_path | accident_photos N:1 accidents | Yes |
| photo_facts | id | photo_id, provider, facts_json, raw_ref | photo_facts N:1 accident_photos | Yes |
| checklist_items | id | accident_type, text, priority | checklist_items 1:N checklist_results | No |
| checklist_results | id | accident_id, checklist_item_id, status | checklist_results N:1 accidents | Yes |
| action_logs | id | accident_id, action_kind, payload_json, because_json | action_logs N:1 accidents | Yes |

## Data Dictionary

## vehicles

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 차량 식별 | 테스트 종료 후 30일 이하 |
| plate_number | string | yes | 12가3456 | Personal | 사고 기록 식별 보조 | 테스트 종료 후 30일 이하 |
| car_model | string | yes | Avante | Personal | 차량 정보 표시 | 테스트 종료 후 30일 이하 |
| insurance_company | string | yes | Demo Insurance | Personal | 체크리스트 안내 | 테스트 종료 후 30일 이하 |
| emergency_contact | string | yes | 010-0000-0000 | Personal | 긴급 연락 안내 | 테스트 종료 후 30일 이하 |
| created_at | timestamp | yes | 2026-09-24T10:00:00+09:00 | Internal | 생성 시각 | 테스트 종료 후 30일 이하 |
| updated_at | timestamp | yes | 2026-09-24T10:00:00+09:00 | Internal | 수정 시각 | 테스트 종료 후 30일 이하 |

## accidents

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 사고 식별 | 테스트 종료 후 30일 이하 |
| vehicle_id | uuid | yes | uuid | Internal | 차량 연결 | 테스트 종료 후 30일 이하 |
| occurred_at | timestamp | yes | 2026-09-24T10:30:00+09:00 | Personal | 사고 시간 기록 | 테스트 종료 후 30일 이하 |
| latitude | decimal | no | 37.5665 | Sensitive | 위치 기록 | 테스트 종료 후 30일 이하 |
| longitude | decimal | no | 126.9780 | Sensitive | 위치 기록 | 테스트 종료 후 30일 이하 |
| location_text | string | no | 서울시 중구 예시 도로 | Sensitive | 위치 수동 기록 | 테스트 종료 후 30일 이하 |
| location_source | string | yes | gps | Internal | 위치 출처 | 테스트 종료 후 30일 이하 |
| created_at | timestamp | yes | 2026-09-24T10:30:00+09:00 | Internal | 생성 시각 | 테스트 종료 후 30일 이하 |

## triage_questions

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 질문 식별 | 프로젝트 유지 기간 |
| question_key | string | yes | injury_exists | Internal | 규칙 매칭 | 프로젝트 유지 기간 |
| text | string | yes | 다친 사람이 있나요? | Public | UI 표시 | 프로젝트 유지 기간 |
| answer_options | json | yes | ["yes","no","unknown"] | Public | UI 표시 | 프로젝트 유지 기간 |

## triage_answers

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 답변 식별 | 테스트 종료 후 30일 이하 |
| accident_id | uuid | yes | uuid | Internal | 사고 연결 | 테스트 종료 후 30일 이하 |
| question_key | string | yes | injury_exists | Internal | 질문 연결 | 테스트 종료 후 30일 이하 |
| answer_value | string | yes | unknown | Sensitive | 상황 유추 | 테스트 종료 후 30일 이하 |

## situation_candidates

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 후보 식별 | 테스트 종료 후 30일 이하 |
| accident_id | uuid | yes | uuid | Internal | 사고 연결 | 테스트 종료 후 30일 이하 |
| candidate_type | string | yes | minor_collision | Internal | 상황 후보 | 테스트 종료 후 30일 이하 |
| score | integer | yes | 4 | Internal | 규칙 점수 | 테스트 종료 후 30일 이하 |
| label | string | yes | 경미한 접촉사고 가능성 높음 | Internal | UI 표시 | 테스트 종료 후 30일 이하 |

## accident_photos

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 사진 식별 | 테스트 종료 후 30일 이하 |
| accident_id | uuid | yes | uuid | Internal | 사고 연결 | 테스트 종료 후 30일 이하 |
| photo_type | string | yes | scene_wide | Internal | 누락 확인 | 테스트 종료 후 30일 이하 |
| storage_path | string | yes | accidents/uuid/photo.jpg | Sensitive | 사진 조회 | 테스트 종료 후 30일 이하 |
| requested_slot | string | no | other_plate | Internal | 요청 항목 추적 | 테스트 종료 후 30일 이하 |
| quality_json | json | no | {"status":"pass"} | Internal | 품질 검사 결과 | 테스트 종료 후 30일 이하 |
| uploaded_at | timestamp | yes | 2026-09-24T10:35:00+09:00 | Internal | 업로드 시각 | 테스트 종료 후 30일 이하 |

## photo_facts

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 관찰 결과 식별 | 테스트 종료 후 30일 이하 |
| photo_id | uuid | yes | uuid | Internal | 사진 연결 | 테스트 종료 후 30일 이하 |
| provider | string | yes | mock | Internal | mock/비전 제공자 구분 | 테스트 종료 후 30일 이하 |
| raw_ref | string | no | fixtures/vision_raw/3f9a.json | Internal | 원본 응답 참조 | 테스트 종료 후 30일 이하 |
| facts_json | json | yes | {"vehicles":{"count":1}} | Sensitive | 사진 관찰 결과 저장 | 테스트 종료 후 30일 이하 |
| created_at | timestamp | yes | 2026-09-24T10:36:00+09:00 | Internal | 생성 시각 | 테스트 종료 후 30일 이하 |

## checklist_items

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | string | yes | check_injury | Public | 체크리스트 식별 | 프로젝트 유지 기간 |
| accident_type | string | yes | minor_collision | Public | 매칭 조건 | 프로젝트 유지 기간 |
| text | string | yes | 다친 사람이 있는지 확인하세요. | Public | 안내 표시 | 프로젝트 유지 기간 |
| priority | string | yes | high | Public | 정렬 | 프로젝트 유지 기간 |

## checklist_results

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 결과 식별 | 테스트 종료 후 30일 이하 |
| accident_id | uuid | yes | uuid | Internal | 사고 연결 | 테스트 종료 후 30일 이하 |
| checklist_item_id | string | yes | check_injury | Internal | 체크리스트 연결 | 테스트 종료 후 30일 이하 |
| status | string | yes | pending | Internal | 완료 상태 | 테스트 종료 후 30일 이하 |

## action_logs

| 컬럼 | 타입 | 필수 | 예시 | 분류 | 저장 목적 | 보관 기간 |
| --- | --- | --- | --- | --- | --- | --- |
| id | uuid | yes | uuid | Internal | 행동 로그 식별 | 테스트 종료 후 30일 이하 |
| accident_id | uuid | yes | uuid | Internal | 사고 연결 | 테스트 종료 후 30일 이하 |
| action_kind | string | yes | capture | Internal | NextAction 종류 | 테스트 종료 후 30일 이하 |
| payload_json | json | yes | {"slot":"other_plate"} | Internal | 앱 표시 행동 재현 | 테스트 종료 후 30일 이하 |
| because_json | json | no | ["gap=other_plate"] | Internal | 결정 근거 추적 | 테스트 종료 후 30일 이하 |
| created_at | timestamp | yes | 2026-09-24T10:37:00+09:00 | Internal | 생성 시각 | 테스트 종료 후 30일 이하 |
