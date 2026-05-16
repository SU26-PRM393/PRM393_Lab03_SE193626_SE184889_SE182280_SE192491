import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';

enum MapViewportStatus {
  initial,
  ready,
  interacting,
  loadingImagery,
  sourceUnavailable,
}

class MapViewport {
  const MapViewport({
    required this.center,
    required this.zoom,
    required this.minZoom,
    required this.maxZoom,
    required this.status,
    this.lastInteractionAt,
    this.message,
  });

  factory MapViewport.initial() {
    return const MapViewport(
      center: MapConstants.vietnamCenter,
      zoom: MapConstants.initialZoom,
      minZoom: MapConstants.minZoom,
      maxZoom: MapConstants.maxZoom,
      status: MapViewportStatus.initial,
    );
  }

  final LatLng center;
  final double zoom;
  final double minZoom;
  final double maxZoom;
  final MapViewportStatus status;
  final DateTime? lastInteractionAt;
  final String? message;

  bool get isInteracting => status == MapViewportStatus.interacting;
  bool get hasMessage => message != null && message!.isNotEmpty;
  bool get isSourceUnavailable => status == MapViewportStatus.sourceUnavailable;

  MapViewport markReady() {
    return copyWith(status: MapViewportStatus.ready, clearMessage: true);
  }

  MapViewport trackInteraction({
    required LatLng center,
    required double zoom,
    required bool hasGesture,
    required DateTime occurredAt,
  }) {
    return copyWith(
      center: center,
      zoom: zoom,
      status:
          hasGesture ? MapViewportStatus.interacting : MapViewportStatus.ready,
      lastInteractionAt: occurredAt,
      clearMessage: hasGesture,
    );
  }

  MapViewport markSourceUnavailable(String message) {
    return copyWith(
      status: MapViewportStatus.sourceUnavailable,
      message: message,
    );
  }

  MapViewport copyWith({
    LatLng? center,
    double? zoom,
    double? minZoom,
    double? maxZoom,
    MapViewportStatus? status,
    DateTime? lastInteractionAt,
    String? message,
    bool clearMessage = false,
  }) {
    return MapViewport(
      center: center ?? this.center,
      zoom: (zoom ?? this.zoom)
          .clamp(minZoom ?? this.minZoom, maxZoom ?? this.maxZoom),
      minZoom: minZoom ?? this.minZoom,
      maxZoom: maxZoom ?? this.maxZoom,
      status: status ?? this.status,
      lastInteractionAt: lastInteractionAt ?? this.lastInteractionAt,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
