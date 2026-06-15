import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_service.dart';
import 'package:vietnam_map_flutter/features/auth/presentation/user_management_dialog.dart';

// ---------------------------------------------------------------------------
// Mock — không cần Firebase
// ---------------------------------------------------------------------------
class _MockUserManagementService implements UserManagementServiceInterface {
  final List<UserRecord> _users;
  Exception? _loadError;
  Exception? _actionError;

  final List<String> disabledCalls = [];
  final List<String> deleteCalls = [];

  _MockUserManagementService(this._users);

  void stubLoadError(Exception e) => _loadError = e;
  void stubActionError(Exception e) => _actionError = e;

  @override
  Future<List<UserRecord>> getOtherUsers(String excludeUid) async {
    if (_loadError != null) throw _loadError!;
    return _users;
  }

  @override
  Future<void> setUserDisabled(String uid, {required bool disabled}) async {
    if (_actionError != null) throw _actionError!;
    disabledCalls.add('$uid:$disabled');
    // Cập nhật trạng thái trong list để _load() lần sau thấy đúng
    final idx = _users.indexWhere((u) => u.uid == uid);
    if (idx != -1) {
      _users[idx] = UserRecord(
        uid: _users[idx].uid,
        email: _users[idx].email,
        role: _users[idx].role,
        disabled: disabled,
      );
    }
  }

  @override
  Future<void> deleteUserDocument(String uid) async {
    if (_actionError != null) throw _actionError!;
    deleteCalls.add(uid);
    _users.removeWhere((u) => u.uid == uid);
  }

  @override
  Future<void> setUserRole(String uid, String role) async {
    if (_actionError != null) throw _actionError!;
    final idx = _users.indexWhere((u) => u.uid == uid);
    if (idx != -1) {
      _users[idx] = UserRecord(
        uid: _users[idx].uid,
        email: _users[idx].email,
        role: role,
        disabled: _users[idx].disabled,
      );
    }
  }
}

/// Service giữ future chưa resolve — chỉ dùng để test loading state
class _BlockingUserManagementService implements UserManagementServiceInterface {
  _BlockingUserManagementService(this._completer);
  final Completer<List<UserRecord>> _completer;

  @override
  Future<List<UserRecord>> getOtherUsers(String _) => _completer.future;

  @override
  Future<void> setUserDisabled(String uid, {required bool disabled}) async {}

  @override
  Future<void> deleteUserDocument(String uid) async {}

  @override
  Future<void> setUserRole(String uid, String role) async {}
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------
const _currentUserId = 'admin-uid';

Widget _buildDialog(UserManagementServiceInterface svc) => MaterialApp(
      home: Scaffold(
        body: UserManagementDialog(
          currentUserId: _currentUserId,
          service: svc,
        ),
      ),
    );

UserRecord _user({
  String uid = 'uid-1',
  String email = 'user@test.com',
  String role = 'user',
  bool disabled = false,
}) =>
    UserRecord(uid: uid, email: email, role: role, disabled: disabled);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  group('UserManagementDialog — loading state', () {
    testWidgets('hiển thị spinner khi đang tải', (tester) async {
      // Dùng Completer để giữ future chưa complete → spinner hiển thị
      final completer = Completer<List<UserRecord>>();
      final svc = _BlockingUserManagementService(completer);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Giải phóng future để teardown sạch
      completer.complete([]);
      await tester.pumpAndSettle();
    });
  });

  group('UserManagementDialog — danh sách trống', () {
    testWidgets('hiển thị thông báo khi không có user khác', (tester) async {
      final svc = _MockUserManagementService([]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.text('Chưa có người dùng nào khác.'), findsOneWidget);
    });
  });

  group('UserManagementDialog — hiển thị danh sách', () {
    testWidgets('hiển thị header và danh sách đúng', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'alice@test.com', role: 'user'),
        _user(uid: 'uid-2', email: 'bob@test.com', role: 'admin'),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.text('Quản lí người dùng'), findsOneWidget);
      expect(find.text('alice@test.com'), findsOneWidget);
      expect(find.text('bob@test.com'), findsOneWidget);
      // Role chip
      expect(find.text('User'), findsOneWidget);
      expect(find.text('Admin'), findsOneWidget);
    });

    testWidgets('user bị disable hiển thị chip "Đã tắt"', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'disabled@test.com', disabled: true),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.text('Đã tắt'), findsOneWidget);
    });

    testWidgets('user active hiển thị icon toggle_on', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'active@test.com', disabled: false),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.toggle_on), findsOneWidget);
    });

    testWidgets('user bị disable hiển thị icon toggle_off', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'dis@test.com', disabled: true),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.toggle_off), findsOneWidget);
    });
  });

  group('UserManagementDialog — toggle disable', () {
    testWidgets('bấm toggle gọi setUserDisabled với disabled=true', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'active@test.com', disabled: false),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.toggle_on));
      await tester.pumpAndSettle();

      expect(svc.disabledCalls, contains('uid-1:true'));
    });

    testWidgets('bấm toggle_off gọi setUserDisabled với disabled=false',
        (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'dis@test.com', disabled: true),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.toggle_off));
      await tester.pumpAndSettle();

      expect(svc.disabledCalls, contains('uid-1:false'));
    });
  });

  group('UserManagementDialog — xóa user', () {
    testWidgets('bấm delete → hiện confirm dialog', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'todelete@test.com'),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.text('Xác nhận xóa'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Xóa'), findsOneWidget);
    });

    testWidgets('bấm Hủy → không xóa', (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'todelete@test.com'),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      expect(svc.deleteCalls, isEmpty);
      expect(find.text('todelete@test.com'), findsOneWidget);
    });

    testWidgets('bấm Xóa → gọi deleteUserDocument và xóa khỏi danh sách',
        (tester) async {
      final svc = _MockUserManagementService([
        _user(uid: 'uid-1', email: 'todelete@test.com'),
      ]);
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Xóa'));
      await tester.pumpAndSettle();

      expect(svc.deleteCalls, contains('uid-1'));
      expect(find.text('Chưa có người dùng nào khác.'), findsOneWidget);
    });
  });

  group('UserManagementDialog — lỗi tải dữ liệu', () {
    testWidgets('hiển thị thông báo lỗi khi getOtherUsers thất bại',
        (tester) async {
      final svc = _MockUserManagementService([]);
      svc.stubLoadError(Exception('Network error'));
      await tester.pumpWidget(_buildDialog(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });
  });
}
