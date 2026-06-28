import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/utils/map_startup_trace.dart';
import 'package:vietnam_map_flutter/models/map_boundary.dart';
import 'package:vietnam_map_flutter/models/province_hover_state.dart';

class ProvinceHoverOutline extends StatefulWidget {
  const ProvinceHoverOutline({
    required this.state,
    super.key,
  });

  final ProvinceHoverState state;

  @override
  State<ProvinceHoverOutline> createState() => _ProvinceHoverOutlineState();
}

class _ProvinceHoverOutlineState extends State<ProvinceHoverOutline> {
  ProvinceBoundary? _lastBoundary;
  List<Polygon>? _outlinePolygons;
  List<Polygon>? _haloPolygons;

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final boundary = state.hoveredBoundary;
    if (!state.isActive || boundary == null) {
      return const SizedBox.shrink();
    }

    final outlinePolygons = _outlinesFor(boundary);
    final haloPolygons = _halosFor(boundary);

    return IgnorePointer(
      child: Stack(
        children: [
          PolygonLayer(
            polygonLabels: false,
            painterFillMethod: PolygonPainterFillMethod.evenOdd,
            polygonCulling: false,
            simplificationTolerance:
                MapConstants.interactionOutlineSimplificationTolerance,
            polygons: haloPolygons,
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

  List<Polygon> _outlinesFor(ProvinceBoundary boundary) {
    if (identical(_lastBoundary, boundary) && _outlinePolygons != null) {
      return _outlinePolygons!;
    }

    _lastBoundary = boundary;
    _outlinePolygons = MapStartupTrace.timeSync(
      'overlay.hoverOutline.polygons',
      () => [
        for (final polygon in boundary.polygons) _outlinePolygon(polygon),
      ],
      arguments: {'provinceId': boundary.id},
    );
    _haloPolygons = null;
    return _outlinePolygons!;
  }

  List<Polygon> _halosFor(ProvinceBoundary boundary) {
    if (identical(_lastBoundary, boundary) && _haloPolygons != null) {
      return _haloPolygons!;
    }

    _lastBoundary = boundary;
    _haloPolygons = MapStartupTrace.timeSync(
      'overlay.hoverHalo.polygons',
      () => [
        for (final polygon in boundary.polygons) _haloPolygon(polygon),
      ],
      arguments: {'provinceId': boundary.id},
    );
    return _haloPolygons!;
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
