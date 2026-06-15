import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';

enum _SortField { email, role, status }

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({
    super.key,
    required this.currentUserId,
    UserManagementServiceInterface? service,
  }) : _service = service;

  final String currentUserId;
  final UserManagementServiceInterface? _service;

  @override
  State<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  UserManagementServiceInterface get _svc =>
      widget._service ?? AuthService.instance;

  List<UserRecord>? _allUsers;
  String? _error;
  bool _loading = false;

  // Filter & sort state
  final _searchCtrl = TextEditingController();
  String _searchText = '';
  String _roleFilter = 'all';
  String _statusFilter = 'all';
  _SortField _sortField = _SortField.email;
  bool _sortAsc = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final users = await _svc.getOtherUsers(widget.currentUserId);
      setState(() {
        _allUsers = users;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  List<UserRecord> get _filtered {
    if (_allUsers == null) return [];
    var list = _allUsers!.toList();

    if (_searchText.isNotEmpty) {
      final q = _searchText.toLowerCase();
      list = list.where((u) => u.email.toLowerCase().contains(q)).toList();
    }
    if (_roleFilter != 'all') {
      list = list.where((u) => u.role == _roleFilter).toList();
    }
    if (_statusFilter == 'active') {
      list = list.where((u) => !u.disabled).toList();
    } else if (_statusFilter == 'disabled') {
      list = list.where((u) => u.disabled).toList();
    }

    list.sort((a, b) {
      int cmp;
      switch (_sortField) {
        case _SortField.role:
          cmp = a.role.compareTo(b.role);
          break;
        case _SortField.status:
          cmp = a.disabled.toString().compareTo(b.disabled.toString());
          break;
        case _SortField.email:
          cmp = a.email.toLowerCase().compareTo(b.email.toLowerCase());
          break;
      }
      return _sortAsc ? cmp : -cmp;
    });

    return list;
  }

  Future<void> _toggleDisable(UserRecord record) async {
    try {
      await _svc.setUserDisabled(record.uid, disabled: !record.disabled);
      await _load();
    } catch (e) {
      _snack('Không thể cập nhật: $e', isError: true);
    }
  }

  Future<void> _delete(UserRecord record) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: Text(
            'Xóa người dùng "${record.email}"?\n\nHành động này không thể hoàn tác.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy')),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _svc.deleteUserDocument(record.uid);
      _snack('Đã xóa ${record.email}');
      await _load();
    } catch (e) {
      _snack('Không thể xóa: $e', isError: true);
    }
  }

  Future<void> _editRole(UserRecord record) async {
    await showDialog(
      context: context,
      builder: (_) => _EditRoleDialog(
        record: record,
        onSave: (newRole) async {
          await _svc.setUserRole(record.uid, newRole);
          await _load();
        },
      ),
    );
  }

  void _snack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? Theme.of(context).colorScheme.error
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final filtered = _filtered;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Header ────────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
          color: cs.surfaceContainerLow,
          child: Row(
            children: [
              Icon(Icons.group, color: cs.primary),
              const SizedBox(width: 10),
              Text(
                'Quản lí người dùng',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              if (_allUsers != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: cs.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${filtered.length}/${_allUsers!.length}',
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                tooltip: 'Tải lại',
                onPressed: _loading ? null : _load,
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── Search + Filters ──────────────────────────────────────────────
        Container(
          color: cs.surfaceContainerLow,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search
              TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Tìm kiếm theo email...',
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _searchText = '');
                          },
                        )
                      : null,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  filled: true,
                  fillColor: cs.surface,
                ),
                onChanged: (v) => setState(() => _searchText = v),
              ),
              const SizedBox(height: 10),

              // Filter row
              Wrap(
                spacing: 8,
                runSpacing: 6,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('Role:',
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
                  ..._buildFilterChips(
                    options: const {
                      'all': 'Tất cả',
                      'admin': 'Admin',
                      'user': 'User'
                    },
                    current: _roleFilter,
                    onSelect: (v) => setState(() => _roleFilter = v),
                  ),
                  const SizedBox(width: 8),
                  Text('Trạng thái:',
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
                  ..._buildFilterChips(
                    options: const {
                      'all': 'Tất cả',
                      'active': 'Hoạt động',
                      'disabled': 'Đã tắt'
                    },
                    current: _statusFilter,
                    onSelect: (v) => setState(() => _statusFilter = v),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Sort row
              Row(
                children: [
                  Text('Sắp xếp:',
                      style: TextStyle(
                          fontSize: 12, color: cs.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(width: 8),
                  DropdownButton<_SortField>(
                    value: _sortField,
                    isDense: true,
                    underline: const SizedBox(),
                    style:
                        TextStyle(fontSize: 12, color: cs.onSurface),
                    items: const [
                      DropdownMenuItem(
                          value: _SortField.email, child: Text('Email')),
                      DropdownMenuItem(
                          value: _SortField.role, child: Text('Role')),
                      DropdownMenuItem(
                          value: _SortField.status, child: Text('Trạng thái')),
                    ],
                    onChanged: (v) =>
                        setState(() => _sortField = v ?? _SortField.email),
                  ),
                  IconButton(
                    icon: Icon(
                      _sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                    ),
                    tooltip: _sortAsc ? 'Tăng dần' : 'Giảm dần',
                    onPressed: () => setState(() => _sortAsc = !_sortAsc),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // ── Body ──────────────────────────────────────────────────────────
        Expanded(child: _buildBody(filtered)),
      ],
    );
  }

  List<Widget> _buildFilterChips({
    required Map<String, String> options,
    required String current,
    required ValueChanged<String> onSelect,
  }) {
    final cs = Theme.of(context).colorScheme;
    return options.entries.map((e) {
      final selected = current == e.key;
      return GestureDetector(
        onTap: () => onSelect(e.key),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: selected ? cs.primary : cs.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            e.value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: selected ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBody(List<UserRecord> filtered) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                color: Theme.of(context).colorScheme.error, size: 40),
            const SizedBox(height: 8),
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _load,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }
    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off,
                size: 48,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.3)),
            const SizedBox(height: 12),
            Text(
              _allUsers?.isEmpty == true
                  ? 'Chưa có người dùng nào khác.'
                  : 'Không tìm thấy kết quả phù hợp.',
              style: TextStyle(
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.5)),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: filtered.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (ctx, i) => _UserTile(
        record: filtered[i],
        onToggleDisable: () => _toggleDisable(filtered[i]),
        onDelete: () => _delete(filtered[i]),
        onEditRole: () => _editRole(filtered[i]),
      ),
    );
  }
}

// ── User tile với ExpansionTile để xem chi tiết ───────────────────────────────

class _UserTile extends StatelessWidget {
  const _UserTile({
    required this.record,
    required this.onToggleDisable,
    required this.onDelete,
    required this.onEditRole,
  });

  final UserRecord record;
  final VoidCallback onToggleDisable;
  final VoidCallback onDelete;
  final VoidCallback onEditRole;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDisabled = record.disabled;
    final isAdmin = record.isAdmin;

    return ExpansionTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: isDisabled
            ? cs.surfaceContainerHighest
            : (isAdmin ? cs.primaryContainer : cs.secondaryContainer),
        child: Icon(
          isAdmin ? Icons.admin_panel_settings : Icons.person,
          size: 18,
          color: isDisabled
              ? cs.onSurfaceVariant
              : (isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer),
        ),
      ),
      title: Text(
        record.email,
        style: TextStyle(
          fontSize: 13,
          color: isDisabled
              ? cs.onSurface.withValues(alpha: 0.45)
              : cs.onSurface,
          decoration: isDisabled ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: Row(
        children: [
          _Chip(
            label: isAdmin ? 'Admin' : 'User',
            bg: isDisabled
                ? cs.surfaceContainerHighest
                : (isAdmin ? cs.primaryContainer : cs.secondaryContainer),
            fg: isDisabled
                ? cs.onSurfaceVariant
                : (isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer),
          ),
          if (isDisabled) ...[
            const SizedBox(width: 6),
            _Chip(label: 'Đã tắt', bg: cs.errorContainer, fg: cs.onErrorContainer),
          ],
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Tooltip(
            message: 'Chỉnh sửa quyền',
            child: IconButton(
              icon: Icon(Icons.edit_outlined, size: 18, color: cs.primary),
              onPressed: onEditRole,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
          Tooltip(
            message: isDisabled ? 'Kích hoạt' : 'Vô hiệu hóa',
            child: IconButton(
              icon: Icon(
                isDisabled ? Icons.toggle_off : Icons.toggle_on,
                size: 22,
                color: isDisabled ? cs.outline : cs.primary,
              ),
              onPressed: onToggleDisable,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
          Tooltip(
            message: 'Xóa người dùng',
            child: IconButton(
              icon: Icon(Icons.delete_outline, size: 18, color: cs.error),
              onPressed: onDelete,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      // Detail khi expand
      children: [
        Container(
          color: cs.surfaceContainerLow,
          padding: const EdgeInsets.fromLTRB(72, 8, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(label: 'UID', value: record.uid),
              _DetailRow(label: 'Email', value: record.email),
              _DetailRow(label: 'Quyền', value: isAdmin ? 'Admin' : 'User'),
              _DetailRow(
                label: 'Trạng thái',
                value: isDisabled ? 'Đã tắt' : 'Hoạt động',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  color: cs.onSurface.withValues(alpha: 0.5),
                  fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.bg, required this.fg});
  final String label;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

// ── Edit role dialog ──────────────────────────────────────────────────────────

class _EditRoleDialog extends StatefulWidget {
  const _EditRoleDialog({required this.record, required this.onSave});

  final UserRecord record;
  final Future<void> Function(String role) onSave;

  @override
  State<_EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<_EditRoleDialog> {
  late String _role;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _role = widget.record.role;
  }

  @override
  Widget build(BuildContext context) {
    final unchanged = _role == widget.record.role;

    return AlertDialog(
      title: const Text('Chỉnh sửa quyền'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.record.email,
              style:
                  const TextStyle(fontSize: 12, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          RadioListTile<String>(
            dense: true,
            title: const Text('User'),
            subtitle: const Text('Chỉ xem bản đồ', style: TextStyle(fontSize: 11)),
            value: 'user',
            groupValue: _role,
            onChanged: _saving ? null : (v) => setState(() => _role = v!),
          ),
          RadioListTile<String>(
            dense: true,
            title: const Text('Admin'),
            subtitle: const Text('Quản lí toàn bộ hệ thống',
                style: TextStyle(fontSize: 11)),
            value: 'admin',
            groupValue: _role,
            onChanged: _saving ? null : (v) => setState(() => _role = v!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _saving || unchanged
              ? null
              : () async {
                  setState(() => _saving = true);
                  try {
                    await widget.onSave(_role);
                    if (mounted) Navigator.pop(context);
                  } catch (_) {
                    if (mounted) setState(() => _saving = false);
                  }
                },
          child: _saving
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Lưu'),
        ),
      ],
    );
  }
}
