# Prompt Review Command - Claude 4 Best Practices

**IMPORTANT**: This command implements AI Review-First design following Claude 4 best practices for automated prompt and code quality evaluation with Korean reporting.

## Overview

Evaluate files according to Claude 4 best practices and provide comprehensive Korean evaluation. This command reads local files passed as arguments, analyzes content based on structured review templates, and creates detailed review files without external references.

## Core Principles (Claude 4 Best Practices)

**Scope**: Local file evaluation only - no external references

### AI Review-First Methodology

- **Pattern**: File input → Critical review → Structured evaluation → Korean report
- **Approach**: Use AI as "Senior Reviewer" for comprehensive quality assessment
- **Cycles**: Multi-perspective evaluation (Security → SOLID → Performance)
- **Priority**: Security (High) → SOLID Principles (Medium) → Performance (Low)

### Clear Instructions

- Eliminate ambiguity in evaluation criteria
- Define specific quality metrics and deliverables
- Provide structured review templates for consistent assessment

### Structured Quality Assessment

Apply consistent evaluation framework:

```
1. 보안 취약점 (고우선도) - Security vulnerabilities assessment
2. SOLID 원칙 위반 (중우선도) - SOLID principle violations analysis
3. 성능 최적화 (저우선도) - Performance optimization opportunities
제약: 각 카테고리 400자 이내로 요약
```

## Execution Modes

### Interactive Mode (No Arguments)

```bash
/prompt-review
```

**Behavior**:

1. **Argument Validation**: Check if file path is provided
2. **Early Termination**: If no arguments, display "⏺ 파일 경로를 인수로 제공해 주세요" in red and terminate immediately
3. **No further processing** when no arguments provided

### Direct Mode (With File Path)

```bash
/prompt-review path/to/file.md
```

**Behavior**:

- **No confirmation prompts** - immediate execution
- Validate file path and accessibility
- Begin content evaluation automatically
- Generate structured Korean review report

## AI Review-First Processing Flow

### Phase 1: File Processing and Initial Analysis

**Objective**: Secure file access and content parsing

**Actions**:

1. **File Access Validation**: Verify file exists and is readable with security checks
2. **Content Analysis**: Parse and analyze content structure
3. **Context Detection**: Identify file type and content category
4. **Initial Quality Check**: Validate content against Claude 4 best practices

**Quality Gate**: Successfully parsed content ready for evaluation

### Phase 2: Multi-Perspective Evaluation

**Review Template** (Use this exact format):

```
다음 내용을 Claude 4 베스트 프랙티스에 따라 리뷰해 주세요.

평가 카테고리:
1. 보안 취약점 (고우선도) - 보안 위험, 입력 검증, 인증 인가
2. SOLID 원칙 위반 (중우선도) - 설계 원칙, 아키텍처 패턴, 유지보수성
3. 성능 최적화 (저우선도) - 효율성, 확장성, 리소스 사용

제약: 각 카테고리 400자 이내로 구체적이고 실행 가능한 피드백 제공.
가장 우선순위가 높은 문제에 초점을 맞춰 주세요.
```

**Evaluation Process**:

1. **고우선도 평가**: 보안 취약점의 포괄적 분석
2. **중우선도 평가**: SOLID 원칙과 아키텍처 설계의 검증
3. **저우선도 평가**: 성능 최적화 기회의 특정
4. **종합 평가**: 전체적인 품질 점수와 개선 제안

**Quality Gates**:

- Security: 중대한 보안 위험의 특정과 평가
- Architecture: 설계 원칙 위반의 검출과 개선 제안
- Performance: 최적화 기회의 특정과 구현 제안

### Phase 3: Korean Review Report Generation

**Actions**:

1. **Review File Creation**: Generate `.review.<extension>` file with structured Korean evaluation
2. **Quality Score Calculation**: Comprehensive quality assessment with numeric scoring
3. **Improvement Recommendations**: Specific, actionable improvement suggestions
4. **Best Practice References**: Links to relevant Claude 4 best practices documentation

