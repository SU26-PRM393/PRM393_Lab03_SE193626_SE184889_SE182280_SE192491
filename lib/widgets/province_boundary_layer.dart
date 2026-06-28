import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/utils/map_startup_trace.dart';
import 'package:vietnam_map_flutter/models/map_boundary.dart';

class ProvinceBoundaryLayer extends StatefulWidget {
  const ProvinceBoundaryLayer({
    required this.boundaries,
    this.selectedBoundary,
    super.key,
  });

  final List<ProvinceBoundary> boundaries;
  final ProvinceBoundary? selectedBoundary;

  @override
  State<ProvinceBoundaryLayer> createState() => _ProvinceBoundaryLayerState();
}

class _ProvinceBoundaryLayerState extends State<ProvinceBoundaryLayer> {
  List<ProvinceBoundary>? _lastBoundaries;
  List<Polygon>? _boundaryPolygons;
  ProvinceBoundary? _lastSelectedBoundary;
  List<Polygon>? _selectedPolygons;

  @override
  Widget build(BuildContext context) {
    final boundaries = widget.boundaries;
    if (boundaries.isEmpty) {
      return const SizedBox.shrink();
    }
    final boundaryPolygons = _polygonsForBoundaries(boundaries);
    final selectedPolygons = _polygonsForSelected(widget.selectedBoundary);

    return IgnorePointer(
      child: Stack(
        children: [
          PolygonLayer(
            polygonLabels: false,
            painterFillMethod: PolygonPainterFillMethod.evenOdd,
            simplificationTolerance:
                MapConstants.boundarySimplificationTolerance,
            polygons: boundaryPolygons,
          ),
          if (selectedPolygons.isNotEmpty)
            PolygonLayer(
              polygonLabels: false,
              painterFillMethod: PolygonPainterFillMethod.evenOdd,
              polygonCulling: false,
              simplificationTolerance:
                  MapConstants.interactionOutlineSimplificationTolerance,
              polygons: selectedPolygons,
            ),
        ],
      ),
    );
  }

  List<Polygon> _polygonsForBoundaries(List<ProvinceBoundary> boundaries) {
    if (identical(_lastBoundaries, boundaries) && _boundaryPolygons != null) {
      return _boundaryPolygons!;
    }

    _lastBoundaries = boundaries;
    _boundaryPolygons = MapStartupTrace.timeSync(
      'overlay.provinceBoundary.polygons',
      () => [
        for (final boundary in boundaries)
          for (final polygon in boundary.polygons)
            _polygon(
              polygon,
              MapConstants.provinceBoundaryWidth,
              MapConstants.provinceBoundaryColor,
            ),
      ],
      arguments: {'boundaryCount': boundaries.length},
    );
    return _boundaryPolygons!;
  }

  List<Polygon> _polygonsForSelected(ProvinceBoundary? selectedBoundary) {
    if (identical(_lastSelectedBoundary, selectedBoundary) &&
        _selectedPolygons != null) {
      return _selectedPolygons!;
    }

    _lastSelectedBoundary = selectedBoundary;
    _selectedPolygons = selectedBoundary == null
        ? const []
        : MapStartupTrace.timeSync(
            'overlay.selectedProvince.polygons',
            () => [
              for (final polygon in selectedBoundary.polygons)
                _polygon(
                  polygon,
                  MapConstants.provinceHoverOutlineWidth,
                  MapConstants.provinceHoverOutlineColor,
                ),
            ],
            arguments: {'provinceId': selectedBoundary.id},
          );
    return _selectedPolygons!;
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
