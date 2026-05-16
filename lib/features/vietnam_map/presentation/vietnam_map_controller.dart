import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';
import '../data/location_repository.dart';
import '../data/map_tile_source.dart';
import '../domain/administrative_area.dart';
import '../domain/current_location_state.dart';
import '../domain/map_tile_source.dart';
import '../domain/map_view_state.dart';

class VietnamMapController extends ChangeNotifier {
  VietnamMapController({
    LocationRepository locationRepository =
        const GeolocatorLocationRepository(),
  }) : _locationRepository = locationRepository;

  final LocationRepository _locationRepository;
  final MapController mapController = MapController();

  MapViewport _viewport = MapViewport.initial();
  CurrentLocationState _locationState = CurrentLocationState.unknown();
  AdministrativeAreaControlSpace _controlSpace =
      AdministrativeAreaControlSpace.inactive();
  final MapTileSource _tileSource = MapTileSources.openStreetMap;
  DateTime? _lastTileFailureNoticeAt;

  MapViewport get viewport => _viewport;
  CurrentLocationState get locationState => _locationState;
  AdministrativeAreaControlSpace get controlSpace => _controlSpace;
  MapTileSource get tileSource => _tileSource;

  bool get hasLocationMessage {
    return _locationState.status != CurrentLocationStatus.unknown &&
        _locationState.hasMessage;
  }

  void markMapReady() {
    if (_viewport.status == MapViewportStatus.initial) {
      _viewport = _viewport.markReady();
      notifyListeners();
    }
  }

  void updateViewport(MapCamera camera, bool hasGesture) {
    final previousStatus = _viewport.status;
    _viewport = _viewport.trackInteraction(
      center: camera.center,
      zoom: camera.zoom,
      hasGesture: hasGesture,
      occurredAt: DateTime.now(),
    );

    if (!hasGesture && previousStatus == MapViewportStatus.interacting) {
      notifyListeners();
    }
  }

  void zoomIn() {
    final viewport = _currentViewport();
    _moveTo(viewport.center, viewport.zoom + MapConstants.zoomStep);
  }

  void zoomOut() {
    final viewport = _currentViewport();
    _moveTo(viewport.center, viewport.zoom - MapConstants.zoomStep);
  }

  void recenterOnVietnam() {
    _moveTo(MapConstants.vietnamCenter, MapConstants.initialZoom);
  }

  Future<void> requestCurrentLocation() async {
    if (_locationState.isRequesting) {
      return;
    }

    _locationState = const CurrentLocationState(
      status: CurrentLocationStatus.requesting,
      message: 'Requesting current location...',
    );
    notifyListeners();

    final nextState = await _locationRepository.currentLocation();
    _locationState = nextState;

    final coordinate = nextState.coordinate;
    if (coordinate != null) {
      final viewport = _currentViewport();
      _moveTo(coordinate, viewport.zoom < 9 ? 9 : viewport.zoom);
      return;
    }

    notifyListeners();
  }

  void markMapSourceUnavailable(Object error) {
    final now = DateTime.now();
    final lastNotice = _lastTileFailureNoticeAt;
    if (lastNotice != null &&
        now.difference(lastNotice) < MapConstants.tileFailureNoticeThrottle) {
      return;
    }

    _lastTileFailureNoticeAt = now;
    _viewport = _viewport.markSourceUnavailable(
      'Map tiles are temporarily unavailable.',
    );
    notifyListeners();
  }

  void acknowledgeInactiveControl() {
    _controlSpace = AdministrativeAreaControlSpace.inactive();
    notifyListeners();
  }

  void _moveTo(LatLng center, double zoom) {
    final viewport = _currentViewport();
    final nextZoom = zoom.clamp(viewport.minZoom, viewport.maxZoom).toDouble();
    mapController.move(center, nextZoom);
    _viewport = viewport.copyWith(
      center: center,
      zoom: nextZoom,
      status: MapViewportStatus.ready,
      lastInteractionAt: DateTime.now(),
      clearMessage: true,
    );
    notifyListeners();
  }

  MapViewport _currentViewport() {
    try {
      final camera = mapController.camera;
      return _viewport.copyWith(
        center: camera.center,
        zoom: camera.zoom,
      );
    } catch (_) {
      return _viewport;
    }
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
