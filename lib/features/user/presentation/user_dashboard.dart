import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';

enum _UserSection { overview }

/// Dashboard layout cho user thường: sidebar có thể thu gọn + vùng nội dung
class UserDashboard extends StatefulWidget {
  const UserDashboard({
    super.key,
    required this.user,
    required this.onLogout,
  });

  final AppUser user;
  final VoidCallback onLogout;

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool _expanded = false;
  _UserSection _section = _UserSection.overview;

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
            onSelect: (s) => setState(() => _section = s),
            onLogout: widget.onLogout,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    return _DashboardOverview(user: widget.user);
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
  final _UserSection section;
  final VoidCallback onToggle;
  final ValueChanged<_UserSection> onSelect;
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
            selected: section == _UserSection.overview,
            expanded: expanded,
            onTap: () => onSelect(_UserSection.overview),
          ),
          // Placeholder items — sẽ phát triển sau
          _SidebarItem(
            icon: Icons.history_outlined,
            label: 'Lịch sử',
            selected: false,
            expanded: expanded,
            disabled: true,
            onTap: null,
          ),
          _SidebarItem(
            icon: Icons.bookmark_outline,
            label: 'Đã lưu',
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

    return Tooltip(
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
  }
}

// ── Dashboard overview ────────────────────────────────────────────────────────

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview({required this.user});

  final AppUser user;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, ${user.email}',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Bảng điều khiển người dùng',
            style: textTheme.bodyMedium?.copyWith(
                color: cs.onSurface.withValues(alpha: 0.6)),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _StatCard(
                icon: Icons.map_outlined,
                label: 'Bản đồ',
                value: 'Việt Nam',
                color: cs.primaryContainer,
                iconColor: cs.onPrimaryContainer,
              ),
              _StatCard(
                icon: Icons.location_city_outlined,
                label: 'Tỉnh/Thành',
                value: '63',
                color: cs.secondaryContainer,
                iconColor: cs.onSecondaryContainer,
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
                    'Chuyển tab "VietMap" ở trên để khám phá bản đồ Việt Nam.',
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
          Text(
            value,
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: iconColor),
          ),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 12, color: iconColor)),
        ],
      ),
    );
  }
}
