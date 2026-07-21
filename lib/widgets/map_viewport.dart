import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart' as vector_tiles;

import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/utils/platform_utils.dart';
import 'package:vietnam_map_flutter/models/current_location_state.dart';
import 'package:vietnam_map_flutter/viewmodels/vietnam_map_controller.dart';
import 'current_location_indicator.dart';
import 'choropleth_layer.dart';
import 'island_feature_overlay.dart';
import 'island_label_overlay.dart';
import 'lower_level_place_layer.dart';
import 'map_scope_overlay.dart';
import 'province_boundary_layer.dart';
import 'province_hover_outline.dart';
import 'province_label_layer.dart';

class MapViewport extends StatefulWidget {
  const MapViewport({
    required this.controller,
    required this.overlay,
    super.key,
  });

  final VietnamMapController controller;
  final Widget overlay;

  @override
  State<MapViewport> createState() => _MapViewportState();
}

class _MapViewportState extends State<MapViewport> {
  late final TileProvider _tileProvider = NetworkTileProvider();

  void _handleLongPress(LatLng point) {
    if (!PlatformUtils.usesTouchInteraction) return;
    
    // Trigger haptic feedback for touch devices
    HapticFeedback.mediumImpact();
    
    // Show preview (same as hover on desktop)
    widget.controller.previewProvinceAt(point);
    
    // Auto-dismiss preview after a short delay
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        widget.controller.clearProvincePreview();
      }
    });
  }

  void _handleMapTap(VietnamMapController controller, LatLng point, bool usesTouch) {
    if (usesTouch) {
      controller.clearProvincePreview();
    }
    controller.selectProvinceAt(point);
  }

  MapOptions _buildMapOptions(VietnamMapController controller, bool usesTouch) {
    return MapOptions(
      initialCenter: controller.viewport.center,
      initialZoom: controller.viewport.zoom,
      minZoom: controller.viewport.minZoom,
      maxZoom: controller.viewport.maxZoom,
      cameraConstraint: CameraConstraint.containCenter(
        bounds: controller.viewport.cameraBounds,
      ),
      onMapReady: controller.markMapReady,
      onPositionChanged: controller.updateViewport,
      onPointerHover: PlatformUtils.supportsHover
          ? (_, point) => controller.updateProvinceHover(point)
          : null,
      onLongPress: usesTouch ? (_, point) => _handleLongPress(point) : null,
      onTap: (_, point) => _handleMapTap(controller, point, usesTouch),
    );
  }

  Widget _buildBaseLayer(VietnamMapController controller) {
    final tileSource = controller.tileSource;
    final urlTemplate = tileSource.urlTemplate;
    if (urlTemplate == null) {
      return const SizedBox.shrink();
    }

    if (tileSource.isVector) {
      return _VectorBasemapLayer(
        styleUrl: urlTemplate,
        apiKey: MapConstants.ndaMapsApiKey,
        onError: controller.markMapSourceUnavailable,
      );
    }

    return TileLayer(
      urlTemplate: urlTemplate,
      userAgentPackageName: MapConstants.appUserAgent,
      tileProvider: _tileProvider,
      keepBuffer: MapConstants.tileKeepBuffer,
      panBuffer: MapConstants.tilePanBuffer,
      retinaMode: false,
      tileDisplay: const TileDisplay.fadeIn(
        duration: MapConstants.tileFadeInDuration,
        reloadStartOpacity: 0.35,
      ),
      errorTileCallback: (tile, error, stackTrace) {
        controller.markMapSourceUnavailable(error);
      },
    );
  }

  List<CircleMarker> _buildEventCircles(VietnamMapController controller) {
    return controller.visibleCampaignEvents.map((event) {
      final coord = controller.eventCoordinates[event.id];
      if (coord == null) {
        return null;
      }

      final isSelected = controller.selectedEvent?.id == event.id;
      return CircleMarker(
        point: coord,
        radius: 1000.0,
        useRadiusInMeter: true,
        color: isSelected
            ? Colors.teal.withValues(alpha: 0.12)
            : Colors.blue.withValues(alpha: 0.05),
        borderColor: isSelected
            ? Colors.teal.withValues(alpha: 0.4)
            : Colors.blue.withValues(alpha: 0.18),
        borderStrokeWidth: isSelected ? 2.0 : 1.0,
      );
    }).whereType<CircleMarker>().toList();
  }

  Color _eventColor(String status) {
    switch (status) {
      case 'in-progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Marker? _buildEventMarker(VietnamMapController controller, dynamic event) {
    final coord = controller.eventCoordinates[event.id];
    if (coord == null) {
      return null;
    }

    final color = _eventColor(event.status);
    final isSelected = controller.selectedEvent?.id == event.id;
    final showLabel = controller.eventVisibility == MapEventVisibility.detail;

    return Marker(
      point: coord,
      width: showLabel ? 180 : 32,
      height: showLabel ? 60 : 32,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () => controller.selectEvent(event),
        child: Tooltip(
          message: event.name,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showLabel) ...[
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: color,
                      width: isSelected ? 2.5 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    event.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
              ],
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: isSelected ? 18 : 12,
                height: isSelected ? 18 : 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: isSelected ? 2.0 : 1.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 4,
                      color: Colors.black38,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: isSelected
                    ? const Icon(
                        Icons.location_on,
                        size: 10,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEventLayers(VietnamMapController controller) {
    final visible = controller.visibleCampaignEvents;
    if (controller.eventCoordinates.isEmpty ||
        controller.eventVisibility == MapEventVisibility.hide) {
      return const [];
    }

    return [
      CircleLayer(circles: _buildEventCircles(controller)),
      MarkerLayer(
        markers: visible
            .map((event) => _buildEventMarker(controller, event))
            .whereType<Marker>()
            .toList(),
      ),
    ];
  }

  List<Widget> _buildMapChildren(VietnamMapController controller) {
    return [
      _buildBaseLayer(controller),
      MapScopeOverlay(scope: controller.mapScope),
      ProvinceBoundaryLayer(
        boundaries: controller.provinceBoundaries,
        selectedBoundary: controller.selectedProvince,
      ),
      // Choropleth fills: rendered above boundary lines
      if (controller.choroplethEnabled)
        ChoroplethLayer(
          boundaries: controller.provinceBoundaries,
          densityMap: controller.provinceCampaignDensity,
        ),
      if (controller.showProvinceLabels)
        ProvinceLabelLayer(
          boundaries: controller.provinceBoundaries,
          zoom: controller.viewport.zoom,
        ),
      IslandFeatureOverlay(
        labels: controller.islandLabelOverrides,
        zoom: controller.viewport.zoom,
      ),
      IslandLabelOverlay(
        labels: controller.islandLabelOverrides,
        zoom: controller.viewport.zoom,
      ),
      LowerLevelPlaceLayer(
        places: controller.selectedLowerLevelPlaces,
        zoom: controller.viewport.zoom,
        visibilityMode: controller.communeVisibilityMode,
        selectedPlace: controller.selectedLowerLevelPlace,
        onPlaceSelected: controller.selectLowerLevelPlace,
      ),
      ValueListenableBuilder(
        valueListenable: controller.provinceHoverNotifier,
        builder: (context, state, _) {
          return ProvinceHoverOutline(state: state);
        },
      ),
      ..._buildEventLayers(controller),
      if (controller.locationState.isAvailable)
        MarkerLayer(
          markers: [
            Marker(
              point: controller.locationState.coordinate!,
              width: 56,
              height: 56,
              child: CurrentLocationIndicator(
                state: controller.locationState,
              ),
            ),
          ],
        ),
    ];
  }

  Widget? _buildSourceUnavailableBanner(VietnamMapController controller) {
    if (!controller.viewport.isSourceUnavailable) {
      return null;
    }

    return Positioned(
      top: 16,
      left: 80,
      child: IgnorePointer(
        child: _StatusBanner(
          icon: Icons.cloud_off,
          message: controller.viewport.message ?? 'Lớp bản đồ không khả dụng.',
        ),
      ),
    );
  }

  IconData _locationStatusIcon(VietnamMapController controller) {
    if (controller.locationState.status == CurrentLocationStatus.available) {
      return Icons.location_on;
    }
    if (controller.locationState.status == CurrentLocationStatus.requesting) {
      return Icons.my_location;
    }
    return Icons.location_off;
  }

  Widget? _buildLocationBanner(VietnamMapController controller) {
    if (!controller.hasLocationMessage) {
      return null;
    }

    return Positioned(
      top: controller.viewport.isSourceUnavailable ? 72 : 16,
      left: 80,
      child: IgnorePointer(
        child: _StatusBanner(
          icon: _locationStatusIcon(controller),
          message: controller.locationState.message!,
        ),
      ),
    );
  }

  Widget? _buildBoundaryBanner(VietnamMapController controller) {
    if (!controller.isBoundaryDataUnavailable ||
        controller.boundaryDataMessage == null) {
      return null;
    }

    return Positioned(
      top: controller.viewport.isSourceUnavailable ? 72 : 16,
      left: 80,
      child: IgnorePointer(
        child: _StatusBanner(
          icon: Icons.map_outlined,
          message: controller.boundaryDataMessage!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final tileSource = controller.tileSource;
    final usesTouch = PlatformUtils.usesTouchInteraction;

    return ClipRect(
      child: Stack(
        children: [
          RepaintBoundary(
            child: MouseRegion(
              onExit: (_) => controller.clearProvinceHover(),
              child: FlutterMap(
                mapController: controller.mapController,
                options: _buildMapOptions(controller, usesTouch),
                children: _buildMapChildren(controller),
              ),
            ),
          ),
          if (_buildSourceUnavailableBanner(controller) case final banner?) banner,
          if (_buildLocationBanner(controller) case final banner?) banner,
          if (_buildBoundaryBanner(controller) case final banner?) banner,
          Positioned(
            right: 16,
            top: 16,
            child: RepaintBoundary(child: widget.overlay),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: _Attribution(text: tileSource.attribution),
          ),
        ],
      ),
    );
  }
}

class _VectorBasemapLayer extends StatefulWidget {
  const _VectorBasemapLayer({
    required this.styleUrl,
    required this.apiKey,
    required this.onError,
  });

  final String styleUrl;
  final String apiKey;
  final ValueChanged<Object> onError;

  @override
  State<_VectorBasemapLayer> createState() => _VectorBasemapLayerState();
}

class _VectorBasemapLayerState extends State<_VectorBasemapLayer> {
  late Future<vector_tiles.Style> _style;
  bool _reportedError = false;

  @override
  void initState() {
    super.initState();
    _style = _readStyle();
  }

  @override
  void didUpdateWidget(covariant _VectorBasemapLayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.styleUrl != widget.styleUrl ||
        oldWidget.apiKey != widget.apiKey) {
      _reportedError = false;
      _style = _readStyle();
    }
  }

  Future<vector_tiles.Style> _readStyle() {
    return vector_tiles.StyleReader(
      uri: widget.styleUrl,
      apiKey: widget.apiKey,
    ).read();
  }

  void _reportError(Object error) {
    if (_reportedError) {
      return;
    }

    _reportedError = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onError(error);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<vector_tiles.Style>(
      future: _style,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          _reportError(snapshot.error!);
          return const SizedBox.shrink();
        }

        final style = snapshot.data;
        if (style == null) {
          return const SizedBox.shrink();
        }

        return vector_tiles.VectorTileLayer(
          theme: style.theme,
          sprites: style.sprites,
          tileProviders: style.providers,
          maximumZoom: MapConstants.maxZoom,
        );
      },
    );
  }
}

class _Attribution extends StatelessWidget {
  const _Attribution({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface.withAlpha(235),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({
    required this.icon,
    required this.message,
  });

  final IconData icon;
  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Material(
        color: colorScheme.surface,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: 8),
              Flexible(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }
}
