# GitHub Issue 처리 명령어 - Claude 4 모범 사례 & TDD 통합 (No Mise Version)

**중요**: 이 명령어는 GitHub Issues를 사용한 고품질 Flutter 개발을 위해 Claude 4 모범 사례와 테스트 주도 개발 원칙을 따르는 TDD + AI Review-First 설계를 구현합니다. **이 버전은 mise를 사용하지 않고 Flutter 기본 도구만 사용합니다.**

## 개요

TDD + AI Review-First 방법론을 사용하여 GitHub Issues를 처리합니다. 이 명령어는 격리된 작업 환경을 생성하고, 구조화된 AI 리뷰 통합과 함께 Red-Green-Refactor 사이클을 적용하며, 자동화된 검증을 통해 품질 표준을 보장합니다.

## 핵심 원칙 (Claude 4 + TDD 모범 사례)

**참고 문서**:

- `docs/CLAUDE_4_BEST_PRACTICES.md`
- `docs/TEST_DRIVEN_DEVELOPMENT.md`

### TDD + AI Review-First 방법론

- **핵심 사이클**: Red (실패하는 테스트) → Green (최소 구현) → AI 리뷰 → 리팩터링 → 릴리스
- **30% 테스트 전략**: 최소 실패 테스트로 시작하여 통과하도록 구현한 다음 AI 리뷰를 통해 개선
- **접근법**: TDD 사이클에서 AI를 "주니어 디자이너"가 아닌 "시니어 리뷰어"로 사용
- **리뷰 사이클**: 리팩터링 단계에서 3-4회 반복 AI 리뷰 사이클
- **우선순위**: 보안 (HIGH) → SOLID 원칙 (MEDIUM) → 성능 (LOW)

### F.I.R.S.T. 원칙 통합

- **F**ast(빠름): 테스트는 0.1초 이내에 실행
- **I**ndependent(독립성): 테스트들은 서로 의존하지 않음
- **R**epeatable(반복 가능): 환경에 관계없이 일관된 결과
- **S**elf-validating(자체 검증): 명확한 pass/fail 결과
- **T**imely(적시성): 구현 전에 테스트 작성

### TDD 컨텍스트와 명확한 지침

- 테스트 요구사항과 구현 목표의 모호성 제거
- 구체적인 TDD 수락 기준과 품질 게이트 정의
- Red-Green-Refactor 사이클을 위한 구조화된 AI 리뷰 템플릿 제공

### TDD 중심의 구조화된 품질 평가

일관된 TDD + AI 평가 프레임워크 적용:

```
1. 테스트 품질 (F.I.R.S.T. 준수) - 검증 단계
2. 보안 취약점 (HIGH 우선순위) - AI 리뷰 단계
3. SOLID 원칙 위반 (MEDIUM 우선순위) - AI 리뷰 단계
4. 성능 최적화 (LOW 우선순위) - AI 리뷰 단계
제약 사항: 각 카테고리당 400자 이내로 결과 요약
```

## Execution Modes

### Interactive Mode (No Arguments)

```bash
/task-no-mise
```

**Behavior**:

1. Fetch Issues from GitHub using `gh issue list --assignee @me --state open`
2. Parse and categorize Issues by type:
   - **Features**: Labels containing 'enhancement', 'feature'
   - **Bugs**: Labels containing 'bug', 'bugfix'
3. Display interactive selection with Issue Template compliance indicators
4. Support multiple Issue selection with TDD readiness validation
5. Confirm selections before parallel TDD + AI Review-First execution

### Automatic Mode (With Arguments)

```bash
/task-no-mise #123 #456
```

**Behavior**:

- **No confirmation prompts** - immediate TDD + AI Review-First execution
- Validate Issue numbers and template compliance via `gh issue view`
- Check Issue Template fields (acceptance criteria, testing strategy, AI review criteria)
- Create isolated TDD work environments automatically via git worktree
- Begin background processing with Red-Green-Refactor + AI Review cycles
- Send completion notifications with TDD quality metrics

## TDD + AI Review-First Processing Flow

### Phase 1: Red - Failing Test Creation (5 minutes)

**Objective**: Create minimal failing tests following F.I.R.S.T. principles

**TDD Actions**:

- Parse Issue Template acceptance criteria and testing strategy
- **Configure Flutter test environment using direct Flutter commands**:
  ```bash
  flutter --version              # Verify Flutter installation
  flutter doctor                 # Check Flutter setup
  flutter pub get               # Install dependencies
  ```
- Create dedicated feature branch via `git worktree add .claude-workspaces/issue-{number}/`
- Write 30% tests: single behavior, minimal expectations
- Validate Issue Template compliance (functional/non-functional/security requirements)

