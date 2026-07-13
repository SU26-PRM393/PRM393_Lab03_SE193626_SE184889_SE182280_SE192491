import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_map_flutter/models/island_label_override.dart';
import 'package:vietnam_map_flutter/models/map_boundary.dart';
import 'package:vietnam_map_flutter/models/map_scope.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';

void main() {
  group('VietnamMapController performance paths', () {
    test('invalidates cached search results when search input changes', () {
      final controller = VietnamMapController();
      addTearDown(controller.dispose);

      controller.setBoundaryDataForTesting(_boundaryData());

      final initialResults = controller.filteredAdministrativeEntries;
      expect(initialResults, hasLength(2));
      expect(controller.hasCachedAdministrativeEntries, isTrue);

      controller.updateSearchText('two');

      expect(controller.hasCachedAdministrativeEntries, isFalse);
      expect(
        controller.filteredAdministrativeEntries.map((result) => result.name),
        ['Province Two'],
      );
    });

    testWidgets('resolves only the latest hover coordinate in a frame',
        (tester) async {
      final controller = VietnamMapController();
      addTearDown(controller.dispose);
      controller.setBoundaryDataForTesting(_boundaryData());

      var hoverNotifications = 0;
      controller.provinceHoverNotifier.addListener(() {
        hoverNotifications += 1;
      });

      controller.updateProvinceHover(const LatLng(0.5, 0.5));
      controller.updateProvinceHover(const LatLng(2.5, 2.5));

      expect(controller.provinceHoverState.isInactive, isTrue);

      await tester.pump();

      expect(controller.provinceHoverState.hoveredProvinceId, 'p2');
      expect(hoverNotifications, 1);
    });
  });
}

VietnamBoundaryData _boundaryData() {
  final provinces = [
    _province(
      id: 'p1',
      code: '01',
      name: 'Province One',
      south: 0,
      west: 0,
      north: 1,
      east: 1,
    ),
    _province(
      id: 'p2',
      code: '02',
      name: 'Province Two',
      south: 2,
      west: 2,
      north: 3,
      east: 3,
    ),
  ];

  return VietnamBoundaryData.ready(
    scope: VietNamMapScope.fromProvinceBoundaries(provinces),
    provinceBoundaries: provinces,
    lowerLevelPlaces: const [],
    islandLabels: IslandLabelOverride.defaults,
  );
}

ProvinceBoundary _province({
  required String id,
  required String code,
  required String name,
  required double south,
  required double west,
  required double north,
  required double east,
}) {
  return ProvinceBoundary(
    id: id,
    provinceCode: code,
    name: name,
    level: 'Province',
    polygons: [
      BoundaryPolygon(
        outerRing: BoundaryRing(
          points: [
            LatLng(south, west),
            LatLng(north, west),
            LatLng(north, east),
            LatLng(south, east),
            LatLng(south, west),
          ],
        ),
      ),
    ],
  );
}
