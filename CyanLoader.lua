-- Cyan — Standalone Loader (compact, menu always visible)
-- Loads the official Cyan library + addons over HttpGet, builds every addon
-- control inside SafeSetup (pcall) so one failing addon can NEVER blank the
-- rest of the menu, and shows the menu immediately (no key-gate, no
-- Library:Toggle(false)). Host this file anywhere (pastebin / gist) and run it
-- with loadstring. It pulls Library.lua + the addons from the official repo,
-- which are already correct (v26.7.6).

local warn = (warn or print)

local repo = "https://raw.githubusercontent.com/EhabYT/cyan/main/"

-- pcall-wrapped module loader: a single failed download / compile / run can
-- never abort the whole script (which would otherwise blank every control
-- defined after it).
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

local Library = LoadAddon("Library", "Library.lua")
local ThemeManager = LoadAddon("ThemeManager", "addons/ThemeManager.lua")
local SaveManager = LoadAddon("SaveManager", "addons/SaveManager.lua")
local HUD = LoadAddon("HUD", "addons/HUD.lua")
local ESP = LoadAddon("ESP", "addons/ESP.lua")
local Radar = LoadAddon("Radar", "addons/Radar.lua")
local Movement = LoadAddon("Movement", "addons/Movement.lua")
local Visuals = LoadAddon("Visuals", "addons/Visuals.lua")
local Camera = LoadAddon("Camera", "addons/Camera.lua")
local Protections = LoadAddon("Protections", "addons/Protections.lua")
local ServerInfo = LoadAddon("ServerInfo", "addons/ServerInfo.lua")
local QoL = LoadAddon("QoL", "addons/QoL.lua")
local UIUtilities = LoadAddon("UIUtilities", "addons/UIUtilities.lua")
local Player = LoadAddon("Player", "addons/Player.lua")
local WeaponMods = LoadAddon("WeaponMods", "addons/WeaponMods.lua")

local Options = Library.Options
local Toggles = Library.Toggles

-- Tracks each addon's load/build outcome so the Diagnostics panel can name the
-- exact addon (if any) that failed, instead of leaving you guessing why some
-- options are missing.
local AddonStatus = {}

-- SafeSetup wraps an addon's UI/setup block in pcall so a single runtime error
-- in one addon can never blank out the rest of the menu. If an addon throws
-- while building its controls, the others keep loading and a notification is
-- shown instead of the whole menu silently dying.
local function SafeSetup(Name, Fn)
    local Ok, Err = pcall(Fn)
    AddonStatus[Name] = { Ok = Ok, Err = Err }
    if not Ok then
        warn(string.format("[Cyan] %s failed to load: %s", Name, tostring(Err)))
        if Library and Library.Notify then
            pcall(
                Library.Notify,
                Library,
                string.format("Cyan: %s could not load. See console.", Name),
                8
            )
        end
    end
end

Library.ForceCheckbox = false
Library.ShowToggleFrameInKeybinds = true -- toggle keybinds work inside keybinds UI; good for mobile

local Window = Library:CreateWindow({
    Title = "Cyan",
    Footer = "standalone loader",
    NotifySide = "Right",
    ShowCustomCursor = true,
    Center = true, -- centered, static menu (does not drift around the screen)
    Resizable = true, -- resizable so mobile/desktop users can fit & reveal all groupbox columns
    MobileButtonsSide = "Right", -- UI toggle & lock buttons on the right (thumb-friendly on mobile)
    -- AutoShow is intentionally left at its default (true) and there is NO
    -- Library:Toggle(false) call anywhere — the menu is shown immediately.
})

local Tabs = {
    Combat = Window:AddTab("Combat", "swords"),
    Player = Window:AddTab("Player", "user"),
    World = Window:AddTab("World", "globe"),
    Misc = Window:AddTab("Misc", "cube"),
    Settings = Window:AddTab("Settings", "settings"),
}

