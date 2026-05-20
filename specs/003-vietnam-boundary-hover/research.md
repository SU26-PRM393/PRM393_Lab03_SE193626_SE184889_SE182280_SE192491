# Research: Vietnam Boundary Hover Map

## Decision: Preserve the current raster basemap appearance

**Decision**: Keep the existing OSM raster tile source, tile provider,
attribution, controls, and Material 3 map layout as the base map.

**Rationale**: The user explicitly likes the current map appearance. Replacing
the basemap with vector tiles, a different tile provider, or an offline tile
package would likely change colors, roads, typography, water styling, and label
density. The requested behavior can be planned as overlays around the current
map instead.

**Alternatives considered**:

- Replace OSM raster tiles with custom vector tiles: rejected because it would
  change the appearance and add heavy data/style work.
- Package a full offline tile set: rejected because public OSM prefetch is not
  allowed and it would expand scope beyond hover and labels.
- Draw a fully custom Viet Nam map: rejected because it would discard the
  current interactive map appearance.

## Decision: Use a local Viet Nam scope mask plus camera constraints

**Decision**: Add a local Viet Nam scope geometry asset and combine it with map
camera bounds. The visible map remains the current tile layer, while non-Viet
Nam areas are hidden or neutralized by an overlay when the user pans near
borders.

**Rationale**: The current raster tile layer includes neighboring countries in
the tile images. Camera bounds alone reduce how far the user can pan, but they
cannot remove neighboring-country land and labels near border-adjacent views.
A neutral mask is the smallest appearance-preserving way to satisfy the
Viet Nam-only scope without changing the base map style inside Viet Nam.

**Alternatives considered**:

- Camera bounds only: rejected because border tiles can still show other
  countries.
- Change tile URL to a different country-only provider: rejected because it
  changes appearance and introduces provider uncertainty.
- Remove the base tile layer outside Viet Nam by tile filtering: rejected
  because raster tiles do not align with administrative boundaries.

## Decision: Use simplified local province GeoJSON for hover boundaries

**Decision**: Store simplified province-level boundary geometry as a packaged
GeoJSON asset and load it once through `AdminBoundarySource`. Match boundaries
to existing province metadata by stable province code or ID.

**Rationale**: Existing `provinces.json` contains province metadata, centroids,
bounds, and vertex counts, but not full coordinate rings for rendering or hit
testing. Hover outlines require actual geometry. A local asset keeps hover
responsive and avoids network dependency during pointer movement.

**Alternatives considered**:

- Query a remote boundary service on hover: rejected because pointer movement
  must be immediate and offline/poor-network behavior must remain usable.
- Use only province centroids or bounding boxes: rejected because outlines
  would not match the requested province region.
- Store province boundaries in Isar: rejected for this static read-only data;
  packaged assets are simpler and enough for the feature.

## Decision: Use bbox-first hit testing before polygon containment

**Decision**: For hover, first filter candidate provinces by bounding box, then
perform point-in-polygon checks only for those candidates. Cache parsed geometry
in memory while the map screen is alive.

**Rationale**: Pointer movement can fire frequently, and checking every polygon
ring for every movement risks jank. Bbox filtering keeps the expensive work
small while preserving accurate region outlines.

**Alternatives considered**:

- Check every polygon on every pointer move: rejected because it risks blocking
  the UI isolate.
- Add a spatial-index dependency immediately: rejected because the first pass
  can meet the feature scale with bbox filtering and simplified geometry.
- Highlight by nearest centroid: rejected because it can select the wrong
  province near borders or irregular coastlines.

## Decision: Replace island labels with an overlay, not a basemap change

**Decision**: Add fixed island label override data for `Quan dao Hoang Sa` and
`Quan đao Trường Sa`. Render those labels above the base map and neutralize any
visible baked-in English labels only in the small label area needed for the
replacement.

**Rationale**: The current basemap labels are part of raster tiles and cannot be
renamed directly. A small overlay preserves the current map appearance while
making the user-facing labels match the requested text.

**Alternatives considered**:

- Change OSM data or tile labels at runtime: rejected because raster tile text
  is baked into images.
- Switch to a custom label tile source: rejected because it changes appearance
  and broadens scope.
- Show both old and new labels: rejected because the spec requires the old
  labels not to be visible.

## Decision: Do not add province detail panels or selection behavior

**Decision**: Hover only shows a province outline. It does not open a detail
panel, select a province, filter data, or change inactive future controls.

**Rationale**: The user requested hover outlines, and earlier feature specs
explicitly keep search/filter/sort behavior out of scope. Keeping hover
presentation-only minimizes behavior changes and preserves the current screen.

**Alternatives considered**:

- Add province tooltip or click selection: rejected as outside the requested
  feature.
- Fill the province area on hover: rejected because it would alter the map
  appearance more than a boundary outline.
