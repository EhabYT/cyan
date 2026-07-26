--!strict
-- Cyan Weapon Mods add-on (best-effort, game-dependent).
-- These attempt to neutralize common weapon properties. Effectiveness depends
-- entirely on the game's weapon implementation; treat them as conveniences.

local WeaponMods = {}
WeaponMods.__index = WeaponMods

local Players: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

export type WeaponModOptions = {
    NoRecoil: boolean?,
    NoSpread: boolean?,
    InfiniteAmmo: boolean?,
    RapidFire: boolean?,
}

function WeaponMods.new(Library, Options: WeaponModOptions?)
    Options = Options or {}
    local Self = setmetatable({}, WeaponMods)

    Self.Flags = {
        NoRecoil = Options.NoRecoil or false,
        NoSpread = Options.NoSpread or false,
        InfiniteAmmo = Options.InfiniteAmmo or false,
        RapidFire = Options.RapidFire or false,
    }
    Self._Connection = nil

    local function GetTool()
        local Character = LocalPlayer.Character
        if not Character then
            return nil
        end
        return Character:FindFirstChildOfClass("Tool")
            or Character:FindFirstChildOfClass("HopperBin")
    end

    local function SetIfPresent(Tool, Name, Value)
        pcall(function()
            if Tool[Name] ~= nil then
                Tool[Name] = Value
            end
        end)
    end

    local function Apply()
        local Tool = GetTool()
        if not Tool then
            return
        end
        if Self.Flags.NoRecoil then
            SetIfPresent(Tool, "Recoil", 0)
        end
        if Self.Flags.NoSpread then
            SetIfPresent(Tool, "Spread", 0)
        end
        if Self.Flags.InfiniteAmmo then
            SetIfPresent(Tool, "Ammo", 999999)
            SetIfPresent(Tool, "Clip", 999999)
            SetIfPresent(Tool, "ClipSize", 999999)
        end
        if Self.Flags.RapidFire then
            SetIfPresent(Tool, "FireRate", 0.05)
            SetIfPresent(Tool, "Cooldown", 0)
            SetIfPresent(Tool, "FireCooldown", 0)
        end
    end

    function Self:Set(Name: string, Enabled: boolean)
        if Self.Flags[Name] == nil then
            return
        end
        Self.Flags[Name] = Enabled
        local Any = Self.Flags.NoRecoil
            or Self.Flags.NoSpread
            or Self.Flags.InfiniteAmmo
            or Self.Flags.RapidFire
        if Any and not Self._Connection then
            Self._Connection = RunService.Heartbeat:Connect(Apply)
        elseif not Any and Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    function Self:Destroy()
        if Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    return Self
end

return WeaponMods
