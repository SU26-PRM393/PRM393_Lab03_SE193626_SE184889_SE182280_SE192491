import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/data/map_tile_source.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/current_location_state.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/island_label_override.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_boundary.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_scope.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_tile_source.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_view_state.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/province_hover_state.dart';

void main() {
  group('Boundary geometry', () {
    test('checks bounds before polygon containment', () {
      final ring = _ring(
        south: 10,
        west: 100,
        north: 11,
        east: 101,
      );

      expect(ring.contains(const LatLng(10.5, 100.5)), isTrue);
      expect(ring.contains(const LatLng(12, 100.5)), isFalse);
      expect(ring.contains(const LatLng(10.5, 102)), isFalse);
    });

    test('treats inner rings as holes', () {
      final polygon = BoundaryPolygon(
        outerRing: _ring(south: 0, west: 0, north: 10, east: 10),
        holes: [_ring(south: 4, west: 4, north: 6, east: 6)],
      );

      expect(polygon.contains(const LatLng(2, 2)), isTrue);
      expect(polygon.contains(const LatLng(5, 5)), isFalse);
      expect(polygon.contains(const LatLng(20, 20)), isFalse);
    });

    test('uses largest polygon for province label coordinate', () {
      final boundary = ProvinceBoundary(
        id: 'province',
        provinceCode: '01',
        name: 'Province',
        level: 'Province',
        polygons: [
          _polygon(south: 0, west: 0, north: 1, east: 1),
          _polygon(south: 10, west: 10, north: 20, east: 20),
        ],
      );

      expect(boundary.contains(const LatLng(0.5, 0.5)), isTrue);
      expect(boundary.contains(const LatLng(15, 15)), isTrue);
      expect(boundary.contains(const LatLng(5, 5)), isFalse);
      expect(boundary.labelCoordinate.latitude, closeTo(15, 0.001));
      expect(boundary.labelCoordinate.longitude, closeTo(15, 0.001));
    });

    test('extends island province bounds without changing polygon hit test',
        () {
      final daNang = ProvinceBoundary(
        id: 'da-nang',
        provinceCode: '48',
        name: 'Da Nang',
        level: 'City',
        polygons: [
          _polygon(south: 15.9, west: 107.9, north: 16.2, east: 108.3)
        ],
      );

      expect(
        isCoordinateInBounds(
          daNang.bounds,
          const LatLng(16.371347929067802, 112.07857797346432),
        ),
        isTrue,
      );
      expect(
        daNang.contains(
          const LatLng(16.371347929067802, 112.07857797346432),
        ),
        isFalse,
      );
    });

    test('falls back to bounds center for degenerate label geometry', () {
      final boundary = ProvinceBoundary(
        id: 'line',
        provinceCode: '02',
        name: 'Line Province',
        level: 'Province',
        polygons: [
          BoundaryPolygon(
            outerRing: BoundaryRing(
              points: const [
                LatLng(1, 1),
                LatLng(2, 2),
                LatLng(3, 3),
                LatLng(1, 1),
              ],
            ),
          ),
        ],
      );

      expect(boundary.labelCoordinate.latitude, closeTo(2, 0.001));
      expect(boundary.labelCoordinate.longitude, closeTo(2, 0.001));
    });
  });

  group('Map scope data', () {
    test('creates initial, ready, unavailable, and copied boundary data', () {
      final province = _province(
        id: 'p1',
        code: '01',
        south: 0,
        west: 0,
        north: 1,
        east: 1,
      );

      final initial = VietnamBoundaryData.initial();
      expect(initial.status, VietnamBoundaryDataStatus.initial);
      expect(initial.scope.hasGeometry, isFalse);

      final ready = VietnamBoundaryData.ready(
        scope: VietNamMapScope.fromProvinceBoundaries([province]),
        provinceBoundaries: [province],
        lowerLevelPlaces: const [],
        islandLabels: IslandLabelOverride.defaults,
      );
      expect(ready.status, VietnamBoundaryDataStatus.ready);
      expect(ready.scope.hasGeometry, isTrue);
      expect(ready.hasProvinceBoundaries, isTrue);

      final copied = ready.copyWith(
        status: VietnamBoundaryDataStatus.unavailable,
        message: 'missing',
      );
      expect(copied.isUnavailable, isTrue);
      expect(copied.message, 'missing');
      expect(copied.copyWith(clearMessage: true).message, isNull);
    });
  });

  group('Map viewport state', () {
    test('tracks interaction, clamps camera state, and clears messages', () {
      final initial = MapViewport.initial();
      expect(initial.status, MapViewportStatus.initial);

      final unavailable = initial.markSourceUnavailable('offline');
      expect(unavailable.isSourceUnavailable, isTrue);
      expect(unavailable.hasMessage, isTrue);

      final ready = unavailable.markReady();
      expect(ready.status, MapViewportStatus.ready);
      expect(ready.hasMessage, isFalse);

      final tracked = ready.trackInteraction(
        center: const LatLng(21, 106),
        zoom: 12,
        hasGesture: true,
        occurredAt: DateTime(2026, 1, 1),
      );
      expect(tracked.isInteracting, isTrue);
      expect(tracked.lastInteractionAt, DateTime(2026, 1, 1));

      final clamped = tracked.copyWith(zoom: 100);
      expect(clamped.zoom, tracked.maxZoom);
      expect(
        tracked.constrainCenter(const LatLng(90, 200)).latitude,
        tracked.cameraBounds.north,
      );
    });
  });

  group('Current location state', () {
    test('reports status helpers and preserves values through copyWith', () {
      final unknown = CurrentLocationState.unknown();
      expect(unknown.hasMessage, isTrue);
      expect(unknown.isRequesting, isFalse);

      final available = unknown.copyWith(
        status: CurrentLocationStatus.available,
        coordinate: const LatLng(21.0278, 105.8342),
        accuracyMeters: 20,
        message: '',
        lastUpdatedAt: DateTime(2026, 1, 2),
      );

      expect(available.isAvailable, isTrue);
      expect(available.hasMessage, isFalse);
      expect(available.accuracyMeters, 20);
      expect(available.lastUpdatedAt, DateTime(2026, 1, 2));
    });
  });

  group('Map tile source metadata', () {
    test('identifies online and vector sources', () {
      expect(MapTileSources.defaultBasemap.isOnline, isTrue);
      expect(MapTileSources.defaultBasemap.isVector, isTrue);

      const offline = MapTileSource(
        name: 'Offline',
        type: MapTileSourceType.localMbtiles,
        attribution: 'Local',
        cachePolicy: 'Packaged with app',
        supportsOffline: true,
      );

      expect(offline.isOnline, isFalse);
      expect(offline.isVector, isFalse);
      expect(offline.supportsOffline, isTrue);
    });
  });

  group('Province hover resolver', () {
    test('returns unavailable when no boundaries are available', () {
      final state = ProvinceHoverResolver.resolve(
        coordinate: const LatLng(0, 0),
        boundaries: const [],
        occurredAt: DateTime(2026, 1, 1),
      );

      expect(state.status, ProvinceHoverStatus.unavailable);
      expect(state.message, isNotEmpty);
    });

    test('resolves active and inactive mainland coordinates', () {
      final province = _province(
        id: 'p1',
        code: '01',
        south: 0,
        west: 0,
        north: 1,
        east: 1,
      );

      final active = ProvinceHoverResolver.resolve(
        coordinate: const LatLng(0.5, 0.5),
        boundaries: [province],
        occurredAt: DateTime(2026, 1, 1),
      );
      final inactive = ProvinceHoverResolver.resolve(
        coordinate: const LatLng(5, 5),
        boundaries: [province],
        occurredAt: DateTime(2026, 1, 1),
      );

      expect(active.isActive, isTrue);
      expect(active.hoveredProvinceId, 'p1');
      expect(inactive.isInactive, isTrue);
      expect(active.isSameVisibleState(active), isTrue);
      expect(active.isSameVisibleState(inactive), isFalse);
    });

    test('maps island hover areas to the configured province codes', () {
      final daNang = _province(
        id: 'da-nang',
        code: '48',
        south: 15,
        west: 107,
        north: 17,
        east: 109,
      );
      final khanhHoa = _province(
        id: 'khanh-hoa',
        code: '56',
        south: 11,
        west: 108,
        north: 13,
        east: 110,
      );

      final hoangSa = ProvinceHoverResolver.resolve(
        coordinate: const LatLng(16.4, 112.1),
        boundaries: [daNang, khanhHoa],
        occurredAt: DateTime(2026, 1, 1),
      );
      final truongSa = ProvinceHoverResolver.resolve(
        coordinate: const LatLng(9.3, 114),
        boundaries: [daNang, khanhHoa],
        occurredAt: DateTime(2026, 1, 1),
      );

      expect(hoangSa.hoveredProvinceId, 'da-nang');
      expect(truongSa.hoveredProvinceId, 'khanh-hoa');
    });
  });
}

ProvinceBoundary _province({
  required String id,
  required String code,
  required double south,
  required double west,
  required double north,
  required double east,
}) {
  return ProvinceBoundary(
    id: id,
    provinceCode: code,
    name: id,
    level: 'Province',
    polygons: [_polygon(south: south, west: west, north: north, east: east)],
  );
}

BoundaryPolygon _polygon({
  required double south,
  required double west,
  required double north,
  required double east,
}) {
  return BoundaryPolygon(
    outerRing: _ring(south: south, west: west, north: north, east: east),
  );
}

BoundaryRing _ring({
  required double south,
  required double west,
  required double north,
  required double east,
}) {
  return BoundaryRing(
    points: [
      LatLng(south, west),
      LatLng(north, west),
      LatLng(north, east),
      LatLng(south, east),
      LatLng(south, west),
    ],
  );
}
