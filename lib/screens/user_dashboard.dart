import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/screens/profile_screen.dart';
import 'package:vietnam_map_flutter/screens/campaign_management_screen.dart';
import 'package:vietnam_map_flutter/screens/stats_screen.dart' show StatsEmbeddedContent;
import 'package:vietnam_map_flutter/screens/notification_center_screen.dart';
import 'package:vietnam_map_flutter/viewmodels/notification_viewmodel.dart';

enum _UserSection { overview, campaigns, notifications }

const _kOverviewLabel = 'Thống Kê';
const _kNotificationsLabel = 'Thông báo';

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

  void _handleSectionSelected(_UserSection section) {
    setState(() => _section = section);
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
            user: widget.user,
            onProfileUpdated: widget.onProfileUpdated,
          ),
        ),
      );
    }
  }

  String _currentSectionTitle() {
    return switch (_section) {
      _UserSection.overview => _kOverviewLabel,
      _UserSection.campaigns => 'Chiến dịch',
      _UserSection.notifications => _kNotificationsLabel,
    };
  }

  Widget _buildNotificationButton(ColorScheme cs, int unread) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          color: cs.onPrimary,
          tooltip: _kNotificationsLabel,
          onPressed: () => setState(() => _section = _UserSection.notifications),
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

  Widget _buildAccountMenuChild(ColorScheme cs, String displayName) {
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
          const CircleAvatar(
            radius: 10,
            child: SizedBox.shrink(),
          ),
          const SizedBox(width: 6),
          Text(displayName, style: TextStyle(color: cs.onPrimary, fontSize: 12)),
          const SizedBox(width: 4),
          Icon(Icons.arrow_drop_down, size: 14, color: cs.onPrimary),
        ],
      ),
    );
  }

  List<Widget> _buildMobileActions(ColorScheme cs, int unread, String displayName) {
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
        child: _buildAccountMenuChild(cs, displayName),
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildMobileScaffold(BuildContext context, ColorScheme cs, int unread, String displayName) {
    return Scaffold(
      drawer: Drawer(
        child: _Sidebar(
          section: _section,
          unread: unread,
          onSelect: (section) {
            _handleSectionSelected(section);
            Navigator.pop(context);
          },
        ),
      ),
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        title: Text(
          _currentSectionTitle(),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        actions: _buildMobileActions(cs, unread, displayName),
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NotificationViewModel(widget.user.uid),
      child: Builder(builder: (context) => _buildInner(context)),
    );
  }

  Widget _buildInner(BuildContext context) {
    final vm = context.watch<NotificationViewModel>();
    final cs = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;
    final displayName =
        widget.user.name.isNotEmpty ? widget.user.name : widget.user.email;
    final unread = vm.unreadCount;

    if (isMobile) {
      return _buildMobileScaffold(context, cs, unread, displayName);
    }

    return _buildDesktopLayout(unread);
  }

  Widget _buildBody() {
    switch (_section) {
      case _UserSection.overview:
        return _DashboardOverview(user: widget.user);
      case _UserSection.campaigns:
        return CampaignManagementScreen(currentUser: widget.user);
      case _UserSection.notifications:
        return NotificationCenterScreen(
            userId: widget.user.uid, currentUser: widget.user);
    }
  }
}

// ── Sidebar ──────────────────────────────────────────────────────────────────

class _Sidebar extends StatelessWidget {
  const _Sidebar({
    required this.section,
    required this.onSelect,
    this.unread = 0,
  });

  final _UserSection section;
  final ValueChanged<_UserSection> onSelect;
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
          _SidebarItem(
            icon: Icons.notifications_outlined,
            label: _kNotificationsLabel,
            selected: section == _UserSection.notifications,
            expanded: true,
            badge: unread > 0 ? unread : null,
            onTap: () => onSelect(_UserSection.notifications),
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
    final defaultColor = widget.selected
        ? cs.primary
        : (_hovered ? cs.primary : cs.onSurfaceVariant);
    final effectiveColor = defaultColor;

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
                        fontSize: 13,
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

class _DashboardOverview extends StatelessWidget {
  const _DashboardOverview({required this.user});

  final AppUser user;

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
          const StatsEmbeddedContent(
            showMapCard: true,
          ),
        ],
      ),
    );
  }
}

