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
    'search filter sort for province and lower level works',
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

      // Province: search + filter + sort.
      controller.updateSelectedLevel(AdministrativeAreaLevel.province);
      _setFilterChip(controller, chip: 'Province', selected: true);
      _setFilterChip(controller, chip: 'City', selected: false);
      _setFilterChip(controller, chip: 'District', selected: false);
      controller.updateSearchText('ha noi');
      controller.updateSortOption('Name');
      controller.updateSortDirection(AdministrativeAreaSortDirection.ascending);
      await $.tester.pumpAndSettle();

      final provinceResultsAsc = controller.filteredAdministrativeEntries;
      expect(provinceResultsAsc, isNotEmpty);
      expect(
        provinceResultsAsc.every(
          (result) => result.filter == AdministrativeAreaFilter.province,
        ),
        isTrue,
      );

      final provinceNamesAsc =
          provinceResultsAsc.map((result) => result.name).toList();

      controller.updateSortDirection(AdministrativeAreaSortDirection.descending);
      await $.tester.pumpAndSettle();

      final provinceResultsDesc = controller.filteredAdministrativeEntries;
      final provinceNamesDesc =
          provinceResultsDesc.map((result) => result.name).toList();
      expect(provinceNamesDesc, provinceNamesAsc.reversed.toList());

      // Lower level: search + filter + sort.
      controller.updateSelectedLevel(AdministrativeAreaLevel.district);
      _setFilterChip(controller, chip: 'Province', selected: false);
      _setFilterChip(controller, chip: 'City', selected: false);
      _setFilterChip(controller, chip: 'District', selected: true);
      controller.updateSearchText('quan');
      controller.updateSortOption('Name');
      controller.updateSortDirection(AdministrativeAreaSortDirection.ascending);
      await $.tester.pumpAndSettle();

      final lowerLevelResultsAsc = controller.filteredAdministrativeEntries;
      expect(lowerLevelResultsAsc, isNotEmpty);
      expect(
        lowerLevelResultsAsc.every(
          (result) => result.filter == AdministrativeAreaFilter.district,
        ),
        isTrue,
      );
      expect(
        lowerLevelResultsAsc.every((result) => result.lowerLevelPlace != null),
        isTrue,
      );

      final lowerLevelNamesAsc =
          lowerLevelResultsAsc.map((result) => result.name).toList();

      controller.updateSortDirection(AdministrativeAreaSortDirection.descending);
      await $.tester.pumpAndSettle();

      final lowerLevelResultsDesc = controller.filteredAdministrativeEntries;
      final lowerLevelNamesDesc =
          lowerLevelResultsDesc.map((result) => result.name).toList();
      expect(lowerLevelNamesDesc, lowerLevelNamesAsc.reversed.toList());
    },
  );
}

void _setFilterChip(
  VietnamMapController controller, {
  required String chip,
  required bool selected,
}) {
  final isSelected = controller.isFilterChipSelected(chip);
  if (isSelected != selected) {
    controller.toggleFilterChip(chip);
  }
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
