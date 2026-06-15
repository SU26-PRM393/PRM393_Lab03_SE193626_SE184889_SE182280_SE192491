import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/admin/presentation/admin_shell.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_controller.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_service.dart';
import 'package:vietnam_map_flutter/features/auth/presentation/auth_gate.dart';
import 'package:vietnam_map_flutter/features/user/presentation/user_shell.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/presentation/vietnam_map_screen.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------
class _MockAuthService implements AuthServiceInterface {
  final _stream = StreamController<bool>.broadcast();

  AppUser? _user;

  void emitSignedIn(bool v) => _stream.add(v);
  void setCurrentUser(AppUser user) => _user = user;

  @override
  Stream<bool> get isSignedIn => _stream.stream;

  @override
  Future<AppUser?> getCurrentUser() async => _user;

  @override
  Future<AppUser> signIn(String e, String p) async => _user!;

  @override
  Future<AppUser> signUp(String e, String p, String name) async => _user!;

  @override
  Future<void> signOut() async => _stream.add(false);

  void dispose() => _stream.close();
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------
Widget _buildGate(AuthController ctrl) => MaterialApp(
      home: AuthGate(controller: ctrl),
    );

const _fakeUser = AppUser(
  uid: 'uid-1',
  email: 'user@test.com',
  role: UserRole.user,
  name: 'Fake User',
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  late _MockAuthService svc;
  late AuthController ctrl;

  setUp(() {
    svc = _MockAuthService();
    ctrl = AuthController(service: svc);
  });

  tearDown(() {
    ctrl.dispose();
    svc.dispose();
  });

  group('AuthGate — trạng thái loading', () {
    testWidgets('hiển thị SplashScreen (spinner) khi chưa có auth state',
        (tester) async {
      // Stream chưa emit gì → controller vẫn ở loading
      await tester.pumpWidget(_buildGate(ctrl));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Đăng nhập để tiếp tục'), findsNothing);
    });
  });

  group('AuthGate — trạng thái unauthenticated', () {
    testWidgets('hiển thị LoginScreen khi stream emit false', (tester) async {
      await tester.pumpWidget(_buildGate(ctrl));

      svc.emitSignedIn(false);
      await tester.pumpAndSettle();

      expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('quay lại LoginScreen sau khi đăng xuất', (tester) async {
      // Setup: đăng nhập trước
      svc.setCurrentUser(_fakeUser);
      await tester.pumpWidget(_buildGate(ctrl));
      svc.emitSignedIn(true);
      await tester.pump();
      await tester.pump();

      // Đăng xuất
      svc.emitSignedIn(false);
      await tester.pumpAndSettle();

      expect(find.text('Đăng nhập để tiếp tục'), findsOneWidget);
    });
  });

  group('AuthGate — trạng thái authenticated', () {
    testWidgets('hiển thị UserShell khi user thường đăng nhập',
        (tester) async {
      svc.setCurrentUser(_fakeUser);
      await tester.pumpWidget(_buildGate(ctrl));

      // runAsync cho phép Future thật chạy (getCurrentUser là async)
      await tester.runAsync(() async {
        svc.emitSignedIn(true);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);
      });
      await tester.pump();

      expect(find.byType(UserShell), findsOneWidget);
      expect(find.text('Đăng nhập để tiếp tục'), findsNothing);
    });

    testWidgets('UserShell nhận đúng AppUser khi là user thường',
        (tester) async {
      svc.setCurrentUser(_fakeUser);
      await tester.pumpWidget(_buildGate(ctrl));

      await tester.runAsync(() async {
        svc.emitSignedIn(true);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);
      });
      await tester.pump();

      final shell = tester.widget<UserShell>(find.byType(UserShell));
      expect(shell.user.uid, 'uid-1');
      expect(shell.user.isAdmin, isFalse);
    });
  });

  group('AuthGate — admin routing', () {
    testWidgets('hiển thị AdminShell khi user là admin', (tester) async {
      const adminUser = AppUser(
        uid: 'admin-uid',
        email: 'admin@test.com',
        role: UserRole.admin,
        name: 'Admin User',
      );
      svc.setCurrentUser(adminUser);
      await tester.pumpWidget(_buildGate(ctrl));

      await tester.runAsync(() async {
        svc.emitSignedIn(true);
        await Future.delayed(Duration.zero);
        await Future.delayed(Duration.zero);
      });
      await tester.pump();

      expect(find.byType(AdminShell), findsOneWidget);
      expect(find.byType(VietnamMapScreen), findsNothing);
    });
  });
}
