# DanghwangZero Project Overlay

이 파일은 Universal Development Harness를 당황Zero 프로젝트에 적용하기 위한 프로젝트별 오버레이이다.

## 1. Project Summary

프로젝트 이름:

- 당황Zero

한 줄 목표:

- 교통사고 직후 필요한 사진, 위치, 시간, 차량 정보, 사고 상황을 구조화하고 초기 대응 체크리스트를 제공하는 모바일 앱

주 사용자:

- 경미한 접촉사고 또는 시설물 파손 사고 직후 초기 대응이 필요한 운전자

핵심 사용자 흐름:

```text
앱 실행
  -> 사고 대응 시작
  -> 사고 유형 선택
  -> 위치/시간 저장
  -> 사진 촬영/업로드
  -> 누락 항목 확인
  -> 체크리스트 추천
  -> 사고 요약 확인
```

## 2. Tech Stack

Frontend:

- Flutter
- Dart

Backend:

- FastAPI
- Python

Database:

- Supabase PostgreSQL

Storage:

- Supabase Storage

AI:

- MVP: 규칙 기반 케이스 매칭
- Optional: LLM API for summary and follow-up questions

CV:

- MVP: 수동 사진 항목 체크
- Optional: OpenCV image quality check
- Optional: YOLO pretrained detection

## 3. Architecture

```text
Flutter App
  -> FastAPI Backend
      -> Supabase PostgreSQL
      -> Supabase Storage
      -> AI rules module
      -> CV validation module
```

## 4. MVP Scope

포함:

- 사고 유형 선택
- 위치/시간 저장
- 차량 정보 등록
- 사진 촬영/업로드
- 사진 항목 누락 확인
- 사고 유형별 체크리스트 추천
- 사고 요약

제외:

- 과실비율 판단
- 법적 책임 판단
- 보험금 판단
- 112/119 신고 대체
- 보험사 공식 판단 대체

## 5. Data Classification

개인정보:

- 전화번호
- 차량번호
- 사고 위치
- 사고 사진

민감하게 다룰 데이터:

- 사고 기록
- 보험사 정보
- 긴급 연락처

저장하지 않을 데이터:

- 주민등록번호
- 결제 정보
- 실제 발표용 개인정보

## 6. Feature Flags

```text
ENABLE_AI_SUMMARY=false
ENABLE_AI_FOLLOWUP=false
ENABLE_CV_ANALYSIS=false
ENABLE_YOLO_DETECTION=false
```

규칙:

- feature flag를 꺼도 기본 사고 기록과 체크리스트 추천은 동작해야 한다.
- 발표 전 불안정한 AI/CV 기능은 끈다.

## 7. Safety Constraints

AI 금지:

- 과실비율 판단
- 법적 책임 판단
- 보험금 판단
- 사고 원인 단정
- 신고 필요 여부 단정

CV 금지:

- 파손 확정
- 부상 여부 단정
- 책임 판단

표현 원칙:

- "확정" 대신 "확인 필요", "의심", "기록 권장" 표현을 사용한다.
- 최종 안내 문구는 체크리스트 DB에서 가져온다.

## 8. Core API Candidates

```text
POST /vehicles
GET /vehicles
POST /accidents
GET /accidents/{accident_id}
POST /accidents/{accident_id}/photos
GET /accidents/{accident_id}/checklist
GET /accidents/{accident_id}/summary
```

## 9. Core Tables

- `users`
- `vehicles`
- `accidents`
- `accident_photos`
- `checklist_items`
- `checklist_results`
- `accident_type_rules`

## 10. Required Test Scenarios

정상:

- 접촉사고 기록 생성
- 시설물 파손 기록 생성
- 사진 업로드 후 체크리스트 추천
- 사고 요약 조회

실패:

- 위치 권한 거부
- 사진 업로드 실패
- 잘못된 파일 업로드
- AI/CV 실패
- 네트워크 오류

권한:

- 다른 사용자의 사고 기록 조회 차단

