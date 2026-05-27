import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:flutter_map/flutter_map.dart';
import 'package:isar/isar.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';
import '../../../shared/performance/map_startup_trace.dart';
import '../data/admin_boundary_source.dart';
import '../data/location_repository.dart';
import '../data/map_tile_source.dart';
import '../database/import_service.dart';
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

enum MapLoadStatus {
  idle,
  loading,
  ready,
  unavailable,
}

enum AdministrativeImportStatus {
  idle,
  checking,
  importingProvinces,
  importingCommunes,
  importingCommittees,
  ready,
  skipped,
  unavailable,
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
  final Set<String> _activeFilterChips = {
    'Province',
    'City',
    'District',
  };
  VietnamBoundaryData _boundaryData = VietnamBoundaryData.initial();
  Map<String, AdministrativeAreaMetric> _provinceMetricsByCode = {};
  Map<String, AdministrativeAreaMetric> _lowerLevelMetricsByCode = {};
  final ValueNotifier<ProvinceHoverState> provinceHoverNotifier =
      ValueNotifier<ProvinceHoverState>(ProvinceHoverState.inactive());
  ProvinceBoundary? _selectedProvince;
  Province? _selectedProvinceDetails;
  LowerLevelPlace? _selectedLowerLevelPlace;
  Commune? _selectedCommuneDetails;
  bool _isLoadingDetails = false;
  CommuneVisibilityMode _communeVisibilityMode = CommuneVisibilityMode.details;
  final MapTileSource _tileSource = MapTileSources.defaultBasemap;
  DateTime? _lastTileFailureNoticeAt;
  bool _isLoadingBoundaryData = false;
  bool _isLoadingLowerLevelPlaces = false;
  bool _isBootstrappingDatabase = false;
  bool _databaseReady = false;
  bool _mapReady = false;
  bool _isDisposed = false;
  MapLoadStatus _boundaryStatus = MapLoadStatus.idle;
  MapLoadStatus _metricsStatus = MapLoadStatus.idle;
  MapLoadStatus _lowerLevelPlacesStatus = MapLoadStatus.idle;
  AdministrativeImportStatus _importStatus = AdministrativeImportStatus.idle;
  List<AdministrativeAreaSearchResult>? _filteredAdministrativeEntriesCache;
  LatLng? _pendingHoverCoordinate;
  bool _hoverFrameScheduled = false;
  Timer? _cameraAnimationTimer;
  Timer? _deferredLowerLevelLoadTimer;

  MapViewport get viewport => _viewport;
  CurrentLocationState get locationState => _locationState;
  AdministrativeAreaControlSpace get controlSpace => _controlSpace;
  MapTileSource get tileSource => _tileSource;
  VietNamMapScope get mapScope => _boundaryData.scope;
  List<ProvinceBoundary> get provinceBoundaries =>
      _boundaryData.provinceBoundaries;
  List<IslandLabelOverride> get islandLabelOverrides =>
      _boundaryData.islandLabels;
  ProvinceHoverState get provinceHoverState => provinceHoverNotifier.value;
  ProvinceBoundary? get selectedProvince => _selectedProvince;
  Province? get selectedProvinceDetails => _selectedProvinceDetails;
  LowerLevelPlace? get selectedLowerLevelPlace => _selectedLowerLevelPlace;
  Commune? get selectedCommuneDetails => _selectedCommuneDetails;
  bool get isLoadingDetails => _isLoadingDetails;
  CommuneVisibilityMode get communeVisibilityMode => _communeVisibilityMode;
  bool get databaseReady => _databaseReady;
  bool get mapReady => _mapReady;
  MapLoadStatus get boundaryStatus => _boundaryStatus;
  MapLoadStatus get metricsStatus => _metricsStatus;
  MapLoadStatus get lowerLevelPlacesStatus => _lowerLevelPlacesStatus;
  AdministrativeImportStatus get importStatus => _importStatus;

  bool get isBoundaryDataReady =>
      _boundaryData.status == VietnamBoundaryDataStatus.ready;

