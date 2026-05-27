# Validation Notes: Vietnam Boundary Hover Map

## Setup Baseline

- `flutter pub get`: Passed. No new runtime dependency was added for the
  overlay-based map scope implementation.
- Asset registration: `pubspec.yaml` already registers
  `lib/features/vietnam_map/assets/boundaries/`.
- Current map appearance baseline: The existing map uses `flutter_map` with the
  OSM raster tile URL, `NetworkTileProvider`, visible OSM attribution, 60 ms
  tile fade-in, current-location marker support, status banners, and overlay
  controls. The implementation must keep that base layer and surrounding
  controls recognizable.

## US1 Scope

- Implementation complete. The existing OSM tile layer, tile provider,
  attribution, tile display settings, and current map controls remain in
  `lib/features/vietnam_map/presentation/widgets/map_viewport.dart`.
- User feedback update: outside Viet Nam is now masked with an opaque neutral
  color instead of a translucent fade.
- Non-interactive verification: Windows debug build passed with the new
  boundary assets.
- Manual visual validation for initial view, border panning, screenshot, and
  profile-mode border panning is still pending.

## US2 Labels

- Implementation complete. Island label overrides use `Quan dao Hoang Sa` and
  the requested Vietnamese Truong Sa label from local overlay data and render
  above the base map.
- Non-interactive verification: analyzer and Windows debug build passed.
- Manual visual validation for old-label coverage and screenshots is still
  pending.

## US3 Hover

- Implementation complete. Province hover uses cached boundary data,
  isolate-backed GeoJSON parsing, bbox-first candidate filtering,
  point-in-polygon checks, and one active outline overlay.
- User feedback update: province boundaries are visible by default, hover uses
  `flutter_map` native pointer callbacks, and clicking a province shows only
  that province's lower-level places from the packaged lower-level point asset.
- Non-interactive verification: analyzer and Windows debug build passed.
- Manual hover walkthrough, adjacent transition checks, and profile-mode hover
  timing are still pending.

## Accessibility

- Overlay labels use semantics labels, hover outlines use a white halo plus a
  high-contrast stroke, and existing controls keep their current accessible
  widgets. Manual keyboard/screen-reader review is still pending.

## Visual Comparison

- Source review confirms the base map appearance is preserved by keeping the
  existing OSM raster tile source and adding overlays only. Screenshot or
  recording comparison is still pending.

## Profile Evidence

- 2026-05-27: Startup smoothing implementation moved Isar initialization and
  administrative JSON import behind the first rendered frame, added profile/debug
  timeline spans for startup/import/boundary/search/hover/overlay paths, deferred
  lower-level boundary loading, cached search results and map polygons, and
  throttled hover resolution to once per frame.
- 2026-05-27: `flutter analyze` passed with no issues after the startup
  smoothing changes.
- 2026-05-27: `flutter test` passed, including new focused coverage for
  import-needed planning, cached search invalidation, and frame-throttled hover
  resolution.
- 2026-05-27: `flutter build windows --debug` and
  `flutter build windows --profile` both completed successfully.
- 2026-05-27: Interactive cold/warm launch timing and 60-second profile-mode
  walkthrough remain pending because they require a live desktop session.
- `dart format`: Passed with no file changes after the province drill-down
  update.
- `flutter analyze`: Passed with no issues after the province drill-down and
  island label asset updates.
- `flutter test`: Passed after replacing the stale default counter smoke test
  with a current map shell smoke test.
- `flutter build windows --debug`: Passed after the province drill-down and
  island label asset updates.
- Profile-mode runtime walkthrough is still pending because it requires an
  interactive desktop session.
