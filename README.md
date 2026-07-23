# Cyan

Cyan is a maintained, typed Luau UI library for Roblox. It provides windows, tabs, groupboxes, inputs, notifications, dialogs, theming, optional configuration persistence, a cyan/navy default palette, and a complete feature showcase.

**Current package version:** `26.7.7`
**License:** [MIT](LICENSE)

The bundled Cyan logo is available through `Library.ImageManager.GetAsset("CyanLogo")` in hosts that support custom local assets. It is used by the example window and the default loading screen. Hosts without custom-asset support use a safe fallback icon until a Roblox asset ID for the logo is configured.

## Install

### Wally (recommended)

After publishing this repository to the Wally registry, add Cyan to your `wally.toml`:

```toml
[dependencies]
Cyan = "ehabyt/cyan@26.7.7"
```

Then use the package entry point:

```luau
local Cyan = require(Packages.Cyan)
local Library = Cyan.Library

local Window = Library:CreateWindow({
    Title = "My experience",
    Footer = "Powered by Cyan",
})

local Main = Window:AddTab("Main", "layout-dashboard")
local Controls = Main:AddLeftGroupbox("Controls", "sliders-horizontal")

Controls:AddToggle("FeatureEnabled", {
    Text = "Enable feature",
    Default = false,
})

Library.Toggles.FeatureEnabled:OnChanged(function(enabled)
    print("Feature enabled:", enabled)
end)
```

Cyan exports `Library`, `SaveManager`, `ThemeManager`, and `KeySystem`. The full API showcase is in [Example.lua](Example.lua); type declarations for the library, package, and add-ons live in [Library.d.luau](Library.d.luau).

### Direct loader

`Example.lua` retains a direct loader for environments that intentionally provide `game:HttpGet` and `loadstring`. Prefer a local Wally or Roblox package dependency in normal development so source versions are pinned and reviewable.

## Modern UX

- `Window:AddHeaderButton()` adds compact, tooltip-enabled quick actions beside search.
- `Window:Open()`, `Window:Close()`, `Window:SelectTab(name)`, `Window:GetActiveTab()`, `Window:GetTabs()`, `Window:NextTab()`, `Window:PreviousTab()`, `Window:ToggleSidebar()`, and `Window:ResetPosition()` support menu navigation and layout controls.
- **Ctrl+PageUp** and **Ctrl+PageDown** navigate through visible tabs.
- `Window:GetPosition()`, `Window:SetPosition(position)`, and `Window:Center()` provide layout control for menu presets.
- `Window:GetSearchText()`, `Window:SetSearchPlaceholder(text)`, and `Window:SetSearchVisible(boolean)` let applications tailor search behavior.
- **Ctrl+K** focuses the window search field when search is visible and the window is open.
- **Escape** leaves focused text input first, then closes an open menu or a dialog that permits outside-click dismissal.
- `Window:FocusSearch()` returns `true` when it successfully focuses search.
- `Window:ClearSearch()` clears the active query, restores hidden controls, and releases text focus.
- `Library:CloseTransientUI()` closes the active menu or a dismissible dialog and reports whether it closed anything.
- `Library:SetReducedMotion(true)` disables Cyan transition animations while preserving the caller’s preferred animation settings for later restoration.

## Liquid Glass style

Cyan uses a liquid-glass visual style by default: translucent cyan/navy surfaces, a soft cyan gradient, rounded panels, and accent highlights. Control it at creation time or at runtime:

```luau
local Window = Library:CreateWindow({
    Title = "My experience",
    Glass = true,
    GlassTransparency = 0.16,
    GlassStrokeTransparency = 0.25,
})

Window:SetGlass(true, 0.2, 0.18)
Window:SetGlassPreset("Aurora") -- Liquid, Crystal, Frosted, Ocean, Aurora, Midnight, or Solid
Window:SetGlassSheen(true, 7)
Window:SetGlassBackgroundMotion(true, 14)
Window:SetGlassBlur(true, 8) -- Optional; affects the scene behind the menu
```

The example menu exposes **Liquid Glass**, **Glass Transparency**, **Glass Preset**, **Animate Glass**, and optional **Glass Blur** controls under UI Settings. Tabs, dialogs, notifications, inputs, and action buttons inherit the same translucent Cyan glass treatment. Mobile header and circular action buttons also use an iPhone-style press-scale feedback animation.

## Accessibility and input

Cyan includes keyboard-first search (`Ctrl+K`), Escape-aware text handling, DPI scaling, custom cursor control, and a reduced-motion preference. On touch devices, the menu automatically fits the current viewport, starts with a compact sidebar by default, supports optional horizontal swipe navigation between visible tabs, respects the Roblox safe area for notches and system bars, and refreshes after portrait/landscape changes. Configure this with `WindowInfo.MobileScale`, `WindowInfo.MobileViewportPadding`, `WindowInfo.MobileStartCompacted`, and `WindowInfo.MobileLayout`. Runtime presets are available through `Window:SetMobileLayout("Compact" | "Balanced" | "Expanded")`. Header actions receive larger touch targets, while optional desktop quick actions can be hidden on mobile. The bundled CyanLogo brands the primary mobile menu and Open actions. The 52px circular menu button opens a compact action panel containing Open, Close, and Lock/Unlock controls. The panel automatically shows only the actions relevant to the current menu state and dismisses when the user taps outside it; the remaining controls use X, lock, and unlock icons when available. Use `Library:SetReducedMotion(true)` for users who prefer fewer transitions; call it with `false` to restore the window’s configured animations.

