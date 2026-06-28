import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../stats/presentation/stats_screen.dart';
import 'campaign_management_screen.dart';
import 'user_management_screen.dart';

import 'admin_shell.dart';

enum AdminSection { overview, campaigns, userManagement, stats }

/// Dashboard layout: sidebar có thể thu gọn + vùng nội dung chính
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({
    super.key,
    required this.admin,
    required this.onLogout,
    required this.onProfileUpdated,
    UserManagementServiceInterface? service,
  }) : _service = service;

  final AppUser admin;
  final VoidCallback onLogout;
  final ValueChanged<AppUser> onProfileUpdated;
  final UserManagementServiceInterface? _service;

  @override
  State<AdminDashboard> createState() => AdminDashboardState();
}

class AdminDashboardState extends State<AdminDashboard> {
  AdminSection _section = AdminSection.overview;
  String? _searchEmail;

  static const _expandedWidth = 210.0;

  @override
  void initState() {
    super.initState();
    AdminNavigation.searchEmailNotifier.addListener(_onSearchEmailChanged);
    final email = AdminNavigation.searchEmailNotifier.value;
    if (email != null) {
      _section = AdminSection.userManagement;
      _searchEmail = email;
      AdminNavigation.searchEmailNotifier.value = null;
    }
  }

  @override
  void dispose() {
    AdminNavigation.searchEmailNotifier.removeListener(_onSearchEmailChanged);
    super.dispose();
  }

  void _onSearchEmailChanged() {
    final email = AdminNavigation.searchEmailNotifier.value;
    if (email != null) {
      setState(() {
        _section = AdminSection.userManagement;
        _searchEmail = email;
      });
      AdminNavigation.searchEmailNotifier.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;

    final hasPhoto = widget.admin.photoUrl != null && widget.admin.photoUrl!.trim().isNotEmpty;
    final displayName = widget.admin.name.isNotEmpty ? widget.admin.name : widget.admin.email;
    final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    if (isMobile) {
      return Scaffold(
        drawer: Drawer(
          child: _Sidebar(
            section: _section,
            onSelect: (s) {
              setState(() {
                _section = s;
                if (s != AdminSection.userManagement) {
                  _searchEmail = null;
                }
              });
              Navigator.pop(context); // Đóng drawer
            },
          ),
        ),
        appBar: AppBar(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          title: Text(
            switch (_section) {
              AdminSection.overview => 'Dashboard',
              AdminSection.campaigns => 'Chiến dịch',
              AdminSection.userManagement => 'Người dùng',
              AdminSection.stats => 'Thống Kê',
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
                        user: widget.admin,
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
                      backgroundImage: hasPhoto ? NetworkImage(widget.admin.photoUrl!) : null,
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
            onSelect: (s) => setState(() {
              _section = s;
              if (s != AdminSection.userManagement) {
                _searchEmail = null;
              }
            }),
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
      case AdminSection.campaigns:
        return CampaignManagementScreen(currentUser: widget.admin);
      case AdminSection.userManagement:
        return UserManagementScreen(
          currentUserId: widget.admin.uid,
          initialSearchText: _searchEmail,
          service: widget._service,
        );
      case AdminSection.stats:
        return const StatsScreen(isAdmin: true);
    }
  }
}

// ── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.section,
    required this.onSelect,
  });

  final AdminSection section;
  final ValueChanged<AdminSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      color: cs.surfaceContainerLow,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),

          // Nav items
          _SidebarItem(
            icon: Icons.dashboard_outlined,
            label: 'Dashboard',
            selected: section == AdminSection.overview,
            expanded: true,
            onTap: () => onSelect(AdminSection.overview),
          ),
          _SidebarItem(
            icon: Icons.campaign_outlined,
            label: 'Chiến dịch',
            selected: section == AdminSection.campaigns,
            expanded: true,
            onTap: () => onSelect(AdminSection.campaigns),
          ),
          _SidebarItem(
            icon: Icons.group_outlined,
            label: 'Người dùng',
            selected: section == AdminSection.userManagement,
            expanded: true,
            onTap: () => onSelect(AdminSection.userManagement),
          ),
          _SidebarItem(
            icon: Icons.bar_chart_outlined,
            label: 'Thống Kê',
            selected: section == AdminSection.stats,
            expanded: true,
            onTap: () => onSelect(AdminSection.stats),
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
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final effectiveColor = widget.selected
        ? cs.primary
        : (_hovered ? cs.primary : cs.onSurfaceVariant);

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
      cursor: SystemMouseCursors.click,
      child: Tooltip(
        message: widget.expanded ? '' : widget.label,
        preferBelow: false,
        child: InkWell(
          onTap: widget.onTap,
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
                        fontSize: 15,
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

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Xin chào, ${widget.admin.name.isNotEmpty ? widget.admin.name : widget.admin.email}',
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
                    'Chọn "Chiến dịch" ở sidebar để quản lí Campaign/Event, '
                    '"Người dùng" để quản lí tài khoản, '
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
                  fontSize: 26, fontWeight: FontWeight.bold, color: iconColor)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 14, color: iconColor)),
        ],
      ),
    );
  }
}
