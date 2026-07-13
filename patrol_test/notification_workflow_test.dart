// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _authenticatedShellKey = #patrolAuthenticatedShell;

void main() {
  patrolTest(
    'notification workflow works after campaign creation',
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
        () => _isOnLoginScreen() || $( _authenticatedShellKey).exists,
        timeout: const Duration(seconds: 60),
      );

      if ($( _authenticatedShellKey).exists) {
        await _signOutIfAuthenticated($);
      }

      await _waitForLoginScreen($.tester);
      await _signInAsAdmin($);

      await $( _authenticatedShellKey).waitUntilVisible(
        timeout: const Duration(seconds: 60),
      );

      final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toString();
      final createdName = 'Patrol Campaign $uniqueSuffix';

      await _openCampaignSection($);
      await _openCreateCampaignForm($);
      await _saveCampaignFromDialog(
        $,
        name: createdName,
        description: 'Created to verify notification workflow',
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo chiến dịch.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _openNotificationCenter($);

      await _waitForCondition(
        $.tester,
        () => _hasNotificationEntry(createdName),
        timeout: const Duration(seconds: 60),
      );

      await _tapNotificationEntry($, createdName);

      await _waitForCondition(
        $.tester,
        () => find.text(createdName).evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );
    },
  );
}

bool _isOnLoginScreen() {
  return find.widgetWithText(TextFormField, 'Email').evaluate().isNotEmpty &&
      find.widgetWithText(TextFormField, 'Mật khẩu').evaluate().isNotEmpty &&
      find.widgetWithText(FilledButton, 'Đăng nhập').evaluate().isNotEmpty;
}

bool _hasNotificationEntry(String campaignName) {
  return find.text('Thông báo').evaluate().isNotEmpty &&
      find.text('Chiến dịch mới').evaluate().isNotEmpty &&
      find.text(campaignName).evaluate().isNotEmpty;
}

Future<void> _waitForLoginScreen(WidgetTester tester) async {
  await _waitForCondition(
    tester,
    _isOnLoginScreen,
    timeout: const Duration(seconds: 30),
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

Future<void> _signOutIfAuthenticated(PatrolIntegrationTester $) async {
  final accountMenu = find.byTooltip('Tài khoản');

  await _waitForCondition(
    $.tester,
    () => accountMenu.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await _tapVisible(accountMenu.first, $.tester);

  await _waitForCondition(
    $.tester,
    () => find.text('Đăng xuất').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await _tapVisible(find.text('Đăng xuất').last, $.tester);
  await _waitForLoginScreen($.tester);
}

Future<void> _openCampaignSection(PatrolIntegrationTester $) async {
  await _openAdminNavigationItem($, label: 'Chiến dịch');
}

Future<void> _openNotificationCenter(PatrolIntegrationTester $) async {
  final bellButton = find.byTooltip('Thông báo');
  if (bellButton.evaluate().isNotEmpty) {
    await _tapVisible(bellButton.first, $.tester);
  } else {
    await _openAdminNavigationItem($, label: 'Thông báo');
  }

  await _waitForCondition(
    $.tester,
    () => find.text('Thông báo').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _openAdminNavigationItem(
  PatrolIntegrationTester $, {
  required String label,
}) async {
  final menuButton = find.byIcon(Icons.menu);

  if (menuButton.evaluate().isNotEmpty) {
    await _tapVisible(menuButton.first, $.tester);

    final drawer = find.byType(Drawer);
    await _waitForCondition(
      $.tester,
      () => drawer.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    final drawerLabel = find.descendant(
      of: drawer.first,
      matching: find.text(label),
    );

    await _waitForCondition(
      $.tester,
      () => drawerLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await _tapNavigationItem(drawerLabel.first, $.tester);
    return;
  }

  final sidebarLabel = find.text(label);
  await _waitForCondition(
    $.tester,
    () => sidebarLabel.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await _tapNavigationItem(sidebarLabel.first, $.tester);
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

Future<void> _saveCampaignFromDialog(
  PatrolIntegrationTester $, {
  required String name,
  required String description,
}) async {
  await _waitForCampaignDialog(
    $.tester,
    title: 'Tạo chiến dịch',
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

Future<void> _tapNotificationEntry(
  PatrolIntegrationTester $,
  String campaignName,
) async {
  final campaignBody = find.text(campaignName);

  await _waitForCondition(
    $.tester,
    () => campaignBody.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  final notificationTile = find.ancestor(
    of: campaignBody.first,
    matching: find.byType(InkWell),
  );

  if (notificationTile.evaluate().isNotEmpty) {
    await _tapVisible(notificationTile.first, $.tester);
    return;
  }

  await _tapVisible(campaignBody.first, $.tester);
}

Future<void> _tapNavigationItem(Finder labelFinder, WidgetTester tester) async {
  final navItem = find.ancestor(
    of: labelFinder,
    matching: find.byType(InkWell),
  );

  if (navItem.evaluate().isNotEmpty) {
    await _tapVisible(navItem.first, tester);
    return;
  }

  await _tapVisible(labelFinder, tester);
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