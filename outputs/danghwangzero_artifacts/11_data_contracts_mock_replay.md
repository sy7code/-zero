# 당황Zero Data Contracts, Mock, and Replay

이 문서는 사진 분석, 상황 분류, 누락 분석, 화면 안내를 서로 분리하기 위한 구현 계약이다. 목적은 CV/AI가 완성되지 않아도 앱과 백엔드가 mock 데이터로 끝까지 동작하게 만드는 것이다.

## 1. 채택할 것과 제외할 것

채택:

- `PhotoFacts`: 사진에서 관찰한 사실만 담는 JSON
- `NextAction`: 앱이 다음에 보여줄 행동 1개를 담는 JSON
- mock PhotoFacts 주입
- 실제 비전 응답 replay
- 시나리오 YAML 기반 자동 검증

제외 또는 보류:

- React 화면 전제: 이 프로젝트는 Flutter 앱이므로 React 디버그 UI는 사용하지 않는다.
- Cloudflare 터널 전제: 실제 배포/시연 방식 확정 전까지 필수로 두지 않는다.
- Google Vision 확정: 30장 시험 전까지 후보 기술로만 둔다.
- Gemini 또는 외부 AI 테스트 환경에 실제 번호판/개인정보 전송: 사용하지 않는다.

## 2. PhotoFacts Contract

PhotoFacts는 사진에서 본 사실만 담는다. 체크리스트 조건을 충족했는지, 사고 유형이 무엇인지는 PhotoFacts에 넣지 않는다.

```json
{
  "photo_id": "p5",
  "slot_requested": "other_plate",
  "provider": "mock",
  "raw_ref": "fixtures/vision_raw/3f9a.json",
  "vehicles": {
    "count": 1,
    "largest_box_area": 0.62
  },
  "framing": "medium",
  "contact": "unknown",
  "plate": {
    "visible": "yes",
    "text": "123가4567",
    "format_ok": true
  },
  "facility": "unknown",
  "road_marks": {
    "lane": "yes",
    "skid": "unknown"
  },
  "smoke_fire": "no",
  "caption_ko": "승용차 뒷면, 번호판 판독"
}
```

규칙:

- 관찰 값은 가능하면 `yes`, `no`, `unknown`으로 둔다.
- 인식하지 못한 것은 `unknown`이다. `unknown`을 `no`로 바꾸지 않는다.
- 번호판 텍스트는 사용자가 확인하기 전까지 확정값이 아니다.
- 실제 번호판은 로그, 발표자료, 슬라이드에서 마스킹한다.
- `caption_ko`는 사람이 디버깅하기 위한 설명이며, 규칙 판단의 유일한 입력으로 쓰지 않는다.

## 3. NextAction Contract

NextAction은 앱이 다음에 보여줄 행동 1개만 담는다.

```json
{
  "action_id": "a7",
  "kind": "capture",
  "slot": "other_plate",
  "kb_item": "SHOT_OTHER_PLATE",
  "text": "상대 차 번호판을 찍어 주세요.",
  "hint": "번호판 글자가 화면 가운데 오게 촬영하세요.",
  "tts": "상대 차 번호판을 찍어 주세요.",
  "timeout_s": 10,
  "source": "source_required",
  "because": [
    "type=VEHICLE_VEHICLE",
    "gap=other_plate"
  ]
}
```

Allowed `kind`:

- `capture`: 사진 촬영 요청
- `choice`: 버튼 2~4개와 `모름`
- `checklist`: 체크박스 목록
- `call`: 전화 버튼
- `emergency`: 긴급 안내
- `summary`: 사고 기록 카드

규칙:

- 한 번에 보여줄 주요 요청은 1개다.
- 버튼 선택지는 최대 4개다.
- `모름`은 안전/분류 질문에 항상 둔다.
- 전화는 자동 실행하지 않고 사용자가 버튼을 누를 때만 연결한다.
- `because`는 디버그 화면과 발표 설명에 사용한다.

## 4. Mock Injection Points

