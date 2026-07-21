import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/models/map_style.dart';
import 'package:vietnam_map_flutter/utils/platform_utils.dart';
import 'package:vietnam_map_flutter/utils/responsive_breakpoints.dart';
import 'current_location_button.dart';
import 'map_zoom_controls.dart';

class MapOverlayControls extends StatelessWidget {
  const MapOverlayControls({
    required this.isLocationLoading,
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onCurrentLocation,
    required this.onRecenter,
    required this.activeMapStyle,
    required this.onMapStyleChanged,
    required this.choroplethEnabled,
    required this.onToggleChoropleth,
    required this.hasEventFilter,
    required this.onOpenFilter,
    super.key,
  });

  final bool isLocationLoading;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCurrentLocation;
  final VoidCallback onRecenter;

  // Map style switcher
  final MapStyle activeMapStyle;
  final ValueChanged<MapStyle> onMapStyleChanged;

  // Choropleth toggle
  final bool choroplethEnabled;
  final VoidCallback onToggleChoropleth;

  // Event filter
  final bool hasEventFilter;
  final VoidCallback onOpenFilter;

  @override
  Widget build(BuildContext context) {
    final isMobile =
        context.useCompactNavigation || PlatformUtils.usesTouchInteraction;

    return Semantics(
      container: true,
      label: 'Điều khiển bản đồ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // ── Zoom ──────────────────────────────────────────────────────────
          MapZoomControls(
            onZoomIn: onZoomIn,
            onZoomOut: onZoomOut,
          ),
          const SizedBox(height: 10),

          // ── Current location ──────────────────────────────────────────────
          CurrentLocationButton(
            isLoading: isLocationLoading,
            onPressed: onCurrentLocation,
            isMobile: isMobile,
          ),
          const SizedBox(height: 10),

          // ── Re-center Vietnam ─────────────────────────────────────────────
          Tooltip(
            message: 'Căn giữa về Việt Nam',
            child: isMobile
                ? SizedBox(
                    width: ResponsiveBreakpoints.minTouchTarget,
                    height: ResponsiveBreakpoints.minTouchTarget,
                    child: IconButton.filledTonal(
                      onPressed: onRecenter,
                      icon: const Icon(Icons.center_focus_strong),
                    ),
                  )
                : FilledButton.tonalIcon(
                    onPressed: onRecenter,
                    icon: const Icon(Icons.center_focus_strong),
                    label: const Text('Việt Nam'),
                  ),
          ),
          const SizedBox(height: 14),

          // ── Divider ───────────────────────────────────────────────────────
          _ControlDivider(),
          const SizedBox(height: 14),

          // ── Map style switcher ────────────────────────────────────────────
          _MapStyleSwitcher(
            active: activeMapStyle,
            onChanged: onMapStyleChanged,
          ),
          const SizedBox(height: 10),

          // ── Choropleth toggle ─────────────────────────────────────────────
          _OverlayIconButton(
            tooltip: choroplethEnabled
                ? 'Tắt bản đồ mật độ'
                : 'Bật bản đồ mật độ sự kiện',
            icon: Icons.gradient_rounded,
            active: choroplethEnabled,
            onPressed: onToggleChoropleth,
          ),
          const SizedBox(height: 10),

          // ── Event filter ──────────────────────────────────────────────────
          _OverlayIconButton(
            tooltip: hasEventFilter
                ? 'Đang lọc sự kiện — bấm để chỉnh'
                : 'Lọc sự kiện trên bản đồ',
            icon: hasEventFilter
                ? Icons.filter_list_rounded
                : Icons.filter_list_off_rounded,
            active: hasEventFilter,
            activeColor: Theme.of(context).colorScheme.tertiary,
            onPressed: onOpenFilter,
          ),
        ],
      ),
    );
  }
}

// ── Map style row ─────────────────────────────────────────────────────────────

class _MapStyleSwitcher extends StatelessWidget {
  const _MapStyleSwitcher({
    required this.active,
    required this.onChanged,
  });

  final MapStyle active;
  final ValueChanged<MapStyle> onChanged;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 2,
      shadowColor: Colors.black26,
      borderRadius: BorderRadius.circular(10),
      color: cs.surface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Column(
          children: [
            for (final style in MapStyle.values)
              Tooltip(
                message: style.displayName,
                preferBelow: false,
                child: InkWell(
                  onTap: () => onChanged(style),
                  borderRadius: BorderRadius.circular(8),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    width: 36,
                    height: 32,
                    decoration: BoxDecoration(
                      color: active == style
                          ? cs.primaryContainer
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _iconFor(style),
                      size: 18,
                      color: active == style
                          ? cs.onPrimaryContainer
                          : cs.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(MapStyle style) => switch (style) {
        MapStyle.light => Icons.map_outlined,
        MapStyle.dark => Icons.dark_mode_outlined,
        MapStyle.satellite => Icons.satellite_alt_outlined,
      };
}

// ── Generic icon button ───────────────────────────────────────────────────────

class _OverlayIconButton extends StatelessWidget {
  const _OverlayIconButton({
    required this.tooltip,
    required this.icon,
    required this.active,
    required this.onPressed,
    this.activeColor,
  });

  final String tooltip;
  final IconData icon;
  final bool active;
  final VoidCallback onPressed;
  final Color? activeColor;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = active
        ? (activeColor ?? cs.primary).withValues(alpha: 0.15)
        : cs.surface;
    final fg = active ? (activeColor ?? cs.primary) : cs.onSurfaceVariant;

    return Tooltip(
      message: tooltip,
      preferBelow: false,
      child: Material(
        elevation: 2,
        shadowColor: Colors.black26,
        borderRadius: BorderRadius.circular(10),
        color: bg,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: SizedBox(
            width: 44,
            height: 36,
            child: Icon(icon, size: 20, color: fg),
          ),
        ),
      ),
    );
  }
}

// ── Visual divider ────────────────────────────────────────────────────────────

class _ControlDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.6),
    );
  }
}
