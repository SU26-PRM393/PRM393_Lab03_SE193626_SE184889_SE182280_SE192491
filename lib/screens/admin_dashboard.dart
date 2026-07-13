import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vietnam_map_flutter/utils/responsive_breakpoints.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/screens/profile_screen.dart';
import 'package:vietnam_map_flutter/screens/stats_screen.dart' show StatsEmbeddedContent;
import 'package:vietnam_map_flutter/screens/firebase_demo_screen.dart';
import 'package:vietnam_map_flutter/screens/notification_center_screen.dart';
import 'package:vietnam_map_flutter/viewmodels/notification_viewmodel.dart';
import 'campaign_management_screen.dart';
import 'user_management_screen.dart';

import 'admin_shell.dart';

enum AdminSection {
  overview,
  campaigns,
  userManagement,
  firebaseDemo,
  notifications,
}

const _kUserManagementLabel = 'Người dùng';
const _kOverviewLabel = 'Thống Kê';
const _kNotificationsLabel = 'Thông báo';

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

  void _handleSectionSelected(AdminSection section) {
    setState(() {
      _section = section;
      if (section != AdminSection.userManagement) {
        _searchEmail = null;
      }
    });
  }

  void _handleMobileDrawerSelection(BuildContext context, AdminSection section) {
    _handleSectionSelected(section);
    Navigator.pop(context);
  }

  void _handleProfileUpdated(AppUser updated) {
    widget.onProfileUpdated(updated);
  }

  void _handleAccountAction(String value) {
    if (value == 'logout') {
      widget.onLogout();
      return;
    }

    if (value == 'profile') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(
            user: widget.admin,
            onProfileUpdated: _handleProfileUpdated,
          ),
        ),
      );
    }
  }

  String _currentSectionTitle() {
    return switch (_section) {
      AdminSection.overview => _kOverviewLabel,
      AdminSection.campaigns => 'Chiến dịch',
      AdminSection.userManagement => _kUserManagementLabel,
      AdminSection.firebaseDemo => 'Firebase Demo',
      AdminSection.notifications => _kNotificationsLabel,
    };
  }

  Widget _buildNotificationButton(ColorScheme cs, int unread) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: cs.onPrimary,
          tooltip: _kNotificationsLabel,
          onPressed: () => setState(() => _section = AdminSection.notifications),
        ),
        if (unread > 0)
          Positioned(
            right: 6,
            top: 6,
            child: IgnorePointer(
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  unread > 99 ? '99+' : '$unread',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAccountMenuChild(ColorScheme cs, bool hasPhoto, String displayName, String firstLetter) {
    return Container(
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
          Text(displayName, style: TextStyle(color: cs.onPrimary, fontSize: 12)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 14, color: cs.onPrimary),
        ],
      ),
    );
  }

  List<Widget> _buildMobileActions(ColorScheme cs, int unread, bool hasPhoto, String displayName, String firstLetter) {
    return [
      _buildNotificationButton(cs, unread),
      PopupMenuButton<String>(
        offset: const Offset(0, 48),
        tooltip: 'Tài khoản',
        onSelected: _handleAccountAction,
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
        child: _buildAccountMenuChild(cs, hasPhoto, displayName, firstLetter),
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildMobileScaffold(
    BuildContext context,
    ColorScheme cs,
    int unread,
    bool hasPhoto,
    String displayName,
    String firstLetter,
  ) {
    return Scaffold(
      drawer: Drawer(
        child: _Sidebar(
          section: _section,
          unread: unread,
          onSelect: (section) => _handleMobileDrawerSelection(context, section),
        ),
      ),
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(
          _currentSectionTitle(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: _buildMobileActions(cs, unread, hasPhoto, displayName, firstLetter),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildDesktopLayout(int unread) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: _expandedWidth,
          child: _Sidebar(
            section: _section,
            unread: unread,
            onSelect: _handleSectionSelected,
          ),
        ),
        const VerticalDivider(width: 1, thickness: 1),
        Expanded(child: _buildBody()),
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
      case AdminSection.firebaseDemo:
        return const FirebaseDemoScreen(isAdmin: true);
      case AdminSection.notifications:
        return NotificationCenterScreen(
            userId: widget.admin.uid, currentUser: widget.admin);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(widget.admin.uid),
      child: Builder(builder: (context) {
        final vm = context.watch<NotificationViewModel>();
        final cs = Theme.of(context).colorScheme;
        // Use responsive breakpoints instead of hardcoded 700px
        final isMobile = context.useCompactNavigation;

        final hasPhoto = widget.admin.photoUrl != null &&
            widget.admin.photoUrl!.trim().isNotEmpty;
        final displayName = widget.admin.name.isNotEmpty
            ? widget.admin.name
            : widget.admin.email;
        final firstLetter =
            displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
        final unread = vm.unreadCount;

        if (isMobile) {
          return _buildMobileScaffold(
            context,
            cs,
            unread,
            hasPhoto,
            displayName,
            firstLetter,
          );
        }

        return _buildDesktopLayout(unread);
      }),
    );
  }
}

// ── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.section,
    required this.onSelect,
    this.unread = 0,
  });

  final AdminSection section;
  final ValueChanged<AdminSection> onSelect;
  final int unread;

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
            label: _kOverviewLabel,
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
            label: _kUserManagementLabel,
            selected: section == AdminSection.userManagement,
            expanded: true,
            onTap: () => onSelect(AdminSection.userManagement),
          ),
          _SidebarItem(
            icon: Icons.local_fire_department_outlined,
            label: 'Firebase Demo',
            selected: section == AdminSection.firebaseDemo,
            expanded: true,
            onTap: () => onSelect(AdminSection.firebaseDemo),
          ),
          _SidebarItem(
            icon: Icons.notifications_outlined,
            label: _kNotificationsLabel,
            selected: section == AdminSection.notifications,
            expanded: true,
            badge: unread > 0 ? unread : null,
            onTap: () => onSelect(AdminSection.notifications),
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
    this.badge,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final bool expanded;
  final VoidCallback? onTap;
  final int? badge;

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
            padding:
                EdgeInsets.symmetric(horizontal: widget.expanded ? 10 : 0),
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
                  if (widget.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        widget.badge! > 99 ? '99+' : '${widget.badge}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
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
      if (mounted) setState(() => _userCount = users.length + 1);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Thống Kê',
            style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          StatsEmbeddedContent(
            showUserCard: true,
            userCount: _userCount,
            showMapCard: true,
          ),
        ],
      ),
    );
  }
}

