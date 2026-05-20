# UI Contract: Map Scope, Island Labels, and Province Hover

## Preserved Map Appearance

- The existing base tile layer remains visually recognizable as the current map.
- The feature must not replace the map engine, switch to a different-looking
  tile provider, remove attribution, or redesign the surrounding controls.
- Roads, water, typography, colors, and general map texture inside Viet Nam
  should remain the same except where the requested scope, labels, or hover
  outline require a local overlay.

## Viet Nam-Only Scope

- On initial load, Viet Nam is the only country visible as usable map geography.
- Panning and zooming near borders must not reveal neighboring-country land,
  borders, place labels, or country names.
- If outside-scope geography would appear in the base raster tiles, it must be
  fully hidden, masked, or neutralized without covering the Viet Nam map area.
  It must not remain visible as faded country geography.
- Camera constraints must keep normal Viet Nam exploration possible, including
  mainland, coast, and relevant island areas.
- Existing drag, zoom, current-location, and inactive search/filter/sort
  controls must continue to work.

## Island Label Overrides

- The Hoang Sa island group label displays as `Quan dao Hoang Sa`.
- The Truong Sa island group label displays as `Quan đao Trường Sa`.
- `Paracel Islands` and `Spratly Islands` must not be visible in supported app
  views where the replacement labels are shown.
- Replacement labels must remain readable and must not cover zoom controls,
  current-location controls, attribution, or status banners.

## Province Hover Outline

- The default map displays province-level boundaries first.
- Hovering over a province-level area displays one outline matching that
  area's boundary.
- Moving to another province-level area updates the outline to the new area.
- Leaving the map, hovering over water, or hovering over an area without
  province data clears the outline.
- The outline is presentation-only: it does not select a province, open a
  panel, filter data, sort data, or change inactive future controls.
- The outline must be visible over common map backgrounds while preserving the
  current map appearance. A thin high-contrast stroke is preferred over filled
  highlight.

## Province Click Drill-Down

- Clicking a province-level area selects that province.
- A selected province shows only lower-level places that belong to that
  province.
- Lower-level places are not shown before a province is selected.
- Clicking outside eligible province areas clears the selected province and
  removes lower-level places.
- Drill-down must not enable search, filter, sort, or data editing behavior.

## Failure And Loading States

- If boundary data is still loading, the base map remains usable.
- If province boundary data cannot load, hover outlines are unavailable but
  dragging, zooming, current-location behavior, attribution, and controls remain
  usable.
- If island label overlay data cannot load, the validation must treat the label
  replacement as failed; the app should not crash.
- Any non-blocking status message must follow the existing status-banner style.

## Accessibility And Performance

- The hover outline must have enough contrast to be identifiable without a
  subtle color difference alone.
- Existing accessible names and keyboard/button access for map controls remain
  intact.
- Hover state must appear, update, or clear within 100 ms under normal desktop
  conditions.
- Boundary geometry must be loaded and cached so pointer movement does not
  cause repeated parsing or broad screen rebuilds.
