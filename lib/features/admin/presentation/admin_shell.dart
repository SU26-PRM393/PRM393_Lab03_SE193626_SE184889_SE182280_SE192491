import 'package:flutter/material.dart';

import '../../auth/data/auth_service.dart';
import '../../vietnam_map/presentation/vietnam_map_screen.dart';
import 'admin_dashboard.dart';

enum AdminTab { dashboard, vietmap }

/// Layout chính cho admin — navbar trên cùng với 2 tab: Dashboard và VietMap
class AdminShell extends StatefulWidget {
  const AdminShell({super.key, required this.admin, required this.onLogout});

  final AppUser admin;
  final VoidCallback onLogout;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  AdminTab _tab = AdminTab.dashboard;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
        titleSpacing: 16,
        title: Row(
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
        actions: [
          // Admin badge
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cs.onPrimary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.admin_panel_settings, size: 14, color: cs.onPrimary),
                const SizedBox(width: 6),
                Text(
                  widget.admin.email,
                  style: TextStyle(color: cs.onPrimary, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _tab == AdminTab.dashboard
          ? AdminDashboard(admin: widget.admin, onLogout: widget.onLogout)
          // VietMap tab: appUser = null → không hiện avatar badge
          : const VietnamMapScreen(),
    );
  }
}

class _TabButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final color = selected
        ? cs.onPrimary
        : cs.onPrimary.withValues(alpha: 0.65);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: selected
            ? BoxDecoration(
                color: cs.onPrimary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
