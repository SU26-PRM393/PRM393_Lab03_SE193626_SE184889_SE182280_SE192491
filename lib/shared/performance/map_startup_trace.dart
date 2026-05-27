import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class MapStartupTrace {
  const MapStartupTrace._();

  static bool get enabled => kDebugMode || kProfileMode;

  static void instant(String name, {Map<String, Object?>? arguments}) {
    if (!enabled) {
      return;
    }

    developer.Timeline.instantSync(name, arguments: arguments);
    _log(name);
  }

  static T timeSync<T>(
    String name,
    T Function() action, {
    Map<String, Object?>? arguments,
  }) {
    if (!enabled) {
      return action();
    }

    final stopwatch = Stopwatch()..start();
    developer.Timeline.startSync(name, arguments: arguments);
    try {
      return action();
    } finally {
      stopwatch.stop();
      developer.Timeline.finishSync();
      _log('$name ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  static Future<T> timeAsync<T>(
    String name,
    Future<T> Function() action, {
    Map<String, Object?>? arguments,
  }) async {
    if (!enabled) {
      return action();
    }

    final stopwatch = Stopwatch()..start();
    final task = developer.TimelineTask();
    task.start(name, arguments: arguments);
    try {
      return await action();
    } finally {
      stopwatch.stop();
      task.finish(arguments: {
        ...?arguments,
        'elapsedMs': stopwatch.elapsedMilliseconds,
      });
      _log('$name ${stopwatch.elapsedMilliseconds}ms');
    }
  }

  static void _log(String message) {
    if (kDebugMode) {
      debugPrint('[map-trace] $message');
    }
  }
}
