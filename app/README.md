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
