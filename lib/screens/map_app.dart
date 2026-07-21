import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/l10n/app_strings.dart';
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

/// Root widget. Holds the [ValueNotifier<Locale>] so that the entire tree
/// can react to language switches via [AppLocale].
class MapApp extends StatefulWidget {
  const MapApp({super.key});

  @override
  State<MapApp> createState() => _MapAppState();
}

class _MapAppState extends State<MapApp> {
  final _localeNotifier = ValueNotifier<Locale>(localeVi);

  @override
  void dispose() {
    _localeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: _localeNotifier,
      builder: (context, locale, _) {
        return AppLocale(
          locale: locale,
          notifier: _localeNotifier,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: locale == localeEn ? 'Vietnam Map' : 'Bản đồ Việt Nam',
            theme: AppTheme.light(),
            locale: locale,
            scrollBehavior: MyCustomScrollBehavior(),
            home: const AuthGate(),
          ),
        );
      },
    );
  }
}
