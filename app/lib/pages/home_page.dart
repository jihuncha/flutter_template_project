import 'package:app/i18n/translations.g.dart';
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
  var _counter = 0;

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
    // Log user action with structured logging using mixin
    logUserAction(
      'counter_increment',
      {'previous_value': _counter, 'new_value': _counter + 1},
    );

    // Use performance measurement helper
    _measurePerformance('counter_update', () {
      setState(() {
        _counter++;
      });
    }, metadata: {'counter_value': _counter + 1});
  }

  void _decrementCounter() {
    // Prevent counter from going below 0
    if (_counter <= 0) return;

    // Log user action with structured logging using mixin
    logUserAction(
      'counter_decrement',
      {'previous_value': _counter, 'new_value': _counter - 1},
    );

    // Use performance measurement helper
    _measurePerformance('counter_update', () {
      setState(() {
        _counter--;
      });
    }, metadata: {'counter_value': _counter - 1});
  }

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

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
              '${t.home.counter}: $_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            heroTag: 'decrement',
            child: const Icon(Icons.remove),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: 'increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
