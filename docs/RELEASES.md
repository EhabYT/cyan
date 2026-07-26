# Cyan releases

## 26.7.18 — 26 July 2026

### Highlights

- Improved Arabic and other RTL login UX with Key System prompt, status, and input alignment.
- Added documentation and smoke coverage for the new RightToLeft KeySystem UI option.

## 26.7.17 — 26 July 2026

### Highlights

- Added pre-login language selection to the Key System experience.
- Synchronized language controls across the login and protected settings screens.

## 26.7.16 — 26 July 2026

### Highlights

- Improved the example UI/UX with organized, icon-labeled settings panels for menu controls, appearance, accessibility, and mobile behavior.
- Preserved responsive visibility and live localization across the reorganized interface.

## 26.7.15 — 26 July 2026

### Highlights

- Added a configurable mobile lock long-press duration and immediate localized lock/unlock feedback.
- Extended built-in mobile localization keys and documentation for a clearer touch experience.

## 26.7.14 — 26 July 2026

### Highlights

- Hardened the mobile CyanLogo/lock gesture state so lock controls cannot remain invisibly active after dismissal.
- Lock controls now close predictably after use, a normal menu tap, or an outside tap.

## 26.7.13 — 26 July 2026

### Highlights

- Corrected the mobile interaction model: CyanLogo directly toggles the menu, and press-and-hold exclusively toggles the Lock/Unlock action.
- Removed redundant hidden Open/Close actions from the mobile panel.

## 26.7.12 — 26 July 2026

### Highlights

- Streamlined mobile actions: one primary control toggles Open/Close, while a long press on CyanLogo toggles the optional Lock/Unlock action.
- Refreshed mobile interaction documentation and retained outside-tap dismissal plus touch debounce behavior.

## 26.7.11 — 26 July 2026

### Highlights

- Fixed the example startup flow by opening the protected window only after the Key System gate and all panels are ready.
- Added a validation invariant for explicit key-gated example startup.

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