local function SetupESP()
    local ESPManager = ESP.new(Library, {
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 50, 50),
        DefaultBoxColor = Color3.fromRGB(255, 255, 255),
    })

    local ESPGroup = Tabs.Combat:AddRightGroupbox("ESP", "eye")

    ESPGroup:AddToggle("ESPToggle", {
        Text = "Enable ESP",
        Default = true,
        Callback = function(Value)
            ESPManager:SetEnabled(Value)
        end,
    })

    ESPGroup:AddToggle("ESPBoxes", {
        Text = "Boxes",
        Default = true,
        Callback = function(Value)
            ESPManager:SetBoxesVisible(Value)
        end,
    })

    ESPGroup:AddToggle("ESPNames", {
        Text = "Names",
        Default = true,
        Callback = function(Value)
            ESPManager:SetNamesVisible(Value)
        end,
    })

    ESPGroup:AddToggle("ESPTracers", {
        Text = "Tracers",
        Default = false,
        Callback = function(Value)
            ESPManager:SetTracersVisible(Value)
        end,
    })

    ESPGroup:AddToggle("ESPTeamCheck", {
        Text = "Team Check",
        Default = false,
        Tooltip = "Hides ESP for players on the same team.",
        Callback = function(Value)
            ESPManager:SetTeamCheck(Value)
        end,
    })

    ESPGroup:AddDropdown("ESPBoxStyle", {
        Values = { "Corner", "Standard", "Outline" },
        Default = "Corner",
        Text = "Box Style",
        Callback = function(Value)
            if ESPManager.Players then
                for _, Handler in ESPManager.Players do
                    if Handler and Handler.Options then
                        Handler.Options.BoxStyle = Value
                    end
                end
            end
        end,
    })

    ESPGroup:AddDivider()

    ESPGroup:AddLabel("FOV Circle"):AddKeyPicker("FOVKeybind", {
        Default = "F",
        Mode = "Toggle",
        Text = "Toggle FOV circle",
        NoUI = false,
        Callback = function(Value)
            ESPManager:ShowFOVCircle(Value)
        end,
    })

    ESPGroup:AddSlider("FOVRadius", {
        Text = "FOV Radius",
        Default = 60,
        Min = 10,
        Max = 300,
        Rounding = 0,
        Callback = function(Value)
            ESPManager:SetFOVCircle({
                Radius = Value,
                Color = Color3.fromRGB(255, 255, 255),
                Transparency = 0.85,
                Enabled = Toggles.FOVKeybind and Toggles.FOVKeybind:GetState() or false,
            })
        end,
    })

    ESPGroup:AddToggle("FOVFilled", {
        Text = "Filled",
        Default = false,
        Callback = function(Value)
            ESPManager:SetFOVCircle({
                Filled = Value,
                Enabled = Toggles.FOVKeybind and Toggles.FOVKeybind:GetState() or false,
            })
        end,
    })

    ESPGroup:AddDivider()

    local AimGroup = Tabs.Combat:AddLeftGroupbox("Aimbot", "crosshair")
    AimGroup:AddLabel("Aimbot helpers")
    AimGroup:AddButton({
        Text = "Lock nearest target",
        Func = function()
            local Target = ESPManager:GetNearestPlayerToMouse(200)
            if Target then
                ESPManager:LockOntoTarget(Target)
                Library:Notify({
                    Title = "Target locked",
                    Description = "Locked onto " .. Target.Name,
                    Time = 2,
                })
            else
                Library:Notify("No target found within range.")
            end
        end,
    })

    AimGroup:AddButton({
        Text = "Unlock target",
        Func = function()
            ESPManager:UnlockTarget()
            Library:Notify("Target released.")
        end,
    })

    AimGroup:AddDivider()
    AimGroup:AddLabel("Aimbot")

    AimGroup:AddToggle("AimbotEnabled", {
        Text = "Aimbot",
        Default = false,
        Tooltip = "Enables the aimbot system.",
        Callback = function(Value)
            ESPManager:SetAimbotEnabled(Value)
        end,
    })

    AimGroup:AddToggle("SilentAim", {
        Text = "Silent Aim",
        Default = false,
        Tooltip = "Silently rotates your character toward the target without visible snapping.",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ SilentAim = Value })
        end,
    })

    AimGroup:AddToggle("AutoFire", {
        Text = "Auto Fire",
        Default = false,
        Tooltip = "Automatically fires your equipped tool when a target is in FOV.",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ AutoFire = Value })
        end,
    })

    AimGroup:AddSlider("AutoFireDelay", {
        Text = "Auto Fire Delay",
        Default = 0.15,
        Min = 0.05,
        Max = 1,
        Rounding = 2,
        Suffix = "s",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ AutoFireDelay = Value })
        end,
    })

    AimGroup:AddSlider("AimbotFOV", {
        Text = "Aimbot FOV",
        Default = 60,
        Min = 5,
        Max = 360,
        Rounding = 0,
        Suffix = "\u{00B0}",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ FOV = Value })
        end,
    })

    AimGroup:AddSlider("AimbotSmoothness", {
        Text = "Smoothness",
        Default = 0.8,
        Min = 0,
        Max = 1,
        Rounding = 2,
        Suffix = "",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ Smoothness = Value })
        end,
    })

    AimGroup:AddSlider("PredictionAmount", {
        Text = "Prediction",
        Default = 0.5,
        Min = 0,
        Max = 2,
        Rounding = 1,
        Suffix = "",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ PredictionAmount = Value })
        end,
    })

    AimGroup:AddDropdown("AimbotHitbox", {
        Text = "Hitbox",
        Values = { "Head", "Torso", "Limb", "Random" },
        Default = "Torso",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ Hitbox = Value })
        end,
    })

    AimGroup:AddDivider()
    AimGroup:AddLabel("Magic Bullet")

    AimGroup:AddToggle("MagicBullet", {
        Text = "Magic Bullet",
        Default = false,
        Tooltip = "Redirects fired projectiles to the locked target.",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ MagicBullet = Value })
        end,
    })

    AimGroup:AddSlider("MagicBulletChance", {
        Text = "Hit Chance",
        Default = 100,
        Min = 1,
        Max = 100,
        Rounding = 0,
        Suffix = "%",
        Callback = function(Value)
            ESPManager:SetAimbotOptions({ MagicBulletChance = Value })
        end,
    })

    -- Start ESP after a short delay to let players load
    task.delay(2, function()
        if Library.Unloaded then
            return
        end

        ESPManager:AddPlayerESP({
            Box = true,
            BoxStyle = "Corner",
            HealthBar = true,
            Name = true,
            Distance = true,
            Tracer = false,
            Chams = false,
            TeamCheck = false,
        })

        ESPManager:SetFOVCircle({
            Radius = 60,
            Color = Color3.fromRGB(255, 255, 255),
            Transparency = 0.85,
            Filled = false,
            Enabled = false,
        })
    end)
