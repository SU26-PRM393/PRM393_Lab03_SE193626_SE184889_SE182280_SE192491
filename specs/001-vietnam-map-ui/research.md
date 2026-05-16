# Research: Desktop Viet Nam Map UI

## Decision: Flutter + Material 3 For Desktop Shell

**Rationale**: Flutter provides one desktop codebase for Windows, macOS, and
Linux. Material 3 gives a consistent component system for controls, surfaces,
states, typography, and accessibility. The UI-first scope benefits from
Material 3's built-in desktop-compatible controls and theming.

**Alternatives considered**:
- Native Windows/macOS/Linux UI: rejected because it would split the UI work
  across multiple platforms too early.
- Web desktop shell: rejected because the requested deliverable is a desktop
  application.

## Decision: `flutter_map` For Map Engine

**Rationale**: `flutter_map` supports Flutter desktop platforms and is a
pure-Flutter, vendor-flexible map client. It supports raster tile layers,
markers, polygons, camera control, and interactive map gestures that match the
UI-first requirements.

**Alternatives considered**:
- Google Maps Flutter: rejected because the requested stack names OSM and
  `flutter_map`, and Google Maps would add provider lock-in and API setup.
- Custom map renderer: rejected because it would add high complexity before the
  product needs custom rendering.

## Decision: `latlong2` For Coordinate Values

**Rationale**: `latlong2` is the coordinate utility used by the selected map
stack and provides latitude/longitude value types and distance calculations.
This keeps map center, current location, and future administrative-area geometry
consistent.

**Alternatives considered**:
- Custom coordinate model only: rejected because it would duplicate common
  coordinate handling and complicate `flutter_map` integration.

## Decision: OpenStreetMap Raster Tiles For Online Basemap

**Rationale**: OSM aligns with the requested stack and provides the base map for
the initial interactive UI. The plan must include visible attribution, correct
tile URL, valid app identification, and policy-compliant caching.

**Alternatives considered**:
- Commercial OSM-derived tile provider: deferred until usage volume, styling,
  and production constraints are clearer.
- Self-hosted tiles immediately: rejected for the first UI slice because it
  would delay the desktop interaction work.

## Decision: Geofabrik Vietnam Extract For Future Vietnam Data

**Rationale**: Geofabrik provides Vietnam OSM extracts including current PBF and
Shapefile/GPKG-style assets. It is a practical source for later local province,
city, district, and boundary preparation.

**Alternatives considered**:
- Manual administrative-area data entry: rejected because it is error-prone and
  hard to update.
- Live Overpass/API queries: rejected for this UI-first feature and not needed
  before filter/search/sort behavior exists.

## Decision: GeoJSON/Shapefiles As Boundary Input Formats

**Rationale**: GeoJSON is convenient for app-side boundary assets after
preprocessing, while Shapefiles are common in Geofabrik-style administrative
datasets. The feature should reserve adapter boundaries without requiring
rendered admin overlays in the first UI slice.

**Alternatives considered**:
- Render no boundary data concept at all: rejected because future controls for
  province/city/district need an explicit data path.

## Decision: MBTiles Or PMTiles Reserved For Future Offline Tiles

**Rationale**: MBTiles is a SQLite-based tile container suitable for local disk
access. PMTiles is a single-file archive format designed for efficient tile
access and static hosting patterns. Public OSM tile servers do not permit
offline/prefetch use, so future offline tiles must come from a self-hosted or
explicitly permitted source.

**Alternatives considered**:
- Prefetch OSM public tiles: rejected because it violates OSM tile policy.
- No offline tile concept: rejected because the requested stack explicitly
  includes MBTiles or PMTiles.

## Decision: `geolocator` For Current Location

**Rationale**: The feature needs a current-location state, and `geolocator`
supports Flutter desktop platforms through endorsed platform packages. The
implementation must handle denied, unavailable, and delayed location states
without blocking map exploration.

**Alternatives considered**:
- Manual mock-only current location: rejected because the feature asks to show
  current location, though mock fallback can still support demos.
- IP-based location only: rejected because it is less precise and has different
  privacy expectations.

## References

- Flutter Material 3 default and theming guidance:
  https://docs.flutter.dev/release/breaking-changes/material-3-default
- `flutter_map` package and supported platforms:
  https://pub.dev/packages/flutter_map
- `flutter_map` documentation:
  https://docs.fleaflet.dev/
- `latlong2` package and coordinate utilities:
  https://pub.dev/packages/latlong2
- OpenStreetMap tile usage policy:
  https://operations.osmfoundation.org/policies/tiles/
- Geofabrik Vietnam extract listing:
  https://download.geofabrik.de/asia/vietnam.html
- MBTiles 1.3 specification:
  https://github.com/mapbox/mbtiles-spec/blob/master/1.3/spec.md
- PMTiles concepts:
  https://docs.protomaps.com/pmtiles/
- `geolocator` package and desktop support:
  https://pub.dev/packages/geolocator
