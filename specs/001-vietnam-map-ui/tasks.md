---
description: "Task list for Desktop Viet Nam Map UI implementation"
---

# Tasks: Desktop Viet Nam Map UI

**Input**: Design documents from `/specs/001-vietnam-map-ui/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/ui-contract.md, quickstart.md

**Quality Gates**: This task list uses manual verification, analyzer/format
checks, visual review, accessibility review, and performance validation.
Automated tests are not required and are not generated as mandatory tasks.

**Organization**: Tasks are grouped by user story so each story can be delivered
and manually verified independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when dependencies are complete and files do not overlap
- **[Story]**: User story label for story phases only
- Every task includes exact file paths

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Create the Flutter desktop app foundation, dependencies, and base folders.

- [x] T001 Create Flutter desktop project scaffold in `pubspec.yaml`, `lib/main.dart`, and `windows/`
- [x] T002 Add `flutter_map`, `latlong2`, and `geolocator` dependencies in `pubspec.yaml`
- [x] T003 [P] Configure analyzer and formatting rules in `analysis_options.yaml`
- [x] T004 [P] Create planned app directories in `lib/app/`, `lib/features/vietnam_map/`, `lib/shared/constants/`, `assets/maps/boundaries/`, and `assets/maps/offline_tiles/`
- [x] T005 Register map and image asset folders in `pubspec.yaml`
- [x] T006 Create Material 3 app theme tokens in `lib/app/app_theme.dart`
- [x] T007 Create root `MaterialApp` shell using the Material 3 theme in `lib/app/map_app.dart`
- [x] T008 Wire `main()` to launch the app shell in `lib/main.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared map constants, domain state, data adapters, and controller boundaries used by all user stories.

**CRITICAL**: No user story work can begin until this phase is complete.

- [x] T009 Create OSM tile URL, attribution, Vietnam initial center, and zoom constants in `lib/shared/constants/map_constants.dart`
- [x] T010 [P] Create `MapViewport` domain state in `lib/features/vietnam_map/domain/map_view_state.dart`
- [x] T011 [P] Create `MapTileSource` domain state in `lib/features/vietnam_map/domain/map_tile_source.dart`
- [x] T012 [P] Create `CurrentLocationState` domain state in `lib/features/vietnam_map/domain/current_location_state.dart`
- [x] T013 [P] Create `AdministrativeAreaControlSpace` and `AdministrativeArea` domain models in `lib/features/vietnam_map/domain/administrative_area.dart`
- [x] T014 Create OSM online tile source adapter with attribution and no-offline policy flags in `lib/features/vietnam_map/data/map_tile_source.dart`
- [x] T015 [P] Create current-location repository interface and geolocator-backed implementation skeleton in `lib/features/vietnam_map/data/location_repository.dart`
- [x] T016 [P] Create future Geofabrik/GeoJSON/Shapefile boundary source placeholder in `lib/features/vietnam_map/data/admin_boundary_source.dart`
- [x] T017 Create `VietnamMapController` with viewport, tile source, location, and inactive-control state in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [x] T018 Create main feature screen shell wired to the controller in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`
- [x] T019 Connect the app shell to `VietnamMapScreen` in `lib/app/map_app.dart`

**Checkpoint**: Flutter app foundation, map constants, domain state, data adapters, and feature shell are ready.

---

## Phase 3: User Story 1 - Explore Viet Nam Map (Priority: P1) MVP

**Goal**: Users can open the desktop app, see a Viet Nam map, drag it, and zoom in/out.

**Independent Validation**: Open the desktop app, confirm the Viet Nam map is visible, drag the map in multiple directions, zoom in/out, and verify the map remains responsive.

### Implementation for User Story 1

- [x] T020 [P] [US1] Implement `flutter_map` viewport centered on Viet Nam in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [x] T021 [P] [US1] Implement visible zoom in/out controls in `lib/features/vietnam_map/presentation/widgets/map_zoom_controls.dart`
- [x] T022 [US1] Wire drag, wheel/trackpad zoom, and zoom button behavior through `VietnamMapController` in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [x] T023 [US1] Add OSM tile layer and visible attribution overlay in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [x] T024 [US1] Add map loading and map-source unavailable UI states in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [x] T025 [US1] Compose the map viewport and zoom controls into the screen layout in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`
- [x] T026 [US1] Add desktop resize constraints that keep the map dominant in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`

### Manual Validation for User Story 1

- [ ] T027 [US1] Run `dart format` and `flutter analyze` for `lib/main.dart`, `lib/app/`, `lib/shared/`, and `lib/features/vietnam_map/`
- [ ] T028 [US1] Verify map visible, drag, zoom in, and zoom out walkthrough using `specs/001-vietnam-map-ui/quickstart.md`
- [ ] T029 [US1] Capture screenshot or short recording of map ready and map interaction states in `specs/001-vietnam-map-ui/checklists/requirements.md`
- [ ] T030 [US1] Record first usable map timing and pan/zoom response notes in `specs/001-vietnam-map-ui/quickstart.md`

**Checkpoint**: User Story 1 is fully functional and manually verified as the MVP.

---

## Phase 4: User Story 2 - See Current Location (Priority: P2)

**Goal**: Users can see current-location state when available and receive a non-blocking unavailable state when location cannot be displayed.

**Independent Validation**: Open the app with location available and confirm a marker or indicator appears; deny or disable location and confirm the map remains usable with a clear unavailable state.

### Implementation for User Story 2

- [x] T031 [P] [US2] Implement current-location button UI in `lib/features/vietnam_map/presentation/widgets/current_location_button.dart`
- [x] T032 [P] [US2] Implement current-location marker, accuracy, and unavailable indicators in `lib/features/vietnam_map/presentation/widgets/current_location_indicator.dart`
- [x] T033 [US2] Implement request, denied, unavailable, available, and error transitions in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [x] T034 [US2] Connect `LocationRepository` to `geolocator` permission and current-position calls in `lib/features/vietnam_map/data/location_repository.dart`
- [x] T035 [US2] Add Windows desktop location capability notes or configuration in `windows/runner/Runner.rc`
- [x] T036 [US2] Overlay current-location controls and status without blocking map gestures in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [x] T037 [US2] Add non-blocking denied/unavailable location messages in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`

