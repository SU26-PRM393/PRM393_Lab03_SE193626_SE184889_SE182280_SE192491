// ignore_for_file: deprecated_member_use

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'support/patrol_app_helpers.dart';
import 'support/test_credentials.dart';

void main() {
  patrolTest(
    'profile navigation displays authenticated user information',
    ($) async {
      await launchAppAndSignInAsAdmin($);

      await openAccountAction($, actionLabel: 'Hồ sơ cá nhân');

      await waitForCondition(
        $.tester,
        () => find.text('Hồ sơ cá nhân').evaluate().isNotEmpty,
        timeout: const Duration(seconds: 30),
      );

      expect(find.text('Thông tin cơ bản'), findsOneWidget);
      expect(find.text('Địa chỉ Email'), findsOneWidget);
      expect(find.text('Họ và tên'), findsOneWidget);
      expect(find.text('QUẢN TRỊ VIÊN'), findsOneWidget);
      expect(find.text(PatrolTestCredentials.testAdminEmail), findsWidgets);
    },
  );
}