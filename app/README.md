# 당황Zero Flutter Prototype

Flutter SDK가 설치된 환경에서 아래 순서로 실행한다.

```powershell
cd app
flutter create . --platforms=android
flutter pub get
flutter run
```

Android 실행 전 `android/app/src/main/AndroidManifest.xml`에 카메라와 위치 권한을 추가한다.

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

## Prototype Scope

- 사고 대응 시작
- 위치/시각 기록
- 안전 확인
- 버튼형 질문
- 사진 slot 기록
- 사고 기록 카드
- Hive 로컬 저장

서버와 비전 API는 아직 연결하지 않고 mock PhotoFacts와 규칙 기반 NextAction으로 흐름을 보여준다.

## Visual Direction

화면 구조는 3차 자료의 데모 화면을 따른다.

- 홈: 버튼 하나로 시작
- 안전 확인: 질문 하나와 버튼 셋
- 촬영 안내: 가이드 틀과 이유 한 줄
- 긴급 화면: 빨강 전용, 전화는 직접 누름
- 사고 기록 카드: 누락/건너뛴 사진과 진행 로그 표시
