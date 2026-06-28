import 'dart:ui';

import 'package:flutter_map/flutter_map.dart' show LatLngBounds;
import 'package:latlong2/latlong.dart';

class MapConstants {
  const MapConstants._();

  static const String appUserAgent = 'vietnam_map_flutter/0.1.0';
  static const String noLabelTileUrl =
      'https://a.basemaps.cartocdn.com/rastertiles/'
      'voyager_nolabels/{z}/{x}/{y}.png';
  static const String noLabelAttribution =
      '(C) OpenStreetMap contributors, (C) CARTO';
  static const String ndaMapsApiKey = String.fromEnvironment(
    'NDAMAPS_API_KEY',
    defaultValue: 'anonymous-apikey',
  );
  static const String ndaMapsStyleUrl =
      'https://maptiles.ndamaps.vn/styles/day-v1/style.json?apikey={key}';
  static const String ndaMapsAttribution = '(C) NDAMaps, (C) Openmap.vn';
  static const String osmPolicyNote =
      'Public online tiles are for interactive viewing only; no offline '
      'prefetch.';
  static const int tileKeepBuffer = 3;
  static const int tilePanBuffer = 1;
  static const Duration tileFadeInDuration = Duration(milliseconds: 60);
  static const Duration tileFailureNoticeThrottle = Duration(seconds: 2);
  static const Duration mapFeedbackBudget = Duration(milliseconds: 100);
  static const Duration maxVisibleFreezeBudget = Duration(milliseconds: 150);
  static const Duration firstUsableMapBudget = Duration(seconds: 3);
  static const Duration hoverFeedbackBudget = Duration(milliseconds: 100);

  static const LatLng vietnamCenter = LatLng(16.0471, 108.2068);
  static final LatLngBounds vietnamCameraBounds = LatLngBounds(
    const LatLng(4.0, 100.0),
    const LatLng(24.8, 118.8),
  );
  static const double initialZoom = 5.6;
  static const double minZoom = 4;
  static const double maxZoom = 18;
  static const double zoomStep = 1;

  static const String vietnamScopeAsset =
      'assets/boundaries/vietnam_scope.geojson';
  static const String provinceBoundariesAsset =
      'assets/boundaries/province_boundaries.geojson';
  static const String islandLabelOverridesAsset =
      'assets/boundaries/island_label_overrides.json';
  static const String lowerUnitsAsset =
      'assets/boundaries/lower_units.geojson';

  static const Color outsideVietnamMaskColor = Color(0xFFF7F9F9);
  static const Color provinceBoundaryColor = Color(0xFF4F6F7A);
  static const Color provinceHoverOutlineColor = Color(0xFF005E8A);
  static const Color provinceHoverOutlineHaloColor = Color(0xFFFFFFFF);
  static const Color lowerLevelMarkerColor = Color(0xFF006B5F);
  static const double provinceBoundaryWidth = 1.1;
  static const double provinceHoverOutlineWidth = 2.4;
  static const double provinceHoverOutlineHaloWidth = 4.8;
  static const double boundarySimplificationTolerance = 0.4;
  static const double interactionOutlineSimplificationTolerance = 0;
  static const double provinceLabelMinZoom = 4;
  static const double provinceLabelWidth = 118;
  static const double provinceLabelHeight = 34;
  static const double provinceFitPadding = 52;
  static const double provinceFitMaxZoom = 9.5;
  static const Duration provinceFitAnimationDuration =
      Duration(milliseconds: 420);
  static const double lowerLevelLabelMinZoom = 10.25;
  static const double lowerLevelDotSize = 7;
  static const double lowerLevelLabelWidth = 88;
  static const double lowerLevelLabelHeight = 20;
  static const Color islandFeatureColor = Color(0xFF005E8A);
  static const Color islandFeatureFillColor = Color(0xFFFFFFFF);
  static const double islandFeatureRadius = 4.2;
  static const double islandFeatureBorderWidth = 1.4;
}
