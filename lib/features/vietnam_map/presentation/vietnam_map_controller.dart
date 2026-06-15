import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart' show EdgeInsets;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../shared/constants/map_constants.dart';
import '../../../shared/performance/map_startup_trace.dart';
import '../data/admin_boundary_source.dart';
import '../data/firestore_repository.dart';
import '../data/location_repository.dart';
import '../data/map_tile_source.dart';
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
import '../../admin/domain/campaign.dart';
import '../../admin/domain/event.dart';
import '../../admin/domain/school.dart';
import '../../admin/data/campaign_repository.dart';

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

  // --- Campaign States ---
  bool _isCampaignPanelExpanded = false;
  List<Campaign> _campaigns = [];
  Campaign? _selectedCampaign;
  List<Event> _selectedCampaignEvents = [];
  Event? _selectedEvent;
  bool _isLoadingCampaigns = false;
  bool _isLoadingEvents = false;
  Map<String, LatLng> _eventCoordinates = {}; 
  Map<String, School> _eventSchools = {};
  Map<String, String> _employeeNames = {};
  Map<String, String> _employeeEmails = {};
  bool _showProvinceLabels = true;
  // -----------------------

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
  bool get showProvinceLabels => _showProvinceLabels;

  // --- Campaign Getters ---
  bool get isCampaignPanelExpanded => _isCampaignPanelExpanded;
  List<Campaign> get campaigns => _campaigns;
  Campaign? get selectedCampaign => _selectedCampaign;
  List<Event> get selectedCampaignEvents => _selectedCampaignEvents;
  Event? get selectedEvent => _selectedEvent;
  bool get isLoadingCampaigns => _isLoadingCampaigns;
  bool get isLoadingEvents => _isLoadingEvents;
  Map<String, LatLng> get eventCoordinates => _eventCoordinates;
  Map<String, School> get eventSchools => _eventSchools;
  Map<String, String> get employeeNames => _employeeNames;
  Map<String, String> get employeeEmails => _employeeEmails;

  void toggleCampaignPanel(bool expanded) {
    if (_isCampaignPanelExpanded == expanded) return;
    _isCampaignPanelExpanded = expanded;
    if (expanded) {
      _loadCampaigns();
    }
    notifyListeners();
  }

  Future<void> _loadCampaigns() async {
    if (_isLoadingCampaigns || _campaigns.isNotEmpty) return;
    _isLoadingCampaigns = true;
    notifyListeners();
    try {
      _campaigns = await CampaignRepository.instance.getAllCampaigns();
    } catch (e) {
      debugPrint('Load campaigns error: $e');
    } finally {
      _isLoadingCampaigns = false;
      notifyListeners();
    }
  }

  Future<void> selectCampaign(Campaign campaign) async {
    _selectedCampaign = campaign;
    _selectedEvent = null;
    _selectedCampaignEvents = [];
    _eventCoordinates = {};
    _eventSchools = {};
    _employeeNames = {};
    _employeeEmails = {};
    _isLoadingEvents = true;
    notifyListeners();

    try {
      final events = await CampaignRepository.instance.getEventsForCampaign(campaign.id);
      _selectedCampaignEvents = events;
      
      // Ensure lowerLevelPlaces are loaded so we can resolve commune coordinates
      if (_lowerLevelPlacesStatus != MapLoadStatus.ready) {
        await _ensureLowerLevelPlacesLoaded();
      }
      
      // Resolve coordinates
      final Map<String, LatLng> resolvedCoords = {};
      
      // Extract all unique school IDs
      final Set<String> schoolIdsToFetch = {};
      for (final event in events) {
        schoolIdsToFetch.addAll(event.schoolIds);
      }
      
      // Fetch schools
      final schools = await CampaignRepository.instance.getSchoolsByIds(schoolIdsToFetch.toList());
      final Map<String, School> schoolMap = {for (var s in schools) s.id: s};
      
      // Map event ID to first available school's commune coordinate
      for (final event in events) {
        if (event.schoolIds.isNotEmpty) {
          final firstSchoolId = event.schoolIds.first;
          final school = schoolMap[firstSchoolId];
          if (school != null) {
            final communeCode = school.communeCode;
            final targetCodeValue = int.tryParse(communeCode);
            // Find coordinate from lowerLevelPlaces
            final place = _boundaryData.lowerLevelPlaces.where((p) {
              return p.code == communeCode || (targetCodeValue != null && int.tryParse(p.code) == targetCodeValue);
            }).firstOrNull;
            if (place != null) {
              resolvedCoords[event.id] = place.coordinate;
            } else {
               // Fallback: If not found, use province center
               final provCode = school.provinceCode;
               final provTargetValue = int.tryParse(provCode);
               final provPlace = _boundaryData.provinceBoundaries.where((p) => p.provinceCode == provCode || (provTargetValue != null && int.tryParse(p.provinceCode) == provTargetValue)).firstOrNull;
               if (provPlace != null && provPlace.polygons.isNotEmpty) {
                   resolvedCoords[event.id] = provPlace.polygons.first.outerRing.bounds.center;
               }
            }
          }
        }
      }
      
      // Fetch employee names & emails
      final Set<String> employeeIdsToFetch = {};
      for (final event in events) {
        employeeIdsToFetch.addAll(event.assignedEmployeeIds);
      }
      final employeeDetails = await CampaignRepository.instance.getUserDetailsByIds(employeeIdsToFetch.toList());
      final Map<String, String> employeeNames = {};
      final Map<String, String> employeeEmails = {};
      for (var entry in employeeDetails.entries) {
        employeeNames[entry.key] = entry.value['name'] ?? 'Unknown';
        employeeEmails[entry.key] = entry.value['email'] ?? '';
      }
      
      _eventCoordinates = resolvedCoords;
      _eventSchools = schoolMap;
      _employeeNames = employeeNames;
      _employeeEmails = employeeEmails;
      
      if (resolvedCoords.isNotEmpty) {
        final bounds = LatLngBounds.fromPoints(resolvedCoords.values.toList());
        final targetCamera = CameraFit.bounds(
          bounds: bounds,
          padding: const EdgeInsets.all(56.0),
          maxZoom: 9.5,
          minZoom: viewport.minZoom,
        ).fit(mapController.camera);
        
        _animateCameraTo(
          center: targetCamera.center,
          zoom: targetCamera.zoom,
        );
      }
    } catch (e) {
      debugPrint('Load events error: $e');
    } finally {
      _isLoadingEvents = false;
      notifyListeners();
    }
  }

  void selectEvent(Event event) {
    _selectedEvent = event;
    notifyListeners();
    
    // Zoom to event coordinate
    final coord = _eventCoordinates[event.id];
    if (coord != null) {
      _animateCameraTo(center: coord, zoom: 12.0);
    }
  }

  void deselectCampaign() {
    _selectedCampaign = null;
    _selectedEvent = null;
    _selectedCampaignEvents = [];
    _eventCoordinates = {};
    _eventSchools = {};
    _employeeNames = {};
    _employeeEmails = {};
    notifyListeners();
  }
  // ------------------------

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
        data: AdministrativeAreaSearchData(
          provinces: _boundaryData.provinceBoundaries,
          lowerLevelPlaces: _boundaryData.lowerLevelPlaces,
          provinceMetricsByCode: _provinceMetricsByCode,
          lowerLevelMetricsByCode: _lowerLevelMetricsByCode,
        ),
        criteria: AdministrativeAreaSearchCriteria(
          searchText: _controlSpace.searchText,
          selectedLevel: _controlSpace.selectedLevel,
          selectedFilters: _selectedFilters,
          sortOption: _controlSpace.sortOption,
          sortDirection: _controlSpace.sortDirection,
        ),
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
      // Firestore không cần init — đọc thẳng từ cloud (có offline cache)
      _databaseReady = true;
      await _loadAdministrativeMetrics();
      if (_isDisposed) return;
      _importStatus = AdministrativeImportStatus.ready;
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
    if (!_databaseReady) return;

    _metricsStatus = MapLoadStatus.loading;
    notifyListeners();

    final results = await MapStartupTrace.timeAsync(
      'metrics.load',
      () => Future.wait([
        FirestoreRepository.instance.getAllProvinces(),
        FirestoreRepository.instance.getAllCommunes(),
      ]),
    );
    if (_isDisposed) return;

    final provinceRows = results[0] as List<Province>;
    final communeRows = results[1] as List<Commune>;

    _provinceMetricsByCode = {
      for (final p in provinceRows)
        if (p.ma.isNotEmpty)
          p.ma: AdministrativeAreaMetric(
            areaKm2: p.areaKm2,
            population: p.population,
            density: p.density,
          ),
    };

    _lowerLevelMetricsByCode = {
      for (final c in communeRows)
        if (c.ma.isNotEmpty)
          c.ma: AdministrativeAreaMetric(
            areaKm2: c.areaKm2,
            population: c.population,
            density: c.density,
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
    } else {
      notifyListeners();
    }

    // Auto-hide the message after 4 seconds
    if (nextState.hasMessage) {
      Future.delayed(const Duration(seconds: 4), () {
        if (!_isDisposed && _locationState.message == nextState.message) {
          _locationState = _locationState.copyWith(message: '');
          notifyListeners();
        }
      });
    }
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
    _isLoadingDetails = true;
    notifyListeners();

    try {
      _selectedProvinceDetails = await MapStartupTrace.timeAsync(
        'details.province.load',
        () => FirestoreRepository.instance.getProvinceByMa(provinceCode),
      );
      if (_isDisposed) return;
    } catch (e) {
      debugPrint('Error loading province details: $e');
    } finally {
      _isLoadingDetails = false;
      if (!_isDisposed) notifyListeners();
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
    try {
      _selectedCommuneDetails = await MapStartupTrace.timeAsync(
        'details.commune.load',
        () => FirestoreRepository.instance.getCommuneByMa(communeCode),
      );
      if (_isDisposed) return;
    } catch (e) {
      debugPrint('Error loading commune details: $e');
    } finally {
      _isLoadingDetails = false;
      if (!_isDisposed) notifyListeners();
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

  void toggleProvinceLabels(bool show) {
    if (_showProvinceLabels == show) return;
    _showProvinceLabels = show;
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
    const duration = MapConstants.provinceFitAnimationDuration;

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
