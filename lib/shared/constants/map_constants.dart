import 'package:latlong2/latlong.dart';

class MapConstants {
  const MapConstants._();

  static const String appUserAgent = 'vietnam_map_flutter/0.1.0';
  static const String osmTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  static const String osmAttribution = '© OpenStreetMap contributors';
  static const String osmPolicyNote =
      'Public OSM tiles are for interactive viewing only; no offline prefetch.';
  static const int tileKeepBuffer = 3;
  static const int tilePanBuffer = 1;
  static const Duration tileFadeInDuration = Duration(milliseconds: 60);
  static const Duration tileFailureNoticeThrottle = Duration(seconds: 2);
  static const Duration mapFeedbackBudget = Duration(milliseconds: 100);
  static const Duration maxVisibleFreezeBudget = Duration(milliseconds: 150);
  static const Duration firstUsableMapBudget = Duration(seconds: 3);

  static const LatLng vietnamCenter = LatLng(16.0471, 108.2068);
  static const double initialZoom = 5.6;
  static const double minZoom = 4;
  static const double maxZoom = 18;
  static const double zoomStep = 1;
}
