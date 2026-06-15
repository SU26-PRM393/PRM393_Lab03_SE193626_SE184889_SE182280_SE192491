import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_gate.dart';
import 'app_theme.dart';

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bản đồ Việt Nam',
      theme: AppTheme.light(),
      home: const AuthGate(),
    );
  }
}
