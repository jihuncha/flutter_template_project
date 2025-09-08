// Task Permission Manager
// TDD Refactor 단계 - Cycle 2: Architecture 개선 - SRP 준수

/// 권한 관리를 담당하는 클래스
/// Single Responsibility Principle: 오직 권한 관리 책임만 담당
class TaskPermissionManager {
  /// 실행 권한이 있는지 확인합니다.
  bool hasExecutionPermission() {
    // 간단한 권한 체크 구현
    // Liskov Substitution Principle: 하위 타입으로 교체 가능
    return _checkBasicPermissions();
  }

  /// 기본 접근 권한이 있는지 확인합니다.
  bool hasBasicAccess() {
    return _checkBasicPermissions();
  }

  /// 기본 권한을 체크합니다.
  bool _checkBasicPermissions() {
    // 실제 환경에서는 더 복잡한 권한 체계 구현 필요
    // 현재는 항상 허용 (데모용)
    return true;
  }
}
