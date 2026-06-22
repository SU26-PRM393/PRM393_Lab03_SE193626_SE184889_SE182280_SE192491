import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vietnam_map_flutter/features/auth/data/auth_service.dart';
import 'package:vietnam_map_flutter/features/admin/presentation/user_management_screen.dart';

// ---------------------------------------------------------------------------
// Mock
// ---------------------------------------------------------------------------
class _MockService implements UserManagementServiceInterface {
  final List<UserRecord> _users;
  Exception? _loadError;
  final List<String> disabledCalls = [];
  final List<String> deleteCalls = [];
  final List<String> roleCalls = [];

  _MockService(this._users);
  void stubLoadError(Exception e) => _loadError = e;

  @override
  Future<List<UserRecord>> getOtherUsers(String excludeUid) async {
    if (_loadError != null) throw _loadError!;
    return List.of(_users);
  }

  @override
  Future<void> setUserDisabled(String uid, {required bool disabled}) async {
    disabledCalls.add('$uid:$disabled');
    final idx = _users.indexWhere((u) => u.uid == uid);
    if (idx != -1) {
      _users[idx] = UserRecord(uid: uid, email: _users[idx].email, role: _users[idx].role, disabled: disabled, name: _users[idx].name);
    }
  }

  @override
  Future<void> deleteUserDocument(String uid) async {
    deleteCalls.add(uid);
    _users.removeWhere((u) => u.uid == uid);
  }

  @override
  Future<void> setUserRole(String uid, String role) async {
    roleCalls.add('$uid:$role');
    final idx = _users.indexWhere((u) => u.uid == uid);
    if (idx != -1) {
      _users[idx] = UserRecord(uid: uid, email: _users[idx].email, role: role, disabled: _users[idx].disabled, name: _users[idx].name);
    }
  }
}

