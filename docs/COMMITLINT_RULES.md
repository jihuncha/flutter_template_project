# Commitlint 규칙

이 프로젝트에서는 [Conventional Commits](https://www.conventionalcommits.org/) 명세에 기반한 커밋 메시지 형식을 채택하고 있습니다. 이를 통해 커밋 히스토리가 읽기 쉬워지고, 자동으로 시맨틱 버전 관리를 생성할 수 있습니다.

## 커밋 메시지 형식

커밋 메시지는 다음 형식을 따라야 합니다:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### 구성 요소

1. **type(필수)**: 커밋의 유형을 나타냅니다.
2. **scope(선택)**: 커밋의 영향 범위를 나타냅니다(예: 컴포넌트명, 파일명 등).
3. **description(필수)**: 커밋의 간결한 설명.
4. **body(선택)**: 커밋의 상세한 설명.
5. **footer(선택)**: 파괴적 변경(BREAKING CHANGE) 주석이나 Issue 참조 등.

## 사용 가능한 타입

이 프로젝트에서는 다음 타입을 사용할 수 있습니다:

| 타입     | 설명                                                                                      |
| ---------- | ----------------------------------------------------------------------------------------- |
| `build`    | 빌드 시스템 또는 외부 의존성에 영향을 주는 변경(예: npm, cargo, yarn, gradle 등)       |
| `chore`    | 기타 변경(소스나 테스트 변경을 포함하지 않음)                                            |
| `ci`       | CI 설정 파일과 스크립트의 변경(예: GitHub Actions, Travis, Circle, BrowserStack 등) |
| `docs`     | 문서만의 변경                                                                    |
| `feat`     | 새로운 기능 추가                                                                              |
| `fix`      | 버그 수정                                                                                  |
| `perf`     | 성능을 향상시키는 코드 변경                                                      |
| `refactor` | 버그를 수정하지 않고 기능도 추가하지 않는 코드 변경(리팩토링)                            |
| `revert`   | 이전 커밋을 되돌리기                                                                  |
| `style`    | 코드의 의미에 영향을 주지 않는 변경(공백, 포맷, 세미콜론 누락 등)                  |
| `test`     | 누락된 테스트 추가 또는 기존 테스트의 수정                                          |

## 사용 예

### 기능 추가

```
feat: 사용자 인증 기능 추가
```

```
feat(auth): 로그인 화면 구현
```

### 버그 수정

```
fix: 내비게이션 바 스크롤 문제 수정
```

```
fix(ui): 다크 모드에서 텍스트 색상 문제 수정
```

### 문서 업데이트

```
docs: README에 설치 절차 추가
```

```
docs(api): API 엔드포인트 사용 예시 업데이트
```

### 리팩토링

```
refactor: 사용자 서비스 코드 정리
```

```
refactor(state): Riverpod 프로바이더 구조 개선
```

### 파괴적 변경을 포함한 커밋

```
feat!: API 응답 형식 변경

BREAKING CHANGE: API 응답 형식이 변경되었습니다.
기존 형식: { data: [...] }
새로운 형식: { items: [...], meta: {...} }
```

## 커밋 메시지 검증

이 프로젝트에서는 커밋 메시지가 위 규칙을 준수하는지 자동으로 검증하기 위해 [commitlint](https://commitlint.js.org/)를 사용합니다. 커밋 메시지가 규칙을 위반하는 경우 커밋이 거부됩니다.

### 로컬에서의 검증

커밋하기 전에 메시지를 검증하려면:

```bash
npx commitlint --edit
```

## 추천 사항

- 커밋 메시지는 **명령형**으로 작성하세요(예: "추가하다" 대신 "추가")
- 처음 문자는 **소문자**로 하세요
- 마지막에 마침표를 붙이지 마세요
- 설명은 간결하게, 50자 이내로 작성하세요
- 상세한 설명이 필요한 경우는 빈 줄을 두고 body에 작성하세요

## 참고 링크

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Angular Commit Message Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
- [Commitlint](https://commitlint.js.org/)
