import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:vietnam_map_flutter/models/map_boundary.dart';
import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/utils/map_startup_trace.dart';

/// A map layer that fills province polygons with a sequential color scale
/// proportional to the number of active events in each province.
///
/// Province matching is done by [ProvinceBoundary.provinceCode], which must
/// equal the key used in [densityMap] (the school's provinceCode).
class ChoroplethLayer extends StatefulWidget {
  const ChoroplethLayer({
    required this.boundaries,
    required this.densityMap,
    super.key,
  });

  /// All province boundaries to fill.
  final List<ProvinceBoundary> boundaries;

  /// Maps `provinceCode → activeEventCount`. Provinces not present get count 0.
  final Map<String, int> densityMap;

  @override
  State<ChoroplethLayer> createState() => _ChoroplethLayerState();
}

class _ChoroplethLayerState extends State<ChoroplethLayer> {
  List<ProvinceBoundary>? _lastBoundaries;
  Map<String, int>? _lastDensityMap;
  List<Polygon>? _cachedPolygons;

  static const _scale = [
    Color(0x00000000), // 0 events — transparent
    Color(0xFFCCFBF1), // 1        — teal-100
    Color(0xFF5EEAD4), // 2–3      — teal-300
    Color(0xFF2DD4BF), // 4–6      — teal-400 (mid)
    Color(0xFF0D9488), // 7+       — teal-600 (max)
  ];

  Color _colorForCount(int count) {
    if (count == 0) return _scale[0];
    if (count == 1) return _scale[1];
    if (count <= 3) return _scale[2];
    if (count <= 6) return _scale[3];
    return _scale[4];
  }

  List<Polygon> _buildPolygons(
    List<ProvinceBoundary> boundaries,
    Map<String, int> densityMap,
  ) {
    return MapStartupTrace.timeSync(
      'overlay.choropleth.polygons',
      () => [
        for (final boundary in boundaries)
          for (final polygon in boundary.polygons)
            Polygon(
              points: polygon.outerRing.points,
              holePointsList: polygon.holes.isEmpty
                  ? null
                  : [for (final hole in polygon.holes) hole.points],
              color: _colorForCount(
                densityMap[boundary.provinceCode] ?? 0,
              ).withValues(alpha: 0.55),
              borderStrokeWidth: MapConstants.provinceBoundaryWidth,
              borderColor: MapConstants.provinceBoundaryColor
                  .withValues(alpha: 0.0), // boundary drawn by ProvinceBoundaryLayer
            ),
      ],
      arguments: {'count': boundaries.length},
    );
  }

  @override
  Widget build(BuildContext context) {
    final boundaries = widget.boundaries;
    final densityMap = widget.densityMap;

    if (boundaries.isEmpty || densityMap.values.every((v) => v == 0)) {
      return const SizedBox.shrink();
    }

    if (!identical(_lastBoundaries, boundaries) ||
        _lastDensityMap != densityMap ||
        _cachedPolygons == null) {
      _lastBoundaries = boundaries;
      _lastDensityMap = densityMap;
      _cachedPolygons = _buildPolygons(boundaries, densityMap);
    }

    return IgnorePointer(
      child: PolygonLayer(
        polygonLabels: false,
        painterFillMethod: PolygonPainterFillMethod.evenOdd,
        simplificationTolerance: MapConstants.boundarySimplificationTolerance,
        polygons: _cachedPolygons!,
      ),
    );
  }
}

/// Color scale legend for the choropleth map. Displayed as a small floating
/// card in the bottom-left corner of the map.
class ChoroplethLegend extends StatelessWidget {
  const ChoroplethLegend({super.key});

  static const _entries = [
    (color: Color(0xFFCCFBF1), label: '1 sự kiện'),
    (color: Color(0xFF5EEAD4), label: '2–3 sự kiện'),
    (color: Color(0xFF2DD4BF), label: '4–6 sự kiện'),
    (color: Color(0xFF0D9488), label: '7+ sự kiện'),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(10),
      color: cs.surface.withValues(alpha: 0.92),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Mật độ sự kiện',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 8),
            for (final entry in _entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: entry.color.withValues(alpha: 0.75),
                        border: Border.all(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.4),
                        ),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      entry.label,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: cs.onSurface,
                          ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
