import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/models/map_tile_source.dart';
import 'package:vietnam_map_flutter/models/map_style.dart';

class MapTileSources {
  const MapTileSources._();

  static const MapTileSource ndaMapsVector = MapTileSource(
    id: 'nda_light',
    name: 'NDAMaps Day Vector',
    type: MapTileSourceType.onlineVector,
    urlTemplate: MapConstants.ndaMapsStyleUrl,
    attribution: MapConstants.ndaMapsAttribution,
    cachePolicy: 'Honor provider cache headers. Do not prefetch tiles.',
    supportsOffline: false,
  );

  static const MapTileSource noLabelBasemap = MapTileSource(
    id: 'carto_voyager',
    name: 'CARTO Voyager No Labels',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.noLabelTileUrl,
    attribution: MapConstants.noLabelAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );

  /// Light raster basemap (CARTO Voyager with labels).
  static const MapTileSource light = MapTileSource(
    id: 'carto_light',
    name: 'CARTO Voyager',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.lightTileUrl,
    attribution: MapConstants.noLabelAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );

  /// Dark basemap (CARTO Dark All).
  static const MapTileSource dark = MapTileSource(
    id: 'carto_dark',
    name: 'CARTO Dark',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.darkTileUrl,
    attribution: MapConstants.noLabelAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );

  /// Satellite imagery (Esri World Imagery).
  static const MapTileSource satellite = MapTileSource(
    id: 'esri_satellite',
    name: 'Esri World Imagery',
    type: MapTileSourceType.onlineOsm,
    urlTemplate: MapConstants.satelliteTileUrl,
    attribution: MapConstants.satelliteAttribution,
    cachePolicy: 'Honor server cache headers. Do not force no-cache requests.',
    supportsOffline: false,
  );

  static const MapTileSource defaultBasemap = ndaMapsVector;

  /// Returns the [MapTileSource] corresponding to a [MapStyle].
  static MapTileSource forStyle(MapStyle style) => switch (style) {
        MapStyle.light => light,
        MapStyle.dark => dark,
        MapStyle.satellite => satellite,
      };
}
