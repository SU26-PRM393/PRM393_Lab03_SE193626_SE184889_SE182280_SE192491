// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/patrol_app_helpers.dart';

void main() {
  patrolTest(
    'pdf export uploads report to firebase storage',
    ($) async {
      await launchAppAndSignInAsAdmin($);

      await openNavigationItem($, label: 'Firebase Demo');

      await waitForCondition(
        $.tester,
        () => find.text('Remote Config').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await waitForCondition(
        $.tester,
        () =>
            find.text('true').evaluate().isNotEmpty ||
            find.text('Xuất Báo Cáo PDF').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      if (find.text('Xuất Báo Cáo PDF').evaluate().isEmpty) {
        fail(
          'PDF export section is unavailable because Remote Config key enable_pdf_export is disabled for the current test environment.',
        );
      }

      await waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Tạo & Tải lên Storage').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 60),
      );

      await tapVisible(
        find.widgetWithText(FilledButton, 'Tạo & Tải lên Storage').first,
        $.tester,
      );

      await waitForCondition(
        $.tester,
        () =>
            find.text('Xuất PDF thành công!').evaluate().isNotEmpty ||
            find.text('Mở').evaluate().isNotEmpty ||
            find.textContaining('firebasestorage').evaluate().isNotEmpty ||
            find.textContaining('Lỗi xuất PDF:').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 120),
      );

      final exportError = find.textContaining('Lỗi xuất PDF:');
      if (exportError.evaluate().isNotEmpty) {
        fail('PDF export failed in Firebase demo flow.');
      }

      expect(find.text('Xuất PDF thành công!'), findsOneWidget);
      expect(find.text('Mở'), findsWidgets);
      expect(find.textContaining('firebasestorage'), findsWidgets);
    },
  );
}