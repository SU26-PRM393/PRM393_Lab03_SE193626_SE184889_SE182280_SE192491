import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_controller.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_service.dart';

// ---------------------------------------------------------------------------
// Mock không cần Firebase — điều khiển stream bằng tay
// ---------------------------------------------------------------------------
class MockAuthService implements AuthServiceInterface {
  final _signedInController = StreamController<bool>();

  AppUser? _currentUser;
  Exception? _signInError;
  Exception? _signUpError;
  Exception? _getCurrentUserError;

  /// Gửi event "đăng nhập / đăng xuất" vào stream
  void emitSignedIn(bool value) => _signedInController.add(value);

  /// Cấu hình để signIn trả về user thành công
  void stubSignInSuccess(AppUser user) {
    _currentUser = user;
    _signInError = null;
    _getCurrentUserError = null;
  }

  /// Cấu hình để signIn ném lỗi
  void stubSignInError(String firebaseCode) {
    _signInError = Exception(firebaseCode);
  }

  /// Cấu hình để signUp ném lỗi
  void stubSignUpError(String firebaseCode) {
    _signUpError = Exception(firebaseCode);
  }

  /// Cấu hình để getCurrentUser ném lỗi
  void stubGetCurrentUserError(String message) {
    _getCurrentUserError = Exception(message);
  }

  @override
  Stream<bool> get isSignedIn => _signedInController.stream;

  @override
  Future<AppUser?> getCurrentUser() async {
    if (_getCurrentUserError != null) throw _getCurrentUserError!;
    return _currentUser;
  }

  @override
  Future<AppUser> signIn(String email, String password) async {
    if (_signInError != null) throw _signInError!;
    return _currentUser!;
  }

  @override
  Future<AppUser> signUp(String email, String password, String name) async {
    if (_signUpError != null) throw _signUpError!;
    return _currentUser!;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    emitSignedIn(false);
  }

  void dispose() => _signedInController.close();
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------
const _adminUser = AppUser(uid: 'uid-1', email: 'admin@test.com', role: UserRole.admin, name: 'Admin User');
const _normalUser = AppUser(uid: 'uid-2', email: 'user@test.com', role: UserRole.user, name: 'Normal User');

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late MockAuthService mockService;
  late AuthController controller;

  setUp(() {
    mockService = MockAuthService();
    controller = AuthController(service: mockService);
  });

  tearDown(() {
    controller.dispose();
    mockService.dispose();
  });

  group('AuthController — initial state', () {
    test('starts as loading before auth stream emits', () {
      expect(controller.status, AuthStatus.loading);
      expect(controller.user, isNull);
      expect(controller.errorMessage, isNull);
    });
  });

  group('AuthController — auth stream', () {
    test('goes to unauthenticated when stream emits false', () async {
      mockService.emitSignedIn(false);
      await Future.microtask(() {});

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.user, isNull);
    });

    test('goes to authenticated when stream emits true and getCurrentUser returns user',
        () async {
      mockService.stubSignInSuccess(_adminUser);
      mockService.emitSignedIn(true);
      await Future.microtask(() {});
      await Future.microtask(() {}); // chờ getCurrentUser() hoàn thành

      expect(controller.status, AuthStatus.authenticated);
      expect(controller.user, _adminUser);
    });

    test('goes to unauthenticated with friendly error when getCurrentUser throws exception',
        () async {
      mockService.stubGetCurrentUserError('Tài khoản của bạn đã bị vô hiệu hóa.');
      mockService.emitSignedIn(true);
      await Future.microtask(() {});
      await Future.microtask(() {}); // chờ getCurrentUser() hoàn thành

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.user, isNull);
      expect(controller.errorMessage, 'Tài khoản của bạn đã bị vô hiệu hóa.');
    });
  });

  group('AuthController — signIn', () {
    test('sets authenticated and user on success', () async {
      mockService.stubSignInSuccess(_normalUser);

      await controller.signIn('user@test.com', '123456');

      expect(controller.status, AuthStatus.authenticated);
      expect(controller.user, _normalUser);
      expect(controller.errorMessage, isNull);
    });

    test('sets unauthenticated and friendly error on wrong password', () async {
      mockService.stubSignInError('wrong-password');

      await controller.signIn('user@test.com', 'wrong');

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.errorMessage, 'Email hoặc mật khẩu không đúng.');
    });

    test('maps invalid-credential to friendly message', () async {
      mockService.stubSignInError('invalid-credential');

      await controller.signIn('user@test.com', 'wrong');

      expect(controller.errorMessage, 'Email hoặc mật khẩu không đúng.');
    });

    test('maps network-request-failed to friendly message', () async {
      mockService.stubSignInError('network-request-failed');

      await controller.signIn('a@b.com', 'pass');

      expect(controller.errorMessage, 'Không có kết nối mạng.');
    });

    test('maps unknown error to generic message', () async {
      mockService.stubSignInError('some-unknown-code');

      await controller.signIn('a@b.com', 'pass');

      expect(controller.errorMessage, 'Đã xảy ra lỗi. Vui lòng thử lại.');
    });

    test('maps custom disabled error message correctly', () async {
      mockService.stubSignInError('Tài khoản của bạn đã bị vô hiệu hóa.');

      await controller.signIn('disabled@test.com', 'pass');

      expect(controller.errorMessage, 'Tài khoản của bạn đã bị vô hiệu hóa.');
    });

    test('maps custom deleted error message correctly', () async {
      mockService.stubSignInError('Tài khoản của bạn đã bị xóa hoặc không tồn tại.');

      await controller.signIn('deleted@test.com', 'pass');

      expect(controller.errorMessage, 'Tài khoản của bạn đã bị xóa hoặc không tồn tại.');
    });
  });

  group('AuthController — signUp', () {
    test('sets authenticated on success', () async {
      mockService.stubSignInSuccess(_normalUser);

      await controller.signUp('new@test.com', 'password123', 'Test Name');

      expect(controller.status, AuthStatus.authenticated);
      expect(controller.user, _normalUser);
    });

    test('maps email-already-in-use to friendly message', () async {
      mockService.stubSignUpError('email-already-in-use');

      await controller.signUp('dup@test.com', 'pass', 'Test Name');

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.errorMessage, 'Email này đã tồn tại.');
    });

    test('maps weak-password to friendly message', () async {
      mockService.stubSignUpError('weak-password');

      await controller.signUp('new@test.com', '123', 'Test Name');

      expect(controller.errorMessage, 'Mật khẩu phải có ít nhất 6 ký tự.');
    });

    test('maps invalid-email to friendly message', () async {
      mockService.stubSignUpError('invalid-email');

      await controller.signUp('not-an-email', 'pass', 'Test Name');

      expect(controller.errorMessage, 'Địa chỉ email không hợp lệ.');
    });
  });

  group('AuthController — signOut', () {
    test('goes to unauthenticated after signOut', () async {
      mockService.stubSignInSuccess(_adminUser);
      await controller.signIn('admin@test.com', 'pass');
      expect(controller.status, AuthStatus.authenticated);

      await controller.signOut();
      await Future.microtask(() {});

      expect(controller.status, AuthStatus.unauthenticated);
      expect(controller.user, isNull);
    });
  });

  group('AuthController — isLoading helper', () {
    test('isLoading true while in loading state', () {
      expect(controller.isLoading, isTrue);
    });

    test('isLoading false after unauthenticated', () async {
      mockService.emitSignedIn(false);
      await Future.microtask(() {});

      expect(controller.isLoading, isFalse);
    });
  });
}