**Quality Gate**: High-quality Korean review report with actionable insights

## Enhanced Core Implementation

### 1. Secure File Reading and Validation

```typescript
// Enhanced security-first file access with comprehensive validation
import { resolve, relative, join, extname, isAbsolute } from 'path'
import { stat, readFile } from 'fs/promises'

const ALLOWED_EXTENSIONS = [
  '.md',
  '.txt',
  '.js',
  '.ts',
  '.dart',
  '.py',
  '.java',
  '.json',
  '.yaml',
  '.yml',
]
const MAX_FILE_SIZE = 50 * 1024 * 1024 // 50MB
const WORK_DIRECTORY = process.env.WORK_DIRECTORY || '.'

async function validateAndReadFile(
  filePath: string
): Promise<{ content: string; extension: string }> {
  // Input sanitization - prevent malicious file access
  if (!filePath || /[\x00-\x1f\x7f-\x9f]/.test(filePath)) {
    throw new SecurityError(
      '액세스 거부: 잘못된 파일 경로 문자가 포함되어 있습니다'
    )
  }

  // Resolve absolute path and validate
  const resolvedPath = resolve(filePath)
  const workDir = resolve(WORK_DIRECTORY)
  const relativePath = relative(workDir, resolvedPath)

  // Enhanced path validation - prevent directory traversal
  if (
    relativePath.startsWith('..') ||
    isAbsolute(relativePath) ||
    relativePath.includes('..')
  ) {
    throw new SecurityError(
      '액세스 거부: 디렉토리 트래버샴 공격 시도가 감지되었습니다'
    )
  }

  // Validate file extension
  const ext = extname(filePath).toLowerCase()
  if (!ALLOWED_EXTENSIONS.includes(ext)) {
    throw new ValidationError(`지원되지 않는 파일 확장자: ${ext}`)
  }

  // Check file size and permissions
  const stats = await stat(resolvedPath)
  if (stats.size > MAX_FILE_SIZE) {
    throw new ValidationError(
      `파일 크기가 너무 큽니다: ${stats.size} bytes`
    )
  }

  // Read with encoding validation
  const content = await readFile(resolvedPath, { encoding: 'utf8' })
  return { content, extension: ext }
}
```

### 2. Claude 4 Best Practices Evaluator

