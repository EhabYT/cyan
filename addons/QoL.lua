-- !strict
-- Cyan QoL addon: Teleport panel, Server rejoin, Item ESP, Auto-collect, Anti-void, Infinite-yield-style tools.

local QoL = {}
QoL.__index = QoL

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TweenService: TweenService = game:GetService("TweenService")
local TeleportService: TeleportService = game:GetService("TeleportService")
local VirtualUser: VirtualUser = game:GetService("VirtualUser")

export type QoLOptions = {
    Visible: boolean?,
    Position: UDim2?,
}

local function GetCharacter(Player: Player): Model?
    return Player and Player.Character
end

local function GetRootPart(Character: Model): BasePart?
    return Character
        and (
            Character:FindFirstChild("HumanoidRootPart")
            or Character:FindFirstChild("UpperTorso")
            or Character:FindFirstChild("Torso")
            or Character:FindFirstChild("Head")
        )
end

local function GetCharacterPosition(Character: Model): Vector3?
    local Root = GetRootPart(Character)
    return Root and Root.Position
end

local function GetLocalCharacter(): Model?
    local Player = Players.LocalPlayer
    return Player and Player.Character
end

local function GetLocalRoot(): BasePart?
    return GetRootPart(GetLocalCharacter())
end

function QoL.new(Library: any, Options: QoLOptions?)
    assert(typeof(Library) == "table", "QoL requires a Cyan Library instance")

    local Config: QoLOptions = Options or {}
    local self: any = setmetatable({
        Library = Library,
        Config = Config,
        Options = {
            ItemEsp = false,
            ItemEspColor = Color3.fromRGB(0, 255, 255),
            ItemEspTransparency = 0.3,
            ItemEspRange = 100,
            AutoCollect = false,
            AutoCollectRange = 20,
            AutoCollectWhitelist = {},
            AntiVoidEnabled = false,
            AntiVoidMode = "Teleport",
            AntiVoidY = -50,
            AntiVoidSafePosition = nil,
            InfiniteYield = false,
            AutoClick = false,
            AutoClickInterval = 0.1,
            JumpModifier = false,
            JumpPower = 50,
            WalkSpeedModifier = false,
            WalkSpeed = 16,
        },
        ItemEspHighlights = {},
        AutoCollectConnections = {},
        AntiVoidConnection = nil,
        AutoClickThread = nil,
        Connections = {},
        Destroyed = false,
    }, QoL)

    local function SetupConnections()
        -- Item ESP logic
        local function RefreshItemEsp()
            for _, Highlight in self.ItemEspHighlights do
                if Highlight and Highlight.Parent then
                    Highlight:Destroy()
                end
            end
            self.ItemEspHighlights = {}

            if not self.Options.ItemEsp then
                return
            end

            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            local Origin = Root and Root.Position or Vector3.zero

            for _, Part in workspace:GetDescendants() do
                if
                    Part:IsA("BasePart")
                    and Part.CanCollide == false
                    and not Part:FindFirstAncestorOfClass("Player")
                    and not Part:FindFirstAncestorOfClass("Tool")
                then
                    local IsDroppedItem = Part:IsA("Part") or Part:IsA("MeshPart")
                    if
                        IsDroppedItem
                        and (Part.Position - Origin).Magnitude <= self.Options.ItemEspRange
                    then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Adornee = Part
                        Highlight.FillColor = self.Options.ItemEspColor
                        Highlight.FillTransparency = self.Options.ItemEspTransparency
                        Highlight.OutlineColor = Color3.new(1, 1, 1)
                        Highlight.OutlineTransparency = 0.5
                        Highlight.Parent = Part
                        table.insert(self.ItemEspHighlights, Highlight)
                    end
                end
            end
        end

        local EspConnection = RunService.Heartbeat:Connect(function()
            if self.Options.ItemEsp and not self.Destroyed then
                RefreshItemEsp()
            end
        end)
        table.insert(self.Connections, EspConnection)

        -- Auto-collect logic: walk to collectibles
        local AutoCollectTick = 0
        local ACConnection = RunService.Heartbeat:Connect(function(Delta)
            if not self.Options.AutoCollect or self.Destroyed then
                AutoCollectTick = 0
                return
            end
            AutoCollectTick += Delta
            if AutoCollectTick < 0.5 then
                return
            end
            AutoCollectTick = 0

            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            if not Root then
                return
            end
            local Origin = Root.Position

            for _, Part in workspace:GetDescendants() do
                if not Part:IsA("BasePart") then
                    continue
                end
                if Part:FindFirstAncestorOfClass("Player") then
                    continue
                end
                if Part:FindFirstAncestorOfClass("Tool") then
                    continue
                end
                if
                    Part:FindFirstAncestorOfClass("Model")
                    and Part.Parent:IsA("Model")
                    and Part.Parent:FindFirstChildOfClass("Humanoid")
                then
                    continue
                end
                local TouchInterest = Part:FindFirstChildOfClass("TouchTransmitter")
                if not TouchInterest then
                    continue
                end

                local Dist = (Part.Position - Origin).Magnitude
                if Dist > self.Options.AutoCollectRange then
                    continue
                end

                local BodyPos = Instance.new("BodyPosition")
                BodyPos.MaxForce = Vector3.new(100000, 100000, 100000)
                BodyPos.Position = Part.Position
                BodyPos.P = 3000
                BodyPos.D = 100
                BodyPos.Parent = Root

                local StartPos = Root.Position
                local Target = Part.Position
                local StartTime = tick()

                repeat
                    RunService.Heartbeat:Wait()
                    local Elapsed = tick() - StartTime
                    if Elapsed > 3 then
                        break
                    end
                    local Alpha = math.min(Elapsed / 0.5, 1)
                    BodyPos.Position = StartPos:Lerp(Target, Alpha)
                until (Root.Position - Part.Position).Magnitude < 4
                    or not Part.Parent
                    or not BodyPos.Parent

                BodyPos:Destroy()
                break
            end
        end)
        table.insert(self.Connections, ACConnection)
    end

    local function SetupAntiVoid()
        if self.AntiVoidConnection then
            self.AntiVoidConnection:Disconnect()
            self.AntiVoidConnection = nil
        end

        if not self.Options.AntiVoidEnabled then
            return
        end

        local StartPos = Vector3.zero
        local Character = GetLocalCharacter()
        if Character then
            local Root = GetRootPart(Character)
            if Root then
                StartPos = Root.Position
            end
        end
        self.Options.AntiVoidSafePosition = self.Options.AntiVoidSafePosition or StartPos

        self.AntiVoidConnection = RunService.Heartbeat:Connect(function()
            if self.Destroyed then
                return
            end
            local Character = GetLocalCharacter()
            local Root = Character and GetRootPart(Character)
            if not Root then
                return
            end

            if Root.Position.Y < self.Options.AntiVoidY then
                local SafePos = self.Options.AntiVoidSafePosition
                if self.Options.AntiVoidMode == "Teleport" then
                    Root.CFrame = CFrame.new(SafePos + Vector3.new(0, 3, 0))
                    local Force = Instance.new("BodyVelocity")
                    Force.MaxForce = Vector3.new(0, 1e9, 0)
                    Force.Velocity = Vector3.new(0, 0, 0)
                    Force.Parent = Root
                    game:GetService("Debris"):AddItem(Force, 0.5)
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                elseif self.Options.AntiVoidMode == "Float" then
                    local BodyPos = Root:FindFirstChildOfClass("BodyPosition")
                    if not BodyPos then
                        BodyPos = Instance.new("BodyPosition")
                        BodyPos.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                        BodyPos.P = 5000
                        BodyPos.D = 200
                        BodyPos.Parent = Root
                    end
                    BodyPos.Position = SafePos + Vector3.new(0, 3, 0)
                    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                    if Humanoid then
                        Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                    end
                end
            end
        end)
        table.insert(self.Connections, self.AntiVoidConnection)
    end

    local function SetupAutoClick()
        if self.AutoClickThread then
            coroutine.close(self.AutoClickThread)
            self.AutoClickThread = nil
        end

        if not self.Options.AutoClick then
            return
        end

        self.AutoClickThread = coroutine.create(function()
            while self.Options.AutoClick and not self.Destroyed do
                task.wait(self.Options.AutoClickInterval)
                if not self.Options.AutoClick then
                    break
                end
                local Character = GetLocalCharacter()
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                if Humanoid then
                    local Tool = Character:FindFirstChildOfClass("Tool")
                    if Tool then
                        local ClickFunction = Tool:FindFirstChild("Click")
                        if ClickFunction and ClickFunction:IsA("BindableFunction") then
                            ClickFunction:Invoke()
                        end
                        local Handle = Tool:FindFirstChild("Handle")
                        if Handle then
                            local TouchInterest = Handle:FindFirstChildOfClass("TouchTransmitter")
                            if TouchInterest then
                                firetouchinterest(
                                    Handle,
                                    (
                                        Players.LocalPlayer
                                        and Players.LocalPlayer.Character
                                        and Players.LocalPlayer.Character:FindFirstChild(
                                            "HumanoidRootPart"
                                        )
                                    ) or Handle,
                                    0
                                )
                            end
                        end
                    end
                end
            end
        end)
        table.insert(self.Connections, {
            Connected = true,
            Disconnect = function()
                if self.AutoClickThread then
                    coroutine.close(self.AutoClickThread)
                    self.AutoClickThread = nil
                end
            end,
        })
        coroutine.resume(self.AutoClickThread)
    end

    self._SetupAntiVoid = SetupAntiVoid
    self._SetupAutoClick = SetupAutoClick

    SetupConnections()
    SetupAntiVoid()
    SetupAutoClick()

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

