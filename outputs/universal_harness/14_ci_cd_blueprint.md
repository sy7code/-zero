# 14. CI/CD Blueprint

이 문서는 자동 검증 파이프라인을 만들 때 참고하는 예시다. 프로젝트 기술 스택에 맞게 필요한 부분만 사용한다.

## 1. CI에서 반드시 확인할 것

최소 권장:

- formatting 또는 lint
- test
- build 또는 import check
- secret scan
- dependency lockfile 변경 확인

추가 권장:

- type check
- API contract test
- migration check
- security test
- E2E smoke test

## 2. Backend CI 예시

Python/FastAPI 기준 예시:

```yaml
name: backend-ci

on:
  pull_request:
  push:
    branches: [main]

jobs:
  backend:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-python@v5
        with:
          python-version: "3.11"

      - name: Install dependencies
        run: |
          python -m pip install --upgrade pip
          pip install -r requirements.txt

      - name: Import check
        run: |
          python -m compileall .

      - name: Run tests
        run: |
          pytest
```

## 3. Flutter CI 예시

```yaml
name: flutter-ci

on:
  pull_request:
  push:
    branches: [main]

jobs:
  flutter:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          flutter-version: "stable"

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze
        run: flutter analyze

      - name: Test
        run: flutter test
```

## 4. Secret Scan 예시

간단한 방어선:

```yaml
name: secret-scan

on:
  pull_request:

jobs:
  secret-scan:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Check env files
        run: |
          if git ls-files | grep -E '(^|/)\\.env($|\\.)'; then
            echo "Do not commit .env files"
            exit 1
          fi

      - name: Check common secret patterns
        run: |
          if grep -RInE '(api[_-]?key|secret|token|password)\\s*=\\s*[^\\s]+' . --exclude-dir=.git; then
            echo "Potential secret found"
            exit 1
          fi
```

실제 현업에서는 Gitleaks, TruffleHog 같은 전용 도구 사용을 권장한다.

## 5. PR Gate Policy

PR merge 조건 예시:

- backend CI 통과
- frontend CI 통과
- secret scan 통과
- 최소 1명 리뷰 승인
- 테스트 근거 작성
- 보안 영향 있음이면 Security Reviewer 확인

## 6. Release Pipeline

권장 흐름:

```text
merge to main
  -> CI
  -> build artifact
  -> smoke test
  -> deploy
  -> post-deploy health check
  -> rollback if health check fails
```

## 7. Rollback 기준

즉시 rollback 또는 feature flag off:

- 로그인 불가
- 핵심 API 5xx 급증
- 데이터 저장 실패
- 개인정보 노출 가능성
- 결제 또는 권한 문제
- AI/ML 기능이 위험한 출력을 반복

