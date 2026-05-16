# UI Performance Contract: Smooth Map Movement

## Scope

This contract covers the existing desktop Viet Nam map screen. It defines the
observable behavior expected after smoothing map movement.

## Primary Surface

- The Viet Nam map remains the dominant visual area.
- Users can drag the map with a pointer.
- Users can zoom using pointer input and visible zoom controls.
- Users can use current-location and recenter controls without waiting for map
  movement to settle.
- OSM attribution remains visible and unobstructed.
- Reserved search, filter, and sort controls remain visible but inactive.

## Interaction Contract

### Drag

**Given** the map is visible, **When** the user drags continuously, **Then** the
map follows the drag with visible feedback within 100 ms and without repeated
pauses.

### Zoom

**Given** the map is visible, **When** the user zooms in or out repeatedly,
**Then** the zoom change is visible within 100 ms and the current area of
interest remains understandable.

### Control Response

**Given** the user has just dragged or zoomed, **When** they select zoom,
current-location, or recenter controls, **Then** the chosen control responds
without freezing the screen.

### Loading Or Missing Imagery

**Given** some map imagery is loading or unavailable, **When** the user keeps
moving the map, **Then** the app shows a non-blocking status and continues to
accept drag, zoom, and control input.

### Resize

**Given** the app window is resized, **When** the user resumes map movement,
**Then** the map, attribution, current-location state, and controls remain
visible and stable.

## Accessibility Contract

- Zoom and current-location controls keep accessible names.
- Pointer gestures do not replace button access for core map actions.
- Focus and visible control states remain stable while imagery is loading.
- Text remains legible in the current desktop compact and wide layouts.

## Performance Contract

- First usable map: within 3 seconds under normal desktop conditions.
- Drag/zoom feedback: within 100 ms for at least 95% of observed actions.
- Longest visible freeze: no more than 150 ms during a representative
  60-second exploration session.
- Control response: zoom and current-location controls remain usable in 100% of
  validation attempts during or immediately after movement.
- Gesture rebuild boundary: continuous camera updates must not rebuild the
  entire desktop screen or inactive control panel.

## Out Of Scope

- Implementing real search, filter, sort, or administrative boundary behavior.
- Adding offline map tile packaging.
- Prefetching or downloading public OSM tiles for offline use.
- Replacing the map engine.