  List<AdministrativeAreaSearchResult> get filteredAdministrativeEntries {
    if (!isBoundaryDataReady) {
      return const [];
    }
    final cachedResults = _filteredAdministrativeEntriesCache;
    if (cachedResults != null) {
      return cachedResults;
    }

    final results = MapStartupTrace.timeSync(
      'search.filterAndSort',
      () => AdministrativeAreaSearchEngine.filterAndSort(
        provinces: _boundaryData.provinceBoundaries,
        lowerLevelPlaces: _boundaryData.lowerLevelPlaces,
        searchText: _controlSpace.searchText,
        selectedLevel: _controlSpace.selectedLevel,
        selectedFilters: _selectedFilters,
        sortOption: _controlSpace.sortOption,
        sortDirection: _controlSpace.sortDirection,
        provinceMetricsByCode: _provinceMetricsByCode,
        lowerLevelMetricsByCode: _lowerLevelMetricsByCode,
      ),
      arguments: {
        'provinceCount': _boundaryData.provinceBoundaries.length,
        'lowerLevelCount': _boundaryData.lowerLevelPlaces.length,
      },
    );
    _filteredAdministrativeEntriesCache = results;
    return results;
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

  void _invalidateAdministrativeEntries() {
    _filteredAdministrativeEntriesCache = null;
  }

  void _setProvinceHoverState(ProvinceHoverState nextState) {
    if (_isDisposed) {
      return;
    }

    if (provinceHoverNotifier.value.isSameVisibleState(nextState)) {
      return;
    }

    provinceHoverNotifier.value = nextState;
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

  @visibleForTesting
  bool get hasCachedAdministrativeEntries =>
      _filteredAdministrativeEntriesCache != null;

  @visibleForTesting
  void setBoundaryDataForTesting(VietnamBoundaryData data) {
    _boundaryData = data;
    _boundaryStatus = data.status == VietnamBoundaryDataStatus.ready
        ? MapLoadStatus.ready
        : MapLoadStatus.unavailable;
    _invalidateAdministrativeEntries();
  }

  void bootstrapAfterFirstFrame() {
    MapStartupTrace.instant('app.firstFrame');
    loadBoundaryData();
    bootstrapAdministrativeData();
    requestCurrentLocation();
  }

  Future<void> bootstrapAdministrativeData() async {
    if (_databaseReady || _isBootstrappingDatabase) {
      return;
    }

    _isBootstrappingDatabase = true;
    _importStatus = AdministrativeImportStatus.checking;
    notifyListeners();

    try {
      await IsarService.init();
      _databaseReady = true;
      await ImportService.importDataIfNeeded(
        onProgress: (phase) {
          if (_isDisposed) {
            return;
          }
          _importStatus = _importStatusForPhase(phase);
          notifyListeners();
        },
      );
      if (_isDisposed) {
        return;
      }
      if (_importStatus != AdministrativeImportStatus.skipped) {
        _importStatus = AdministrativeImportStatus.ready;
      }
      await _loadAdministrativeMetrics();
      _refreshSelectedDetailsAfterDatabaseReady();
    } catch (error, stackTrace) {
      debugPrint('Administrative data bootstrap failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _databaseReady = false;
      _importStatus = AdministrativeImportStatus.unavailable;
      _metricsStatus = MapLoadStatus.unavailable;
    } finally {
      _isBootstrappingDatabase = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  AdministrativeImportStatus _importStatusForPhase(
    AdministrativeDataImportPhase phase,
  ) {
    switch (phase) {
      case AdministrativeDataImportPhase.checking:
        return AdministrativeImportStatus.checking;
      case AdministrativeDataImportPhase.provinces:
        return AdministrativeImportStatus.importingProvinces;
      case AdministrativeDataImportPhase.communes:
        return AdministrativeImportStatus.importingCommunes;
      case AdministrativeDataImportPhase.committees:
        return AdministrativeImportStatus.importingCommittees;
      case AdministrativeDataImportPhase.ready:
        return AdministrativeImportStatus.ready;
      case AdministrativeDataImportPhase.skipped:
        return AdministrativeImportStatus.skipped;
    }
  }

  Future<void> loadBoundaryData() async {
    if (_isLoadingBoundaryData ||
        _boundaryData.status == VietnamBoundaryDataStatus.ready) {
      return;
    }

    _isLoadingBoundaryData = true;
    _boundaryStatus = MapLoadStatus.loading;
    notifyListeners();

    final nextData = await MapStartupTrace.timeAsync(
      'boundary.initial.total',
      _adminBoundarySource.loadInitialBoundaryData,
    );
    if (_isDisposed) {
      return;
    }
    _isLoadingBoundaryData = false;
    _boundaryData = nextData;
    _boundaryStatus = nextData.status == VietnamBoundaryDataStatus.ready
        ? MapLoadStatus.ready
        : MapLoadStatus.unavailable;
    _invalidateAdministrativeEntries();

    if (!nextData.hasProvinceBoundaries && nextData.message != null) {
      _setProvinceHoverState(ProvinceHoverState.unavailable(nextData.message!));
    }

    notifyListeners();
    _scheduleDeferredLowerLevelPlacesLoad();
  }

  Future<void> _loadAdministrativeMetrics() async {
    if (!_databaseReady) {
      return;
    }

    _metricsStatus = MapLoadStatus.loading;
    notifyListeners();

    final rows = await MapStartupTrace.timeAsync(
      'metrics.load',
      () => Future.wait<dynamic>([
        IsarService.isar.provinces.where().findAll(),
        IsarService.isar.communes.where().findAll(),
      ]),
    );
    if (_isDisposed) {
      return;
    }
    final provinceRows = rows[0] as List<Province>;
    final communeRows = rows[1] as List<Commune>;

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
    _metricsStatus = MapLoadStatus.ready;
    _invalidateAdministrativeEntries();
  }

  void _refreshSelectedDetailsAfterDatabaseReady() {
    final province = _selectedProvince;
    if (province != null) {
      unawaited(_loadProvinceDetails(province.provinceCode));
    }

    final place = _selectedLowerLevelPlace;
    if (place != null) {
      unawaited(_loadCommuneDetails(place.code));
    }
  }

  void _scheduleDeferredLowerLevelPlacesLoad() {
    if (!_mapReady ||
        _boundaryData.status != VietnamBoundaryDataStatus.ready ||
        _lowerLevelPlacesStatus != MapLoadStatus.idle ||
        _deferredLowerLevelLoadTimer != null) {
      return;
    }

    _deferredLowerLevelLoadTimer = Timer(const Duration(seconds: 2), () {
      _deferredLowerLevelLoadTimer = null;
      unawaited(_ensureLowerLevelPlacesLoaded());
    });
  }

  Future<void> _ensureLowerLevelPlacesLoaded() async {
    if (_lowerLevelPlacesStatus == MapLoadStatus.ready ||
        _isLoadingLowerLevelPlaces ||
        _boundaryData.status != VietnamBoundaryDataStatus.ready) {
      return;
    }

    _isLoadingLowerLevelPlaces = true;
    _lowerLevelPlacesStatus = MapLoadStatus.loading;
    notifyListeners();

    try {
      final places = await MapStartupTrace.timeAsync(
        'boundary.lowerUnits.total',
        _adminBoundarySource.loadLowerLevelPlaces,
      );
      if (_isDisposed) {
        return;
      }
      _boundaryData = _boundaryData.copyWith(lowerLevelPlaces: places);
      _lowerLevelPlacesStatus = MapLoadStatus.ready;
      _invalidateAdministrativeEntries();
    } catch (error, stackTrace) {
      debugPrint('Lower-level boundary data load failed: $error');
      debugPrintStack(stackTrace: stackTrace);
      _lowerLevelPlacesStatus = MapLoadStatus.unavailable;
    } finally {
      _isLoadingLowerLevelPlaces = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  void markMapReady() {
    if (_mapReady) {
      return;
    }

    _mapReady = true;
    MapStartupTrace.instant('map.ready');
    _scheduleDeferredLowerLevelPlacesLoad();

    if (_viewport.status == MapViewportStatus.initial) {
      _viewport = _viewport.markReady();
      notifyListeners();
      return;
    }

    notifyListeners();
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
    if (hasGesture && !provinceHoverState.isInactive) {
      _setProvinceHoverState(ProvinceHoverState.inactive());
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
      message: 'Đang yêu cầu vị trí hiện tại...',
    );
    notifyListeners();

    final nextState = await _locationRepository.currentLocation();
    if (_isDisposed) {
      return;
    }
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
      'Lớp bản đồ tạm thời không khả dụng.',
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
    _invalidateAdministrativeEntries();
    notifyListeners();
  }

  void updateSelectedLevel(AdministrativeAreaLevel level) {
    _controlSpace = _controlSpace.copyWith(
      selectedLevel: level,
      isFunctional: true,
    );
    _invalidateAdministrativeEntries();
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
    _invalidateAdministrativeEntries();
    notifyListeners();
  }

  void updateSortDirection(AdministrativeAreaSortDirection sortDirection) {
    _controlSpace = _controlSpace.copyWith(
      sortDirection: sortDirection,
      isFunctional: true,
    );
    _invalidateAdministrativeEntries();
    notifyListeners();
  }

  void toggleFilterChip(String chip) {
    if (_activeFilterChips.contains(chip)) {
      _activeFilterChips.remove(chip);
    } else {
      _activeFilterChips.add(chip);
    }
    _invalidateAdministrativeEntries();
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
    _pendingHoverCoordinate = coordinate;
    if (_hoverFrameScheduled) {
      return;
    }

    _hoverFrameScheduled = true;
    SchedulerBinding.instance.scheduleFrameCallback((_) {
      if (_isDisposed) {
        return;
      }

      _hoverFrameScheduled = false;
      final pendingCoordinate = _pendingHoverCoordinate;
      _pendingHoverCoordinate = null;
      if (pendingCoordinate != null) {
        _resolveProvinceHover(pendingCoordinate);
      }
    });
  }

  void _resolveProvinceHover(LatLng coordinate) {
    if (_boundaryData.status == VietnamBoundaryDataStatus.initial) {
      return;
    }

    if (!_boundaryData.hasProvinceBoundaries) {
      final message = _boundaryData.message ??
          'Dữ liệu ranh giới tỉnh/thành không khả dụng.';
      _setProvinceHoverState(ProvinceHoverState.unavailable(message));
      return;
    }

    final currentBoundary = provinceHoverState.hoveredBoundary;
    if (currentBoundary != null && currentBoundary.contains(coordinate)) {
      return;
    }

    final nextState = MapStartupTrace.timeSync(
      'hover.resolve',
      () => ProvinceHoverResolver.resolve(
        coordinate: coordinate,
        boundaries: _boundaryData.provinceBoundaries,
        occurredAt: DateTime.now(),
      ),
      arguments: {'boundaryCount': _boundaryData.provinceBoundaries.length},
    );

    _setProvinceHoverState(nextState);
  }

  void selectProvinceAt(LatLng coordinate) {
    if (!_boundaryData.hasProvinceBoundaries) {
      return;
    }

    final nextState = MapStartupTrace.timeSync(
      'province.select.resolve',
      () => ProvinceHoverResolver.resolve(
        coordinate: coordinate,
        boundaries: _boundaryData.provinceBoundaries,
        occurredAt: DateTime.now(),
      ),
      arguments: {'boundaryCount': _boundaryData.provinceBoundaries.length},
    );

    final boundary = nextState.hoveredBoundary;
    if (boundary == null) {
      if (_selectedProvince != null || _selectedLowerLevelPlace != null) {
        _selectedProvince = null;
        _selectedProvinceDetails = null;
        _selectedLowerLevelPlace = null;
        _selectedCommuneDetails = null;
        _setProvinceHoverState(ProvinceHoverState.inactive());
        notifyListeners();
      }
      return;
    }

    final isNewProvince = _selectedProvince?.id != boundary.id;
    final shouldNotify = isNewProvince ||
        !provinceHoverState.isSameVisibleState(nextState) ||
        _selectedLowerLevelPlace != null;

    _selectedProvince = boundary;
    _setProvinceHoverState(nextState);

    if (isNewProvince || _selectedLowerLevelPlace != null) {
      _selectedLowerLevelPlace = null;
      _selectedCommuneDetails = null;
      _communeVisibilityMode = CommuneVisibilityMode.details;
      unawaited(_ensureLowerLevelPlacesLoaded());
      unawaited(_loadProvinceDetails(boundary.provinceCode));
    }

    _animateViewportToProvince(boundary);

    if (shouldNotify) {
      notifyListeners();
    }
  }

  Future<void> _loadProvinceDetails(String provinceCode) async {
    if (!_databaseReady) {
      _isLoadingDetails = _isBootstrappingDatabase;
      notifyListeners();
      return;
    }

    _isLoadingDetails = true;
    notifyListeners();

    try {
      final details = await MapStartupTrace.timeAsync(
        'details.province.load',
        () => IsarService.isar.provinces
            .filter()
            .maEqualTo(provinceCode)
            .findFirst(),
      );
      if (_isDisposed) {
        return;
      }
      _selectedProvinceDetails = details;
    } catch (e) {
      debugPrint('Error loading province details: $e');
    } finally {
      _isLoadingDetails = false;
      if (!_isDisposed) {
        notifyListeners();
      }
    }
  }

  void selectLowerLevelPlace(LowerLevelPlace place) {
    _selectedLowerLevelPlace = place;
    _selectedCommuneDetails = null;
    _isLoadingDetails = _databaseReady || _isBootstrappingDatabase;
    notifyListeners();

    _animateCameraTo(
      center: place.coordinate,
      zoom: 12.0,
    );

    unawaited(_loadCommuneDetails(place.code));
  }

  Future<void> _loadCommuneDetails(String communeCode) async {
    if (!_databaseReady) {
      _isLoadingDetails = _isBootstrappingDatabase;
      notifyListeners();
      return;
    }

    try {
      final details = await MapStartupTrace.timeAsync(
        'details.commune.load',
        () => IsarService.isar.communes
            .filter()
            .maEqualTo(communeCode)
            .findFirst(),
      );
      if (_isDisposed) {
        return;
      }
      _selectedCommuneDetails = details;
    } catch (e) {
      debugPrint('Error loading commune details: $e');
    } finally {
      _isLoadingDetails = false;
      if (!_isDisposed) {
        notifyListeners();
      }
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
    if (provinceHoverState.isInactive) {
      return;
    }

    _setProvinceHoverState(ProvinceHoverState.inactive());
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
    _isDisposed = true;
    _cancelCameraAnimation();
    _deferredLowerLevelLoadTimer?.cancel();
    provinceHoverNotifier.dispose();
    mapController.dispose();
    super.dispose();
  }
}
