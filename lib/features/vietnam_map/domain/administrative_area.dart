import 'package:latlong2/latlong.dart';

import 'lower_level_place.dart';
import 'map_boundary.dart';

enum AdministrativeAreaLevel {
  all,
  province,
  city,
  district,
}

enum AdministrativeAreaFilter {
  province,
  city,
  district,
}

enum BoundarySourceType {
  placeholder,
  geoJson,
  shapefile,
}

enum AdministrativeAreaSortDirection {
  ascending,
  descending;

  String get label {
    switch (this) {
      case AdministrativeAreaSortDirection.ascending:
        return 'Lower to higher';
      case AdministrativeAreaSortDirection.descending:
        return 'Higher to lower';
    }
  }
}

class AdministrativeAreaControlSpace {
  const AdministrativeAreaControlSpace({
    required this.searchText,
    required this.selectedLevel,
    required this.sortOption,
    required this.sortDirection,
    required this.filterChips,
    required this.isFunctional,
  });

  factory AdministrativeAreaControlSpace.active() {
    return const AdministrativeAreaControlSpace(
      searchText: '',
      selectedLevel: AdministrativeAreaLevel.all,
      sortOption: 'Name',
      sortDirection: AdministrativeAreaSortDirection.ascending,
      filterChips: ['Province', 'City', 'District'],
      isFunctional: true,
    );
  }

  factory AdministrativeAreaControlSpace.inactive() {
    return const AdministrativeAreaControlSpace(
      searchText: '',
      selectedLevel: AdministrativeAreaLevel.all,
      sortOption: 'Name',
      sortDirection: AdministrativeAreaSortDirection.ascending,
      filterChips: ['Province', 'City', 'District'],
      isFunctional: false,
    );
  }

  AdministrativeAreaControlSpace copyWith({
    String? searchText,
    AdministrativeAreaLevel? selectedLevel,
    String? sortOption,
    AdministrativeAreaSortDirection? sortDirection,
    bool? isFunctional,
  }) {
    return AdministrativeAreaControlSpace(
      searchText: searchText ?? this.searchText,
      selectedLevel: selectedLevel ?? this.selectedLevel,
      sortOption: sortOption ?? this.sortOption,
      sortDirection: sortDirection ?? this.sortDirection,
      filterChips: filterChips,
      isFunctional: isFunctional ?? this.isFunctional,
    );
  }

  final String searchText;
  final AdministrativeAreaLevel selectedLevel;
  final String sortOption;
  final AdministrativeAreaSortDirection sortDirection;
  final List<String> filterChips;
  final bool isFunctional;
}

class AdministrativeArea {
  const AdministrativeArea({
    required this.id,
    required this.name,
    required this.level,
    required this.boundarySource,
    this.provinceCode,
    this.boundaryId,
    this.geometryAsset,
  });

  final String id;
  final String name;
  final AdministrativeAreaLevel level;
  final BoundarySourceType boundarySource;
  final String? provinceCode;
  final String? boundaryId;
  final String? geometryAsset;
}

class AdministrativeAreaMetric {
  const AdministrativeAreaMetric({
    this.areaKm2,
    this.population,
    this.density,
  });

  final double? areaKm2;
  final int? population;
  final double? density;
}

class AdministrativeAreaSearchResult {
  const AdministrativeAreaSearchResult({
    required this.id,
    required this.name,
    required this.filter,
    required this.subtitle,
    required this.coordinate,
    required this.normalizedSearchText,
    this.provinceBoundary,
    this.lowerLevelPlace,
    this.areaKm2,
    this.population,
    this.density,
  });

  final String id;
  final String name;
  final AdministrativeAreaFilter filter;
  final String subtitle;
  final LatLng coordinate;
  final String normalizedSearchText;
  final ProvinceBoundary? provinceBoundary;
  final LowerLevelPlace? lowerLevelPlace;
  final double? areaKm2;
  final int? population;
  final double? density;

  String get levelLabel {
    switch (filter) {
      case AdministrativeAreaFilter.province:
        return 'Province';
      case AdministrativeAreaFilter.city:
        return 'City';
      case AdministrativeAreaFilter.district:
        return 'District';
    }
  }
}