```typescript
// Comprehensive evaluation engine based on Claude 4 best practices
interface EvaluationResult {
  category: 'security' | 'solid' | 'performance'
  priority: 'high' | 'medium' | 'low'
  score: number // 0-100
  issues: Issue[]
  recommendations: string[]
  bestPracticeReferences: string[]
}

interface Issue {
  severity: 'critical' | 'major' | 'minor'
  description: string
  location?: string
  suggestion: string
}

class Claude4BestPracticesEvaluator {
  private readonly securityPatterns = [
    /password\s*=\s*['""].+['"]/gi,
    /api_key\s*=\s*['""].+['"]/gi,
    /token\s*=\s*['""].+['"]/gi,
    /eval\s*\(/gi,
    /exec\s*\(/gi,
    /innerHTML\s*=/gi,
  ]

  private readonly solidViolationPatterns = [
    /class\s+\w+[^{]*{[^}]*}[^}]*{/gs, // God classes (rough heuristic)
    /function\s+\w+\([^)]*\)[^{]*{(?:[^{}]*{[^{}]*})*[^{}]*}/gs, // Long functions
  ]

  async evaluateContent(
    content: string,
    extension: string
  ): Promise<EvaluationResult[]> {
    const results: EvaluationResult[] = []

    // High Priority: Security Evaluation
    results.push(await this.evaluateSecurity(content, extension))

    // Medium Priority: SOLID Principles Evaluation
    results.push(await this.evaluateSOLIDPrinciples(content, extension))

    // Low Priority: Performance Evaluation
    results.push(await this.evaluatePerformance(content, extension))

    return results
  }

  private async evaluateSecurity(
    content: string,
    extension: string
  ): Promise<EvaluationResult> {
    const issues: Issue[] = []
    const recommendations: string[] = []

    // Check for hardcoded secrets
    this.securityPatterns.forEach((pattern, index) => {
      const matches = content.match(pattern)
      if (matches) {
        issues.push({
          severity: 'critical',
          description: '하드코딩된 기밀 정보가 감지되었습니다',
          suggestion: '환경 변수나 보안 설정 파일을 사용해 주세요',
        })
      }
    })

    // Check for SQL injection patterns
    if (content.includes('query') && content.includes('+')) {
      issues.push({
        severity: 'major',
        description: 'SQL 인젝션 가능성이 있습니다',
        suggestion: '매개변수화된 쿼리를 사용해 주세요',
      })
    }

    // Calculate security score
    const criticalCount = issues.filter(i => i.severity === 'critical').length
    const majorCount = issues.filter(i => i.severity === 'major').length
    const score = Math.max(0, 100 - criticalCount * 40 - majorCount * 20)

    if (score < 70) {
      recommendations.push('보안 감사 실시를 강력히 추천합니다')
    }
    if (criticalCount > 0) {
      recommendations.push(
        '중대한 보안 문제를 즉시 수정해 주세요'
      )
    }

    return {
      category: 'security',
      priority: 'high',
      score,
      issues,
      recommendations,
      bestPracticeReferences: [
        '보안 베스트 프랙티스',
        '보안 코딩 원칙',
      ],
    }
  }

  private async evaluateSOLIDPrinciples(
    content: string,
    extension: string
  ): Promise<EvaluationResult> {
    const issues: Issue[] = []
    const recommendations: string[] = []

    // Single Responsibility Principle check
    const classMatches = content.match(/class\s+(\w+)/g)
    if (classMatches) {
      classMatches.forEach(match => {
        const className = match.split(' ')[1]
        // Simple heuristic: check if class has multiple concerns
        if (
          content.includes(`${className}`) &&
          content.split(className).length > 5
        ) {
          issues.push({
            severity: 'minor',
            description: `클래스 ${className} 가 여러 책임을 가지고 있을 가능성이 있습니다`,
            suggestion:
              '단일 책임 원칙에 따라 클래스를 분할하는 것을 검토해 주세요',
          })
        }
      })
    }

    // Open/Closed Principle check
    if (
      content.includes('instanceof') ||
      content.includes('switch') ||
      content.includes('case')
    ) {
      issues.push({
        severity: 'minor',
        description: '확장에 대해 폐쇄되어 있을 가능성이 있습니다',
        suggestion:
          '다형성이나 Strategy 패턴 사용을 검토해 주세요',
      })
    }

    const score = Math.max(0, 100 - issues.length * 15)

    if (score < 80) {
      recommendations.push('SOLID 원칙의 적용을 검토해 주세요')
    }

    return {
      category: 'solid',
      priority: 'medium',
      score,
      issues,
      recommendations,
      bestPracticeReferences: ['SOLID 설계 원칙', '객체 지향 설계 패턴'],
    }
  }

  private async evaluatePerformance(
    content: string,
    extension: string
  ): Promise<EvaluationResult> {
    const issues: Issue[] = []
    const recommendations: string[] = []

    // Check for performance anti-patterns
    if (content.includes('n+1') || content.includes('nested loop')) {
      issues.push({
        severity: 'major',
        description: '성능 문제가 감지되었습니다',
        suggestion: '알고리즘 최적화나 캐시 사용을 검토해 주세요',
      })
    }

    // Check for large file indicators
    if (content.length > 10000) {
      issues.push({
        severity: 'minor',
        description: '파일 크기가 너무 큽니다',
        suggestion: '파일의 분할이나 모듈화를 검토해 주세요',
      })
    }

    const score = Math.max(0, 100 - issues.length * 10)

    if (score < 85) {
      recommendations.push('성능 최적화의 기회가 있습니다')
    }

    return {
      category: 'performance',
      priority: 'low',
      score,
      issues,
      recommendations,
      bestPracticeReferences: ['성능 최적화 기법'],
    }
  }
}
```

