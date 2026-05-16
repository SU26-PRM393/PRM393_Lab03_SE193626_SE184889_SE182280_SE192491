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
    return Semantics(
      container: true,
      label: 'Map controls',
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
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Recenter on Viet Nam',
            child: FilledButton.tonalIcon(
              onPressed: onRecenter,
              icon: const Icon(Icons.center_focus_strong),
              label: const Text('Viet Nam'),
            ),
          ),
        ],
      ),
    );
  }
}
