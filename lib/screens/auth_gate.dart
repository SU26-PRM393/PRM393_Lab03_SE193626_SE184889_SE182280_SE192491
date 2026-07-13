import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/screens/admin_shell.dart';
import 'package:vietnam_map_flutter/screens/user_shell.dart';
import 'package:vietnam_map_flutter/viewmodels/auth_controller.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'login_screen.dart';

typedef UserShellBuilder = Widget Function(
  BuildContext context,
  AppUser user,
  VoidCallback onLogout,
);

typedef AdminShellBuilder = Widget Function(
  BuildContext context,
  AppUser admin,
  VoidCallback onLogout,
);

/// "Cổng bảo vệ" — quyết định user thấy màn hình nào dựa trên trạng thái auth
/// Tương tự SecurityFilterChain trong Spring Security
///
/// Luồng:
///   loading         → màn hình splash (chờ Firebase check token)
///   unauthenticated → LoginScreen
///   authenticated   → VietnamMapScreen (truyền AppUser vào để biết role)
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    this.controller,
    this.userShellBuilder,
    this.adminShellBuilder,
  });

  /// Injection point để test — production để null (tự tạo)
  final AuthController? controller;
  final UserShellBuilder? userShellBuilder;
  final AdminShellBuilder? adminShellBuilder;

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
              final builder = widget.adminShellBuilder;
              if (builder != null) {
                return builder(context, user, _authController.signOut);
              }
              return AdminShell(admin: user, onLogout: _authController.signOut);
            }
            final resolvedUser =
                user ?? const AppUser(uid: '', email: '', role: UserRole.user, name: '');
            final builder = widget.userShellBuilder;
            if (builder != null) {
              return builder(context, resolvedUser, _authController.signOut);
            }
            return UserShell(user: resolvedUser, onLogout: _authController.signOut);
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
