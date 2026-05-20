import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';
import '../domain/administrative_area.dart';
import '../domain/island_label_override.dart';
import '../domain/lower_level_place.dart';
import '../domain/map_boundary.dart';
import '../domain/map_scope.dart';

class AdminBoundarySource {
  const AdminBoundarySource();

  static Future<VietnamBoundaryData>? _cachedBoundaryData;

  Future<List<AdministrativeArea>> loadPlaceholders() async {
    return const <AdministrativeArea>[];
  }

  Future<VietnamBoundaryData> loadBoundaryData() {
    return _cachedBoundaryData ??= _loadBoundaryData();
  }

  Future<VietnamBoundaryData> _loadBoundaryData() async {
    try {
      final provinceBoundaries = await _loadProvinceBoundaries();
      final lowerLevelPlaces = await _loadLowerLevelPlaces();
      final islandLabels = await _loadIslandLabelOverrides();

      return VietnamBoundaryData.ready(
        scope: VietNamMapScope.fromProvinceBoundaries(
          provinceBoundaries,
          sourceVersion: '2026.04.16-sapnhap-bando-vn-local',
        ),
        provinceBoundaries: provinceBoundaries,
        lowerLevelPlaces: lowerLevelPlaces,
        islandLabels: islandLabels,
      );
    } catch (_) {
      return VietnamBoundaryData.unavailable(
        'Province boundary data is unavailable.',
      );
    }
  }

  Future<List<ProvinceBoundary>> _loadProvinceBoundaries() async {
    final raw = await rootBundle.loadString(
      MapConstants.provinceBoundariesAsset,
    );
    return compute(_decodeProvinceBoundaries, raw);
  }

  Future<List<LowerLevelPlace>> _loadLowerLevelPlaces() async {
    final raw = await rootBundle.loadString(MapConstants.lowerUnitsAsset);
    return compute(_decodeLowerLevelPlaces, raw);
  }

  Future<List<IslandLabelOverride>> _loadIslandLabelOverrides() async {
    try {
      final raw = await rootBundle.loadString(
        MapConstants.islandLabelOverridesAsset,
      );
      final decoded = jsonDecode(raw) as List<dynamic>;

      return [
        for (final item in decoded)
          _parseIslandLabelOverride(item as Map<String, dynamic>),
      ];
    } catch (_) {
      return IslandLabelOverride.defaults;
    }
  }

  IslandLabelOverride _parseIslandLabelOverride(Map<String, dynamic> item) {
    return IslandLabelOverride(
      id: item['id'].toString(),
      legacyLabel: item['legacyLabel'].toString(),
      displayLabel: item['displayLabel'].toString(),
      anchor: LatLng(
        (item['lat'] as num).toDouble(),
        (item['lon'] as num).toDouble(),
      ),
      minZoom: (item['minZoom'] as num).toDouble(),
      maxZoom: (item['maxZoom'] as num).toDouble(),
      coverLegacyLabel: item['coverLegacyLabel'] == true,
    );
  }

  // Future data path:
  // - Use approved local boundary extracts as the source dataset.
  // - Preprocess province/city/district boundaries from GeoJSON or Shapefiles.
  // - Package approved offline basemap tiles as MBTiles or PMTiles.
  // - Do not prefetch public OSM tiles for offline use.
}

List<ProvinceBoundary> _decodeProvinceBoundaries(String raw) {
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  final features = decoded['features'] as List<dynamic>;

  return [
    for (final feature in features)
      _parseProvinceFeature(feature as Map<String, dynamic>),
  ];
}

List<LowerLevelPlace> _decodeLowerLevelPlaces(String raw) {
  final decoded = jsonDecode(raw) as Map<String, dynamic>;
  final features = decoded['features'] as List<dynamic>;

  return [
    for (final feature in features)
      _parseLowerLevelPlace(feature as Map<String, dynamic>),
  ];
}

LowerLevelPlace _parseLowerLevelPlace(Map<String, dynamic> feature) {
  final properties = feature['properties'] as Map<String, dynamic>;
  final geometry = feature['geometry'] as Map<String, dynamic>;
  final coordinates = geometry['coordinates'] as List<dynamic>;

  return LowerLevelPlace(
    id: properties['id']?.toString() ?? properties['code'].toString(),
    code: properties['code'].toString(),
    name: properties['name'].toString(),
    level: properties['level'].toString(),
    parentCode: properties['parent_code'].toString(),
    parentName: properties['parent_name'].toString(),
    coordinate: LatLng(
      (coordinates[1] as num).toDouble(),
      (coordinates[0] as num).toDouble(),
    ),
  );
}

ProvinceBoundary _parseProvinceFeature(Map<String, dynamic> feature) {
  final properties = feature['properties'] as Map<String, dynamic>;
  final geometry = feature['geometry'] as Map<String, dynamic>;
  final id = properties['id']?.toString() ?? feature['id']?.toString() ?? '';
  final code = properties['ma']?.toString() ?? id;
  final name = properties['ten']?.toString() ?? code;
  final level = properties['type']?.toString() ?? 'Province';

  return ProvinceBoundary(
    id: id,
    provinceCode: code,
    name: name,
    level: level,
    polygons: _parseGeometry(geometry),
  );
}

List<BoundaryPolygon> _parseGeometry(Map<String, dynamic> geometry) {
  final type = geometry['type']?.toString();
  final coordinates = geometry['coordinates'] as List<dynamic>;

  if (type == 'Polygon') {
    return [_parsePolygon(coordinates)];
  }

  if (type == 'MultiPolygon') {
    return [
      for (final polygon in coordinates)
        _parsePolygon(polygon as List<dynamic>),
    ];
  }

  return const [];
}

BoundaryPolygon _parsePolygon(List<dynamic> polygonCoordinates) {
  final rings = [
    for (final ring in polygonCoordinates) _parseRing(ring as List<dynamic>),
  ].where((ring) => ring.points.length >= 4).toList(growable: false);

  if (rings.isEmpty) {
    throw const FormatException('Boundary polygon has no valid rings.');
  }

  return BoundaryPolygon(
    outerRing: rings.first,
    holes: rings.skip(1).toList(growable: false),
  );
}

BoundaryRing _parseRing(List<dynamic> ringCoordinates) {
  return BoundaryRing(
    points: [
      for (final coordinate in ringCoordinates)
        _parseCoordinate(coordinate as List<dynamic>),
    ],
  );
}

LatLng _parseCoordinate(List<dynamic> coordinate) {
  final longitude = (coordinate[0] as num).toDouble();
  final latitude = (coordinate[1] as num).toDouble();

  return LatLng(latitude, longitude);
}
