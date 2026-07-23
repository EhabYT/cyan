# Cyan — Script Overhaul & Redesign Report

This document records the full audit and the concrete changes applied to the
Cyan Roblox Luau UI library in response to the overhaul brief:

1. **Core Code Architecture** — import/dependency hardening.
2. **Loading & Key System** — loading screen → dedicated key window → menu.
3. **UI/UX Refinement** — compact radar, static/centered menu, clean aesthetic.
4. **Functionality Audit** — why options went missing, and how they are now
   guaranteed to appear.

> Environment note: the sandbox has **no Roblox runtime**, so changes are
> validated statically (`stylua`, `luau-analyze`), via the project's 5 mandatory
> checks, and by executing `Example.lua` end‑to‑end against a mock Roblox
> environment. Visual/aesthetic results must be confirmed on your executor.

---

## 0. Validation status

All five mandatory gates pass after the changes:

| Check | Command | Result |
|------|---------|--------|
| Format | `stylua --check Library.lua Library.d.luau Example.lua init.luau addons tests/keysystem_smoke.luau` | ✅ |
| Project invariants | `python3 tests/validate_project.py` | ✅ |
| Persistence smoke | `bash tests/smoke_addons.sh` | ✅ |
| Key system smoke | `luau tests/keysystem_smoke.luau` | ✅ |
| Wally package | `wally package --output /tmp/cyan.wally` | ✅ |

`Example.lua` also executes **end‑to‑end with 0 addon errors** in the mock
harness (loading screen → key system → menu flow included).

---

## 1. Core Code Architecture

### 1.1 Audit findings

* **Fragile module loading.** Every module was loaded with
  `local X = loadstring(game:HttpGet(repo .. "X.lua"))()`. A single failed
  download, syntax error, or runtime error while a module *initialises* threw
  at that line and **aborted the entire script** — silently blanking every
  control defined afterwards. This is the single most likely root cause of
  *"some options appear, some don't"*.
* **No dependency isolation between addons.** Each addon's *build* block ran at
  top level; one throwing addon wiped all subsequent ones.
* **Two consumption paths exist** and both are valid:
  * Direct loader: `Example.lua` (`loadstring` + `HttpGet`) — for executors that
    support it.
  * Wally package: `require(Packages.Cyan)` — documented in `README.md`,
    packaged via `init.luau` (exports `Library`, `ThemeManager`, `SaveManager`,
    `Player`, `WeaponMods`).
* **`KeySystem` addon is callback‑driven and ships no keys** — verification is
  owned by the host through a `Validate` callback. Good, secure design.

### 1.2 Implemented fixes

**`LoadAddon` — pcall‑wrapped loads** (replaces the bare `loadstring` calls):

```lua
local function LoadAddon(Name, Path)
    local Ok, Mod = pcall(loadstring, game:HttpGet(repo .. Path))
    if not Ok or not Mod then
        warn(string.format("[Cyan] Failed to compile %s (%s): %s", Name, Path, tostring(Mod)))
        return nil
    end
    Ok, Mod = pcall(Mod)
    if not Ok then
        warn(string.format("[Cyan] Failed to run %s (%s): %s", Name, Path, tostring(Mod)))
        return nil
    end
    return Mod
end

local Library      = LoadAddon("Library", "Library.lua")
local ThemeManager = LoadAddon("ThemeManager", "addons/ThemeManager.lua")
local SaveManager  = LoadAddon("SaveManager", "addons/SaveManager.lua")
local HUD          = LoadAddon("HUD", "addons/HUD.lua")
local ESP          = LoadAddon("ESP", "addons/ESP.lua")
-- ... all 11 addons + Player/WeaponMods loaded the same way ...
```

**`SafeSetup` — pcall‑wrapped build blocks** (each addon's UI build lives in
`local function SetupX() … end` and is invoked through `SafeSetup`):

```lua
local AddonStatus = {}

local function SafeSetup(Name, Fn)
    local Ok, Err = pcall(Fn)
    AddonStatus[Name] = { Ok = Ok, Err = Err }
    if not Ok then
        warn(string.format("[Cyan] %s failed to load: %s", Name, tostring(Err)))
        if Library and Library.Notify then
            pcall(Library.Notify, Library,
                string.format("Cyan: %s could not load. See console.", Name), 8)
        end
    end
end
```

> Net effect: a failure in **one** addon (load *or* build) can no longer blank
> out the rest of the menu. The remaining addons still load, and the failure is
> reported instead of silently killing the UI.

---

## 2. Loading & Key System

### 2.1 Flow

