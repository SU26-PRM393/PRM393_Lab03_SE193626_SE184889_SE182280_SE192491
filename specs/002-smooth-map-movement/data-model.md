# Data Model: Smooth Map Movement

## Map Viewport

Represents the user's current visible map context.

**Fields**:
- `center`: Current latitude/longitude at the center of the map.
- `zoom`: Current zoom level.
- `minZoom`: Lowest allowed zoom level.
- `maxZoom`: Highest allowed zoom level.
- `status`: Current viewport status: initial, ready, interacting, source
  unavailable, or loading imagery.
- `lastInteractionAt`: Time of the most recent user or programmatic map
  movement.
- `message`: Optional user-facing status message.

**Validation Rules**:
- `zoom` must be clamped between `minZoom` and `maxZoom`.
- `center` must only update from valid map camera or location coordinates.
- User gesture updates must not require a whole-screen rebuild.

**State Transitions**:
- `initial` -> `ready` when the map is ready.
- `ready` -> `interacting` while the user drags or zooms.
- `interacting` -> `ready` after interaction settles.
- `ready` or `interacting` -> `sourceUnavailable` when tile loading failures
  need a visible non-blocking status.

## Map Interaction Sample

Represents a lightweight measurement or observation during validation.

**Fields**:
- `startedAt`: Start time of the observed interaction.
- `endedAt`: End time of the observed interaction.
- `interactionType`: Drag, zoom, button zoom, recenter, current location, or
  window resize.
- `visibleFeedbackMs`: Estimated time until the user sees response.
- `longestVisibleFreezeMs`: Longest observed freeze in the sample.
- `notes`: Reviewer notes about jank, blank tiles, control response, or
  unexpected motion.

**Validation Rules**:
- Drag/zoom feedback should be at or below 100 ms in at least 95% of observed
  actions.
- No sample in the representative session should include a visible freeze above
  150 ms.

## Imagery Loading State

Represents user-visible map tile loading and failure feedback.

**Fields**:
- `state`: Loading, loaded, partially unavailable, or unavailable.
- `sourceName`: Name of the selected tile source.
- `message`: Optional non-blocking message shown on the map.
- `lastFailureAt`: Most recent tile failure time, when applicable.

**Validation Rules**:
- Loading or failure messages must not block drag, zoom, attribution, or map
  controls.
- Repeated tile failures must not trigger rebuild loops that make gestures
  slower.

## Map Control Area State

Represents controls that remain visible while the map moves.

**Fields**:
- `zoomControlsAvailable`: Whether zoom controls can be used.
- `currentLocationAvailable`: Whether current-location action can be requested.
- `recenterAvailable`: Whether recenter-on-Viet-Nam action can be used.
- `reservedControlsInactive`: Whether future search/filter/sort controls remain
  inactive.

**Validation Rules**:
- Zoom, current-location, and recenter controls must remain reachable while or
  immediately after the map moves.
- Reserved controls must not change data or block map gestures.

## Map Performance Settings

Represents the planned map rendering and tile behavior settings.

**Fields**:
- `notifyDuringGesture`: Whether broad listeners are notified during every
  camera update.
- `tileKeepBuffer`: Number of extra tile rows/columns retained before unload.
- `tilePanBuffer`: Number of surrounding tile rows/columns preloaded.
- `tileDisplayMode`: Instant or fade-in tile display behavior.
- `useBuiltInTileCache`: Whether compatible built-in tile caching remains
  enabled.
- `useRetinaMode`: Whether native retina tiles are requested.

**Validation Rules**:
- `notifyDuringGesture` should be false for broad screen listeners.
- `tilePanBuffer` should remain conservative, usually 0 or 1, unless profiling
  proves a higher value helps without slowing visible tiles.
- `useBuiltInTileCache` should remain true for online OSM desktop usage.
- `useRetinaMode` should not emulate retina tiles for OSM direct URLs that lack
  native high-density tile support.
