// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:app/i18n/translations.g.dart' as app_translations;
import 'package:app/pages/home_page.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  setUpAll(() {
    // Initialize AppLogger for all tests
    if (!AppLogger.isInitialized) {
      AppLogger.initialize(LoggerConfig.development());
    }
  });

  group('Basic Widget Tests', () {
    testWidgets('Counter increments smoke test', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );
    });
  });

  group('Decrement Counter Tests (TDD - Red Phase)', () {
    testWidgets('should render decrement button', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Act & Assert
      expect(find.byIcon(Icons.remove), findsOneWidget);
      expect(find.byTooltip('Decrement'), findsOneWidget);
    });

    testWidgets('should decrement counter when decrement button tapped', (
      tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // First increment to 1
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Act
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Assert
      expect(find.textContaining('0'), findsOneWidget);
    });

    testWidgets('should allow negative counter values', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Act - tap decrement from initial 0
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Assert
      expect(find.textContaining('-1'), findsOneWidget);
    });

    testWidgets(
      'should maintain state during increment/decrement combination',
      (tester) async {
        // Arrange
        await tester.pumpWidget(
          ProviderScope(
            child: app_translations.TranslationProvider(
              child: const MaterialApp(home: HomePage()),
            ),
          ),
        );

        // Act - complex sequence
        await tester.tap(find.byIcon(Icons.add)); // +1
        await tester.pump();
        await tester.tap(find.byIcon(Icons.add)); // +2
        await tester.pump();
        await tester.tap(find.byIcon(Icons.remove)); // +1
        await tester.pump();

        // Assert
        expect(find.textContaining('1'), findsOneWidget);
      },
    );
  });
}
