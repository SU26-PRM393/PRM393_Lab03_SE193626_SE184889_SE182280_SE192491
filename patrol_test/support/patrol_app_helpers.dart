// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'test_credentials.dart';

const authenticatedShellKey = #patrolAuthenticatedShell;

Future<void> launchAppAndSignInAsAdmin(PatrolIntegrationTester $) async {
  if (PatrolTestCredentials.testAdminEmail.isEmpty ||
      PatrolTestCredentials.testAdminPassword.isEmpty) {
    throw StateError(
      'TEST_ADMIN_EMAIL and TEST_ADMIN_PASSWORD must be provided. Load them from .env.test via the Patrol runner script.',
    );
  }

  await app.main();
  await pumpUi($.tester);

  await waitForCondition(
    $.tester,
    () => isOnLoginScreen() || $(authenticatedShellKey).exists,
    timeout: const Duration(seconds: 60),
  );

  if ($(authenticatedShellKey).exists) {
    await signOutIfAuthenticated($);
  }

  await waitForLoginScreen($.tester);
  await signIn(
    $,
    email: PatrolTestCredentials.testAdminEmail,
    password: PatrolTestCredentials.testAdminPassword,
  );
  await waitForAuthenticatedShell($.tester);
}

bool isOnLoginScreen() {
  return find.widgetWithText(TextFormField, 'Email').evaluate().isNotEmpty &&
      find.widgetWithText(TextFormField, 'Mật khẩu').evaluate().isNotEmpty &&
      find.widgetWithText(FilledButton, 'Đăng nhập').evaluate().isNotEmpty;
}

Future<void> waitForLoginScreen(WidgetTester tester) async {
  await waitForCondition(
    tester,
    isOnLoginScreen,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> waitForAuthenticatedShell(WidgetTester tester) async {
  await waitForCondition(
    tester,
    () =>
        find.byKey(const ValueKey('patrolAuthenticatedShell')).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 60),
  );
}

Future<void> signIn(
  PatrolIntegrationTester $, {
  required String email,
  required String password,
}) async {
  final emailField = find.widgetWithText(TextFormField, 'Email');
  final passwordField = find.widgetWithText(TextFormField, 'Mật khẩu');
  final loginButton = find.widgetWithText(FilledButton, 'Đăng nhập');

  await waitForCondition(
    $.tester,
    () =>
        emailField.evaluate().isNotEmpty &&
        passwordField.evaluate().isNotEmpty &&
        loginButton.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await $.tester.enterText(emailField.first, email);
  await $.tester.enterText(passwordField.first, password);
  await $.tester.tap(loginButton.first);
  await pumpUi($.tester);
}

Future<void> signOutIfAuthenticated(PatrolIntegrationTester $) async {
  final accountMenu = find.byTooltip('Tài khoản');

  await waitForCondition(
    $.tester,
    () => accountMenu.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await tapVisible(accountMenu.first, $.tester);

  await waitForCondition(
    $.tester,
    () => find.text('Đăng xuất').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await tapVisible(find.text('Đăng xuất').last, $.tester);
  await waitForLoginScreen($.tester);
}

Future<void> openNavigationItem(
  PatrolIntegrationTester $, {
  required String label,
}) async {
  final menuButton = find.byIcon(Icons.menu);

  if (menuButton.evaluate().isNotEmpty) {
    await tapVisible(menuButton.first, $.tester);

    final drawer = find.byType(Drawer);
    await waitForCondition(
      $.tester,
      () => drawer.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    final drawerLabel = find.descendant(
      of: drawer.first,
      matching: find.text(label),
    );

    await waitForCondition(
      $.tester,
      () => drawerLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await tapNavigationItem(drawerLabel.first, $.tester);
    return;
  }

  final sidebarLabel = find.text(label);
  await waitForCondition(
    $.tester,
    () => sidebarLabel.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await tapNavigationItem(sidebarLabel.first, $.tester);
}

Future<void> openAccountAction(
  PatrolIntegrationTester $, {
  required String actionLabel,
}) async {
  final accountMenu = find.byTooltip('Tài khoản');

  await waitForCondition(
    $.tester,
    () => accountMenu.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await tapVisible(accountMenu.first, $.tester);

  await waitForCondition(
    $.tester,
    () => find.text(actionLabel).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await tapVisible(find.text(actionLabel).last, $.tester);
}

Future<void> tapNavigationItem(Finder labelFinder, WidgetTester tester) async {
  await tester.ensureVisible(labelFinder);
  await tester.tap(labelFinder);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
  await tester.pumpAndSettle(const Duration(milliseconds: 200));
}

Future<void> tapVisible(Finder finder, WidgetTester tester) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await pumpUi(tester);
}

Future<void> pumpUi(WidgetTester tester) async {
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));
}

Future<void> waitForCondition(
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