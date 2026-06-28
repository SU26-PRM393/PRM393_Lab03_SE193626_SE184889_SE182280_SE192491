import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:vietnam_map_flutter/utils/map_constants.dart';
import 'package:vietnam_map_flutter/models/island_label_override.dart';

class IslandLabelOverlay extends StatelessWidget {
  const IslandLabelOverlay({
    required this.labels,
    required this.zoom,
    super.key,
  });

  final List<IslandLabelOverride> labels;
  final double zoom;

  @override
  Widget build(BuildContext context) {
    final visibleLabels = [
      for (final label in labels)
        if (label.isVisibleAtZoom(zoom)) label,
    ];

    if (visibleLabels.isEmpty) {
      return const SizedBox.shrink();
    }

    return IgnorePointer(
      child: MarkerLayer(
        markers: [
          for (final label in visibleLabels) _markerFor(context, label),
        ],
      ),
    );
  }

  Marker _markerFor(BuildContext context, IslandLabelOverride label) {
    return Marker(
      point: label.anchor,
      width: MapConstants.provinceLabelWidth,
      height: MapConstants.provinceLabelHeight,
      alignment: Alignment.center,
      child: Semantics(
        label: label.displayLabel,
        child: _IslandLabel(label: label),
      ),
    );
  }
}

class _IslandLabel extends StatelessWidget {
  const _IslandLabel({required this.label});

  final IslandLabelOverride label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Text(
        label.displayLabel,
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
