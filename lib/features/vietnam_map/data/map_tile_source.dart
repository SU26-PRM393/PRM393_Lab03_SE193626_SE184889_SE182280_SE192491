import '../../../shared/constants/map_constants.dart';
import '../domain/map_tile_source.dart';

class MapTileSources {
  const MapTileSources._();

  static const MapTileSource openStreetMap = MapTileSource(
    name: 'OpenStreetMap',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.osmTileUrl,
    attribution: MapConstants.osmAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );
}
