# VietNam-Map-Flutter

Desktop Viet Nam map UI built with Flutter and Material 3

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

## Test Environment

Shared non-secret test configuration should live in `.env.test.example`.
Local secret values should live in `.env.test`, which is intentionally ignored by git.

Typical usage for Patrol and other integration tests:

```powershell
Copy-Item .env.test.example .env.test
```

To run the Google Patrol auth flow using values from `.env.test`:

```powershell
.\scripts\run_patrol_google_auth.ps1
```

Keep identifiers such as test emails in the shared example file when useful.
Keep passwords, tokens, and other secrets only in `.env.test` or your CI secret store.

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

## Code Quality Analysis

This project uses **SonarQube Community Edition** for code quality analysis.

### Quick Start

1. **Install SonarScanner** (if not already installed):
   - Download from: https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/
   - Add `bin` directory to your PATH

2. **Start SonarQube** (using Docker):
   ```powershell
   docker run -d --name sonarqube -p 9000:9000 -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLED=true sonarqube:community
   ```

3. **Run Analysis**:
   ```powershell
   .\scripts\sonarqube-analyze.ps1
   ```

4. **View Results**: http://localhost:9000

For detailed setup and configuration, see [SONARQUBE_SETUP.md](SONARQUBE_SETUP.md)


