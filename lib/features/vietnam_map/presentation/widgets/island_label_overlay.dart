import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import '../../domain/island_label_override.dart';

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
      width: 190,
      height: 66,
      alignment: Alignment.bottomCenter,
      child: Semantics(
        label: label.displayLabel,
        child: Align(
          alignment: Alignment.topCenter,
          child: _IslandLabel(label: label),
        ),
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
    final textStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surface.withAlpha(
          label.coverLegacyLabel ? 242 : 210,
        ),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withAlpha(45),
            blurRadius: 5,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label.displayLabel,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
    );
  }
}
