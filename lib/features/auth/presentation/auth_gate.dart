import 'package:flutter/material.dart';

import '../../vietnam_map/presentation/vietnam_map_screen.dart';
import '../data/auth_controller.dart';
import 'login_screen.dart';

/// "Cổng bảo vệ" — quyết định user thấy màn hình nào dựa trên trạng thái auth
/// Tương tự SecurityFilterChain trong Spring Security
///
/// Luồng:
///   loading         → màn hình splash (chờ Firebase check token)
///   unauthenticated → LoginScreen
///   authenticated   → VietnamMapScreen (truyền AppUser vào để biết role)
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  // AuthController tạo ở đây để tồn tại suốt vòng đời app
  // (không tạo trong build() vì mỗi rebuild sẽ tạo instance mới → reset state)
  final _authController = AuthController();

  @override
  void dispose() {
    _authController.dispose();
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
            return VietnamMapScreen(appUser: _authController.user);
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
