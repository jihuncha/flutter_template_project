# .claude/CLAUDE.md - 로컬 Claude Code 설정

이 파일은 특정 워크스페이스 내에서 작업할 때 Claude Code에 로컬 지침을 제공하며, 루트 레벨의 CLAUDE.md 설정을 오버라이드합니다.

## 명령어 인수 검증 워크플로우

`.claude/commands/`에서 정의된 명령어를 실행할 때 다음 워크플로우가 적용됩니다:

### 인수 검증 규칙

**인수가 필요한 명령어의 경우:**

1. **인수 확인**: 필수 인수가 제공되었는지 확인
2. **인수 누락 시 동작**:
   - 오류 메시지 표시: `⏺ Please provide required arguments`
   - 종료 이유를 로그에 기록
   - **"Update Todos" 단계 건너뛰기**
   - **처리를 즉시 종료**
   - **명령어 실행을 계속하지 않음**

3. **인수 제공 시**: 일반적인 명령어 처리를 계속

### 구현 패턴

```bash
# 명령어 실행 패턴
if [[ -z "${REQUIRED_ARG}" ]]; then
    echo "⏺ Please provide required arguments"
    echo "📝 Terminating: Missing required arguments"
    exit 0
fi

# 명령어 처리를 계속...
```

## 루트 CLAUDE.md 오버라이드

**중요**: 이 로컬 `.claude/CLAUDE.md` 설정은 프로젝트 루트에 위치한 루트 레벨 CLAUDE.md 파일을 **오버라이드**하고 **무시**합니다.

- 루트 CLAUDE.md 경로: `CLAUDE.md` (무시됨)
- 로컬 CLAUDE.md 경로: `.claude/CLAUDE.md` (활성)

## 명령어별 규칙

### /file-to-issue 명령어

**필수 인수**: 파일 경로

**검증 워크플로우**:

```bash
if [[ -z "${FILE_PATH}" ]]; then
    echo "⏺ Please provide a file path as an argument"
    echo "📝 Skipping Update Todos phase due to missing file path"
    exit 0
fi
```

### 향후 명령어

`.claude/commands/` 디렉토리에서 정의되는 모든 명령어는 동일한 인수 검증 패턴을 구현해야 합니다:

1. 필수 인수 확인
2. 누락 시 조기 종료
3. todos/정리 단계 건너뛰기
4. 종료 이유 로그 기록

## 워크스페이스 격리

이 워크스페이스는 루트 프로젝트 설정과 격리되어 동작합니다:

- **독립적인 명령어 실행**
- **분리된 메모리/컨텍스트**
- **로컬 전용 설정 규칙**
- **루트 레벨 지침 오버라이드**

## 우선순위

설정 우선순위 (높은 순):

1. `.claude/CLAUDE.md` (이 파일) - **최고 우선순위**
2. `.claude/commands/*.md` - 명령어별 설정
3. 로컬 환경 변수
4. 루트 CLAUDE.md - **이 워크스페이스에서는 무시됨**

---

**참고**: 이 설정은 루트 프로젝트 설정에서 워크스페이스 격리를 유지하면서 모든 커스텀 명령어에서 일관된 인수 검증을 보장합니다.
