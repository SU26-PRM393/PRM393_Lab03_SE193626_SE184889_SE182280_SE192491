import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/administrative_area.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/lower_level_place.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/map_boundary.dart';

void main() {
  group('AdministrativeAreaSearchEngine', () {
    const hanoiName = 'Hà Nội';
    const hoChiMinhName = 'Hồ Chí Minh';

    final provinces = <ProvinceBoundary>[
      ProvinceBoundary(
        id: 'p1',
        provinceCode: '01',
        name: hanoiName,
        level: 'Province',
        polygons: [
          BoundaryPolygon(
            outerRing: BoundaryRing(
              points: const [
                LatLng(21.0, 105.8),
                LatLng(21.1, 105.8),
                LatLng(21.1, 105.9),
                LatLng(21.0, 105.9),
                LatLng(21.0, 105.8),
              ],
            ),
          ),
        ],
      ),
      ProvinceBoundary(
        id: 'p2',
        provinceCode: '79',
        name: hoChiMinhName,
        level: 'Province',
        polygons: [
          BoundaryPolygon(
            outerRing: BoundaryRing(
              points: const [
                LatLng(10.7, 106.6),
                LatLng(10.8, 106.6),
                LatLng(10.8, 106.7),
                LatLng(10.7, 106.7),
                LatLng(10.7, 106.6),
              ],
            ),
          ),
        ],
      ),
    ];

    final places = <LowerLevelPlace>[
      const LowerLevelPlace(
        id: 'd1',
        code: '00001',
        name: 'Bạch Mai',
        level: 'ward',
        parentCode: '01',
        parentName: hanoiName,
        coordinate: LatLng(21.0, 105.85),
      ),
      const LowerLevelPlace(
        id: 'd2',
        code: '00002',
        name: 'Đống Đa',
        level: 'commune',
        parentCode: '01',
        parentName: hanoiName,
        coordinate: LatLng(21.02, 105.83),
      ),
      const LowerLevelPlace(
        id: 'c1',
        code: '00003',
        name: 'Thành phố Sài Gòn',
        level: 'special_zone',
        parentCode: '79',
        parentName: hoChiMinhName,
        coordinate: LatLng(10.76, 106.66),
      ),
    ];

    final provinceMetrics = <String, AdministrativeAreaMetric>{
      '01': const AdministrativeAreaMetric(
        areaKm2: 3359,
        population: 8400000,
        density: 2500,
      ),
      '79': const AdministrativeAreaMetric(
        areaKm2: 2095,
        population: 9300000,
        density: 4440,
      ),
    };

    final lowerLevelMetrics = <String, AdministrativeAreaMetric>{
      '00001': const AdministrativeAreaMetric(
        areaKm2: 10,
        population: 120000,
        density: 12000,
      ),
      '00002': const AdministrativeAreaMetric(
        areaKm2: 12,
        population: 150000,
        density: 12500,
      ),
      '00003': const AdministrativeAreaMetric(
        areaKm2: 12,
        population: 130000,
        density: 10800,
      ),
    };

    test('filters by search text and selected level, then sorts by name', () {
      final results = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: places,
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: lowerLevelMetrics,
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: 'ha',
          selectedLevel: AdministrativeAreaLevel.province,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Name',
          sortDirection: AdministrativeAreaSortDirection.ascending,
        ),
      );

      expect(results.map((result) => result.name).toList(), [hanoiName]);
    });

    test('filters by city and district chips and keeps alphabetical order', () {
      final results = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: places,
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: lowerLevelMetrics,
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.district,
          selectedFilters: {
            AdministrativeAreaFilter.city,
            AdministrativeAreaFilter.district,
          },
          sortOption: 'Name',
          sortDirection: AdministrativeAreaSortDirection.ascending,
        ),
      );

      expect(
        results.map((result) => result.name).toList(),
        ['Bạch Mai', 'Đống Đa', 'Thành phố Sài Gòn'],
      );
    });

    test('sorts by area, population, and density when requested', () {
      final areaResults = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: const [],
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: const {},
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.all,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Area',
          sortDirection: AdministrativeAreaSortDirection.descending,
        ),
      );

      final populationResults = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: const [],
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: const {},
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.all,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Population',
          sortDirection: AdministrativeAreaSortDirection.descending,
        ),
      );

      final densityResults = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: const [],
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: const {},
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.all,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Density',
          sortDirection: AdministrativeAreaSortDirection.descending,
        ),
      );

      expect(areaResults.map((result) => result.name).toList(),
          [hanoiName, hoChiMinhName]);
      expect(
        populationResults.map((result) => result.name).toList(),
        [hoChiMinhName, hanoiName],
      );
      expect(
        densityResults.map((result) => result.name).toList(),
        [hoChiMinhName, hanoiName],
      );
    });

    test('supports ascending and descending order for the selected metric', () {
      final ascending = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: const [],
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: const {},
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.all,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Area',
          sortDirection: AdministrativeAreaSortDirection.ascending,
        ),
      );

      final descending = AdministrativeAreaSearchEngine.filterAndSort(
        data: AdministrativeAreaSearchData(
          provinces: provinces,
          lowerLevelPlaces: const [],
          provinceMetricsByCode: provinceMetrics,
          lowerLevelMetricsByCode: const {},
        ),
        criteria: const AdministrativeAreaSearchCriteria(
          searchText: '',
          selectedLevel: AdministrativeAreaLevel.all,
          selectedFilters: {AdministrativeAreaFilter.province},
          sortOption: 'Area',
          sortDirection: AdministrativeAreaSortDirection.descending,
        ),
      );

      expect(ascending.map((result) => result.name).toList(),
          [hoChiMinhName, hanoiName]);
      expect(descending.map((result) => result.name).toList(),
          [hanoiName, hoChiMinhName]);
    });
  });
}