class AdministrativeAreaSearchEngine {
  static List<AdministrativeAreaSearchResult> filterAndSort({
    required List<ProvinceBoundary> provinces,
    required List<LowerLevelPlace> lowerLevelPlaces,
    required String searchText,
    required AdministrativeAreaLevel selectedLevel,
    required Set<AdministrativeAreaFilter> selectedFilters,
    required String sortOption,
    required AdministrativeAreaSortDirection sortDirection,
    required Map<String, AdministrativeAreaMetric> provinceMetricsByCode,
    required Map<String, AdministrativeAreaMetric> lowerLevelMetricsByCode,
  }) {
    final normalizedQuery = _normalizeForSearch(searchText);

    final results = <AdministrativeAreaSearchResult>[
      for (final province in provinces)
        AdministrativeAreaSearchResult(
          id: 'province:${province.id}',
          name: province.name,
          filter: AdministrativeAreaFilter.province,
          subtitle: 'Province • ${province.provinceCode}',
          coordinate: province.labelCoordinate,
          normalizedSearchText: _normalizeForSearch(
            '${province.name} Province • ${province.provinceCode}',
          ),
          provinceBoundary: province,
          areaKm2: provinceMetricsByCode[province.provinceCode]?.areaKm2,
          population: provinceMetricsByCode[province.provinceCode]?.population,
          density: provinceMetricsByCode[province.provinceCode]?.density,
        ),
      for (final place in lowerLevelPlaces)
        AdministrativeAreaSearchResult(
          id: 'place:${place.id}',
          name: place.name,
          filter: _filterForLowerLevel(place),
          subtitle: place.parentName,
          coordinate: place.coordinate,
          normalizedSearchText:
              _normalizeForSearch('${place.name} ${place.parentName}'),
          lowerLevelPlace: place,
          areaKm2: lowerLevelMetricsByCode[place.code]?.areaKm2,
          population: lowerLevelMetricsByCode[place.code]?.population,
          density: lowerLevelMetricsByCode[place.code]?.density,
        ),
    ]
      ..retainWhere((result) => selectedFilters.contains(result.filter))
      ..retainWhere((result) {
        if (selectedLevel == AdministrativeAreaLevel.all) {
          return true;
        }

        return selectedLevel == AdministrativeAreaLevel.province
            ? result.filter == AdministrativeAreaFilter.province
            : result.filter != AdministrativeAreaFilter.province;
      })
      ..retainWhere((result) {
        if (normalizedQuery.isEmpty) {
          return true;
        }

        return result.normalizedSearchText.contains(normalizedQuery);
      });

    results.sort((left, right) {
      final comparison = _compareSortValues(
        left,
        right,
        sortOption,
        sortDirection,
      );

      if (comparison != 0) {
        return comparison;
      }

      if (sortOption == 'Name') {
        final comparison =
            left.normalizedSearchText.compareTo(right.normalizedSearchText);
        if (comparison != 0) {
          return sortDirection == AdministrativeAreaSortDirection.ascending
              ? comparison
              : -comparison;
        }

        final fallback = left.name.compareTo(right.name);
        return sortDirection == AdministrativeAreaSortDirection.ascending
            ? fallback
            : -fallback;
      }

      return _compareNames(
        left.name,
        right.name,
        AdministrativeAreaSortDirection.ascending,
      );
    });

    return results;
  }

  static int _compareSortValues(
    AdministrativeAreaSearchResult left,
    AdministrativeAreaSearchResult right,
    String sortOption,
    AdministrativeAreaSortDirection sortDirection,
  ) {
    switch (sortOption) {
      case 'Area':
        return _compareNullableDouble(
          left.areaKm2,
          right.areaKm2,
          sortDirection,
        );
      case 'Population':
        return _compareNullableInt(
          left.population,
          right.population,
          sortDirection,
        );
      case 'Density':
        return _compareNullableDouble(
          left.density,
          right.density,
          sortDirection,
        );
      case 'Name':
      default:
        return 0;
    }
  }

  static int _compareNullableDouble(
    double? left,
    double? right,
    AdministrativeAreaSortDirection sortDirection,
  ) {
    if (left == null && right == null) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }

