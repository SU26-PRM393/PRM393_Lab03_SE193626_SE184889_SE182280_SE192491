// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/models/administrative_area.dart';
import 'package:vietnam_map_flutter/screens/vietnam_map_screen.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';
import 'package:vietnam_map_flutter/widgets/map_viewport.dart';

void main() {
  patrolTest(
    'province selection and lower level reveal works by click',
    ($) async {
      await $.tester.pumpWidget(
        const MaterialApp(
          home: VietnamMapScreen(),
        ),
      );
      await $.tester.pumpAndSettle();

      await $(FlutterMap).waitUntilVisible(timeout: const Duration(seconds: 30));
      await $.tester.pumpAndSettle();

      await $.tester.tap(find.byIcon(Icons.search).first);
      await $.tester.pumpAndSettle();

      final mapViewport =
          $.tester.widget<MapViewport>(find.byType(MapViewport).first);
      final controller = mapViewport.controller;

      await _waitForCondition(
        $.tester,
        () => controller.isBoundaryDataReady,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => controller.lowerLevelPlacesStatus == MapLoadStatus.ready,
        timeout: const Duration(seconds: 30),
      );

      controller.updateSelectedLevel(AdministrativeAreaLevel.province);
      controller.updateSearchText('ha');
      controller.updateSortOption('Name');
      await $.tester.pumpAndSettle();

      final provinceResults = controller.filteredAdministrativeEntries
          .where((result) => result.filter == AdministrativeAreaFilter.province)
          .toList();

      expect(provinceResults, isNotEmpty);
      final targetProvinceName = provinceResults.first.name;

      await $.tester.tap(find.text(targetProvinceName).first);
      await $.tester.pumpAndSettle();

      await _waitForCondition(
        $.tester,
        () => controller.selectedProvince?.name == targetProvinceName,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => controller.selectedLowerLevelPlaces.isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => !controller.isLoadingDetails,
        timeout: const Duration(seconds: 30),
      );

      expect(find.textContaining('Xã/Phường ('), findsWidgets);
    },
  );
}

Future<void> _waitForCondition(
  WidgetTester tester,
  bool Function() predicate, {
  required Duration timeout,
}) async {
  final startedAt = DateTime.now();

  while (!predicate()) {
    if (DateTime.now().difference(startedAt) > timeout) {
      fail('Timed out waiting for condition after ${timeout.inSeconds} seconds.');
    }

    await tester.pump(const Duration(milliseconds: 100));
  }
}
