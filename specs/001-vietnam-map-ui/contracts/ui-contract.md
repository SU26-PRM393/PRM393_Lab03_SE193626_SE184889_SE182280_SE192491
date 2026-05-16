# UI Contract: Desktop Viet Nam Map UI

## Scope

This contract defines the user-visible states and interactions for the first
desktop map UI slice. It does not define working search, filter, or sort
behavior.

## Main Screen Layout

### Required Regions

- **Map Region**: Dominant region showing the Viet Nam map.
- **Control Region**: Reserved region for future province, city, district
  search, filter, and sort tools.
- **Map Utility Region**: Zoom controls, current-location control, and visible
  attribution.
- **Status Region**: Non-blocking messages for loading, location unavailable,
  and map-source issues.

### Layout Behavior

- Map region remains visible at all supported desktop sizes.
- Control region may compress or reposition, but must not cover required map
  controls or attribution.
- Current-location state remains discoverable when available or unavailable.

## Interactions

### Map Pan

**Trigger**: User drags the map.

**Expected Result**: Map viewport moves in response to the drag while preserving
zoom level and keeping the map interactive.

### Map Zoom

**Trigger**: User uses pointer wheel/trackpad gesture or visible zoom controls.

**Expected Result**: Map zoom level changes within allowed min/max limits and
the current map context remains understandable.

### Current Location

**Trigger**: User opens the screen or activates the current-location control.

**Expected Result**:
- If available, show a marker or indicator on/near the map.
- If denied or unavailable, show a clear non-blocking message.
- Map pan and zoom remain usable in all states.

### Search, Filter, Sort Controls

**Trigger**: User focuses or clicks reserved search, filter, or sort controls.

**Expected Result**:
- Controls may show inactive or placeholder affordances.
- Controls must not search, filter, sort, select, navigate, or mutate map data.
- User should understand these tools are reserved for a later feature.

## Required States

- Initial loading
- Map ready
- Map interaction active
- Current location requesting
- Current location available
- Current location denied
- Current location unavailable
- Map tile/source unavailable
- Inactive future controls

## Accessibility Contract

- Interactive controls have accessible names.
- Zoom and current-location actions are available through visible controls, not
  only pointer gestures.
- Text remains legible after desktop window resizing.
- Focus order moves through control region, map utility controls, and status
  region predictably.

## Performance Contract

- Main map view usable within 3 seconds under normal desktop conditions.
- Pan and zoom feedback visible within 200 ms of input.
- Location failure cannot block map exploration.
