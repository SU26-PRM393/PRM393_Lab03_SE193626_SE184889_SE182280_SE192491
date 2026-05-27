import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:flutter_map/flutter_map.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';
import '../data/admin_boundary_source.dart';
import '../data/location_repository.dart';
import '../data/map_tile_source.dart';
import '../database/isar_service.dart';
import '../domain/administrative_area.dart';
import '../domain/current_location_state.dart';
import '../domain/island_label_override.dart';
import '../domain/lower_level_place.dart';
import '../domain/map_boundary.dart';
import '../domain/map_scope.dart';
import '../domain/map_tile_source.dart';
import '../domain/map_view_state.dart';
import '../domain/province_hover_state.dart';
import '../model/province.dart';
import '../model/commune.dart';

enum CommuneVisibilityMode {
  details,
  dots,
  hide,
}

class VietnamMapController extends ChangeNotifier {
  VietnamMapController({
    LocationRepository locationRepository =
        const GeolocatorLocationRepository(),
    AdminBoundarySource adminBoundarySource = const AdminBoundarySource(),
  })  : _locationRepository = locationRepository,
        _adminBoundarySource = adminBoundarySource;

  final LocationRepository _locationRepository;
  final AdminBoundarySource _adminBoundarySource;
  final MapController mapController = MapController();

  MapViewport _viewport = MapViewport.initial();
  CurrentLocationState _locationState = CurrentLocationState.unknown();
  AdministrativeAreaControlSpace _controlSpace =
      AdministrativeAreaControlSpace.active();
  Set<String> _activeFilterChips = {
    'Province',
    'City',
    'District',
  };
  VietnamBoundaryData _boundaryData = VietnamBoundaryData.initial();
  Map<String, AdministrativeAreaMetric> _provinceMetricsByCode = {};
  Map<String, AdministrativeAreaMetric> _lowerLevelMetricsByCode = {};
  ProvinceHoverState _provinceHoverState = ProvinceHoverState.inactive();
  ProvinceBoundary? _selectedProvince;
  Province? _selectedProvinceDetails;
  LowerLevelPlace? _selectedLowerLevelPlace;
  Commune? _selectedCommuneDetails;
  bool _isLoadingDetails = false;
  CommuneVisibilityMode _communeVisibilityMode = CommuneVisibilityMode.details;
  final MapTileSource _tileSource = MapTileSources.defaultBasemap;
  DateTime? _lastTileFailureNoticeAt;
  bool _isLoadingBoundaryData = false;
  Timer? _cameraAnimationTimer;
  // Debounce state for search input: UI shows immediate searchText in
  // control space, but filtering uses the debounced `_effectiveSearchText`.
  Timer? _searchDebounceTimer;
  String _effectiveSearchText = '';

  MapViewport get viewport => _viewport;
  CurrentLocationState get locationState => _locationState;
  AdministrativeAreaControlSpace get controlSpace => _controlSpace;
  MapTileSource get tileSource => _tileSource;
  VietNamMapScope get mapScope => _boundaryData.scope;
  List<ProvinceBoundary> get provinceBoundaries =>
      _boundaryData.provinceBoundaries;
  List<IslandLabelOverride> get islandLabelOverrides =>
      _boundaryData.islandLabels;
  ProvinceHoverState get provinceHoverState => _provinceHoverState;
  ProvinceBoundary? get selectedProvince => _selectedProvince;
  Province? get selectedProvinceDetails => _selectedProvinceDetails;
  LowerLevelPlace? get selectedLowerLevelPlace => _selectedLowerLevelPlace;
  Commune? get selectedCommuneDetails => _selectedCommuneDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  CommuneVisibilityMode get communeVisibilityMode => _communeVisibilityMode;

  bool get isBoundaryDataReady =>
      _boundaryData.status == VietnamBoundaryDataStatus.ready;

  List<AdministrativeAreaSearchResult> get filteredAdministrativeEntries {
    if (!isBoundaryDataReady) {
      return const [];
    }

    return AdministrativeAreaSearchEngine.filterAndSort(
      provinces: _boundaryData.provinceBoundaries,
      lowerLevelPlaces: _boundaryData.lowerLevelPlaces,
      // Use the debounced effective search text for filtering/sorting so
      // that UI updates remain snappy while expensive work is throttled.
      searchText: _effectiveSearchText,
      selectedLevel: _controlSpace.selectedLevel,
      selectedFilters: _selectedFilters,
      sortOption: _controlSpace.sortOption,
      sortDirection: _controlSpace.sortDirection,
      provinceMetricsByCode: _provinceMetricsByCode,
      lowerLevelMetricsByCode: _lowerLevelMetricsByCode,
    );
  }

