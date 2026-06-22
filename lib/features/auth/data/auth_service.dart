import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../firebase_options.dart';

/// Role của user trong hệ thống
enum UserRole { user, admin }

/// Interface để AuthController có thể test được mà không cần Firebase thật
/// Chỉ khai báo những method mà AuthController cần gọi
abstract class AuthServiceInterface {
  Stream<bool> get isSignedIn;
  Future<AppUser?> getCurrentUser();
  Future<AppUser> signIn(String email, String password);
  Future<AppUser> signUp(String email, String password, String name);
  Future<AppUser> signInWithGoogle();
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
class AuthService implements AuthServiceInterface, UserManagementServiceInterface {
  AuthService._();
  static final instance = AuthService._();

  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /// Stream bool: true = đã đăng nhập, false = chưa
  @override
  Stream<bool> get isSignedIn => _auth.authStateChanges().map((u) => u != null);

  /// Đăng nhập bằng Google sử dụng phương pháp Loopback (mở trình duyệt mặc định bảo mật)
  @override
  Future<AppUser> signInWithGoogle() async {
    // 0. Nếu chạy trên Android hoặc iOS, sử dụng SDK native của google_sign_in
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      final googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Đăng nhập bằng Google bị hủy.');
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user!;

      // Đảm bảo document user tồn tại trong Firestore (giống desktop)
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (!userDoc.exists) {
        await _db.collection('users').doc(user.uid).set({
          'email': user.email ?? '',
          'name': user.displayName ?? user.email?.split('@').first ?? 'User',
          'role': 'user',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return _toAppUser(user);
    }

    const clientId = DefaultFirebaseOptions.googleClientId;
    if (clientId.isEmpty || 
        clientId.contains('YOUR_CLIENT_ID_SUFFIX') || 
        clientId == 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com') {
      throw Exception('Vui lòng cấu hình googleClientId trong lib/firebase_options.dart');
    }

    // 1. Tạo local HTTP Server để hứng callback

    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final port = server.port;
    final redirectUri = 'http://localhost:$port';

    // 2. Tạo PKCE verifier và challenge
    final random = Random.secure();
    const chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~';
    final codeVerifier = List.generate(80, (index) => chars[random.nextInt(chars.length)]).join();
    
    final verifierBytes = utf8.encode(codeVerifier);
    final verifierDigest = sha256.convert(verifierBytes);
    final codeChallenge = base64Url.encode(verifierDigest.bytes).replaceAll('=', '');

    // 3. Tạo Google OAuth URL
    final scopes = ['openid', 'email', 'profile'];
    final authUri = Uri.https('accounts.google.com', '/o/oauth2/v2/auth', {
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'response_type': 'code',
      'scope': scopes.join(' '),
      'code_challenge': codeChallenge,
      'code_challenge_method': 'S256',
    });

    // 4. Mở trình duyệt mặc định của hệ thống
    if (!await launchUrl(authUri, mode: LaunchMode.externalApplication)) {
      await server.close();
      throw Exception('Không thể mở trình duyệt.');
    }

    // 5. Lắng nghe Authorization Code từ trình duyệt
    String? authCode;
    try {
      await for (final request in server) {
        final code = request.uri.queryParameters['code'];
        if (code != null) {
          authCode = code;
          
          // Trả về trang HTML thông báo đăng nhập thành công
          request.response.statusCode = 200;
          request.response.headers.contentType = ContentType.html;
          request.response.write('''
            <!DOCTYPE html>
            <html>
            <head>
              <meta charset="utf-8">
              <title>Đăng nhập thành công</title>
              <style>
                body {
                  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
                  display: flex;
                  flex-direction: column;
                  align-items: center;
                  justify-content: center;
                  height: 100vh;
                  margin: 0;
                  background-color: #f5f5f7;
                }
                .card {
                  background: white;
                  padding: 40px;
                  border-radius: 12px;
                  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                  text-align: center;
                }
                h1 { color: #34c759; margin-top: 0; }
                p { color: #8e8e93; }
              </style>
            </head>
            <body>
              <div class="card">
                <h1>Đăng nhập thành công!</h1>
                <p>Bạn có thể đóng trình duyệt này và quay lại ứng dụng Bản đồ Việt Nam.</p>
              </div>
            </body>
            </html>
          ''');
          await request.response.close();
          break;
        } else {
          request.response.statusCode = 400;
          request.response.headers.contentType = ContentType.html;
          request.response.write('<h1>Lỗi đăng nhập</h1><p>Không nhận được mã xác thực.</p>');
          await request.response.close();
        }
      }
    } finally {
      await server.close();
    }

    if (authCode == null) {
      throw Exception('Đăng nhập bằng Google bị hủy.');
    }

    // 6. Trao đổi authCode lấy tokens
    final httpClient = HttpClient();
    final tokenRequest = await httpClient.postUrl(Uri.parse('https://oauth2.googleapis.com/token'));
    tokenRequest.headers.contentType = ContentType.json;
    final body = {
      'client_id': clientId,
      'code': authCode,
      'code_verifier': codeVerifier,
      'redirect_uri': redirectUri,
      'grant_type': 'authorization_code',
    };

    if (DefaultFirebaseOptions.googleClientSecret.isNotEmpty) {
      body['client_secret'] = DefaultFirebaseOptions.googleClientSecret;
    }

    tokenRequest.write(jsonEncode(body));

    final tokenResponse = await tokenRequest.close();
    final responseBody = await tokenResponse.transform(utf8.decoder).join();
    httpClient.close();

    if (tokenResponse.statusCode != 200) {
      throw Exception('Không thể trao đổi mã xác thực với Google: $responseBody');
    }

    final tokenData = jsonDecode(responseBody) as Map<String, dynamic>;
    final accessToken = tokenData['access_token'] as String?;
    final idToken = tokenData['id_token'] as String?;

    if (accessToken == null || idToken == null) {
      throw Exception('Không nhận được tokens từ Google.');
    }

    // 7. Đăng nhập vào Firebase Auth bằng credential
    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );
    
    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user!;

    // 8. Đảm bảo document user tồn tại trong Firestore
    final userDoc = await _db.collection('users').doc(user.uid).get();
    if (!userDoc.exists) {
      await _db.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'name': user.displayName ?? user.email?.split('@').first ?? 'User',
        'role': 'user',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    return _toAppUser(user);
  }

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

  /// Đọc role từ Firestore rồi ghép vào AppUser
  Future<AppUser> _toAppUser(User firebaseUser) async {
    var doc = await _db.collection('users').doc(firebaseUser.uid).get();
    
    // Nếu chưa có doc, thử đợi tối đa 3 giây (retry mỗi 300ms) đề phòng trường hợp đang tạo tài khoản mới/Google login
    int retries = 0;
    while (!doc.exists && retries < 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      doc = await _db.collection('users').doc(firebaseUser.uid).get();
      retries++;
    }

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
