import 'package:flutter/material.dart';

import '../../../shared/performance/map_startup_trace.dart';
import '../../auth/data/auth_service.dart';
import '../../auth/presentation/user_management_dialog.dart';
import '../domain/current_location_state.dart';
import 'vietnam_map_controller.dart';
import 'widgets/map_control_panel.dart';
import 'widgets/map_overlay_controls.dart';
import 'widgets/map_viewport.dart';
import 'widgets/campaign_control_panel.dart';

class VietnamMapScreen extends StatefulWidget {
  const VietnamMapScreen({super.key, this.appUser});

  /// null khi chạy không qua AuthGate (ví dụ: testing)
  final AppUser? appUser;

  @override
  State<VietnamMapScreen> createState() => _VietnamMapScreenState();
}

class _VietnamMapScreenState extends State<VietnamMapScreen> {
  late final VietnamMapController _controller;
  bool _isSearchExpanded = false;

  // ValueNotifier thay vì Offset? thông thường.
  // Khi cập nhật _avatarOffset.value, chỉ ValueListenableBuilder rebuild,
  // không rebuild toàn bộ màn hình (map + panel không bị đụng vào).
  final ValueNotifier<Offset?> _avatarOffset = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = VietnamMapController();
    _controller.addListener(_onMapControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.bootstrapAfterFirstFrame();
      }
    });
  }

  void _onMapControllerChanged() {
    final hasSelection = _controller.selectedProvince != null || _controller.selectedLowerLevelPlace != null;
    if (hasSelection && !_isSearchExpanded) {
      _isSearchExpanded = true;
      _controller.toggleCampaignPanel(false);
      _controller.deselectCampaign();
    }
    setState(() {});
  }

  @override
  void dispose() {
    _avatarOffset.dispose();
    _controller.removeListener(_onMapControllerChanged);
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
              return MapControlPanel(
                controller: _controller,
                onClose: () {
                  _controller.clearSelection();
                  setState(() => _isSearchExpanded = false);
                },
              );
            },
          );

          final campaignPanel = AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return CampaignControlPanel(
                controller: _controller,
                onClose: () {
                  _controller.toggleCampaignPanel(false);
                  _controller.deselectCampaign();
                },
              );
            },
          );

          final body = compact
              ? Column(
                  children: [
                    if (_isSearchExpanded) SizedBox(height: 250, child: panel),
                    if (_controller.isCampaignPanelExpanded) SizedBox(height: 300, child: campaignPanel),
                    Expanded(child: map),
                  ],
                )
              : Row(
                  children: [
                    if (_isSearchExpanded) SizedBox(width: 360, child: panel),
                    if (_controller.isCampaignPanelExpanded) SizedBox(width: 400, child: campaignPanel),
                    Expanded(child: map),
                  ],
                );

          return Stack(
            children: [
              body,
              if (!_isSearchExpanded && !_controller.isCampaignPanelExpanded)
                Positioned(
                  left: 16,
                  top: 12,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        heroTag: 'expand_search_btn',
                        elevation: 4,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        onPressed: () {
                          _controller.deselectCampaign();
                          _controller.toggleCampaignPanel(false);
                          setState(() => _isSearchExpanded = true);
                        },
                        child: const Icon(Icons.search),
                      ),
                      const SizedBox(height: 12),
                      FloatingActionButton(
                        heroTag: 'expand_campaign_btn',
                        elevation: 4,
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        foregroundColor: Theme.of(context).colorScheme.secondary,
                        onPressed: () {
                          _controller.clearSelection();
                          setState(() => _isSearchExpanded = false);
                          _controller.toggleCampaignPanel(true);
                        },
                        child: const Icon(Icons.campaign),
                      ),
                    ],
                  ),
                ),
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
                      showProvinceLabels: controller.showProvinceLabels,
                      onToggleProvinceLabels: controller.toggleProvinceLabels,
                    ),
                  ),
                ),
              ],
            );
          });
        },
      ),
    );
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
