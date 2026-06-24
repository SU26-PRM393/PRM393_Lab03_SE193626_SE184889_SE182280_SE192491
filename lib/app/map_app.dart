import 'dart:ui';
import 'package:flutter/material.dart';

import '../features/auth/presentation/auth_gate.dart';
import 'app_theme.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
      };
}

class MapApp extends StatelessWidget {
  const MapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bản đồ Việt Nam',
      theme: AppTheme.light(),
      scrollBehavior: MyCustomScrollBehavior(),
      home: const AuthGate(),
    );
  }
}
