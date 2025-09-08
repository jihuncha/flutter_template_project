#!/usr/bin/env dart

// TaskCommand 서비스 테스트 스크립트
// 사용법: dart scripts/test_task_command.dart

import '../app/lib/services/task_command.dart';

void main(List<String> args) {
  print('🧪 TaskCommand 서비스 테스트 시작...\n');
  
  final taskCommand = TaskCommand();
  
  // 1. 워크스페이스 격리 테스트
  print('1️⃣ 워크스페이스 격리 검증 테스트:');
  
  // 유효한 경우
  final validResult = taskCommand.validateWorkspaceIsolation('.claude-workspaces');
  print('   ✅ 유효한 경로 (.claude-workspaces): $validResult');
  
  // 무효한 경우
  final invalidResult = taskCommand.validateWorkspaceIsolation('../etc');
  print('   ❌ 무효한 경로 (../etc): $invalidResult');
  
  print('');
  
  // 2. 명령어 실행 프로세스 테스트
  print('2️⃣ 명령어 실행 프로세스 테스트:');
  
  // 유효한 명령어 ID
  final validCommand = taskCommand.executeCommandProcess(commandId: 'test-123');
  print('   ✅ 유효한 명령어 (test-123): $validCommand');
  
  // 기본 명령어
  final defaultCommand = taskCommand.executeCommandProcess();
  print('   🔧 기본 명령어: $defaultCommand');
  
  print('');
  
  // 3. 기본 기능 확인 테스트
  print('3️⃣ 기본 기능 확인 테스트:');
  
  final functionalityResult = taskCommand.verifyBasicFunctionality();
  print('   ✅ 기본 기능 확인: $functionalityResult');
  
  print('');
  
  // 4. 인터랙티브 명령어 처리
  if (args.isNotEmpty) {
    final command = args[0];
    print('4️⃣ 사용자 명령어 처리:');
    
    switch (command.toLowerCase()) {
      case 'validate':
        final path = args.length > 1 ? args[1] : '.claude-workspaces';
        final result = taskCommand.validateWorkspaceIsolation(path);
        print('   📁 경로 검증 ($path): $result');
        break;
        
      case 'execute':
        final id = args.length > 1 ? args[1] : null;
        final result = taskCommand.executeCommandProcess(commandId: id);
        print('   ⚡ 명령어 실행 ($id): $result');
        break;
        
      case 'check':
        final result = taskCommand.verifyBasicFunctionality();
        print('   🔍 기본 기능 확인: $result');
        break;
        
      default:
        print('   ❓ 알 수 없는 명령어: $command');
        print('   💡 사용 가능한 명령어: validate, execute, check');
    }
  } else {
    print('4️⃣ 사용법 안내:');
    print('   dart scripts/test_task_command.dart validate [경로]');
    print('   dart scripts/test_task_command.dart execute [명령어ID]');
    print('   dart scripts/test_task_command.dart check');
  }
  
  print('\n🎉 TaskCommand 서비스 테스트 완료!');
}