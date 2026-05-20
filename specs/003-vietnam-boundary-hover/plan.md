# Implementation Plan: Vietnam Boundary Hover Map

**Branch**: `003-vietnam-boundary-hover` | **Date**: 2026-05-17 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/003-vietnam-boundary-hover/spec.md`

## Summary

Keep the current desktop Viet Nam map appearance while adding stricter
geographic scope and province hover feedback. The recommended approach is to
leave the existing OSM raster tile layer, attribution, controls, and Material 3
layout unchanged, then add a local boundary overlay layer above it: a neutral
outside-Viet Nam mask, fixed island label overrides for the requested labels,
and a thin province outline that appears only while the pointer hovers over a
province-level area.

No new map engine or different-looking basemap is planned. The existing
`flutter_map` stack remains the base; the feature adds local, cached geometry
data and overlay rendering around the current map.

## Technical Context

**Language/Version**: Dart 3.x with Flutter stable. Current project SDK
constraint is `>=3.4.0 <4.0.0`.

**Primary Dependencies**: Flutter SDK, Material 3 widgets, `flutter_map` 8.3.0,
`latlong2`, `geolocator`, existing OSM raster tile source, local JSON/GeoJSON
asset loading, and existing project state/controller patterns. No new runtime
dependency is recommended for this planning pass.

**Storage**: Static packaged assets under
`lib/features/vietnam_map/assets/boundaries/` for simplified Viet Nam
country-scope and province-level geometry. Existing province metadata under
`lib/features/vietnam_map/assets/data/` remains available for IDs, names, and
province matching. No user data storage is required.

**Verification Approach**: Manual desktop walkthroughs, screenshots or short
recordings, visual comparison against the current map appearance, Flutter
profile mode, Flutter performance overlay or DevTools Performance view, and
source review for geometry loading, hover state, and rebuild boundaries.
Automated tests are not required by the project constitution.

**Target Platform**: Desktop application with Windows as the primary local
validation target. macOS and Linux remain structurally compatible.

**Project Type**: Flutter desktop application.

**Performance Goals**: Main map usable within 3 seconds; hover outline appears,
updates, or clears within 100 ms; no user-visible freeze longer than 150 ms
during a 60-second mixed pan/zoom/hover session; existing drag and zoom
smoothness target from feature `002` remains intact.

**UX/UI Standards**: Preserve the existing map-first Material 3 desktop layout,
current OSM-like map styling, visible attribution, current-location states,
inactive search/filter/sort areas, readable labels, and keyboard or button
access for zoom and current-location actions. Only three visible changes are in
scope: outside-Viet Nam masking where needed, requested island label overrides,
and province hover outlines.

**Performance Validation**: Run `flutter run -d windows --profile`, use the
performance overlay or DevTools Performance view, perform 30 seconds of border
panning and 60 seconds of mixed drag/zoom/hover/control interaction, and record
whether hover feedback meets the 100 ms target without red jank bars or visible
freezes.

**Constraints**: The current map appearance must not be replaced with a
different basemap style. Public OSM tiles must keep visible attribution, a
specific app identifier, policy-compliant caching, and no public-tile prefetch
or offline download behavior. Because raster tile labels are baked into the
base imagery, label replacement must be handled as a small overlay/cover rather
than by mutating the tile source. Boundary geometry must be simplified and
cached so pointer movement does not block the UI isolate.

**Scale/Scope**: One desktop main map screen, one `flutter_map` viewport, one
existing tile layer, one local Viet Nam scope geometry, one province-level
boundary dataset, two island label overrides, one active hover outline, existing
current-location marker/state, and existing map controls.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **Code Quality**: PASS. The implementation will stay inside
  `lib/features/vietnam_map/`, separating geometry asset loading, map scope
  rules, province hit testing, hover state, and overlay widgets. New helpers
  are justified because boundary parsing and point-in-polygon logic do not
  belong inside widget build methods.
- **Manual Verification**: PASS. The primary journeys are independently
  verifiable by opening the map, checking current appearance, panning near
  borders, inspecting Hoang Sa and Truong Sa labels, and hovering over multiple
  provinces. Evidence will include screenshots or a short recording plus
  profile-mode notes.
- **UX Consistency**: PASS. The current map view, controls, attribution,
  location states, and inactive control panel remain in place. Hover feedback
  is additive and uses the existing map interaction model.
- **Beautiful UI**: PASS. The map remains the dominant surface. The province
  outline must be thin, high contrast, and non-blocking; the outside-scope mask
  must be visually neutral; island label overrides must be legible without
  covering essential controls.
- **Performance**: PASS. Budgets are explicit for first usable map, hover
  response, freeze duration, and profile-mode validation. Boundary data must be
  simplified, loaded once, cached, and queried with bbox-first checks before
  polygon containment.
- **Gate Result**: PASS. No constitution violations.

## Project Structure

### Documentation (this feature)

```text
specs/003-vietnam-boundary-hover/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- map-scope-hover-contract.md
|-- checklists/
|   `-- requirements.md
`-- tasks.md
```

### Source Code (repository root)

```text
lib/
|-- features/
|   `-- vietnam_map/
|       |-- assets/
|       |   |-- boundaries/
|       |   |   |-- vietnam_scope.geojson
|       |   |   `-- province_boundaries.geojson
|       |   `-- data/
|       |       `-- provinces.json
|       |-- data/
|       |   |-- admin_boundary_source.dart
|       |   `-- map_tile_source.dart
|       |-- domain/
|       |   |-- administrative_area.dart
|       |   |-- map_boundary.dart
|       |   |-- map_scope.dart
|       |   |-- province_hover_state.dart
|       |   `-- map_view_state.dart
|       `-- presentation/
|           |-- vietnam_map_controller.dart
|           |-- vietnam_map_screen.dart
|           `-- widgets/
|               |-- map_scope_overlay.dart
|               |-- province_hover_outline.dart
|               |-- island_label_overlay.dart
|               `-- map_viewport.dart
lib/
`-- shared/
    `-- constants/
        `-- map_constants.dart
```

**Structure Decision**: Keep the work inside the existing
`lib/features/vietnam_map/` feature boundary. The expected implementation
extends the existing `AdminBoundarySource`, controller, map viewport, and map
constants. It does not require a new app-wide state framework, a new map
engine, or a new base tile style.

## Complexity Tracking

> No constitution violations or unusual complexity are required for this plan.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|

## Post-Design Constitution Re-Check

- **Code Quality**: PASS. `research.md`, `data-model.md`, and
  `map-scope-hover-contract.md` define focused ownership for geometry assets,
  scope masking, label overrides, and hover state.
- **Manual Verification**: PASS. `quickstart.md` includes visual appearance
  comparison, Viet Nam-only border checks, island label checks, hover checks,
  and profile-mode performance capture.
- **UX Consistency**: PASS. The contract preserves current map appearance,
  current controls, attribution, current-location behavior, and inactive future
  controls.
- **Beautiful UI**: PASS. Only scoped overlay elements are added, and their
  acceptance criteria require legibility without visually replacing the map.
- **Performance**: PASS. The design requires local cached geometry, bbox-first
  hit testing, one active outline, and profile validation against the existing
  smooth-map movement budget.
- **Gate Result**: PASS. No design-phase violations.
