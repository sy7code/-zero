# 당황Zero API and Local Contract Spec

사고 기록의 원본 저장소는 Flutter 앱의 로컬 저장소다. FastAPI는 선택적 분석, replay, 시나리오 검증을 위한 계산 API이며 차량 정보와 사고 기록을 장기 저장하지 않는다.

공통 실패 응답은 `code`, `message`, `request_id`를 포함한다.

```json
{
  "success": false,
  "code": "ERROR_CODE",
  "message": "사용자에게 보여줄 메시지",
  "request_id": "req_xxx"
}
```

## Local Contract: AccidentSnapshot

Flutter 앱이 Decision Core 또는 FastAPI에 넘기는 현재 사고 상태다.

```json
{
  "accident_id": "local_uuid",
  "occurred_at": "2026-09-28T14:30:00+09:00",
  "location": {
    "source": "gps",
    "lat": 37.5665,
    "lng": 126.978,
    "accuracy_m": 25,
    "text": "서울시 중구 예시 도로"
  },
  "answers": {
    "injury_exists": "unknown",
    "road_risk": "no",
    "other_vehicle_exists": "yes"
  },
  "photo_slots": {
    "scene_wide": "done",
    "other_plate": "missing"
  },
  "photo_facts": [
    {
      "photo_id": "p1",
      "slot_requested": "scene_wide",
      "provider": "mock",
      "vehicles": { "count": 2 },
      "contact": "yes",
      "plate": { "visible": "no", "text": null, "format_ok": null },
      "smoke_fire": "no"
    }
  ]
}
```

Validation:

- `accident_id`: local UUID
- `location.source`: `gps`, `manual`, `unknown`
- answer value: `yes`, `no`, `unknown`, 또는 질문별 enum
- 사진 slot 상태: `missing`, `requested`, `done`, `skipped`
- `unknown`은 실패가 아니라 정보 부족이다.

## GET /health

목적: 백엔드 서버 상태 확인

Response:

```json
{
  "success": true,
  "data": {
    "status": "ok",
    "mode": "mock"
  },
  "message": "ok"
}
```

## POST /analyze/photo

목적: 사진 품질과 PhotoFacts 후보를 반환한다. 서버는 기본적으로 사진 원본을 장기 저장하지 않는다.

Content-Type:

- `multipart/form-data`

Fields:

- `file`: jpg, jpeg, png, webp
- `requested_slot`: `scene_wide`, `my_damage_close`, `my_damage_wide`, `other_damage`, `other_plate`, `traffic_sign`, `facility`, `road_marks`, `other`
- `mode`: `mock`, `replay`, `real`
- `replay_ref`: replay 모드에서만 사용

Validation:

- file size: 10MB 이하
- 원본 파일명 저장 금지
- HEIC는 JPEG 변환 또는 재업로드 요청
- 실제 번호판 원문은 로그에 남기지 않음

Response:

```json
{
  "success": true,
  "data": {
    "request_id": "req_xxx",
    "quality": {
      "status": "pass",
      "blur_score": 182,
      "brightness": 0.52
    },
    "photo_facts": {
      "photo_id": "local_p1",
      "slot_requested": "other_plate",
      "provider": "replay",
      "raw_ref": "fixtures/vision_raw/plate_01.json",
      "vehicles": {
        "count": 1,
        "largest_box_area": 0.62
      },
      "framing": "medium",
      "contact": "unknown",
      "plate": {
        "visible": "yes",
        "text": "123가****",
        "format_ok": true
      },
      "facility": "unknown",
      "road_marks": {
        "lane": "yes",
        "skid": "unknown"
      },
      "smoke_fire": "no",
      "caption_ko": "승용차 뒷면, 번호판 후보"
    }
  },
  "message": "photo_analyzed"
}
```

## POST /next-action

목적: 현재 사고 상태에서 앱이 다음에 보여줄 행동 1개를 반환한다.

Request:

```json
{
  "snapshot": {
    "accident_id": "local_uuid",
    "answers": {
      "injury_exists": "no",
      "other_vehicle_exists": "yes"
    },
    "photo_slots": {
      "scene_wide": "done",
      "other_plate": "missing"
    },
    "photo_facts": []
  }
}
```

Response:

```json
{
  "success": true,
  "data": {
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
  },
  "message": "ok"
}
```

Allowed `kind`:

- `capture`: 촬영 요청
- `choice`: 버튼 선택지
- `checklist`: 체크 항목
- `call`: 전화 버튼
- `emergency`: 긴급 안내
- `summary`: 사고 기록 카드

## POST /scenario/run

목적: YAML 시나리오를 실행해 NextAction 흐름을 검증한다. 개발/테스트 전용이다.

Request:

```json
{
  "scenario_id": "S02_missing_plate",
  "mode": "mock"
}
```

Response:

```json
{
  "success": true,
  "data": {
    "scenario_id": "S02_missing_plate",
    "passed": true,
    "steps": 5,
    "failed_step": null
  },
  "message": "scenario_passed"
}
```

## API Guardrails

- 서버는 차량번호, 전화번호, 상세 주소 원문을 로그에 남기지 않는다.
- server secret은 Flutter 앱 설정, asset, bundle에 포함하지 않는다.
- real vision 모드는 feature flag로 꺼둘 수 있어야 한다.
- AI/CV 실패 시 `manual_choice_required` 또는 replay 결과를 반환한다.
- 과실, 법적 책임, 신고 필요 여부 확정 문장을 반환하면 실패다.