end

SafeSetup("ESP", SetupESP)

-- Radar setup
local function SetupRadar()
    local RadarManager = Radar.new(Library, {
        Range = 150,
        Zoom = 1,
        Size = 120, -- compact radar / minimap
        Position = "TopLeft",
        ShowLocalFOV = true,
        FOVAngle = 90,
        BlipStyle = "Arrow",
        BlipSize = 4,
        ShowNames = false,
        ShowGrid = true,
        TeamColor = Color3.fromRGB(0, 255, 0),
        EnemyColor = Color3.fromRGB(255, 50, 50),
        LocalColor = Color3.fromRGB(0, 150, 255),
        Visible = true,
    })

    local RadarGroup = Tabs.Player:AddLeftGroupbox("Radar", "compass")

    RadarGroup:AddToggle("RadarToggle", {
        Text = "Enable Radar",
        Default = true,
        Callback = function(Value)
            RadarManager:SetVisible(Value)
        end,
    })

    RadarGroup:AddSlider("RadarRange", {
        Text = "Range",
        Default = 150,
        Min = 50,
        Max = 500,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            RadarManager:SetRange(Value)
        end,
    })

    RadarGroup:AddSlider("RadarZoom", {
        Text = "Zoom",
        Default = 1,
        Min = 0.5,
        Max = 3,
        Rounding = 1,
        Callback = function(Value)
            RadarManager:SetZoom(Value)
        end,
    })

    RadarGroup:AddDropdown("RadarPosition", {
        Values = { "TopLeft", "TopRight", "BottomLeft", "BottomRight" },
        Default = "TopLeft",
        Text = "Position",
        Callback = function(Value)
            RadarManager:SetPosition(Value)
        end,
    })

    RadarGroup:AddDropdown("RadarBlipStyle", {
        Values = { "Arrow", "Dot", "Ring" },
        Default = "Arrow",
        Text = "Blip Style",
        Callback = function(Value)
            RadarManager:SetBlipStyle(Value)
        end,
    })

    RadarGroup:AddToggle("RadarNames", {
        Text = "Show Names",
        Default = false,
        Callback = function(Value)
            RadarManager:SetShowNames(Value)
        end,
    })

    RadarGroup:AddSlider("RadarBlipSize", {
        Text = "Blip Size",
        Default = 4,
        Min = 2,
        Max = 10,
        Rounding = 0,
        Callback = function(Value)
            RadarManager:SetBlipSize(Value)
        end,
    })

    RadarGroup:AddToggle("RadarFOV", {
        Text = "Show FOV Cone",
        Default = true,
        Callback = function(Value)
            RadarManager:SetShowFOV(Value)
        end,
    })

    RadarGroup:AddSlider("RadarFOVAngle", {
        Text = "FOV Angle",
        Default = 90,
        Min = 10,
        Max = 360,
        Rounding = 0,
        Suffix = "\u{00B0}",
        Callback = function(Value)
            RadarManager:SetFOVAngle(Value)
        end,
    })
end

SafeSetup("Radar", SetupRadar)

