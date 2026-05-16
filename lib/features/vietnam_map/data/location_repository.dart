import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../domain/current_location_state.dart';

abstract class LocationRepository {
  Future<CurrentLocationState> currentLocation();
}

class GeolocatorLocationRepository implements LocationRepository {
  const GeolocatorLocationRepository();

  @override
  Future<CurrentLocationState> currentLocation() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.unavailable,
          message: 'Location services are unavailable on this desktop.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.denied,
          message: 'Location permission was denied.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        return const CurrentLocationState(
          status: CurrentLocationStatus.denied,
          message: 'Location permission is permanently denied.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 8),
        ),
      );

      return CurrentLocationState(
        status: CurrentLocationStatus.available,
        coordinate: LatLng(position.latitude, position.longitude),
        accuracyMeters: position.accuracy,
        message: 'Current location found.',
        lastUpdatedAt: DateTime.now(),
      );
    } on TimeoutException {
      return const CurrentLocationState(
        status: CurrentLocationStatus.unavailable,
        message: 'Location request timed out.',
      );
    } catch (_) {
      return const CurrentLocationState(
        status: CurrentLocationStatus.error,
        message: 'Current location could not be loaded.',
      );
    }
  }
}
