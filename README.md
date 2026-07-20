# Cyan

Cyan is a maintained, typed Luau UI library for Roblox. It provides windows, tabs, groupboxes, inputs, notifications, dialogs, theming, optional configuration persistence, and a complete feature showcase.

**Current package version:** `26.7.0`
**License:** [MIT](LICENSE)

## Install

### Wally (recommended)

After publishing this repository to the Wally registry, add Cyan to your `wally.toml`:

```toml
[dependencies]
Cyan = "ehabyt/cyan@26.7.0"
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

- **Ctrl+K** focuses the window search field when search is visible and the window is open.
- **Escape** leaves focused text input first, then closes an open menu or a dialog that permits outside-click dismissal.
- `Window:FocusSearch()` returns `true` when it successfully focuses search.
- `Window:ClearSearch()` clears the active query, restores hidden controls, and releases text focus.
- `Library:CloseTransientUI()` closes the active menu or a dismissible dialog and reports whether it closed anything.
- `Library:SetReducedMotion(true)` disables Cyan transition animations while preserving the caller’s preferred animation settings for later restoration.

## Accessibility and input

Cyan includes keyboard-first search (`Ctrl+K`), Escape-aware text handling, DPI scaling, custom cursor control, and a reduced-motion preference. Use `Library:SetReducedMotion(true)` for users who prefer fewer transitions; call it with `false` to restore the window’s configured animations.

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

Both managers now use `CyanLibSettings` as their default root folder. See [docs/MIGRATION.md](docs/MIGRATION.md) when moving from Obsidian.

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
- [Changelog](CHANGELOG.md)
- [Contributing](CONTRIBUTING.md)
