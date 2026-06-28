import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/models/map_tile_source.dart';

class MapTileSources {
  const MapTileSources._();

  static const MapTileSource ndaMapsVector = MapTileSource(
    name: 'NDAMaps Day Vector',
    type: MapTileSourceType.onlineVector,
    urlTemplate: MapConstants.ndaMapsStyleUrl,
    attribution: MapConstants.ndaMapsAttribution,
    cachePolicy: 'Honor provider cache headers. Do not prefetch tiles.',
    supportsOffline: false,
  );

  static const MapTileSource noLabelBasemap = MapTileSource(
    name: 'CARTO Voyager No Labels',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.noLabelTileUrl,
    attribution: MapConstants.noLabelAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );

  static const MapTileSource defaultBasemap = ndaMapsVector;
}
