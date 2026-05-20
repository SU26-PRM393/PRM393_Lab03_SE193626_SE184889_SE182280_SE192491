import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/island_label_override.dart';

class IslandFeatureOverlay extends StatelessWidget {
  const IslandFeatureOverlay({
    required this.labels,
    required this.zoom,
    super.key,
  });

  final List<IslandLabelOverride> labels;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final visibleLabels = [
      for (final label in labels)
        if (label.isVisibleAtZoom(zoom)) label,
    ];

    if (visibleLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: MarkerLayer(
        markers: [
          for (final label in visibleLabels) _markerFor(label),
        ],
      ),
    );
  }

  Marker _markerFor(IslandLabelOverride label) {
    return Marker(
      point: label.anchor,
      width: 72,
      height: 44,
      alignment: Alignment.center,
      child: Semantics(
        label: '${label.displayLabel} island feature',
        child: CustomPaint(
          painter: _IslandFeaturePainter(seed: label.id),
        ),
      ),
    );
  }
}

class _IslandFeaturePainter extends CustomPainter {
  const _IslandFeaturePainter({required this.seed});

  final String seed;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final offsets = seed == 'hoang-sa'
        ? const [
            Offset(-18, -5),
            Offset(-8, 4),
            Offset(4, -3),
            Offset(15, 6),
            Offset(23, -8),
          ]
        : const [
            Offset(-22, -7),
            Offset(-12, 6),
            Offset(0, -2),
            Offset(11, 8),
            Offset(22, -4),
            Offset(29, 9),
          ];

    final fillPaint = Paint()
      ..color = MapConstants.islandFeatureFillColor
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = MapConstants.islandFeatureColor
      ..strokeWidth = MapConstants.islandFeatureBorderWidth
      ..style = PaintingStyle.stroke;

    for (final offset in offsets) {
      final point = center + offset;
      canvas
        ..drawCircle(point, MapConstants.islandFeatureRadius, fillPaint)
        ..drawCircle(point, MapConstants.islandFeatureRadius, strokePaint);
    }
  }

  @override
  bool shouldRepaint(_IslandFeaturePainter oldDelegate) {
    return seed != oldDelegate.seed;
  }
}