-- Movement addon
local function SetupMovement()
    local MovementManager = Movement.new(Library, {
        WalkSpeed = 16,
        JumpPower = 50,
        FlySpeed = 50,
        AutoNoclipWhenFlying = true,
    })

    local MoveGroup = Tabs.Player:AddRightGroupbox("Movement", "zap")

    MoveGroup:AddToggle("WalkSpeedToggle", {
        Text = "Override WalkSpeed",
        Default = false,
        Callback = function(Value)
            if Value then
                MovementManager:SetWalkSpeed(Options.WalkSpeedSlider.Value, true)
            else
                MovementManager:SetWalkSpeed(16, false)
            end
        end,
    })

    MoveGroup:AddSlider("WalkSpeedSlider", {
        Text = "WalkSpeed",
        Default = 16,
        Min = 1,
        Max = 250,
        Rounding = 0,
        Suffix = " studs/s",
        Callback = function(Value)
            if Toggles.WalkSpeedToggle and Toggles.WalkSpeedToggle.Value then
                MovementManager:SetWalkSpeed(Value, true)
            end
        end,
    })

    MoveGroup:AddToggle("JumpPowerToggle", {
        Text = "Override Jump Power",
        Default = false,
        Callback = function(Value)
            if Value then
                MovementManager:SetJumpPower(Options.JumpPowerSlider.Value, true)
            else
                MovementManager:SetJumpPower(50, false)
            end
        end,
    })

    MoveGroup:AddSlider("JumpPowerSlider", {
        Text = "Jump Power",
        Default = 50,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            if Toggles.JumpPowerToggle and Toggles.JumpPowerToggle.Value then
                MovementManager:SetJumpPower(Value, true)
            end
        end,
    })

    MoveGroup:AddDivider()

    MoveGroup:AddToggle("FlyToggle", {
        Text = "Fly",
        Default = false,
        Tooltip = "Press Space to go up, Shift to go down, Ctrl to sprint.",
        Callback = function(Value)
            MovementManager:SetFlying(Value)
        end,
    })

    MoveGroup:AddSlider("FlySpeedSlider", {
        Text = "Fly Speed",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Suffix = " studs/s",
        Callback = function(Value)
            MovementManager:SetFlySpeed(Value)
        end,
    })

    MoveGroup:AddToggle("NoclipToggle", {
        Text = "Noclip",
        Default = false,
        Tooltip = "Walk through walls and objects.",
        Callback = function(Value)
            MovementManager:SetNoclipping(Value)
        end,
    })

    MoveGroup:AddDivider()

    MoveGroup:AddLabel("Anti-tools")

    MoveGroup:AddToggle("AntiVoidToggle", {
        Text = "Anti Void",
        Default = false,
        Tooltip = "Teleports you back when falling below the map.",
        Callback = function(Value)
            MovementManager:SetAntiVoid(Value)
        end,
    })

    MoveGroup:AddToggle("AntiTeleportToggle", {
        Text = "Anti Teleport",
        Default = false,
        Tooltip = "Blocks forced teleportation beyond 500 studs.",
        Callback = function(Value)
            MovementManager:SetAntiTeleport(Value)
        end,
    })
end

SafeSetup("Movement", SetupMovement)

-- Visuals addon
local function SetupVisuals()
    local VisualsManager = Visuals.new(Library, {})

    local VisGroup = Tabs.World:AddLeftGroupbox("Visuals", "eye")

    VisGroup:AddToggle("FullbrightToggle", {
        Text = "Fullbright",
        Default = false,
        Tooltip = "Fully illuminates the world. Disables shadows and fog.",
        Callback = function(Value)
            VisualsManager:SetFullbright(Value)
        end,
    })

    VisGroup:AddToggle("NightVisionToggle", {
        Text = "Night Vision",
        Default = false,
        Tooltip = "Brightens dark areas with a green-tinted overlay.",
        Callback = function(Value)
            VisualsManager:SetNightVision(Value)
        end,
    })

    VisGroup:AddSlider("NightVisionIntensity", {
        Text = "Night Vision Strength",
        Default = 85,
        Min = 30,
        Max = 100,
        Rounding = 0,
        Suffix = "%",
        Callback = function(Value)
            VisualsManager:SetNightVision(
                Toggles.NightVisionToggle and Toggles.NightVisionToggle.Value or false,
                Value / 100
            )
        end,
    })

    VisGroup:AddToggle("XRayToggle", {
        Text = "X-Ray",
        Default = false,
        Tooltip = "Highlights players through walls.",
        Callback = function(Value)
            VisualsManager:SetXRay(Value)
        end,
    })

    VisGroup:AddDivider()

    VisGroup:AddToggle("FogOverrideToggle", {
        Text = "Fog Override",
        Default = false,
        Callback = function(Value)
            if Value then
                VisualsManager:SetFogOverride(
                    true,
                    Options.FogStartSlider.Value,
                    Options.FogEndSlider.Value
                )
            else
                VisualsManager:ResetFog()
            end
        end,
    })

    VisGroup:AddSlider("FogStartSlider", {
        Text = "Fog Start",
        Default = 0,
        Min = 0,
        Max = 500,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            if Toggles.FogOverrideToggle and Toggles.FogOverrideToggle.Value then
                VisualsManager:SetFogOverride(true, Value, Options.FogEndSlider.Value)
            end
        end,
    })

    VisGroup:AddSlider("FogEndSlider", {
        Text = "Fog End",
        Default = 1000,
        Min = 10,
        Max = 10000,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            if Toggles.FogOverrideToggle and Toggles.FogOverrideToggle.Value then
                VisualsManager:SetFogOverride(true, Options.FogStartSlider.Value, Value)
            end
        end,
    })

    VisGroup:AddDivider()

    VisGroup:AddToggle("FPSToggle", {
        Text = "FPS Counter",
        Default = false,
        Tooltip = "Shows real-time framerate in the top-right corner.",
        Callback = function(Value)
            VisualsManager:SetFPSCounter(Value)
        end,
    })
end

SafeSetup("Visuals", SetupVisuals)

