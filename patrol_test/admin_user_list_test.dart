// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _authenticatedShellKey = #patrolAuthenticatedShell;

void main() {
  patrolTest(
    'admin can view user list',
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

      await _openUserManagementSection($);

      await _waitForCondition(
        $.tester,
        _hasLoadedUserList,
        timeout: const Duration(seconds: 60),
      );
    },
  );
}

bool _isOnLoginScreen() {
  return find.widgetWithText(TextFormField, 'Email').evaluate().isNotEmpty &&
      find.widgetWithText(TextFormField, 'Mật khẩu').evaluate().isNotEmpty &&
      find.widgetWithText(FilledButton, 'Đăng nhập').evaluate().isNotEmpty;
}

bool _hasLoadedUserList() {
  if (find.text('Quản lí người dùng').evaluate().isEmpty) {
    return false;
  }

  if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
    return false;
  }

  final emptyState = find.text('Chưa có người dùng nào khác.').evaluate().isNotEmpty;
  final errorState = find.text('Thử lại').evaluate().isNotEmpty;
  final hasEmailRow = find.byWidgetPredicate((widget) {
    return widget is Text && widget.data != null && widget.data!.contains('@');
  }).evaluate().isNotEmpty;

  return !errorState && (hasEmailRow || emptyState);
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

Future<void> _openUserManagementSection(PatrolIntegrationTester $) async {
  final menuButton = find.byIcon(Icons.menu);

  if (menuButton.evaluate().isNotEmpty) {
    await _tapVisible(menuButton.first, $.tester);

    final drawer = find.byType(Drawer);
    await _waitForCondition(
      $.tester,
      () => drawer.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    final drawerUserManagementLabel = find.descendant(
      of: drawer.first,
      matching: find.text('Người dùng'),
    );

    await _waitForCondition(
      $.tester,
      () => drawerUserManagementLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await _tapNavigationItem(drawerUserManagementLabel.first, $.tester);
  } else {
    final sidebarUserManagementLabel = find.text('Người dùng');

    await _waitForCondition(
      $.tester,
      () => sidebarUserManagementLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await _tapNavigationItem(sidebarUserManagementLabel.first, $.tester);
  }

  await _waitForCondition(
    $.tester,
    () => find.text('Quản lí người dùng').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
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