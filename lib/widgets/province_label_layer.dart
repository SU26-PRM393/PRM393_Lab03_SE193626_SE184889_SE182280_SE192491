import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/models/map_boundary.dart';

class ProvinceLabelLayer extends StatelessWidget {
  const ProvinceLabelLayer({
    required this.boundaries,
    required this.zoom,
    super.key,
  });

  final List<ProvinceBoundary> boundaries;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    if (boundaries.isEmpty || zoom < MapConstants.provinceLabelMinZoom) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: MarkerLayer(
        markers: [
          for (final boundary in boundaries) _markerFor(boundary),
        ],
      ),
    );
  }

  Marker _markerFor(ProvinceBoundary boundary) {
    return Marker(
      point: boundary.labelCoordinate,
      width: MapConstants.provinceLabelWidth,
      height: MapConstants.provinceLabelHeight,
      alignment: Alignment.center,
      child: Semantics(
        label: boundary.name,
        child: _ProvinceLabel(name: boundary.name),
      ),
    );
  }
}

class _ProvinceLabel extends StatelessWidget {
  const _ProvinceLabel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        name,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
          height: 1.05,
          shadows: const [
            Shadow(
              color: Colors.white,
              blurRadius: 4,
            ),
            Shadow(
              color: Colors.white,
              blurRadius: 8,
            ),
          ],
        ),
      ),
    );
  }
}