```
[ script starts ]
   └─ main Window created, then Library:Toggle(false)   → menu HIDDEN
[ modules load + all tabs/options built ]               → (happens while hidden)
[ presentation flow ]
   1. Library:CreateLoading(...)                        → lightweight loading screen
        └─ update steps, then Loading:Destroy()         → (auto‑reveals, immediately re‑hidden)
   2. dedicated Key window  (Library:CreateWindow)
        └─ KeySystem.new({ Validate, OnVerified }):Attach(KeyTab)
        └─ Library:Toggle(false)                        → menu stays HIDDEN while key open
   3. On correct key → close key window + Library:Toggle(true)  → MENU REVEALED
```

### 2.2 Implementation (top of `Example.lua`)

```lua
local Window = Library:CreateWindow({
    Title = "Cyan",
    Icon = CyanLogo,
    IconSize = UDim2.fromOffset(32, 32),
    Footer = "version: example",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true,      -- static, centered menu
    Resizable = false,  -- fixed size
    AutoShow = false,   -- hidden until the key system verifies access
})

-- Keep the menu hidden until the key system verifies access.
Library:Toggle(false)
```

### 2.3 Implementation (end of `Example.lua`)

```lua
local REQUIRE_KEY = true
local ACCESS_KEY  = "cyan" -- TODO: replace with your access key / password

local function RevealMenu() Library:Toggle(true) end

local function RunPresentation()
    -- 1) Lightweight loading screen
    local Loading = Library:CreateLoading({
        Title = "Cyan", WindowWidth = 420, WindowHeight = 230,
        TotalSteps = 4, CurrentStep = 0, ShowSidebar = false,
    })
    Loading:SetMessage("Starting Cyan...")
    for Step = 1, 4 do
        Loading:SetCurrentStep(Step)
        Loading:SetMessage("Loading interface... (" .. Step .. "/4)")
        task.wait(0.3)
    end
    Loading:Destroy()

    -- 2) Key system in a separate, dedicated window
    if not REQUIRE_KEY then RevealMenu(); return end

    local LoadedKeySystem = LoadAddon("KeySystem", "addons/KeySystem.lua")
    if not LoadedKeySystem then RevealMenu(); return end

    local KeyWindow = Library:CreateWindow({
        Title = "Cyan | Access", Icon = CyanLogo,
        Center = true, AutoShow = true, Resizable = false,
        Size = UDim2.fromOffset(380, 340),
    })
    local KeyTab = KeyWindow:AddTab("Access", "lock")

    local Key = LoadedKeySystem.new({
        Validate = function(Key) return Key == ACCESS_KEY, "Invalid access key" end,
        MaxAttempts = 5,
        OnVerified = function()
            pcall(function()
                if KeyWindow.Destroy then KeyWindow:Destroy()
                elseif KeyWindow.Holder then KeyWindow.Holder.Visible = false
                elseif KeyWindow.Container then KeyWindow.Container.Visible = false end
            end)
            Library:Toggle(false); Library:Toggle(true) -- reveal main menu
        end,
    })
    Key:Attach(KeyTab)
    Library:Toggle(false) -- keep menu hidden while key window is open
end

local PresentOk, PresentErr = pcall(RunPresentation)
if not PresentOk then
    warn("[Cyan] Presentation failed, revealing menu directly: " .. tostring(PresentErr))
    Library:Toggle(true) -- never leave the user on a blank screen
end
```

### 2.4 Safety guarantees

* **The menu can never be stuck hidden by a bug.** `RunPresentation` is fully
  wrapped in `pcall`; any error (bad key‑window icon, missing module, API
  mismatch) reveals the menu directly.
* **The old "hidden tabs" bug is avoided.** The previous version hid tabs until
  a key was entered (`GateTabs`). This rewrite instead hides the *whole menu*
  and reveals it only after `OnVerified`, so every tab/option is present the
  moment the menu appears.
* **Disable any time:** set `REQUIRE_KEY = false` to skip the key window
  entirely.
* **Set your key:** change `ACCESS_KEY` (currently the demo value `"cyan"`).
  For a real product, point `Validate` at your key‑check endpoint instead of a
  static string.

---

## 3. UI/UX Refinement

### 3.1 Compact radar / minimap

The radar was `Size = 180`. Reduced to a compact `120`:

```lua
local RadarManager = Radar.new(Library, {
    Range = 150, Zoom = 1,
    Size = 120, -- compact radar / minimap
    Position = "TopLeft", ShowLocalFOV = true, FOVAngle = 90,
    BlipStyle = "Arrow", BlipSize = 4,
})
```

### 3.2 Static, centered menu

