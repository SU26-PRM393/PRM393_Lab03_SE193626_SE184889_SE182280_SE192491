import 'package:flutter/material.dart';

import '../../../shared/performance/map_startup_trace.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/user_management_dialog.dart';
import '../domain/current_location_state.dart';
import 'vietnam_map_controller.dart';
import 'widgets/map_control_panel.dart';
import 'widgets/map_overlay_controls.dart';
import 'widgets/map_viewport.dart';

class VietnamMapScreen extends StatefulWidget {
  const VietnamMapScreen({super.key, this.appUser});

  /// null khi chạy không qua AuthGate (ví dụ: testing)
  final AppUser? appUser;

  @override
  State<VietnamMapScreen> createState() => _VietnamMapScreenState();
}

class _VietnamMapScreenState extends State<VietnamMapScreen> {
  late final VietnamMapController _controller;

  // ValueNotifier thay vì Offset? thông thường.
  // Khi cập nhật _avatarOffset.value, chỉ ValueListenableBuilder rebuild,
  // không rebuild toàn bộ màn hình (map + panel không bị đụng vào).
  final ValueNotifier<Offset?> _avatarOffset = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = VietnamMapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.bootstrapAfterFirstFrame();
      }
    });
  }

  @override
  void dispose() {
    _avatarOffset.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showUserManagement() {
    showDialog(
      context: context,
      builder: (_) => UserManagementDialog(
        currentUserId: widget.appUser!.uid,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 980;
          final map = _MapSurface(controller: _controller);
          final panel = AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return MapControlPanel(controller: _controller);
            },
          );

          final body = compact
              ? Column(
                  children: [
                    SizedBox(height: 250, child: panel),
                    Expanded(child: map),
                  ],
                )
              : Row(
                  children: [
                    SizedBox(width: 360, child: panel),
                    Expanded(child: map),
                  ],
                );

          return Stack(
            children: [
              body,
              if (widget.appUser != null)
                // ValueListenableBuilder chỉ rebuild Positioned + avatar
                // Map và panel KHÔNG bị rebuild khi kéo → mượt hơn
                ValueListenableBuilder<Offset?>(
                  valueListenable: _avatarOffset,
                  builder: (context, offset, child) {
                    final left = offset?.dx ?? (constraints.maxWidth - 52);
                    final top = offset?.dy ?? 12;
                    return Positioned(
                      left: left,
                      top: top,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          // Gán trực tiếp vào .value — không gọi setState
                          final cur = _avatarOffset.value ??
                              Offset(constraints.maxWidth - 52, 12);
                          _avatarOffset.value = Offset(
                            (cur.dx + details.delta.dx)
                                .clamp(0.0, constraints.maxWidth - 40),
                            (cur.dy + details.delta.dy)
                                .clamp(0.0, constraints.maxHeight - 40),
                          );
                        },
                        child: child,
                      ),
                    );
                  },
                  child: _UserBadge(
                    user: widget.appUser!,
                    onManageUsers: _showUserManagement,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _MapSurface extends StatelessWidget {
  const _MapSurface({required this.controller});

  final VietnamMapController controller;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          return MapStartupTrace.timeSync('widget.mapSurface.build', () {
            return Stack(
              children: [
                Positioned.fill(
                  child: MapViewport(
                    controller: controller,
                    overlay: MapOverlayControls(
                      isLocationLoading: controller.locationState.isRequesting,
                      onZoomIn: controller.zoomIn,
                      onZoomOut: controller.zoomOut,
                      onCurrentLocation: controller.requestCurrentLocation,
                      onRecenter: controller.recenterOnVietnam,
                    ),
                  ),
                ),
                if (_showLocationMessage(controller.locationState))
                  Positioned(
                    left: 20,
                    bottom: 20,
                    child: _LocationMessage(state: controller.locationState),
                  ),
              ],
            );
          });
        },
      ),
    );
  }

  bool _showLocationMessage(CurrentLocationState state) {
    return state.hasMessage &&
        state.status != CurrentLocationStatus.unknown &&
        state.status != CurrentLocationStatus.requesting;
  }
}

/// Avatar tròn — bấm để hiện dropdown, kéo để di chuyển
class _UserBadge extends StatelessWidget {
  const _UserBadge({required this.user, required this.onManageUsers});

  final AppUser user;
  final VoidCallback onManageUsers;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isAdmin = user.isAdmin;

    // Admin dùng primaryContainer để nổi bật nhưng không chói
    final avatarBg = isAdmin ? cs.primary : cs.secondaryContainer;
    final avatarFg = isAdmin ? cs.onPrimary : cs.onSecondaryContainer;
    final chipBg = isAdmin ? cs.primaryContainer : cs.secondaryContainer;
    final chipFg = isAdmin ? cs.onPrimaryContainer : cs.onSecondaryContainer;

    return PopupMenuButton<_UserMenuAction>(
      offset: const Offset(0, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tooltip: '',
      onSelected: (action) async {
        switch (action) {
          case _UserMenuAction.manageUsers:
            onManageUsers();
          case _UserMenuAction.logout:
            await AuthService.instance.signOut();
        }
      },
      itemBuilder: (context) => [
        // ── Header: thông tin user (không click được) ──
        PopupMenuItem(
          enabled: false,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.email,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: cs.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  isAdmin ? 'Admin' : 'User',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: chipFg,
                  ),
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),

        // ── Admin only: Quản lí người dùng ──
        if (isAdmin)
          PopupMenuItem(
            value: _UserMenuAction.manageUsers,
            child: Row(
              children: [
                Icon(Icons.manage_accounts_outlined, size: 18, color: cs.primary),
                const SizedBox(width: 10),
                const Text('Quản lí người dùng'),
              ],
            ),
          ),

        // ── Đăng xuất ──
        PopupMenuItem(
          value: _UserMenuAction.logout,
          child: Row(
            children: [
              Icon(Icons.logout, size: 18, color: cs.error),
              const SizedBox(width: 10),
              Text('Đăng xuất', style: TextStyle(color: cs.error)),
            ],
          ),
        ),
      ],
      child: CircleAvatar(
        radius: 18,
        backgroundColor: avatarBg,
        child: Icon(
          isAdmin ? Icons.admin_panel_settings : Icons.person,
          color: avatarFg,
          size: 18,
        ),
      ),
    );
  }
}

enum _UserMenuAction { manageUsers, logout }

class _LocationMessage extends StatelessWidget {
  const _LocationMessage({required this.state});

  final CurrentLocationState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isError = state.status == CurrentLocationStatus.denied ||
        state.status == CurrentLocationStatus.unavailable ||
        state.status == CurrentLocationStatus.error;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Material(
        color: colorScheme.surface,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.location_off : Icons.my_location,
                color: isError ? colorScheme.error : colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state.message ?? 'Trạng thái vị trí đã thay đổi.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