**Quality Gates**:

- ✅ Tests fail as expected (Red state confirmed)
- ✅ Test intent clear without implementation
- ✅ F.I.R.S.T. principles followed
- ✅ Issue Template requirements translated to test cases

### Phase 2: Green - Minimal Implementation (10 minutes)

**Objective**: Make tests pass with simplest possible implementation

**Implementation Strategy Selection**:

- **Obvious**: Clear, direct implementation
- **Fake It**: Hard-coded values, then generalize
- **Triangulation**: Multiple test cases to drive abstraction

**Quality Gates**:

- ✅ All tests pass (Green state achieved)
- ✅ Minimal code changes applied
- ✅ No over-engineering or premature optimization
- ✅ Compilable, functional walking skeleton

### Phase 3: Refactor - AI Review Cycles (15 minutes, 3-4 Iterations)

**Objective**: Improve code quality through structured AI review while maintaining test success

**TDD + AI Review Template** (Use this exact format):

```
Code Review Request: [Brief description]

Implement TDD + AI Review-First methodology:

1. Test Quality Validation (F.I.R.S.T. compliance):
   - Fast: < 0.1 seconds execution
   - Independent: No test interdependencies
   - Repeatable: Consistent results
   - Self-validating: Clear pass/fail
   - Timely: Written before implementation

2. Security Analysis (HIGH Priority - Fix Immediately):
   - Hardcoded secrets/credentials scan
   - Input validation and sanitization
   - Secure data storage patterns
   - Authentication/authorization security

3. Architecture Review (MEDIUM Priority - Address Next):
   - SOLID principles compliance (SRP, OCP, LSP, ISP, DIP)
   - Design pattern consistency with project conventions
   - Code organization and separation of concerns
   - Error handling and user feedback patterns

4. Performance Review (LOW Priority - Optimize Later):
   - Algorithmic efficiency and O(n) complexity
   - Resource usage: memory, CPU, network
   - Flutter-specific: widget rebuilds, state management
   - Build performance and dependency impact

Constraints:
- Maximum 400 characters per category summary
- Provide specific file:line references
- Include actionable next steps
- Maintain test success throughout refactoring
```

**Iterative AI Review Process**:

1. **Cycle 1**: Validate F.I.R.S.T. test quality + address ALL HIGH priority security issues
2. **Cycle 2**: Fix major SOLID principle violations while preserving test success
3. **Cycle 3**: Optimize performance within feasible scope, validate test performance
4. **Final Validation**: Human review of AI recommendations + full test suite execution

**TDD Quality Gates**:

- ✅ **Test Integrity**: All tests continue to pass after each refactor iteration
- ✅ **Security**: Zero high-severity vulnerabilities identified
- ✅ **Architecture**: Major SOLID principle violations resolved
- ✅ **Performance**: Test execution < 0.1s, no obvious bottlenecks
- ✅ **F.I.R.S.T. Compliance**: All tests meet independence, repeatability criteria

### Phase 4: Release Preparation with TDD Validation

**TDD Release Actions (No Mise)**:

- Execute complete TDD validation suite using direct commands:
  ```bash
  # For Melos projects
  dart pub global activate melos
  melos run test              # All tests (unit, widget, integration)
  melos run analyze          # Static analysis (dart analyze)
  melos run format           # Code formatting (dart format)
  melos run analyze-slang    # Translation validation
  
  # Alternative: Direct Flutter commands
  flutter test                    # Run all tests
  dart analyze --fatal-infos      # Static analysis
  dart format --set-exit-if-changed .  # Format validation
  flutter pub get                 # Dependencies check
  ```
- Verify F.I.R.S.T. compliance: test independence, speed, repeatability
- Run TDD quality metrics: cycle time (Red: 5min, Green: 10min, Refactor: 15min)
- Generate test coverage report and ensure quality thresholds met
- Create Pull Request with Issue Template-compliant description
- Monitor GitHub Actions: `.github/workflows/check-pr.yml`
- Update GitHub Issue with TDD metrics and completion status
- Send completion notification with TDD quality metrics summary

**TDD Quality Gates**:

- ✅ **Complete Test Suite**: All Red-Green-Refactor cycles completed successfully
- ✅ **F.I.R.S.T. Compliance**: All tests meet speed, independence, repeatability criteria
- ✅ **Test Coverage**: Unit tests ≥90%, Widget tests ≥80%, Critical paths 100%
- ✅ **AI Review Standards**: All security, SOLID, performance criteria met
- ✅ **CI/CD Pipeline**: All GitHub Actions checks pass including test execution
- ✅ **Issue Template Compliance**: All acceptance criteria validated and documented

