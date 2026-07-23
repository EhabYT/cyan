--!strict
-- Cyan Movement addon: WalkSpeed, JumpPower, Gravity, Fly, Noclip, and Anti-tool protection.

local Movement = {}
Movement.__index = Movement

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type FlyControl = "Classic" | "Directional"
export type AntiVoidAction = "Teleport" | "Float"

export type MovementOptions = {
    WalkSpeed: number?,
    JumpPower: number?,
    JumpHeight: number?,
    Gravity: number?,
    FlySpeed: number?,
    FlyControl: FlyControl?,
    AutoNoclipWhenFlying: boolean?,
    AntiVoid: boolean?,
    AntiVoidAction: AntiVoidAction?,
    VoidThreshold: number?,
    AntiKick: boolean?,
    AntiTeleport: boolean?,
    AutoUpdateSpeed: boolean?,
}

local function GetHumanoid(Player: Player): Humanoid?
    local Character = Player and Player.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChildOfClass("Humanoid")
end

local function GetRootPart(Player: Player): BasePart?
    local Character = Player and Player.Character
    if not Character then
        return nil
    end
    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
end

function Movement.new(Library: any, Options: MovementOptions?)
    assert(typeof(Library) == "table", "Movement requires a Cyan Library instance")

    local Config: MovementOptions = Options or {}
    local LocalPlayer = Players.LocalPlayer

    local self: any = setmetatable({
        Library = Library,
        WalkSpeed = Config.WalkSpeed or 16,
        JumpPower = Config.JumpPower or 50,
        JumpHeight = Config.JumpHeight,
        FlySpeed = Config.FlySpeed or 50,
        FlyControl = Config.FlyControl or "Directional",
        Gravity = Config.Gravity,
        AutoNoclipWhenFlying = Config.AutoNoclipWhenFlying or true,
        WalkSpeedEnabled = false,
        JumpPowerEnabled = false,
        GravityEnabled = false,
        Flying = false,
        Noclipping = false,
        AntiVoid = Config.AntiVoid or false,
        AntiVoidAction = Config.AntiVoidAction or "Float",
        VoidThreshold = Config.VoidThreshold or -50,
        AntiKick = Config.AntiKick or false,
        AntiTeleport = Config.AntiTeleport or false,
        AutoUpdateSpeed = Config.AutoUpdateSpeed or true,
        Connections = {},
        FlyBodyVelocity = nil,
        FlyBodyGyro = nil,
        OnGroundLast = false,
        LastPosition = nil,
        Destroyed = false,
    }, Movement)

    if self.Gravity ~= nil then
        self.GravityEnabled = true
        workspace.Gravity = self.Gravity
    end

    self:_StartLoop()
    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function Movement:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function Movement:_StartLoop()
    if self._UpdateConnection then
        return
    end

    self._UpdateConnection = self:_GiveConnection(RunService.Heartbeat:Connect(function(DeltaTime)
        if self.Destroyed then
            return
        end

        local Player = Players.LocalPlayer
        if not Player then
            return
        end

        local Humanoid = GetHumanoid(Player)
        local RootPart = GetRootPart(Player)

        if self.WalkSpeedEnabled and Humanoid and Humanoid.Parent then
            Humanoid.WalkSpeed = self.WalkSpeed
        end

        if self.JumpPowerEnabled and Humanoid and Humanoid.Parent then
            if self.JumpHeight then
                Humanoid.JumpHeight = self.JumpHeight
            else
                Humanoid.JumpPower = self.JumpPower
            end
        end

        if self.Noclipping and RootPart and RootPart.Parent then
            RootPart.CanCollide = false
        end

        if self.Flying and RootPart and RootPart.Parent then
            self:_UpdateFly(RootPart, Humanoid, DeltaTime)
        end

        if self.AntiVoid and RootPart and RootPart.Parent then
            self:_CheckVoid(RootPart)
        end

        if self.AntiTeleport and RootPart and RootPart.Parent then
            self:_CheckTeleport(RootPart)
        end
    end))
end

function Movement:SetWalkSpeed(Speed: number, Enable: boolean?)
    self.WalkSpeed = math.clamp(Speed, 0, 500)
    if Enable ~= nil then
        self.WalkSpeedEnabled = Enable
    else
        self.WalkSpeedEnabled = Speed ~= 16
    end

    local Humanoid = GetHumanoid(Players.LocalPlayer)
    if self.WalkSpeedEnabled and Humanoid then
        Humanoid.WalkSpeed = self.WalkSpeed
    end
end

function Movement:SetJumpPower(Power: number, Enable: boolean?)
    self.JumpPower = math.clamp(Power, 0, 500)
    if Enable ~= nil then
        self.JumpPowerEnabled = Enable
    else
        self.JumpPowerEnabled = Power ~= 50
    end

    local Humanoid = GetHumanoid(Players.LocalPlayer)
    if self.JumpPowerEnabled and Humanoid then
        Humanoid.JumpPower = self.JumpPower
    end
end

function Movement:SetJumpHeight(Height: number, Enable: boolean?)
    self.JumpHeight = math.clamp(Height, 0, 100)
    if Enable ~= nil then
        self.JumpPowerEnabled = Enable
    else
        self.JumpPowerEnabled = Height ~= 0
    end
end

function Movement:SetGravity(G: number)
    workspace.Gravity = G
    self.GravityEnabled = true
    self.Gravity = G
end

function Movement:ResetGravity()
    workspace.Gravity = 196.2
    self.GravityEnabled = false
    self.Gravity = nil
end

function Movement:ToggleFly()
    self:SetFlying(not self.Flying)
end

