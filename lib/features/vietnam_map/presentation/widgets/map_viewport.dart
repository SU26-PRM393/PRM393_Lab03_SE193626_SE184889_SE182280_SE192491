import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/current_location_state.dart';
import '../vietnam_map_controller.dart';
import 'current_location_indicator.dart';

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

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final tileSource = controller.tileSource;
    final urlTemplate = tileSource.urlTemplate;

    return ClipRect(
      child: Stack(
        children: [
          RepaintBoundary(
            child: FlutterMap(
              mapController: controller.mapController,
              options: MapOptions(
                initialCenter: controller.viewport.center,
                initialZoom: controller.viewport.zoom,
                minZoom: controller.viewport.minZoom,
                maxZoom: controller.viewport.maxZoom,
                onMapReady: controller.markMapReady,
                onPositionChanged: controller.updateViewport,
              ),
              children: [
                if (urlTemplate != null)
                  TileLayer(
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
                  ),
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
              ],
            ),
          ),
          if (controller.viewport.isSourceUnavailable)
            Positioned(
              top: 16,
              left: 16,
              child: IgnorePointer(
                child: _StatusBanner(
                  icon: Icons.cloud_off,
                  message: controller.viewport.message ??
                      'Map tiles are unavailable.',
                ),
              ),
            ),
          if (controller.locationState.status ==
              CurrentLocationStatus.requesting)
            Positioned(
              top: controller.viewport.isSourceUnavailable ? 72 : 16,
              left: 16,
              child: const IgnorePointer(
                child: _StatusBanner(
                  icon: Icons.my_location,
                  message: 'Requesting current location...',
                ),
              ),
            ),
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
