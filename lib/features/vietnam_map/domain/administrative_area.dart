enum AdministrativeAreaLevel {
  all,
  province,
  city,
  district,
}

enum BoundarySourceType {
  placeholder,
  geoJson,
  shapefile,
}

class AdministrativeAreaControlSpace {
  const AdministrativeAreaControlSpace({
    required this.searchText,
    required this.selectedLevel,
    required this.sortOption,
    required this.filterChips,
    required this.isFunctional,
  });

  factory AdministrativeAreaControlSpace.inactive() {
    return const AdministrativeAreaControlSpace(
      searchText: '',
      selectedLevel: AdministrativeAreaLevel.all,
      sortOption: 'Name',
      filterChips: ['Province', 'City', 'District'],
      isFunctional: false,
    );
  }

  final String searchText;
  final AdministrativeAreaLevel selectedLevel;
  final String sortOption;
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
