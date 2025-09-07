# Maestro 테스트 프레임워크와 Flutter 앱 통합

## 목적

Flutter 앱에서 UI 테스트 자동화를 구현하고, FloatingActionButton 탭 동작을 검증한다

## 절차

1. **Maestro CLI 설치**
2. **테스트 설정 파일 생성**
3. **실행과 검증**

## 예시

실제 카운터 앱에서 FloatingActionButton 테스트를 실행

---

## 1. Maestro CLI 설치

### 설치 명령어

```bash
# Maestro CLI 설치 (macOS/Linux)
curl -sL https://get.maestro.mobile.dev/install.sh | bash

# 경로 설정
export PATH="$PATH":"$HOME/.maestro/bin"
```

### 설치 확인

```bash
# 설치 확인
maestro --version

# 사용 가능한 명령어 표시
maestro --help
```

**전문용어 설명:**

- **Maestro**: Flutter나 React Native 앱용 UI 테스트 자동화 도구
- **CLI**: Command Line Interface (명령줄 인터페이스)

---

## 2. 테스트 설정 파일 생성

### 디렉터리 구조

```
project-root/
├── maestro/                    # Maestro 테스트 설정
│   └── counter_test.yaml      # 카운터 테스트 설정
├── .env.maestro              # 환경변수 설정
└── app/
    └── lib/pages/home/
        └── home_page.dart    # 테스트 대상 화면
```

### 환경변수 설정 (.env.maestro)

```bash
# 애플리케이션 설정
APP_ID=com.example.app
MAESTRO_TIMEOUT=30000
MAESTRO_LOG_LEVEL=INFO
```

### 테스트 설정 파일 (maestro/counter_test.yaml)

```yaml
appId: ${APP_ID}
---
- launchApp
- assertVisible: 'Flutter Demo Home Page'
- assertVisible: '카운터: 0'
- tapOn:
    id: 'FloatingActionButton'
- assertVisible: '카운터: 1'
- tapOn:
    id: 'FloatingActionButton'
- assertVisible: '카운터: 2'
```

### Widget 측 대응 (app/lib/pages/home/home_page.dart)

```dart
// FloatingActionButton에 Key 식별자 추가
floatingActionButton: FloatingActionButton(
  key: const Key('FloatingActionButton'),  // ← 이 라인 추가
  onPressed: _incrementCounter,
  tooltip: 'Increment',
  child: const Icon(Icons.add),
),
```

**전문용어 설명:**

- **Key**: Flutter에서 Widget 식별에 사용하는 고유 식별자
- **assertVisible**: 화면상에 지정 요소가 표시되는지 검증
- **tapOn**: 지정 요소를 탭하는 조작

---

## 3. 실행과 검증

### 테스트 실행 절차

```bash
# 1. 앱 시작 (디바이스/에뮬레이터에서)
cd app
flutter run

# 2. 별도 터미널에서 Maestro 테스트 실행
maestro test --env='APP_ID=com.example.app' maestro/counter_test.yaml
```

### 실행 성공 예시

```
✅ Launch app com.example.app
✅ Assert visible "Flutter Demo Home Page"
✅ Assert visible "카운터: 0"
✅ Tap on FloatingActionButton
✅ Assert visible "카운터: 1"
✅ Tap on FloatingActionButton
✅ Assert visible "카운터: 2"

Flow completed successfully 🎉
```

### 자주 발생하는 문제와 대처법

| 문제                | 원인                        | 대처법                                  |
| ------------------- | --------------------------- | --------------------------------------- |
| `App not found`     | 앱이 시작되지 않음          | `flutter run`으로 앱을 먼저 시작         |
| `Element not found` | Key 식별자가 설정되지 않음  | Widget에 `key: const Key('이름')` 추가 |
| `Timeout`           | 앱 응답이 느림              | `.env.maestro`에서 타임아웃 시간 연장  |

---

## 4. 고급 활용 예시

### 다중 화면 테스트

```yaml
appId: ${APP_ID}
---
- launchApp
- assertVisible: 'Flutter Demo Home Page'

# 홈 화면에서의 테스트
- tapOn:
    id: 'FloatingActionButton'
- assertVisible: '카운터: 1'

# 설정 화면으로 이동 테스트
- tapOn:
    id: 'SettingsButton'
- assertVisible: '설정'
- tapOn: '뒤로'
- assertVisible: 'Flutter Demo Home Page'
```

### 조건분기 테스트

```yaml
# 카운터가 특정 값일 때의 동작 테스트
- runFlow:
    when:
      visible: '카운터: 5'
    commands:
      - assertVisible: '최대값에 도달했습니다'
```

---

## 5. CI/CD 파이프라인 통합

### GitHub Actions 예시

```yaml
name: Maestro UI Tests
on: [push, pull_request]

jobs:
  ui-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v3

      - name: Setup Flutter
        uses: subosito/flutter-action@v2

      - name: Install Maestro
        run: curl -sL https://get.maestro.mobile.dev/install.sh | bash

      - name: Build app
        run: |
          cd app
          flutter build apk --debug

      - name: Start emulator
        run: # 에뮬레이터 시작 명령어

      - name: Run Maestro tests
        run: |
          export PATH="$PATH":"$HOME/.maestro/bin"
          maestro test maestro/
```

---

## 6. 개발팀용 모범 사례

### 테스트 작성 시 주의사항

1. **식별자 일관성**: 모든 테스트 대상 Widget에는 명확한 Key 설정
2. **테스트 독립성**: 각 테스트 파일은 독립적으로 실행 가능하게 구성
3. **대기시간 최적화**: 불필요한 대기는 피하고, 필요한 부분에만 타임아웃 설정

### 팀 개발에서의 활용

```mermaid
flowchart LR
    A[개발자] --> B[Widget 구현]
    B --> C[Key 식별자 추가]
    C --> D[Maestro 테스트 생성]
    D --> E[PR 생성]
    E --> F[CI/CD에서 테스트 실행]
    F --> G[병합]
```

### 효과적인 테스트 전략

- **단계적 도입**: 중요 화면부터 순차적으로 테스트 추가
- **회귀 테스트**: 수정 후 기존 기능 동작 확인
- **크로스 플랫폼**: iOS/Android 양쪽에서 동작 검증

---

## 요약

**오늘부터 실행할 수 있는 3단계:**

1. **Maestro CLI 설치** (5분): 개발환경에 도구 도입
2. **테스트 설정 생성** (15분): YAML 파일과 Widget Key 설정
3. **테스트 실행 확인** (10분): 실제 동작 검증

**처음에는 하나의 버튼 테스트부터 시작해서, 단계적으로 복잡한 시나리오로 확장함으로써 확실하게 UI 테스트 자동화를 도입할 수 있습니다. 팀 전체의 개발 효율성 향상과 버그 검출 정확도 향상을 실현합니다.**