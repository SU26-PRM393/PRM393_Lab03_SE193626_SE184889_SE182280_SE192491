import 'package:flutter/material.dart';

import '../features/vietnam_map/presentation/vietnam_map_screen.dart';
import 'app_theme.dart';

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Viet Nam Map',
      theme: AppTheme.light(),
      home: const VietnamMapScreen(),
    );
  }
}
