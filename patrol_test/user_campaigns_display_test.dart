// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

const _authenticatedShellKey = #patrolAuthenticatedShell;

void main() {
  patrolTest(
    'user can view campaigns screen',
    ($) async {
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
      final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toString();
      await _signUpAsFreshUser(
        $,
        name: 'Patrol User $uniqueSuffix',
        email: 'patrol.user.$uniqueSuffix@example.com',
        password: 'Patrol123!',
      );

      await _waitForAuthenticatedUserShell($.tester);

      await _openUserCampaignSection($);

      await _waitForCondition(
        $.tester,
        _hasLoadedCampaignScreen,
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

bool _hasLoadedCampaignScreen() {
  if (find.text('Chiến dịch').evaluate().isEmpty) {
    return false;
  }

  if (find.byType(CircularProgressIndicator).evaluate().isNotEmpty) {
    return false;
  }

  if (find.byTooltip('Tạo chiến dịch mới').evaluate().isNotEmpty ||
      find.widgetWithText(FilledButton, 'Tạo chiến dịch').evaluate().isNotEmpty) {
    return false;
  }

  final emptyState = find.text('Chưa có chiến dịch').evaluate().isNotEmpty;
  final hasCampaignContent = find.byWidgetPredicate((widget) {
    return widget is Text &&
        widget.data != null &&
        widget.data!.isNotEmpty &&
        widget.data != 'Chiến dịch' &&
        widget.data != 'Chưa có chiến dịch' &&
        widget.data != 'Không tìm thấy chiến dịch nào.' &&
        widget.data != 'Tìm kiếm chiến dịch...';
  }).evaluate().isNotEmpty;

  return emptyState || hasCampaignContent;
}

String? _authErrorMessage() {
  final errorTexts = find.byWidgetPredicate((widget) {
    return widget is Text &&
        widget.data != null &&
        (widget.data == 'Email hoặc mật khẩu không đúng.' ||
            widget.data == 'Tài khoản của bạn đã bị vô hiệu hóa.' ||
            widget.data == 'Tài khoản của bạn đã bị xóa hoặc không tồn tại.' ||
            widget.data == 'Email này đã tồn tại.' ||
            widget.data == 'Đã xảy ra lỗi. Vui lòng thử lại.');
  }).evaluate();

  if (errorTexts.isEmpty) {
    return null;
  }

  final textWidget = errorTexts.first.widget;
  return textWidget is Text ? textWidget.data : null;
}

Future<void> _waitForLoginScreen(WidgetTester tester) async {
  await _waitForCondition(
    tester,
    _isOnLoginScreen,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _waitForAuthenticatedUserShell(WidgetTester tester) async {
  final startedAt = DateTime.now();

  while (true) {
    if (find.byKey(const ValueKey('patrolAuthenticatedShell')).evaluate().isNotEmpty) {
      return;
    }

    final error = _authErrorMessage();
    if (error != null) {
      fail('User auth flow did not reach the authenticated shell: $error');
    }

    if (DateTime.now().difference(startedAt) > const Duration(seconds: 60)) {
      fail('Timed out waiting for the authenticated user shell after login.');
    }

    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> _signUpAsFreshUser(
  PatrolIntegrationTester $, {
  required String name,
  required String email,
  required String password,
}) async {
  final signUpToggle = find.text('Chưa có tài khoản? Đăng ký');
  await _waitForCondition(
    $.tester,
    () => signUpToggle.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
  await _tapVisible(signUpToggle.first, $.tester);

  final nameField = find.widgetWithText(TextFormField, 'Họ và tên');
  final emailField = find.widgetWithText(TextFormField, 'Email');
  final passwordField = find.widgetWithText(TextFormField, 'Mật khẩu');
  final signUpButton = find.widgetWithText(FilledButton, 'Đăng ký');

  await _waitForCondition(
    $.tester,
    () => nameField.evaluate().isNotEmpty &&
        emailField.evaluate().isNotEmpty &&
        passwordField.evaluate().isNotEmpty &&
        signUpButton.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await $.tester.enterText(nameField.first, name);
  await $.tester.enterText(emailField.first, email);
  await $.tester.enterText(passwordField.first, password);
  await $.tester.tap(signUpButton.first);
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

Future<void> _openUserCampaignSection(PatrolIntegrationTester $) async {
  final menuButton = find.byIcon(Icons.menu);

  if (menuButton.evaluate().isNotEmpty) {
    await _tapVisible(menuButton.first, $.tester);

    final drawer = find.byType(Drawer);
    await _waitForCondition(
      $.tester,
      () => drawer.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    final drawerCampaignLabel = find.descendant(
      of: drawer.first,
      matching: find.text('Chiến dịch'),
    );

    await _waitForCondition(
      $.tester,
      () => drawerCampaignLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await _tapNavigationItem(drawerCampaignLabel.first, $.tester);
  } else {
    final sidebarCampaignLabel = find.text('Chiến dịch');

    await _waitForCondition(
      $.tester,
      () => sidebarCampaignLabel.evaluate().isNotEmpty,
      timeout: const Duration(seconds: 15),
    );

    await _tapNavigationItem(sidebarCampaignLabel.first, $.tester);
  }
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