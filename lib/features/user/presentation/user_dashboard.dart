import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../admin/presentation/campaign_management_screen.dart';

enum _UserSection { overview, campaigns }

/// Dashboard layout cho user thường: sidebar có thể thu gọn + vùng nội dung
class UserDashboard extends StatefulWidget {
  const UserDashboard({
    super.key,
    required this.user,
    required this.onLogout,
    required this.onProfileUpdated,
  });

  final AppUser user;
  final VoidCallback onLogout;
  final ValueChanged<AppUser> onProfileUpdated;

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  _UserSection _section = _UserSection.overview;

  static const _expandedWidth = 210.0;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;

    final hasPhoto = widget.user.photoUrl != null && widget.user.photoUrl!.trim().isNotEmpty;
    final displayName = widget.user.name.isNotEmpty ? widget.user.name : widget.user.email;
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    if (isMobile) {
      return Scaffold(
        drawer: Drawer(
          child: _Sidebar(
            section: _section,
            onSelect: (s) {
              setState(() => _section = s);
              Navigator.pop(context); // Đóng drawer
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          title: Text(
            switch (_section) {
              _UserSection.overview => 'Dashboard',
              _UserSection.campaigns => 'Chiến dịch',
            },
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton<String>(
              offset: const Offset(0, 48),
              tooltip: 'Tài khoản',
              onSelected: (val) {
                if (val == 'logout') {
                  widget.onLogout();
                } else if (val == 'profile') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        user: widget.user,
                        onProfileUpdated: widget.onProfileUpdated,
                      ),
                    ),
                  );
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem<String>(
                  value: 'profile',
                  child: Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.black87, size: 18),
                      SizedBox(width: 8),
                      Text('Hồ sơ cá nhân'),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 18),
                      SizedBox(width: 8),
                      Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: cs.onPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
                      backgroundImage: hasPhoto ? NetworkImage(widget.user.photoUrl!) : null,
                      onBackgroundImageError: hasPhoto ? (_, __) {} : null,
                      child: hasPhoto
                          ? null
                          : Text(
                              firstLetter,
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                color: cs.onPrimary,
                              ),
                            ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      displayName,
                      style: TextStyle(color: cs.onPrimary, fontSize: 12),
                    ),
                    const SizedBox(width: 4),
                    Icon(Icons.arrow_drop_down, size: 14, color: cs.onPrimary),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: _buildBody(),
      );
    }

    return Row(
      children: [
        SizedBox(
          width: _expandedWidth,
          child: _Sidebar(
            section: _section,
            onSelect: (s) => setState(() => _section = s),
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    switch (_section) {
      case _UserSection.overview:
        return _DashboardOverview(user: widget.user);
      case _UserSection.campaigns:
        return CampaignManagementScreen(currentUser: widget.user);
    }
  }
}

// ── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.section,
    required this.onSelect,
  });

  final _UserSection section;
  final ValueChanged<_UserSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            selected: section == _UserSection.overview,
            expanded: true,
            onTap: () => onSelect(_UserSection.overview),
          ),
          _SidebarItem(
            icon: Icons.campaign_outlined,
            label: 'Chiến dịch',
            selected: section == _UserSection.campaigns,
            expanded: true,
            onTap: () => onSelect(_UserSection.campaigns),
          ),
          // Placeholder items — sẽ phát triển sau
          const _SidebarItem(
            icon: Icons.history_outlined,
            label: 'Lịch sử',
            selected: false,
            expanded: true,
            disabled: true,
            onTap: null,
          ),
          const _SidebarItem(
            icon: Icons.bookmark_outline,
            label: 'Đã lưu',
            selected: false,
            expanded: true,
            disabled: true,
            onTap: null,
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.expanded,
    required this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final defaultColor = widget.selected
        ? cs.primary
        : (_hovered ? cs.primary : cs.onSurfaceVariant);
    final effectiveColor =
        widget.disabled ? cs.onSurface.withValues(alpha: 0.35) : defaultColor;

    BoxDecoration? decoration;
    if (widget.selected) {
      decoration = BoxDecoration(
        color: cs.primary.withValues(alpha: _hovered ? 0.18 : 0.12),
        borderRadius: BorderRadius.circular(8),
      );
    } else if (_hovered) {
      decoration = BoxDecoration(
        color: cs.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: widget.disabled
          ? SystemMouseCursors.forbidden
          : SystemMouseCursors.click,
      child: Tooltip(
        message: widget.expanded ? '' : widget.label,
        preferBelow: false,
        child: InkWell(
          onTap: widget.disabled ? null : widget.onTap,
          borderRadius: BorderRadius.circular(8),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            height: 44,
            margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            padding: EdgeInsets.symmetric(horizontal: widget.expanded ? 10 : 0),
            decoration: decoration,
            child: Row(
              mainAxisAlignment: widget.expanded
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.center,
              children: [
                Icon(widget.icon, size: 20, color: effectiveColor),
                if (widget.expanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      widget.label,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: effectiveColor,
                        fontWeight: widget.selected || _hovered
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ],
            ),
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Xin chào, ${user.name.isNotEmpty ? user.name : user.email}',
            style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Bảng điều khiển người dùng',
            style: textTheme.bodyMedium
                ?.copyWith(color: cs.onSurface.withValues(alpha: 0.6)),
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