`CreateWindow` now uses `Center = true` and `Resizable = false`. The window is
pinned to the centre and cannot be resized, while every individual toggle,
slider, dropdown and keybind remains fully adjustable — satisfying *"crucial
elements stay static, other options stay adjustable."*

> To make the window **fully non‑draggable** (locked in place, no top‑bar
> drag), `Library:MakeDraggable(MainFrame, TopBar, …)` would need to be skipped
> for the main window. That is a one‑line Library change; it was left intact to
> preserve multi‑window drag behaviour. Say the word and it will be added behind
> a `Draggable = false` window option.

### 3.3 Clean / modern aesthetic

Cyan already ships a modern design system; the overhaul leans into it rather
than reinventing it:

* Glassmorphism panels (`Glass`, `GlassTransparency`, `GlassSheen`) — kept on.
* Rounded corners (`CornerRadius`, clamped to 20).
* Smooth tab/element tweens (`TabTransitionInfo`, `WindowAnimationInfo`).
* ESP/Aimbot **Combat tab split** into clearly separated `ESP` and `Aimbot`
  groupboxes for scannability.
* A **Diagnostics** groupbox in *Settings* (see §4).

> A full visual reskin (custom theme, fonts, spacing) is subjective and cannot
> be verified without rendering. The ThemeManager already supports custom
> themes (`ThemeManager:ApplyTheme` / `SetFolder`); a bespoke palette can be
> dropped in there.

---

## 4. Functionality Audit

### 4.1 Root cause of missing options

The recurring *"some options show, some don't"* is almost always **one addon
erroring during build**, which previously aborted the rest of the script. The
fixes in §1 eliminate the cascade. Remaining, per‑addon failures are now:

* caught (the addon's later controls still won't build, but everything else
  does), and
* **surfaced visibly** via the new **Diagnostics** panel.

### 4.2 Diagnostics panel (Settings tab)

```lua
do
    local DiagGroup = Tabs.Settings:AddLeftGroupbox("Diagnostics", "activity")
    DiagGroup:AddLabel("Addon load / build status:")
    for _, Name in ipairs({ "ESP", "Radar", "Movement", "Visuals", "Camera",
        "Server Info", "Protections", "QoL", "UI Utilities", "Player", "Weapon Mods" }) do
        local S = AddonStatus[Name]
        if S and S.Ok then
            DiagGroup:AddLabel("  [OK]   " .. Name)
        else
            local Detail = (S and S.Err and tostring(S.Err) or "no status"):gsub("\n", " "):sub(1, 70)
            DiagGroup:AddLabel("  [FAIL] " .. Name .. ": " .. Detail)
        end
    end
end
```

After a fresh load, open **Settings → Diagnostics**. Any addon showing
`[FAIL]` names the exact module and the error it hit on your game — that is the
precise target for the next fix, instead of guessing.

### 4.3 Best‑effort features

`Player` (GodMode/Teleport) and `WeaponMods` (NoRecoil/NoSpread/InfiniteAmmo/
RapidFire) act on each game's own systems via `pcall`‑guarded property edits.
They cannot be made universal across every Roblox game; if one game exposes
different instances, that addon may report a benign failure — captured by
Diagnostics rather than breaking the menu.

---

## 5. How to verify on your executor

1. **Clear the executor/script cache**, then re‑run the script (stale cached
   `Example.lua` is the other common cause of "missing options").
2. The **loading screen** appears, then the **key window** (`Cyan | Access`).
   Enter the key (`ACCESS_KEY`, currently `"cyan"`).
3. On success the key window closes and the **main menu** appears.
4. Open **Settings → Diagnostics**. All addons should read `[OK]`. Any `[FAIL]`
   entry tells you exactly what to report.

---

## 6. Summary of changes (this session)

| Area | Change |
|------|--------|
| Architecture | `LoadAddon` pcall‑wraps every module load |
| Architecture | `SafeSetup` pcall‑wraps every addon build; `AddonStatus` tracking |
| Diagnostics | New `Diagnostics` groupbox in Settings |
| Loading | `Library:CreateLoading` lightweight screen before the menu |
| Key System | Dedicated key window; menu revealed only on `OnVerified` |
| UI/UX | Radar `Size` 180 → 120 (compact) |
| UI/UX | Menu `Center = true`, `Resizable = false`, `AutoShow = false` |
| UI/UX | Combat tab split into `ESP` + `Aimbot` groupboxes |

**Not pushed to GitHub** (per standing instruction) — changes are committed
locally. Provide the intended access key and any aesthetic direction and the
remaining polish (custom theme, non‑draggable lock, bespoke layout) can be
applied.
