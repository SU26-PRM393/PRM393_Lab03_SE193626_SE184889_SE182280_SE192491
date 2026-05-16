import 'package:flutter/material.dart';

import '../../domain/current_location_state.dart';

class CurrentLocationIndicator extends StatelessWidget {
  const CurrentLocationIndicator({
    required this.state,
    super.key,
  });

  final CurrentLocationState state;

  @override
  Widget build(BuildContext context) {
    if (state.isAvailable) {
      return Semantics(
        label: 'Current location marker',
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(41),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.surface,
                  width: 3,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
