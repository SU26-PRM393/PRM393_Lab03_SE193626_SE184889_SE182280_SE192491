import 'package:latlong2/latlong.dart';

import 'map_boundary.dart';

enum ProvinceHoverStatus {
  inactive,
  active,
  ambiguous,
  unavailable,
}

class ProvinceHoverState {
  const ProvinceHoverState({
    required this.status,
    this.pointerCoordinate,
    this.hoveredProvinceId,
    this.hoveredBoundary,
    this.lastUpdatedAt,
    this.message,
  });

  factory ProvinceHoverState.inactive() {
    return const ProvinceHoverState(status: ProvinceHoverStatus.inactive);
  }

  factory ProvinceHoverState.active({
    required LatLng pointerCoordinate,
    required ProvinceBoundary boundary,
    required DateTime occurredAt,
  }) {
    return ProvinceHoverState(
      status: ProvinceHoverStatus.active,
      pointerCoordinate: pointerCoordinate,
      hoveredProvinceId: boundary.id,
      hoveredBoundary: boundary,
      lastUpdatedAt: occurredAt,
    );
  }

  factory ProvinceHoverState.unavailable(String message) {
    return ProvinceHoverState(
      status: ProvinceHoverStatus.unavailable,
      message: message,
      lastUpdatedAt: DateTime.now(),
    );
  }

  final ProvinceHoverStatus status;
  final LatLng? pointerCoordinate;
  final String? hoveredProvinceId;
  final ProvinceBoundary? hoveredBoundary;
  final DateTime? lastUpdatedAt;
  final String? message;

  bool get isActive =>
      status == ProvinceHoverStatus.active && hoveredBoundary != null;
  bool get isInactive => status == ProvinceHoverStatus.inactive;

  bool isSameVisibleState(ProvinceHoverState other) {
    return status == other.status &&
        hoveredProvinceId == other.hoveredProvinceId &&
        message == other.message;
  }
}

class ProvinceHoverResolver {
  const ProvinceHoverResolver._();

  static ProvinceHoverState resolve({
    required LatLng coordinate,
    required List<ProvinceBoundary> boundaries,
    required DateTime occurredAt,
  }) {
    if (boundaries.isEmpty) {
      return ProvinceHoverState.unavailable(
        'Province boundary data is unavailable.',
      );
    }

    // Check if the coordinate is near Hoàng Sa
    // Hoàng Sa bounds: lat [15.5, 17.5], lon [110.5, 113.5]
    if (coordinate.latitude >= 15.5 &&
        coordinate.latitude <= 17.5 &&
        coordinate.longitude >= 110.5 &&
        coordinate.longitude <= 113.5) {
      final boundary = _findBoundaryByCode(boundaries, '48');
      if (boundary != null) {
        return ProvinceHoverState.active(
          pointerCoordinate: coordinate,
          boundary: boundary,
          occurredAt: occurredAt,
        );
      }
    }

    // Check if the coordinate is near Trường Sa
    // Trường Sa bounds: lat [7.0, 12.0], lon [111.0, 117.5]
    if (coordinate.latitude >= 7.0 &&
        coordinate.latitude <= 12.0 &&
        coordinate.longitude >= 111.0 &&
        coordinate.longitude <= 117.5) {
      final boundary = _findBoundaryByCode(boundaries, '56');
      if (boundary != null) {
        return ProvinceHoverState.active(
          pointerCoordinate: coordinate,
          boundary: boundary,
          occurredAt: occurredAt,
        );
      }
    }

    for (final boundary in boundaries) {
      if (!isCoordinateInBounds(boundary.bounds, coordinate)) {
        continue;
      }

      if (boundary.contains(coordinate)) {
        return ProvinceHoverState.active(
          pointerCoordinate: coordinate,
          boundary: boundary,
          occurredAt: occurredAt,
        );
      }
    }

    return ProvinceHoverState.inactive();
  }

  static ProvinceBoundary? _findBoundaryByCode(
    List<ProvinceBoundary> boundaries,
    String code,
  ) {
    for (final boundary in boundaries) {
      if (boundary.provinceCode == code) {
        return boundary;
      }
    }
    return null;
  }
}
