# Quickstart: Smooth Map Movement

## Prerequisites

- Flutter stable installed with Windows desktop support enabled.
- Network access for online OSM tiles during validation.
- A representative desktop window size: at least one wide layout and one compact
  layout below the app's panel breakpoint.

## Implementation Checklist

1. Run dependency setup:

   ```powershell
   flutter pub get
   ```

2. Refactor the map screen so map camera movement does not notify the broad
   screen listener on every `onPositionChanged` event.
3. Keep the tile layer and tile provider configuration stable for the map
   viewport lifetime.
4. Keep built-in tile caching enabled for non-web desktop usage.
5. Tune tile behavior conservatively:
   - Start with current/default `panBuffer` behavior.
   - Increase `keepBuffer` only if profiling shows blank tiles during desktop
     panning without memory or request pressure.
   - Avoid emulated retina mode for direct OSM tiles.
   - Consider instant or shorter tile fade display if fade animation shows up
     as jank in profile mode.
6. Keep current-location lookup asynchronous and non-blocking.
7. Preserve attribution, zoom controls, recenter, current-location, and inactive
   future control areas.

## Manual Validation

1. Run analyzer before profile validation:

   ```powershell
   flutter analyze
   ```

2. Run the app in profile mode:

   ```powershell
   flutter run -d windows --profile
   ```

   A profile build can also be used as a compile check before interactive
   validation:

   ```powershell
   flutter build windows --profile
   ```

3. Enable the performance overlay from DevTools or by pressing `P` in the
   running Flutter console when available.
4. Confirm the main map is usable within 3 seconds.
5. Drag continuously in multiple directions for 30 seconds.
6. Alternate drag, pointer zoom, zoom buttons, recenter, and current-location
   for 60 seconds.
7. Resize the window to compact and wide layouts, then repeat a short drag and
   zoom pass.
8. Temporarily disconnect or throttle the network if possible, then confirm
   loading or missing imagery does not block drag or zoom.
9. Record:
   - First usable map time.
   - Whether visible feedback appears within 100 ms.
   - Longest visible freeze observed.
   - Whether UI or raster graphs show red bars during gestures.
   - Whether controls respond during or immediately after movement.

## Acceptance Evidence

- Short screen recording or screenshots showing ready, interacting, loading or
  unavailable imagery, and current-location states.
- Profile-mode notes with any observed jank bars or visible freezes.
- Reviewer confirmation that the inactive side panel does not rebuild or block
  gestures during continuous map movement.

## Implementation Validation Notes

- 2026-05-16: `flutter analyze` passed with no issues after implementation.
- 2026-05-16: `flutter build windows --profile` completed successfully and
  produced `build/windows/x64/runner/Profile/vietnam_map_flutter.exe`.
- 2026-05-16: Live drag/zoom profiling still requires an interactive desktop
  session so pointer movement, window resizing, and performance overlay evidence
  can be observed directly.

## Policy Notes

- Keep a specific `userAgentPackageName` for public OSM requests.
- Keep visible OSM attribution.
- Do not add offline downloads or background prefetching from public OSM tiles.
- If production usage outgrows public OSM tile expectations, plan a separate
  feature for a permitted hosted, self-hosted, MBTiles, or PMTiles tile source.
