# Quickstart: Desktop Viet Nam Map UI

## Prerequisites

- Flutter stable installed with desktop support enabled.
- Windows desktop target available for local validation. macOS/Linux can be
  validated later if those environments are available.
- Network access for online OpenStreetMap tiles during the first UI slice.

## Initial Project Setup

1. Create the Flutter desktop app in the repository root if `pubspec.yaml` does
   not exist yet.
2. Enable Material 3 theming in the app theme and define the desktop map color,
   typography, spacing, and component tokens.
3. Add the planned dependencies:
   - `flutter_map`
   - `latlong2`
   - `geolocator`
4. Add a visible OSM attribution string to the map surface.

## Map Stack Setup

1. Use `flutter_map` as the interactive map engine.
2. Use `latlong2` coordinates for Viet Nam center, current location, and future
   administrative-area geometry.
3. Use OSM raster tiles only for normal interactive viewing.
4. Do not add offline download or tile prefetch behavior from the public OSM
   tile service.
5. Reserve data adapters for future Geofabrik Vietnam extract processing,
   GeoJSON/Shapefile boundaries, and MBTiles or PMTiles offline tile assets.

## Manual Validation

1. Run the desktop app in profile or release mode.
2. Confirm the main map view appears within 3 seconds.
3. Drag the map in multiple directions.
4. Zoom in and out using pointer input and visible zoom controls.
5. Confirm OSM attribution remains visible.
6. Confirm the current-location indicator appears when location is available.
7. Disable or deny location access and confirm a non-blocking unavailable state.
8. Resize the desktop window and confirm the map, reserved controls, and utility
   controls remain visible and legible.
9. Interact with the reserved search, filter, and sort UI and confirm they do
   not change map content or data.
10. Capture screenshots or a short recording covering the ready, interaction,
    current-location, unavailable-location, and inactive-control states.

## Performance Notes

- Use Flutter DevTools or performance overlay while dragging and zooming.
- Record first usable map time from app launch to visible interactive map.
- Record whether visible pan/zoom response stays under the 200 ms requirement.

## Implementation Validation Notes

- 2026-05-16: Runtime validation is blocked in this environment because
  `flutter` and `dart` are not available on `PATH`.
- 2026-05-16: Source files, project metadata, and manual validation steps were
  prepared for execution on a machine with Flutter installed.

## Policy Notes

- Public OSM tiles require visible attribution and policy-compliant request
  behavior.
- Offline use must come from a self-hosted or explicitly permitted tile source,
  packaged as MBTiles or PMTiles in a later feature.
