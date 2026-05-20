import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/map_boundary.dart';
import '../../domain/province_hover_state.dart';

class ProvinceHoverOutline extends StatelessWidget {
  const ProvinceHoverOutline({
    required this.state,
    super.key,
  });

  final ProvinceHoverState state;

  @override
  Widget build(BuildContext context) {
    final boundary = state.hoveredBoundary;
    if (!state.isActive || boundary == null) {
      return const SizedBox.shrink();
    }

    final outlinePolygons = [
      for (final polygon in boundary.polygons) _outlinePolygon(polygon),
    ];

    return IgnorePointer(
      child: Stack(
        children: [
          PolygonLayer(
            polygonLabels: false,
            painterFillMethod: PolygonPainterFillMethod.evenOdd,
            polygonCulling: false,
            simplificationTolerance:
                MapConstants.interactionOutlineSimplificationTolerance,
            polygons: [
              for (final polygon in boundary.polygons) _haloPolygon(polygon),
            ],
          ),
          PolygonLayer(
            polygonLabels: false,
            painterFillMethod: PolygonPainterFillMethod.evenOdd,
            polygonCulling: false,
            simplificationTolerance:
                MapConstants.interactionOutlineSimplificationTolerance,
            polygons: outlinePolygons,
          ),
        ],
      ),
    );
  }

  Polygon _haloPolygon(BoundaryPolygon polygon) {
    return _polygon(
      polygon,
      MapConstants.provinceHoverOutlineHaloWidth,
      MapConstants.provinceHoverOutlineHaloColor,
    );
  }

  Polygon _outlinePolygon(BoundaryPolygon polygon) {
    return _polygon(
      polygon,
      MapConstants.provinceHoverOutlineWidth,
      MapConstants.provinceHoverOutlineColor,
    );
  }

  Polygon _polygon(
    BoundaryPolygon polygon,
    double strokeWidth,
    Color strokeColor,
  ) {
    return Polygon(
      points: polygon.outerRing.points,
      holePointsList: polygon.holes.isEmpty
          ? null
          : [
              for (final hole in polygon.holes) hole.points,
            ],
      color: null,
      borderStrokeWidth: strokeWidth,
      borderColor: strokeColor,
    );
  }
}
