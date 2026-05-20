import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/map_boundary.dart';

class ProvinceBoundaryLayer extends StatelessWidget {
  const ProvinceBoundaryLayer({
    required this.boundaries,
    this.selectedBoundary,
    super.key,
  });

  final List<ProvinceBoundary> boundaries;
  final ProvinceBoundary? selectedBoundary;

  @override
  Widget build(BuildContext context) {
    if (boundaries.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: Stack(
        children: [
          PolygonLayer(
            polygonLabels: false,
            painterFillMethod: PolygonPainterFillMethod.evenOdd,
            simplificationTolerance:
                MapConstants.boundarySimplificationTolerance,
            polygons: [
              for (final boundary in boundaries)
                for (final polygon in boundary.polygons)
                  _polygon(
                    polygon,
                    MapConstants.provinceBoundaryWidth,
                    MapConstants.provinceBoundaryColor,
                  ),
            ],
          ),
          if (selectedBoundary != null)
            PolygonLayer(
              polygonLabels: false,
              painterFillMethod: PolygonPainterFillMethod.evenOdd,
              polygonCulling: false,
              simplificationTolerance:
                  MapConstants.interactionOutlineSimplificationTolerance,
              polygons: [
                for (final polygon in selectedBoundary!.polygons)
                  _polygon(
                    polygon,
                    MapConstants.provinceHoverOutlineWidth,
                    MapConstants.provinceHoverOutlineColor,
                  ),
              ],
            ),
        ],
      ),
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
