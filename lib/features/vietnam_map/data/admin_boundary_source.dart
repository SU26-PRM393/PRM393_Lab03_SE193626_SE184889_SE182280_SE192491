import '../domain/administrative_area.dart';

class AdminBoundarySource {
  const AdminBoundarySource();

  Future<List<AdministrativeArea>> loadPlaceholders() async {
    return const <AdministrativeArea>[];
  }

  // Future data path:
  // - Use Geofabrik Vietnam extracts as the source dataset.
  // - Preprocess province/city/district boundaries from GeoJSON or Shapefiles.
  // - Package approved offline basemap tiles as MBTiles or PMTiles.
  // - Do not prefetch public OSM tiles for offline use.
}
