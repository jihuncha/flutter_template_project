// Task Command Service
// /task-no-mise 명령어의 핵심 기능을 구현합니다.
// TDD Refactor 단계 - Cycle 2: Architecture 개선 - SOLID 원칙 준수

import 'task_command_executor.dart';

/// TaskCommand 클래스는 /task-no-mise 명령어의 Facade 역할을 합니다.
///
/// Architecture improvements applied (SOLID Principles):
/// - Single Responsibility: 오직 API facade 역할만 담당
/// - Open/Closed: 확장에는 열려있고 수정에는 닫혀있음
/// - Liskov Substitution: 하위 타입으로 교체 가능한 구조
/// - Interface Segregation: 클라이언트가 필요한 기능만 노출
/// - Dependency Inversion: 구체 클래스가 아닌 추상화에 의존
class TaskCommand {
  final TaskCommandExecutor _executor;

  /// Dependency Injection을 통한 느슨한 결합
  TaskCommand({TaskCommandExecutor? executor})
    : _executor = executor ?? TaskCommandExecutor();

  /// 워크스페이스 격리 기능을 확인합니다.
  ///
  /// Facade Pattern: 복잡한 하위 시스템을 간단한 인터페이스로 노출
  bool validateWorkspaceIsolation([String? workspacePath]) {
    return _executor.executeWorkspaceIsolation(workspacePath);
  }

  /// 명령어 실행 프로세스를 검증합니다.
  ///
  /// Single Responsibility: 오직 요청을 위임하는 역할
  String executeCommandProcess({String? commandId}) {
    return _executor.executeCommand(commandId: commandId);
  }

  /// 기본 기능 확인을 수행합니다.
  ///
  /// Interface Segregation: 클라이언트가 사용하지 않는 기능에 의존하지 않음
  bool verifyBasicFunctionality() {
    return _executor.executeBasicFunctionality();
  }
}