### 3. Korean Review Report Generator

```typescript
// Comprehensive Korean review report generator
class KoreanReviewReportGenerator {
  async generateReport(
    filePath: string,
    evaluationResults: EvaluationResult[],
    originalContent: string
  ): Promise<string> {
    const timestamp = new Date().toLocaleString('ja-JP', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      hour: '2-digit',
      minute: '2-digit',
      second: '2-digit',
    })

    const overallScore = this.calculateOverallScore(evaluationResults)
    const qualityRating = this.getQualityRating(overallScore)

    return `# Claude 4 베스트 프랙티스 리뷰 리포트

## 기본 정보

- **파일**: ${filePath}
- **리뷰 일시**: ${timestamp}
- **종합 점수**: ${overallScore}/100 (${qualityRating})
- **리뷰 기준**: Claude 4 베스트 프랙티스(로컬 평가)

## 평가 요약

${this.generateScoreSummary(evaluationResults)}

## 상세 평가

${evaluationResults.map(result => this.generateDetailedEvaluation(result)).join('\n\n')}

## 종합적인 개선 제안

### 즉시 대응해야 할 항목 (고우선도)

${this.getHighPriorityRecommendations(evaluationResults)}

### 개선을 검토해야 할 항목 (중우선도)

${this.getMediumPriorityRecommendations(evaluationResults)}

### 최적화의 기회 (저우선도)

${this.getLowPriorityRecommendations(evaluationResults)}

## Claude 4 베스트 프랙티스 적용도

### AI 리뷰 퍼스트 설계에의 적합성

${this.evaluateAIReviewFirstCompliance(originalContent)}

### 프롬프트 엔지니어링 원칙에의 준수

${this.evaluatePromptEngineeringCompliance(originalContent)}

## 참고 자료

- Claude 4 베스트 프랙티스(로컬 평가 기준)
- AI 리뷰 퍼스트 설계 기법
- 보안·SOLID 원칙·성능 평가 프레임워크

## 리뷰어 정보

- **리뷰어**: Claude Code AI Review System
- **버전**: Claude 4 Best Practices v1.0
- **리뷰 방법**: 자동화된 AI 리뷰 퍼스트 기법

---

