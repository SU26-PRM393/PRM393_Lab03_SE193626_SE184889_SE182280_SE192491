// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/patrol_app_helpers.dart';

void main() {
  patrolTest(
    'remote config values are displayed in firebase demo',
    ($) async {
      await launchAppAndSignInAsAdmin($);

      await openNavigationItem($, label: 'Firebase Demo');

      await waitForCondition(
        $.tester,
        () => find.text('Remote Config').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      final refreshButton = find.byTooltip('Fetch config mới');
      if (refreshButton.evaluate().isNotEmpty) {
        await tapVisible(refreshButton.first, $.tester);
      }

      expect(find.text('default_chart_province_count'), findsOneWidget);
      expect(find.text('enable_pdf_export'), findsOneWidget);
      expect(find.text('max_checkin_distance_meters'), findsOneWidget);
      expect(find.text('Số tỉnh hiển thị trên biểu đồ'), findsOneWidget);
      expect(find.text('Bật xuất PDF'), findsOneWidget);
      expect(find.text('Khoảng cách check-in tối đa'), findsOneWidget);

      final booleanValue = find.byWidgetPredicate(
        (widget) => widget is Text && (widget.data == 'true' || widget.data == 'false'),
      );
      final numericValue = find.byWidgetPredicate(
        (widget) => widget is Text &&
            widget.data != null &&
            RegExp(r'^\d+$').hasMatch(widget.data!),
      );
      final distanceValue = find.byWidgetPredicate(
        (widget) => widget is Text &&
            widget.data != null &&
            RegExp(r'^\d+(\.\d+)? m$').hasMatch(widget.data!),
      );

      expect(booleanValue, findsWidgets);
      expect(numericValue, findsWidgets);
      expect(distanceValue, findsWidgets);
    },
  );
}