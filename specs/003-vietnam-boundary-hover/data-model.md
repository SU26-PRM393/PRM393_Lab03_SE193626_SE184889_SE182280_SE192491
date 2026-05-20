# Data Model: Vietnam Boundary Hover Map

## VietNamMapScope

Represents the visible national scope used to keep the map focused on Viet Nam.

**Fields**:

- `id`: Stable identifier for the scope asset, such as `vietnam`.
- `displayName`: User-facing or reviewer-facing name for the scope.
- `bounds`: Minimum and maximum latitude/longitude used for camera limits.
- `geometry`: Polygon or multipolygon rings that define the visible Viet Nam
  map area.
- `maskGeometry`: Optional inverse or outside-scope geometry used to neutralize
  areas outside Viet Nam.
- `sourceVersion`: Dataset/version note used for reviewer traceability.

**Validation rules**:

- Bounds must include mainland Viet Nam and relevant island map areas.
- Geometry must be valid enough for rendering without self-intersection
  artifacts that obscure Viet Nam.
- The scope must not require replacing the current base tile style.

## ProvinceBoundary

Represents one province-level administrative area eligible for hover outline.

**Fields**:

- `id`: Stable app identifier for the province boundary.
- `provinceCode`: Province code used to match existing province metadata.
- `name`: Province or centrally governed city name.
- `level`: Province-level type, including province, city, or capital.
- `bounds`: Minimum and maximum latitude/longitude used for fast hover
  candidate filtering.
- `geometry`: Polygon or multipolygon coordinate rings used for outline
  rendering and point containment.
- `centroid`: Optional coordinate for diagnostics or future labels.
- `sourceVersion`: Dataset/version note used for reviewer traceability.

**Validation rules**:

- Every boundary must match an existing province-level metadata record or be
  explicitly documented as an approved extra area.
- Geometry must support drawing an outline without filling the province.
- Bounds must contain the geometry and must be small enough to filter hover
  candidates effectively.
- Simplification must preserve recognizably correct borders and coastlines for
  desktop viewing.

## IslandLabelOverride

Represents a user-facing replacement label for an island group.

**Fields**:

- `id`: Stable identifier such as `hoang-sa` or `truong-sa`.
- `legacyLabel`: The old label that must not be visible in the app map view.
- `displayLabel`: The requested replacement label.
- `anchor`: Latitude/longitude where the replacement label is placed.
- `minZoom`: Lowest zoom where the label is shown.
- `maxZoom`: Highest zoom where the label is shown.
- `coverLegacyLabel`: Whether a small neutral cover is needed behind the
  replacement label to hide baked-in raster text.

**Validation rules**:

- `displayLabel` must exactly match the requested text: `Quan dao Hoang Sa` or
  `Quan đao Trường Sa`.
- Replacement labels must not cover essential controls or attribution.
- Legacy labels must not remain visible where replacement labels are shown.

## ProvinceHoverState

Represents the current pointer relationship to province boundaries.

**Fields**:

- `pointerPosition`: Latest pointer coordinate on the map, when available.
- `hoveredProvinceId`: Active province boundary ID, or empty when none is
  hovered.
- `status`: One of `inactive`, `active`, `ambiguous`, or `unavailable`.
- `lastUpdatedAt`: Timestamp of the latest hover state transition.
- `message`: Optional diagnostic or unavailable-data note for non-blocking
  validation.

**State transitions**:

- `inactive` -> `active`: Pointer enters a province-level area.
- `active` -> `active`: Pointer moves to another province-level area.
- `active` -> `inactive`: Pointer leaves province-level areas or the map.
- `active` -> `ambiguous`: Pointer is exactly on a shared boundary and a stable
  candidate has not yet been resolved.
- Any state -> `unavailable`: Boundary data cannot be loaded; the map remains
  usable without hover outlines.

**Validation rules**:

- At most one hover outline should be shown for a resolved active state.
- Hover state updates must not block drag, zoom, current-location controls, or
  attribution.
- Missing or unavailable geometry must clear the outline and keep the base map
  usable.

## Relationships

- `VietNamMapScope` constrains and masks the same map viewport used by existing
  map interactions.
- `ProvinceBoundary` records are loaded by the boundary source and queried by
  hover state.
- `ProvinceHoverState.hoveredProvinceId` references one `ProvinceBoundary`.
- `IslandLabelOverride` records are rendered by the map overlay layer and are
  independent of province hover state.