  bool isFilterChipSelected(String chip) {
    return _activeFilterChips.contains(chip);
  }

  Set<AdministrativeAreaFilter> get _selectedFilters {
    final filters = <AdministrativeAreaFilter>{};

    for (final chip in _activeFilterChips) {
      switch (chip) {
        case 'Province':
          filters.add(AdministrativeAreaFilter.province);
          break;
        case 'City':
          filters.add(AdministrativeAreaFilter.city);
          break;
        case 'District':
          filters.add(AdministrativeAreaFilter.district);
          break;
      }
    }

    return filters;
  }

  void setCommuneVisibilityMode(CommuneVisibilityMode mode) {
    if (_communeVisibilityMode != mode) {
      _communeVisibilityMode = mode;
      notifyListeners();
    }
  }

  List<LowerLevelPlace> get selectedLowerLevelPlaces {
    final province = _selectedProvince;
    if (province == null) {
      return const [];
    }

    return [
      for (final place in _boundaryData.lowerLevelPlaces)
        if (place.parentCode == province.provinceCode) place,
    ];
  }

  bool get isBoundaryDataUnavailable => _boundaryData.isUnavailable;
  String? get boundaryDataMessage => _boundaryData.message;

  bool get hasLocationMessage {
    return _locationState.status != CurrentLocationStatus.unknown &&
        _locationState.hasMessage;
  }

  Future<void> loadBoundaryData() async {
    if (_isLoadingBoundaryData ||
        _boundaryData.status == VietnamBoundaryDataStatus.ready) {
      return;
    }

    _isLoadingBoundaryData = true;
    final nextData = await _adminBoundarySource.loadBoundaryData();
    _isLoadingBoundaryData = false;
    _boundaryData = nextData;

    if (!nextData.hasProvinceBoundaries && nextData.message != null) {
      _provinceHoverState = ProvinceHoverState.unavailable(nextData.message!);
    }

    if (nextData.status == VietnamBoundaryDataStatus.ready) {
      await _loadAdministrativeMetrics();
    }

    notifyListeners();
  }

  Future<void> _loadAdministrativeMetrics() async {
    final provinceRows = await IsarService.isar.provinces.where().findAll();
    final communeRows = await IsarService.isar.communes.where().findAll();

    _provinceMetricsByCode = {
      for (final province in provinceRows)
        if (province.ma.isNotEmpty)
          province.ma: AdministrativeAreaMetric(
            areaKm2: province.areaKm2,
            population: province.population,
            density: province.density,
          ),
    };

    _lowerLevelMetricsByCode = {
      for (final commune in communeRows)
        if (commune.ma.isNotEmpty)
          commune.ma: AdministrativeAreaMetric(
            areaKm2: commune.areaKm2,
            population: commune.population,
            density: commune.density,
          ),
    };
  }

  void markMapReady() {
    if (_viewport.status == MapViewportStatus.initial) {
      _viewport = _viewport.markReady();
      notifyListeners();
    }
  }

  void updateViewport(MapCamera camera, bool hasGesture) {
    final previousStatus = _viewport.status;
    final previousShowsLowerLevelLabels =
        _viewport.zoom >= MapConstants.lowerLevelLabelMinZoom;
    _viewport = _viewport.trackInteraction(
      center: camera.center,
      zoom: camera.zoom,
      hasGesture: hasGesture,
      occurredAt: DateTime.now(),
    );
    final nextShowsLowerLevelLabels =
        _viewport.zoom >= MapConstants.lowerLevelLabelMinZoom;

    var shouldNotify = false;
    if (hasGesture && !_provinceHoverState.isInactive) {
      _provinceHoverState = ProvinceHoverState.inactive();
      shouldNotify = true;
    }

    if (_selectedProvince != null &&
        previousShowsLowerLevelLabels != nextShowsLowerLevelLabels) {
      shouldNotify = true;
    }

    if (!hasGesture && previousStatus == MapViewportStatus.interacting) {
      shouldNotify = true;
    }

    if (shouldNotify) {
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

  void updateSearchText(String searchText) {
    // Immediately reflect the typed value in control space for the UI,
    // but debounce the actual filtering so it uses `_effectiveSearchText`.
    _controlSpace = _controlSpace.copyWith(
      searchText: searchText,
      isFunctional: true,
    );
    // Restart debounce timer (250ms)
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 250), () {
      _effectiveSearchText = searchText;
      notifyListeners();
    });
    // Notify now so UI shows the immediate search text change (e.g., TextField)
    notifyListeners();
  }

