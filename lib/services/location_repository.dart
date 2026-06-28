import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:vietnam_map_flutter/models/current_location_state.dart';

abstract class LocationRepository {
  Future<CurrentLocationState> currentLocation();
}

class GeolocatorLocationRepository implements LocationRepository {
  const GeolocatorLocationRepository();

  @override
  Future<CurrentLocationState> currentLocation() async {
    final isWindows = defaultTargetPlatform == TargetPlatform.windows;
    if (isWindows) {
      return CurrentLocationState(
        status: CurrentLocationStatus.available,
        coordinate: const LatLng(21.0285, 105.8542), // Hanoi center fallback
        accuracyMeters: 100.0,
        message: 'Đã giả lập vị trí trên Windows.',
        lastUpdatedAt: DateTime.now(),
      );
    }

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.unavailable,
          message: 'Dịch vụ vị trí không khả dụng trên máy tính này.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.denied,
          message: 'Quyền truy cập vị trí đã bị từ chối.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.denied,
          message: 'Quyền truy cập vị trí đã bị từ chối vĩnh viễn.',
        );
      }

      final isWindows = defaultTargetPlatform == TargetPlatform.windows;
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: isWindows ? LocationAccuracy.low : LocationAccuracy.high,
          timeLimit: const Duration(seconds: 15),
        ),
      );

      return CurrentLocationState(
        status: CurrentLocationStatus.available,
        coordinate: LatLng(position.latitude, position.longitude),
        accuracyMeters: position.accuracy,
        message: 'Đã tìm thấy vị trí hiện tại.',
        lastUpdatedAt: DateTime.now(),
      );
    } on TimeoutException {
      return const CurrentLocationState(
        status: CurrentLocationStatus.unavailable,
        message: 'Yêu cầu vị trí đã hết thời gian chờ.',
      );
    } catch (_) {
      return const CurrentLocationState(
        status: CurrentLocationStatus.error,
        message: 'Không thể tải vị trí hiện tại.',
      );
    }
  }
}
