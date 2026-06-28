import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/services/auth_service.dart';

class UserManagementDialog extends StatefulWidget {
  const UserManagementDialog({
    super.key,
    required this.currentUserId,
    UserManagementServiceInterface? service,
  }) : _service = service;

  final String currentUserId;

  /// Injection point để test — production để null (dùng AuthService.instance)
  final UserManagementServiceInterface? _service;

  @override
  State<UserManagementDialog> createState() => _UserManagementDialogState();
}

class _UserManagementDialogState extends State<UserManagementDialog> {
  List<UserRecord>? _users;
  String? _error;
  // uid đang xử lý action — để disable button tránh bấm nhiều lần
  String? _loadingUid;

  UserManagementServiceInterface get _svc =>
      widget._service ?? AuthService.instance;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _users = null;
      _error = null;
    });
    try {
      final users = await _svc.getOtherUsers(widget.currentUserId);
      setState(() => _users = users);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _toggleDisable(UserRecord record) async {
    setState(() => _loadingUid = record.uid);
    try {
      await _svc.setUserDisabled(record.uid, disabled: !record.disabled);
      await _load();
    } catch (e) {
      _showError('Không thể cập nhật: $e');
    } finally {
      setState(() => _loadingUid = null);
    }
  }

  Future<void> _delete(UserRecord record) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text('Xóa người dùng "${record.email}"?\n\nHành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    setState(() => _loadingUid = record.uid);
    try {
      await _svc.deleteUserDocument(record.uid);
      await _load();
    } catch (e) {
      _showError('Không thể xóa: $e');
    } finally {
      setState(() => _loadingUid = null);
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 540, maxHeight: 620),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ────────────────────────────────────────────────────────
            Builder(builder: (context) {
              final cs = Theme.of(context).colorScheme;
              return Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
                decoration: BoxDecoration(
                  color: cs.primary,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.manage_accounts, color: cs.onPrimary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Quản lí người dùng',
                        style: TextStyle(
                          color: cs.onPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: cs.onPrimary),
                      hoverColor: cs.onPrimary.withValues(alpha: 0.1),
                      tooltip: 'Tải lại',
                      onPressed: _load,
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: cs.onPrimary),
                      hoverColor: cs.onPrimary.withValues(alpha: 0.1),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            }),

            // ── Body ──────────────────────────────────────────────────────────
            Expanded(child: _buildBody()),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 40),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: const Text('Thử lại')),
          ],
        ),
      );
    }

    if (_users == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_users!.isEmpty) {
      return const Center(
        child: Text('Chưa có người dùng nào khác.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _users!.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, i) => _UserTile(
        record: _users![i],
        isProcessing: _loadingUid == _users![i].uid,
        onToggleDisable: () => _toggleDisable(_users![i]),
        onDelete: () => _delete(_users![i]),
      ),
    );
  }
}

// ── Tile hiển thị 1 user ──────────────────────────────────────────────────────

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.record,
    required this.isProcessing,
    required this.onToggleDisable,
    required this.onDelete,
  });

  final UserRecord record;
  final bool isProcessing;
  final VoidCallback onToggleDisable;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = record.disabled;

    final normalBg = record.isAdmin ? cs.primaryContainer : cs.secondaryContainer;
    final avatarBg = isDisabled ? cs.surfaceContainerHighest : normalBg;
    final normalIconColor = record.isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer;
    final avatarIconColor = isDisabled ? cs.onSurfaceVariant : normalIconColor;

    final hasPhoto = record.photoUrl != null && record.photoUrl!.trim().isNotEmpty;
    final displayName = record.name.isNotEmpty ? record.name : record.email;
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: CircleAvatar(
        backgroundColor: avatarBg,
        backgroundImage: hasPhoto ? NetworkImage(record.photoUrl!) : null,
        onBackgroundImageError: hasPhoto
            ? (exception, stackTrace) {
                // Gracefully catch image loading errors
              }
            : null,
        child: hasPhoto
            ? null
            : Text(
                firstLetter,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: avatarIconColor,
                ),
              ),
      ),
      title: Text(
        record.email,
        style: TextStyle(
          fontSize: 14,
          color: isDisabled ? cs.onSurfaceVariant : cs.onSurface,
        ),
      ),
      subtitle: Row(
        children: [
          _RoleChip(role: record.role, disabled: isDisabled),
          if (isDisabled) ...[
            const SizedBox(width: 6),
            _StatusChip(
              label: 'Đã tắt',
              bg: cs.errorContainer,
              fg: cs.onErrorContainer,
            ),
          ],
        ],
      ),
      trailing: _buildTrailing(cs, isDisabled),
    );
  }

  Widget _buildTrailing(ColorScheme cs, bool isDisabled) {
    if (isProcessing) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2, color: cs.primary),
      );
    }
    final toggleIcon = isDisabled ? Icons.toggle_off : Icons.toggle_on;
    final toggleColor = isDisabled ? cs.outline : cs.primary;
    final toggleMsg = isDisabled ? 'Kích hoạt' : 'Vô hiệu hóa';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Tooltip(
          message: toggleMsg,
          child: IconButton(
            icon: Icon(toggleIcon, color: toggleColor, size: 28),
            hoverColor: toggleColor.withValues(alpha: 0.1),
            onPressed: onToggleDisable,
          ),
        ),
        Tooltip(
          message: 'Xóa người dùng',
          child: IconButton(
            icon: Icon(Icons.delete_outline, color: cs.error),
            hoverColor: cs.error.withValues(alpha: 0.1),
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({required this.role, required this.disabled});
  final String role;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = role == 'admin';

    final adminBg = isAdmin ? cs.primaryContainer : cs.secondaryContainer;
    final bg = disabled ? cs.surfaceContainerHighest : adminBg;
    final adminFg = isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer;
    final fg = disabled ? cs.onSurfaceVariant : adminFg;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        isAdmin ? 'Admin' : 'User',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: fg)),
    );
  }
}
