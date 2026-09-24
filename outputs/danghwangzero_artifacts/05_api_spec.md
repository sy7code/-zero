# 당황Zero API Spec

공통 실패 응답은 `code`, `message`, `request_id`를 포함한다.

```json
{
  "success": false,
  "code": "ERROR_CODE",
  "message": "사용자에게 보여줄 메시지",
  "request_id": "req_xxx"
}
```

## GET /health

목적: 백엔드 서버 상태 확인

Response:

```json
{
  "success": true,
  "data": {
    "status": "ok"
  },
  "message": "ok"
}
```

## POST /vehicles

목적: 차량과 보험/연락처 정보 등록

Request:

```json
{
  "plate_number": "12가3456",
  "car_model": "Avante",
  "insurance_company": "Demo Insurance",
  "emergency_contact": "010-0000-0000"
}
```

Validation:

- `plate_number`: required, max 20
- `car_model`: required, max 50
- `insurance_company`: required, max 50
- `emergency_contact`: required, max 30

Response:

```json
{
  "success": true,
  "data": {
    "vehicle_id": "uuid"
  },
  "message": "vehicle_created"
}
```

## GET /vehicles

목적: 등록된 차량 정보 조회

Response:

```json
{
  "success": true,
  "data": [
    {
      "vehicle_id": "uuid",
      "plate_number": "12가3456",
      "car_model": "Avante",
      "insurance_company": "Demo Insurance",
      "emergency_contact": "010-0000-0000"
    }
  ],
  "message": "ok"
}
```

## POST /accidents

목적: 사고 기록 생성

Request:

```json
{
  "vehicle_id": "uuid",
  "occurred_at": "2026-09-24T10:30:00+09:00",
  "latitude": 37.5665,
  "longitude": 126.978,
  "location_text": "서울시 중구 예시 도로",
  "location_source": "gps"
}
```

Validation:

- `vehicle_id`: required
- `occurred_at`: required
- `latitude`: optional, -90 to 90
- `longitude`: optional, -180 to 180
- `location_text`: optional, max 200
- `location_source`: `gps` 또는 `manual`

Response:

```json
{
  "success": true,
  "data": {
    "accident_id": "uuid"
  },
  "message": "accident_created"
}
```

## POST /accidents/{accident_id}/triage-answers

목적: 단계형 질문 답변 저장

Request:

```json
{
  "answers": [
    {
      "question_key": "injury_exists",
      "answer_value": "unknown"
    },
    {
      "question_key": "other_vehicle_exists",
      "answer_value": "yes"
    }
  ]
}
```

Response:

```json
{
  "success": true,
  "data": {
    "saved_count": 2
  },
  "message": "triage_answers_saved"
}
```

## GET /accidents/{accident_id}/situation

목적: 질문 답변 기반 상황 후보 조회

Response:

```json
{
  "success": true,
  "data": {
    "primary_candidate": {
      "type": "minor_collision",
      "label": "경미한 접촉사고 가능성 높음",
      "confidence_level": "high"
    },
    "candidates": [
      {
        "type": "minor_collision",
        "score": 4
      },
      {
        "type": "emergency_check_required",
        "score": 1
      }
    ],
    "next_question": null
  },
  "message": "ok"
}
```

## POST /accidents/{accident_id}/photos

목적: 사고 사진 업로드

Content-Type:

- `multipart/form-data`

Fields:

- `photo_type`: `scene_wide`, `my_damage_close`, `my_damage_wide`, `other_damage`, `other_plate`, `traffic_sign`, `facility`, `road_marks`, `other`
- `file`: jpg, jpeg, png, webp
- `requested_slot`: 서버가 요청한 촬영 항목, optional

Validation:

- file size: 10MB 이하
- 원본 파일명 저장 금지
- Storage path는 UUID 기반
- HEIC는 서버에서 바로 분석하지 않고 JPEG 재업로드 또는 앱 변환을 요청한다.

Response:

```json
{
  "success": true,
  "data": {
    "photo_id": "uuid",
    "photo_type": "scene_wide",
    "storage_path": "accidents/uuid/photo_uuid.jpg",
    "quality": {
      "status": "pass",
      "blur_score": 182,
      "brightness": 0.52
    },
    "photo_facts_status": "not_run"
  },
  "message": "photo_uploaded"
}
```

## POST /accidents/{accident_id}/photo-facts

목적: CV/비전/mock 결과를 고정 형식으로 저장한다. MVP에서는 내부 API 또는 개발용 API로만 사용한다.

Request:

```json
{
  "photo_id": "uuid",
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

Validation:

- `provider`: `mock`, `cloud_vision`, `gemini`, `opencv`, `manual`
- 관찰 값은 `yes`, `no`, `unknown` 중 하나를 우선 사용한다.
- `unknown`은 실패가 아니라 정보 부족으로 취급한다.
- 실제 개인정보가 포함된 번호판 텍스트는 데모/로그/슬라이드에서 마스킹한다.

Response:

```json
{
  "success": true,
  "data": {
    "photo_fact_id": "uuid"
  },
  "message": "photo_facts_saved"
}
```

## GET /accidents/{accident_id}/next-action

목적: 현재 사고 기록에서 앱이 다음에 보여줄 행동 1개를 반환한다.

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

## GET /accidents/{accident_id}/checklist

목적: 상황 후보와 사진 상태 기반 체크리스트 조회

Response:

```json
{
  "success": true,
  "data": {
    "situation_label": "경미한 접촉사고 가능성 높음",
    "missing_photo_types": ["other_plate"],
    "items": [
      {
        "id": "check_injury",
        "text": "다친 사람이 있는지 다시 확인하세요.",
        "priority": "high",
        "source": "source_required"
      }
    ]
  },
  "message": "ok"
}
```

## GET /accidents/{accident_id}/summary

목적: 사고 기록 요약 조회

Response:

```json
{
  "success": true,
  "data": {
    "occurred_at": "2026-09-24T10:30:00+09:00",
    "location_text": "서울시 중구 예시 도로",
    "vehicle": {
      "plate_number": "12가3456",
      "insurance_company": "Demo Insurance"
    },
    "situation_label": "경미한 접촉사고 가능성 높음",
    "photo_status": {
      "uploaded": ["overview", "damage"],
      "missing": ["license_plate"]
    },
    "checklist_count": 5
  },
  "message": "ok"
}
```