-- Camera addon
local function SetupCamera()
    local CameraManager = Camera.new(Library, {
        ThirdPersonDistance = 8,
        FreecamSpeed = 50,
        FOV = 90,
    })

    local CamGroup = Tabs.World:AddRightGroupbox("Camera", "camera")

    CamGroup:AddToggle("ThirdPersonToggle", {
        Text = "Third Person",
        Default = false,
        Tooltip = "Switches to a third-person perspective behind your character.",
        Callback = function(Value)
            CameraManager:SetThirdPerson(Value)
        end,
    })

    CamGroup:AddSlider("ThirdPersonDistance", {
        Text = "Distance",
        Default = 8,
        Min = 1,
        Max = 30,
        Rounding = 1,
        Suffix = " studs",
        Callback = function(Value)
            CameraManager:SetThirdPerson(
                Toggles.ThirdPersonToggle and Toggles.ThirdPersonToggle.Value or false,
                Value
            )
        end,
    })

    CamGroup:AddDivider()

    CamGroup:AddToggle("FOVToggle", {
        Text = "Override FOV",
        Default = false,
        Tooltip = "Changes the camera field of view.",
        Callback = function(Value)
            CameraManager:SetFOV(Options.FOVSlider.Value, Value)
        end,
    })

    CamGroup:AddSlider("FOVSlider", {
        Text = "FOV",
        Default = 90,
        Min = 20,
        Max = 180,
        Rounding = 0,
        Suffix = "\u{00B0}",
        Callback = function(Value)
            if Toggles.FOVToggle and Toggles.FOVToggle.Value then
                CameraManager:SetFOV(Value, true)
            end
        end,
    })

    CamGroup:AddDivider()

    CamGroup:AddToggle("FreecamToggle", {
        Text = "Freecam",
        Default = false,
        Tooltip = "Detaches the camera from your character. WASD to move, mouse to look, E/Q or Space/Shift for vertical.",
        Callback = function(Value)
            CameraManager:SetFreecam(Value)
        end,
    })

    CamGroup:AddSlider("FreecamSpeed", {
        Text = "Freecam Speed",
        Default = 50,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Suffix = " studs/s",
        Callback = function(Value)
            CameraManager:SetFreecamSpeed(Value)
        end,
    })

    CamGroup:AddToggle("CameraSpinToggle", {
        Text = "Camera Spin",
        Default = false,
        Tooltip = "Orbits the camera around your character.",
        Callback = function(Value)
            CameraManager:SetSpin(Value)
        end,
    })

    CamGroup:AddSlider("CameraSpinSpeed", {
        Text = "Spin Speed",
        Default = 30,
        Min = 5,
        Max = 360,
        Rounding = 0,
        Suffix = "\u{00B0}/s",
        Callback = function(Value)
            CameraManager:SetSpin(
                Toggles.CameraSpinToggle and Toggles.CameraSpinToggle.Value or false,
                Value
            )
        end,
    })
end

SafeSetup("Camera", SetupCamera)

-- ServerInfo addon
local function SetupServerInfo()
    local ServerInfoManager = ServerInfo.new(Library, {
        ShowServerInfo = true,
        ShowPlayerInfo = true,
    })

    local ServerGroup = Tabs.World:AddLeftGroupbox("Server Info", "server")

    ServerGroup:AddToggle("ServerInfoToggle", {
        Text = "Show Server Info",
        Default = true,
        Tooltip = "Shows server statistics panel (FPS, ping, players, etc.).",
        Callback = function(Value)
            ServerInfoManager:SetVisible(Value)
        end,
    })

    ServerGroup:AddToggle("ServerInfoServerToggle", {
        Text = "Server Details",
        Default = true,
        Tooltip = "Show server data section in the panel.",
        Callback = function(Value)
            ServerInfoManager:SetShowServerInfo(Value)
        end,
    })

    ServerGroup:AddToggle("ServerInfoPlayerToggle", {
        Text = "Player Details",
        Default = true,
        Tooltip = "Show player info section in the panel.",
        Callback = function(Value)
            ServerInfoManager:SetShowPlayerInfo(Value)
        end,
    })

    ServerGroup:AddSlider("ServerInfoUpdateInterval", {
        Text = "Update Interval",
        Default = 0.3,
        Min = 0.1,
        Max = 2,
        Rounding = 1,
        Suffix = "s",
        Callback = function(Value)
            ServerInfoManager:SetUpdateInterval(Value)
        end,
    })
end

SafeSetup("Server Info", SetupServerInfo)

