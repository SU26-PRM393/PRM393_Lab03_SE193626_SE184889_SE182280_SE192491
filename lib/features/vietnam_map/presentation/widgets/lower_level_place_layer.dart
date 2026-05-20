import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/lower_level_place.dart';
import '../vietnam_map_controller.dart' show CommuneVisibilityMode;

class LowerLevelPlaceLayer extends StatelessWidget {
  const LowerLevelPlaceLayer({
    required this.places,
    required this.zoom,
    this.visibilityMode = CommuneVisibilityMode.details,
    this.selectedPlace,
    this.onPlaceSelected,
    super.key,
  });

  final List<LowerLevelPlace> places;
  final double zoom;
  final CommuneVisibilityMode visibilityMode;
  final LowerLevelPlace? selectedPlace;
  final ValueChanged<LowerLevelPlace>? onPlaceSelected;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty || visibilityMode == CommuneVisibilityMode.hide) {
      return const SizedBox.shrink();
    }

    return MarkerLayer(
      markers: [
        for (final place in places) _markerFor(place),
      ],
    );
  }

  Marker _markerFor(LowerLevelPlace place) {
    final isChosen = selectedPlace?.code == place.code;

    final bool showLabel;
    if (visibilityMode == CommuneVisibilityMode.dots) {
      if (selectedPlace != null) {
        showLabel = isChosen && (zoom >= MapConstants.lowerLevelLabelMinZoom);
      } else {
        showLabel = false;
      }
    } else {
      showLabel = zoom >= MapConstants.lowerLevelLabelMinZoom;
    }

    // Use a larger hit target (24px) for the dots so they are easy to click
    final hitWidth = showLabel
        ? MapConstants.lowerLevelLabelWidth
        : 24.0;
    final hitHeight = showLabel
        ? MapConstants.lowerLevelLabelHeight
        : 24.0;

    return Marker(
      point: place.coordinate,
      width: hitWidth,
      height: hitHeight,
      alignment: Alignment.center,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onPlaceSelected?.call(place),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Semantics(
            label: place.name,
            child: showLabel
                ? _LowerLevelLabel(place: place)
                : const Center(child: _LowerLevelDot()),
          ),
        ),
      ),
    );
  }
}

class _LowerLevelDot extends StatelessWidget {
  const _LowerLevelDot();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MapConstants.lowerLevelDotSize,
      height: MapConstants.lowerLevelDotSize,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: MapConstants.lowerLevelMarkerColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1.2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _LowerLevelLabel extends StatelessWidget {
  const _LowerLevelLabel({required this.place});

  final LowerLevelPlace place;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(224),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: MapConstants.lowerLevelMarkerColor),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          place.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
        ),
      ),
    );
  }
}