class _BlockingService implements UserManagementServiceInterface {
  _BlockingService(this._completer);
  final Completer<List<UserRecord>> _completer;
  @override Future<List<UserRecord>> getOtherUsers(String _) => _completer.future;
  @override Future<void> setUserDisabled(String uid, {required bool disabled}) async {}
  @override Future<void> deleteUserDocument(String uid) async {}
  @override Future<void> setUserRole(String uid, String role) async {}
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------
const _currentUid = 'admin-uid';

Widget _buildScreen(UserManagementServiceInterface svc) => MaterialApp(
      home: Scaffold(body: UserManagementScreen(currentUserId: _currentUid, service: svc)),
    );

UserRecord _user({String uid = 'uid-1', String email = 'user@test.com', String role = 'user', bool disabled = false, String name = ''}) =>
    UserRecord(uid: uid, email: email, role: role, disabled: disabled, name: name);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------
void main() {
  setUp(() {
    final binding = TestWidgetsFlutterBinding.ensureInitialized();
    binding.platformDispatcher.views.first.physicalSize = const Size(1200, 800);
    binding.platformDispatcher.views.first.devicePixelRatio = 1.0;
  });

  // ── Loading ────────────────────────────────────────────────────────────────
  group('UserManagementScreen — loading', () {
    testWidgets('hiển thị spinner khi đang tải', (tester) async {
      final completer = Completer<List<UserRecord>>();
      await tester.pumpWidget(_buildScreen(_BlockingService(completer)));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete([]);
      await tester.pumpAndSettle();
    });
  });

  // ── Error ──────────────────────────────────────────────────────────────────
  group('UserManagementScreen — lỗi tải', () {
    testWidgets('hiển thị thông báo lỗi khi load thất bại', (tester) async {
      final svc = _MockService([]);
      svc.stubLoadError(Exception('Network error'));
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Thử lại'), findsOneWidget);
    });

    testWidgets('bấm Thử lại sẽ load lại dữ liệu', (tester) async {
      final svc = _MockService([]);
      svc.stubLoadError(Exception('err'));
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      // Gỡ lỗi, load lại
      svc.stubLoadError(Exception('err2'));
      await tester.tap(find.text('Thử lại'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });
  });

  // ── Empty ──────────────────────────────────────────────────────────────────
  group('UserManagementScreen — danh sách trống', () {
    testWidgets('hiển thị thông báo khi không có user nào', (tester) async {
      await tester.pumpWidget(_buildScreen(_MockService([])));
      await tester.pumpAndSettle();

      expect(find.text('Chưa có người dùng nào khác.'), findsOneWidget);
    });
  });

  // ── List render ───────────────────────────────────────────────────────────
  group('UserManagementScreen — hiển thị danh sách', () {
    testWidgets('hiển thị header với counter', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alice@test.com'),
        _user(uid: 'uid-2', email: 'bob@test.com'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('Quản lí người dùng'), findsOneWidget);
      expect(find.text('2/2'), findsOneWidget);
    });

    testWidgets('hiển thị email người dùng', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alice@test.com', role: 'user'),
        _user(uid: 'uid-2', email: 'bob@test.com', role: 'admin'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);
      expect(find.text('bob@test.com'), findsOneWidget);
    });

    testWidgets('user bị disabled hiển thị chip "Đã tắt"', (tester) async {
      final svc = _MockService([_user(email: 'dis@test.com', disabled: true)]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('Đã tắt'), findsWidgets);
    });

    testWidgets('hiển thị icon toggle_on cho user active', (tester) async {
      final svc = _MockService([_user(disabled: false)]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.toggle_on), findsOneWidget);
    });

    testWidgets('hiển thị icon toggle_off cho user bị disabled', (tester) async {
      final svc = _MockService([_user(disabled: true)]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.toggle_off), findsOneWidget);
    });
  });

  // ── Expand detail ─────────────────────────────────────────────────────────
  group('UserManagementScreen — xem chi tiết', () {
    testWidgets('hiển thị UID dưới dạng subtitle', (tester) async {
      final svc = _MockService([_user(uid: 'uid-abc', email: 'detail@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('uid-abc'), findsOneWidget);
    });
  });

  // ── Search ────────────────────────────────────────────────────────────────
  group('UserManagementScreen — tìm kiếm', () {
    testWidgets('tìm kiếm theo email lọc danh sách', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alice@test.com'),
        _user(uid: 'uid-2', email: 'bob@test.com'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'alice');
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);
      expect(find.text('bob@test.com'), findsNothing);
      expect(find.text('1/2'), findsOneWidget);
    });

    testWidgets('bấm nút xóa search reset về toàn bộ danh sách', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alice@test.com'),
        _user(uid: 'uid-2', email: 'bob@test.com'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'alice');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);
      expect(find.text('bob@test.com'), findsOneWidget);
    });

    testWidgets('tìm kiếm theo tên lọc danh sách', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alice@test.com', name: 'Alice Smith'),
        _user(uid: 'uid-2', email: 'bob@test.com', name: 'Bob Johnson'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'smith');
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);
      expect(find.text('bob@test.com'), findsNothing);
    });

    testWidgets('không tìm thấy kết quả hiển thị thông báo phù hợp', (tester) async {
      final svc = _MockService([_user(email: 'alice@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField).first, 'zzz');
      await tester.pumpAndSettle();

      expect(find.text('Không tìm thấy kết quả phù hợp.'), findsOneWidget);
    });
  });

  // ── Filter role ───────────────────────────────────────────────────────────
  group('UserManagementScreen — filter role', () {
    testWidgets('filter Admin chỉ hiển thị admin users', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'admin@test.com', role: 'admin'),
        _user(uid: 'uid-2', email: 'user@test.com', role: 'user'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Admin').first);
      await tester.pumpAndSettle();

      expect(find.text('admin@test.com'), findsOneWidget);
      expect(find.text('user@test.com'), findsNothing);
    });
  });

  // ── Filter status ─────────────────────────────────────────────────────────
  group('UserManagementScreen — filter status', () {
    testWidgets('filter Đã tắt chỉ hiển thị user bị vô hiệu hóa', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'active@test.com', disabled: false),
        _user(uid: 'uid-2', email: 'disabled@test.com', disabled: true),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Đã tắt').first);
      await tester.pumpAndSettle();

      expect(find.text('disabled@test.com'), findsOneWidget);
      expect(find.text('active@test.com'), findsNothing);
    });

    testWidgets('filter Hoạt động chỉ hiển thị user active', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'active@test.com', disabled: false),
        _user(uid: 'uid-2', email: 'disabled@test.com', disabled: true),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Hoạt động'));
      await tester.pumpAndSettle();

      expect(find.text('active@test.com'), findsOneWidget);
      expect(find.text('disabled@test.com'), findsNothing);
    });
  });

  // ── Toggle disable ────────────────────────────────────────────────────────
  group('UserManagementScreen — toggle disable', () {
    testWidgets('bấm toggle_on gọi setUserDisabled với disabled=true', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', disabled: false)]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.toggle_on));
      await tester.pumpAndSettle();

      expect(svc.disabledCalls, contains('uid-1:true'));
    });

    testWidgets('bấm toggle_off gọi setUserDisabled với disabled=false', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', disabled: true)]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.toggle_off));
      await tester.pumpAndSettle();

      expect(svc.disabledCalls, contains('uid-1:false'));
    });
  });

  // ── Delete ─────────────────────────────────────────────────────────────────
  group('UserManagementScreen — xóa user', () {
    testWidgets('bấm delete mở confirm dialog', (tester) async {
      final svc = _MockService([_user(email: 'todel@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();

      expect(find.text('Xác nhận xóa'), findsOneWidget);
      expect(find.text('Hủy'), findsOneWidget);
      expect(find.text('Xóa'), findsOneWidget);
    });

    testWidgets('bấm Hủy không gọi deleteUserDocument', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', email: 'todel@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      expect(svc.deleteCalls, isEmpty);
      expect(find.text('todel@test.com'), findsOneWidget);
    });

    testWidgets('bấm Xóa gọi deleteUserDocument và xóa khỏi danh sách', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', email: 'todel@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline).first);
      await tester.pumpAndSettle();
      // Tìm nút Xóa trong dialog (FilledButton)
      final deleteBtn = find.descendant(of: find.byType(AlertDialog), matching: find.text('Xóa'));
      await tester.tap(deleteBtn);
      await tester.pumpAndSettle();

      expect(svc.deleteCalls, contains('uid-1'));
      expect(find.text('Chưa có người dùng nào khác.'), findsOneWidget);
    });
  });

  // ── Edit role ─────────────────────────────────────────────────────────────
  group('UserManagementScreen — chỉnh sửa quyền', () {
    testWidgets('bấm edit mở dialog chỉnh sửa quyền', (tester) async {
      final svc = _MockService([_user(email: 'edit@test.com', role: 'user')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();

      expect(find.text('Chỉnh sửa quyền'), findsOneWidget);
      expect(find.text('User'), findsWidgets);
      expect(find.text('Admin'), findsWidgets);
    });

    testWidgets('bấm Hủy trong dialog không thay đổi role', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', role: 'user')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Hủy'));
      await tester.pumpAndSettle();

      expect(svc.roleCalls, isEmpty);
    });

    testWidgets('chọn Admin rồi Lưu gọi setUserRole với admin', (tester) async {
      final svc = _MockService([_user(uid: 'uid-1', email: 'edit@test.com', role: 'user')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.edit_outlined).first);
      await tester.pumpAndSettle();

      // Chọn radio Admin
      await tester.tap(find.text('Admin').last);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lưu'));
      await tester.pumpAndSettle();

      expect(svc.roleCalls, contains('uid-1:admin'));
    });
  });

  // ── Sort ──────────────────────────────────────────────────────────────────
  group('UserManagementScreen — sắp xếp', () {
    testWidgets('bấm sort toggle đảo chiều sắp xếp', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'alpha@test.com'),
        _user(uid: 'uid-2', email: 'beta@test.com'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      // Ban đầu asc → alpha trước
      final items = tester.widgetList<Text>(
        find.descendant(of: find.byType(DataTable), matching: find.byType(Text)),
      ).map((t) => t.data ?? '').where((s) => s.contains('@')).toList();
      expect(items.first, 'alpha@test.com');

      // Đảo chiều
      await tester.tap(find.byIcon(Icons.arrow_upward));
      await tester.pumpAndSettle();

      final itemsDesc = tester.widgetList<Text>(
        find.descendant(of: find.byType(DataTable), matching: find.byType(Text)),
      ).map((t) => t.data ?? '').where((s) => s.contains('@')).toList();
      expect(itemsDesc.first, 'beta@test.com');
    });
    testWidgets('sắp xếp theo tên', (tester) async {
      final svc = _MockService([
        _user(uid: 'uid-1', email: 'a@test.com', name: 'Zeta'),
        _user(uid: 'uid-2', email: 'b@test.com', name: 'Alpha'),
      ]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      // Mặc định sắp xếp theo email -> a@test.com trước
      var items = tester.widgetList<Text>(
        find.descendant(of: find.byType(DataTable), matching: find.byType(Text)),
      ).map((t) => t.data ?? '').where((s) => s.contains('@')).toList();
      expect(items.first, 'a@test.com');

      // Chọn sắp xếp theo Họ và tên
      await tester.tap(find.byWidgetPredicate((w) => w.runtimeType.toString().startsWith('DropdownButton')).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Họ và tên').last);
      await tester.pumpAndSettle();

      // Sắp xếp asc theo tên -> Alpha (b@test.com) trước Zeta (a@test.com)
      items = tester.widgetList<Text>(
        find.descendant(of: find.byType(DataTable), matching: find.byType(Text)),
      ).map((t) => t.data ?? '').where((s) => s.contains('@')).toList();
      expect(items.first, 'b@test.com');
    });
  });

  // ── Refresh ───────────────────────────────────────────────────────────────
  group('UserManagementScreen — refresh', () {
    testWidgets('bấm refresh icon tải lại danh sách', (tester) async {
      final svc = _MockService([_user(email: 'alice@test.com')]);
      await tester.pumpWidget(_buildScreen(svc));
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.refresh));
      await tester.pumpAndSettle();

      expect(find.text('alice@test.com'), findsOneWidget);
    });
  });
}
