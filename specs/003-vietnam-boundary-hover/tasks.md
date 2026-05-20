# Tasks: Vietnam Boundary Hover Map

**Input**: Design documents from `/specs/003-vietnam-boundary-hover/`

**Prerequisites**: [plan.md](./plan.md), [spec.md](./spec.md),
[research.md](./research.md), [data-model.md](./data-model.md),
[map-scope-hover-contract.md](./contracts/map-scope-hover-contract.md),
[quickstart.md](./quickstart.md)

**Quality Gates**: Code quality, manual verification, UX consistency, visual
polish, accessibility, and performance validation are required. Automated tests
are not required for this feature.

**Organization**: Tasks are grouped by user story so the Viet Nam-only map MVP
can be implemented and verified before island label replacement and province
hover outlines are added.

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Prepare local validation notes, asset registration, and current
appearance baseline before implementation starts.

- [X] T001 Run `flutter pub get` for `pubspec.yaml` and confirm no new runtime dependency is needed for the overlay-based map scope plan
- [X] T002 Create `specs/003-vietnam-boundary-hover/validation-notes.md` with sections for setup baseline, US1 scope, US2 labels, US3 hover, accessibility, visual comparison, and profile evidence
- [X] T003 [P] Record the current map appearance baseline from `lib/features/vietnam_map/presentation/widgets/map_viewport.dart` in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [X] T004 [P] Verify `pubspec.yaml` registers `lib/features/vietnam_map/assets/boundaries/` and document the result in `specs/003-vietnam-boundary-hover/validation-notes.md`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Establish geometry assets, domain models, cached loading, and map
constants used by all user stories.

**CRITICAL**: No user story work can begin until this phase is complete.

- [X] T005 Add simplified Viet Nam country-scope geometry in `lib/features/vietnam_map/assets/boundaries/vietnam_scope.geojson`
- [X] T006 Add simplified province-level boundary geometry matching existing province codes in `lib/features/vietnam_map/assets/boundaries/province_boundaries.geojson`
- [X] T007 [P] Create boundary geometry domain types in `lib/features/vietnam_map/domain/map_boundary.dart`
- [X] T008 [P] Create Viet Nam map scope domain state in `lib/features/vietnam_map/domain/map_scope.dart`
- [X] T009 [P] Create province hover domain state in `lib/features/vietnam_map/domain/province_hover_state.dart`
- [X] T010 [P] Create island label override domain state in `lib/features/vietnam_map/domain/island_label_override.dart`
- [X] T011 Update `lib/features/vietnam_map/domain/administrative_area.dart` to expose province-level boundary metadata needed for matching `province_boundaries.geojson`
- [X] T012 Implement cached GeoJSON asset parsing for scope, province boundaries, and label overrides in `lib/features/vietnam_map/data/admin_boundary_source.dart`
- [X] T013 Add map scope bounds, hover response budget, overlay stroke style, neutral mask style, and island label anchors in `lib/shared/constants/map_constants.dart`
- [X] T014 Load boundary data once and expose map scope, island labels, province boundaries, and unavailable-data state in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`

**Checkpoint**: Foundation ready; user story implementation can now begin.

---

## Phase 3: User Story 1 - View Only Viet Nam On The Map (Priority: P1) MVP

**Goal**: The current-style map remains focused on Viet Nam and does not expose
neighboring-country geography or labels during normal pan and zoom.

**Independent Validation**: Open the map, pan and zoom around mainland, coastal,
and island areas, and confirm no other country geography or labels are visible
while the existing map appearance is preserved inside Viet Nam.

### Implementation for User Story 1

- [X] T015 [US1] Add Viet Nam camera bounds and edge handling to `lib/features/vietnam_map/domain/map_view_state.dart`
- [X] T016 [US1] Apply Viet Nam-focused camera constraints in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [X] T017 [P] [US1] Implement outside-scope neutral masking in `lib/features/vietnam_map/presentation/widgets/map_scope_overlay.dart`
- [X] T018 [US1] Integrate `MapScopeOverlay` above the existing tile layer and below existing controls in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [X] T019 [US1] Add non-blocking unavailable-scope fallback handling in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [X] T020 [US1] Preserve existing OSM tile source, attribution, tile provider, and tile display settings in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`

### Manual Validation for User Story 1

- [X] T021 [US1] Run `dart format` and `flutter analyze` for `lib/features/vietnam_map/domain/`, `lib/features/vietnam_map/data/admin_boundary_source.dart`, `lib/features/vietnam_map/presentation/`, and `lib/shared/constants/map_constants.dart`
- [ ] T022 [US1] Validate initial view and northern, western, and southwestern border panning using `specs/003-vietnam-boundary-hover/quickstart.md`
- [ ] T023 [US1] Capture screenshot or short recording of Viet Nam-only scope and current map appearance preservation in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [ ] T024 [US1] Profile 30 seconds of border panning in `flutter run -d windows --profile` and record feedback/freezing notes in `specs/003-vietnam-boundary-hover/validation-notes.md`

