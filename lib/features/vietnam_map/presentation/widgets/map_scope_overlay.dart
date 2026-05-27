import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../../../shared/performance/map_startup_trace.dart';
import '../../domain/map_boundary.dart';
import '../../domain/map_scope.dart';

class MapScopeOverlay extends StatefulWidget {
  const MapScopeOverlay({
    required this.scope,
    super.key,
  });

  final VietNamMapScope scope;

  @override
  State<MapScopeOverlay> createState() => _MapScopeOverlayState();
}

class _MapScopeOverlayState extends State<MapScopeOverlay> {
  VietNamMapScope? _lastScope;
  List<Polygon>? _cachedPolygons;

  @override
  Widget build(BuildContext context) {
    final scope = widget.scope;
    if (!scope.hasGeometry) {
      return const SizedBox.shrink();
    }
    final polygons = _polygonsFor(scope);

    return IgnorePointer(
      child: PolygonLayer(
        polygonLabels: false,
        painterFillMethod: PolygonPainterFillMethod.evenOdd,
        simplificationTolerance: MapConstants.boundarySimplificationTolerance,
        invertedFill: MapConstants.outsideVietnamMaskColor,
        polygons: polygons,
      ),
    );
  }

  List<Polygon> _polygonsFor(VietNamMapScope scope) {
    if (identical(_lastScope, scope) && _cachedPolygons != null) {
      return _cachedPolygons!;
    }

    _lastScope = scope;
    _cachedPolygons = MapStartupTrace.timeSync(
      'overlay.scope.polygons',
      () => [
        for (final polygon in scope.polygons) _transparentPolygon(polygon),
      ],
      arguments: {'polygonCount': scope.polygons.length},
    );
    return _cachedPolygons!;
  }

  Polygon _transparentPolygon(BoundaryPolygon polygon) {
    return Polygon(
      points: polygon.outerRing.points,
      holePointsList: polygon.holes.isEmpty
          ? null
          : [
              for (final hole in polygon.holes) hole.points,
            ],
      color: Colors.transparent,
      borderStrokeWidth: 0,
    );
  }
}
