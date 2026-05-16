# Tasks: Smooth Map Movement

**Input**: Design documents from `/specs/002-smooth-map-movement/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md),
[research.md](./research.md), [data-model.md](./data-model.md),
[ui-performance-contract.md](./contracts/ui-performance-contract.md),
[quickstart.md](./quickstart.md)

**Quality Gates**: Code quality, manual verification, UX consistency, visual
polish, accessibility, and performance validation are required. Automated tests
are not required for this feature.

**Organization**: Tasks are grouped by user story so the smoother map movement
MVP can be implemented and verified before control responsiveness and
longer-session resilience work.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare dependency, analyzer, and validation-note baseline before
code changes.

- [X] T001 Run `flutter pub get` for `pubspec.yaml` and confirm no new runtime dependency is needed for the `flutter_map` 8.3 smoothing pass
- [X] T002 Create `specs/002-smooth-map-movement/validation-notes.md` with sections for baseline, US1, US2, US3, and final profile evidence
- [X] T003 Run pre-change `flutter analyze` for `analysis_options.yaml` and `lib/`, then record the result in `specs/002-smooth-map-movement/validation-notes.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish shared constants and policy guardrails used by all user
stories.

**CRITICAL**: No user story work can begin until this phase is complete.

- [X] T004 Add map performance constants for user agent, tile buffers, tile display behavior, and validation budgets in `lib/shared/constants/map_constants.dart`
- [X] T005 Add viewport helper fields or methods for interaction and imagery status transitions in `lib/features/vietnam_map/domain/map_view_state.dart`
- [X] T006 [P] Verify `pubspec.yaml` and `pubspec.lock` still have no extra tile-provider or state-management dependency after setup
- [X] T007 [P] Confirm the OSM no-prefetch/offline-download policy remains represented in `lib/features/vietnam_map/data/map_tile_source.dart`

**Checkpoint**: Foundation ready; user story implementation can now begin.

---

## Phase 3: User Story 1 - Move The Map Smoothly (Priority: P1) MVP

**Goal**: Dragging and zooming the Viet Nam map visibly respond within 100 ms
without repeated pauses or full-screen rebuild pressure.

**Independent Validation**: Run the desktop app in profile mode, drag
continuously for 30 seconds, zoom repeatedly, and confirm the map follows input
without visible freezes longer than 150 ms.

### Implementation for User Story 1

