import 'package:flutter/material.dart';

import '../domain/current_location_state.dart';
import 'vietnam_map_controller.dart';
import 'widgets/map_control_panel.dart';
import 'widgets/map_overlay_controls.dart';
import 'widgets/map_viewport.dart';

class VietnamMapScreen extends StatefulWidget {
  const VietnamMapScreen({super.key});

  @override
  State<VietnamMapScreen> createState() => _VietnamMapScreenState();
}

class _VietnamMapScreenState extends State<VietnamMapScreen> {
  late final VietnamMapController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VietnamMapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.requestCurrentLocation();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 980;
          final map = _MapSurface(controller: _controller);
          final panel = MapControlPanel(
            controlSpace: _controller.controlSpace,
            onInactiveInteraction: _controller.acknowledgeInactiveControl,
          );

          if (compact) {
            return Column(
              children: [
                SizedBox(height: 238, child: panel),
                Expanded(child: map),
              ],
            );
          }

          return Row(
            children: [
              SizedBox(width: 360, child: panel),
              Expanded(child: map),
            ],
          );
        },
      ),
    );
  }
}

class _MapSurface extends StatelessWidget {
  const _MapSurface({required this.controller});

  final VietnamMapController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned.fill(
              child: MapViewport(
                controller: controller,
                overlay: MapOverlayControls(
                  isLocationLoading: controller.locationState.isRequesting,
                  onZoomIn: controller.zoomIn,
                  onZoomOut: controller.zoomOut,
                  onCurrentLocation: controller.requestCurrentLocation,
                  onRecenter: controller.recenterOnVietnam,
                ),
              ),
            ),
            if (_showLocationMessage(controller.locationState))
              Positioned(
                left: 20,
                bottom: 20,
                child: _LocationMessage(state: controller.locationState),
              ),
          ],
        );
      },
    );
  }

  bool _showLocationMessage(CurrentLocationState state) {
    return state.hasMessage &&
        state.status != CurrentLocationStatus.unknown &&
        state.status != CurrentLocationStatus.requesting;
  }
}

class _LocationMessage extends StatelessWidget {
  const _LocationMessage({required this.state});

  final CurrentLocationState state;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isError = state.status == CurrentLocationStatus.denied ||
        state.status == CurrentLocationStatus.unavailable ||
        state.status == CurrentLocationStatus.error;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Material(
        color: colorScheme.surface,
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isError ? Icons.location_off : Icons.my_location,
                color: isError ? colorScheme.error : colorScheme.primary,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  state.message ?? 'Location state changed.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
