# Add-ons

All add-ons are constructed in `Example.lua` and surface their controls in the
**UI Settings** tab. They are enabled by default and not gated by the KeySystem
demo.

| Add-on | Constructor | What it does |
| --- | --- | --- |
| ESP & Aimbot | `ESP.new(Library, opts)` | Player boxes, health bars, names, tracers, chams, FOV circle, target lock, aimbot, silent aim, auto-fire, magic bullet. |
| Radar | `Radar.new(Library, opts)` | Minimap with blips, range/zoom, FOV cone, positions. |
| Movement | `Movement.new(Library, opts)` | WalkSpeed, jump power, fly, noclip, anti-void, anti-teleport. |
| Visuals | `Visuals.new(Library, opts)` | Fullbright, night vision, X-ray, fog override, FPS counter. |
| Camera | `Camera.new(Library, opts)` | Third-person, FOV override, freecam, spin. |
| Server Info | `ServerInfo.new(Library, opts)` | Live server / player statistics panel. |
| Protections | `Protections.new(Library, opts)` | Anti-kick (+rejoin), anti-crash, anti-idle, anti-lag. |
| QoL | `QoL.new(Library, opts)` | Rejoin, copy link, server hop, item ESP, auto-collect, auto-click. |
| UI Utilities | `UIUtilities.new(Library, opts)` | Watermark, color palette, notification presets. |
| HUD | `HUD.new(Library, opts)` | On-screen text, progress, timers, waypoints, objectives, performance. |
| KeySystem | `KeySystem.new(opts)` | Callback-driven access-key UI (`GateTabs` / `Attach`). |
| ThemeManager | `ThemeManager:SetLibrary(Library)` | Theme persistence and built-in palettes. |
| SaveManager | `SaveManager:SetLibrary(Library)` | Configuration save / load slots. |

## Minimal usage

```luau
local Library = require(Packages.Cyan).Library
local ESP = require(Packages.Cyan).ESP

local Window = Library:CreateWindow({ Title = "My hub" })
local Tab = Window:AddTab("Main", "user")
local Group = Tab:AddLeftGroupbox("Combat", "swords")

local Manager = ESP.new(Library, {})
Group:AddToggle("ESP", {
    Text = "Enable ESP",
    Default = true,
    Callback = function(v) Manager:SetEnabled(v) end,
})
```
