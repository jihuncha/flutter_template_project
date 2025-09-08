# Claude Code 로컬 설정

**워크스페이스 고유의 Claude Code 설정과 인수 검증 워크플로우**

이 디렉토리는 프로젝트 내의 Claude Code 고유 설정과 커스텀 명령어를 관리합니다.

## 문서 구조

이 `.claude/` 디렉토리는 다음 문서 체계를 따릅니다:

### CLAUDE.md - README.md 1:1 대응

- **[CLAUDE.md](CLAUDE.md)**: Claude Code용 로컬 워크스페이스 설정
- **[README.md](README.md)**: 인간을 위한 Claude Code 설정 설명 (본 문서)
- **1:1 관계**: CLAUDE.md의 각 섹션은 이 README.md에서 대응하는 인간용 설명을 가집니다

## コマンド引数検証ワークフロー

`.claude/commands/`で定義されたコマンドを実行する際、以下のワークフローが適用されます：

### 引数検証ルール

**引数が必要なコマンドの場合：**

1. **引数チェック**: 必須引数が提供されているかを確認
2. **引数不足時の動作**:
   - エラーメッセージ表示: `⏺ Please provide required arguments`
   - 終了理由をログ記録
   - **「Todos更新」フェーズをスキップ**
   - **処理を即座に終了**
   - **コマンド実行を継続しない**

3. **引数提供時**: 通常のコマンド処理を継続

### 実装パターン

```bash
# コマンド実行パターン
if [[ -z "${REQUIRED_ARG}" ]]; then
    echo "⏺ Please provide required arguments"
    echo "📝 Terminating: Missing required arguments"
    exit 0
fi

# コマンド処理を継続...
```

## 루트 CLAUDE.md 오버라이드

**중요**: 이 로컬 `.claude/CLAUDE.md` 설정은 프로젝트 루트 레벨의 CLAUDE.md 파일을 **오버라이드**하고 **무시**합니다.

- 루트 CLAUDE.md 경로: `CLAUDE.md` (무시됨)
- 로컬 CLAUDE.md 경로: `.claude/CLAUDE.md` (활성)

## 명령어별 규칙

### /task 명령어

**필수 인수**: GitHub Issue 번호 또는 ID

**검증 워크플로우**:

```bash
if [[ -z "${ISSUE_ID}" ]]; then
    echo "⏺ Please provide an Issue ID as an argument"
    echo "📝 Skipping Update Todos phase due to missing Issue ID"
    exit 0
fi
```

### 향후 명령어

`.claude/commands/` 디렉토리에서 정의되는 모든 명령어는 동일한 인수 검증 패턴을 구현해야 합니다:

1. 필수 인수 확인
2. 부족 시 조기 종료
3. todos/정리 단계 스킵
4. 종료 이유 로그 기록

## ワークスペース分離

このワークスペースは、ルートプロジェクト設定から分離されて動作します：

- **独立したコマンド実行**
- **分離されたメモリ/コンテキスト**
- **ローカル専用設定ルール**
- **ルートレベル指示のオーバーライド**

## 우선순위

설정의 우선순위 (높은 순):

1. `.claude/CLAUDE.md` (이 파일) - **최고 우선순위**
2. `.claude/commands/*.md` - 명령어별 설정
3. 로컬 환경 변수
4. 루트 CLAUDE.md - **이 워크스페이스에서는 무시**

## 커스텀 명령어

### 명령어 디렉토리 구조

```
.claude/
├── CLAUDE.md          # Claude Code 설정 (AI용)
├── README.md          # 인간용 설명 (본 문서)
└── commands/          # 커스텀 명령어 정의
    ├── task.md        # GitHub Issue 처리 명령어
    └── [future].md    # 향후 명령어
```

### 사용 가능한 명령어

- **`/task`**: GitHub Issue 처리 명령어 (자세한 내용은 `commands/task.md` 참조)

## 개발자 가이드

### 새 명령어 추가

새로운 커스텀 명령어를 추가할 때:

1. `commands/` 디렉토리에 새로운 `.md` 파일 생성
2. 인수 검증 워크플로우 구현
3. 명령어별 로직 정의
4. 문서 업데이트

### 인수 검증 구현

모든 명령어에서 일관된 인수 검증 구현:

```bash
# 필수 인수 확인 예시
if [[ $# -eq 0 ]] || [[ -z "$1" ]]; then
    echo "⏺ Please provide required arguments"
    echo "📝 Command terminated due to missing arguments"
    exit 0
fi

# 명령어 처리를 계속
echo "✅ Arguments provided, proceeding with command execution"
```

## 문제 해결

### 일반적인 문제

1. **명령어가 실행되지 않음**
   - 필수 인수가 제공되었는지 확인
   - 로컬 CLAUDE.md 설정을 확인

2. **설정이 반영되지 않음**
   - 로컬 설정이 루트 설정을 오버라이드하고 있는지 확인
   - 워크스페이스 분리가 적절히 동작하고 있는지 확인

3. **인수 검증이 동작하지 않음**
   - 명령어 정의 파일의 인수 검증 로직을 확인
   - 적절한 종료 코드가 설정되어 있는지 확인

## 설정 검증

로컬 설정이 올바르게 동작하는지 확인하려면:

```bash
# 명령어의 인수 없이 실행 테스트
/task
# 예상되는 출력: "⏺ Please provide required arguments"

# 명령어의 인수와 함께 실행 테스트
/task ISSUE-123
# 예상되는 동작: 일반적인 명령어 처리
```

---

**참고**: 이 설정을 통해 모든 커스텀 명령어에서 일관된 인수 검증을 보장하고, 루트 프로젝트 설정에서 워크스페이스 분리를 유지합니다.
