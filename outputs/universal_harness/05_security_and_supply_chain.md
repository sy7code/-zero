# 05. Security and Supply Chain

## 1. Secure Development Baseline

모든 프로젝트는 다음 보안 기준을 기본으로 둔다.

- secret은 코드에 저장하지 않는다.
- 최소 권한 원칙을 따른다.
- 사용자 입력은 서버에서 검증한다.
- 인증과 인가를 분리해서 확인한다.
- 개인정보는 최소 수집한다.
- 로그에 민감정보를 남기지 않는다.
- 에러 응답에 내부 정보를 노출하지 않는다.
- 외부 연동 실패를 예상하고 fallback을 둔다.

## 2. Secret Management

규칙:

- `.env`는 Git에 올리지 않는다.
- `.env.example`만 공유한다.
- client 앱에는 server secret을 넣지 않는다.
- 배포 환경 secret은 배포 플랫폼의 secret manager를 사용한다.
- 노출 의심 시 즉시 키를 회전한다.

검증:

- secret scan
- `.gitignore` 확인
- client bundle 또는 앱 설정 확인

## 3. Authentication and Authorization

규칙:

- 인증은 사용자가 누구인지 확인한다.
- 인가는 해당 리소스에 접근할 수 있는지 확인한다.
- 모든 사용자 소유 리소스 조회/수정/삭제에는 owner check를 둔다.
- 관리자 기능은 별도 권한으로 분리한다.

검증:

- 로그인하지 않은 요청
- 다른 사용자 리소스 접근
- 권한 없는 수정/삭제

## 4. Input Validation

검증 대상:

- 문자열 길이
- enum 값
- 숫자 범위
- 날짜 형식
- URL 형식
- 파일 확장자
- MIME type
- 파일 크기

규칙:

- 프론트 검증은 사용자 경험용이다.
- 실제 보안 검증은 서버에서 한다.

## 5. File Upload Security

규칙:

- 허용 확장자 목록을 둔다.
- MIME type을 검사한다.
- 파일 크기를 제한한다.
- 원본 파일명으로 저장하지 않는다.
- UUID 또는 해시 기반 이름을 사용한다.
- 공개 접근 여부를 명시적으로 정한다.
- 실행 가능한 파일은 업로드하지 못하게 한다.

## 6. Dependency and Supply Chain

규칙:

- 사용하지 않는 dependency를 추가하지 않는다.
- dependency 추가 이유를 PR에 적는다.
- lockfile을 유지한다.
- 취약점 스캔이 가능하면 실행한다.
- 빌드와 배포는 재현 가능하게 만든다.

권장 검증:

- dependency audit
- lockfile 변경 리뷰
- build script 리뷰
- CI에서 test/build 실행

## 7. Build Integrity

규칙:

- release artifact는 CI에서 생성하는 것을 우선한다.
- 빌드 스크립트는 repository에 기록한다.
- 수동 빌드 산출물을 출처 없이 배포하지 않는다.
- 배포된 버전과 commit을 연결한다.

## 8. Logging and Observability

로그에 남길 것:

- 요청 ID
- 사용자 ID 또는 익명화된 식별자
- 처리 결과
- 오류 유형
- 처리 시간

로그에 남기지 말 것:

- 비밀번호
- API key
- 토큰
- 주민번호 등 고유식별정보
- 카드 정보
- 필요 이상의 위치 정보
- 민감한 원문 입력

## 9. AI/ML Security Extension

AI/ML 프로젝트는 추가로 확인한다.

- 모델 입력에 민감정보가 포함되는가
- 모델 출력이 검증 없이 사용자에게 전달되는가
- hallucination이 위험한 행동으로 이어지는가
- prompt 또는 system instruction이 외부에 노출되는가
- 외부 모델 API 비용과 rate limit이 관리되는가
- 모델 실패 시 fallback이 있는가

