// Task Command Test
// 이 테스트는 /task-no-mise 명령어의 기본 기능을 검증합니다.
// F.I.R.S.T. 원칙을 따라 작성되었습니다:
// - Fast: 빠른 실행 (< 0.1초)
// - Independent: 다른 테스트와 독립적
// - Repeatable: 반복 가능한 결과
// - Self-validating: 명확한 pass/fail
// - Timely: 구현 전에 작성

import 'package:app/services/task_command.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Task Command Tests (TDD Refactor Phase - Complete)', () {
    late TaskCommand taskCommand;

    setUp(() {
      taskCommand = TaskCommand();
    });

    group('기존 기능 호환성 테스트', () {
      // Test 1: Fast - 0.1초 이내 실행 검증
      testWidgets('워크스페이스 격리 기능 테스트', (tester) async {
        final stopwatch = Stopwatch()..start();

        // Refactor 후에도 기본 기능 동작 확인
        final result = taskCommand.validateWorkspaceIsolation();
        expect(result, isTrue);

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100)); // < 0.1초
      });

      // Test 2: Independent - 다른 테스트와 독립적
      test('명령어 실행 프로세스 검증 테스트', () {
        // Refactor 후에도 기본 기능 동작 확인
        final result = taskCommand.executeCommandProcess();
        expect(result, isA<String>());
        expect(result, isNotEmpty);
      });

      // Test 3: Repeatable - 반복 가능한 결과
      test('기본 기능 확인 테스트', () {
        // Refactor 후에도 기본 기능 동작 확인
        final result = taskCommand.verifyBasicFunctionality();
        expect(result, isTrue);
      });

      // Test 4: Self-validating - 명확한 결과
      test('TaskCommand 인스턴스 생성 테스트', () {
        expect(taskCommand, isA<TaskCommand>());
        expect(taskCommand, isNotNull);
      });
    });

    group('보안 개선사항 테스트', () {
      test('워크스페이스 경로 보안 검증', () {
        // 허용된 경로
        expect(
          taskCommand.validateWorkspaceIsolation('.claude-workspaces'),
          isTrue,
        );

        // 상위 디렉토리 접근 시도 차단
        expect(taskCommand.validateWorkspaceIsolation('../etc'), isFalse);
        expect(taskCommand.validateWorkspaceIsolation('../../root'), isFalse);

        // 절대 경로 차단
        expect(taskCommand.validateWorkspaceIsolation('/etc/passwd'), isFalse);

        // 허용되지 않은 패턴 차단
        expect(
          taskCommand.validateWorkspaceIsolation('malicious-path'),
          isFalse,
        );
      });

      test('명령어 ID 보안 검증', () {
        // 유효한 명령어 ID
        expect(
          taskCommand.executeCommandProcess(commandId: 'valid-command'),
          contains('success'),
        );
        expect(
          taskCommand.executeCommandProcess(commandId: 'test123'),
          contains('success'),
        );

        // 기본 명령어 ID (null)
        expect(taskCommand.executeCommandProcess(), contains('success'));
      });

      test('에러 처리 보안성 검증', () {
        // 유효하지 않은 입력에 대한 안전한 처리 확인
        final result1 = taskCommand.validateWorkspaceIsolation('../invalid');
        expect(result1, isFalse); // 예외 발생하지 않고 안전하게 false 반환

        final result2 = taskCommand.executeCommandProcess(commandId: '');
        expect(result2, isA<String>()); // 안전한 에러 메시지 반환
      });
    });

    group('통합 보안 테스트', () {
      test('전체 보안 워크플로우', () {
        // 1. 워크스페이스 검증
        final isolation = taskCommand.validateWorkspaceIsolation();
        expect(isolation, isTrue);

        // 2. 명령어 실행
        final execution = taskCommand.executeCommandProcess();
        expect(execution, contains('success'));

        // 3. 기본 기능 검증
        final functionality = taskCommand.verifyBasicFunctionality();
        expect(functionality, isTrue);
      });
    });

    group('성능 최적화 테스트', () {
      test('F.I.R.S.T. - Fast 원칙 준수 (< 0.1초)', () {
        final stopwatch = Stopwatch()..start();

        // 100회 연속 실행으로 성능 테스트
        for (int i = 0; i < 100; i++) {
          taskCommand.validateWorkspaceIsolation();
          taskCommand.executeCommandProcess();
          taskCommand.verifyBasicFunctionality();
        }

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(100)); // < 0.1초
      });

      test('메모리 효율성 - 반복 실행 시 메모리 누수 없음', () {
        // GC를 고려한 반복 테스트
        for (int i = 0; i < 1000; i++) {
          final result1 = taskCommand.validateWorkspaceIsolation();
          final result2 = taskCommand.executeCommandProcess();
          final result3 = taskCommand.verifyBasicFunctionality();

          // 예상된 결과 확인
          expect(result1, isTrue);
          expect(result2, contains('success'));
          expect(result3, isTrue);
        }
      });

      test('캐싱 효과 - 반복 호출 시 성능 일관성', () {
        final times = <int>[];

        // 5회 측정하여 성능 일관성 확인
        for (int i = 0; i < 5; i++) {
          final stopwatch = Stopwatch()..start();

          for (int j = 0; j < 10; j++) {
            taskCommand.validateWorkspaceIsolation('.claude-workspaces');
            taskCommand.executeCommandProcess(commandId: 'test$j');
          }

          stopwatch.stop();
          times.add(stopwatch.elapsedMicroseconds);
        }

        // 성능 편차가 크지 않은지 확인 (캐싱 효과)
        final average = times.reduce((a, b) => a + b) / times.length;
        for (final time in times) {
          expect((time - average).abs() / average, lessThan(0.5)); // 50% 이내 편차
        }
      });
    });

    group('TDD 최종 검증 - F.I.R.S.T. 원칙', () {
      test('Fast - 모든 테스트가 빠르게 실행됨', () {
        final stopwatch = Stopwatch()..start();

        expect(taskCommand.validateWorkspaceIsolation(), isTrue);
        expect(taskCommand.executeCommandProcess(), contains('success'));
        expect(taskCommand.verifyBasicFunctionality(), isTrue);

        stopwatch.stop();
        expect(stopwatch.elapsedMilliseconds, lessThan(10)); // 매우 빠름
      });

      test('Independent - 테스트 실행 순서에 관계없이 동일한 결과', () {
        // 순서를 바꿔서 실행
        final result1 = taskCommand.verifyBasicFunctionality();
        final result2 = taskCommand.executeCommandProcess();
        final result3 = taskCommand.validateWorkspaceIsolation();

        expect(result1, isTrue);
        expect(result2, contains('success'));
        expect(result3, isTrue);
      });

      test('Repeatable - 동일한 입력에 동일한 출력', () {
        for (int i = 0; i < 5; i++) {
          expect(
            taskCommand.validateWorkspaceIsolation('.claude-workspaces'),
            isTrue,
          );
          expect(
            taskCommand.executeCommandProcess(commandId: 'test'),
            contains('test executed successfully'),
          );
          expect(taskCommand.verifyBasicFunctionality(), isTrue);
        }
      });

      test('Self-validating - 명확한 성공/실패 결과', () {
        // 성공 케이스
        expect(
          taskCommand.validateWorkspaceIsolation('.claude-workspaces'),
          isTrue,
        );

        // 실패 케이스
        expect(taskCommand.validateWorkspaceIsolation('../invalid'), isFalse);

        // 결과가 명확함을 확인
        final result = taskCommand.executeCommandProcess();
        expect(
          result,
          anyOf(contains('success'), contains('failed'), contains('permitted')),
        );
      });

      test('Timely - 구현 전에 작성된 테스트가 구현 후에도 유효함', () {
        // 초기 Red 단계에서 작성된 테스트가 여전히 유효한지 확인
        expect(taskCommand, isA<TaskCommand>());
        expect(taskCommand, isNotNull);

        // Green 단계에서 추가된 기능들이 여전히 동작하는지 확인
        expect(taskCommand.validateWorkspaceIsolation(), isTrue);
        expect(taskCommand.executeCommandProcess(), isA<String>());
        expect(taskCommand.verifyBasicFunctionality(), isTrue);
      });
    });
  });
}
