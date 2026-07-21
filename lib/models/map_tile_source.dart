enum MapTileSourceType {
  onlineOsm,
  onlineVector,
  localMbtiles,
  localPmtiles,
  placeholder,
}

class MapTileSource {
  const MapTileSource({
    required this.id,
    required this.name,
    required this.type,
    required this.attribution,
    required this.cachePolicy,
    required this.supportsOffline,
    this.urlTemplate,
  });

  /// Stable identifier used to compare tile sources (e.g., to avoid
  /// unnecessary tile reloads when the same source is reselected).
  final String id;
  final String name;
  final MapTileSourceType type;
  final String? urlTemplate;
  final String attribution;
  final String cachePolicy;
  final bool supportsOffline;

  bool get isOnline =>
      type == MapTileSourceType.onlineOsm ||
      type == MapTileSourceType.onlineVector;
  bool get isVector => type == MapTileSourceType.onlineVector;
}
