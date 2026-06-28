import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/screens/auth_gate.dart';
import 'package:vietnam_map_flutter/utils/app_theme.dart';

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
