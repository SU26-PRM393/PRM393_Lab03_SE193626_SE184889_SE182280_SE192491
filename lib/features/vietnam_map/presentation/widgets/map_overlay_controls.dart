import 'package:flutter/material.dart';

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
    final isMobile = MediaQuery.of(context).size.width < 700;

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
                ? IconButton.filledTonal(
                    onPressed: onRecenter,
                    icon: const Icon(Icons.center_focus_strong),
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