-- Protections addon
local function SetupProtections()
    local ProtectionManager = Protections.new(Library, {})

    local ProtGroup = Tabs.Misc:AddLeftGroupbox("Protections", "shield")

    ProtGroup:AddToggle("AntiKickToggle", {
        Text = "Anti Kick",
        Default = false,
        Tooltip = "Blocks kick attempts and optionally rejoins the server.",
        Callback = function(Value)
            ProtectionManager:SetAntiKick(
                Value,
                Toggles.AntiKickRejoinToggle and Toggles.AntiKickRejoinToggle.Value or false
            )
        end,
    })

    ProtGroup:AddToggle("AntiKickRejoinToggle", {
        Text = "Auto Rejoin on Kick",
        Default = true,
        Tooltip = "Automatically rejoins the server if kicked.",
        Callback = function(Value)
            if Toggles.AntiKickToggle and Toggles.AntiKickToggle.Value then
                ProtectionManager:SetAntiKick(true, Value)
            end
        end,
    })

    ProtGroup:AddDivider()

    ProtGroup:AddToggle("AntiCrashToggle", {
        Text = "Anti Crash",
        Default = false,
        Tooltip = "Filters out crash exploits: massive parts, sounds, meshes, and particles.",
        Callback = function(Value)
            ProtectionManager:SetAntiCrash(Value)
        end,
    })

    ProtGroup:AddToggle("AntiIdleToggle", {
        Text = "Anti Idle",
        Default = false,
        Tooltip = "Prevents auto-kick for being idle by simulating small movements.",
        Callback = function(Value)
            ProtectionManager:SetAntiIdle(Value)
        end,
    })

    ProtGroup:AddSlider("AntiIdleInterval", {
        Text = "Idle Interval",
        Default = 30,
        Min = 10,
        Max = 120,
        Rounding = 0,
        Suffix = "s",
        Callback = function(Value)
            ProtectionManager:SetAntiIdle(
                Toggles.AntiIdleToggle and Toggles.AntiIdleToggle.Value or false,
                Value
            )
        end,
    })

    ProtGroup:AddDivider()

    ProtGroup:AddToggle("AntiLagToggle", {
        Text = "Anti Lag",
        Default = false,
        Tooltip = "Lowers graphics quality and disables effects for better performance.",
        Callback = function(Value)
            ProtectionManager:SetAntiLag(Value)
        end,
    })

    ProtGroup:AddDropdown("AntiLagGraphicsLevel", {
        Text = "Graphics Level",
        Values = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" },
        Default = "1",
        Callback = function(Value)
            local Level = tonumber(Value)
            ProtectionManager:SetAntiLagGraphicsLevel(Level)
            if Toggles.AntiLagToggle and Toggles.AntiLagToggle.Value then
                ProtectionManager:SetAntiLag(true, Level)
            end
        end,
    })
end

SafeSetup("Protections", SetupProtections)

-- QoL addon
local function SetupQoL()
    local QoLManager = QoL.new(Library, {})

    local QoLGroup = Tabs.Misc:AddLeftGroupbox("Misc / QoL", "cube")

    QoLGroup:AddButton({
        Text = "Rejoin Server",
        Tooltip = "Leaves and rejoins the current server.",
        Callback = function()
            QoLManager:RejoinServer()
        end,
    })

    QoLGroup:AddButton({
        Text = "Copy Server Link",
        Tooltip = "Copies the current server link to clipboard.",
        Callback = function()
            local Link = QoLManager:CopyServerLink()
            Library:Notify({ Description = "Server link copied:\n" .. Link, Time = 5 })
        end,
    })

    QoLGroup:AddButton({
        Text = "Server Hop",
        Tooltip = "Teleports to a new random server of this game.",
        Callback = function()
            QoLManager:ServerHop()
        end,
    })

    QoLGroup:AddDivider()

    QoLGroup:AddToggle("ItemEspToggle", {
        Text = "Item ESP",
        Default = false,
        Tooltip = "Highlights dropped items within range.",
        Callback = function(Value)
            QoLManager:SetItemEsp(Value)
        end,
    })

    QoLGroup:AddSlider("ItemEspRange", {
        Text = "Item ESP Range",
        Default = 100,
        Min = 10,
        Max = 500,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            QoLManager:SetItemEspRange(Value)
        end,
    })

    QoLGroup:AddToggle("AutoCollectToggle", {
        Text = "Auto Collect",
        Default = false,
        Tooltip = "Automatically walks to nearby collectible items.",
        Callback = function(Value)
            QoLManager:SetAutoCollect(Value)
        end,
    })

    QoLGroup:AddSlider("AutoCollectRange", {
        Text = "Collect Range",
        Default = 20,
        Min = 5,
        Max = 100,
        Rounding = 0,
        Suffix = " studs",
        Callback = function(Value)
            QoLManager:SetAutoCollectRange(Value)
        end,
    })

    QoLGroup:AddDivider()

    QoLGroup:AddToggle("AntiVoidToggle", {
        Text = "Anti Void",
        Default = false,
        Tooltip = "Teleports you back above Y=-50 if you fall into the void.",
        Callback = function(Value)
            QoLManager:SetAntiVoid(Value)
        end,
    })

    QoLGroup:AddSlider("AntiVoidY", {
        Text = "Void Y Level",
        Default = -50,
        Min = -500,
        Max = 0,
        Rounding = 0,
        Callback = function(Value)
            QoLManager:SetAntiVoidY(Value)
        end,
    })

    QoLGroup:AddToggle("AutoClickToggle", {
        Text = "Auto Click",
        Default = false,
        Tooltip = "Automatically clicks with your held tool.",
        Callback = function(Value)
            QoLManager:SetAutoClick(Value)
        end,
    })

    QoLGroup:AddSlider("AutoClickInterval", {
        Text = "Click Interval",
        Default = 0.1,
        Min = 0.02,
        Max = 1,
        Rounding = 2,
        Suffix = "s",
        Callback = function(Value)
            QoLManager:SetAutoClickInterval(Value)
        end,
    })

    QoLGroup:AddDivider()

    QoLGroup:AddSlider("QoLWalkSpeed", {
        Text = "WalkSpeed",
        Default = 16,
        Min = 1,
        Max = 200,
        Rounding = 0,
        Callback = function(Value)
            QoLManager:SetCharacterWalkSpeed(Value)
        end,
    })

    QoLGroup:AddSlider("QoLJumpPower", {
        Text = "Jump Power",
        Default = 50,
        Min = 1,
        Max = 500,
        Rounding = 0,
        Callback = function(Value)
            QoLManager:SetCharacterJumpPower(Value)
        end,
    })

    QoLGroup:AddButton({
        Text = "Reset WalkSpeed / Jump",
        Tooltip = "Resets WalkSpeed to 16 and Jump Power to 50.",
        Callback = function()
            QoLManager:ResetCharacterModifiers()
        end,
    })
