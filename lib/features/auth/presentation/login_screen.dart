import 'package:flutter/material.dart';

import '../data/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});

  final AuthController controller;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isSignUp = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSignUp) {
      await widget.controller.signUp(_emailCtrl.text, _passwordCtrl.text);
    } else {
      await widget.controller.signIn(_emailCtrl.text, _passwordCtrl.text);
    }
  }

  String? _validateEmail(String? v) {
    if (v == null || v.trim().isEmpty) return 'Nhập email';
    if (!v.contains('@')) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Nhập mật khẩu';
    if (_isSignUp && v.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String get _submitLabel => _isSignUp ? 'Đăng ký' : 'Đăng nhập';

  @override
  Widget build(BuildContext context) {
    final isLoading = widget.controller.isLoading;
    final error = widget.controller.errorMessage;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo / tiêu đề
                  const Icon(Icons.map, size: 64, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    'Bản đồ Việt Nam',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isSignUp ? 'Tạo tài khoản mới' : 'Đăng nhập để tiếp tục',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // Email field
                  TextFormField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  TextFormField(
                    controller: _passwordCtrl,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: const Icon(Icons.lock_outline),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                      ),
                    ),
                    validator: _validatePassword,
                  ),
                  const SizedBox(height: 8),

                  // Error message
                  if (error != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      error,
                      style: const TextStyle(color: Colors.red, fontSize: 13),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 20),

                  // Submit button
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(_submitLabel),
                  ),
                  const SizedBox(height: 12),

                  // Toggle login/signup
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () => setState(() {
                              _isSignUp = !_isSignUp;
                              widget.controller.errorMessage == null;
                            }),
                    child: Text(
                      _isSignUp
                          ? 'Đã có tài khoản? Đăng nhập'
                          : 'Chưa có tài khoản? Đăng ký',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
