import 'package:flutter_map/flutter_map.dart' show LatLngBounds;

import 'island_label_override.dart';
import 'lower_level_place.dart';
import 'map_boundary.dart';

enum VietnamBoundaryDataStatus {
  initial,
  ready,
  unavailable,
}

class VietNamMapScope {
  VietNamMapScope({
    required this.id,
    required this.displayName,
    required List<BoundaryPolygon> polygons,
    this.sourceVersion,
  })  : polygons = List.unmodifiable(polygons),
        bounds = polygons.isEmpty ? null : boundsFromPolygons(polygons);

  factory VietNamMapScope.empty() {
    return VietNamMapScope(
      id: 'vietnam',
      displayName: 'Việt Nam',
      polygons: const [],
    );
  }

  factory VietNamMapScope.fromProvinceBoundaries(
    List<ProvinceBoundary> boundaries, {
    String? sourceVersion,
  }) {
    return VietNamMapScope(
      id: 'vietnam',
      displayName: 'Việt Nam',
      polygons: [
        for (final boundary in boundaries) ...boundary.polygons,
      ],
      sourceVersion: sourceVersion,
    );
  }

  final String id;
  final String displayName;
  final List<BoundaryPolygon> polygons;
  final LatLngBounds? bounds;
  final String? sourceVersion;

  bool get hasGeometry => polygons.isNotEmpty && bounds != null;
}

class VietnamBoundaryData {
  const VietnamBoundaryData({
    required this.status,
    required this.scope,
    required this.provinceBoundaries,
    required this.lowerLevelPlaces,
    required this.islandLabels,
    this.message,
  });

  factory VietnamBoundaryData.initial() {
    return VietnamBoundaryData(
      status: VietnamBoundaryDataStatus.initial,
      scope: VietNamMapScope.empty(),
      provinceBoundaries: const [],
      lowerLevelPlaces: const [],
      islandLabels: IslandLabelOverride.defaults,
    );
  }

  factory VietnamBoundaryData.ready({
    required VietNamMapScope scope,
    required List<ProvinceBoundary> provinceBoundaries,
    required List<LowerLevelPlace> lowerLevelPlaces,
    required List<IslandLabelOverride> islandLabels,
  }) {
    return VietnamBoundaryData(
      status: VietnamBoundaryDataStatus.ready,
      scope: scope,
      provinceBoundaries: List.unmodifiable(provinceBoundaries),
      lowerLevelPlaces: List.unmodifiable(lowerLevelPlaces),
      islandLabels: List.unmodifiable(islandLabels),
    );
  }

  factory VietnamBoundaryData.unavailable(String message) {
    return VietnamBoundaryData(
      status: VietnamBoundaryDataStatus.unavailable,
      scope: VietNamMapScope.empty(),
      provinceBoundaries: const [],
      lowerLevelPlaces: const [],
      islandLabels: IslandLabelOverride.defaults,
      message: message,
    );
  }

  final VietnamBoundaryDataStatus status;
  final VietNamMapScope scope;
  final List<ProvinceBoundary> provinceBoundaries;
  final List<LowerLevelPlace> lowerLevelPlaces;
  final List<IslandLabelOverride> islandLabels;
  final String? message;

  bool get isUnavailable => status == VietnamBoundaryDataStatus.unavailable;
  bool get hasProvinceBoundaries => provinceBoundaries.isNotEmpty;

  VietnamBoundaryData copyWith({
    VietnamBoundaryDataStatus? status,
    VietNamMapScope? scope,
    List<ProvinceBoundary>? provinceBoundaries,
    List<LowerLevelPlace>? lowerLevelPlaces,
    List<IslandLabelOverride>? islandLabels,
    String? message,
    bool clearMessage = false,
  }) {
    return VietnamBoundaryData(
      status: status ?? this.status,
      scope: scope ?? this.scope,
      provinceBoundaries:
          List.unmodifiable(provinceBoundaries ?? this.provinceBoundaries),
      lowerLevelPlaces:
          List.unmodifiable(lowerLevelPlaces ?? this.lowerLevelPlaces),
      islandLabels: List.unmodifiable(islandLabels ?? this.islandLabels),
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