  void updateSelectedLevel(AdministrativeAreaLevel level) {
    _controlSpace = _controlSpace.copyWith(
      selectedLevel: level,
      isFunctional: true,
    );
    notifyListeners();
  }

  void updateSortOption(String sortOption) {
    _controlSpace = _controlSpace.copyWith(
      sortOption: sortOption,
      sortDirection: sortOption == 'Name'
          ? AdministrativeAreaSortDirection.ascending
          : AdministrativeAreaSortDirection.descending,
      isFunctional: true,
    );
    notifyListeners();
  }

  void updateSortDirection(AdministrativeAreaSortDirection sortDirection) {
    _controlSpace = _controlSpace.copyWith(
      sortDirection: sortDirection,
      isFunctional: true,
    );
    notifyListeners();
  }

  void toggleFilterChip(String chip) {
    if (_activeFilterChips.contains(chip)) {
      _activeFilterChips.remove(chip);
    } else {
      _activeFilterChips.add(chip);
    }
    notifyListeners();
  }

  void selectAdministrativeEntry(AdministrativeAreaSearchResult result) {
    if (result.provinceBoundary != null) {
      selectProvinceAt(result.coordinate);
      return;
    }

    final place = result.lowerLevelPlace;
    if (place != null) {
      selectLowerLevelPlace(place);
    }
  }

  void updateProvinceHover(LatLng coordinate) {
    if (_boundaryData.status == VietnamBoundaryDataStatus.initial) {
      return;
    }

    if (!_boundaryData.hasProvinceBoundaries) {
      final message =
          _boundaryData.message ?? 'Province boundary data is unavailable.';
      final nextState = ProvinceHoverState.unavailable(message);
      if (!_provinceHoverState.isSameVisibleState(nextState)) {
        _provinceHoverState = nextState;
        notifyListeners();
      }
      return;
    }

    final nextState = ProvinceHoverResolver.resolve(
      coordinate: coordinate,
      boundaries: _boundaryData.provinceBoundaries,
      occurredAt: DateTime.now(),
    );

    if (_provinceHoverState.isSameVisibleState(nextState)) {
      return;
    }

    _provinceHoverState = nextState;
    notifyListeners();
  }

