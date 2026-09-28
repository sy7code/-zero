# 당황Zero Project Overlay

범용 하네스에 덧씌우는 프로젝트별 실행 규칙이다. 구현 중 판단이 갈리면 이 파일을 우선 확인한다.

## 1. Project Summary

프로젝트 이름: 당황Zero

한 줄 목표: 교통사고 직후 사용자가 판단을 길게 설명하지 않아도, 앱이 한 번에 하나씩 묻고 필요한 사진과 기록을 안내한다.

주 사용자: 사고 직후 당황해서 대응 순서와 증거 기록 항목을 놓치기 쉬운 운전자

핵심 사용자 흐름: 시작 -> 안전 확인 -> 전경 사진 -> 쉬운 질문 -> 상황 후보 확인 -> 상황별 사진 -> 이동 후 정보 -> 사고 기록 카드

## 2. Tech Stack

Frontend: Flutter, Dart

Local data: Hive, app documents directory

Device APIs: camera, geolocator, flutter_tts, share_plus, permission_handler

Backend: FastAPI, Pydantic

CV/AI: Pillow, OpenCV, Google Cloud Vision 후보, 보조 모델 후보, mock/replay adapter

Rules and scenarios: PyYAML, rule engine, scenario YAML

Validation: pytest, fixture replay, 30장 사진 시험

Design: Pretendard, Lucide

## 3. Architecture

```text
Flutter App
  -> Hive: 차량 정보, 사고 기록, 사진 메타데이터, 체크리스트 상태
  -> App Documents Directory: 사고 사진 파일
  -> Device APIs: 카메라, 위치, 음성 읽기, 공유
  -> FastAPI, optional: 사진 품질/PhotoFacts/NextAction 계산
  -> Vision Adapter, optional: real, mock, replay
```

기록은 사용자 기기 안에 저장한다. 서버는 기본적으로 계산 결과를 반환하고, 데모 replay fixture 외의 실제 개인정보와 사진 원본을 장기 저장하지 않는다.

## 4. MVP Scope

포함:

- 사고 대응 시작과 위치/시간 자동 기록
- 안전 확인과 긴급 화면
- 버튼 2-4개와 `모름` 중심의 쉬운 질문
- 전경, 번호판, 파손 부위, 시설물 등 사진 기록 안내
- 상황 후보와 누락 항목 기반 NextAction
- 사고 기록 카드와 히스토리
- AI/CV 없이 돌아가는 mock/replay 검증

제외:

- 과실비율 판단
- 법적 책임 판단
- 112/119 신고 대체
- 보험사 공식 판단 또는 실시간 접수
- 경찰/소방 시스템 연동
- 실제 번호판 OCR 확정 저장
- 외부 모델에 실제 개인정보가 포함된 사진을 무조건 전송하는 흐름

## 5. Data Classification

Sensitive:

- GPS 좌표, 상세 주소, 사고 사진 원본, 번호판이 보이는 사진

Personal:

- 차량번호, 보험사, 긴급 연락처, 사고 시간, 사고 메모

Internal:

- accident_id, photo_id, scenario_id, rule_id, request_id, quality score

Public:

- 체크리스트 템플릿, 촬영 안내 문구, 질문 템플릿

저장하지 않을 데이터:

- 서버 로그의 차량번호 원문
- 서버 로그의 전화번호 원문
- 서버 로그의 상세 주소 원문
- 외부 API 응답에 포함된 실제 번호판 원문

## 6. External Integrations

Google Cloud Vision 후보:

- 인증 방식: 서버 환경변수
- timeout: 10초 이하
- retry: 429, 502, 503, 504에 한해 최대 1회
- fallback: replay fixture 또는 manual PhotoFacts
- 비용: 30장 시험 전 호출 수 제한
- rate limit: 실험 계정 기준 확인 필요

주소 변환 후보:

- timeout: 5초 이하
- fallback: 좌표 또는 수동 위치 메모만 저장

보조 모델 후보:

- timeout: 15초 이하
- fallback: 규칙 기반 NextAction
- 금지: 과실, 법적 책임, 신고 필요 여부 확정 문장

## 7. Feature Flags

```text
VITE_ENABLE_VISION=false
VITE_ENABLE_REPLAY=true
VITE_ENABLE_TTS=true
ENABLE_REAL_VISION=false
ENABLE_ASSISTANT_MODEL=false
```

## 8. API Contracts

주요 API:

```text
POST /analyze/photo
request: image or replay_ref, requested_slot
response: PhotoFacts, quality, request_id
error: code, message, request_id

POST /next-action
request: AccidentSnapshot
response: NextAction
error: code, message, request_id
```

API는 사고 기록의 원본 저장소가 아니다. 클라이언트는 필요한 결과만 Flutter 로컬 저장소에 저장한다.

## 9. Local Storage Contracts

주요 Hive boxes:

- vehicles
- accidents
- triage_answers
- accident_photos
- photo_facts
- checklist_results
- action_logs
- app_settings
- replay_fixtures, 개발/데모 전용

마이그레이션 주의사항:

- Hive adapter 또는 box schema를 바꿀 때 기존 사고 기록을 삭제하지 않는다.
- 민감 필드를 추가하면 data dictionary에 분류와 보관 기간을 먼저 적는다.

## 10. Test Scenarios

정상 시나리오:

- 차대차 접촉사고 기본 흐름
- 시설물 파손 흐름
- 이동 전 촬영 후 이동 후 정보 입력

실패 시나리오:

- 위치 권한 거부
- 사진 품질 불합격
- 비전 API timeout
- 무응답 10초 후 음성 안내

권한 시나리오:

- 카메라 권한 거부 후 수동 업로드
- 위치 권한 거부 후 수동 위치 메모

## 11. Release Checklist

- README와 산출물이 3차 기준으로 최신이다.
- mock/replay 시나리오 12개 중 must-have 8개 이상 통과한다.
- 핵심 데모가 3회 연속 성공한다.
- 데모 데이터에 실제 개인정보가 0개다.
- server secret이 Flutter 앱 설정 또는 bundle에 없다.
- 외부 API 실패 시 AI/CV 없이 흐름이 끝까지 간다.
