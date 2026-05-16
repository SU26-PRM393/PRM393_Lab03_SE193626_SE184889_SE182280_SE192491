enum MapTileSourceType {
  onlineOsm,
  localMbtiles,
  localPmtiles,
  placeholder,
}

class MapTileSource {
  const MapTileSource({
    required this.name,
    required this.type,
    required this.attribution,
    required this.cachePolicy,
    required this.supportsOffline,
    this.urlTemplate,
  });

  final String name;
  final MapTileSourceType type;
  final String? urlTemplate;
  final String attribution;
  final String cachePolicy;
  final bool supportsOffline;

  bool get isOnline => type == MapTileSourceType.onlineOsm;
}
