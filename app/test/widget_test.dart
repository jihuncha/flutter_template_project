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

  group('Counter Widget Tests', () {
    testWidgets('Counter starts at 0', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Verify that our counter starts at 0.
      expect(find.text('카운터: 0'), findsOneWidget);
      expect(find.text('카운터: 1'), findsNothing);
    });

    testWidgets('Counter increments when + button is tapped', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Tap the '+' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      // Verify that our counter has incremented.
      expect(find.text('카운터: 1'), findsOneWidget);
      expect(find.text('카운터: 0'), findsNothing);
    });

    testWidgets('Counter decrements when - button is tapped', (tester) async {
      // Build our app and trigger a frame.
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
      expect(find.text('카운터: 1'), findsOneWidget);

      // Then tap the '-' icon and trigger a frame.
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Verify that our counter has decremented.
      expect(find.text('카운터: 0'), findsOneWidget);
      expect(find.text('카운터: 1'), findsNothing);
    });

    testWidgets('Counter cannot go below 0', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Counter starts at 0, try to decrement
      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      // Verify that our counter stays at 0.
      expect(find.text('카운터: 0'), findsOneWidget);
    });

    testWidgets('Multiple increment and decrement operations work correctly', (tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(
        ProviderScope(
          child: app_translations.TranslationProvider(
            child: const MaterialApp(home: HomePage()),
          ),
        ),
      );

      // Increment 3 times
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byIcon(Icons.add));
        await tester.pump();
      }
      expect(find.text('카운터: 3'), findsOneWidget);

      // Decrement 2 times
      for (int i = 0; i < 2; i++) {
        await tester.tap(find.byIcon(Icons.remove));
        await tester.pump();
      }
      expect(find.text('카운터: 1'), findsOneWidget);
    });
  });
}
