import 'package:flutter/material.dart';

import '../../admin/presentation/admin_shell.dart';
import '../../user/presentation/user_shell.dart';
import '../data/auth_controller.dart';
import '../data/auth_service.dart';
import 'login_screen.dart';

/// "Cổng bảo vệ" — quyết định user thấy màn hình nào dựa trên trạng thái auth
/// Tương tự SecurityFilterChain trong Spring Security
///
/// Luồng:
///   loading         → màn hình splash (chờ Firebase check token)
///   unauthenticated → LoginScreen
///   authenticated   → VietnamMapScreen (truyền AppUser vào để biết role)
class AuthGate extends StatefulWidget {
  const AuthGate({super.key, this.controller});

  /// Injection point để test — production để null (tự tạo)
  final AuthController? controller;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final AuthController _authController;
  late final bool _ownsController;

  @override
  void initState() {
    super.initState();
    if (widget.controller != null) {
      _authController = widget.controller!;
      _ownsController = false;
    } else {
      _authController = AuthController();
      _ownsController = true;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _authController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _authController,
      builder: (context, _) {
        switch (_authController.status) {
          case AuthStatus.loading:
            return const _SplashScreen();

          case AuthStatus.unauthenticated:
            return LoginScreen(controller: _authController);

          case AuthStatus.authenticated:
            final user = _authController.user;
            if (user != null && user.isAdmin) {
              return AdminShell(
                admin: user,
                onLogout: _authController.signOut,
              );
            }
            return UserShell(
              user: user ?? const AppUser(uid: '', email: '', role: UserRole.user, name: ''),
              onLogout: _authController.signOut,
            );
        }
      },
    );
  }
}

/// Màn hình chờ trong khi Firebase kiểm tra token
class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map, size: 64, color: Colors.green),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
