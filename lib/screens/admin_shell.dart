  import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/screens/profile_screen.dart';
import 'package:vietnam_map_flutter/screens/vietnam_map_screen.dart';
import 'admin_dashboard.dart';

enum AdminTab { dashboard, vietmap }

/// Layout chính cho admin — navbar trên cùng với 2 tab: Dashboard và VietMap
class AdminNavigation {
  static final searchEmailNotifier = ValueNotifier<String?>(null);

  static void navigateToUserAndSearch(BuildContext context, String email) {
    searchEmailNotifier.value = email;
    final shell = context.findAncestorStateOfType<AdminShellState>();
    if (shell != null) {
      shell.setTab(AdminTab.dashboard);
    }
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.admin, required this.onLogout});

  final AppUser admin;
  final VoidCallback onLogout;

  @override
  State<AdminShell> createState() => AdminShellState();
}

class AdminShellState extends State<AdminShell> {
  AdminTab _tab = AdminTab.dashboard;
  late AppUser _admin;

  @override
  void initState() {
    super.initState();
    _admin = widget.admin;
  }

  void setTab(AdminTab tab) {
    setState(() => _tab = tab);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 700;

    // Determine whether to show the outer AppBar
    // If we are on mobile and on the dashboard tab, the dashboard has its own AppBar
    final showOuterAppBar = !isMobile || _tab == AdminTab.vietmap;

    return Scaffold(
      appBar: showOuterAppBar
          ? AppBar(
              backgroundColor: cs.primary,
              foregroundColor: cs.onPrimary,
              titleSpacing: 16,
              title: isMobile
                  ? const Text(
                      'VietMap',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    )
                  : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Icon(Icons.map, color: cs.onPrimary, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            'VietNam Map',
                            style: TextStyle(
                              color: cs.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 24),
                          // Tab buttons
                          _TabButton(
                            label: 'Dashboard',
                            icon: Icons.dashboard_outlined,
                            selected: _tab == AdminTab.dashboard,
                            onTap: () => setState(() => _tab = AdminTab.dashboard),
                          ),
                          const SizedBox(width: 4),
                          _TabButton(
                            label: 'VietMap',
                            icon: Icons.map_outlined,
                            selected: _tab == AdminTab.vietmap,
                            onTap: () => setState(() => _tab = AdminTab.vietmap),
                          ),
                        ],
                      ),
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
                            user: _admin,
                            onProfileUpdated: (updated) {
                              setState(() => _admin = updated);
                            },
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
                  child: Builder(
                    builder: (context) {
                      final hasPhoto = _admin.photoUrl != null && _admin.photoUrl!.trim().isNotEmpty;
                      final displayName = _admin.name.isNotEmpty ? _admin.name : _admin.email;
                      final firstLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

                      return _ProfileHoverWrapper(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: cs.onPrimary.withValues(alpha: 0.2),
                                backgroundImage: hasPhoto ? NetworkImage(_admin.photoUrl!) : null,
                                onBackgroundImageError: hasPhoto ? (_, __) {} : null,
                                child: hasPhoto
                                    ? null
                                    : Text(
                                        firstLetter,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: cs.onPrimary,
                                        ),
                                      ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                displayName,
                                style: TextStyle(color: cs.onPrimary, fontSize: 12, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(width: 4),
                              Icon(Icons.arrow_drop_down, size: 14, color: cs.onPrimary),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 8),
              ],
            )
          : null,
      bottomNavigationBar: isMobile
          ? BottomNavigationBar(
              currentIndex: _tab == AdminTab.dashboard ? 0 : 1,
              selectedItemColor: cs.primary,
              unselectedItemColor: cs.onSurface.withValues(alpha: 0.6),
              onTap: (index) {
                setState(() {
                  _tab = index == 0 ? AdminTab.dashboard : AdminTab.vietmap;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard_outlined),
                  activeIcon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map_outlined),
                  activeIcon: Icon(Icons.map),
                  label: 'VietMap',
                ),
              ],
            )
          : null,
      body: _tab == AdminTab.dashboard
          ? AdminDashboard(
              admin: _admin,
              onLogout: widget.onLogout,
              onProfileUpdated: (updated) {
                setState(() => _admin = updated);
              },
            )
          : const VietnamMapScreen(),
    );
  }
}

class _TabButton extends StatefulWidget {
  const _TabButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = widget.selected
        ? cs.onPrimary
        : (_hovered ? cs.onPrimary : cs.onPrimary.withValues(alpha: 0.65));

    BoxDecoration? decoration;
    if (widget.selected) {
      decoration = BoxDecoration(
        color: cs.onPrimary.withValues(alpha: _hovered ? 0.28 : 0.18),
        borderRadius: BorderRadius.circular(8),
      );
    } else if (_hovered) {
      decoration = BoxDecoration(
        color: cs.onPrimary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: decoration,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontSize: 13,
                  fontWeight: widget.selected || _hovered
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileHoverWrapper extends StatefulWidget {
  const _ProfileHoverWrapper({required this.child});
  final Widget child;

  @override
  State<_ProfileHoverWrapper> createState() => _ProfileHoverWrapperState();
}

class _ProfileHoverWrapperState extends State<_ProfileHoverWrapper> {
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
        decoration: BoxDecoration(
          color: cs.onPrimary.withValues(alpha: _hovered ? 0.25 : 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: widget.child,
      ),
    );
  }
}
