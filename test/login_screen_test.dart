import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_controller.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_service.dart';
import 'package:vietnam_map_flutter/features/auth/presentation/login_screen.dart';

// ---------------------------------------------------------------------------
// Mock (không cần Firebase)
// ---------------------------------------------------------------------------
class _MockAuthService implements AuthServiceInterface {
  final _stream = StreamController<bool>.broadcast();

  AppUser? _nextUser;
  Exception? _nextError;

  void stubSuccess(AppUser user) {
    _nextUser = user;
    _nextError = null;
  }

  void stubError(String code) => _nextError = Exception(code);

  @override
  Stream<bool> get isSignedIn => _stream.stream;

  @override
  Future<AppUser?> getCurrentUser() async => _nextUser;

  @override
  Future<AppUser> signIn(String email, String password) async {
    if (_nextError != null) throw _nextError!;
    return _nextUser!;
  }

  @override
  Future<AppUser> signUp(String email, String password) async {
    if (_nextError != null) throw _nextError!;
    return _nextUser!;
  }

  @override
  Future<void> signOut() async => _stream.add(false);

  void dispose() => _stream.close();
}

// ---------------------------------------------------------------------------
// Helper — bọc ListenableBuilder để widget rebuild khi controller thay đổi
// ---------------------------------------------------------------------------
Widget _pump(_MockAuthService svc) {
  final ctrl = AuthController(service: svc);
  // emit unauthenticated ngay để thoát loading state
  svc._stream.add(false);
  return MaterialApp(
    home: ListenableBuilder(
      listenable: ctrl,
      builder: (_, __) => LoginScreen(controller: ctrl),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late _MockAuthService svc;

  setUp(() => svc = _MockAuthService());
  tearDown(() => svc.dispose());

  group('LoginScreen — render', () {
    testWidgets('hiển thị đủ các thành phần ở chế độ đăng nhập', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      expect(find.text('Bản đồ Việt Nam'), findsOneWidget);
      expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
      expect(find.text('Đăng nhập'), findsOneWidget);
      expect(find.text('Chưa có tài khoản? Đăng ký'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('chuyển sang chế độ đăng ký khi bấm toggle', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Tạo tài khoản mới'), findsOneWidget);
      expect(find.text('Đăng ký'), findsOneWidget);
      expect(find.text('Đã có tài khoản? Đăng nhập'), findsOneWidget);
    });

    testWidgets('chuyển lại về đăng nhập khi bấm toggle lần 2', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Đã có tài khoản? Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
    });
  });

  group('LoginScreen — form validation', () {
    testWidgets('hiện lỗi khi email trống', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Nhập email'), findsOneWidget);
    });

    testWidgets('hiện lỗi khi email không có @', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'notanemail');
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Email không hợp lệ'), findsOneWidget);
    });

    testWidgets('hiện lỗi khi mật khẩu trống', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Nhập mật khẩu'), findsOneWidget);
    });

    testWidgets('hiện lỗi mật khẩu ngắn khi đăng ký', (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Mật khẩu'), '123');
      await tester.tap(find.text('Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Mật khẩu tối thiểu 6 ký tự'), findsOneWidget);
    });
  });

  group('LoginScreen — password visibility toggle', () {
    testWidgets('bấm icon mắt thay đổi trạng thái ẩn/hiện mật khẩu',
        (tester) async {
      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      // Ban đầu mật khẩu bị ẩn (visibility_off)
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);

      await tester.tap(find.byIcon(Icons.visibility_off));
      await tester.pumpAndSettle();

      // Sau khi bấm, hiện icon visibility (không ẩn nữa)
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });
  });

  group('LoginScreen — error message từ controller', () {
    testWidgets('hiển thị error message khi signIn thất bại', (tester) async {
      svc.stubError('wrong-password');

      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'a@b.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Mật khẩu'), 'wrongpass');
      await tester.tap(find.text('Đăng nhập'));
      await tester.pumpAndSettle();

      expect(find.text('Email hoặc mật khẩu không đúng.'), findsOneWidget);
    });

    testWidgets('hiển thị error khi đăng ký với email đã tồn tại',
        (tester) async {
      svc.stubError('email-already-in-use');

      await tester.pumpWidget(_pump(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Chưa có tài khoản? Đăng ký'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.widgetWithText(TextFormField, 'Email'), 'dup@test.com');
      await tester.enterText(
          find.widgetWithText(TextFormField, 'Mật khẩu'), 'password123');
      await tester.tap(find.text('Đăng ký'));
      await tester.pumpAndSettle();

      expect(find.text('Email này đã được đăng ký.'), findsOneWidget);
    });
  });
}
