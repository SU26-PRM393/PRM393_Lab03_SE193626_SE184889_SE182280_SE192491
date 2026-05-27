import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/data/admin_boundary_source.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_scope.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminBoundarySource', () {
    test('preserves An Giang disjoint rings as province geometry', () async {
      final data = await const AdminBoundarySource().loadInitialBoundaryData();

      expect(data.status, VietnamBoundaryDataStatus.ready);

      final anGiang = data.provinceBoundaries.singleWhere(
        (boundary) => boundary.provinceCode == '91',
      );

      expect(anGiang.polygons.length, greaterThan(1));
      expect(
        anGiang.contains(const LatLng(10.18453675203437, 105.03255680944322)),
        isTrue,
      );
      expect(anGiang.bounds.west, lessThan(104));
      expect(anGiang.bounds.east, greaterThan(105.5));
    });
  });
}
