import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/map_boundary.dart';
import '../../domain/map_scope.dart';

class MapScopeOverlay extends StatelessWidget {
  const MapScopeOverlay({
    required this.scope,
    super.key,
  });

  final VietNamMapScope scope;

  @override
  Widget build(BuildContext context) {
    if (!scope.hasGeometry) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: PolygonLayer(
        polygonLabels: false,
        painterFillMethod: PolygonPainterFillMethod.evenOdd,
        simplificationTolerance: MapConstants.boundarySimplificationTolerance,
        invertedFill: MapConstants.outsideVietnamMaskColor,
        polygons: [
          for (final polygon in scope.polygons) _transparentPolygon(polygon),
        ],
      ),
    );
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
