import 'package:app/i18n/translations.g.dart';
import 'package:app/providers/counter_provider.dart';
import 'package:app/router/routes.dart';
import 'package:core/core.dart' hide LocaleSettings;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> with LoggerMixin {
  /// Performance measurement helper method
  void _measurePerformance(
    String operation,
    VoidCallback callback, {
    Map<String, dynamic>? metadata,
  }) {
    final stopwatch = Stopwatch()..start();
    callback();
    stopwatch.stop();

    logger.logPerformance(
      operation,
      stopwatch.elapsed,
      metadata,
    );
  }

  void _incrementCounter() {
    final counter = ref.read(counterProvider.notifier);
    final currentValue = ref.read(counterProvider);

    // Log user action with structured logging using mixin
    logUserAction(
      'counter_increment',
      {'previous_value': currentValue, 'new_value': currentValue + 1},
    );

    // Use performance measurement helper
    _measurePerformance('counter_update', () {
      counter.increment();
    }, metadata: {'counter_value': currentValue + 1});
  }

  void _decrementCounter() {
    final counter = ref.read(counterProvider.notifier);
    final currentValue = ref.read(counterProvider);

    // Log user action with structured logging using mixin
    logUserAction(
      'counter_decrement',
      {'previous_value': currentValue, 'new_value': currentValue - 1},
    );

    // Use performance measurement helper
    _measurePerformance('counter_update', () {
      counter.decrement();
    }, metadata: {'counter_value': currentValue - 1});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);
    final counterValue = ref.watch(counterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: () => const SettingsRoute().push<void>(context),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '${t.home.counter}: $counterValue',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: 'increment',
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            heroTag: 'decrement',
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