## HUD

`HUD` adds a lightweight, theme-aware, draggable status panel for data your own experience owns—such as objectives, session state, or progress. It does not inspect or automate other players.

```luau
local StatusHUD = Cyan.HUD.new(Library, {
    Title = "Session",
    Position = UDim2.fromOffset(12, 80),
})

local Status = StatusHUD:AddText("Status", {
    Text = "Status",
    Value = "Ready",
})
local Progress = StatusHUD:AddProgress("Load", {
    Text = "Loading",
    Value = 0.4,
})

Status:SetValue("Running")
Progress:SetValue(1)
```

Use `HUD:Remove(index)`, `HUD:Clear()`, `HUD:SetVisible(boolean)`, or `HUD:Destroy()` to manage it. The HUD cleans itself up when `Library:Unload()` runs.

Additional host-controlled HUD tools include:

- `AddTimer` / `AddCooldown` for countdowns
- `AddCounter` and `AddProgressRing` for compact numeric status
- `AddWaypoint` / `AddObjectiveTracker` for supplied objective positions, distance, and compass direction
- `AddObjectiveMarker` and `AddInteractionPrompt` for supplied NPC/objective world labels
- `SetParty` for a host-provided party/team panel
- `AddPerformance` for local FPS and optional host-provided ping data
- `SetUpdateInterval(seconds)` to throttle timer/waypoint display updates; mobile HUDs default to 0.15 seconds
- `Alert` for Cyan notifications

Objective targets, party members, and interaction labels must be supplied by your own trusted game/server logic. `AddInteractionPrompt` creates a standard line-of-sight `ProximityPrompt`; its callback is presentation-only, so the server must validate every protected interaction. Cyan does not discover players, scan the map, or render through walls.

## Key system

`KeySystem` supplies a callback-driven access-key flow with input trimming, optional cooldowns, attempt limits, lock/reset state, status UI, and safe verifier-callback handling. It contains **no hard-coded keys or verification endpoint**—your application owns authorization.

```luau
local Gate = Cyan.KeySystem.new({
    Validate = function(submittedKey)
        -- Call your trusted entitlement service here.
        -- Client-side allowlists are only suitable for demos or non-sensitive tools.
        return submittedKey == "example-key", "Key was not accepted"
    end,
    MaxAttempts = 5,
    CooldownSeconds = 1,
    OnVerified = function()
        -- Enable only the UI or features authorized by your trusted service.
        print("Access approved")
    end,
})

local KeyTab = Window:AddKeyTab("Access", "key")
Gate:Attach(KeyTab, {
    Prompt = "Enter your access key.",
    Placeholder = "Access key",
})
```

Use `Gate:GateTabs(loginTab, { protectedTab1, protectedTab2 }, options)` before `Attach` when the login tab must appear first and the rest of the menu should remain hidden until verification succeeds. Set `HideSearchBeforeVerification = true` to hide search until access is approved. Call `Gate:Logout()` to return the UI to the login tab.

For a real Roblox experience, client UI is not an authorization boundary. Verify entitlement on the server and enforce protected gameplay/features there.

## Persistence add-ons

`SaveManager` and `ThemeManager` are optional. They require the host to provide filesystem functions (`isfolder`, `isfile`, `listfiles`, `makefolder`, `readfile`, `writefile`, and `delfile`). Call `:IsSupported()` before presenting persistence controls in hosts that may not support a filesystem:

```luau
Cyan.SaveManager:SetLibrary(Library)
local supported, reason = Cyan.SaveManager:IsSupported()
if supported then
    Cyan.SaveManager:SetFolder("MyExperience")
else
    warn(reason)
end
```

Both managers now use `CyanLibSettings` as their default root folder. Save Manager includes validated config renaming with autoload migration, and Theme Manager includes a stable **Cyan** preset so the cyan/navy palette can always be restored after customizing the mutable `Default` theme. See [docs/MIGRATION.md](docs/MIGRATION.md) when moving from Obsidian.

## Development

The repository pins its tools in [rokit.toml](rokit.toml): Wally `0.3.2`, StyLua `2.5.2`, and Luau `0.730`.

```sh
# Install Rokit v1.2.0 or newer, then install pinned tools.
rokit install

# Format sources. StyLua also parses Luau as it formats.
stylua Library.lua Library.d.luau Example.lua init.luau addons tests/keysystem_smoke.luau

# Verify formatting and syntax without changing source.
stylua --check Library.lua Library.d.luau Example.lua init.luau addons tests/keysystem_smoke.luau

# Validate package metadata, local module targets, and public API declarations.
python3 tests/validate_project.py

# Smoke-test persistence errors and invalid-path handling without Roblox.
bash tests/smoke_addons.sh

# Smoke-test callback key-system state transitions.
luau tests/keysystem_smoke.luau

# Validate Wally packaging without writing to the repository.
wally package --output /tmp/cyan.wally
```

Continuous integration runs the same formatting, syntax, package, and project validation checks. Contribution conventions are in [CONTRIBUTING.md](CONTRIBUTING.md).

## Documentation map

- [Feature showcase](Example.lua)
- [Public type declarations](Library.d.luau)
- [Migration guide](docs/MIGRATION.md)
- [Key system guide](docs/KEY_SYSTEM.md)
- [Release notes](docs/RELEASES.md)
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