## Flutter Commands Integration (No Mise)

### Primary Commands (Melos + Direct Flutter)

```bash
# Environment Setup (No Mise)
flutter --version                        # Check Flutter installation
flutter doctor                          # Verify Flutter setup
dart pub global activate melos          # Install Melos globally

# Project Setup
melos bootstrap                          # Install dependencies for workspace
# Alternative: flutter pub get && cd packages/core && flutter pub get

# Code generation (freezed, riverpod, go_router, slang)
melos run gen
# Alternative: dart run build_runner build --delete-conflicting-outputs

# Static analysis
melos run analyze
# Alternative: dart analyze --fatal-infos --fatal-warnings

# Code formatting
melos run format
# Alternative: dart format . && dart format --set-exit-if-changed .

# Run tests
melos run test
# Alternative: flutter test && cd packages/core && flutter test

# Translation validation
melos run analyze-slang
# Alternative: Manual slang validation

# CI format check
dart format --set-exit-if-changed .
```

### Direct Flutter Commands (Fallback)

```bash
# Run application
flutter run -d chrome --web-port 8080
flutter run -d <device_id>              # For mobile devices

# Run tests (specific)
flutter test test/widget_test.dart       # Single test file
flutter test --coverage                  # With coverage

# Build verification
flutter build apk --debug                # Android debug build
flutter build web --debug                # Web debug build
flutter build ios --no-codesign --debug  # iOS debug build (macOS only)

# Dependencies management
flutter pub get                          # Install dependencies
flutter pub upgrade                      # Upgrade dependencies
flutter clean                           # Clean build cache
```

### Environment Setup (No Mise)

```bash
# Check Flutter environment
flutter doctor -v                       # Detailed Flutter status
flutter --version                       # Flutter version info
dart --version                          # Dart version info

# Setup development environment
flutter config --enable-web             # Enable web support
flutter config --enable-linux-desktop   # Enable Linux desktop (if needed)
flutter config --enable-macos-desktop   # Enable macOS desktop (if needed)
flutter config --enable-windows-desktop # Enable Windows desktop (if needed)
```

### Troubleshooting Guide (No Mise)

#### Flutter Environment Issues

```bash
# Verify Flutter installation
flutter doctor --verbose
flutter config --list

# Resolve Flutter issues
flutter clean
flutter pub get
flutter pub upgrade

# Reset Flutter configuration
flutter config --clear-features
flutter doctor
```

#### Version Management (No Mise)

```bash
# Use Flutter version from system PATH
which flutter                           # Check Flutter location
flutter channel                         # Check current channel
flutter channel stable                  # Switch to stable channel (if needed)
flutter upgrade                         # Upgrade Flutter

# Check Dart version compatibility
dart --version
flutter --version
```

#### Build Issues

```bash
# Clean and rebuild
flutter clean
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# For Melos projects
melos clean
melos bootstrap
melos run gen
```

## GitHub CLI Integration (Unified Approach)

**IMPORTANT**: All GitHub operations MUST use GitHub CLI (`gh`) commands. Direct GitHub API calls are deprecated.

### Issue Management Commands

```bash
# List issues with Issue Template compliance check
gh issue list --assignee @me --state open --json number,title,labels,body

# Get issue details with template field validation
gh issue view #123 --json body,title,labels | jq '.body' | grep -E "(Acceptance Criteria|Testing Strategy|AI Review)"

# Issue Template compliance validation
gh issue view #123 --json body | jq -r '.body' | grep -c "- \[ \]" # Count unchecked checkboxes

# Add TDD progress comment with metrics
gh issue comment #123 --body "TDD Progress: Red(5min) → Green(10min) → Refactor(15min). F.I.R.S.T. compliance: ✅"

# Close issue with TDD completion metrics
gh issue close #123 --comment "Fixed in PR #456. TDD Metrics: Tests(90%+), Security(✅), SOLID(✅), Performance(✅)"
```

### Pull Request Creation with Issue Template Compliance

