# Quickstart: Vietnam Boundary Hover Map

## Prerequisites

- Flutter stable with Dart 3.x.
- Windows desktop target enabled for primary validation.
- Local boundary assets available under
  `lib/features/vietnam_map/assets/boundaries/`:
  - `vietnam_scope.geojson`
  - `province_boundaries.geojson`

## Local Validation

1. Install dependencies.

   ```powershell
   flutter pub get
   ```

2. Check code quality after implementation.

   ```powershell
   dart format lib
   flutter analyze
   ```

3. Run the desktop app in profile mode.

   ```powershell
   flutter run -d windows --profile
   ```

4. For a non-interactive compile check, build the Windows debug target.

   ```powershell
   flutter build windows --debug
   ```

5. Confirm the current map appearance is preserved.

   - Compare the base map inside Viet Nam with the current app before this
     feature.
   - Confirm roads, water, base labels, controls, attribution, current-location
     UI, and inactive search/filter/sort areas still look like the current app.
   - Expected visible differences are limited to outside-Viet Nam masking,
     island label overrides, and province hover outlines.

6. Validate Viet Nam-only scope.

   - Open the initial map view and confirm Viet Nam is the only country shown.
   - Pan toward northern, western, and southwestern borders.
   - Zoom in and out near border areas.
   - Confirm no neighboring-country land, border, place label, or country name
     is visible in the application map view.

7. Validate island labels.

   - Navigate to the Hoang Sa island group area and confirm the label reads
     `Quan dao Hoang Sa`.
   - Navigate to the Truong Sa island group area and confirm the label reads
     `Quan đao Trường Sa`.
   - Confirm `Paracel Islands` and `Spratly Islands` are not visible where the
     replacement labels are shown.

8. Validate province hover outlines.

   - Confirm the default map shows province-level boundaries before any
     province is selected.
   - Hover over at least 10 province-level areas, including both provinces and
     centrally governed cities.
   - Confirm one outline appears within 100 ms and matches the hovered area.
   - Move between adjacent province-level areas and confirm the outline updates
     without leaving stale outlines.
   - Hover over water or outside eligible areas and confirm the outline clears.
   - Click a province and confirm lower-level places for that province appear.
   - Click another province and confirm lower-level places update to that
     province.
   - Click water or neutral outside-map space and confirm lower-level places
     clear.

9. Validate performance and responsiveness.

   - Enable the Flutter performance overlay or use DevTools Performance view.
   - Perform 30 seconds of border panning.
   - Perform 60 seconds of mixed drag, zoom, hover, current-location control,
     and window resizing.
   - Confirm no user-visible freeze longer than 150 ms and no progressive
     slowdown.

## Evidence To Capture

- Screenshot or short recording showing the current-style map with outside
  geography hidden.
- Screenshot or short recording showing the two requested island labels.
- Screenshot or short recording showing province hover outlines on multiple
  areas.
- Profile-mode notes confirming hover response and gesture smoothness meet the
  planned budgets.
