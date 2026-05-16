# VietNam-Map-Flutter

Desktop Viet Nam map UI built with Flutter and Material 3.

## Map Stack

| Purpose | Technology |
|---------|------------|
| Map Engine | `flutter_map` |
| Coordinate Utils | `latlong2` |
| Map Source | OpenStreetMap (OSM) |
| Vietnam Data | Geofabrik Vietnam Extract |
| Admin Boundaries | GeoJSON / Shapefiles |
| Offline Tiles | MBTiles or PMTiles |

## Run Locally

Flutter stable with Windows desktop support is required.

```powershell
flutter create --platforms=windows .
flutter pub get
flutter run -d windows
```

The current feature is UI-first:

- The Viet Nam map is interactive through pan and zoom.
- Current-location UI states are included.
- Search, filter, and sort controls are visible but intentionally inactive.
- Public OSM tiles must not be prefetched for offline use.

## Performance Validation

For map smoothness work, validate the desktop app in profile mode rather than
debug mode:

```powershell
flutter analyze
flutter build windows --profile
flutter run -d windows --profile
```

During profile validation, drag continuously, zoom repeatedly, resize the
window, and confirm map controls remain responsive while the performance overlay
or DevTools shows no repeated jank during normal map exploration.
