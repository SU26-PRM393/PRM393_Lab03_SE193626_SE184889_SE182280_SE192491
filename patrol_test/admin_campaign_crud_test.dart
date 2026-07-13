// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _authenticatedShellKey = #patrolAuthenticatedShell;

void main() {
  patrolTest(
    'admin campaign and event creation work',
    ($) async {
      if (PatrolTestCredentials.testAdminEmail.isEmpty ||
          PatrolTestCredentials.testAdminPassword.isEmpty) {
        throw StateError(
          'TEST_ADMIN_EMAIL and TEST_ADMIN_PASSWORD must be provided. Load them from .env.test via the Patrol runner script.',
        );
      }

      await app.main();
      await _pumpUi($.tester);

      await _waitForCondition(
        $.tester,
        () => $( _authenticatedShellKey).exists ||
            find.widgetWithText(FilledButton, 'Đăng nhập').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 60),
      );

      if (!$( _authenticatedShellKey).exists) {
        await _signInAsAdmin($);
      }

      await $( _authenticatedShellKey).waitUntilVisible(
        timeout: const Duration(seconds: 60),
      );
      await _pumpUi($.tester);

      await _openCampaignSection($);

      final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toString();
      final createdName = 'Patrol Campaign $uniqueSuffix';

      await _openCreateCampaignForm($);
      await _saveCampaignFromDialog(
        $,
        name: createdName,
        description: 'Created by Patrol E2E test',
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo chiến dịch.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      final eventName = 'Patrol Event $uniqueSuffix';

      await _openCampaignDetails($, campaignName: createdName);
      await _openCreateEventForm($);
      await _saveEventFromDialog($, name: eventName);

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo event.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.text(eventName).evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Số nhân viên phụ trách: 1').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );
    },
  );
}

Future<void> _signInAsAdmin(PatrolIntegrationTester $) async {
  final emailField = find.widgetWithText(TextFormField, 'Email');
  final passwordField = find.widgetWithText(TextFormField, 'Mật khẩu');
  final loginButton = find.widgetWithText(FilledButton, 'Đăng nhập');

  await _waitForCondition(
    $.tester,
    () => emailField.evaluate().isNotEmpty &&
        passwordField.evaluate().isNotEmpty &&
        loginButton.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await $.tester.enterText(emailField.first, PatrolTestCredentials.testAdminEmail);
  await $.tester.enterText(passwordField.first, PatrolTestCredentials.testAdminPassword);
  await $.tester.tap(loginButton.first);
  await _pumpUi($.tester);
}

Future<void> _openCampaignSection(PatrolIntegrationTester $) async {
  final campaignLabel = find.text('Chiến dịch');

  if (campaignLabel.evaluate().isNotEmpty) {
    await $.tester.tap(campaignLabel.first);
    await _pumpUi($.tester);
    return;
  }

  final menuButton = find.byIcon(Icons.menu);
  if (menuButton.evaluate().isNotEmpty) {
    await $.tester.tap(menuButton.first);
    await _pumpUi($.tester);

    await _waitForCondition(
      $.tester,
      () => campaignLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await $.tester.tap(campaignLabel.first);
    await _pumpUi($.tester);
    return;
  }

  fail('Unable to locate campaign navigation in admin dashboard.');
}

Future<void> _openCreateCampaignForm(PatrolIntegrationTester $) async {
  final createTooltipButton = find.byTooltip('Tạo chiến dịch mới');
  if (createTooltipButton.evaluate().isNotEmpty) {
    await _tapVisible(createTooltipButton.first, $.tester);
    await _waitForCampaignDialog($.tester, title: 'Tạo chiến dịch');
    return;
  }

  final createFilledButton = find.widgetWithText(FilledButton, 'Tạo chiến dịch');
  if (createFilledButton.evaluate().isNotEmpty) {
    await _tapVisible(createFilledButton.first, $.tester);
    await _waitForCampaignDialog($.tester, title: 'Tạo chiến dịch');
    return;
  }

  fail('Unable to locate create campaign action.');
}

Future<void> _openCampaignDetails(
  PatrolIntegrationTester $, {
  required String campaignName,
}) async {
  final campaignNameFinder = find.text(campaignName);

  await _waitForCondition(
    $.tester,
    () => campaignNameFinder.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await _tapVisible(campaignNameFinder.first, $.tester);

  await _waitForCondition(
    $.tester,
    () => find.widgetWithText(FilledButton, 'Thêm event').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _saveCampaignFromDialog(
  PatrolIntegrationTester $, {
  required String name,
  required String description,
}) async {
  await _waitForCampaignDialog(
    $.tester,
    title: find.text('Sửa chiến dịch').evaluate().isNotEmpty
        ? 'Sửa chiến dịch'
        : 'Tạo chiến dịch',
  );

  final dialog = find.byType(AlertDialog).last;
  final dialogFields = find.descendant(
    of: dialog,
    matching: find.byType(TextFormField),
  );

  await $.tester.ensureVisible(dialogFields.at(0));
  await $.tester.enterText(dialogFields.at(0), name);
  await _pumpUi($.tester);

  await $.tester.ensureVisible(dialogFields.at(1));
  await $.tester.enterText(dialogFields.at(1), description);
  await _pumpUi($.tester);

  final saveButton = find.descendant(
    of: dialog,
    matching: find.widgetWithText(FilledButton, 'Lưu'),
  );
  await _tapVisible(saveButton.first, $.tester);
}

Future<void> _openCreateEventForm(PatrolIntegrationTester $) async {
  final createEventButton = find.widgetWithText(FilledButton, 'Thêm event');

  await _waitForCondition(
    $.tester,
    () => createEventButton.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await _tapVisible(createEventButton.first, $.tester);

  await _waitForCondition(
    $.tester,
    () => find.text('Tạo event').evaluate().isNotEmpty &&
        find.byType(AlertDialog).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );
}

Future<void> _saveEventFromDialog(
  PatrolIntegrationTester $, {
  required String name,
}) async {
  await _waitForCondition(
    $.tester,
    () => find.text('Tạo event').evaluate().isNotEmpty &&
        find.byType(AlertDialog).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  final dialog = find.byType(AlertDialog).last;
  final nameField = find.descendant(
    of: dialog,
    matching: find.widgetWithText(TextFormField, 'Tên event'),
  );

  await $.tester.ensureVisible(nameField.first);
  await $.tester.enterText(nameField.first, name);
  await _pumpUi($.tester);

  await _assignFirstStaffMemberFromDialog($, dialog);

  final saveButton = find.descendant(
    of: dialog,
    matching: find.widgetWithText(FilledButton, 'Lưu'),
  );
  await _tapVisible(saveButton.first, $.tester);
}

Future<void> _assignFirstStaffMemberFromDialog(
  PatrolIntegrationTester $,
  Finder dialog,
) async {
  final staffOption = find.descendant(
    of: dialog,
    matching: find.byType(CheckboxListTile),
  );

  await _waitForCondition(
    $.tester,
    () => staffOption.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await _tapVisible(staffOption.first, $.tester);
}

Future<void> _waitForCampaignDialog(
  WidgetTester tester, {
  required String title,
}) async {
  await _waitForCondition(
    tester,
    () => find.text(title).evaluate().isNotEmpty &&
        find.byType(AlertDialog).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );
}

Future<void> _tapVisible(Finder finder, WidgetTester tester) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await _pumpUi(tester);
}

Future<void> _pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
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
