# Data Model: Desktop Viet Nam Map UI

## MapViewport

Represents the user's current map camera and interaction state.

**Fields**
- `center`: latitude/longitude coordinate for the current viewport center
- `zoom`: current zoom level
- `minZoom`: lowest allowed zoom level
- `maxZoom`: highest allowed zoom level
- `isDragging`: whether a drag gesture is active
- `lastInteractionAt`: timestamp of the most recent pan or zoom action

**Validation Rules**
- `center` must be a valid latitude/longitude pair.
- `zoom` must remain between `minZoom` and `maxZoom`.
- Initial center must focus on Viet Nam geography.

**State Transitions**
- Initial -> Ready when the map has a usable center and tile layer.
- Ready -> Interacting while drag or zoom input is active.
- Interacting -> Ready after input settles.
- Ready -> Error only when the map cannot display a usable basemap.

## MapTileSource

Represents the basemap tile source currently used by the map.

**Fields**
- `name`: display name for the source
- `type`: online OSM, local MBTiles, local PMTiles, or placeholder
- `urlTemplate`: online tile URL template when applicable
- `attribution`: visible attribution text
- `cachePolicy`: caching expectation for the source
- `supportsOffline`: whether the source permits offline use

**Validation Rules**
- Online OSM source must display attribution.
- Online OSM source must not be used for offline/prefetch behavior.
- Offline tile sources must come from explicit local or permitted provider
  assets.

## CurrentLocationState

Represents current-location availability and display.

**Fields**
- `status`: unknown, requesting, available, denied, unavailable, error
- `coordinate`: latitude/longitude coordinate when available
- `accuracyMeters`: optional accuracy radius
- `message`: user-facing state message
- `lastUpdatedAt`: timestamp for the last successful location update

**Validation Rules**
- `coordinate` is required only when status is available.
- Unavailable, denied, and error statuses must provide a user-facing message.
- Location failure must not block map pan/zoom.

**State Transitions**
- Unknown -> Requesting when location is requested.
- Requesting -> Available when a coordinate is returned.
- Requesting -> Denied when permission is denied.
- Requesting -> Unavailable when location service cannot return a coordinate.
- Requesting -> Error when an unexpected failure occurs.

## AdministrativeAreaControlSpace

Represents the UI-only area reserved for future province/city/district tools.

**Fields**
- `searchText`: visible placeholder or inactive text field value
- `selectedLevel`: province, city, district, or all
- `sortOption`: inactive selected sort placeholder
- `filterChips`: inactive filter placeholders
- `isFunctional`: always false for this feature

**Validation Rules**
- `isFunctional` must remain false in this UI-first feature.
- Controls must not modify map content, selected areas, or displayed data.
- Controls must remain visible and readable at common desktop window sizes.

## AdministrativeArea

Represents future province, city, or district data.

**Fields**
- `id`: stable source identifier
- `name`: display name
- `level`: province, city, district, or other administrative level
- `boundarySource`: GeoJSON, Shapefile-derived, or placeholder
- `geometry`: optional boundary geometry for future overlays

**Validation Rules**
- This feature may define the entity but must not require populated
  administrative data.
- Later filtering/searching/sorting features must populate `id`, `name`, and
  `level` before user-facing behavior is enabled.
