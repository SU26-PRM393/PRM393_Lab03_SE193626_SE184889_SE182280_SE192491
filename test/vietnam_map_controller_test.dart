import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/data/location_repository.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/domain/current_location_state.dart';
import 'package:vietnam_map_flutter/features/vietnam_map/presentation/vietnam_map_controller.dart';

class MockLocationRepository implements LocationRepository {
  CurrentLocationState stubState = CurrentLocationState.unknown();
  Completer<CurrentLocationState>? completer;

  @override
  Future<CurrentLocationState> currentLocation() {
    if (completer != null) {
      return completer!.future;
    }
    return Future.value(stubState);
  }
}

void main() {
  group('VietnamMapController Location Tests', () {
    late MockLocationRepository mockLocationRepository;
    late VietnamMapController controller;

    setUp(() {
      mockLocationRepository = MockLocationRepository();
      controller = VietnamMapController(locationRepository: mockLocationRepository);
    });

    tearDown(() {
      controller.dispose();
    });

    testWidgets('requestCurrentLocation state transitions and auto-hide message', (WidgetTester tester) async {
      mockLocationRepository.completer = Completer<CurrentLocationState>();

      // Start requesting
      final future = controller.requestCurrentLocation();
      
      expect(controller.locationState.isRequesting, isTrue);
      expect(controller.locationState.message, 'Đang yêu cầu vị trí hiện tại...');

      // Complete the request
      const successState = CurrentLocationState(
        status: CurrentLocationStatus.available,
        coordinate: LatLng(10.0, 106.0),
        message: 'Đã tìm thấy vị trí hiện tại.',
      );
      mockLocationRepository.completer!.complete(successState);
      await future;

      expect(controller.locationState.status, CurrentLocationStatus.available);
      expect(controller.locationState.coordinate, const LatLng(10.0, 106.0));
      expect(controller.locationState.message, 'Đã tìm thấy vị trí hiện tại.');

      // Wait 4 seconds for auto-hide timer to trigger
      await tester.pump(const Duration(seconds: 4));

      // Message should be empty, but coordinate remains intact
      expect(controller.locationState.message, isEmpty);
      expect(controller.locationState.coordinate, const LatLng(10.0, 106.0));
    });

    testWidgets('does not request location again if already requesting', (WidgetTester tester) async {
      mockLocationRepository.completer = Completer<CurrentLocationState>();

      // First call
      final future1 = controller.requestCurrentLocation();
      expect(controller.locationState.isRequesting, isTrue);

      // Second call should return early without calling repo again
      await controller.requestCurrentLocation();
      
      mockLocationRepository.completer!.complete(const CurrentLocationState(
        status: CurrentLocationStatus.available,
        coordinate: LatLng(10.0, 106.0),
        message: 'Success',
      ));
      await future1;

      expect(controller.locationState.coordinate, const LatLng(10.0, 106.0));

      // Wait 4 seconds for auto-hide timer to trigger
      await tester.pump(const Duration(seconds: 4));
    });
  });
}