### Manual Validation for User Story 2

- [ ] T038 [US2] Run `dart format` and `flutter analyze` for `lib/features/vietnam_map/data/location_repository.dart`, `lib/features/vietnam_map/domain/current_location_state.dart`, and `lib/features/vietnam_map/presentation/`
- [ ] T039 [US2] Verify available, denied, unavailable, and error location states using `specs/001-vietnam-map-ui/quickstart.md`
- [ ] T040 [US2] Capture screenshot or short recording of current-location available and unavailable states in `specs/001-vietnam-map-ui/checklists/requirements.md`
- [ ] T041 [US2] Verify map pan/zoom still works during location failure using `specs/001-vietnam-map-ui/contracts/ui-contract.md`

**Checkpoint**: User Stories 1 and 2 work independently and together.

---

## Phase 5: User Story 3 - Reserve Controls For Future Province Data Tools (Priority: P3)

**Goal**: Users see polished, inactive search/filter/sort UI space for future province, city, and district tools.

**Independent Validation**: Open the app and confirm the search/filter/sort control area is visible, readable, inactive, and does not change map content.

### Implementation for User Story 3

- [x] T042 [P] [US3] Implement inactive search field, administrative level selector, filter chips, and sort selector in `lib/features/vietnam_map/presentation/widgets/map_control_panel.dart`
- [x] T043 [US3] Keep `AdministrativeAreaControlSpace.isFunctional` false and expose inactive labels through `VietnamMapController` in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [x] T044 [US3] Add desktop control panel layout beside or above the map in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`
- [x] T045 [US3] Add accessible labels and inactive helper text for search, filter, and sort controls in `lib/features/vietnam_map/presentation/widgets/map_control_panel.dart`
- [x] T046 [US3] Ensure control panel interactions do not mutate map viewport, tile source, current location, or administrative data in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [x] T047 [US3] Add future-data source comments for Geofabrik, GeoJSON/Shapefile, MBTiles, and PMTiles in `lib/features/vietnam_map/data/admin_boundary_source.dart`

### Manual Validation for User Story 3

- [ ] T048 [US3] Run `dart format` and `flutter analyze` for `lib/features/vietnam_map/presentation/widgets/map_control_panel.dart`, `lib/features/vietnam_map/domain/administrative_area.dart`, and `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`
- [ ] T049 [US3] Verify search, filter, and sort controls are visible and inactive using `specs/001-vietnam-map-ui/contracts/ui-contract.md`
- [ ] T050 [US3] Verify clicking or focusing reserved controls does not change map content using `specs/001-vietnam-map-ui/quickstart.md`
- [ ] T051 [US3] Capture desktop narrow and wide layout screenshots showing map and reserved controls in `specs/001-vietnam-map-ui/checklists/requirements.md`

**Checkpoint**: All selected user stories work independently and the UI-first feature is complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final quality pass across the desktop UI, map policy, accessibility, and performance requirements.

- [x] T052 [P] Review OSM attribution visibility and tile policy notes in `lib/shared/constants/map_constants.dart`
- [x] T053 [P] Review Material 3 colors, typography, spacing, and component states in `lib/app/app_theme.dart`
- [x] T054 Review focus order, keyboard reachability for zoom/current-location controls, and accessible names in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`
- [ ] T055 Run full `dart format` and `flutter analyze` for `pubspec.yaml`, `analysis_options.yaml`, `lib/`, and `windows/`
- [ ] T056 Validate every quickstart manual validation step and record results in `specs/001-vietnam-map-ui/quickstart.md`
- [ ] T057 Capture final ready, interaction, current-location, unavailable-location, inactive-control, narrow, and wide screenshots in `specs/001-vietnam-map-ui/checklists/requirements.md`
- [ ] T058 Profile app launch and pan/zoom behavior in profile or release mode and record results in `specs/001-vietnam-map-ui/quickstart.md`
- [x] T059 Update project README with desktop run instructions and map stack summary in `README.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; complete before foundational work.
- **Foundational (Phase 2)**: Depends on Setup completion; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; delivers the MVP map experience.
- **User Story 2 (Phase 4)**: Depends on Foundational and integrates with the map viewport from US1.
- **User Story 3 (Phase 5)**: Depends on Foundational and can start after US1 layout exists.
- **Polish (Phase 6)**: Depends on all selected user stories.

### User Story Dependencies

- **US1 - Explore Viet Nam Map**: First MVP story; no dependency on US2 or US3.
- **US2 - See Current Location**: Depends on the shared map viewport and controller from US1, but can be manually verified independently after integration.
- **US3 - Reserve Controls For Future Province Data Tools**: Depends on the screen layout from US1, but must remain non-functional and independently verifiable.

### Within Each User Story

- Domain and data state before controller integration.
- Controller behavior before screen composition.
- Screen composition before manual validation.
- Analyzer/format checks before story checkpoint.
- Accessibility and performance validation before final polish.

## Parallel Opportunities

- T003, T004, and T006 can run in parallel after T001.
- T010, T011, T012, T013, T015, and T016 can run in parallel after T009.
- T020 and T021 can run in parallel after Phase 2.
- T031 and T032 can run in parallel after US1 checkpoint.
- T052 and T053 can run in parallel during polish.

## Parallel Example: User Story 1

```text
Task: "T020 [P] [US1] Implement `flutter_map` viewport centered on Viet Nam in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`"
Task: "T021 [P] [US1] Implement visible zoom in/out controls in `lib/features/vietnam_map/presentation/widgets/map_zoom_controls.dart`"
```

## Parallel Example: User Story 2

```text
Task: "T031 [P] [US2] Implement current-location button UI in `lib/features/vietnam_map/presentation/widgets/current_location_button.dart`"
Task: "T032 [P] [US2] Implement current-location marker, accuracy, and unavailable indicators in `lib/features/vietnam_map/presentation/widgets/current_location_indicator.dart`"
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and manually validate map visibility, dragging, zooming, attribution, and performance.

### Incremental Delivery

1. Deliver US1 as the standalone interactive map MVP.
2. Add US2 current-location states without blocking pan/zoom.
3. Add US3 inactive control panel without enabling search/filter/sort behavior.
4. Run final polish and quickstart validation.

### Manual Verification Summary

- **US1**: Map visible, draggable, zoomable, and responsive.
- **US2**: Current-location available/unavailable states are clear and non-blocking.
- **US3**: Reserved province/city/district search/filter/sort UI is visible and inactive.

## Notes

- Automated tests are not required by constitution v2.0.0.
- Search, filter, and sort behavior must remain out of scope for this feature.
- Public OSM tiles must not be prefetched for offline use.
- Offline tiles are future work and must use self-hosted or explicitly permitted MBTiles or PMTiles sources.