function Movement:SetFlying(Fly: boolean)
    if Fly == self.Flying then
        return
    end

    self.Flying = Fly
    local Player = Players.LocalPlayer

    if Fly then
        self:_SetupFly()
        Player.CharacterAdded:Connect(function(Character)
            if self.Flying then
                task.wait(0.5)
                self:_SetupFly()
            end
        end)
        if self.AutoNoclipWhenFlying then
            self:SetNoclipping(true)
        end
    else
        self:_CleanupFly()
        if self.AutoNoclipWhenFlying and not self.Noclipping then
            self:SetNoclipping(false)
        end
    end
end

function Movement:_SetupFly()
    local Player = Players.LocalPlayer
    if not Player then
        return
    end

    local Character = Player.Character
    local Humanoid = GetHumanoid(Player)
    local RootPart = GetRootPart(Player)
    if not RootPart or not Humanoid then
        return
    end

    Humanoid.PlatformStand = true

    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.Name = "CyanFlyVelocity"
    BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
    BodyVelocity.Velocity = Vector3.zero
    BodyVelocity.Parent = RootPart

    local BodyGyro = Instance.new("BodyGyro")
    BodyGyro.Name = "CyanFlyGyro"
    BodyGyro.MaxTorque = Vector3.new(0, 0, 0)
    BodyGyro.Parent = RootPart

    self.FlyBodyVelocity = BodyVelocity
    self.FlyBodyGyro = BodyGyro
end

function Movement:_CleanupFly()
    local Player = Players.LocalPlayer
    if not Player then
        return
    end

    local Humanoid = GetHumanoid(Player)
    if Humanoid then
        Humanoid.PlatformStand = false
    end

    task.delay(0.1, function()
        if self.FlyBodyVelocity then
            self.FlyBodyVelocity:Destroy()
            self.FlyBodyVelocity = nil
        end
        if self.FlyBodyGyro then
            self.FlyBodyGyro:Destroy()
            self.FlyBodyGyro = nil
        end
    end)
end

function Movement:_UpdateFly(RootPart: BasePart, Humanoid: Humanoid?, DeltaTime: number)
    if not self.FlyBodyVelocity then
        return
    end

    local Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    local Forward = Camera.CFrame.LookVector
    local Right = Camera.CFrame.RightVector
    local Up = Vector3.new(0, 1, 0)
    local InputDirection = Vector3.zero

    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        InputDirection += Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        InputDirection -= Forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        InputDirection -= Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        InputDirection += Right
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        InputDirection += Up
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        InputDirection -= Up
    end

    if InputDirection.Magnitude > 0 then
        InputDirection = InputDirection.Unit
        local Speed = self.FlySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            Speed = Speed * 2.5
        end
        self.FlyBodyVelocity.Velocity = InputDirection * Speed
    elseif self.AutoUpdateSpeed and Humanoid then
        local MoveDir = Humanoid.MoveDirection
        if MoveDir.Magnitude > 0 then
            self.FlyBodyVelocity.Velocity = MoveDir * self.WalkSpeed * 2
            return
        end
        self.FlyBodyVelocity.Velocity = Vector3.zero
    else
        self.FlyBodyVelocity.Velocity = Vector3.zero
    end
end

function Movement:ToggleNoclip()
    self:SetNoclipping(not self.Noclipping)
end

function Movement:SetNoclipping(Noclip: boolean)
    self.Noclipping = Noclip

    local RootPart = GetRootPart(Players.LocalPlayer)
    if RootPart and Noclip then
        RootPart.CanCollide = false
    end
end

function Movement:SetFlySpeed(Speed: number)
    self.FlySpeed = math.max(1, Speed)
end

function Movement:SetFlyControl(Control: FlyControl)
    self.FlyControl = Control
end

function Movement:_CheckVoid(RootPart: BasePart)
    if RootPart.Position.Y < self.VoidThreshold then
        if self.AntiVoidAction == "Teleport" then
            local Spawns = workspace:FindFirstChild("SpawnLocation")
            if Spawns then
                RootPart.CFrame = CFrame.new(Spawns.Position + Vector3.new(0, 5, 0))
            else
                local Camera = workspace.CurrentCamera
                if Camera then
                    RootPart.CFrame = CFrame.new(Camera.CFrame.Position + Vector3.new(0, 5, 0))
                end
            end
        elseif self.AntiVoidAction == "Float" then
            RootPart.Velocity = Vector3.zero
            RootPart.CFrame += Vector3.new(0, 3, 0)
        end
    end
end

function Movement:_CheckTeleport(RootPart: BasePart)
    local CurrentPos = RootPart.Position
    if self.LastPosition then
        local Distance = (CurrentPos - self.LastPosition).Magnitude
        local Character = RootPart.Parent
        local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
        if Distance > 500 and Humanoid and Humanoid.Health > 0 then
            RootPart.CFrame = CFrame.new(self.LastPosition)
            return
        end
    end
    self.LastPosition = CurrentPos
end

function Movement:SetAntiVoid(Enabled: boolean, Action: AntiVoidAction?)
    self.AntiVoid = Enabled
    if Action then
        self.AntiVoidAction = Action
    end
end

function Movement:SetAntiKick(Enabled: boolean)
    self.AntiKick = Enabled
end

function Movement:SetAntiTeleport(Enabled: boolean)
    self.AntiTeleport = Enabled
    self.LastPosition = nil

    local RootPart = GetRootPart(Players.LocalPlayer)
    if RootPart then
        self.LastPosition = RootPart.Position
    end
end

function Movement:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    if self._UpdateConnection then
        self._UpdateConnection:Disconnect()
        self._UpdateConnection = nil
    end

    self:SetFlying(false)
    self:SetNoclipping(false)

    if self.GravityEnabled then
        workspace.Gravity = 196.2
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
end

return Movement
