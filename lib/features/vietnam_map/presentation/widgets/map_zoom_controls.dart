import 'package:flutter/material.dart';

class MapZoomControls extends StatelessWidget {
  const MapZoomControls({
    required this.onZoomIn,
    required this.onZoomOut,
    super.key,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surface,
      elevation: 2,
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Semantics(
            button: true,
            label: 'Zoom in',
            child: IconButton(
              tooltip: 'Zoom in',
              icon: const Icon(Icons.add),
              onPressed: onZoomIn,
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Semantics(
            button: true,
            label: 'Zoom out',
            child: IconButton(
              tooltip: 'Zoom out',
              icon: const Icon(Icons.remove),
              onPressed: onZoomOut,
            ),
          ),
        ],
      ),
    );
  }
}