    final comparison = left.compareTo(right);
    return sortDirection == AdministrativeAreaSortDirection.ascending
        ? comparison
        : -comparison;
  }

  static int _compareNullableInt(
    int? left,
    int? right,
    AdministrativeAreaSortDirection sortDirection,
  ) {
    if (left == null && right == null) {
      return 0;
    }
    if (left == null) {
      return 1;
    }
    if (right == null) {
      return -1;
    }

    final comparison = left.compareTo(right);
    return sortDirection == AdministrativeAreaSortDirection.ascending
        ? comparison
        : -comparison;
  }

  static int _compareNames(
    String left,
    String right,
    AdministrativeAreaSortDirection sortDirection,
  ) {
    final normalizedLeft = _normalizeForSearch(left);
    final normalizedRight = _normalizeForSearch(right);
    final comparison = normalizedLeft.compareTo(normalizedRight);
    if (comparison != 0) {
      return sortDirection == AdministrativeAreaSortDirection.ascending
          ? comparison
          : -comparison;
    }

    final fallback = left.compareTo(right);
    return sortDirection == AdministrativeAreaSortDirection.ascending
        ? fallback
        : -fallback;
  }

  static AdministrativeAreaFilter _filterForLowerLevel(LowerLevelPlace place) {
    if (place.level == 'special_zone') {
      return AdministrativeAreaFilter.city;
    }

    return AdministrativeAreaFilter.district;
  }

  static String _normalizeForSearch(String value) {
    return value
        .toLowerCase()
        .replaceAll('à', 'a')
        .replaceAll('á', 'a')
        .replaceAll('ả', 'a')
        .replaceAll('ã', 'a')
        .replaceAll('ạ', 'a')
        .replaceAll('â', 'a')
        .replaceAll('ấ', 'a')
        .replaceAll('ầ', 'a')
        .replaceAll('ẩ', 'a')
        .replaceAll('ẫ', 'a')
        .replaceAll('ậ', 'a')
        .replaceAll('ă', 'a')
        .replaceAll('ắ', 'a')
        .replaceAll('ằ', 'a')
        .replaceAll('ẳ', 'a')
        .replaceAll('ẵ', 'a')
        .replaceAll('ặ', 'a')
        .replaceAll('è', 'e')
        .replaceAll('é', 'e')
        .replaceAll('ẻ', 'e')
        .replaceAll('ẽ', 'e')
        .replaceAll('ẹ', 'e')
        .replaceAll('ê', 'e')
        .replaceAll('ế', 'e')
        .replaceAll('ề', 'e')
        .replaceAll('ể', 'e')
        .replaceAll('ễ', 'e')
        .replaceAll('ệ', 'e')
        .replaceAll('ì', 'i')
        .replaceAll('í', 'i')
        .replaceAll('ỉ', 'i')
        .replaceAll('ĩ', 'i')
        .replaceAll('ị', 'i')
        .replaceAll('ò', 'o')
        .replaceAll('ó', 'o')
        .replaceAll('ỏ', 'o')
        .replaceAll('õ', 'o')
        .replaceAll('ọ', 'o')
        .replaceAll('ô', 'o')
        .replaceAll('ố', 'o')
        .replaceAll('ồ', 'o')
        .replaceAll('ổ', 'o')
        .replaceAll('ỗ', 'o')
        .replaceAll('ộ', 'o')
        .replaceAll('ơ', 'o')
        .replaceAll('ớ', 'o')
        .replaceAll('ờ', 'o')
        .replaceAll('ở', 'o')
        .replaceAll('ỡ', 'o')
        .replaceAll('ợ', 'o')
        .replaceAll('ù', 'u')
        .replaceAll('ú', 'u')
        .replaceAll('ủ', 'u')
        .replaceAll('ũ', 'u')
        .replaceAll('ụ', 'u')
        .replaceAll('ư', 'u')
        .replaceAll('ứ', 'u')
        .replaceAll('ừ', 'u')
        .replaceAll('ử', 'u')
        .replaceAll('ữ', 'u')
        .replaceAll('ự', 'u')
        .replaceAll('ỳ', 'y')
        .replaceAll('ý', 'y')
        .replaceAll('ỷ', 'y')
        .replaceAll('ỹ', 'y')
        .replaceAll('ỵ', 'y')
        .replaceAll('đ', 'd');
  }
}
