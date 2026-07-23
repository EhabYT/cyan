# Architecture

Cyan is a typed Luau UI library for Roblox. It is organised so the core
(`Library.lua`) stays independent of features, and every feature lives in its
own add-on under `addons/`.

## Layout

```
cyan/
├── Library.lua            # Core: windows, tabs, elements, theming, registry
├── Library.d.luau         # Public type declarations (Luau LSP)
├── init.luau              # Package entry point (require(Packages.Cyan))
├── Example.lua            # Feature showcase / runnable loader
├── addons/                # One file per feature
│   ├── ESP.lua            # ESP + Aimbot
│   ├── Radar.lua          # Minimap radar
│   ├── Movement.lua       # WalkSpeed, fly, noclip, anti-void
│   ├── Visuals.lua        # Fullbright, night vision, fog, FPS
│   ├── Camera.lua         # Third-person, FOV, freecam, spin
│   ├── ServerInfo.lua     # Server / player stats panel
│   ├── Protections.lua    # Anti-kick, anti-crash, anti-idle, anti-lag
│   ├── QoL.lua            # Rejoin, server hop, item ESP, auto-click
│   ├── UIUtilities.lua    # Watermark, color palette, notifications
│   ├── HUD.lua            # Text/progress/timer/waypoint overlays
│   ├── KeySystem.lua      # Callback-driven access-key UI
│   ├── ThemeManager.lua   # Theme persistence + built-in palettes
│   └── SaveManager.lua    # Configuration persistence
├── assets/                # Bundled images (logo, icons, maps)
├── docs/                  # Guides (this folder)
├── tests/                 # Repository invariants + smoke tests
├── wally.toml             # Package manifest
└── stylua.toml            # Formatter config
```

## Core responsibilities (`Library.lua`)

- **Window / Tab / Groupbox** construction and layout.
- **Elements**: toggle, checkbox, slider, input, dropdown, button, label,
  color picker, key picker.
- **Registry**: binds `Scheme` colors to instances so themes re-paint live.
- **Theme**: `Library.Scheme` + `AddToRegistry` / `UpdateColorsUsingRegistry`.
- **Input / drag / search / notifications / dialogs**.
- **Glass surfaces**, reduced-motion, DPI scaling, mobile layout.

## Add-on contract

Each add-on exposes a constructor that receives `Library` and an options table,
returns a manager, and registers its controls on the `UI Settings` tab in
`Example.lua`. Add-ons never gate their own UI; visibility is owned by the host.

## Loading

- **Wally** (recommended): `require(Packages.Cyan)`.
- **Loader**: `Example.lua` fetches `Library.lua` and `addons/*.lua` from the
  published `main` (or local siblings when present) and wires every add-on into
  the `UI Settings` tab. No KeySystem gating is applied to add-on controls.
