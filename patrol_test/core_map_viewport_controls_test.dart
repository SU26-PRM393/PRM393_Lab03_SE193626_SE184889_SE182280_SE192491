// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/screens/vietnam_map_screen.dart';
import 'package:vietnam_map_flutter/utils/map_constants.dart';

void main() {
  patrolTest(
    'core map loads with Vietnam-focused default viewport and map controls visible',
    ($) async {
      await $.tester.pumpWidget(
        const MaterialApp(
          home: VietnamMapScreen(),
        ),
      );
      await $.tester.pumpAndSettle();

      await $(FlutterMap).waitUntilVisible(timeout: const Duration(seconds: 30));
      await $.tester.pumpAndSettle();

      final map = $.tester.widget<FlutterMap>(find.byType(FlutterMap).first);
      final options = map.options;

      expect(
        options.initialCenter.latitude,
        closeTo(MapConstants.vietnamCenter.latitude, 0.000001),
      );
      expect(
        options.initialCenter.longitude,
        closeTo(MapConstants.vietnamCenter.longitude, 0.000001),
      );
      expect(
        options.initialZoom,
        closeTo(MapConstants.initialZoom, 0.000001),
      );

      expect(find.byIcon(Icons.add), findsWidgets);
      expect(find.byIcon(Icons.remove), findsWidgets);
      expect(find.byIcon(Icons.my_location), findsWidgets);
      expect(find.byIcon(Icons.center_focus_strong), findsWidgets);
    },
  );
}
