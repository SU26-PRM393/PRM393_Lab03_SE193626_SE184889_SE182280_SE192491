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
    required this.showProvinceLabels,
    required this.onToggleProvinceLabels,
    super.key,
  });

  final bool isLocationLoading;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onCurrentLocation;
  final VoidCallback onRecenter;
  final bool showProvinceLabels;
  final ValueChanged<bool> onToggleProvinceLabels;

  @override
  Widget build(BuildContext context) {
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
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: 'Căn giữa về Việt Nam',
            child: FilledButton.tonalIcon(
              onPressed: onRecenter,
              icon: const Icon(Icons.center_focus_strong),
              label: const Text('Việt Nam'),
            ),
          ),
          const SizedBox(height: 12),
          Tooltip(
            message: showProvinceLabels ? 'Ẩn tên tất cả các tỉnh' : 'Hiện tên tất cả các tỉnh',
            child: FilledButton.tonalIcon(
              onPressed: () => onToggleProvinceLabels(!showProvinceLabels),
              icon: Icon(showProvinceLabels ? Icons.label_off_outlined : Icons.label_outlined),
              label: Text(showProvinceLabels ? 'Ẩn tên tỉnh' : 'Hiện tên tỉnh'),
            ),
          ),
        ],
      ),
    );
  }
}
