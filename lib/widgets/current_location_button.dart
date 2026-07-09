import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/utils/responsive_breakpoints.dart';

class CurrentLocationButton extends StatelessWidget {
  const CurrentLocationButton({
    required this.isLoading,
    required this.onPressed,
    this.isMobile = false,
    super.key,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    final iconWidget = isLoading
        ? const SizedBox.square(
            dimension: 18,
            child: CircularProgressIndicator(strokeWidth: 2),
          )
        : const Icon(Icons.my_location);

    return Semantics(
      button: true,
      label:
          isLoading ? 'Đang tải vị trí hiện tại' : 'Hiển thị vị trí hiện tại',
      child: Tooltip(
        message: 'Hiển thị vị trí hiện tại',
        child: isMobile
            // Ensure minimum 48px touch target on mobile
            ? SizedBox(
                width: ResponsiveBreakpoints.minTouchTarget,
                height: ResponsiveBreakpoints.minTouchTarget,
                child: IconButton.filledTonal(
                  onPressed: isLoading ? null : onPressed,
                  icon: iconWidget,
                ),
              )
            : FilledButton.tonalIcon(
                onPressed: isLoading ? null : onPressed,
                icon: iconWidget,
                label: const Text('Vị trí'),
              ),
      ),
    );
  }
}
