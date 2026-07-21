import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/utils/map_startup_trace.dart';
import 'package:vietnam_map_flutter/utils/responsive_breakpoints.dart';
import 'package:vietnam_map_flutter/services/auth_service.dart';
import 'package:vietnam_map_flutter/screens/user_management_dialog.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';
import 'package:vietnam_map_flutter/widgets/choropleth_layer.dart';
import 'package:vietnam_map_flutter/widgets/map_control_panel.dart';
import 'package:vietnam_map_flutter/widgets/map_filter_sheet.dart';
import 'package:vietnam_map_flutter/widgets/map_overlay_controls.dart';
import 'package:vietnam_map_flutter/widgets/map_viewport.dart';
import 'package:vietnam_map_flutter/widgets/campaign_control_panel.dart';

class VietnamMapScreen extends StatefulWidget {
  const VietnamMapScreen({super.key, this.appUser});

  /// null khi chạy không qua AuthGate (ví dụ: testing)
  final AppUser? appUser;

  @override
  State<VietnamMapScreen> createState() => _VietnamMapScreenState();
}

enum _PanelHeightState { minimized, collapsed, expanded }

class _VietnamMapScreenState extends State<VietnamMapScreen> {
  late final VietnamMapController _controller;
  bool _isSearchExpanded = false;
  _PanelHeightState _panelHeightState = _PanelHeightState.collapsed;
  bool _isDragging = false;
  double _dragOffset = 0.0;

