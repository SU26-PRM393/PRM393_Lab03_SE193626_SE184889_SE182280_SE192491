// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _authenticatedShellKey = #patrolAuthenticatedShell;
const _checkInDialogTitle = 'Xác thực Check-in';
void main() {
  patrolTest(
    'staff can check in and create interactions for an event',
    ($) async {
      if (PatrolTestCredentials.testAdminEmail.isEmpty ||
          PatrolTestCredentials.testAdminPassword.isEmpty ||
          PatrolTestCredentials.testUserEmail.isEmpty ||
          PatrolTestCredentials.testUserPassword.isEmpty) {
        throw StateError(
          'TEST_ADMIN_EMAIL, TEST_ADMIN_PASSWORD, TEST_USER_EMAIL, and TEST_USER_PASSWORD must be provided. Load them from .env.test via the Patrol runner script.',
        );
      }

      await app.main();
      await _pumpUi($.tester);

      await _waitForCondition(
        $.tester,
        () => _isOnLoginScreen() || $(_authenticatedShellKey).exists,
        timeout: const Duration(seconds: 60),
      );

      if ($(_authenticatedShellKey).exists) {
        await _signOutIfAuthenticated($);
      }

      await _waitForLoginScreen($.tester);
      await _signIn(
        $,
        email: PatrolTestCredentials.testAdminEmail,
        password: PatrolTestCredentials.testAdminPassword,
      );
      await _waitForAuthenticatedShell($.tester);

      final uniqueSuffix = DateTime.now().millisecondsSinceEpoch.toString();
      final campaignName = 'Patrol Staff Event Campaign $uniqueSuffix';
      final eventName = 'Patrol Staff Event $uniqueSuffix';
      final interactionTargetName = 'Phụ huynh Patrol $uniqueSuffix';
      final interactionNotes =
          'Đã tư vấn và ghi nhận nhu cầu tham gia sự kiện $uniqueSuffix';

      await _openCampaignSection($);
      await _openCreateCampaignForm($);
      await _saveCampaignFromDialog(
        $,
        name: campaignName,
        description: 'Created to validate staff check-in and interaction flow.',
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo chiến dịch.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _openCampaignDetails($, campaignName: campaignName);
      await _openCreateEventForm($);
      await _saveEventFromDialog(
        $,
        name: eventName,
        assignedEmployeeEmail: PatrolTestCredentials.testUserEmail,
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo event.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _signOutIfAuthenticated($);
      await _signIn(
        $,
        email: PatrolTestCredentials.testUserEmail,
        password: PatrolTestCredentials.testUserPassword,
      );
      await _waitForAuthenticatedShell($.tester);

      await _openCampaignSection($);
      await _openCampaignByName($, campaignName: campaignName);
      await _openEventByName($, eventName: eventName);

      await _waitForCondition(
        $.tester,
        () => find.text('Điểm danh & Check-in').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _tapVisible(find.text('Điểm danh & Check-in').last, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Tiến hành Check-in').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _tapVisible(
        find.widgetWithText(FilledButton, 'Tiến hành Check-in').first,
        $.tester,
      );

      await _grantLocationPermissionIfNeeded($);

      await _waitForDialog($.tester, title: _checkInDialogTitle);

      await _waitForCondition(
        $.tester,
        () => _isFilledButtonEnabled('Điểm danh'),
        timeout: const Duration(seconds: 30),
      );

      await _tapVisible(find.widgetWithText(FilledButton, 'Điểm danh').last, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.text('Bạn đã điểm danh thành công!').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _tapVisible(find.text('Tương tác & Lịch sử').last, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(TextButton, 'Thêm tương tác').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _tapVisible(
        find.widgetWithText(TextButton, 'Thêm tương tác').first,
        $.tester,
      );

      await _waitForDialog($.tester, title: 'Thêm tương tác mới');

      final dialog = find.byType(Dialog).last;
      final dialogFields = find.descendant(
        of: dialog,
        matching: find.byType(TextFormField),
      );

      await $.tester.ensureVisible(dialogFields.at(1));
      await $.tester.enterText(dialogFields.at(1), interactionTargetName);
      await _pumpUi($.tester);

      await $.tester.ensureVisible(dialogFields.at(2));
      await $.tester.enterText(dialogFields.at(2), '12A1');
      await _pumpUi($.tester);

      await $.tester.ensureVisible(dialogFields.at(3));
      await $.tester.enterText(dialogFields.at(3), 'PATROL-$uniqueSuffix');
      await _pumpUi($.tester);

      await $.tester.ensureVisible(dialogFields.at(4));
      await $.tester.enterText(dialogFields.at(4), interactionNotes);
      await _pumpUi($.tester);

      await _tapVisible(
        find.widgetWithText(FilledButton, 'Lưu tương tác').first,
        $.tester,
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã thêm tương tác mới.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.text(interactionTargetName).evaluate().isNotEmpty &&
            find.text(interactionNotes).evaluate().isNotEmpty,
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

Future<void> _waitForLoginScreen(WidgetTester tester) async {
  await _waitForCondition(
    tester,
    _isOnLoginScreen,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _waitForAuthenticatedShell(WidgetTester tester) async {
  await _waitForCondition(
    tester,
    () => find.byKey(const ValueKey('patrolAuthenticatedShell')).evaluate().isNotEmpty,
    timeout: const Duration(seconds: 60),
  );
}

Future<void> _signIn(
  PatrolIntegrationTester $, {
  required String email,
  required String password,
}) async {
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

  await $.tester.enterText(emailField.first, email);
  await $.tester.enterText(passwordField.first, password);
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
  await _openNavigationItem($, label: 'Chiến dịch');
}

Future<void> _openNavigationItem(
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
    await _waitForDialog($.tester, title: 'Tạo chiến dịch');
    return;
  }

  final createFilledButton = find.widgetWithText(FilledButton, 'Tạo chiến dịch');
  if (createFilledButton.evaluate().isNotEmpty) {
    await _tapVisible(createFilledButton.first, $.tester);
    await _waitForDialog($.tester, title: 'Tạo chiến dịch');
    return;
  }

  fail('Unable to locate create campaign action.');
}

Future<void> _saveCampaignFromDialog(
  PatrolIntegrationTester $, {
  required String name,
  required String description,
}) async {
  await _waitForDialog($.tester, title: 'Tạo chiến dịch');

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

Future<void> _openCampaignDetails(
  PatrolIntegrationTester $, {
  required String campaignName,
}) async {
  final campaignTile = find.byKey(ValueKey('campaign-tile:$campaignName'));
  final campaignNameFinder = find.text(campaignName);

  await _waitForCondition(
    $.tester,
    () => campaignTile.evaluate().isNotEmpty || campaignNameFinder.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  if (campaignTile.evaluate().isNotEmpty) {
    await _tapVisible(campaignTile.first, $.tester);
  } else {
    await _tapVisible(campaignNameFinder.first, $.tester);
  }

  await _waitForCondition(
    $.tester,
    () => find.widgetWithText(FilledButton, 'Thêm event').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _openCreateEventForm(PatrolIntegrationTester $) async {
  final createEventButton = find.widgetWithText(FilledButton, 'Thêm event');

  await _waitForCondition(
    $.tester,
    () => createEventButton.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await _tapVisible(createEventButton.first, $.tester);
  await _waitForDialog($.tester, title: 'Tạo event');
}

Future<void> _saveEventFromDialog(
  PatrolIntegrationTester $, {
  required String name,
  required String assignedEmployeeEmail,
}) async {
  await _waitForDialog($.tester, title: 'Tạo event');

  final dialog = find.byType(AlertDialog).last;
  final nameField = find.descendant(
    of: dialog,
    matching: find.widgetWithText(TextFormField, 'Tên event'),
  );

  await $.tester.ensureVisible(nameField.first);
  await $.tester.enterText(nameField.first, name);
  await _pumpUi($.tester);

  await _assignEmployeeByEmailFromDialog(
    $,
    dialog: dialog,
    email: assignedEmployeeEmail,
  );

  final saveButton = find.descendant(
    of: dialog,
    matching: find.widgetWithText(FilledButton, 'Lưu'),
  );
  await _tapVisible(saveButton.first, $.tester);
}

Future<void> _assignEmployeeByEmailFromDialog(
  PatrolIntegrationTester $, {
  required Finder dialog,
  required String email,
}) async {
  final emailText = find.descendant(
    of: dialog,
    matching: find.text(email),
  );

  await _waitForCondition(
    $.tester,
    () => emailText.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  final tile = find.ancestor(
    of: emailText.first,
    matching: find.byType(CheckboxListTile),
  );

  if (tile.evaluate().isEmpty) {
    fail('Unable to locate employee assignment tile for $email.');
  }

  await _tapVisible(tile.first, $.tester);
}

Future<void> _openCampaignByName(
  PatrolIntegrationTester $, {
  required String campaignName,
}) async {
  final campaignTile = find.byKey(ValueKey('campaign-tile:$campaignName'));
  final campaignPane = find.byKey(ValueKey('campaign-events-pane:$campaignName'));
  final campaignNameFinder = find.text(campaignName);

  await _waitForCondition(
    $.tester,
    () => campaignTile.evaluate().isNotEmpty || campaignNameFinder.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 60),
  );

  if (campaignTile.evaluate().isNotEmpty) {
    await _tapVisible(campaignTile.first, $.tester);
  } else {
    await _tapVisible(campaignNameFinder.first, $.tester);
  }

  await _waitForCondition(
    $.tester,
    () => campaignPane.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _openEventByName(
  PatrolIntegrationTester $, {
  required String eventName,
}) async {
  final eventNameFinder = find.text(eventName);

  await _waitForCondition(
    $.tester,
    () => eventNameFinder.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await $.tester.ensureVisible(eventNameFinder.first);
  await _pumpUi($.tester);

  await _waitForCondition(
    $.tester,
    () => find.byTooltip('Chi tiết').evaluate().isNotEmpty ||
        find.text('Chi tiết').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  await _tapEventDetailAction($, eventName: eventName);

  await _waitForCondition(
    $.tester,
    () => find.text('Tương tác & Lịch sử').evaluate().isNotEmpty &&
        find.text('Điểm danh & Check-in').evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
}

Future<void> _tapEventDetailAction(
  PatrolIntegrationTester $, {
  required String eventName,
}) async {
  final keyedDetailAction = find.byKey(ValueKey('campaign-event-detail:$eventName'));
  if (keyedDetailAction.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(keyedDetailAction.first);
    await _pumpUi($.tester);
    await _tapVisible(keyedDetailAction.first, $.tester);
    return;
  }

  final eventCard = find.byKey(ValueKey('campaign-event-tile:$eventName'));

  if (eventCard.evaluate().isEmpty) {
    fail('Unable to locate the event tile for $eventName.');
  }

  final scopedTooltip = find.descendant(
    of: eventCard.first,
    matching: find.byTooltip('Chi tiết'),
  );
  if (scopedTooltip.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(scopedTooltip.first);
    await _pumpUi($.tester);
    await _tapVisible(scopedTooltip.first, $.tester);
    return;
  }

  final scopedLabel = find.descendant(
    of: eventCard.first,
    matching: find.text('Chi tiết'),
  );
  if (scopedLabel.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(scopedLabel.first);
    await _pumpUi($.tester);

    final scopedButton = find.ancestor(
      of: scopedLabel.first,
      matching: find.byType(OutlinedButton),
    );
    if (scopedButton.evaluate().isNotEmpty) {
      await _tapVisible(scopedButton.first, $.tester);
      return;
    }

    await _tapVisible(scopedLabel.first, $.tester);
    return;
  }

  fail('Unable to locate the event detail action button for $eventName.');
}

Future<void> _grantLocationPermissionIfNeeded(PatrolIntegrationTester $) async {
  if (await $.native.isPermissionDialogVisible(timeout: const Duration(seconds: 2))) {
    await $.native.grantPermissionWhenInUse();
  }
}

bool _isFilledButtonEnabled(String label) {
  final finder = find.widgetWithText(FilledButton, label);
  if (finder.evaluate().isEmpty) {
    return false;
  }

  final widget = finder.first.evaluate().first.widget;
  return widget is FilledButton && widget.onPressed != null;
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

Future<void> _waitForDialog(
  WidgetTester tester, {
  required String title,
}) async {
  await _waitForCondition(
    tester,
    () => find.text(title).evaluate().isNotEmpty &&
        (find.byType(AlertDialog).evaluate().isNotEmpty ||
            find.byType(Dialog).evaluate().isNotEmpty),
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
