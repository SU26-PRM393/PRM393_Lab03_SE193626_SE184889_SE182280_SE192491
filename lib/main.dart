import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vietnam_map_flutter/firebase_options.dart';
import 'package:vietnam_map_flutter/shared/performance/map_startup_trace.dart';
import 'app/map_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Catch and ignore expected async cancellations (e.g. from vector_map_tiles)
  PlatformDispatcher.instance.onError = (error, stack) {
    final errorStr = error.toString();
    if (errorStr.contains('Cancelled') ||
        errorStr.contains('CancellationException')) {
      debugPrint('Asynchronous task cancelled gracefully: $error');
      return true; // Mark as handled
    }
    return false; // Let Flutter/OS print other uncaught errors
  };

  MapStartupTrace.instant('app.runApp');
  runApp(const MapApp());
}
