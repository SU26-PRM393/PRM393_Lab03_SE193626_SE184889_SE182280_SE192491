# Implementation Plan: Desktop Viet Nam Map UI

**Branch**: `001-vietnam-map-ui` | **Date**: 2026-05-16 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-vietnam-map-ui/spec.md`

## Summary

Build the first desktop UI slice for a Viet Nam map application using Flutter
and Material 3. The screen will center the map experience, support pan and zoom,
show current-location state when available, and reserve polished UI space for
future search, filter, and sort controls for provinces, cities, and districts.
Search, filter, and sort behavior remains explicitly out of scope.

The map stack follows the provided table:

| Purpose | Technology |
|---------|------------|
| Map Engine | `flutter_map` |
| Coordinate Utils | `latlong2` |
| Map Source | OpenStreetMap (OSM) |
| Vietnam Data | Geofabrik Vietnam Extract |
| Admin Boundaries | GeoJSON / Shapefiles |
| Offline Tiles | MBTiles or PMTiles |

## Technical Context

**Language/Version**: Dart 3.x with Flutter stable.

**Primary Dependencies**: Flutter SDK, Material 3 widgets, `flutter_map`,
`latlong2`, `geolocator`, OSM raster tile source, and future-ready adapters for
Geofabrik Vietnam extracts, GeoJSON/Shapefile admin boundaries, and MBTiles or
PMTiles offline tiles.

**Storage**: Initial UI slice uses no persisted user data. Local assets may hold
placeholder UI data, map attribution text, and future processed boundary/tile
artifacts. Offline tiles are planned as future MBTiles or PMTiles assets, not
downloaded from the public OSM tile service.

**Verification Approach**: Manual desktop walkthroughs, screenshots, reviewer
inspection, and profiling output. Automated tests are not required by project
constitution.

**Target Platform**: Desktop application, with Windows as the primary local
development target and macOS/Linux kept structurally compatible where package
support allows.

**Project Type**: Flutter desktop application.

**Performance Goals**: Main map usable within 3 seconds; visible pan/zoom
feedback within 200 ms; interactive map gestures stay visually smooth during
normal desktop use; current-location failure must not block map exploration.

**UX/UI Standards**: Material 3 theme, desktop-first layout density, map as the
dominant visual surface, reserved side/top control area for future search,
filter, and sort, clear inactive-control states, accessible labels, keyboard or
button access for zoom and current-location actions.

**Performance Validation**: Run in profile or release mode on a representative
desktop, capture first usable map time, manually verify pan/zoom response, and
inspect Flutter performance overlay or DevTools frame behavior during map
gestures.

**Constraints**: UI-first only; search/filter/sort must not modify map or data.
Public OSM tiles require visible attribution, valid app identification, caching
that honors policy, and no offline/prefetch use. Offline map support must use
self-hosted or explicitly permitted MBTiles/PMTiles sources.

**Scale/Scope**: One desktop main screen, one interactive map viewport, one
current-location indicator/unavailable state, and inactive/reserved UI for
province, city, district search/filter/sort controls.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Code Quality**: PASS. The implementation will separate app shell/theme,
  map presentation, map controller state, location service state, and inactive
  control panel UI. No business logic will be hidden in large build methods.
- **Manual Verification**: PASS. Each user journey has a manual validation path:
  map pan/zoom walkthrough, current-location available/unavailable walkthrough,
  and inactive-control inspection. Evidence will be screenshots, short demo
  recording, and profiling notes.
- **UX Consistency**: PASS. Material 3 theme tokens, labeled controls, consistent
  inactive states, resize behavior, and map-focused layout will be reused across
  the screen.
- **Beautiful UI**: PASS. The design favors a desktop operational layout:
  full-height map surface, restrained control rail/panel, clear hierarchy,
  readable labels, and non-obstructing OSM attribution/current-location state.
- **Performance**: PASS. Plan includes first usable map, input feedback, map
  gesture smoothness, and current-location failure budgets with profile/release
  validation.
- **Gate Result**: PASS. No constitution violations.

## Project Structure

### Documentation (this feature)

```text
specs/001-vietnam-map-ui/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- ui-contract.md
`-- checklists/
    `-- requirements.md
```

### Source Code (repository root)

```text
lib/
|-- main.dart
|-- app/
|   |-- map_app.dart
|   `-- app_theme.dart
|-- features/
|   `-- vietnam_map/
|       |-- data/
|       |   |-- map_tile_source.dart
|       |   |-- location_repository.dart
|       |   `-- admin_boundary_source.dart
|       |-- domain/
|       |   |-- map_view_state.dart
|       |   |-- current_location_state.dart
|       |   `-- administrative_area.dart
|       |-- presentation/
|       |   |-- vietnam_map_screen.dart
|       |   |-- vietnam_map_controller.dart
|       |   `-- widgets/
|       |       |-- map_viewport.dart
|       |       |-- map_control_panel.dart
|       |       |-- map_zoom_controls.dart
|       |       |-- current_location_button.dart
|       |       `-- current_location_indicator.dart
|       `-- assets/
|           |-- boundaries/
|           `-- offline_tiles/
|-- shared/
|   |-- constants/
|   `-- widgets/
assets/
|-- maps/
|   |-- boundaries/
|   `-- offline_tiles/
`-- images/
```

**Structure Decision**: Use a single Flutter desktop app with a feature-oriented
`lib/features/vietnam_map/` module. Map UI, location state, map source policy,
and future boundary/tile adapters are isolated so later search/filter/sort
features can build on the same feature boundary without refactoring the shell.

## Complexity Tracking

> No constitution violations or unusual complexity are required for this plan.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|

## Post-Design Constitution Re-Check

- **Code Quality**: PASS. `data-model.md` and `ui-contract.md` keep state,
  services, and presentation boundaries explicit.
- **Manual Verification**: PASS. `quickstart.md` lists manual walkthrough,
  screenshot/demo, and performance validation steps.
- **UX Consistency**: PASS. UI contract preserves Material 3 controls, visible
  labels, inactive states, resize behavior, and accessibility expectations.
- **Beautiful UI**: PASS. Layout contract keeps the map dominant and control
  panel secondary without blocking attribution, zoom, or location controls.
- **Performance**: PASS. Quickstart includes first usable map timing, pan/zoom
  feedback, and performance overlay or DevTools validation.
- **Gate Result**: PASS. No design-phase violations.
