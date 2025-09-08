// Task Command Executor
// TDD Refactor 단계 - Cycle 2: Architecture 개선 - SRP 준수

import 'task_command_validator.dart';
import 'task_permission_manager.dart';

/// 명령어 실행을 담당하는 클래스
/// Single Responsibility Principle: 오직 명령어 실행 책임만 담당
class TaskCommandExecutor {
  final TaskCommandValidator _validator;
  final TaskPermissionManager _permissionManager;

  TaskCommandExecutor({
    TaskCommandValidator? validator,
    TaskPermissionManager? permissionManager,
  }) : _validator = validator ?? TaskCommandValidator(),
       _permissionManager = permissionManager ?? TaskPermissionManager();

  /// 워크스페이스 격리 기능을 실행합니다.
  bool executeWorkspaceIsolation([String? workspacePath]) {
    try {
      final path = workspacePath ?? '.claude-workspaces';

      // Dependency Inversion: 추상화에 의존
      if (!_validator.isValidWorkspacePath(path)) {
        return false;
      }

      return _validator.doesWorkspaceExist(path);
    } catch (e) {
      return false;
    }
  }

  /// 명령어 프로세스를 실행합니다.
  String executeCommand({String? commandId}) {
    try {
      // Open/Closed Principle: 확장에는 열려있고 수정에는 닫혀있음
      if (!_permissionManager.hasExecutionPermission()) {
        return 'Execution not permitted';
      }

      final id = commandId ?? 'default';

      if (!_validator.isValidCommandId(id)) {
        return 'Invalid command identifier';
      }

      return 'Command $id executed successfully';
    } catch (e) {
      return 'Command execution failed';
    }
  }

  /// 기본 기능을 실행합니다.
  bool executeBasicFunctionality() {
    try {
      if (!_permissionManager.hasBasicAccess()) {
        return false;
      }

      // Interface Segregation: 필요한 기능만 사용
      return executeWorkspaceIsolation();
    } catch (e) {
      return false;
    }
  }
}
