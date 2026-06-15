import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import 'user_management_screen.dart';

enum AdminSection { overview, userManagement }

/// Dashboard layout: sidebar có thể thu gọn + vùng nội dung chính
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({
    super.key,
    required this.admin,
    required this.onLogout,
    UserManagementServiceInterface? service,
  }) : _service = service;

  final AppUser admin;
  final VoidCallback onLogout;
  final UserManagementServiceInterface? _service;

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _expanded = false;
  AdminSection _section = AdminSection.overview;

  static const _collapsedWidth = 56.0;
  static const _expandedWidth = 210.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          width: _expanded ? _expandedWidth : _collapsedWidth,
          child: _Sidebar(
            expanded: _expanded,
            section: _section,
            onToggle: () => setState(() => _expanded = !_expanded),
            onSelect: (s) => setState(() {
              _section = s;
              // auto-collapse on small screen
            }),
            onLogout: widget.onLogout,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(
          child: _buildBody(),
        ),
      ],
    );
  }

  Widget _buildBody() {
    switch (_section) {
      case AdminSection.overview:
        return _DashboardOverview(
          admin: widget.admin,
          service: widget._service,
        );
      case AdminSection.userManagement:
        return UserManagementScreen(
          currentUserId: widget.admin.uid,
          service: widget._service,
        );
    }
  }
}

// ── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.expanded,
    required this.section,
    required this.onToggle,
    required this.onSelect,
    required this.onLogout,
  });

  final bool expanded;
  final AdminSection section;
  final VoidCallback onToggle;
  final ValueChanged<AdminSection> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toggle button
          SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment:
                  expanded ? MainAxisAlignment.end : MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    expanded ? Icons.chevron_left : Icons.menu,
                    color: cs.onSurfaceVariant,
                  ),
                  tooltip: expanded ? 'Thu gọn' : 'Mở rộng',
                  onPressed: onToggle,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          const SizedBox(height: 4),

          // Nav items
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            selected: section == AdminSection.overview,
            expanded: expanded,
            onTap: () => onSelect(AdminSection.overview),
          ),
          _SidebarItem(
            icon: Icons.group_outlined,
            label: 'Người dùng',
            selected: section == AdminSection.userManagement,
            expanded: expanded,
            onTap: () => onSelect(AdminSection.userManagement),
          ),
          _SidebarItem(
            icon: Icons.bar_chart_outlined,
            label: 'Thống kê',
            selected: false,
            expanded: expanded,
            disabled: true,
            onTap: null,
          ),
          _SidebarItem(
            icon: Icons.settings_outlined,
            label: 'Cài đặt',
            selected: false,
            expanded: expanded,
            disabled: true,
            onTap: null,
          ),

          const Spacer(),
          const Divider(height: 1),
          const SizedBox(height: 4),

          // Logout
          _SidebarItem(
            icon: Icons.logout,
            label: 'Đăng xuất',
            selected: false,
            expanded: expanded,
            onTap: onLogout,
            iconColor: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.onTap,
    this.disabled = false,
    this.iconColor,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;
  final bool disabled;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final defaultColor = selected ? cs.primary : cs.onSurfaceVariant;
    final activeColor = iconColor ?? defaultColor;
    final effectiveColor = disabled
        ? cs.onSurface.withValues(alpha: 0.35)
        : activeColor;

    final item = Tooltip(
      message: expanded ? '' : label,
      preferBelow: false,
      child: InkWell(
        onTap: disabled ? null : onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 44,
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          padding: EdgeInsets.symmetric(horizontal: expanded ? 10 : 0),
          decoration: selected
              ? BoxDecoration(
                  color: cs.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                )
              : null,
          child: Row(
            mainAxisAlignment:
                expanded ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: effectiveColor),
              if (expanded) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: effectiveColor,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return item;
  }
}

// ── Dashboard overview ────────────────────────────────────────────────────────

class _DashboardOverview extends StatefulWidget {
  const _DashboardOverview({required this.admin, this.service});

  final AppUser admin;
  final UserManagementServiceInterface? service;

  @override
  State<_DashboardOverview> createState() => _DashboardOverviewState();
}

class _DashboardOverviewState extends State<_DashboardOverview> {
  UserManagementServiceInterface get _svc =>
      widget.service ?? AuthService.instance;

  int? _userCount;

  @override
  void initState() {
    super.initState();
    _loadUserCount();
  }

  Future<void> _loadUserCount() async {
    try {
      final users = await _svc.getOtherUsers(widget.admin.uid);
      // +1 để tính cả chính admin đang đăng nhập
      if (mounted) setState(() => _userCount = users.length + 1);
    } catch (_) {
      // Nếu lỗi giữ hiển thị '—'
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xin chào, ${widget.admin.email}',
              style: textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text('Bảng điều khiển quản trị viên',
              style: textTheme.bodyMedium
                  ?.copyWith(color: cs.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: Icons.group_outlined,
                label: 'Người dùng',
                value: _userCount == null ? '...' : '$_userCount',
                color: cs.primaryContainer,
                iconColor: cs.onPrimaryContainer,
              ),
              _StatCard(
                icon: Icons.map_outlined,
                label: 'Bản đồ',
                value: 'Việt Nam',
                color: cs.secondaryContainer,
                iconColor: cs.onSecondaryContainer,
              ),
              _StatCard(
                icon: Icons.location_city_outlined,
                label: 'Tỉnh/Thành',
                value: '63',
                color: cs.tertiaryContainer,
                iconColor: cs.onTertiaryContainer,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cs.surfaceContainerLow,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: cs.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Chọn "Người dùng" ở sidebar để quản lí tài khoản, '
                    'hoặc chuyển tab "VietMap" để xem bản đồ.',
                    style: textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.iconColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(value,
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: iconColor)),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(fontSize: 12, color: iconColor)),
        ],
      ),
    );
  }
}
