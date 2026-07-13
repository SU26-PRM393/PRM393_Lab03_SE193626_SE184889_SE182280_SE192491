// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';
import 'package:vietnam_map_flutter/main.dart' as app;

import 'support/test_credentials.dart';

const _googleSignInButtonKey = #patrolGoogleSignInButton;
const _authenticatedShellKey = #patrolAuthenticatedShell;

void main() {
  patrolTest(
    'google login authenticates on Android emulator',
    ($) async {
      expect(Platform.isAndroid, isTrue, reason: 'This Patrol flow is intended for Android emulator runs only.');
      PatrolTestCredentials.validateGoogleLogin();

      await app.main();
      await $( _googleSignInButtonKey).waitUntilVisible(timeout: const Duration(seconds: 30));

      if ($( _authenticatedShellKey).exists) {
        return;
      }

      await $( _googleSignInButtonKey).tap();

      if (!await _waitForAuthenticatedShell($, timeout: const Duration(seconds: 5))) {
        await _completeGoogleSignIn($);

        await _tapOptionalNativeAction($, labels: ['Continue', 'Tiếp tục'], timeout: const Duration(seconds: 8));
        await _tapOptionalNativeAction($, labels: ['I agree', 'Đồng ý', 'Accept'], timeout: const Duration(seconds: 8));
      }

      if (await $.native.isPermissionDialogVisible(timeout: const Duration(seconds: 2))) {
        await $.native.grantPermissionWhenInUse();
      }

      expect(
        await _waitForAuthenticatedShell($, timeout: const Duration(seconds: 60)),
        isTrue,
        reason: 'Google sign-in should route the emulator account into an authenticated shell.',
      );
    },
  );
}

Future<void> _completeGoogleSignIn(PatrolIntegrationTester $) async {
  if (await _tapOptionalNativeAction(
    $,
    labels: [PatrolTestCredentials.googleEmail],
    timeout: const Duration(seconds: 10),
  )) {
    return;
  }

  await _tapOptionalNativeAction(
    $,
    labels: ['Use another account', 'Sử dụng tài khoản khác', 'Add account'],
    timeout: const Duration(seconds: 5),
  );

  await _enterGoogleEmailIfNeeded($);
  await _enterGooglePasswordIfNeeded($);
}

Future<bool> _waitForAuthenticatedShell(
  PatrolIntegrationTester $, {
  required Duration timeout,
}) async {
  try {
    await $( _authenticatedShellKey).waitUntilVisible(timeout: timeout);
    return true;
  } catch (_) {
    return false;
  }
}

Future<void> _enterGoogleEmailIfNeeded(PatrolIntegrationTester $) async {
  final emailField = await _findVisibleSelector(
    $,
    selectors: [
      Selector(textContains: 'Email or phone'),
      Selector(textContains: 'Email hoặc số điện thoại'),
      Selector(textContains: 'email'),
    ],
    timeout: const Duration(seconds: 8),
  );

  if (emailField == null) {
    return;
  }

  await $.native.enterText(
    emailField,
    text: PatrolTestCredentials.googleEmail,
    timeout: const Duration(seconds: 5),
  );

  await _tapOptionalNativeAction(
    $,
    labels: ['Next', 'Tiếp theo'],
    timeout: const Duration(seconds: 8),
  );
}

Future<void> _enterGooglePasswordIfNeeded(PatrolIntegrationTester $) async {
  if (!PatrolTestCredentials.hasGooglePassword) {
    return;
  }

  final passwordField = await _findVisibleSelector(
    $,
    selectors: [
      Selector(textContains: 'Enter your password'),
      Selector(textContains: 'Nhập mật khẩu của bạn'),
      Selector(textContains: 'password'),
      Selector(contentDescriptionContains: 'password'),
    ],
    timeout: const Duration(seconds: 8),
  );

  if (passwordField == null) {
    return;
  }

  await $.native.enterText(
    passwordField,
    text: PatrolTestCredentials.googlePassword,
    timeout: const Duration(seconds: 5),
  );

  await _tapOptionalNativeAction(
    $,
    labels: ['Next', 'Tiếp theo'],
    timeout: const Duration(seconds: 8),
  );
}

Future<bool> _tapOptionalNativeAction(
  PatrolIntegrationTester $, {
  required List<String> labels,
  required Duration timeout,
}) async {
  for (final label in labels) {
    try {
      await $.native.waitUntilVisible(
        Selector(text: label),
        timeout: timeout,
      );
      await $.native.tap(
        Selector(text: label),
        timeout: const Duration(seconds: 5),
      );
      return true;
    } catch (_) {
      continue;
    }
  }

  return false;
}

Future<Selector?> _findVisibleSelector(
  PatrolIntegrationTester $, {
  required List<Selector> selectors,
  required Duration timeout,
}) async {
  for (final selector in selectors) {
    try {
      await $.native.waitUntilVisible(selector, timeout: timeout);
      return selector;
    } catch (_) {
      continue;
    }
  }

  return null;
}