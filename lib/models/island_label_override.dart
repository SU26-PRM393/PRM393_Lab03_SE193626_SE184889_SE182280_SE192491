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
      displayLabel: 'Quần đảo Hoàng Sa',
      anchor: LatLng(16.371347929067802, 112.07857797346432),
      minZoom: 4,
      maxZoom: 10.25,
      coverLegacyLabel: true,
    ),
    IslandLabelOverride(
      id: 'truong-sa',
      legacyLabel: 'Spratly Islands',
      displayLabel: 'Quần đảo Trường Sa',
      anchor: LatLng(9.288659257720576, 113.97556476731718),
      minZoom: 4,
      maxZoom: 10.25,
      coverLegacyLabel: true,
    ),
  ];
}