```bash
# Create PR with Issue Template compliance validation (No Mise)
gh pr create \
  --title "$(gh issue view #123 --json title | jq -r '.title') [#123]" \
  --body "$(cat <<EOF
## Issue Template Compliance
✅ Acceptance Criteria: $(gh issue view #123 --json body | jq -r '.body' | grep -c '✅.*Acceptance')
✅ TDD Implementation: Red-Green-Refactor cycles completed
✅ F.I.R.S.T. Principles: All tests meet Fast, Independent, Repeatable, Self-validating, Timely criteria
✅ AI Review Cycles: 3-4 iterations completed (Security → SOLID → Performance)

## TDD Quality Metrics (No Mise)
- Test Coverage: Unit(≥90%), Widget(≥80%), Critical(100%)
- Cycle Time: Red(5min), Green(10min), Refactor(15min)
- Environment: Flutter $(flutter --version | head -n 1)
- AI Review Standards: Security(✅), SOLID(✅), Performance(✅)

## Build Verification
- flutter test: ✅ Passed
- dart analyze: ✅ No issues
- dart format: ✅ Formatted
- flutter build: ✅ Successful

Closes #123
EOF
)"
```

## Quality Assurance Pipeline (No Mise)

### Stage 1: Code Quality Analysis (No Mise)

```bash
# Static analysis with Flutter rules
flutter analyze --fatal-infos --fatal-warnings
dart analyze .

# Format validation
dart format --set-exit-if-changed .

# Dependencies check
flutter pub deps
flutter pub outdated
```

### Stage 2: Test Execution (No Mise)

```bash
# Run all tests
flutter test --coverage
flutter test --reporter=json > test_results.json

# Specific test types
flutter test test/unit_test/        # Unit tests only
flutter test test/widget_test.dart  # Widget tests only
flutter test integration_test/      # Integration tests (if available)
```

### Stage 3: Build Verification (No Mise)

```bash
# Multi-platform builds
flutter build apk --debug           # Android
flutter build ios --no-codesign --debug  # iOS (macOS only)  
flutter build web --debug           # Web
flutter build linux --debug         # Linux (if enabled)
```

### Stage 4: CI/CD Pipeline Integration

**GitHub Actions Workflow**: `.github/workflows/check-pr.yml`

**Monitored Checks (No Mise)**:

```yaml
# Example .github/workflows/check-pr.yml modifications for no-mise
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'  # Specify version directly
      - run: flutter --version
      - run: dart pub global activate melos
      - run: melos bootstrap
      - run: melos run gen
      - run: melos run analyze
      - run: melos run test
      - run: dart format --set-exit-if-changed .
      - run: flutter build web --debug
```

### Environment Variables (No Mise)

```bash
export ENABLE_BACKGROUND_TASKS=true
export FLUTTER_VERSION_MANAGEMENT=system  # Changed from 'mise' to 'system'
export TASK_MANAGEMENT_SYSTEM=github
export PARALLEL_DEVELOPMENT=git_worktree
export PR_LANGUAGE=korean
export COMPLETION_NOTIFICATION=alarm
export INTERACTIVE_MODE=true
export ISSUE_SELECTION_UI=enabled
export AUTO_CONFIRM_WITH_ARGS=true
export SILENT_MODE_WITH_ARGS=false
export ERROR_ONLY_OUTPUT=false
export CLAUDE_ISOLATION_MODE=true
export CLAUDE_WORKSPACE_DIR=".claude-workspaces"
export CLAUDE_MEMORY_ISOLATION=true
export GITHUB_ACTIONS_CHECK=true
export CHECK_PR_WORKFLOW="check-pr.yml"

# Flutter-specific environment variables
export FLUTTER_ROOT=$(which flutter | sed 's/\/bin\/flutter//')
export PATH=$FLUTTER_ROOT/bin:$PATH
```

## Project Dependencies and Configuration (No Mise)

### Required Technology Stack

- **Framework**: Flutter (Workspace/Monorepo structure)
- **Version Management**: System Flutter installation (no mise required)
- **Task Management**: GitHub Issues
- **Development Workflow**: git worktree for parallel development
- **State Management**: Riverpod (hooks_riverpod, riverpod_annotation)
- **Navigation**: go_router (declarative routing)
- **Internationalization**: slang (type-safe translations)
- **Build Tools**: build_runner, freezed
- **Monorepo Management**: Melos + pub workspace

### System Requirements (No Mise)

```bash
# Required system installations
flutter                              # Flutter SDK (stable channel)
dart                                # Dart SDK (included with Flutter)
git                                 # Version control
gh                                  # GitHub CLI

# Optional global packages
dart pub global activate melos      # For monorepo management
dart pub global activate build_runner  # For code generation
```

### Development Setup (No Mise)

```bash
# 1. Verify system requirements
flutter doctor -v
gh auth status
git --version

# 2. Setup Flutter environment
flutter config --enable-web
flutter channel stable
flutter upgrade

# 3. Install global dependencies
dart pub global activate melos

# 4. Clone and setup project
git clone <repository-url>
cd <project-directory>
melos bootstrap
melos run gen

# 5. Verify setup
flutter test
flutter analyze
dart format --set-exit-if-changed .
```

