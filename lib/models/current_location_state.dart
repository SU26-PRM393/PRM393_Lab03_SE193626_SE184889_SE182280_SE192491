import 'package:latlong2/latlong.dart';

enum CurrentLocationStatus {
  unknown,
  requesting,
  available,
  denied,
  unavailable,
  error,
}

class CurrentLocationState {
  const CurrentLocationState({
    required this.status,
    this.coordinate,
    this.accuracyMeters,
    this.message,
    this.lastUpdatedAt,
  });

  factory CurrentLocationState.unknown() {
    return const CurrentLocationState(
      status: CurrentLocationStatus.unknown,
      message: 'Chưa yêu cầu vị trí hiện tại.',
    );
  }

  final CurrentLocationStatus status;
  final LatLng? coordinate;
  final double? accuracyMeters;
  final String? message;
  final DateTime? lastUpdatedAt;

  bool get isAvailable =>
      status == CurrentLocationStatus.available && coordinate != null;
  bool get isRequesting => status == CurrentLocationStatus.requesting;
  bool get hasMessage => message != null && message!.isNotEmpty;

  CurrentLocationState copyWith({
    CurrentLocationStatus? status,
    LatLng? coordinate,
    double? accuracyMeters,
    String? message,
    DateTime? lastUpdatedAt,
  }) {
    return CurrentLocationState(
      status: status ?? this.status,
      coordinate: coordinate ?? this.coordinate,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      message: message ?? this.message,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}