*이 리포트는 Claude 4 베스트 프랙티스에 기반하여 자동 생성되었습니다.*
*상세한 개선안에 대해서는 사람에 의한 최종 검증을 추천합니다.*`
  }

  private calculateOverallScore(results: EvaluationResult[]): number {
    const weights = { high: 0.5, medium: 0.3, low: 0.2 }
    let totalScore = 0
    let totalWeight = 0

    results.forEach(result => {
      const weight = weights[result.priority]
      totalScore += result.score * weight
      totalWeight += weight
    })

    return Math.round(totalScore / totalWeight)
  }

  private getQualityRating(score: number): string {
    if (score >= 90) return '우수'
    if (score >= 80) return '양호'
    if (score >= 70) return '보통'
    if (score >= 60) return '개선 필요'
    return '대폭 개선 필요'
  }

  private generateScoreSummary(results: EvaluationResult[]): string {
    return results
      .map(result => {
        const categoryName = {
          security: '보안',
          solid: 'SOLID 원칙',
          performance: '성능',
        }[result.category]

        const priorityName = {
          high: '고우선도',
          medium: '중우선도',
          low: '저우선도',
        }[result.priority]

        return `- **${categoryName}** (${priorityName}): ${result.score}/100`
      })
      .join('\n')
  }

  private generateDetailedEvaluation(result: EvaluationResult): string {
    const categoryName = {
      security: '보안 취약점 평가',
      solid: 'SOLID 원칙 평가',
      performance: '성능 평가',
    }[result.category]

    let report = `### ${categoryName}\n\n`
    report += `**점수**: ${result.score}/100\n\n`

    if (result.issues.length > 0) {
      report += `**감지된 문제**:\n\n`
      result.issues.forEach((issue, index) => {
        const severityEmoji = {
          critical: '🔴',
          major: '🟡',
          minor: '🔵',
        }[issue.severity]

        report += `${index + 1}. ${severityEmoji} **${issue.description}**\n`
        report += `   - 개선 제안: ${issue.suggestion}\n`
        if (issue.location) {
          report += `   - 위치: ${issue.location}\n`
        }
        report += '\n'
      })
    } else {
      report += `✅ 이 분야에서는 문제가 감지되지 않았습니다.\n\n`
    }

    if (result.recommendations.length > 0) {
      report += `**추천 사항**:\n\n`
      result.recommendations.forEach((rec, index) => {
        report += `${index + 1}. ${rec}\n`
      })
      report += '\n'
    }

    return report
  }

  private getHighPriorityRecommendations(results: EvaluationResult[]): string {
    const highPriorityItems = results
      .filter(r => r.priority === 'high')
      .flatMap(r => r.issues.filter(i => i.severity === 'critical'))
      .map(i => `- ${i.description}: ${i.suggestion}`)

    return highPriorityItems.length > 0
      ? highPriorityItems.join('\n')
      : '- 고우선도 문제가 감지되지 않았습니다.'
  }

  private getMediumPriorityRecommendations(
    results: EvaluationResult[]
  ): string {
    const mediumPriorityItems = results
      .filter(r => r.priority === 'medium')
      .flatMap(r => r.recommendations)
      .map(rec => `- ${rec}`)

    return mediumPriorityItems.length > 0
      ? mediumPriorityItems.join('\n')
      : '- 중우선도 개선 항목이 없습니다.'
  }

  private getLowPriorityRecommendations(results: EvaluationResult[]): string {
    const lowPriorityItems = results
      .filter(r => r.priority === 'low')
      .flatMap(r => r.recommendations)
      .map(rec => `- ${rec}`)

    return lowPriorityItems.length > 0
      ? lowPriorityItems.join('\n')
      : '- 저우선도 최적화 기회가 없습니다.'
  }

  private evaluateAIReviewFirstCompliance(content: string): string {
    const patterns = [
      { pattern: /작은 초안|소규모 초안|draft/gi, point: '최소 구현의 개념' },
      { pattern: /리뷰|review/gi, point: '리뷰 사이클의 구현' },
      { pattern: /반복|반복적|iteration/gi, point: '반복적 개선 프로세스' },
      {
        pattern: /보안|시큐리티|security/gi,
        point: '보안 우선 접근법',
      },
    ]

    const foundPatterns = patterns.filter(p => content.match(p.pattern))
    const score = (foundPatterns.length / patterns.length) * 100

    let compliance = `**적합도**: ${Math.round(score)}%\n\n`

    if (foundPatterns.length > 0) {
      compliance += `**확인된 베스트 프랙티스**:\n`
      foundPatterns.forEach(p => {
        compliance += `- ✅ ${p.point}\n`
      })
    }

    const missingPatterns = patterns.filter(p => !content.match(p.pattern))
    if (missingPatterns.length > 0) {
      compliance += `\n**개선의 여지**:\n`
      missingPatterns.forEach(p => {
        compliance += `- ❌ ${p.point}\n`
      })
    }

    return compliance
  }

  private evaluatePromptEngineeringCompliance(content: string): string {
    const principles = [
      {
        pattern: /명확.*지시|명확한.*지시|clear.*instruction/gi,
        point: '명확하고 구체적인 지시',
      },
      { pattern: /구조화|체계적|structured/gi, point: '구조화된 포맷' },
      { pattern: /컴텍스트|맥락|context/gi, point: '컴텍스트의 제공' },
      { pattern: /예시|예제|example/gi, point: '실예의 활용' },
    ]

    const foundPrinciples = principles.filter(p => content.match(p.pattern))
    const score = (foundPrinciples.length / principles.length) * 100

    let compliance = `**준수도**: ${Math.round(score)}%\n\n`

    if (foundPrinciples.length > 0) {
      compliance += `**확인된 원칙**:\n`
      foundPrinciples.forEach(p => {
        compliance += `- ✅ ${p.point}\n`
      })
    }

    const missingPrinciples = principles.filter(p => !content.match(p.pattern))
    if (missingPrinciples.length > 0) {
      compliance += `\n**강화해야 할 원칙**:\n`
      missingPrinciples.forEach(p => {
        compliance += `- ❌ ${p.point}\n`
      })
    }

    return compliance
  }
}
```

### 4. Main Command Orchestrator

```typescript
// Main command orchestrator with enhanced error handling
class PromptReviewCommand {
  constructor(
    private fileValidator: FileValidator,
    private evaluator: Claude4BestPracticesEvaluator,
    private reportGenerator: KoreanReviewReportGenerator
  ) {}