  // ValueNotifier thay vì Offset? thông thường.
  // Khi cập nhật _avatarOffset.value, chỉ ValueListenableBuilder rebuild,
  // không rebuild toàn bộ màn hình (map + panel không bị đụng vào).
  final ValueNotifier<Offset?> _avatarOffset = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    _controller = VietnamMapController(appUser: widget.appUser);
    _controller.addListener(_onMapControllerChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.bootstrapAfterFirstFrame();
      }
    });
  }

  void _onMapControllerChanged() {
    final hasSelection = _controller.selectedProvince != null ||
        _controller.selectedLowerLevelPlace != null;
    if (hasSelection && !_isSearchExpanded) {
      _isSearchExpanded = true;
      _controller.toggleCampaignPanel(false);
      _controller.deselectCampaign();
      _panelHeightState = _PanelHeightState.collapsed;
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

  void _closeSearchPanel() {
    _controller.clearSelection();
    setState(() {
      _isSearchExpanded = false;
      _panelHeightState = _PanelHeightState.collapsed;
    });
  }

  void _closeCampaignPanel() {
    _controller.toggleCampaignPanel(false);
    _controller.deselectCampaign();
    setState(() {
      _panelHeightState = _PanelHeightState.collapsed;
    });
  }

  void _openSearchPanel() {
    _controller.deselectCampaign();
    _controller.toggleCampaignPanel(false);
    setState(() {
      _isSearchExpanded = true;
      _panelHeightState = _PanelHeightState.collapsed;
    });
  }

  void _openCampaignPanel() {
    _controller.clearSelection();
    setState(() {
      _isSearchExpanded = false;
      _panelHeightState = _PanelHeightState.collapsed;
    });
    _controller.toggleCampaignPanel(true);
  }

  Widget _buildMapSurface() {
    return _MapSurface(
      controller: _controller,
      onOpenFilter: _openFilterSheet,
    );
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MapFilterSheet(
        selectedStatuses: _controller.eventStatusFilter,
        onStatusFilterChanged: _controller.setEventStatusFilter,
        onClose: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildSearchPanel() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return MapControlPanel(
          controller: _controller,
          onClose: _closeSearchPanel,
        );
      },
    );
  }

  Widget _buildCampaignPanel() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return CampaignControlPanel(
          controller: _controller,
          onClose: _closeCampaignPanel,
        );
      },
    );
  }

  Widget _buildDesktopBody(Widget map, Widget panel, Widget campaignPanel) {
    return Row(
      children: [
        if (_isSearchExpanded) SizedBox(width: 360, child: panel),
        if (_controller.isCampaignPanelExpanded)
          SizedBox(width: 400, child: campaignPanel),
        Expanded(child: map),
      ],
    );
  }

  double _panelBaseHeight({
    required double minimizedHeight,
    required double collapsedHeight,
    required double expandedHeight,
  }) {
    switch (_panelHeightState) {
      case _PanelHeightState.expanded:
        return expandedHeight;
      case _PanelHeightState.collapsed:
        return collapsedHeight;
      case _PanelHeightState.minimized:
        return minimizedHeight;
    }
  }

  void _cyclePanelHeightState() {
    setState(() {
      if (_panelHeightState == _PanelHeightState.minimized) {
        _panelHeightState = _PanelHeightState.collapsed;
      } else if (_panelHeightState == _PanelHeightState.collapsed) {
        _panelHeightState = _PanelHeightState.expanded;
      } else {
        _panelHeightState = _PanelHeightState.collapsed;
      }
    });
  }

  void _startPanelDrag() {
    setState(() {
      _isDragging = true;
      _dragOffset = 0.0;
    });
  }

  void _updatePanelDrag(double deltaY) {
    setState(() {
      _dragOffset += deltaY;
    });
  }

  void _resetPanelDrag() {
    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
    });
  }

  void _finishPanelDrag({
    required double baseHeight,
    required double minimizedHeight,
    required double collapsedHeight,
    required double expandedHeight,
  }) {
    final finalHeight = baseHeight - _dragOffset;
    final diffMinimized = (finalHeight - minimizedHeight).abs();
    final diffCollapsed = (finalHeight - collapsedHeight).abs();
    final diffExpanded = (finalHeight - expandedHeight).abs();

    setState(() {
      _isDragging = false;
      _dragOffset = 0.0;
      if (diffMinimized < diffCollapsed && diffMinimized < diffExpanded) {
        _panelHeightState = _PanelHeightState.minimized;
      } else if (diffExpanded < diffMinimized && diffExpanded < diffCollapsed) {
        _panelHeightState = _PanelHeightState.expanded;
      } else {
        _panelHeightState = _PanelHeightState.collapsed;
      }
    });
  }

  Widget _buildCompactBottomPanel({
    required BuildContext context,
    required Widget child,
    required double collapsedRatio,
  }) {
    final screenHeight = MediaQuery.of(context).size.height;
    const minimizedHeight = 24.0;
    final collapsedHeight = screenHeight * collapsedRatio;
    final expandedHeight = screenHeight * 0.75;
    final baseHeight = _panelBaseHeight(
      minimizedHeight: minimizedHeight,
      collapsedHeight: collapsedHeight,
      expandedHeight: expandedHeight,
    );
    final displayHeight =
        (baseHeight - _dragOffset).clamp(minimizedHeight, expandedHeight);
    final showContent = displayHeight > 56.0;

    return AnimatedPositioned(
      duration: _isDragging ? Duration.zero : const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      left: 0,
      right: 0,
      bottom: 0,
      height: displayHeight,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: _cyclePanelHeightState,
              onVerticalDragStart: (_) => _startPanelDrag(),
              onVerticalDragUpdate: (details) =>
                  _updatePanelDrag(details.delta.dy),
              onVerticalDragEnd: (_) => _finishPanelDrag(
                baseHeight: baseHeight,
                minimizedHeight: minimizedHeight,
                collapsedHeight: collapsedHeight,
                expandedHeight: expandedHeight,
              ),
              onVerticalDragCancel: _resetPanelDrag,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                alignment: Alignment.center,
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
            ),
            if (showContent)
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(24)),
                  child: child,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandButtons(BuildContext context) {
    return Positioned(
      left: 16,
      top: 12,
      child: Row(
        children: [
          _CompactFAB(
            heroTag: 'expand_search_btn',
            icon: Icons.search,
            color: Theme.of(context).colorScheme.primary,
            onTap: _openSearchPanel,
          ),
          const SizedBox(width: 10),
          _CompactFAB(
            heroTag: 'expand_campaign_btn',
            icon: Icons.campaign_outlined,
            color: Theme.of(context).colorScheme.secondary,
            onTap: _openCampaignPanel,
          ),
        ],
      ),
    );
  }

  Widget _buildDraggableUserBadge(BoxConstraints constraints) {
    return ValueListenableBuilder<Offset?>(
      valueListenable: _avatarOffset,
      builder: (context, offset, child) {
        final left = offset?.dx ?? (constraints.maxWidth - 52);
        final top = offset?.dy ?? 12;
        return Positioned(
          left: left,
          top: top,
          child: GestureDetector(
            onPanUpdate: (details) {
              final cur =
                  _avatarOffset.value ?? Offset(constraints.maxWidth - 52, 12);
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Use responsive breakpoints instead of hardcoded 980px
          final compact = constraints.maxWidth < ResponsiveBreakpoints.sidePanelThreshold;
          final map = _buildMapSurface();
          final panel = _buildSearchPanel();
          final campaignPanel = _buildCampaignPanel();
          final body = compact
              ? map
              : _buildDesktopBody(map, panel, campaignPanel);

          return Stack(
            children: [
              body,
              if (compact) ...[
                if (_isSearchExpanded)
                  _buildCompactBottomPanel(
                    context: context,
                    child: panel,
                    collapsedRatio: 0.35,
                  ),
                if (_controller.isCampaignPanelExpanded)
                  _buildCompactBottomPanel(
                    context: context,
                    child: campaignPanel,
                    collapsedRatio: 0.38,
                  ),
              ],
              if (!_isSearchExpanded && !_controller.isCampaignPanelExpanded)
                _buildExpandButtons(context),
              if (widget.appUser != null)
                _buildDraggableUserBadge(constraints),
            ],
          );
        },
      ),
    );
  }
}

class _MapSurface extends StatelessWidget {
  const _MapSurface({
    required this.controller,
    required this.onOpenFilter,
  });

  final VietnamMapController controller;
  final VoidCallback onOpenFilter;

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
                      activeMapStyle: controller.activeMapStyle,
                      onMapStyleChanged: controller.setMapStyle,
                      choroplethEnabled: controller.choroplethEnabled,
                      onToggleChoropleth: controller.toggleChoropleth,
                      hasEventFilter: controller.hasEventStatusFilter,
                      onOpenFilter: onOpenFilter,
                    ),
                  ),
                ),
                // Choropleth legend — bottom-left of map
                if (controller.choroplethEnabled)
                  const Positioned(
                    left: 12,
                    bottom: 40,
                    child: ChoroplethLegend(),
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
                Icon(Icons.manage_accounts_outlined,
                    size: 18, color: cs.primary),
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

class _CompactFAB extends StatelessWidget {
  const _CompactFAB({
    required this.heroTag,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String heroTag;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: heroTag,
      onPressed: onTap,
      backgroundColor: Theme.of(context).colorScheme.surface,
      foregroundColor: color,
      elevation: 4,
      child: Icon(icon, size: 20),
    );
  }
}
