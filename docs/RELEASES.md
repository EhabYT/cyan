# Cyan releases

## 26.7.10 — 26 July 2026

### Highlights

- Added application-configurable localization for supported built-in Cyan text, with live updates across active controls.
- Localized command palette search/empty states, dropdown search, window search, key-box prompt/actions, and confirmation text in the example.
- Added dynamic key-box placeholder, submit, and verified text APIs alongside regression validation and documentation.

## 26.7.9 — 26 July 2026

### Highlights

- Added localization adapters for the generated Save Manager and Theme Manager panels.
- The example now localizes persistence and theme panel labels, controls, confirmation actions, status labels, and autoload/default markers in English, German, and Arabic.
- Added documentation and smoke coverage for safe manager localization setup and fallback behavior.

## 26.7.8 — 26 July 2026

### Highlights

- Improved accessibility for Arabic, Hebrew, Persian, and Urdu with right-to-left alignment across supported localized Cyan controls.
- Restores each control's original left-to-right alignment when the locale changes back.

## 26.7.7 — 26 July 2026

### Highlights

- Streamlined the example into a localized, key-gated settings interface with no Main tab or generic control showcase.
- Added live English, German, and Arabic updates across settings controls, login status UI, tab/groupbox labels, and command-palette actions.
- Added dynamic text APIs for tabs, key tabs, groupboxes, commands, and attached KeySystem UI bindings.
- Refreshed the Liquid Glass showcase image, documentation, and regression coverage for the new localization flow.

## 26.7.6 — 21 July 2026

### Highlights

- Refined iPhone-inspired Liquid Glass with controls, tabs, dialogs, notifications, moving reflections, sheen, optional blur, and expanded presets.
- CyanLogo branding for the example window, loading screen, and primary mobile open actions.
- Login-first KeySystem flow with server-backed validation, tab gating, and local logout support.
- Localization dictionaries, RTL handling, parameter interpolation, bindings, and regression coverage.
- Expanded HUD widgets, objective/interaction UI, party data, timers, performance data, and mobile-aware rendering.
- Mobile viewport, safe-area, compact-sidebar, layout-preset, touch target, action-panel, and swipe-navigation improvements.
- Safer configuration rename/autoload migration, resize guards, narrow-sidebar bounds, regression coverage, and release validation.

### Release checklist

1. Update the version consistently in `wally.toml`, `Library.lua`, `README.md`, `CHANGELOG.md`, and `tests/validate_project.py`.
2. Run the project validation commands documented in the README.
3. Commit the release and create an annotated Git tag named `v<version>`.
4. Publish the Wally package only after the Git release has been pushed and reviewed.

## Version source of truth

The published package version is defined in [`wally.toml`](../wally.toml). Runtime code exposes the same string through `Library.Version`.
