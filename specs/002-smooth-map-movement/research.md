# Research: Smooth Map Movement

## Decision: Keep `flutter_map` 8.3.0 As The Map Engine

**Rationale**: The app already uses `flutter_map` 8.3.0, which supports the
needed desktop raster tile map, camera control, markers, tile buffering, tile
display behavior, and built-in tile caching. The reported lag can be addressed
inside the current stack before replacing the map engine.

**Alternatives considered**:
- Replace the map engine: rejected because it would add provider and migration
  risk before proving the current lag is caused by engine limits.
- Build a custom renderer: rejected because it adds high complexity and would
  delay the immediate smoothing request.

## Decision: Remove High-Frequency Camera Updates From Broad Rebuilds

**Rationale**: The current controller calls listeners for every map position
change, and the screen listens with one broad `AnimatedBuilder`. During dragging
and zooming this can rebuild the map, side panel, overlays, and tile layer many
times per second. The first smoothing pass should update the internal viewport
state without notifying the whole screen on every camera tick, then notify only
for meaningful low-frequency UI state changes such as ready, source
unavailable, location requesting/available, and programmatic movement.

**Alternatives considered**:
- Keep all position updates observable: rejected because it keeps expensive UI
  work on the gesture path.
- Add a global state-management package: rejected because the problem is local
  to map viewport and controller notification boundaries.

## Decision: Keep Tile Layer And Tile Provider Stable Across Interaction

**Rationale**: `flutter_map` documentation recommends manually setting up tile
provider behavior when tile layers are rebuilt frequently, because recreating
the provider/client can cause performance issues or glitches. The plan should
make the map viewport less volatile first, then keep tile-layer configuration
stable for the lifetime of the map widget.

**Alternatives considered**:
- Let a new tile provider be created on every rebuild: rejected because the map
  screen currently rebuilds too often during gestures.
- Introduce a separate cancellable tile provider package: rejected for this
  stack because `flutter_map` 8.3.0 already includes native request cancellation
  support through its current network tile provider path.

## Decision: Use Built-In Tile Caching, Not Public OSM Prefetch

**Rationale**: `flutter_map` 8.2 and later enable built-in tile caching by
default on non-web platforms, reducing duplicate tile requests and improving
tile loading durations. This fits the desktop target and public OSM policy
better than custom prefetching. The feature must not download public OSM tiles
for offline use.

**Alternatives considered**:
- Add offline tile downloads from public OSM: rejected because public OSM tiles
  are for interactive use and the existing plan prohibits offline/prefetch use.
- Add a full offline MBTiles/PMTiles pipeline now: rejected because the current
  request is smoother interaction, not offline map packaging.

## Decision: Tune Tile Display And Buffers Conservatively

**Rationale**: `TileLayer` supports `keepBuffer`, `panBuffer`, and
`tileDisplay`. A moderate keep buffer can reduce visible blank tiles during
desktop panning, while excessive pan buffering can slow visible tile requests
and increase tile-server load. The plan should start from defaults, measure,
then tune within small bounds. Avoid emulated retina mode for OSM direct tiles
because emulation can multiply tile requests and reduce readability.

**Alternatives considered**:
- Increase `panBuffer` aggressively: rejected because documentation warns high
  values can slow all tile requests and increase tile-server load.
- Force high-density emulated retina tiles: rejected because it creates more
  requests and may make labels harder to read.

## Decision: Keep Location Requests Off The Gesture Path

**Rationale**: Current location lookup can take seconds and may require platform
permission. It should remain asynchronous and must not block panning, zooming,
or tile loading. The map may recenter when a location arrives, but active user
movement should remain responsive.

**Alternatives considered**:
- Request location synchronously before map use: rejected because it blocks the
  primary map exploration journey.
- Remove current-location behavior: rejected because it is part of the existing
  map screen contract.

## Decision: Validate In Flutter Profile Mode With Frame Evidence

**Rationale**: Flutter debug mode is not representative of release behavior and
can add jank. Profile mode plus the performance overlay or DevTools Performance
view provides appropriate evidence for UI and raster thread behavior during map
gestures.

**Alternatives considered**:
- Validate only by subjective debug-mode use: rejected because performance
  regressions need profile-mode evidence.
- Require automated benchmarks now: rejected because the project constitution
  allows manual/profile evidence and this is a small desktop UI performance
  improvement.

## References

- `flutter_map` Tile Layer documentation:
  https://docs.fleaflet.dev/layers/tile-layer
- `flutter_map` Tile Providers documentation:
  https://docs.fleaflet.dev/layers/tile-layer/tile-providers
- `flutter_map` Caching documentation:
  https://docs.fleaflet.dev/layers/tile-layer/caching
- `flutter_map` `TileLayer` API:
  https://pub.dev/documentation/flutter_map/latest/flutter_map/TileLayer-class.html
- Flutter performance profiling:
  https://docs.flutter.dev/perf/ui-performance
- `flutter_map_cancellable_tile_provider` deprecation note:
  https://pub.dev/documentation/flutter_map_cancellable_tile_provider/latest/
- OpenStreetMap direct tile guidance:
  https://docs.fleaflet.dev/tile-servers/using-openstreetmap-direct
