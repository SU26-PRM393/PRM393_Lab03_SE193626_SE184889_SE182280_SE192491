// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _authenticatedShellKey = #patrolAuthenticatedShell;
const _confirmLabel = 'Xác nhận';

void main() {
  patrolTest(
    'host completes the event and campaign successfully',
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
      final campaignName = 'Patrol Host Complete Campaign $uniqueSuffix';
      final eventName = 'Patrol Host Complete Event $uniqueSuffix';

      await _openCampaignSection($);
      await _openCreateCampaignForm($);
      await _saveCampaignFromDialog(
        $,
        name: campaignName,
        description: 'Created to verify host event completion and campaign closeout.',
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
        hostEmail: PatrolTestCredentials.testAdminEmail,
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo event.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã tạo event.').evaluate().isEmpty,
        timeout: const Duration(seconds: 15),
      );

      await _openCampaignByName($, campaignName: campaignName);
      await _openEventByName($, eventName: eventName);

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Bắt đầu').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );
      await _tapVisible(find.widgetWithText(FilledButton, 'Bắt đầu').first, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.text('Đã bắt đầu sự kiện.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Kết thúc').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );
      await _tapVisible(find.widgetWithText(FilledButton, 'Kết thúc').first, $.tester);

      await _waitForDialog($.tester, title: 'Kết thúc sự kiện?');
      await _tapVisible(find.widgetWithText(FilledButton, _confirmLabel).last, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.text('Đã kết thúc sự kiện.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.text('Đã kết thúc sự kiện.').evaluate().isEmpty,
        timeout: const Duration(seconds: 15),
      );

      await _returnToCampaignPane(
        $.tester,
        campaignName: campaignName,
      );

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Hoàn thành chiến dịch').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );
      await _tapVisible(
        find.widgetWithText(FilledButton, 'Hoàn thành chiến dịch').first,
        $.tester,
      );

      await _waitForDialog($.tester, title: 'Hoàn thành chiến dịch?');
      await _tapVisible(find.widgetWithText(FilledButton, _confirmLabel).last, $.tester);

      await _waitForCondition(
        $.tester,
        () => find.text('Chiến dịch đã hoàn thành.').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      await _waitForCondition(
        $.tester,
        () => find.widgetWithText(FilledButton, 'Hoàn thành chiến dịch').evaluate().isEmpty,
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
    await _tapCampaignTile(campaignTile.first, $.tester);
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
  required String hostEmail,
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

  await _selectHostFromDialog($, dialog, hostEmail: hostEmail);

  final saveButton = find.descendant(
    of: dialog,
    matching: find.widgetWithText(FilledButton, 'Lưu'),
  );
  await _tapVisible(saveButton.first, $.tester);
}

Future<void> _selectHostFromDialog(
  PatrolIntegrationTester $,
  Finder dialog, {
  required String hostEmail,
}) async {
  final hostDropdown = find.descendant(
    of: dialog,
    matching: find.byType(DropdownButtonFormField<String>),
  );

  await _waitForCondition(
    $.tester,
    () => hostDropdown.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await _tapVisible(hostDropdown.first, $.tester);

  final hostOption = find.byWidgetPredicate((widget) {
    return widget is Text &&
        widget.data != null &&
        widget.data!.contains('($hostEmail)');
  });

  await _waitForCondition(
    $.tester,
    () => hostOption.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 15),
  );

  await _tapVisible(hostOption.last, $.tester);
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
    await _tapCampaignTile(campaignTile.first, $.tester);
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
  final eventCard = find.byKey(ValueKey('campaign-event-tile:$eventName'));
  final eventNameFinder = find.text(eventName);

  await _waitForCondition(
    $.tester,
    () => eventCard.evaluate().isNotEmpty || eventNameFinder.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );

  if (eventCard.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(eventCard.first);
  } else {
    await $.tester.ensureVisible(eventNameFinder.first);
  }
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
  final eventCard = find.byKey(ValueKey('campaign-event-tile:$eventName'));

  if (eventCard.evaluate().isEmpty) {
    fail('Unable to locate the event tile for $eventName.');
  }

  final visibleEventCard = eventCard.hitTestable();
  final scopedRoot = visibleEventCard.evaluate().isNotEmpty
      ? visibleEventCard.first
      : eventCard.first;

  final scopedKeyedAction = find.descendant(
    of: scopedRoot,
    matching: find.byKey(ValueKey('campaign-event-detail:$eventName')),
  );
  final scopedKeyedActionHitTestable = scopedKeyedAction.hitTestable();
  if (scopedKeyedActionHitTestable.evaluate().isNotEmpty) {
    await _tapVisible(scopedKeyedActionHitTestable.first, $.tester);
    return;
  }

  if (scopedKeyedAction.evaluate().isNotEmpty) {
    await _tapVisible(scopedKeyedAction.first, $.tester);
    return;
  }

  final scopedTooltip = find.descendant(
    of: scopedRoot,
    matching: find.byTooltip('Chi tiết'),
  );
  if (scopedTooltip.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(scopedTooltip.first);
    await _pumpUi($.tester);
    await _tapVisible(scopedTooltip.first, $.tester);
    return;
  }

  final scopedLabel = find.descendant(
    of: scopedRoot,
    matching: find.text('Chi tiết'),
  );
  if (scopedLabel.evaluate().isNotEmpty) {
    await $.tester.ensureVisible(scopedLabel.first);
    await _pumpUi($.tester);

    final scopedButton = find.ancestor(
      of: scopedLabel.first,
      matching: find.byType(OutlinedButton),
    );
    final scopedButtonHitTestable = scopedButton.hitTestable();
    if (scopedButtonHitTestable.evaluate().isNotEmpty) {
      await _tapVisible(scopedButtonHitTestable.first, $.tester);
      return;
    }

    if (scopedButton.evaluate().isNotEmpty) {
      await _tapVisible(scopedButton.first, $.tester);
      return;
    }

    final scopedLabelHitTestable = scopedLabel.hitTestable();
    if (scopedLabelHitTestable.evaluate().isNotEmpty) {
      await _tapVisible(scopedLabelHitTestable.first, $.tester);
      return;
    }

    await _tapVisible(scopedLabel.first, $.tester);
    return;
  }

  fail('Unable to locate the event detail action button for $eventName.');
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

Future<void> _tapCampaignTile(Finder campaignTile, WidgetTester tester) async {
  final tapSurface = find.descendant(
    of: campaignTile,
    matching: find.byType(InkWell),
  );

  if (tapSurface.evaluate().isNotEmpty) {
    await _tapVisible(tapSurface.first, tester);
    return;
  }

  await _tapVisible(campaignTile, tester);
}

Future<void> _returnToCampaignPane(
  WidgetTester tester, {
  required String campaignName,
}) async {
  final campaignPane = find.byKey(ValueKey('campaign-events-pane:$campaignName'));

  if (campaignPane.evaluate().isNotEmpty) {
    return;
  }

  await tester.pageBack();
  await _pumpUi(tester);

  await _waitForCondition(
    tester,
    () => campaignPane.evaluate().isNotEmpty,
    timeout: const Duration(seconds: 30),
  );
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
  final hitTestableFinder = finder.hitTestable();
  final tapTarget = hitTestableFinder.evaluate().isNotEmpty
      ? hitTestableFinder.first
      : finder.first;
  await tester.tap(tapTarget, warnIfMissed: false);
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