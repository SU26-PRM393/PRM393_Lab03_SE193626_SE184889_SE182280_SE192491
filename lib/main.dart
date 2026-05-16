import 'package:flutter/material.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/import_service.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/database/isar_service.dart';
import 'app/map_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await IsarService.init();

  await ImportService.importDataIfNeeded();

  runApp(const MapApp());
}
