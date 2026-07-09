import 'package:flutter/material.dart';

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
    super.key,
  });

  final bool isLocationLoading;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCurrentLocation;
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) {
    // Use responsive breakpoints and platform detection
    final isMobile = context.useCompactNavigation || PlatformUtils.usesTouchInteraction;

    return Semantics(
      container: true,
      label: 'Điều khiển bản đồ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          MapZoomControls(
            onZoomIn: onZoomIn,
            onZoomOut: onZoomOut,
          ),
          const SizedBox(height: 12),
          CurrentLocationButton(
            isLoading: isLocationLoading,
            onPressed: onCurrentLocation,
            isMobile: isMobile,
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Căn giữa về Việt Nam',
            child: isMobile
                // Ensure minimum 48px touch target on mobile
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
        ],
      ),
    );
  }
}
