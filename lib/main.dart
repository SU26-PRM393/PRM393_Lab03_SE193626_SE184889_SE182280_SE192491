import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/import_service.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/isar_service.dart';
import 'app/map_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Catch and ignore expected async cancellations (e.g. from vector_map_tiles)
  PlatformDispatcher.instance.onError = (error, stack) {
    final errorStr = error.toString();
    if (errorStr.contains('Cancelled') || errorStr.contains('CancellationException')) {
      debugPrint('Asynchronous task cancelled gracefully: $error');
      return true; // Mark as handled
    }
    return false; // Let Flutter/OS print other uncaught errors
  };

  await IsarService.init();

  await ImportService.importDataIfNeeded();

  runApp(const MapApp());
}
