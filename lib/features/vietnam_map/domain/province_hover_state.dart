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
}