- [X] T008 [US1] Refactor `updateViewport` in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart` so high-frequency gesture camera updates refresh internal center/zoom without calling `notifyListeners()` on every tick
- [X] T009 [US1] Update zoom, recenter, and programmatic move flows in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart` to use the latest map camera as source of truth after gesture notifications are suppressed
- [X] T010 [US1] Apply stable `TileLayer` performance settings in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart` using constants from `lib/shared/constants/map_constants.dart`
- [X] T011 [US1] Add repaint boundaries around the map and stable overlay stack in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart` to limit repaint spill during pan and zoom
- [X] T012 [US1] Rescope `AnimatedBuilder` usage in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart` so the full `Scaffold`, `LayoutBuilder`, and `MapControlPanel` do not rebuild during map camera movement

### Manual Validation for User Story 1

- [ ] T013 [US1] Validate 30-second continuous drag and repeated zoom in profile mode, then record first feedback and freeze notes in `specs/002-smooth-map-movement/validation-notes.md`
- [X] T014 [US1] Run format and analyzer checks for `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`, `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`, and `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`, then record results in `specs/002-smooth-map-movement/validation-notes.md`

**Checkpoint**: User Story 1 is fully functional and manually verified.

---

## Phase 4: User Story 2 - Keep Controls Responsive During Map Movement (Priority: P2)

**Goal**: Zoom, current-location, recenter, and inactive reserved controls
remain responsive during or immediately after map movement.

**Independent Validation**: While dragging and zooming the map in profile mode,
use visible map controls and confirm each responds without freezing the screen.

### Implementation for User Story 2

- [X] T015 [P] [US2] Create `MapOverlayControls` for zoom, current-location, and recenter actions in `lib/features/vietnam_map/presentation/widgets/map_overlay_controls.dart`
- [X] T016 [US2] Update `_MapSurface` in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart` to use `MapOverlayControls` and rebuild controls only for low-frequency controller state changes
- [X] T017 [US2] Guard concurrent current-location requests in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart` so location lookup remains non-blocking during map movement
- [X] T018 [P] [US2] Verify accessible names, tooltips, and button reachability in `lib/features/vietnam_map/presentation/widgets/map_zoom_controls.dart` and `lib/features/vietnam_map/presentation/widgets/current_location_button.dart`

### Manual Validation for User Story 2

- [ ] T019 [US2] Validate zoom, recenter, and current-location controls during or immediately after dragging, then record results in `specs/002-smooth-map-movement/validation-notes.md`
- [X] T020 [US2] Run format and analyzer checks for `lib/features/vietnam_map/presentation/widgets/map_overlay_controls.dart`, `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`, and `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`, then record results in `specs/002-smooth-map-movement/validation-notes.md`

**Checkpoint**: User Stories 1 and 2 work independently.

---

## Phase 5: User Story 3 - Stay Smooth Across Normal Desktop Conditions (Priority: P3)

**Goal**: The map remains smooth during resizing, longer mixed interaction, and
temporary imagery loading or failure conditions.

**Independent Validation**: Resize the desktop window, perform a 60-second
mixed drag/zoom/control session, simulate slow or missing imagery when possible,
and confirm the map remains interactive.

### Implementation for User Story 3

- [X] T021 [US3] Throttle duplicate tile-source unavailable notifications in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart` so repeated tile failures do not cause rebuild loops
- [X] T022 [US3] Update status banners and imagery feedback in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart` so loading or unavailable imagery remains non-blocking and does not cover essential controls
- [X] T023 [US3] Verify compact and wide responsive layout behavior in `lib/features/vietnam_map/presentation/vietnam_map_screen.dart` and adjust sizing if the map or controls shift incoherently after resizing

### Manual Validation for User Story 3

- [ ] T024 [US3] Validate a 60-second mixed drag, zoom, control, and resize session in profile mode, then record freeze and frame notes in `specs/002-smooth-map-movement/validation-notes.md`
- [ ] T025 [US3] Validate temporarily slow or unavailable imagery behavior and record non-blocking interaction evidence in `specs/002-smooth-map-movement/validation-notes.md`
- [X] T026 [US3] Run format and analyzer checks for `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`, `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`, and `lib/features/vietnam_map/presentation/vietnam_map_screen.dart`, then record results in `specs/002-smooth-map-movement/validation-notes.md`

**Checkpoint**: All selected user stories work independently.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final documentation, validation, and quality review across the
entire smooth-map movement feature.

- [X] T027 [P] Update `specs/002-smooth-map-movement/quickstart.md` with any final validation command notes discovered during implementation
- [X] T028 [P] Update `README.md` with a brief profile-mode performance validation note for the desktop map
- [X] T029 Run final format and analyzer checks for `lib/` and `analysis_options.yaml`, then record the final outcome in `specs/002-smooth-map-movement/validation-notes.md`
- [ ] T030 Run the full profile-mode walkthrough from `specs/002-smooth-map-movement/quickstart.md` and capture final evidence in `specs/002-smooth-map-movement/validation-notes.md`
- [ ] T031 Review changed map files under `lib/features/vietnam_map/` for code quality, UX consistency, visual polish, accessibility, and performance gates, then record sign-off in `specs/002-smooth-map-movement/validation-notes.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; suggested MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational and integrates with the US1 map surface.
- **User Story 3 (Phase 5)**: Depends on Foundational and benefits from US1/US2 completion.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **US1 Move The Map Smoothly**: Can start after Foundational and delivers the MVP.
- **US2 Keep Controls Responsive During Map Movement**: Can start after Foundational, but is easiest after US1 rebuild boundaries are in place.
- **US3 Stay Smooth Across Normal Desktop Conditions**: Can start after Foundational, but final validation should run after US1 and US2.

### Parallel Opportunities

- T006 and T007 can run in parallel after T004/T005 planning decisions are clear because they touch different files.
- T015 and T018 can run in parallel during US2 because they touch different widget files.
- T027 and T028 can run in parallel during Polish because they update different documentation files.

## Parallel Execution Examples

### User Story 1

No same-story implementation tasks are marked parallel because the controller,
map viewport, and screen rebuild changes are tightly coupled and should be
integrated sequentially.

### User Story 2

```text
Task A: T015 Create MapOverlayControls in lib/features/vietnam_map/presentation/widgets/map_overlay_controls.dart
Task B: T018 Verify accessibility in lib/features/vietnam_map/presentation/widgets/map_zoom_controls.dart and lib/features/vietnam_map/presentation/widgets/current_location_button.dart
```

### User Story 3

No same-story implementation tasks are marked parallel because tile failure
state, banner behavior, and responsive layout should be verified together to
avoid masking performance regressions.

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and validate drag/zoom smoothness in profile mode.
5. Demo or continue only after the US1 quality gates pass.

### Incremental Delivery

1. Deliver US1 to remove the main panning and zooming lag.
2. Deliver US2 to keep map controls responsive during movement.
3. Deliver US3 to harden resizing, longer sessions, and imagery-delay behavior.
4. Finish Polish with the full quickstart validation pass.

### Validation Summary

- **US1**: 30-second continuous drag and repeated zoom with visible feedback within 100 ms and no freeze above 150 ms.
- **US2**: Zoom, recenter, and current-location controls respond during or immediately after map movement in 100% of validation attempts.
- **US3**: 60-second mixed interaction, resize, and slow/unavailable imagery checks remain interactive and visually stable.

## Notes

- `[P]` tasks use different files and can be parallelized without same-file conflicts.
- Story labels map tasks back to the prioritized user stories in `spec.md`.
- Keep public OSM attribution and avoid public-tile offline prefetching.
- Commit after each task or logical group when using the optional git hook.
