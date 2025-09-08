// Task Command Validator
// TDD Refactor 단계 - Cycle 3: Performance 개선 - 메모리 최적화

import 'dart:io' show Directory;

/// 워크스페이스와 명령어의 유효성을 검증하는 클래스
///
/// Performance improvements applied:
/// - RegExp 인스턴스 재사용을 위한 캐싱
/// - 불필요한 객체 생성 최소화
/// - Early return 패턴으로 연산 최적화
class TaskCommandValidator {
  static const String _allowedWorkspacePrefix = '.claude-workspaces';

  // Performance: RegExp 인스턴스 캐싱으로 메모리 사용량 최적화
  static final RegExp _commandIdPattern = RegExp(r'^[a-zA-Z0-9\-_]+$');

  // Performance: 현재 디렉토리 경로 캐싱
  static String? _currentPath;
  static String get _getCurrentPath {
    return _currentPath ??= Directory.current.path;
  }

  /// 워크스페이스 경로가 유효한지 검증합니다.
  ///
  /// Performance: Early return 패턴으로 불필요한 연산 방지
  bool isValidWorkspacePath(String path) {
    // Performance: 가장 빈번한 실패 케이스부터 확인
    if (path.isEmpty) return false;

    // 보안: 상위 디렉토리 접근 방지
    if (path.contains('..') || path.startsWith('/')) {
      return false;
    }

    // 보안: 허용된 경로 패턴 검증
    return path.contains(_allowedWorkspacePrefix);
  }

  /// 워크스페이스 디렉토리가 존재하는지 확인합니다.
  ///
  /// Performance: 캐시된 경로와 최적화된 경로 계산
  bool doesWorkspaceExist(String path) {
    try {
      // Performance: 조건부 경로 계산 최적화
      final actualPath = _getCurrentPath.contains('.claude-workspaces')
          ? '../$path'
          : path;

      return Directory(actualPath).existsSync();
    } catch (e) {
      return false;
    }
  }

  /// 명령어 ID가 유효한지 검증합니다.
  ///
  /// Performance: 캐시된 RegExp 인스턴스 사용 및 Early return
  bool isValidCommandId(String id) {
    // Performance: 길이 검사를 먼저 수행 (빠른 실패)
    if (id.isEmpty || id.length > 50) return false;

    // Performance: 캐시된 RegExp 인스턴스 재사용
    return _commandIdPattern.hasMatch(id);
  }

  /// 캐시를 초기화합니다 (테스트 환경에서 사용)
  static void clearCache() {
    _currentPath = null;
  }
}