-- Teleport methods
function QoL:TeleportToPlayer(TargetPlayer: Player)
    local TargetChar = TargetPlayer and TargetPlayer.Character
    local TargetRoot = TargetChar and GetRootPart(TargetChar)
    if not TargetRoot then
        return false, "Target has no character"
    end
    local LocalRoot = GetLocalRoot()
    if not LocalRoot then
        return false, "You have no character"
    end
    LocalRoot.CFrame = TargetRoot.CFrame * CFrame.new(0, 3, 3)
    return true
end

function QoL:TeleportToPosition(Position: Vector3)
    local Root = GetLocalRoot()
    if not Root then
        return false
    end
    Root.CFrame = CFrame.new(Position + Vector3.new(0, 3, 0))
    return true
end

function QoL:TeleportToCoordinates(X: number, Y: number, Z: number)
    return self:TeleportToPosition(Vector3.new(X, Y, Z))
end

function QoL:TeleportToWaypoint(Waypoint: CFrame)
    local Root = GetLocalRoot()
    if not Root then
        return false, "You have no character"
    end
    Root.CFrame = Waypoint
    return true
end

-- Server rejoin tools
function QoL:GetServerId(): string
    return game.JobId
end

function QoL:GetPlaceId(): number
    return game.PlaceId
end