end

SafeSetup("QoL", SetupQoL)

-- UI Utilities addon
local function SetupUIUtilities()
    local UIManager = UIUtilities.new(Library, {
        Watermark = {
            Title = "Cyan Hub",
            ShowFPS = true,
            ShowPing = true,
            ShowPlayers = true,
            ShowTime = true,
        },
        ColorPalette = {
            Visible = false,
        },
    })

    local UIGroup = Tabs.Misc:AddRightGroupbox("UI Utilities", "palette")

    UIGroup:AddToggle("WatermarkToggle", {
        Text = "Watermark",
        Default = true,
        Tooltip = "Shows an on-screen watermark with FPS, ping, and player info.",
        Callback = function(Value)
            UIManager:SetWatermarkVisible(Value)
        end,
    })

    UIGroup:AddToggle("WatermarkFPS", {
        Text = "Show FPS",
        Default = true,
        Callback = function(Value)
            UIManager:SetWatermarkOption("FPS", Value)
        end,
    })

    UIGroup:AddToggle("WatermarkPing", {
        Text = "Show Ping",
        Default = true,
        Callback = function(Value)
            UIManager:SetWatermarkOption("Ping", Value)
        end,
    })

    UIGroup:AddToggle("WatermarkPlayers", {
        Text = "Show Players",
        Default = true,
        Callback = function(Value)
            UIManager:SetWatermarkOption("Players", Value)
        end,
    })

    UIGroup:AddToggle("WatermarkTime", {
        Text = "Show Time",
        Default = true,
        Callback = function(Value)
            UIManager:SetWatermarkOption("Time", Value)
        end,
    })

    UIGroup:AddDivider()

    UIGroup:AddToggle("PaletteToggle", {
        Text = "Color Palette",
        Default = false,
        Tooltip = "Shows a palette of preset colors. Click to copy RGB to clipboard.",
        Callback = function(Value)
            UIManager:SetPaletteVisible(Value)
        end,
    })

    UIGroup:AddDivider()

    UIGroup:AddLabel("Notification Presets")
    UIGroup:AddButton({
        Text = "Test Success",
        Callback = function()
            UIManager:NotifySuccess("Operation completed successfully.")
        end,
    })
    UIGroup:AddButton({
        Text = "Test Error",
        Callback = function()
            UIManager:NotifyError("Something went wrong.")
        end,
    })
    UIGroup:AddButton({
        Text = "Test Info",
        Callback = function()
            UIManager:NotifyInfo("Here is some information.")
        end,
    })
    UIGroup:AddButton({
        Text = "Test Warning",
        Callback = function()
            UIManager:NotifyWarning("This is a warning message.")
        end,
    })
end

SafeSetup("UI Utilities", SetupUIUtilities)

-- Player add-on: teleport utilities + best-effort God Mode.
local function SetupPlayer()
    local PlayerManager = Player.new(Library, {})

    local PlayerGroup = Tabs.Player:AddLeftGroupbox("Player", "user")

    local PlayerService = game:GetService("Players")

    local TeleportDropdown = PlayerGroup:AddDropdown("TeleportTarget", {
        Text = "Teleport Target",
        Values = (function()
            local Names = {}
            for _, Plr in PlayerService:GetPlayers() do
                if Plr ~= PlayerService.LocalPlayer then
                    table.insert(Names, Plr.Name)
                end
            end
            return Names
        end)(),
        Default = nil,
        AllowNull = true,
    })

    -- Keep the target list live as players join and leave.
    local function RefreshTeleportTargets()
        local Names = {}
        for _, Plr in PlayerService:GetPlayers() do
            if Plr ~= PlayerService.LocalPlayer then
                table.insert(Names, Plr.Name)
            end
        end
        TeleportDropdown:SetValues(Names)
    end

    Library:GiveSignal(PlayerService.PlayerAdded:Connect(RefreshTeleportTargets))
    Library:GiveSignal(PlayerService.PlayerRemoving:Connect(RefreshTeleportTargets))

    PlayerGroup:AddButton({
        Text = "Refresh Player List",
        Callback = RefreshTeleportTargets,
    })

    PlayerGroup:AddButton({
        Text = "Teleport to Player",
        Callback = function()
            PlayerManager:TeleportToPlayer(Options.TeleportTarget.Value)
        end,
    })

    PlayerGroup:AddButton({
        Text = "Teleport to Mouse",
        Callback = function()
            PlayerManager:TeleportToMouse()
        end,
    })

    PlayerGroup:AddToggle("GodMode", {
        Text = "God Mode",
        Default = false,
        Tooltip = "Best-effort health lock; may not work in games with custom health systems.",
        Callback = function(Value)
            PlayerManager:SetGodMode(Value)
        end,
    })
