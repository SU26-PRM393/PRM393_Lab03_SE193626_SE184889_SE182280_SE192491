import 'package:flutter/material.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.user, required this.onProfileUpdated});

  final AppUser user;
  final ValueChanged<AppUser> onProfileUpdated;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _oldPassCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _loading = false;
  bool _showChangePass = false;
  bool _obscureOldPass = true;
  bool _obscurePass = true;
  bool _obscureConfirmPass = true;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.user.name;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _oldPassCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);
    try {
      final name = _nameCtrl.text.trim();

      // 1. Update name
      await AuthService.instance.updateProfile(
        name: name,
        photoUrl: widget.user.photoUrl,
      );

      // 2. Change password if requested
      if (_showChangePass && _passCtrl.text.isNotEmpty) {
        await AuthService.instance.changePassword(
          _oldPassCtrl.text,
          _passCtrl.text,
        );
        _oldPassCtrl.clear();
        _passCtrl.clear();
        _confirmPassCtrl.clear();
        setState(() => _showChangePass = false);
      }

      // 3. Notify parent/shell with updated user info
      final updatedUser = AppUser(
        uid: widget.user.uid,
        email: widget.user.email,
        role: widget.user.role,
        name: name,
        photoUrl: widget.user.photoUrl,
      );
      widget.onProfileUpdated(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cập nhật tài khoản thành công!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final raw = e.toString();
        String friendly = 'Đã xảy ra lỗi. Vui lòng thử lại.';
        if (raw.contains('wrong-password') || raw.contains('invalid-credential')) {
          friendly = 'Mật khẩu hiện tại không đúng.';
        } else if (raw.contains('requires-recent-login')) {
          friendly = 'Phiên đăng nhập hết hạn. Vui lòng đăng xuất và đăng nhập lại.';
        } else if (raw.contains('network-request-failed')) {
          friendly = 'Không có kết nối mạng.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(friendly),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _togglePasswordVisibility(String field) {
    setState(() {
      switch (field) {
        case 'old':
          _obscureOldPass = !_obscureOldPass;
          break;
        case 'new':
          _obscurePass = !_obscurePass;
          break;
        case 'confirm':
          _obscureConfirmPass = !_obscureConfirmPass;
          break;
      }
    });
  }

  void _toggleChangePassword() {
    setState(() {
      _showChangePass = !_showChangePass;
      if (!_showChangePass) {
        _oldPassCtrl.clear();
        _passCtrl.clear();
        _confirmPassCtrl.clear();
      }
    });
  }

  Widget _buildProfileHeroCard(
    BuildContext context,
    ColorScheme cs,
    bool hasPhoto,
    String firstLetter,
  ) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor:
                  widget.user.isAdmin ? cs.primaryContainer : cs.secondaryContainer,
              backgroundImage: hasPhoto ? NetworkImage(widget.user.photoUrl!) : null,
              onBackgroundImageError: hasPhoto ? (_, __) {} : null,
              child: hasPhoto
                  ? null
                  : Text(
                      firstLetter,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: widget.user.isAdmin
                            ? cs.onPrimaryContainer
                            : cs.onSecondaryContainer,
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.user.name.isNotEmpty ? widget.user.name : 'Người dùng',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              widget.user.email,
              style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: widget.user.isAdmin ? cs.primary : cs.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.user.isAdmin ? 'QUẢN TRỊ VIÊN' : 'THÀNH VIÊN',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: cs.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thông tin cơ bản',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: cs.outlineVariant),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextFormField(
                  initialValue: widget.user.email,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ Email',
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: const Icon(Icons.lock_outline, size: 18),
                    helperText: 'Không thể thay đổi email đăng nhập',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(
                    labelText: 'Họ và tên',
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Vui lòng nhập họ và tên';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityHeader(ColorScheme cs) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Bảo mật',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: cs.primary,
          ),
        ),
        TextButton.icon(
          onPressed: _toggleChangePassword,
          icon: Icon(_showChangePass ? Icons.close : Icons.edit_outlined, size: 16),
          label: Text(_showChangePass ? 'Hủy đổi mật khẩu' : 'Đổi mật khẩu'),
        ),
      ],
    );
  }

  Widget _buildPasswordSection(ColorScheme cs) {
    if (!_showChangePass) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _oldPassCtrl,
              obscureText: _obscureOldPass,
              decoration: InputDecoration(
                labelText: 'Mật khẩu hiện tại',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureOldPass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => _togglePasswordVisibility('old'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (val) {
                if (_showChangePass && (val == null || val.isEmpty)) {
                  return 'Vui lòng nhập mật khẩu hiện tại';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passCtrl,
              obscureText: _obscurePass,
              decoration: InputDecoration(
                labelText: 'Mật khẩu mới',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePass ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () => _togglePasswordVisibility('new'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (val) {
                if (_showChangePass && (val == null || val.length < 6)) {
                  return 'Mật khẩu mới phải dài tối thiểu 6 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _confirmPassCtrl,
              obscureText: _obscureConfirmPass,
              decoration: InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPass
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () => _togglePasswordVisibility('confirm'),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (val) {
                if (_showChangePass && val != _passCtrl.text) {
                  return 'Mật khẩu xác nhận không khớp';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveAction() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: _save,
      icon: const Icon(Icons.save_outlined),
      label: const Text(
        'Lưu thay đổi',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmailUserContent(BuildContext context, ColorScheme cs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildBasicInfoSection(context, cs),
        const SizedBox(height: 20),
        _buildSecurityHeader(cs),
        const SizedBox(height: 10),
        _buildPasswordSection(cs),
        if (_showChangePass) const SizedBox(height: 20),
        _buildSaveAction(),
      ],
    );
  }

  Widget _buildGoogleAccountCard(ColorScheme cs) {
    return Card(
      elevation: 0,
      color: cs.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: cs.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.info_outline, color: cs.primary, size: 32),
            const SizedBox(height: 12),
            const Text(
              'Tài khoản liên kết Google',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Bạn đang đăng nhập bằng tài khoản Google. Thông tin hồ sơ của bạn được đồng bộ trực tiếp và bảo mật thông qua Google.',
              style: TextStyle(color: cs.onSurfaceVariant, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isEmailUser = AuthService.instance.isEmailPasswordUser;

    // Avatar preview values
    final hasPhoto = widget.user.photoUrl != null && widget.user.photoUrl!.trim().isNotEmpty;
    final displayName = _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : widget.user.email;
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        leading: Navigator.canPop(context) ? const BackButton(color: Colors.black) : null,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeroCard(context, cs, hasPhoto, firstLetter),
                  const SizedBox(height: 20),
                  if (isEmailUser) ...[
                    _buildEmailUserContent(context, cs),
                  ] else ...[
                    _buildGoogleAccountCard(cs),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