| ID | 주입 지점 | 목적 | 예시 |
| --- | --- | --- | --- |
| S1 | 시간/위치 고정 | 같은 시나리오 반복 재현 | 고정 좌표, 고정 시각 |
| S2 | 품질 결과 | 흔들림/어두움 흐름 검증 | `quality.status=fail` |
| S3 | 원본 비전 응답 | textualize만 검증 | Cloud Vision 응답 fixture |
| S4 | PhotoFacts | 비전 없이 분류부터 끝까지 검증 | 차량 2대, 접촉 yes |
| S5 | 분류 결과 | 누락 분석과 NextAction 검증 | `VEHICLE_VEHICLE` |
| S6 | 가상 사용자 | 무응답/건너뛰기 검증 | `timeout: 10` |

## 5. Scenario YAML 예시

```yaml
id: S02_missing_plate
context:
  time: "2026-10-14T18:32:00+09:00"
  lat: 37.5665
  lng: 126.9780
  address: "서울 중구 세종대로 110"
steps:
  - expect: { kind: choice, slot: injury }
    user: { answer: "no" }
  - expect: { kind: capture, slot: scene_wide }
    user:
      photo_facts:
        vehicles: { count: 2 }
        contact: "yes"
        framing: "wide"
        plate: { visible: "no" }
        caption_ko: "차 두 대가 앞뒤로 맞닿아 있음"
  - expect: { kind: choice, slot: accident_type, proposed: VEHICLE_VEHICLE }
    user: { answer: "yes" }
  - expect: { kind: capture, slot: other_plate }
    user: { timeout: 10 }
  - expect: { kind: capture, slot: other_plate, escalation: tts }
    user:
      photo_facts:
        plate: { visible: "yes", text: "123가4567", format_ok: true }
final:
  classification: VEHICLE_VEHICLE
```

## 6. 필수 시나리오 12개

1. 차대차 기본
2. 번호판 누락 후 보완
3. 흔들린 사진 다시 찍기
4. 부상 있음
5. 부상 모름
6. 주차 차량
7. 단독 시설물
8. 고속도로 또는 2차 사고 위험 우선
9. 비전 응답 시간 초과
10. 무응답 후 음성/화면 강조
11. 연기 또는 화재 관찰
12. 애매한 분류 후 추가 질문

통과 기준:

- 12개 중 must-have 흐름 8개 이상은 mock만으로 통과한다.
- 최종 발표 전에는 핵심 데모 시나리오 3회 연속 통과가 필요하다.
- 비전 API가 실패해도 `manual choice` 또는 `replay`로 끝까지 진행한다.

## 7. Vision 후보 기술 적용 순서

1. MVP: 수동 사진 항목 체크와 mock PhotoFacts
2. OpenCV: 회전, 크기, 흔들림, 밝기 품질 검사
3. Cloud Vision 후보 실험: 팀 사진 30장으로 라벨, 객체, OCR 응답 확인
4. Gemini 후보 보완: Cloud Vision이 못 채우는 항목만 개인정보 없이 테스트
5. YOLO 후보 실험: pretrained 성능이 데모에 충분할 때만 사용

30장 시험 구성:

- 전경 10장
- 충격 부위 10장
- 번호판 10장
- 디오라마 사진 일부 추가 가능

판정 기준:

- 각 PhotoFacts 필드별 채움률을 표로 기록한다.
- 번호판은 사용자가 1탭으로 확인하는 후보값으로만 사용한다.
- 파손, 스키드마크, 연기/화재 항목 채움률이 낮으면 Gemini 또는 수동 질문으로 대체한다.

## 8. Replay와 로그

Replay:

- 실제 비전 API 응답은 보정된 사진 해시를 기준으로 저장한다.
- 테스트와 예비 시연에서는 저장된 응답을 재생한다.
- replay 결과는 실제 API 호출 결과와 같은 PhotoFacts contract를 반환한다.

JSONL 로그:

```text
photo_analyzed p5 slot=other_plate
preprocess pass blur=182 bright=0.52 1600x1200
vision replay raw_ref=fixtures/vision_raw/3f9a.json
textualize plate_format_ok=true
state other_plate=confirmed_by_user
gaps personal_info, other_insurer, insurer_call
plan choice personal_info kb=PERSONAL_INFO
```

로그 규칙:

- 실제 차량번호, 전화번호, 상세 주소, storage signed URL은 남기지 않는다.
- `request_id`, `accident_id`, module name, elapsed ms, rule id는 남긴다.
- 발표용 디버그 화면에는 마스킹된 값과 `because`만 보여준다.
