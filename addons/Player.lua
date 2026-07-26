--!strict
-- Cyan Player add-on: teleport utilities and a best-effort God Mode.
-- God Mode is a generic health lock and may not cover games that use a custom
-- health/damage system; it is provided as a convenience toggle.

local Player = {}
Player.__index = Player

local Players: Players = game:GetService("Players")
local RunService: RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

export type PlayerOptions = {
    GodMode: boolean?,
}

function Player.new(Library, Options: PlayerOptions?)
    Options = Options or {}
    local Self = setmetatable({}, Player)

    Self._GodMode = false
    Self._Connection = nil

    local function CharacterRoot()
        local Character = LocalPlayer.Character
        if not Character then
            return nil
        end
        return Character:FindFirstChild("HumanoidRootPart") or Character:FindFirstChild("Torso")
    end

    function Self:SetGodMode(Enabled: boolean)
        Self._GodMode = Enabled
        if Enabled then
            Self._Connection = RunService.Heartbeat:Connect(function()
                local Character = LocalPlayer.Character
                if not Character then
                    return
                end
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                if Humanoid and Humanoid.Health < Humanoid.MaxHealth then
                    pcall(function()
                        Humanoid.Health = Humanoid.MaxHealth
                    end)
                end
            end)
        elseif Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    function Self:TeleportToPlayer(Name: string?)
        if not Name then
            return
        end
        local Target = Players:FindFirstChild(Name)
        if not Target or not Target.Character then
            return
        end
        local TargetRoot = Target.Character:FindFirstChild("HumanoidRootPart")
            or Target.Character:FindFirstChild("Torso")
        local MyRoot = CharacterRoot()
        if TargetRoot and MyRoot then
            pcall(function()
                MyRoot.CFrame = TargetRoot.CFrame
            end)
        end
    end

    function Self:TeleportToMouse()
        local Mouse = LocalPlayer:GetMouse()
        if not Mouse then
            return
        end
        local MyRoot = CharacterRoot()
        if Mouse.Hit and MyRoot then
            pcall(function()
                MyRoot.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
            end)
        end
    end

    function Self:Destroy()
        if Self._Connection then
            Self._Connection:Disconnect()
            Self._Connection = nil
        end
    end

    if Options.GodMode then
        Self:SetGodMode(true)
    end

    return Self
end

return Player
