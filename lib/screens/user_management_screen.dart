import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/l10n/app_strings.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';

enum _SortField { name, email, role, status }

// Filter options are generated dynamically via l10n in build methods

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({
    super.key,
    required this.currentUserId,
    this.initialSearchText,
    UserManagementServiceInterface? service,
  }) : _service = service;

  final String currentUserId;
  final String? initialSearchText;
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
    _searchText = widget.initialSearchText ?? '';
    _searchCtrl.text = _searchText;
    _load();
  }

  @override
  void didUpdateWidget(UserManagementScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialSearchText != oldWidget.initialSearchText) {
      setState(() {
        _searchText = widget.initialSearchText ?? '';
        _searchCtrl.text = _searchText;
      });
    }
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
      list = list.where((u) =>
          u.email.toLowerCase().contains(q) ||
          u.name.toLowerCase().contains(q)).toList();
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
        case _SortField.name:
          cmp = a.name.toLowerCase().compareTo(b.name.toLowerCase());
          break;
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
    final l10n = context.l10n;
    try {
      await _svc.setUserDisabled(record.uid, disabled: !record.disabled);
      await _load();
    } catch (e) {
      _snack(l10n.cannotUpdate.replaceFirst('{error}', e.toString()), isError: true);
    }
  }

  Future<void> _delete(UserRecord record) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.confirmDelete),
        content: Text(l10n.deleteUserConfirmText.replaceFirst('{email}', record.email)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _svc.deleteUserDocument(record.uid);
      _snack(l10n.deletedUser.replaceFirst('{email}', record.email));
      await _load();
    } catch (e) {
      _snack(l10n.cannotDelete.replaceFirst('{error}', e.toString()), isError: true);
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

    final roleFilterOptions = {
      'all': context.l10n.all,
      'admin': 'Admin',
      'user': 'User',
    };

    final statusFilterOptions = {
      'all': context.l10n.all,
      'active': context.l10n.active,
      'disabled': context.l10n.disabled,
    };

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
                context.l10n.manageUsers,
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
                        fontSize: 13,
                        color: cs.onPrimaryContainer,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.refresh),
                hoverColor: cs.primary.withValues(alpha: 0.1),
                tooltip: context.l10n.refresh,
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
                  hintText: context.l10n.searchByEmailOrName,
                  prefixIcon: const Icon(Icons.search, size: 20),
                  suffixIcon: _searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          hoverColor: cs.primary.withValues(alpha: 0.1),
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
              if (MediaQuery.of(context).size.width < 700) ...[
                Row(
                  children: [
                    Text('${context.l10n.role}:',
                        style: TextStyle(
                            fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(width: 12),
                    ..._buildFilterChips(
                      options: roleFilterOptions,
                      current: _roleFilter,
                      onSelect: (v) => setState(() => _roleFilter = v),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('${context.l10n.status}:',
                        style: TextStyle(
                            fontSize: 13, color: cs.onSurface.withValues(alpha: 0.6))),
                    const SizedBox(width: 12),
                    ..._buildFilterChips(
                      options: statusFilterOptions,
                      current: _statusFilter,
                      onSelect: (v) => setState(() => _statusFilter = v),
                    ),
                  ],
                ),
              ] else ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('${context.l10n.role}:',
                        style: TextStyle(
                            fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
                    ..._buildFilterChips(
                      options: roleFilterOptions,
                      current: _roleFilter,
                      onSelect: (v) => setState(() => _roleFilter = v),
                    ),
                    const SizedBox(width: 8),
                    Text('${context.l10n.status}:',
                        style: TextStyle(
                            fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
                    ..._buildFilterChips(
                      options: statusFilterOptions,
                      current: _statusFilter,
                      onSelect: (v) => setState(() => _statusFilter = v),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),

              // Sort row
              Row(
                children: [
                  Text('${context.l10n.sortBy}:',
                      style: TextStyle(
                          fontSize: 14, color: cs.onSurface.withValues(alpha: 0.6))),
                  const SizedBox(width: 8),
                  _HoverDropdown(
                    child: DropdownButton<_SortField>(
                      value: _sortField,
                      isDense: true,
                      underline: const SizedBox(),
                      style:
                          TextStyle(fontSize: 14, color: cs.onSurface),
                      items: [
                        DropdownMenuItem(
                            value: _SortField.name, child: Text(context.l10n.fullName)),
                        DropdownMenuItem(
                            value: _SortField.email, child: Text(context.l10n.email)),
                        DropdownMenuItem(
                            value: _SortField.role, child: Text(context.l10n.role)),
                        DropdownMenuItem(
                            value: _SortField.status, child: Text(context.l10n.status)),
                      ],
                      onChanged: (v) =>
                          setState(() => _sortField = v ?? _SortField.email),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      _sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 16,
                    ),
                    hoverColor: cs.primary.withValues(alpha: 0.1),
                    tooltip: _sortAsc ? context.l10n.sortAsc : context.l10n.sortDesc,
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
    return options.entries.map((e) {
      return _FilterChipButton(
        label: e.value,
        selected: current == e.key,
        onTap: () => onSelect(e.key),
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
              label: Text(context.l10n.retry),
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
                  ? context.l10n.noOtherUsers
                  : context.l10n.noResultsFound,
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

    final cs = Theme.of(context).colorScheme;

    final isMobile = MediaQuery.of(context).size.width < 700;

    if (isMobile) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final record = filtered[index];
          final isDisabled = record.disabled;
          final isAdmin = record.isAdmin;
          final normalBg = isAdmin ? cs.primaryContainer : cs.secondaryContainer;
          final chipBg = isDisabled ? cs.surfaceContainerHighest : normalBg;
          final normalIconColor = isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer;
          final chipFg = isDisabled ? cs.onSurfaceVariant : normalIconColor;

          final hasPhoto = record.photoUrl != null && record.photoUrl!.trim().isNotEmpty;
          final displayName = record.name.isNotEmpty ? record.name : record.email;
          final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 0,
            color: cs.surfaceContainerLow,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              backgroundColor: chipBg,
                              backgroundImage: hasPhoto ? NetworkImage(record.photoUrl!) : null,
                              onBackgroundImageError: hasPhoto ? (_, __) {} : null,
                              child: hasPhoto
                                  ? null
                                  : Text(
                                      firstLetter,
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: chipFg,
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                record.name.isNotEmpty ? record.name : context.l10n.unnamed,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  fontStyle: record.name.isEmpty ? FontStyle.italic : FontStyle.normal,
                                  color: isDisabled ? cs.onSurface.withValues(alpha: 0.45) : cs.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Chip(label: isAdmin ? 'Admin' : 'User', bg: chipBg, fg: chipFg),
                          if (isDisabled) ...[
                            const SizedBox(width: 6),
                            _Chip(label: context.l10n.disabled, bg: cs.errorContainer, fg: cs.onErrorContainer),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    record.email,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDisabled ? cs.onSurface.withValues(alpha: 0.45) : cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'UID: ${record.uid}',
                    style: TextStyle(
                      fontSize: 11,
                      color: cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.edit_outlined, size: 16, color: cs.primary),
                        label: Text('Sửa quyền', style: TextStyle(fontSize: 12, color: cs.primary)),
                        onPressed: () => _editRole(record),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: Icon(isDisabled ? Icons.toggle_off : Icons.toggle_on, size: 18, color: isDisabled ? cs.outline : cs.primary),
                        label: Text(isDisabled ? 'Kích hoạt' : 'Tắt', style: TextStyle(fontSize: 12, color: isDisabled ? cs.outline : cs.primary)),
                        onPressed: () => _toggleDisable(record),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        icon: Icon(Icons.delete_outline, size: 16, color: cs.error),
                        label: Text('Xóa', style: TextStyle(fontSize: 12, color: cs.error)),
                        onPressed: () => _delete(record),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width - 210,
          ),
          child: DataTable(
            columns: const [
              DataColumn(label: Text('')),
              DataColumn(label: Text('Họ và tên', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Email', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Quyền', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
              DataColumn(label: Text('Hành động', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
            ],
            rows: filtered.map((record) {
              final isDisabled = record.disabled;
              final isAdmin = record.isAdmin;
              final normalBg = isAdmin ? cs.primaryContainer : cs.secondaryContainer;
              final chipBg = isDisabled ? cs.surfaceContainerHighest : normalBg;
              final normalIconColor = isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer;
              final chipFg = isDisabled ? cs.onSurfaceVariant : normalIconColor;

              final hasPhoto = record.photoUrl != null && record.photoUrl!.trim().isNotEmpty;
              final displayName = record.name.isNotEmpty ? record.name : record.email;
              final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

              return DataRow(
                cells: [
                  // Avatar column (no header)
                  DataCell(
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: chipBg,
                      backgroundImage: hasPhoto ? NetworkImage(record.photoUrl!) : null,
                      onBackgroundImageError: hasPhoto ? (_, __) {} : null,
                      child: hasPhoto
                          ? null
                          : Text(
                              firstLetter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: chipFg,
                              ),
                            ),
                    ),
                  ),
                  // Họ và tên
                  DataCell(
                    Text(
                      record.name.isNotEmpty ? record.name : 'Chưa có',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: record.name.isEmpty ? FontStyle.italic : FontStyle.normal,
                        color: isDisabled ? cs.onSurface.withValues(alpha: 0.45) : cs.onSurface,
                      ),
                    ),
                  ),
                  // Email (+ UID subtitle)
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          record.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDisabled ? cs.onSurface.withValues(alpha: 0.45) : cs.onSurface,
                          ),
                        ),
                        Text(
                          record.uid,
                          style: TextStyle(
                            fontSize: 12,
                            color: cs.onSurface.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quyền
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _Chip(label: isAdmin ? 'Admin' : 'User', bg: chipBg, fg: chipFg),
                        if (isDisabled) ...[
                          const SizedBox(width: 6),
                          _Chip(label: context.l10n.disabled, bg: cs.errorContainer, fg: cs.onErrorContainer),
                        ],
                      ],
                    ),
                  ),
                  // Hành động
                  DataCell(
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Tooltip(
                          message: 'Chỉnh sửa quyền',
                          child: IconButton(
                            icon: Icon(Icons.edit_outlined, size: 18, color: cs.primary),
                            hoverColor: cs.primary.withValues(alpha: 0.1),
                            onPressed: () => _editRole(record),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ),
                        Tooltip(
                          message: isDisabled ? 'Kích hoạt' : 'Vô hiệu hóa',
                          child: IconButton(
                            icon: Icon(isDisabled ? Icons.toggle_off : Icons.toggle_on, size: 22, color: isDisabled ? cs.outline : cs.primary),
                            hoverColor: (isDisabled ? cs.outline : cs.primary).withValues(alpha: 0.1),
                            onPressed: () => _toggleDisable(record),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ),
                        Tooltip(
                          message: 'Xóa người dùng',
                          child: IconButton(
                            icon: Icon(Icons.delete_outline, size: 18, color: cs.error),
                            hoverColor: cs.error.withValues(alpha: 0.1),
                            onPressed: () => _delete(record),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
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

  Future<void> _save() async {
    setState(() => _saving = true);
    final navigator = Navigator.of(context);
    try {
      await widget.onSave(_role);
      if (mounted) navigator.pop();
    } catch (_) {
      if (mounted) setState(() => _saving = false);
    }
  }

  Widget _buildSaveButton(bool unchanged) {
    if (_saving) {
      return const FilledButton(
        onPressed: null,
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return FilledButton(
      onPressed: unchanged ? null : _save,
      child: const Text('Lưu'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unchanged = _role == widget.record.role;

    return AlertDialog(
      title: const Text('Chỉnh sửa quyền', style: TextStyle(fontSize: 16)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.record.email,
              style:
                  const TextStyle(fontSize: 13, fontStyle: FontStyle.italic)),
          const SizedBox(height: 12),
          RadioGroup<String>(
            groupValue: _role,
            onChanged: (v) { if (!_saving && v != null) setState(() => _role = v); },
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RadioListTile<String>(
                  dense: true,
                  subtitle: Text('Chỉ xem bản đồ', style: TextStyle(fontSize: 11)),
                  value: 'user',
                ),
                RadioListTile<String>(
                  dense: true,
                  title: Text('Admin'),
                  subtitle: Text('Quản lí toàn bộ hệ thống', style: TextStyle(fontSize: 11)),
                  value: 'admin',
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        _buildSaveButton(unchanged),
      ],
    );
  }
}

class _FilterChipButton extends StatefulWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_FilterChipButton> createState() => _FilterChipButtonState();
}

class _FilterChipButtonState extends State<_FilterChipButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final normalBg = widget.selected ? cs.primary : cs.surfaceContainerHighest;
    final hoverBg = widget.selected
        ? cs.primary.withValues(alpha: 0.85)
        : cs.surfaceContainerHighest.withValues(alpha: 0.75);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: _hovered ? hoverBg : normalBg,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: widget.selected ? cs.onPrimary : cs.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _HoverDropdown extends StatefulWidget {
  const _HoverDropdown({required this.child});
  final Widget child;

  @override
  State<_HoverDropdown> createState() => _HoverDropdownState();
}

class _HoverDropdownState extends State<_HoverDropdown> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _hovered ? cs.surfaceContainerHighest : cs.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: _hovered ? cs.primary : cs.outlineVariant,
            width: 1,
          ),
        ),
        child: widget.child,
      ),
    );
  }
}
