# Cyan releases

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