  void selectProvinceAt(LatLng coordinate) {
    if (!_boundaryData.hasProvinceBoundaries) {
      return;
    }

    final nextState = ProvinceHoverResolver.resolve(
      coordinate: coordinate,
      boundaries: _boundaryData.provinceBoundaries,
      occurredAt: DateTime.now(),
    );

    final boundary = nextState.hoveredBoundary;
    if (boundary == null) {
      if (_selectedProvince != null || _selectedLowerLevelPlace != null) {
        _selectedProvince = null;
        _selectedProvinceDetails = null;
        _selectedLowerLevelPlace = null;
        _selectedCommuneDetails = null;
        notifyListeners();
      }
      return;
    }

    final isNewProvince = _selectedProvince?.id != boundary.id;
    final shouldNotify = isNewProvince ||
        !_provinceHoverState.isSameVisibleState(nextState) ||
        _selectedLowerLevelPlace != null;

    _selectedProvince = boundary;
    _provinceHoverState = nextState;

    if (isNewProvince || _selectedLowerLevelPlace != null) {
      _selectedLowerLevelPlace = null;
      _selectedCommuneDetails = null;
      _communeVisibilityMode = CommuneVisibilityMode.details;
      _loadProvinceDetails(boundary.provinceCode);
    }

    _animateViewportToProvince(boundary);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> _loadProvinceDetails(String provinceCode) async {
    _isLoadingDetails = true;
    notifyListeners();

    try {
      final details = await IsarService.isar.provinces
          .filter()
          .maEqualTo(provinceCode)
          .findFirst();
      _selectedProvinceDetails = details;
    } catch (e) {
      debugPrint('Error loading province details: $e');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void selectLowerLevelPlace(LowerLevelPlace place) {
    _selectedLowerLevelPlace = place;
    _selectedCommuneDetails = null;
    _isLoadingDetails = true;
    notifyListeners();

    _animateCameraTo(
      center: place.coordinate,
      zoom: 12.0,
    );

    _loadCommuneDetails(place.code);
  }

  Future<void> _loadCommuneDetails(String communeCode) async {
    try {
      final details = await IsarService.isar.communes
          .filter()
          .maEqualTo(communeCode)
          .findFirst();
      _selectedCommuneDetails = details;
    } catch (e) {
      debugPrint('Error loading commune details: $e');
    } finally {
      _isLoadingDetails = false;
      notifyListeners();
    }
  }

  void clearSelection() {
    _selectedProvince = null;
    _selectedProvinceDetails = null;
    _selectedLowerLevelPlace = null;
    _selectedCommuneDetails = null;
    _communeVisibilityMode = CommuneVisibilityMode.details;
    _isLoadingDetails = false;
    notifyListeners();
  }

  void clearPlaceSelection() {
    _selectedLowerLevelPlace = null;
    _selectedCommuneDetails = null;
    _communeVisibilityMode = CommuneVisibilityMode.details;
    _isLoadingDetails = false;
    notifyListeners();
  }

  void clearProvinceHover() {
    if (_provinceHoverState.isInactive) {
      return;
    }

    _provinceHoverState = ProvinceHoverState.inactive();
    notifyListeners();
  }

  void _moveTo(LatLng center, double zoom) {
    _cancelCameraAnimation();
    final viewport = _currentViewport();
    final nextCenter = viewport.constrainCenter(center);
    final nextZoom = zoom.clamp(viewport.minZoom, viewport.maxZoom).toDouble();
    mapController.move(nextCenter, nextZoom);
    _viewport = viewport.copyWith(
      center: nextCenter,
      zoom: nextZoom,
      status: MapViewportStatus.ready,
      lastInteractionAt: DateTime.now(),
      clearMessage: true,
    );
    notifyListeners();
  }

  void _animateViewportToProvince(ProvinceBoundary boundary) {
    try {
      final currentCamera = mapController.camera;
      final targetCamera = CameraFit.bounds(
        bounds: boundary.bounds,
        padding: const EdgeInsets.all(MapConstants.provinceFitPadding),
        maxZoom: MapConstants.provinceFitMaxZoom,
        minZoom: viewport.minZoom,
      ).fit(currentCamera);

      _animateCameraTo(
        center: targetCamera.center,
        zoom: targetCamera.zoom,
      );
    } catch (_) {
      _moveTo(boundary.labelCoordinate, viewport.zoom);
    }
  }

  void _animateCameraTo({
    required LatLng center,
    required double zoom,
  }) {
    _cancelCameraAnimation();

    final startViewport = _currentViewport();
    final startCenter = startViewport.center;
    final startZoom = startViewport.zoom;
    final startAt = DateTime.now();
    final duration = MapConstants.provinceFitAnimationDuration;

    _cameraAnimationTimer = Timer.periodic(
      const Duration(milliseconds: 16),
      (timer) {
        final elapsed = DateTime.now().difference(startAt);
        final linearProgress = elapsed.inMicroseconds / duration.inMicroseconds;
        final progress = linearProgress.clamp(0, 1).toDouble();
        final easedProgress = _easeInOutCubic(progress);
        final nextCenter = LatLng(
          _lerp(startCenter.latitude, center.latitude, easedProgress),
          _lerp(startCenter.longitude, center.longitude, easedProgress),
        );
        final nextZoom = _lerp(startZoom, zoom, easedProgress);

        mapController.move(nextCenter, nextZoom);

        if (progress >= 1) {
          timer.cancel();
          if (identical(_cameraAnimationTimer, timer)) {
            _cameraAnimationTimer = null;
          }
          _viewport = _currentViewport().copyWith(
            status: MapViewportStatus.ready,
            lastInteractionAt: DateTime.now(),
            clearMessage: true,
          );
          notifyListeners();
        }
      },
    );
  }

  void _cancelCameraAnimation() {
    _cameraAnimationTimer?.cancel();
    _cameraAnimationTimer = null;
  }

  double _easeInOutCubic(double value) {
    if (value < 0.5) {
      return 4 * value * value * value;
    }

    final adjusted = -2 * value + 2;
    return 1 - (adjusted * adjusted * adjusted) / 2;
  }

  double _lerp(double start, double end, double progress) {
    return start + (end - start) * progress;
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
    _cancelCameraAnimation();
    _searchDebounceTimer?.cancel();
    mapController.dispose();
    super.dispose();
  }
}