## Execution Examples (No Mise)

### Interactive Selection

```bash
/task-no-mise

📋 Available Issues:
1) #123: User authentication feature implementation (enhancement, @me)
2) #456: Bug fix: Login error handling (bug, @me)  
3) #789: New feature: Push notifications (enhancement, @me)

? Select Issues to process [1-3, or multiple]: 1,3
? Execute with selected Issues: #123, #789? [Y/n]: y

🚀 Starting parallel execution with AI Review-First (No Mise)...
```

### Direct Execution

```bash
/task-no-mise #123

✅ Issue validation: #123 confirmed in GitHub
✅ Workspace creation: .claude-workspaces/issue-123
✅ Git worktree: feature/issue-123
✅ Flutter environment: System Flutter $(flutter --version | head -n 1)
✅ AI Review-First: Quality standards configured
🚀 Background execution started...
📝 Implementing: User authentication feature
⏰ Completion alarm scheduled
```

## Error Handling and Recovery (No Mise)

### Flutter Environment Errors

```bash
# Flutter not found
/task-no-mise #123
❌ Error: Flutter not found in system PATH
💡 Install Flutter: https://docs.flutter.dev/get-started/install

# Flutter doctor issues  
❌ Error: Flutter doctor reported issues
💡 Run: flutter doctor -v
💡 Resolve all issues before continuing
```

### Dependency Errors

```bash
# Melos not available
❌ Error: Melos not found
🔧 Installing Melos globally...
dart pub global activate melos
✅ Melos installed successfully

# Dependencies out of sync
❌ Error: Dependencies not synchronized
🔧 Resolving dependencies...
flutter clean
flutter pub get
melos bootstrap
```

## Best Practices (No Mise)

### System Flutter Management

1. **Use Stable Channel**: `flutter channel stable`
2. **Keep Updated**: Regular `flutter upgrade`
3. **Verify Health**: `flutter doctor` before development
4. **Path Management**: Ensure Flutter bin in system PATH

### Performance Optimization

1. **Build Cache**: Use `flutter clean` judiciously
2. **Dependency Management**: Regular `flutter pub upgrade`
3. **Code Generation**: Efficient `build_runner` usage
4. **Testing**: Fast test execution with focused test suites

### Version Consistency

```bash
# Document Flutter version in project
echo "Flutter $(flutter --version)" > .flutter-version
echo "Dart $(dart --version)" >> .flutter-version

# Team consistency
flutter --version                    # Share output with team
dart --version                       # Ensure same Dart version
```

---

## TaskCommand Service Integration

이 명령어는 실제로 구현된 TaskCommand 서비스와 연결되어 동작합니다:

### 주요 기능

1. **워크스페이스 격리 검증**: `taskCommand.validateWorkspaceIsolation()`
2. **명령어 실행 프로세스**: `taskCommand.executeCommandProcess()`  
3. **기본 기능 확인**: `taskCommand.verifyBasicFunctionality()`

### 사용법 예시

```dart
// TaskCommand 서비스 사용 예시
import 'package:app/services/task_command.dart';

final taskCommand = TaskCommand();

// 워크스페이스 격리 테스트
final isolationResult = taskCommand.validateWorkspaceIsolation('.claude-workspaces');
print('Workspace isolation: $isolationResult');

// 명령어 실행 테스트
final executionResult = taskCommand.executeCommandProcess(commandId: 'test-123');
print('Command execution: $executionResult');

// 기본 기능 테스트
final functionalityResult = taskCommand.verifyBasicFunctionality();
print('Basic functionality: $functionalityResult');
```

### 실제 구현 위치

- **메인 서비스**: `app/lib/services/task_command.dart`
- **실행 로직**: `app/lib/services/task_command_executor.dart`
- **검증 로직**: `app/lib/services/task_command_validator.dart`
- **권한 관리**: `app/lib/services/task_permission_manager.dart`
- **테스트**: `app/test/task_command_test.dart` (16개 테스트)

### 품질 보증

- ✅ **17개 테스트 통과** (16개 TaskCommand + 1개 위젯)
- ✅ **F.I.R.S.T. 원칙 준수** (Fast, Independent, Repeatable, Self-validating, Timely)
- ✅ **SOLID 원칙 적용** (Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion)
- ✅ **보안 검증** (경로 보안, 입력 검증, 에러 처리)
- ✅ **성능 최적화** (캐싱, Early return, 메모리 효율성)

---

**Note**: This no-mise version maintains all quality standards and TDD + AI Review-First methodology while using system-installed Flutter tools instead of mise for version management.