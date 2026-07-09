import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/utils/platform_utils.dart';
import 'package:vietnam_map_flutter/utils/responsive_breakpoints.dart';

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
    // Ensure minimum 48px touch targets on touch devices
    final buttonSize = PlatformUtils.usesTouchInteraction 
        ? ResponsiveBreakpoints.minTouchTarget 
        : 40.0;

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
            label: 'Phóng to',
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: IconButton(
                tooltip: 'Phóng to',
                icon: const Icon(Icons.add),
                onPressed: onZoomIn,
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          Semantics(
            button: true,
            label: 'Thu nhỏ',
            child: SizedBox(
              width: buttonSize,
              height: buttonSize,
              child: IconButton(
                tooltip: 'Thu nhỏ',
                icon: const Icon(Icons.remove),
                onPressed: onZoomOut,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
