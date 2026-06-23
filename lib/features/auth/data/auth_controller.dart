import 'package:flutter/foundation.dart';

import 'auth_service.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

/// ViewModel quản lý trạng thái đăng nhập — tương tự VietnamMapController
/// extends ChangeNotifier → khi state thay đổi, UI tự rebuild
class AuthController extends ChangeNotifier {
  AuthController({AuthServiceInterface? service})
      : _service = service ?? AuthService.instance {
    _init();
  }

  final AuthServiceInterface _service;

  AuthStatus _status = AuthStatus.loading;
  AppUser? _user;
  String? _errorMessage;

  AuthStatus get status => _status;
  AppUser? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _status == AuthStatus.loading;

  /// Lắng nghe auth stream khi khởi tạo
  /// Tương tự @PostConstruct trong Spring — chạy tự động sau khi tạo object
  void _init() {
    _service.isSignedIn.listen((signedIn) async {
      if (!signedIn) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
        return;
      }

      // Đã đăng nhập → load thêm role từ Firestore
      _status = AuthStatus.loading;
      notifyListeners();

      try {
        _user = await _service.getCurrentUser();
        _status = AuthStatus.authenticated;
        _errorMessage = null;
      } on Exception catch (e) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _errorMessage = _friendlyError(e.toString());
      } catch (e) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        _errorMessage = 'Đã xảy ra lỗi khi tải thông tin tài khoản.';
      }
      notifyListeners();
    });
  }

  // Future<void> signIn(String email, String password) async {
  //   _errorMessage = null;
  //   _status = AuthStatus.loading;
  //   notifyListeners();

  //   try {
  //     _user = await _service.signIn(email, password);
  //     _status = AuthStatus.authenticated;
  //     _errorMessage = null;
  //   } on Exception catch (e) {
  //     _status = AuthStatus.unauthenticated;
  //     _errorMessage = _friendlyError(e.toString());
  //   }

  //   notifyListeners();
  // }

  Future<void> signIn(
    String email,
    String password,
  ) async {
    _errorMessage = null;
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      print("========== SIGN IN START ==========");

      _user = await _service.signIn(
        email,
        password,
      );

      print("========== SIGN IN SUCCESS ==========");

      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } on Exception catch (e, s) {
      print("========== SIGN IN ERROR ==========");
      print(e.runtimeType);
      print(e);
      print(s);
      print("===================================");

      _status = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());

      rethrow;
    }

    notifyListeners();
  }

  Future<void> signUp(String email, String password, String name) async {
    _errorMessage = null;
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      _user = await _service.signUp(email, password, name);
      _status = AuthStatus.authenticated;
      _errorMessage = null;
    } on Exception catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = _friendlyError(e.toString());
    }

    notifyListeners();
  }

  Future<void> signOut() async {
    await _service.signOut();
    // isSignedIn stream sẽ tự emit false → _init() xử lý tiếp
  }

  /// Chuyển Firebase error code sang thông báo tiếng Việt dễ đọc
  String _friendlyError(String raw) {
    String clean = raw;
    if (clean.startsWith('Exception: ')) {
      clean = clean.substring('Exception: '.length);
    }
    if (clean.contains('Tài khoản của bạn') ||
        clean.contains('Email này đã bị xóa')) {
      return clean;
    }
    if (raw.contains('user-not-found') ||
        raw.contains('wrong-password') ||
        raw.contains('invalid-credential')) {
      return 'Email hoặc mật khẩu không đúng.';
    }
    if (raw.contains('email-already-in-use')) {
      return 'Email này đã tồn tại.';
    }
    if (raw.contains('weak-password')) {
      return 'Mật khẩu phải có ít nhất 6 ký tự.';
    }
    if (raw.contains('invalid-email')) {
      return 'Địa chỉ email không hợp lệ.';
    }
    if (raw.contains('network-request-failed')) {
      return 'Không có kết nối mạng.';
    }
    return 'Đã xảy ra lỗi. Vui lòng thử lại.';
  }
}
