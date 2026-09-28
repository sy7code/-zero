# 당황Zero Implementation Roadmap

3차 발표안의 M0-M4를 구현 가능한 작업 단위로 쪼갠 로드맵이다.

## 최종 목표

Flutter 앱에서 사고 대응 시작부터 사고 기록 카드까지 3분 안에 끝나는 데모를 만들고, AI/CV가 실패해도 mock/replay로 같은 흐름을 재현한다.

## M0. 계약 정의

작업:

- `PhotoFacts`, `NextAction`, `AccidentSnapshot` JSON schema 작성
- 사진 slot 요구표 작성
- 시나리오 YAML 12개 작성
- 금지 판단 문구 목록 작성

완료 조건:

- mock PhotoFacts만으로 NextAction이 결정된다.
- `unknown`과 `no` 처리가 테스트로 분리된다.
- 과실/법적 책임/신고 필요 여부 확정 문장이 출력되지 않는다.

## M1. 흐름 완성

작업:

- Flutter 기본 앱 생성
- Hive boxes와 repository 함수 작성
- 홈, 안전 확인, 사진 요청, 사고 기록 카드 화면 연결
- Decision Core를 프론트에서 mock으로 호출

완료 조건:

- 텍스트와 mock 입력만으로 사고 기록 카드까지 도달한다.
- 앱 재시작 후 히스토리에서 기록을 다시 연다.
- 위치 권한 거부 흐름이 수동 입력으로 이어진다.

## M2. 앱 화면과 기기 기능

작업:

- 카메라 촬영/업로드 연결
- geolocator 연결
- flutter_tts 기반 무응답 안내
- share_plus 후보 연결
- 모바일 360px 화면 검증

완료 조건:

- 실제 Android 폰 또는 에뮬레이터에서 핵심 흐름이 깨지지 않는다.
- 10초 무응답 시 음성 또는 화면 강조가 동작한다.
- 전화 버튼은 자동 실행되지 않는다.

## M3. 실제 비전 후보 실험

작업:

- FastAPI `/analyze/photo`, `/next-action` 구현
- Pillow/OpenCV 품질 검사 추가
- Google Cloud Vision adapter와 replay adapter 작성
- 팀 사진 30장으로 PhotoFacts 채움률 기록

완료 조건:

- replay 모드에서 네트워크 없이 같은 결과가 나온다.
- 30장 시험 결과가 표로 기록된다.
- 채움률이 낮은 필드는 수동 질문으로 fallback된다.

## M4. 시연 준비

작업:

- 데모 fixture와 초기화 버튼 준비
- 핵심 데모 스크립트 작성
- 3회 연속 리허설
- known issues와 fallback 멘트 정리

완료 조건:

- 발표 환경에서 핵심 흐름 3회 연속 성공
- 네트워크 차단 상태에서도 replay 데모 가능
- 데모 데이터에 실제 개인정보 0개
- README에 실행 방법, 테스트 방법, known issues가 적혀 있음

## 병렬 작업 기준

- M0 계약이 끝나기 전에는 프론트/백엔드 병렬 구현을 시작하지 않는다.
- 프론트는 `NextAction` kind별 렌더링을 먼저 만든다.
- 백엔드는 `PhotoFacts`와 `NextAction` schema 검증을 먼저 만든다.
- CV 담당은 실제 모델 성능보다 mock/replay 재현성을 먼저 만든다.

## 품질 게이트

Design Gate:

- MVP must-have가 5개 이하로 유지된다.
- 범위 밖 항목이 문서화되어 있다.

Contract Gate:

- `PhotoFacts`, `NextAction`, `AccidentSnapshot` 계약이 있다.
- 실패 응답은 `code`, `message`, `request_id`를 포함한다.

Implementation Gate:

- Flutter 앱 bundle, asset, 설정 파일에 server secret이 없다.
- 민감정보 원문이 로그에 남지 않는다.
- 핵심 흐름은 AI/CV 없이 통과한다.

Demo Gate:

- 핵심 데모 3회 연속 성공
- 12개 시나리오 중 must-have 8개 이상 통과
- 비전 API 실패 시 replay 또는 manual fallback 동작