  async execute(filePath?: string): Promise<string> {
    // Enhanced argument validation - exit early if no file path provided
    if (!filePath || filePath.trim() === '') {
      console.log('\x1b[31m⏺ 파일 경로를 인수로 제공해 주세요\x1b[0m')
      console.log('사용예: /prompt-review ./path/to/file.md')
      process.exit(0)
    }

    try {
      // Phase 1: Secure file processing
      console.log(`📖 파일을 읽는 중: ${filePath}`)
      const { content, extension } =
        await this.fileValidator.validateAndRead(filePath)

      // Phase 2: Claude 4 best practices evaluation
      console.log('🔍 Claude 4 베스트 프랙티스에 기반한 평가를 실행 중...')
      const evaluationResults = await this.evaluator.evaluateContent(
        content,
        extension
      )

      // Phase 3: Generate Korean review report
      console.log('📝 한국어 리뷰 리포트를 생성 중...')
      const reviewReport = await this.reportGenerator.generateReport(
        filePath,
        evaluationResults,
        content
      )

      // Phase 4: Create review file
      const reviewFilePath = await this.createReviewFile(
        filePath,
        reviewReport,
        extension
      )

      // Phase 5: Display summary
      const overallScore = this.calculateOverallScore(evaluationResults)
      console.log(`✅ 리뷰 완료: ${reviewFilePath}`)
      console.log(`📊 종합 점수: ${overallScore}/100`)

      return reviewFilePath
    } catch (error) {
      this.handleError(error)
      throw error
    }
  }

  private async createReviewFile(
    originalPath: string,
    reviewContent: string,
    extension: string
  ): Promise<string> {
    // Generate review file path
    const parsedPath = path.parse(originalPath)
    const reviewFilePath = path.join(
      parsedPath.dir,
      `${parsedPath.name}.review${extension}`
    )

    // Write review file
    await writeFile(reviewFilePath, reviewContent, { encoding: 'utf8' })
    console.log(`📁 리뷰 파일을 생성: ${reviewFilePath}`)

    return reviewFilePath
  }

  private calculateOverallScore(results: EvaluationResult[]): number {
    const weights = { high: 0.5, medium: 0.3, low: 0.2 }
    let totalScore = 0
    let totalWeight = 0

    results.forEach(result => {
      const weight = weights[result.priority]
      totalScore += result.score * weight
      totalWeight += weight
    })

    return Math.round(totalScore / totalWeight)
  }

