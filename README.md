# Cyan

**Cyan** is a maintained, typed Luau UI library for Roblox — windows, tabs,
groupboxes, inputs, notifications, dialogs, theming, optional configuration
persistence, and a complete feature showcase (ESP, Aimbot, Radar, Movement,
Visuals, Camera, Server Info, Protections, QoL, UI Utilities).

- **Current package version:** `26.8.0`
- **License:** [MIT](LICENSE)

The bundled Cyan logo is available through `Library.ImageManager.GetAsset("CyanLogo")`
in hosts that support custom local assets. Hosts without custom-asset support
use a safe fallback icon until a Roblox asset ID for the logo is configured.

---

## Install

### Wally (recommended)

After publishing this repository to the Wally registry, add Cyan to your `wally.toml`:

```toml
[dependencies]
Cyan = "ehabyt/cyan@26.8.0"
```

Then use the package entry point:

```luau
local Cyan = require(Packages.Cyan)
local Library = Cyan.Library

local Window = Library:CreateWindow({
    Title = "My experience",
    Footer = "Powered by Cyan",
})
```

### Direct loader (executors / loadstring)

`Example.lua` is a self-contained showcase. It prefers local sibling files when
present and falls back to the published `main` branch over HTTP, so a cloned
repo runs fully offline with the exact local code.

```luau
loadstring(game:HttpGet("https://raw.githubusercontent.com/EhabYT/cyan/main/Example.lua"))()
```

All add-on controls render in the **UI Settings** tab by default — no KeySystem
gating is applied to them.

---

## Quick start

```luau
local Library = require(Packages.Cyan).Library
local ESP = require(Packages.Cyan).ESP

local Window = Library:CreateWindow({ Title = "Cyan", Footer = "example" })
local Tab = Window:AddTab("Main", "user")
local Group = Tab:AddLeftGroupbox("Combat", "swords")

local Manager = ESP.new(Library, {})
Group:AddToggle("ESP", {
    Text = "Enable ESP",
    Default = true,
    Callback = function(Value)
        Manager:SetEnabled(Value)
    end,
})
```

---

## Theming

Cyan ships a built-in theming engine. Colors live in `Library.Scheme`; every
themed element re-paints instantly on theme change.

```luau
local ThemeManager = require(Packages.Cyan).ThemeManager
ThemeManager:SetLibrary(Library)
ThemeManager:SetFolder("MyScriptHub")
ThemeManager:ApplyToTab(Tabs["UI Settings"])
ThemeManager:SetTheme("Cyan Pro") -- Cyan Pro, Midnight, Aurora, Graphite, Bloom, …
```

See [docs/THEMES.md](docs/THEMES.md) for the full palette list and how to create
and persist your own themes.

---

## Add-ons

| Add-on | Highlights |
| --- | --- |
| ESP & Aimbot | Boxes, health bars, tracers, chams, FOV circle, target lock, aimbot, silent aim, auto-fire, magic bullet |
| Radar | Minimap, blips, range/zoom, FOV cone |
| Movement | WalkSpeed, jump, fly, noclip, anti-void |
| Visuals | Fullbright, night vision, X-ray, fog, FPS |
| Camera | Third-person, FOV, freecam, spin |
| Server Info | Live server / player stats |
| Protections | Anti-kick, anti-crash, anti-idle, anti-lag |
| QoL | Rejoin, server hop, item ESP, auto-click |
| UI Utilities | Watermark, color palette, notifications |
| HUD | Text, progress, timers, waypoints, objectives |
| KeySystem | Callback-driven access keys |
| ThemeManager / SaveManager | Theming + config persistence |

Full catalog and APIs: [docs/ADDONS.md](docs/ADDONS.md).
Project structure: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md).

---

## Documentation

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — project layout and core responsibilities
- [docs/ADDONS.md](docs/ADDONS.md) — add-on catalog and minimal usage
- [docs/THEMES.md](docs/THEMES.md) — theming guide and palette list
- [docs/KEY_SYSTEM.md](docs/KEY_SYSTEM.md) — access-key UI
- [docs/MIGRATION.md](docs/MIGRATION.md) — upgrade notes
- [docs/RELEASES.md](docs/RELEASES.md) — release history

---

## Development

Format and validate before committing:

```bash
stylua Library.lua Library.d.luau Example.lua init.luau addons tests/keysystem_smoke.luau
python3 tests/validate_project.py
bash tests/smoke_addons.sh
luau tests/keysystem_smoke.luau
wally package --output /tmp/cyan.wally
```

## License

MIT — see [LICENSE](LICENSE).
