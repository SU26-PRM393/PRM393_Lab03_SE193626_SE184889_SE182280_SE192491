import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../../../shared/constants/map_constants.dart';
import '../../domain/lower_level_place.dart';

class LowerLevelPlaceLayer extends StatelessWidget {
  const LowerLevelPlaceLayer({
    required this.places,
    required this.zoom,
    super.key,
  });

  final List<LowerLevelPlace> places;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    if (places.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: MarkerLayer(
        markers: [
          for (final place in places) _markerFor(place),
        ],
      ),
    );
  }

  Marker _markerFor(LowerLevelPlace place) {
    final showLabel = zoom >= MapConstants.lowerLevelLabelMinZoom;

    return Marker(
      point: place.coordinate,
      width: showLabel
          ? MapConstants.lowerLevelLabelWidth
          : MapConstants.lowerLevelDotSize,
      height: showLabel
          ? MapConstants.lowerLevelLabelHeight
          : MapConstants.lowerLevelDotSize,
      alignment: Alignment.center,
      child: Semantics(
        label: place.name,
        child:
            showLabel ? _LowerLevelLabel(place: place) : const _LowerLevelDot(),
      ),
    );
  }
}

class _LowerLevelDot extends StatelessWidget {
  const _LowerLevelDot();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
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
