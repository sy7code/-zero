# 22. Privacy Data Harness

이 문서는 개인정보, 민감정보, 테스트 데이터, 데모 데이터를 관리하는 데이터 보호 하네스다.

## 1. Entry Criteria

다음 중 하나라도 해당하면 이 하네스를 적용한다.

- 사용자 계정이 있다.
- 위치, 사진, 연락처, 식별자, 결제, 건강, 사고 기록 등 개인 관련 데이터가 있다.
- 외부 평가자에게 데이터를 보여준다.
- AI/ML 모델 입력으로 사용자 데이터가 들어간다.

## 2. Required Outputs

- Data Inventory
- Data Classification
- Demo Data Policy
- Retention and Deletion Rule
- Access Control Notes
- Logging and Masking Rule

## 3. Data Classification

기본 분류:

- Public: 공개되어도 영향이 없는 데이터
- Internal: 프로젝트 내부에서만 쓰는 데이터
- Personal: 개인을 식별하거나 연결할 수 있는 데이터
- Sensitive: 사고, 건강, 금융, 법률, 위치, 사진 등 노출 시 피해가 큰 데이터
- Secret: API key, token, password, private key

## 4. Measurable Defaults

Data Inventory:

- 저장되는 데이터 필드는 모두 inventory에 적는다.
- 각 필드는 classification, purpose, owner, retention을 가진다.

Demo Data:

- 외부 평가용 데이터에는 실제 개인정보 0개를 요구한다.
- 전화번호, 차량번호, 이메일, 주소, 위치는 모두 가짜 데이터 또는 마스킹 데이터를 사용한다.
- 실제 사진을 쓰면 얼굴, 번호판, 위치 단서가 없는지 확인한다.

Retention:

- MVP/평가 프로젝트는 테스트 데이터 보관 기간을 30일 이하로 둔다.
- 보관 기간을 넘기면 삭제하거나 익명화한다.

Logging:

- secret 로그는 0개여야 한다.
- 개인정보 원문 로그는 0개여야 한다.
- 디버그가 필요하면 request_id로 추적한다.

## 5. Privacy Gate

다음 조건을 만족해야 외부 평가에 데이터를 사용한다.

- data inventory가 작성되었다.
- demo data에 실제 개인정보가 없다.
- 로그에 개인정보 원문이 없다.
- secret이 repository와 client bundle에 없다.
- 데이터 삭제 또는 초기화 방법이 문서화되었다.

실패 시 조치:

- 데모 데이터를 재생성한다.
- 로그를 마스킹한다.
- 노출 가능성이 있으면 키를 회전하고 영향 범위를 기록한다.