function QoL:RejoinServer()
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
end

function QoL:CopyServerLink()
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local Link =
        string.format("https://www.roblox.com/games/%d/Custom?gameInstanceId=%s", PlaceId, JobId)
    setclipboard(Link)
    return Link
end

function QoL:ServerHop()
    local PlaceId = game.PlaceId
    TeleportService:Teleport(PlaceId)
end

-- Item ESP
function QoL:SetItemEsp(Enabled: boolean)
    self.Options.ItemEsp = Enabled
end

function QoL:SetItemEspColor(Color: Color3)
    self.Options.ItemEspColor = Color
end

function QoL:SetItemEspTransparency(Transparency: number)
    self.Options.ItemEspTransparency = math.clamp(Transparency, 0, 1)
end

function QoL:SetItemEspRange(Range: number)
    self.Options.ItemEspRange = math.max(Range, 10)
end

-- Auto-collect
function QoL:SetAutoCollect(Enabled: boolean)
    self.Options.AutoCollect = Enabled
end

function QoL:SetAutoCollectRange(Range: number)
    self.Options.AutoCollectRange = math.clamp(Range, 5, 200)
end

-- Anti-void
function QoL:SetAntiVoid(Enabled: boolean, Mode: string?)
    self.Options.AntiVoidEnabled = Enabled
    if Mode then
        self.Options.AntiVoidMode = Mode
    end
    if Enabled then
        local Root = GetLocalRoot()
        if Root then
            self.Options.AntiVoidSafePosition = Root.Position
        end
    end
    self._SetupAntiVoid()
end

function QoL:SetAntiVoidY(Y: number)
    self.Options.AntiVoidY = Y
end

function QoL:SetAntiVoidMode(Mode: string)
    self.Options.AntiVoidMode = Mode
end

-- Infinite-yield-style tools
function QoL:SetInfiniteYield(Enabled: boolean)
    self.Options.InfiniteYield = Enabled
end

-- Auto-click
function QoL:SetAutoClick(Enabled: boolean)
    self.Options.AutoClick = Enabled
    self._SetupAutoClick()
end

function QoL:SetAutoClickInterval(Interval: number)
    self.Options.AutoClickInterval = math.max(Interval, 0.02)
    if self.Options.AutoClick then
        self._SetupAutoClick()
    end
end

-- Character modifiers
function QoL:SetCharacterWalkSpeed(Speed: number)
    self.Options.WalkSpeedModifier = true
    self.Options.WalkSpeed = Speed
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = Speed
    end
end

function QoL:SetCharacterJumpPower(Power: number)
    self.Options.JumpModifier = true
    self.Options.JumpPower = Power
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.JumpPower = Power
    end
end

function QoL:ResetCharacterModifiers()
    self.Options.WalkSpeedModifier = false
    self.Options.JumpModifier = false
    local Character = GetLocalCharacter()
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    if Humanoid then
        Humanoid.WalkSpeed = 16
        Humanoid.JumpPower = 50
    end
end

function QoL:GetPlayerList(): { Player }
    return Players:GetPlayers()
end

function QoL:GetPlayerByName(Name: string): Player?
    Name = Name:lower()
    for _, Player in Players:GetPlayers() do
        if Player.Name:lower():find(Name) or Player.DisplayName:lower():find(Name) then
            return Player
        end
    end
    return nil
end

function QoL:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, Highlight in self.ItemEspHighlights do
        if Highlight and Highlight.Parent then
            Highlight:Destroy()
        end
    end
    self.ItemEspHighlights = {}

    if self.AutoClickThread then
        coroutine.close(self.AutoClickThread)
        self.AutoClickThread = nil
    end

    for i = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, i)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    self._SetupAntiVoid = nil
    self._SetupAutoClick = nil
end

return QoL
