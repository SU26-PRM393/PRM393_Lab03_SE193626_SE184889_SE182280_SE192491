import 'package:flutter_map/flutter_map.dart' show LatLngBounds;
import 'package:latlong2/latlong.dart';

class BoundaryRing {
  BoundaryRing({required List<LatLng> points})
      : points = List.unmodifiable(points),
        bounds = LatLngBounds.fromPoints(points);

  final List<LatLng> points;
  final LatLngBounds bounds;

  bool contains(LatLng coordinate) {
    return isCoordinateInBounds(bounds, coordinate) &&
        _pointInRing(coordinate, points);
  }
}

class BoundaryPolygon {
  BoundaryPolygon({
    required this.outerRing,
    List<BoundaryRing> holes = const [],
  })  : holes = List.unmodifiable(holes),
        bounds = outerRing.bounds;

  final BoundaryRing outerRing;
  final List<BoundaryRing> holes;
  final LatLngBounds bounds;

  bool contains(LatLng coordinate) {
    if (!outerRing.contains(coordinate)) {
      return false;
    }

    for (final hole in holes) {
      if (hole.contains(coordinate)) {
        return false;
      }
    }

    return true;
  }
}

class ProvinceBoundary {
  ProvinceBoundary({
    required this.id,
    required this.provinceCode,
    required this.name,
    required this.level,
    required List<BoundaryPolygon> polygons,
  })  : polygons = List.unmodifiable(polygons),
        bounds =
            _extendedBoundsFor(provinceCode, _boundsFromPolygons(polygons)),
        labelCoordinate = _labelCoordinateFor(polygons);

  final String id;
  final String provinceCode;
  final String name;
  final String level;
  final List<BoundaryPolygon> polygons;
  final LatLngBounds bounds;
  final LatLng labelCoordinate;

  bool contains(LatLng coordinate) {
    if (!isCoordinateInBounds(bounds, coordinate)) {
      return false;
    }

    for (final polygon in polygons) {
      if (polygon.contains(coordinate)) {
        return true;
      }
    }

    return false;
  }

  static LatLngBounds _extendedBoundsFor(
      String provinceCode, LatLngBounds originalBounds) {
    if (provinceCode == '48') {
      // Da Nang: include Hoang Sa commune coordinate
      final points = [
        originalBounds.northWest,
        originalBounds.southEast,
        const LatLng(16.371347929067802, 112.07857797346432),
      ];
      return LatLngBounds.fromPoints(points);
    } else if (provinceCode == '56') {
      // Khanh Hoa: include Truong Sa commune coordinate
      final points = [
        originalBounds.northWest,
        originalBounds.southEast,
        const LatLng(9.288659257720576, 113.97556476731718),
      ];
      return LatLngBounds.fromPoints(points);
    }
    return originalBounds;
  }
}

LatLngBounds boundsFromPolygons(List<BoundaryPolygon> polygons) {
  return _boundsFromPolygons(polygons);
}

bool isCoordinateInBounds(LatLngBounds bounds, LatLng coordinate) {
  return coordinate.latitude >= bounds.south &&
      coordinate.latitude <= bounds.north &&
      coordinate.longitude >= bounds.west &&
      coordinate.longitude <= bounds.east;
}

LatLngBounds _boundsFromPolygons(List<BoundaryPolygon> polygons) {
  final points = <LatLng>[];
  for (final polygon in polygons) {
    points
      ..add(polygon.bounds.northWest)
      ..add(polygon.bounds.southEast);
  }
  return LatLngBounds.fromPoints(points);
}

LatLng _labelCoordinateFor(List<BoundaryPolygon> polygons) {
  if (polygons.isEmpty) {
    return const LatLng(0, 0);
  }

  final polygon = _largestPolygon(polygons);
  return _ringCentroid(polygon.outerRing.points) ??
      _boundsCenter(polygon.bounds);
}

BoundaryPolygon _largestPolygon(List<BoundaryPolygon> polygons) {
  var largest = polygons.first;
  var largestArea = _polygonBoundsArea(largest);

  for (final polygon in polygons.skip(1)) {
    final area = _polygonBoundsArea(polygon);
    if (area > largestArea) {
      largest = polygon;
      largestArea = area;
    }
  }

  return largest;
}

double _polygonBoundsArea(BoundaryPolygon polygon) {
  final bounds = polygon.bounds;
  return (bounds.north - bounds.south).abs() *
      (bounds.east - bounds.west).abs();
}

LatLng? _ringCentroid(List<LatLng> points) {
  if (points.length < 3) {
    return null;
  }

  var signedArea = 0.0;
  var centroidLatitude = 0.0;
  var centroidLongitude = 0.0;

  for (var i = 0; i < points.length; i++) {
    final current = points[i];
    final next = points[(i + 1) % points.length];
    final factor =
        current.longitude * next.latitude - next.longitude * current.latitude;

    signedArea += factor;
    centroidLongitude += (current.longitude + next.longitude) * factor;
    centroidLatitude += (current.latitude + next.latitude) * factor;
  }

  signedArea *= 0.5;
  if (signedArea.abs() < 0.0000001) {
    return null;
  }

  final latitude = centroidLatitude / (6 * signedArea);
  final longitude = centroidLongitude / (6 * signedArea);
  if (!latitude.isFinite || !longitude.isFinite) {
    return null;
  }

  return LatLng(latitude, longitude);
}

LatLng _boundsCenter(LatLngBounds bounds) {
  return LatLng(
    (bounds.north + bounds.south) / 2,
    (bounds.east + bounds.west) / 2,
  );
}

bool _pointInRing(LatLng coordinate, List<LatLng> ring) {
  var inside = false;
  final x = coordinate.longitude;
  final y = coordinate.latitude;

  for (var i = 0, j = ring.length - 1; i < ring.length; j = i++) {
    final xi = ring[i].longitude;
    final yi = ring[i].latitude;
    final xj = ring[j].longitude;
    final yj = ring[j].latitude;

    final intersects =
        (yi > y) != (yj > y) && x < ((xj - xi) * (y - yi)) / (yj - yi) + xi;
    if (intersects) {
      inside = !inside;
    }
  }

  return inside;
}