  private handleError(error: Error): void {
    console.error('❌ エラー:', error.message)

    if (error.name === 'SecurityError') {
      console.error('🔒 セキュリティ検証に失敗しました')
    } else if (error.name === 'ValidationError') {
      console.error('⚠️ 入力検証に失敗しました')
    } else {
      console.error('💥 예상치 못한 오류가 발생했습니다')
    }
  }
}
```

## Enhanced Security Requirements

### File Access Controls

- **Path Validation**: Only allow files within accessible directory structure
- **Extension Whitelist**: Support multiple programming languages and documentation formats
- **Size Limits**: Maximum 50MB file size with performance considerations
- **Permission Check**: Verify read permissions and prevent unauthorized access
- **Input Sanitization**: Comprehensive protection against malicious input patterns

### Content Analysis Security

- **Pattern Matching**: Safe regex patterns for security vulnerability detection
- **Memory Management**: Efficient processing for large files
- **Error Handling**: Secure error messages without sensitive information exposure
- **Rate Limiting**: Protection against excessive resource usage

## Usage Examples

### Basic File Review

```bash
/prompt-review ./docs/CLAUDE_4_BEST_PRACTICES.md

📖 파일을 읽는 중: ./docs/CLAUDE_4_BEST_PRACTICES.md
🔍 Claude 4 베스트 프랙티스에 기반한 평가를 실행 중...
📝 한국어 리뷰 리포트를 생성 중...
📁 리뷰 파일을 생성: ./docs/CLAUDE_4_BEST_PRACTICES.review.md
✅ 리뷰 완료: ./docs/CLAUDE_4_BEST_PRACTICES.review.md
📊 종합 점수: 85/100
```

### Code File Review

```bash
/prompt-review ./app/lib/main.dart

📖 파일을 읽는 중: ./app/lib/main.dart
🔍 Claude 4 베스트 프랙티스에 기반한 평가를 실행 중...
📝 한국어 리뷰 리포트를 생성 중...
📁 리뷰 파일을 생성: ./app/lib/main.review.dart
✅ 리뷰 완료: ./app/lib/main.review.dart
📊 종합 점수: 78/100
```

### No Arguments Example

```bash
/prompt-review

⏺ 파일 경로를 인수로 제공해 주세요
使用例: /prompt-review ./path/to/file.md
```

## Error Handling and Recovery

### File Access Errors

```bash
/prompt-review nonexistent.md
❌ 오류: 파일 'nonexistent.md'를 찾을 수 없습니다
💡 正しいファイルパスを使用してください
```

### Invalid File Extension

```bash
/prompt-review file.exe
❌ 오류: 지원되지 않는 파일 확장자: .exe
💡 サポートされている拡張子: .md, .txt, .js, .ts, .dart, .py, .java, .json, .yaml, .yml
```

### Security Violations

```bash
/prompt-review ../../etc/passwd
❌ エラー: アクセス拒否: ディレクトリトラバーサル攻撃の試行が検出されました
🔒 セキュリティ検証に失敗しました
```

## Best Practices and Limitations

### Optimal Use Cases

- **Documentation files** requiring Claude 4 best practices compliance check
- **Code files** needing security and architecture review
- **Configuration files** requiring validation
- **Prompt templates** needing quality assessment
- **Project guidelines** requiring best practices alignment

### Limitations

- **Binary files** are not supported (only text-based files)
- **Very large files** (>50MB) require manual splitting
- **Language-specific** analysis may need domain expertise
- **Context-dependent** evaluation may require human validation

### Success Factors

1. **Clear file structure** with consistent formatting
2. **Meaningful content** with sufficient detail for evaluation
3. **Proper file permissions** for read access
4. **Standard file extensions** for accurate analysis
5. **Claude 4 best practices knowledge** for interpretation

## Configuration Requirements

### Environment Variables

```bash
export WORK_DIRECTORY="."
export MAX_FILE_SIZE_MB=50
export SUPPORTED_EXTENSIONS=".md,.txt,.js,.ts,.dart,.py,.java,.json,.yaml,.yml"
export REVIEW_LANGUAGE="korean"
export ENABLE_SECURITY_CHECKS=true
```

### File Structure Requirements

```
project-root/
├── .claude/
│   └── commands/
│       └── prompt-review.md
├── docs/
│   └── CLAUDE_4_BEST_PRACTICES.md
└── reviews/ (created automatically)
```

---

**Note**: This enhanced command provides comprehensive evaluation based on Claude 4 best practices with secure file handling, multi-perspective analysis, and detailed Korean reporting.