end

SafeSetup("Player", SetupPlayer)

-- Weapon Mods add-on (best-effort, game-dependent).
local function SetupWeaponMods()
    local WeaponModsManager = WeaponMods.new(Library, {})

    local WeaponGroup = Tabs.Combat:AddLeftGroupbox("Weapon Mods", "swords")

    WeaponGroup:AddToggle("NoRecoil", {
        Text = "No Recoil",
        Default = false,
        Callback = function(Value)
            WeaponModsManager:Set("NoRecoil", Value)
        end,
    })

    WeaponGroup:AddToggle("NoSpread", {
        Text = "No Spread",
        Default = false,
        Callback = function(Value)
            WeaponModsManager:Set("NoSpread", Value)
        end,
    })

    WeaponGroup:AddToggle("InfiniteAmmo", {
        Text = "Infinite Ammo",
        Default = false,
        Callback = function(Value)
            WeaponModsManager:Set("InfiniteAmmo", Value)
        end,
    })

    WeaponGroup:AddToggle("RapidFire", {
        Text = "Rapid Fire",
        Default = false,
        Callback = function(Value)
            WeaponModsManager:Set("RapidFire", Value)
        end,
    })
end

SafeSetup("Weapon Mods", SetupWeaponMods)

-- Addons:
-- SaveManager (Allows you to have a configuration system)
-- ThemeManager (Allows you to have a menu theme system)

-- Hand the library over to our managers
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

-- Ignore keys that are used by ThemeManager.
-- (we dont want configs to save themes, do we?)
SaveManager:IgnoreThemeSettings()

-- Adds our MenuKeybind to the ignore list
-- (do you want each config to have a different menu key? probably not.)
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })

-- use case for doing it this way:
-- a script hub could have themes in a global folder
-- and game configs in a separate folder per game
ThemeManager:SetFolder("MyScriptHub")
SaveManager:SetFolder("MyScriptHub/specific-game")
SaveManager:SetSubFolder("specific-place") -- if the game has multiple places inside of it (for example: DOORS)
-- you can use this to save configs for those places separately
-- The path in this script would be: MyScriptHub/specific-game/settings/specific-place
-- [ This is optional ]

-- Builds our config menu on the right side of our tab
SaveManager:BuildConfigSection(Tabs.Settings)

-- Builds our theme menu (with plenty of built in themes) on the left side
-- NOTE: you can also call ThemeManager:ApplyToGroupbox to add it to a specific groupbox
ThemeManager:ApplyToTab(Tabs.Settings)

-- You can use the SaveManager:LoadAutoloadConfig() to load a config
-- which has been marked to be one that auto loads!
SaveManager:LoadAutoloadConfig()

-- Diagnostics: shows each addon's load/build status so missing options can be
-- pinpointed instead of guessed. A [FAIL] entry names the exact addon that
-- failed and the error it hit on your game. Failures are also surfaced as a
-- startup notification so you never have to hunt for them.
local AddonNames = {
    "ESP",
    "Radar",
    "Movement",
    "Visuals",
    "Camera",
    "Server Info",
    "Protections",
    "QoL",
    "UI Utilities",
    "Player",
    "Weapon Mods",
}

do
    local DiagGroup = Tabs.Settings:AddLeftGroupbox("Diagnostics", "activity")
    DiagGroup:AddLabel("Addon load / build status:")

    local Failed = {}
    for _, Name in ipairs(AddonNames) do
        local S = AddonStatus[Name]
        if S and S.Ok then
            DiagGroup:AddLabel("  [OK]   " .. Name)
        else
            table.insert(Failed, Name)
            local Detail = (S and S.Err and tostring(S.Err) or "no status")
                :gsub("\n", " ")
                :sub(1, 70)
            DiagGroup:AddLabel("  [FAIL] " .. Name .. ": " .. Detail)
        end
    end

    if #Failed > 0 and Library and Library.Notify then
        pcall(
            Library.Notify,
            Library,
            string.format(
                "Cyan: %d addon(s) failed to load: %s. See Settings > Diagnostics.",
                #Failed,
                table.concat(Failed, ", ")
            ),
            10
        )
    end
end
