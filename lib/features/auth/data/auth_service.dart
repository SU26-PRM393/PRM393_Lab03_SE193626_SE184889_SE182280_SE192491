import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Role của user trong hệ thống
enum UserRole { user, admin }

/// Interface để AuthController có thể test được mà không cần Firebase thật
/// Chỉ khai báo những method mà AuthController cần gọi
abstract class AuthServiceInterface {
  Stream<bool> get isSignedIn;
  Future<AppUser?> getCurrentUser();
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signUp(String email, String password, String name);
  Future<void> signOut();
}

/// Interface để UserManagementDialog có thể test được
abstract class UserManagementServiceInterface {
  Future<List<UserRecord>> getOtherUsers(String excludeUid);
  Future<void> setUserDisabled(String uid, {required bool disabled});
  Future<void> deleteUserDocument(String uid);
  Future<void> setUserRole(String uid, String role);
}

/// Thông tin user sau khi đăng nhập thành công
class AppUser {
  const AppUser({
    required this.uid,
    required this.email,
    required this.role,
    required this.name,
  });

  final String uid;
  final String email;
  final UserRole role;
  final String name;

  bool get isAdmin => role == UserRole.admin;
}

/// Tương tự @Service trong Spring Boot — xử lý toàn bộ logic Auth
/// UI chỉ gọi qua class này, không gọi FirebaseAuth trực tiếp
class AuthService
    implements AuthServiceInterface, UserManagementServiceInterface {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Stream bool: true = đã đăng nhập, false = chưa
  @override
  Stream<bool> get isSignedIn => _auth.authStateChanges().map((u) => u != null);

  /// Đăng nhập bằng email + password
  /// Trả về AppUser (có role) hoặc ném exception nếu sai thông tin
  @override
  Future<AppUser> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    return _toAppUser(credential.user!);
  }

  /// Đăng ký tài khoản mới — mặc định role = 'user'
  @override
  Future<AppUser> signUp(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final uid = credential.user!.uid;

      // Tạo document trong collection 'users' với role mặc định và name
      await _db.collection('users').doc(uid).set({
        'email': email.trim(),
        'name': name.trim(),
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return _toAppUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Thay vì query Firestore trực tiếp (gây permission-denied khi chưa login),
        // Ta thử đăng nhập bằng email + password vừa điền.
        try {
          final signInCred = await _auth.signInWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

          final user = signInCred.user!;
          final doc = await _db.collection('users').doc(user.uid).get();

          if (!doc.exists) {
            // Nếu không tồn tại Firestore doc (tài khoản đã bị xóa), xóa Auth user hiện tại.
            await user.delete();

            // Tiến hành đăng ký lại từ đầu!
            final newCred = await _auth.createUserWithEmailAndPassword(
              email: email.trim(),
              password: password,
            );
            final newUid = newCred.user!.uid;
            await _db.collection('users').doc(newUid).set({
              'email': email.trim(),
              'name': name.trim(),
              'role': 'user',
              'createdAt': FieldValue.serverTimestamp(),
            });
            return _toAppUser(newCred.user!);
          } else {
            // Firestore doc có tồn tại (tài khoản bình thường đang hoạt động).
            // Đăng xuất và quăng lỗi email-already-in-use thông thường.
            await _auth.signOut();
            throw FirebaseAuthException(
              code: 'email-already-in-use',
              message: 'Email này đã tồn tại.',
            );
          }
        } catch (_) {
          // Nếu đăng nhập thất bại (hoặc bất kỳ lỗi nào như sai mật khẩu),
          // thì quăng lỗi email-already-in-use thông thường.
          throw FirebaseAuthException(
            code: 'email-already-in-use',
            message: 'Email này đã tồn tại.',
          );
        }
      }
      rethrow;
    }
  }

  /// Đăng xuất
  @override
  Future<void> signOut() => _auth.signOut();

  /// Lấy AppUser hiện tại (null nếu chưa đăng nhập)
  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _toAppUser(user);
  }

  /// Lấy danh sách tất cả users trừ chính mình
  @override
  Future<List<UserRecord>> getOtherUsers(String excludeUid) async {
    final snapshot = await _db.collection('users').get();
    return snapshot.docs
        .where((doc) => doc.id != excludeUid)
        .map((doc) => UserRecord.fromDoc(doc.id, doc.data()))
        .toList();
  }

  /// Vô hiệu hóa / kích hoạt user (chỉ cập nhật Firestore)
  @override
  Future<void> setUserDisabled(String uid, {required bool disabled}) =>
      _db.collection('users').doc(uid).update({'disabled': disabled});

  /// Xóa document user khỏi Firestore (tài khoản Auth vẫn còn nhưng không dùng được app)
  @override
  Future<void> deleteUserDocument(String uid) =>
      _db.collection('users').doc(uid).delete();

  /// Thay đổi role của user ('admin' hoặc 'user')
  @override
  Future<void> setUserRole(String uid, String role) =>
      _db.collection('users').doc(uid).update({'role': role});

  // Đọc role từ Firestore rồi ghép vào AppUser
  Future<AppUser> _toAppUser(User firebaseUser) async {
    final doc = await _db.collection('users').doc(firebaseUser.uid).get();
    if (!doc.exists) {
      try {
        await firebaseUser.delete();
      } catch (_) {
        await _auth.signOut();
      }
      throw Exception('Tài khoản của bạn đã bị xóa hoặc không tồn tại.');
    }
    final data = doc.data();

    // Tài khoản bị admin vô hiệu hóa → đăng xuất ngay
    if (data?['disabled'] == true) {
      await _auth.signOut();
      throw Exception('Tài khoản của bạn đã bị vô hiệu hóa.');
    }

    final roleStr = data?['role'] as String? ?? 'user';
    final role = roleStr == 'admin' ? UserRole.admin : UserRole.user;
    final name = data?['name'] as String? ?? '';

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      role: role,
      name: name,
    );
  }
}

/// Đại diện cho 1 dòng trong collection users — dùng cho màn hình quản lí
class UserRecord {
  const UserRecord({
    required this.uid,
    required this.email,
    required this.role,
    required this.disabled,
    required this.name,
  });

  factory UserRecord.fromDoc(String uid, Map<String, dynamic> data) {
    return UserRecord(
      uid: uid,
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      disabled: data['disabled'] as bool? ?? false,
      name: data['name'] as String? ?? '',
    );
  }

  final String uid;
  final String email;
  final String role;
  final bool disabled;
  final String name;

  bool get isAdmin => role == 'admin';
}
