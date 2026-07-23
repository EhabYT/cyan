# Cyan releases

## 26.8.0 — 23 July 2026

### Highlights

- Professional design system: five curated built-in themes (Cyan Pro, Midnight, Aurora, Graphite, Bloom) with high-contrast, mobile-friendly palettes.
- Reorganized and expanded documentation: new ARCHITECTURE, ADDONS, and THEMES guides plus a polished README.
- Example showcase polished for a cleaner, more professional layout.
- Every add-on control is visible in the "UI Settings" tab with no KeySystem gating.

## 26.7.8 — 23 July 2026

### Highlights

- Example showcase is now self-contained: it loads the local Library and add-ons when available and falls back to the published `main` branch only when no local copy exists, so a cloned repo runs fully offline with the exact local (ungated) code.
- ESP and every add-on control are visible in the "UI Settings" tab by default with no KeySystem gating.

### Release checklist

1. Update the version consistently in `wally.toml`, `Library.lua`, `README.md`, `CHANGELOG.md`, and `tests/validate_project.py`.
2. Run the project validation commands documented in the README.
3. Commit the release and create an annotated Git tag named `v<version>`.
4. Publish the Wally package only after the Git release has been pushed and reviewed.

## 26.7.7 — 23 July 2026

### Highlights

- Fixed the mobile circular launcher button: it can now be dragged and stays where you drop it; viewport and orientation changes no longer reset its position.
- Fixed the example showcase so ESP and all add-on controls are visible by default instead of being gated behind the KeySystem demo.

### Release checklist

1. Update the version consistently in `wally.toml`, `Library.lua`, `README.md`, `CHANGELOG.md`, and `tests/validate_project.py`.
2. Run the project validation commands documented in the README.
3. Commit the release and create an annotated Git tag named `v<version>`.
4. Publish the Wally package only after the Git release has been pushed and reviewed.

## 26.7.6 — 22 July 2026

### Highlights

- Maintenance release packaging the post-26.7.5 formatting, syntax, and escape-sequence fixes.
- Added a canonical StyLua configuration and normalized all sources to 4-space indentation, removing the mixed tabs/spaces inconsistency.
- Fixed an invalid tuple return type annotation in the ESP add-on.
- Fixed four malformed Unicode escape sequences in the example showcase.

## 26.7.5 — 21 July 2026

### Highlights

- Cyan/navy default palette and bundled CyanLogo branding.
- Login-first KeySystem flow with server-backed validator support.
- Expanded HUD widgets, objective/interaction UI, party data, timers, performance data, and mobile-aware rendering.
- Mobile viewport, safe-area, compact-sidebar, layout-preset, touch target, and action-panel improvements.
- CyanLogo branding for the example window, loading screen, and primary mobile open actions.
- Login-first tab gating plus local logout flow and safer configuration rename/autoload migration.
- Expanded regression coverage and release validation.

### Release checklist

1. Update the version consistently in `wally.toml`, `Library.lua`, `README.md`, `CHANGELOG.md`, and `tests/validate_project.py`.
2. Run the project validation commands documented in the README.
3. Commit the release and create an annotated Git tag named `v<version>`.
4. Publish the Wally package only after the Git release has been pushed and reviewed.

## Version source of truth

The published package version is defined in [`wally.toml`](../wally.toml). Runtime code exposes the same string through `Library.Version`.