**Checkpoint**: User Story 1 is fully functional and manually verified as the
MVP.

---

## Phase 4: User Story 2 - See Requested Island Group Labels (Priority: P2)

**Goal**: The island groups display the requested labels without changing the
current base map style.

**Independent Validation**: Navigate to the island group areas and confirm
`Quan dao Hoang Sa` and `Quan đao Trường Sa` are shown while `Paracel Islands`
and `Spratly Islands` are not visible in supported views.

### Implementation for User Story 2

- [X] T025 [P] [US2] Add the exact `Quan dao Hoang Sa` and `Quan đao Trường Sa` label override definitions in `lib/features/vietnam_map/domain/island_label_override.dart`
- [X] T026 [US2] Implement replacement labels and small legacy-label covers in `lib/features/vietnam_map/presentation/widgets/island_label_overlay.dart`
- [X] T027 [US2] Integrate `IslandLabelOverlay` above the base map and below existing controls in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [X] T028 [US2] Ensure island label overlay loading failure is non-crashing and reported through `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [X] T029 [US2] Preserve attribution, zoom controls, current-location controls, and status banners while label overlays are visible in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`

### Manual Validation for User Story 2

- [X] T030 [US2] Run `dart format` and `flutter analyze` for `lib/features/vietnam_map/domain/island_label_override.dart`, `lib/features/vietnam_map/presentation/widgets/island_label_overlay.dart`, `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`, and `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [ ] T031 [US2] Validate Hoang Sa and Truong Sa label replacement using `specs/003-vietnam-boundary-hover/quickstart.md`
- [ ] T032 [US2] Capture screenshot or short recording proving the requested labels are visible and old English labels are hidden in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [ ] T033 [US2] Verify label overlays do not cover attribution or map controls and record the result in `specs/003-vietnam-boundary-hover/validation-notes.md`

**Checkpoint**: User Stories 1 and 2 work independently and together.

---

## Phase 5: User Story 3 - Highlight Province Boundary On Hover (Priority: P3)

**Goal**: Hovering over a province-level area shows one thin, readable boundary
outline without selecting data or changing the current map appearance.

**Independent Validation**: Move the mouse across multiple province-level areas
and confirm the current area's outline appears, updates, and clears correctly
within the hover performance budget.

### Implementation for User Story 3

- [X] T034 [P] [US3] Implement bbox-first province hit testing and point-in-polygon containment in `lib/features/vietnam_map/domain/province_hover_state.dart`
- [X] T035 [US3] Add hover state update methods for pointer enter, move, and exit in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [X] T036 [US3] Capture pointer movement over the map and convert pointer position to map coordinates in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [X] T037 [P] [US3] Implement thin high-contrast province outline rendering in `lib/features/vietnam_map/presentation/widgets/province_hover_outline.dart`
- [X] T038 [US3] Integrate `ProvinceHoverOutline` above the base map and below existing controls in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [X] T039 [US3] Ensure hover state clears over water, outside eligible areas, pointer exit, unavailable boundary data, and active drag gestures in `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`
- [X] T040 [US3] Keep search, filter, sort, current-location, zoom, attribution, and drag interactions unchanged while hover outlines are active in `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`

### Manual Validation for User Story 3

- [X] T041 [US3] Run `dart format` and `flutter analyze` for `lib/features/vietnam_map/domain/province_hover_state.dart`, `lib/features/vietnam_map/presentation/vietnam_map_controller.dart`, `lib/features/vietnam_map/presentation/widgets/province_hover_outline.dart`, and `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`
- [ ] T042 [US3] Validate hover outlines on at least 10 province-level areas using `specs/003-vietnam-boundary-hover/quickstart.md`
- [ ] T043 [US3] Validate adjacent province transitions, water hover, pointer exit, and unavailable-data behavior using `specs/003-vietnam-boundary-hover/contracts/map-scope-hover-contract.md`
- [ ] T044 [US3] Profile 60 seconds of mixed drag, zoom, hover, current-location control, and resize interaction in `flutter run -d windows --profile`, then record hover latency and freeze notes in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [ ] T045 [US3] Capture screenshot or short recording of province hover outlines on multiple areas in `specs/003-vietnam-boundary-hover/validation-notes.md`

**Checkpoint**: All selected user stories work independently and the feature is
complete.

---

## Phase 6: Polish & Cross-Cutting Concerns

**Purpose**: Final quality review across map appearance, accessibility,
performance, documentation, and task evidence.

- [X] T046 [P] Update `specs/003-vietnam-boundary-hover/quickstart.md` with any final validation command notes discovered during implementation
- [X] T047 [P] Review public OSM attribution and no-prefetch policy in `lib/shared/constants/map_constants.dart` and `lib/features/vietnam_map/data/map_tile_source.dart`
- [X] T048 Review all new overlay widgets for visual consistency, text legibility, and no control overlap in `lib/features/vietnam_map/presentation/widgets/`
- [X] T049 Review accessible names, keyboard/button access, contrast, and text scaling for affected map controls and overlays in `lib/features/vietnam_map/presentation/`
- [X] T050 Run final `dart format` and `flutter analyze` for `pubspec.yaml`, `analysis_options.yaml`, `lib/`, and `windows/`, then record results in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [ ] T051 Run the full validation walkthrough from `specs/003-vietnam-boundary-hover/quickstart.md` and record final acceptance evidence in `specs/003-vietnam-boundary-hover/validation-notes.md`
- [ ] T052 Compare final app screenshots against the setup baseline and record whether the current map appearance was preserved in `specs/003-vietnam-boundary-hover/validation-notes.md`

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies; start immediately.
- **Foundational (Phase 2)**: Depends on Setup completion; blocks all user stories.
- **User Story 1 (Phase 3)**: Depends on Foundational; suggested MVP.
- **User Story 2 (Phase 4)**: Depends on Foundational and can be validated after US1 map scope is stable.
- **User Story 3 (Phase 5)**: Depends on Foundational and can be integrated after US1 overlay ordering is established.
- **Polish (Phase 6)**: Depends on all desired user stories being complete.

### User Story Dependencies

- **US1 View Only Viet Nam On The Map**: Can start after Foundational and delivers the MVP.
- **US2 See Requested Island Group Labels**: Can start after Foundational, but final visual checks should run with US1 masking active.
- **US3 Highlight Province Boundary On Hover**: Can start after Foundational, but final integration should reuse US1 overlay ordering.

### Parallel Opportunities

- T003 and T004 can run in parallel during Setup because they update different validation concerns.
- T007, T008, T009, and T010 can run in parallel during Foundation because they create separate domain files.
- T017 can run in parallel with T015/T016 once the scope model exists because it creates a separate overlay widget.
- T025 can run in parallel with US2 overlay rendering because it updates label definitions before integration.
- T034 and T037 can run in parallel during US3 because hit testing and outline rendering are in separate files.
- T046 and T047 can run in parallel during Polish because they update different documentation/source paths.

## Parallel Execution Examples

### User Story 1

```text
Task A: T015 [US1] Add Viet Nam camera bounds and edge handling to lib/features/vietnam_map/domain/map_view_state.dart
Task B: T017 [P] [US1] Implement outside-scope neutral masking in lib/features/vietnam_map/presentation/widgets/map_scope_overlay.dart
```

### User Story 2

```text
Task A: T025 [P] [US2] Add label override definitions in lib/features/vietnam_map/domain/island_label_override.dart
Task B: T026 [US2] Implement replacement labels and covers in lib/features/vietnam_map/presentation/widgets/island_label_overlay.dart
```

### User Story 3

```text
Task A: T034 [P] [US3] Implement bbox-first province hit testing in lib/features/vietnam_map/domain/province_hover_state.dart
Task B: T037 [P] [US3] Implement province outline rendering in lib/features/vietnam_map/presentation/widgets/province_hover_outline.dart
```

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup.
2. Complete Phase 2: Foundational.
3. Complete Phase 3: User Story 1.
4. Stop and manually validate Viet Nam-only scope and current map appearance.
5. Demo or continue only after the US1 quality gates pass.

### Incremental Delivery

1. Deliver US1 to enforce the Viet Nam-only visible map scope.
2. Deliver US2 to replace island labels while preserving the current base map.
3. Deliver US3 to add province hover outlines without adding selection or details.
4. Finish Polish with full quickstart validation and profile evidence.

### Manual Verification Summary

- **US1**: Initial view and border panning show only Viet Nam, with current map appearance preserved inside the visible scope.
- **US2**: Hoang Sa and Truong Sa labels show the requested text, and old English labels are hidden in supported views.
- **US3**: Hovering at least 10 province-level areas shows correct outlines within 100 ms and clears correctly outside eligible areas.

## Notes

- `[P]` tasks use different files and can be parallelized without same-file conflicts.
- Story labels map tasks back to the prioritized user stories in `spec.md`.
- Keep the existing OSM raster tile appearance; overlays should be the only visible change.
- Keep public OSM attribution visible and avoid public-tile offline prefetching.
- Commit after each task or logical group when using the optional git hook.
