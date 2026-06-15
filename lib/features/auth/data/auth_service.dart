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
  Future<AppUser> signUp(String email, String password);
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
  });

  final String uid;
  final String email;
  final UserRole role;

  bool get isAdmin => role == UserRole.admin;
}

/// Tương tự @Service trong Spring Boot — xử lý toàn bộ logic Auth
/// UI chỉ gọi qua class này, không gọi FirebaseAuth trực tiếp
class AuthService implements AuthServiceInterface, UserManagementServiceInterface {
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
  Future<AppUser> signUp(String email, String password) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final uid = credential.user!.uid;

    // Tạo document trong collection 'users' với role mặc định
    await _db.collection('users').doc(uid).set({
      'email': email.trim(),
      'role': 'user',
      'createdAt': FieldValue.serverTimestamp(),
    });

    return _toAppUser(credential.user!);
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

  /// Đọc role từ Firestore rồi ghép vào AppUser
  Future<AppUser> _toAppUser(User firebaseUser) async {
    final doc = await _db.collection('users').doc(firebaseUser.uid).get();
    final data = doc.data();

    // Tài khoản bị admin vô hiệu hóa → đăng xuất ngay
    if (data?['disabled'] == true) {
      await _auth.signOut();
      throw Exception('Tài khoản của bạn đã bị vô hiệu hóa.');
    }

    final roleStr = data?['role'] as String? ?? 'user';
    final role = roleStr == 'admin' ? UserRole.admin : UserRole.user;

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      role: role,
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
  });

  factory UserRecord.fromDoc(String uid, Map<String, dynamic> data) {
    return UserRecord(
      uid: uid,
      email: data['email'] as String? ?? '',
      role: data['role'] as String? ?? 'user',
      disabled: data['disabled'] as bool? ?? false,
    );
  }

  final String uid;
  final String email;
  final String role;
  final bool disabled;

  bool get isAdmin => role == 'admin';
}
