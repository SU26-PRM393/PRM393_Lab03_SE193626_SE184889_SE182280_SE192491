import 'package:flutter/material.dart';

import 'package:vietnam_map_flutter/models/current_location_state.dart';

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
        label: 'Điểm đánh dấu vị trí hiện tại',
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
