# Implementation Plan: Smooth Map Movement

**Branch**: `002-smooth-map-movement` | **Date**: 2026-05-16 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/002-smooth-map-movement/spec.md`

## Summary

Improve the existing desktop Viet Nam map screen so dragging, zooming, and
nearby map controls stay smooth during normal exploration. The technical
approach is to remove high-frequency camera updates from whole-screen rebuilds,
keep the map tile layer and tile provider stable across interaction, preserve
policy-compliant `flutter_map` tile caching, tune tile display behavior for
desktop panning, and validate the result in profile mode with manual frame and
freeze observations.

No new map engine is planned. The current `flutter_map` 8.3.0 stack is already
appropriate for this feature, and its built-in tile caching/request cancellation
support should be used before adding heavier dependencies.

## Technical Context

**Language/Version**: Dart 3.x with Flutter stable. Current project SDK
constraint is `>=3.4.0 <4.0.0`.

**Primary Dependencies**: Flutter SDK, Material 3 widgets, `flutter_map` 8.3.0,
`latlong2`, `geolocator`, and the existing OSM raster tile source. No new
runtime dependency is required for the first smoothing pass.

**Storage**: No user data storage. The feature relies on `flutter_map` built-in
tile caching on non-web desktop platforms and the operating system cache
directory. Offline tile packaging remains out of scope.

**Verification Approach**: Manual desktop walkthroughs, short screen recording
or screenshots, Flutter profile mode, Flutter performance overlay or DevTools
Performance view, reviewer inspection, and source review for rebuild boundaries.
Automated tests are not required by the project constitution.

**Target Platform**: Desktop application with Windows as the primary local
validation target. macOS and Linux remain structurally compatible.

**Project Type**: Flutter desktop application.

**Performance Goals**: Main map usable within 3 seconds; visible drag/zoom
feedback within 100 ms; no user-visible freeze longer than 150 ms during a
60-second exploration session; no progressive slowdown from rapid repeated map
movement; map controls responsive in 100% of validation attempts.

**UX/UI Standards**: Preserve the existing Material 3 desktop layout, map-first
visual hierarchy, visible OSM attribution, current-location states, inactive
search/filter/sort areas, readable labels, and keyboard or button access for
zoom and current-location actions.

**Performance Validation**: Run `flutter run -d windows --profile`, use the
performance overlay or DevTools Performance view, perform 30 seconds of
continuous drag and 60 seconds of mixed drag/zoom/control interaction, and
record whether UI/raster thread frames show red jank bars or visible freezes.

**Constraints**: Public OSM tiles must keep visible attribution, a specific app
identifier, policy-compliant caching, and no public-tile prefetch/offline
download behavior. Smoothing must not add search, filter, sort, or
administrative boundary behavior. Work that can block the UI isolate must be
deferred, cached, chunked, or removed from the gesture path.

**Scale/Scope**: One desktop main map screen, one `flutter_map` viewport, one
current-location marker/state, existing zoom/recenter/location controls, and
inactive reserved province/city/district control areas.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Code Quality**: PASS. The implementation will keep map gesture state,
  performance settings, tile-source policy, and visible UI state in focused
  units under `lib/features/vietnam_map/`. High-frequency camera updates will
  not be routed through broad widget rebuilds. Any new helper must isolate a
  real concern such as throttled viewport state or stable tile-layer settings.
- **Manual Verification**: PASS. The primary journey is independently
  verifiable by dragging and zooming the map for 30-60 seconds in profile mode.
  Evidence will include a manual walkthrough, profiling notes, and a short
  recording or screenshots of ready, loading, location, and interaction states.
- **UX Consistency**: PASS. The current desktop Material 3 layout, map controls,
  current-location messages, attribution, and inactive control panel remain in
  place. The feature changes responsiveness, not the user's workflow or labels.
- **Beautiful UI**: PASS. The map remains the dominant surface. Loading and
  unavailable imagery states must be subtle, non-blocking, and visually stable
  during movement. The plan avoids extra dialogs or settings before map use.
- **Performance**: PASS. Budgets are explicit for first usable map, drag/zoom
  feedback, freeze duration, control response, memory-conscious tile buffering,
  and profile-mode validation on Windows desktop.
- **Gate Result**: PASS. No constitution violations.

## Project Structure

### Documentation (this feature)

```text
specs/002-smooth-map-movement/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- ui-performance-contract.md
`-- checklists/
    `-- requirements.md
```

### Source Code (repository root)

```text
lib/
|-- features/
|   `-- vietnam_map/
|       |-- data/
|       |   |-- location_repository.dart
|       |   `-- map_tile_source.dart
|       |-- domain/
|       |   |-- current_location_state.dart
|       |   |-- map_tile_source.dart
|       |   `-- map_view_state.dart
|       `-- presentation/
|           |-- vietnam_map_controller.dart
|           |-- vietnam_map_screen.dart
|           `-- widgets/
|               |-- current_location_button.dart
|               |-- current_location_indicator.dart
|               |-- map_control_panel.dart
|               |-- map_viewport.dart
|               `-- map_zoom_controls.dart
|-- shared/
|   `-- constants/
|       `-- map_constants.dart
assets/
|-- maps/
|   |-- boundaries/
|   `-- offline_tiles/
`-- images/
```

**Structure Decision**: Keep the work inside the existing
`lib/features/vietnam_map/` feature boundary. The expected implementation
touches map viewport rendering, controller notification behavior, map/tile
performance settings, and validation notes; it does not require a new feature
module or app-wide state framework.

## Complexity Tracking

> No constitution violations or unusual complexity are required for this plan.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|

## Post-Design Constitution Re-Check

- **Code Quality**: PASS. `research.md`, `data-model.md`, and
  `ui-performance-contract.md` define a bounded performance change that
  separates high-frequency map camera movement from low-frequency UI state.
- **Manual Verification**: PASS. `quickstart.md` defines profile-mode
  validation, continuous drag, mixed drag/zoom/control interaction, loading
  resilience, and evidence capture.
- **UX Consistency**: PASS. The UI contract preserves existing controls,
  attribution, current-location messages, inactive future controls, and
  keyboard/button accessibility.
- **Beautiful UI**: PASS. The design keeps loading/unavailable states
  non-blocking and avoids new visual clutter while improving motion quality.
- **Performance**: PASS. Budgets cover first usable map, feedback latency,
  visible freezes, rebuild boundaries, tile loading behavior, and post-change
  profiling.
- **Gate Result**: PASS. No design-phase violations.
