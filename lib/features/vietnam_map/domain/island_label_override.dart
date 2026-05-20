import 'package:latlong2/latlong.dart';

class IslandLabelOverride {
  const IslandLabelOverride({
    required this.id,
    required this.legacyLabel,
    required this.displayLabel,
    required this.anchor,
    required this.minZoom,
    required this.maxZoom,
    required this.coverLegacyLabel,
  });

  final String id;
  final String legacyLabel;
  final String displayLabel;
  final LatLng anchor;
  final double minZoom;
  final double maxZoom;
  final bool coverLegacyLabel;

  bool isVisibleAtZoom(double zoom) {
    return zoom >= minZoom && zoom <= maxZoom;
  }

  static const defaults = <IslandLabelOverride>[
    IslandLabelOverride(
      id: 'hoang-sa',
      legacyLabel: 'Paracel Islands',
      displayLabel: 'Quan dao Hoang Sa',
      anchor: LatLng(16.5, 112),
      minZoom: 4,
      maxZoom: 12,
      coverLegacyLabel: true,
    ),
    IslandLabelOverride(
      id: 'truong-sa',
      legacyLabel: 'Spratly Islands',
      displayLabel: 'Quan \u0111ao Tr\u01b0\u1eddng Sa',
      anchor: LatLng(10.5, 114.3),
      minZoom: 4,
      maxZoom: 12,
      coverLegacyLabel: true,
    ),
  ];
}
