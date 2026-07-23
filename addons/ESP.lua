--!strict
-- Cyan ESP + Aimbot addon: player/object ESP boxes, health bars, names, tracers, chams,
-- FOV circle, and target-selection utilities for aim assistance.

local ESP = {}
ESP.__index = ESP

local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Players: Players = game:GetService("Players")
local TweenService: TweenService = game:GetService("TweenService")
local CoreGui: CoreGui = game:GetService("CoreGui")

local Vector3World = Vector3
local CFrameWorld = CFrame

export type BoxStyle = "Corner" | "Standard" | "Outline"
export type TracerOrigin = "Bottom" | "Middle" | "Mouse"

export type PlayerESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxStyle: BoxStyle?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    BoxThickness: number?,
    HealthBar: boolean?,
    HealthBarColor: boolean?,
    HealthBarTransparency: number?,
    Name: boolean?,
    NameSize: number?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerOrigin: TracerOrigin?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Chams: boolean?,
    ChamsColor: Color3?,
    ChamsTransparency: number?,
    TeamCheck: boolean?,
    MaxDistance: number?,
    VisibleCheck: boolean?,
    CustomFilter: ((Player) -> boolean)?,
}

export type ObjectESPOptions = {
    Enabled: boolean?,
    Box: boolean?,
    BoxColor: Color3?,
    BoxTransparency: number?,
    Name: boolean?,
    NameColor: Color3?,
    Distance: boolean?,
    DistanceColor: Color3?,
    Tracer: boolean?,
    TracerColor: Color3?,
    TracerTransparency: number?,
    Highlight: boolean?,
    HighlightColor: Color3?,
    HighlightTransparency: number?,
    MaxDistance: number?,
    CustomName: string?,
}

export type FOVCircleOptions = {
    Enabled: boolean?,
    Radius: number?,
    Color: Color3?,
    Transparency: number?,
    Thickness: number?,
    Filled: boolean?,
    Visible: boolean?,
}

export type ESPOptions = {
    UpdateInterval: number?,
    TeamColor: Color3?,
    EnemyColor: Color3?,
    DefaultBoxColor: Color3?,
}

local function IsPlayerVisible(Target: Model): boolean
    local Camera = workspace.CurrentCamera
    if not Camera then
        return true
    end

    local Character = Target
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
    if not RootPart then
        return true
    end

    local Origin = Camera.CFrame.Position
    local Direction = (RootPart.Position - Origin).Unit
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    RaycastParams.FilterDescendantsInstances = { Camera, Character, Players.LocalPlayer.Character }

    local Result =
        workspace:Raycast(Origin, Direction * (RootPart.Position - Origin).Magnitude, RaycastParams)
    return Result == nil
end

local function GetPlayerColor(Target: Player): Color3?
    local Team = Target.Team
    if Team then
        return Team.TeamColor.Color
    end

    return nil
end

local function IsOnSameTeam(Target: Player): boolean
    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer then
        return false
    end

    local MyTeam = LocalPlayer.Team
    local TargetTeam = Target.Team
    if MyTeam and TargetTeam then
        return MyTeam == TargetTeam
    end

    return false
end

local function GetCharacterPosition(Character: Model): Vector3?
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")

    if RootPart then
        return RootPart.Position
    end

    return Character:GetPivot().Position
end

local function GetCharacterBoundingBox(Character: Model, IgnoreHead: boolean?): (Vector3, Vector3)
    local RootPart = Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("LowerTorso")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("Head")

    if not RootPart then
        return nil
    end

    local Size = RootPart.Size
    local Position = RootPart.Position
    local Head = Character:FindFirstChild("Head")
    local HeadOffset = 0

    if Head and not IgnoreHead then
        HeadOffset = (Head.Position.Y - Position.Y) + Head.Size.Y / 2
    end

    local Bottom =
        RootPart.CFrame:PointToWorldSpace(Vector3.new(-Size.X / 2, -Size.Y / 2, -Size.Z / 2))
    local Top = RootPart.CFrame:PointToWorldSpace(
        Vector3.new(Size.X / 2, Size.Y / 2 + HeadOffset, Size.Z / 2)
    )

    return Bottom, Top
end

local function WorldToScreen(WorldPoint: Vector3): Vector2?
    local Camera = workspace.CurrentCamera
    if not Camera then
        return nil
    end

    local Point, OnScreen = Camera:WorldToViewportPoint(WorldPoint)
    if not OnScreen or Point.Z < 0 then
        return nil
    end

    return Vector2.new(Point.X, Point.Y)
end

local function IsOnScreen(Position: Vector3): boolean
    local Camera = workspace.CurrentCamera
    if not Camera then
        return false
    end

    local Point, OnScreen = Camera:WorldToViewportPoint(Position)
    return OnScreen and Point.Z > 0
end

function ESP.new(Library: any, Options: ESPOptions?)
    assert(typeof(Library) == "table", "ESP requires a Cyan Library instance")
    assert(typeof(Library.ScreenGui) == "Instance", "ESP requires Library.ScreenGui")

    local Config: ESPOptions = Options or {}
    local Self: any = setmetatable({
        Library = Library,
        Players = {},
        Objects = {},
        FOVCircle = nil,
        FOVCircleVisible = false,
        Enabled = true,
        TracersVisible = true,
        BoxesVisible = true,
        NamesVisible = true,
        HealthBarsVisible = true,
        ChamsVisible = true,
        TeamCheck = false,
        TeamColor = Config.TeamColor or Color3.fromRGB(0, 255, 0),
        EnemyColor = Config.EnemyColor or Color3.fromRGB(255, 50, 50),
        DefaultBoxColor = Config.DefaultBoxColor or Color3.fromRGB(255, 255, 255),
        UpdateInterval = math.clamp(Config.UpdateInterval or 0.1, 0.03, 1),
        DisplayElapsed = 0,
        UpdateConnection = nil,
        ItemConnections = {},
        Connections = {},
        ChamsHighlights = {},
        FOVDrawing = nil,
        TargetLock = nil,
        _AimbotOptions = {
            Enabled = false,
            SilentAim = false,
            Prediction = true,
            PredictionAmount = 0.5,
            Smoothness = 0.8,
            Hitbox = "Torso",
            AutoFire = false,
            AutoFireDelay = 0.15,
            FOV = 60,
            MaxDistance = 1000,
            TeamCheck = true,
            VisibleCheck = false,
            MagicBullet = false,
            MagicBulletChance = 100,
        },
        Destroyed = false,
    }, ESP)

    Self:_InitFOVCircle()
    Self:_StartUpdateLoop()
    SetupSilentAim(Self)
    SetupMagicBullet(Self)
    SetupAutoFire(Self)

    Library:OnUnload(function()
        Self:Destroy()
    end)

    return Self
end

function ESP:_EnsureLibrary()
    assert(not self.Destroyed, "ESP has been destroyed")
end

function ESP:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function ESP:_StartUpdateLoop()
    if self.UpdateConnection then
        return
    end

    self.UpdateConnection =
        self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
            if self.Destroyed then
                return
            end

            self.DisplayElapsed += DeltaTime
            if self.DisplayElapsed < self.UpdateInterval then
                return
            end
            self.DisplayElapsed = 0

            if not self.Enabled then
                return
            end

            for _, Handler in self.Players do
                if not Handler.Destroyed then
                    Handler:Update()
                end
            end

            for _, Handler in self.Objects do
                if not Handler.Destroyed then
                    Handler:Update()
                end
            end
        end))
end

function ESP:_InitFOVCircle()
    local FOVFrame = Instance.new("ImageLabel")
    FOVFrame.Name = "CyanFOVCircle"
    FOVFrame.BackgroundTransparency = 1
    FOVFrame.BorderSizePixel = 0
    FOVFrame.Image = "rbxasset://textures/ui/WhiteCircle.png"
    FOVFrame.ImageColor3 = Color3.fromRGB(255, 255, 255)
    FOVFrame.ImageTransparency = 0.85
    FOVFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    FOVFrame.Size = UDim2.fromOffset(0, 0)
    FOVFrame.Visible = false
    FOVFrame.ZIndex = 10000
    FOVFrame.Parent = self.Library.ScreenGui

    self.FOVDrawing = FOVFrame
end

function ESP:SetFOVCircle(Options: FOVCircleOptions)
    self:_EnsureLibrary()

    local FOV = self.FOVDrawing
    if not FOV then
        return
    end

    local Radius = Options.Radius or 60
    local Color = Options.Color or Color3.fromRGB(255, 255, 255)
    local Transparency = Options.Transparency or 0.85
    local Thickness = Options.Thickness or 1

    FOV.Size = UDim2.fromOffset(Radius * 2, Radius * 2)
    FOV.ImageColor3 = Color
    FOV.ImageTransparency = Transparency

    local Visible = Options.Enabled ~= false and Options.Visible ~= false
    FOV.Visible = Visible
    self.FOVCircleVisible = Visible

    if Options.Filled then
        FOV.BackgroundColor3 = Color
        FOV.BackgroundTransparency = math.min(1, Transparency + 0.3)
    else
        FOV.BackgroundTransparency = 1
    end
end

function ESP:ShowFOVCircle(Visible: boolean)
    self:_EnsureLibrary()
    if self.FOVDrawing then
        self.FOVDrawing.Visible = Visible and self.FOVCircleVisible
    end
end

function ESP:AddPlayerESP(Options: PlayerESPOptions)
    self:_EnsureLibrary()
    assert(typeof(Options) == "table", "PlayerESP options must be a table")

    local ESPRoot = self
    local Opts: PlayerESPOptions = Options
    local Handler = {
        Options = Opts,
        Connections = {},
        BoxLines = {},
        HealthBarFrame = nil,
        HealthBarFill = nil,
        NameLabel = nil,
        DistanceLabel = nil,
        TracerLine = nil,
        TargetPlayer = nil,
        Destroyed = false,
    }

    local function CreateESPInstance(ClassName: string, Properties: { [string]: any }): Instance
        local Inst = Instance.new(ClassName)
        for Key, Value in Properties do
            Inst[Key] = Value
        end
        return Inst
    end

    local function UpdateESPForPlayer(Player: Player)
        if Handler.Destroyed then
            return
        end

        if not Player or not Player.Parent then
            Handler:ClearESP()
            return
        end

        local Character = Player.Character
        if not Character or not Character.Parent then
            Handler:ClearESP()
            return
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            Handler:ClearESP()
            return
        end

        if Opts.TeamCheck and IsOnSameTeam(Player) then
            Handler:ClearESP()
            return
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            Handler:ClearESP()
            return
        end

        if Opts.MaxDistance then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            if MyPos and (Position3D - MyPos).Magnitude > Opts.MaxDistance then
                Handler:ClearESP()
                return
            end
        end

        if Opts.VisibleCheck and not IsPlayerVisible(Character) then
            if Opts.Chams then
                Handler:UpdateChams(Player, false)
            end
            if not Handler.BoxLines[1] then
                return
            end
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            Handler:ClearESP()
            return
        end

        Handler.TargetPlayer = Player

        local BoxColor = Opts.BoxColor
        if not BoxColor then
            if Opts.TeamCheck then
                BoxColor = IsOnSameTeam(Player) and self.TeamColor or self.EnemyColor
            else
                BoxColor = self.DefaultBoxColor
            end
        end

        local Bottom, Top = GetCharacterBoundingBox(Character)
        if Bottom and Top then
            local BottomScreen = WorldToScreen(Bottom)
            local TopScreen = WorldToScreen(Top)

            if BottomScreen and TopScreen then
                local Height = math.abs(BottomScreen.Y - TopScreen.Y)
                local Width = Height * 0.55

                if Width < 4 or Height < 8 then
                    Handler:ClearESP()
                    return
                end

                local CenterX = (TopScreen.X + BottomScreen.X) / 2
                local TopY = TopScreen.Y
                local LeftX = CenterX - Width / 2

                if Opts.Box ~= false then
                    Handler:DrawBox(
                        LeftX,
                        TopY,
                        Width,
                        Height,
                        BoxColor,
                        Opts.BoxStyle or "Corner",
                        Opts.BoxTransparency or 0,
                        Opts.BoxThickness or 1
                    )
                end

                if Opts.HealthBar ~= false then
                    local HealthPercent = math.clamp(Humanoid.Health / Humanoid.MaxHealth, 0, 1)
                    local HealthColor = Color3.fromRGB(
                        math.floor(255 * (1 - HealthPercent)),
                        math.floor(255 * HealthPercent),
                        0
                    )
                    Handler:DrawHealthBar(
                        LeftX - 6,
                        TopY,
                        4,
                        Height,
                        HealthPercent,
                        HealthColor,
                        Opts.HealthBarTransparency or 0
                    )
                end

                if Opts.Name ~= false then
                    Handler:DrawName(
                        Player.Name,
                        CenterX,
                        TopY - 14,
                        Opts.NameSize or 13,
                        Opts.NameColor or Color3.fromRGB(255, 255, 255)
                    )
                end

                if Opts.Distance ~= false then
                    local LocalPlayer = Players.LocalPlayer
                    local MyChar = LocalPlayer and LocalPlayer.Character
                    local MyPos = MyChar and GetCharacterPosition(MyChar)
                    local DistanceText = ""
                    if MyPos then
                        local Dist = math.floor((Position3D - MyPos).Magnitude + 0.5)
                        DistanceText = tostring(Dist) .. " studs"
                    end
                    Handler:DrawDistance(
                        DistanceText,
                        CenterX,
                        BottomScreen.Y + 4,
                        Opts.DistanceColor or Color3.fromRGB(200, 200, 200)
                    )
                end

                if Opts.Tracer then
                    local Origin = Opts.TracerOrigin or "Bottom"
                    local StartX, StartY

                    if Origin == "Mouse" then
                        local MousePos = UserInputService:GetMouseLocation()
                        StartX = MousePos.X
                        StartY = MousePos.Y
                    elseif Origin == "Middle" then
                        local Viewport = workspace.CurrentCamera
                                and workspace.CurrentCamera.ViewportSize
                            or Vector2.new(1920, 1080)
                        StartX = Viewport.X / 2
                        StartY = Viewport.Y
                    else
                        local Viewport = workspace.CurrentCamera
                                and workspace.CurrentCamera.ViewportSize
                            or Vector2.new(1920, 1080)
                        StartX = Viewport.X / 2
                        StartY = Viewport.Y
                    end

                    Handler:DrawTracer(
                        StartX,
                        StartY,
                        CenterX,
                        BottomScreen.Y,
                        Opts.TracerColor or BoxColor,
                        Opts.TracerTransparency or 0
                    )
                end
            end
        end

        if Opts.Chams then
            Handler:UpdateChams(Player, true, Opts.ChamsColor, Opts.ChamsTransparency or 0.5)
        end
    end

    function Handler:DrawBox(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Color: Color3,
        Style: BoxStyle,
        Transparency: number,
        Thickness: number
    )
        local ScreenGui = self.Library.ScreenGui
        local StyleStr = Style or "Corner"

        local function MakeLine(Index: number, Props: { [string]: any })
            if self.BoxLines[Index] and self.BoxLines[Index].Parent then
                for K, V in Props do
                    self.BoxLines[Index][K] = V
                end
                return
            end

            local Line = Instance.new("Frame")
            Line.BorderSizePixel = 0
            Line.BackgroundColor3 = Color
            Line.BackgroundTransparency = Transparency
            Line.ZIndex = 9999
            Line.Parent = ScreenGui

            for K, V in Props do
                Line[K] = V
            end

            if self.BoxLines[Index] then
                self.BoxLines[Index]:Destroy()
            end
            self.BoxLines[Index] = Line
        end

        if StyleStr == "Standard" then
            MakeLine(1, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Width, Thickness),
            })
            MakeLine(2, {
                Position = UDim2.fromOffset(Left, Top + Height),
                Size = UDim2.fromOffset(Width, Thickness),
            })
            MakeLine(3, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Thickness, Height),
            })
            MakeLine(4, {
                Position = UDim2.fromOffset(Left + Width, Top),
                Size = UDim2.fromOffset(Thickness, Height),
            })
        elseif StyleStr == "Outline" then
            local OutlineFrame = self.BoxLines[1]
            if not OutlineFrame or not OutlineFrame.Parent then
                if OutlineFrame then
                    OutlineFrame:Destroy()
                end
                OutlineFrame = Instance.new("Frame")
                OutlineFrame.BorderSizePixel = 0
                OutlineFrame.BackgroundTransparency = 1
                OutlineFrame.ZIndex = 9998
                OutlineFrame.Parent = ScreenGui
                self.BoxLines[1] = OutlineFrame
            end

            OutlineFrame.Position = UDim2.fromOffset(Left - 1, Top - 1)
            OutlineFrame.Size = UDim2.fromOffset(Width + 2, Height + 2)

            local Inner = self.BoxLines[2]
            if not Inner or not Inner.Parent then
                if Inner then
                    Inner:Destroy()
                end
                Inner = Instance.new("Frame")
                Inner.BorderSizePixel = 0
                Inner.BackgroundColor3 = Color
                Inner.BackgroundTransparency = Transparency
                Inner.ZIndex = 9999
                Inner.Parent = OutlineFrame
                self.BoxLines[2] = Inner
            end

            Inner.Position = UDim2.fromOffset(1, 1)
            Inner.Size = UDim2.fromOffset(Width, Height)
            Inner.BackgroundColor3 = Color

            for i = 3, #self.BoxLines do
                if self.BoxLines[i] then
                    self.BoxLines[i]:Destroy()
                    self.BoxLines[i] = nil
                end
            end
        else
            local CornerLength = math.min(Width * 0.2, Height * 0.2, 16)

            MakeLine(1, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(2, {
                Position = UDim2.fromOffset(Left + Width - CornerLength, Top),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(3, {
                Position = UDim2.fromOffset(Left, Top + Height),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(4, {
                Position = UDim2.fromOffset(Left + Width - CornerLength, Top + Height),
                Size = UDim2.fromOffset(CornerLength, Thickness),
            })
            MakeLine(5, {
                Position = UDim2.fromOffset(Left, Top),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(6, {
                Position = UDim2.fromOffset(Left + Width, Top),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(7, {
                Position = UDim2.fromOffset(Left, Top + Height - CornerLength),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
            MakeLine(8, {
                Position = UDim2.fromOffset(Left + Width, Top + Height - CornerLength),
                Size = UDim2.fromOffset(Thickness, CornerLength),
            })
        end
    end

    function Handler:DrawHealthBar(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Percent: number,
        Color: Color3,
        Transparency: number
    )
        local ScreenGui = self.Library.ScreenGui

        if not self.HealthBarFrame or not self.HealthBarFrame.Parent then
            if self.HealthBarFrame then
                self.HealthBarFrame:Destroy()
            end
            self.HealthBarFrame = Instance.new("Frame")
            self.HealthBarFrame.BorderSizePixel = 0
            self.HealthBarFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            self.HealthBarFrame.BackgroundTransparency = Transparency
            self.HealthBarFrame.ZIndex = 9999
            self.HealthBarFrame.Parent = ScreenGui

            self.HealthBarFill = Instance.new("Frame")
            self.HealthBarFill.BorderSizePixel = 0
            self.HealthBarFill.ZIndex = 10000
            self.HealthBarFill.Parent = self.HealthBarFrame
        end

        self.HealthBarFrame.Position = UDim2.fromOffset(Left, Top)
        self.HealthBarFrame.Size = UDim2.fromOffset(Width, Height)

        self.HealthBarFill.BackgroundColor3 = Color
        self.HealthBarFill.BackgroundTransparency = Transparency
        self.HealthBarFill.Size = UDim2.fromScale(1, Percent)
        self.HealthBarFill.Position = UDim2.fromScale(0, 1 - Percent)
    end

    function Handler:DrawName(
        Text: string,
        CenterX: number,
        TopY: number,
        Size: number,
        Color: Color3
    )
        if not self.NameLabel or not self.NameLabel.Parent then
            if self.NameLabel then
                self.NameLabel:Destroy()
            end
            self.NameLabel = Instance.new("TextLabel")
            self.NameLabel.BackgroundTransparency = 1
            self.NameLabel.BorderSizePixel = 0
            self.NameLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.NameLabel.RichText = true
            self.NameLabel.TextStrokeTransparency = 0.5
            self.NameLabel.ZIndex = 9999
            self.NameLabel.Parent = self.Library.ScreenGui
        end

        self.NameLabel.Text = Text
        self.NameLabel.TextColor3 = Color
        self.NameLabel.TextSize = Size
        self.NameLabel.Size = UDim2.fromOffset(200, Size + 4)
        self.NameLabel.Position = UDim2.fromOffset(CenterX - 100, TopY)
        self.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function Handler:DrawDistance(Text: string, CenterX: number, BottomY: number, Color: Color3)
        if not self.DistanceLabel or not self.DistanceLabel.Parent then
            if self.DistanceLabel then
                self.DistanceLabel:Destroy()
            end
            self.DistanceLabel = Instance.new("TextLabel")
            self.DistanceLabel.BackgroundTransparency = 1
            self.DistanceLabel.BorderSizePixel = 0
            self.DistanceLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.DistanceLabel.RichText = true
            self.DistanceLabel.TextStrokeTransparency = 0.5
            self.DistanceLabel.TextSize = 11
            self.DistanceLabel.ZIndex = 9999
            self.DistanceLabel.Parent = self.Library.ScreenGui
        end

        self.DistanceLabel.Text = Text
        self.DistanceLabel.TextColor3 = Color
        self.DistanceLabel.Size = UDim2.fromOffset(200, 16)
        self.DistanceLabel.Position = UDim2.fromOffset(CenterX - 100, BottomY)
        self.DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function Handler:DrawTracer(
        StartX: number,
        StartY: number,
        EndX: number,
        EndY: number,
        Color: Color3,
        Transparency: number
    )
        local ScreenGui = self.Library.ScreenGui

        if not self.TracerLine or not self.TracerLine.Parent then
            if self.TracerLine then
                self.TracerLine:Destroy()
            end
            self.TracerLine = Instance.new("Frame")
            self.TracerLine.BorderSizePixel = 0
            self.TracerLine.ZIndex = 9998
            self.TracerLine.Parent = ScreenGui
        end

        local DX = EndX - StartX
        local DY = EndY - StartY
        local Length = math.sqrt(DX * DX + DY * DY)
        local Angle = math.atan2(DY, DX)

        self.TracerLine.BackgroundColor3 = Color
        self.TracerLine.BackgroundTransparency = Transparency
        self.TracerLine.Size = UDim2.fromOffset(Length, 1)
        self.TracerLine.Position = UDim2.fromOffset(StartX, StartY)
        self.TracerLine.Rotation = math.deg(Angle)
    end

    function Handler:UpdateChams(
        Player: Player,
        Enabled: boolean,
        Color: Color3?,
        Transparency: number?
    )
        if not Enabled then
            if self.ChamsHighlight and self.ChamsHighlight.Parent then
                self.ChamsHighlight:Destroy()
            end
            self.ChamsHighlight = nil
            return
        end

        local Character = Player.Character
        if not Character then
            return
        end

        local Highlight = self.ChamsHighlight
        if not Highlight or not Highlight.Parent then
            if Highlight then
                Highlight:Destroy()
            end
            Highlight = Instance.new("Highlight")
            Highlight.FillTransparency = Transparency or 0.5
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.Parent = Character
            self.ChamsHighlight = Highlight
        end

        Highlight.FillColor = Color or Color3.fromRGB(255, 255, 255)
        Highlight.Adornee = Character
    end

    function Handler:ClearESP()
        for i = 1, #self.BoxLines do
            if self.BoxLines[i] then
                self.BoxLines[i]:Destroy()
                self.BoxLines[i] = nil
            end
        end

        if self.HealthBarFrame then
            self.HealthBarFrame:Destroy()
            self.HealthBarFrame = nil
        end
        if self.HealthBarFill then
            self.HealthBarFill = nil
        end
        if self.NameLabel then
            self.NameLabel:Destroy()
            self.NameLabel = nil
        end
        if self.DistanceLabel then
            self.DistanceLabel:Destroy()
            self.DistanceLabel = nil
        end
        if self.TracerLine then
            self.TracerLine:Destroy()
            self.TracerLine = nil
        end
        if self.ChamsHighlight then
            self.ChamsHighlight:Destroy()
            self.ChamsHighlight = nil
        end

        self.TargetPlayer = nil
    end

    function Handler:Destroy()
        if self.Destroyed then
            return
        end
        self.Destroyed = true

        if self.Connections then
            for _, Connection in self.Connections do
                if Connection and Connection.Connected then
                    Connection:Disconnect()
                end
            end
        end

        self:ClearESP()
        ESPRoot.Players[self.TargetPlayer] = nil
    end

    function Handler:Update()
        if not self.TargetPlayer or not self.TargetPlayer.Parent then
            UpdateESPForPlayer(self.TargetPlayer)
            return
        end

        UpdateESPForPlayer(self.TargetPlayer)
    end

    local PlayerAddedConnection = Players.PlayerAdded:Connect(function(Player)
        if Player == Players.LocalPlayer then
            return
        end

        if Opts.CustomFilter and not Opts.CustomFilter(Player) then
            return
        end

        local PlayerHandler = setmetatable({}, {
            __index = Handler,
            __tostring = function()
                return "PlayerESP:" .. Player.Name
            end,
        })

        PlayerHandler.TargetPlayer = Player
        PlayerHandler.BoxLines = {}
        PlayerHandler.Connections = {}
        self.Players[Player] = PlayerHandler
    end)

    table.insert(Handler.Connections, PlayerAddedConnection)

    local PlayerRemovingConnection = Players.PlayerRemoving:Connect(function(Player)
        local PlayerHandler = self.Players[Player]
        if PlayerHandler then
            PlayerHandler:Destroy()
        end
    end)

    table.insert(Handler.Connections, PlayerRemovingConnection)

    for _, Player in Players:GetPlayers() do
        if Player ~= Players.LocalPlayer then
            if Opts.CustomFilter and not Opts.CustomFilter(Player) then
                continue
            end

            local PlayerHandler = setmetatable({}, {
                __index = Handler,
            })

            PlayerHandler.TargetPlayer = Player
            PlayerHandler.BoxLines = {}
            PlayerHandler.Connections = {}
            self.Players[Player] = PlayerHandler
        end
    end

    self:_StartUpdateLoop()

    return Handler
end

function ESP:AddObjectESP(Target: Instance, Options: ObjectESPOptions)
    self:_EnsureLibrary()
    assert(typeof(Target) == "Instance", "ObjectESP target must be an Instance")
    assert(typeof(Options) == "table", "ObjectESP options must be a table")

    local Opts: ObjectESPOptions = Options
    local ObjectHandler = {
        Target = Target,
        Options = Opts,
        BoxLines = {},
        NameLabel = nil,
        DistanceLabel = nil,
        TracerLine = nil,
        HighlightInst = nil,
        Destroyed = false,
    }

    local function UpdateObjectESP()
        if ObjectHandler.Destroyed then
            return
        end

        if not Target or not Target.Parent then
            return
        end

        local Position3D
        if Target:IsA("BasePart") then
            Position3D = Target.Position
        elseif Target:IsA("Model") then
            Position3D = Target:GetPivot().Position
        elseif Target:IsA("Attachment") then
            Position3D = Target.WorldPosition
        else
            return
        end

        if Opts.MaxDistance then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            if MyPos and (Position3D - MyPos).Magnitude > Opts.MaxDistance then
                ObjectHandler:ClearESP()
                return
            end
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            ObjectHandler:ClearESP()
            return
        end

        local BoxColor = Opts.BoxColor or Color3.fromRGB(255, 255, 0)

        if Opts.Box ~= false then
            local ObjectSize
            if Target:IsA("BasePart") then
                ObjectSize = Target.Size
            else
                ObjectSize = Vector3.new(4, 4, 4)
            end

            if ObjectSize then
                local TopPos = WorldToScreen(Position3D + Vector3World.new(0, ObjectSize.Y / 2, 0))
                local BottomPos =
                    WorldToScreen(Position3D - Vector3World.new(0, ObjectSize.Y / 2, 0))

                if TopPos and BottomPos then
                    local Height = math.abs(BottomPos.Y - TopPos.Y)
                    local Width = Height * 0.6

                    if Width > 4 and Height > 8 then
                        ObjectHandler:DrawBox(
                            (TopPos.X + BottomPos.X) / 2 - Width / 2,
                            TopPos.Y,
                            Width,
                            Height,
                            BoxColor,
                            "Standard",
                            Opts.BoxTransparency or 0,
                            1
                        )
                    end
                end
            end
        end

        local DisplayName = Opts.CustomName or Target.Name
        if Opts.Name ~= false then
            ObjectHandler:DrawName(
                DisplayName,
                ScreenPos.X,
                ScreenPos.Y - 14,
                13,
                Opts.NameColor or Color3.fromRGB(255, 255, 0)
            )
        end

        if Opts.Distance ~= false then
            local LocalPlayer = Players.LocalPlayer
            local MyChar = LocalPlayer and LocalPlayer.Character
            local MyPos = MyChar and GetCharacterPosition(MyChar)
            local DistanceText = ""
            if MyPos then
                local Dist = math.floor((Position3D - MyPos).Magnitude + 0.5)
                DistanceText = tostring(Dist) .. " studs"
            end
            ObjectHandler:DrawDistance(
                DistanceText,
                ScreenPos.X,
                ScreenPos.Y + 4,
                Opts.DistanceColor or Color3.fromRGB(200, 200, 200)
            )
        end

        if Opts.Tracer then
            local Viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
                or Vector2.new(1920, 1080)
            local StartX = Viewport.X / 2
            local StartY = Viewport.Y
            ObjectHandler:DrawTracer(
                StartX,
                StartY,
                ScreenPos.X,
                ScreenPos.Y,
                Opts.TracerColor or BoxColor,
                Opts.TracerTransparency or 0
            )
        end

        if Opts.Highlight and Target:IsA("BasePart") then
            if not ObjectHandler.HighlightInst or not ObjectHandler.HighlightInst.Parent then
                if ObjectHandler.HighlightInst then
                    ObjectHandler.HighlightInst:Destroy()
                end
                ObjectHandler.HighlightInst = Instance.new("Highlight")
                ObjectHandler.HighlightInst.FillTransparency = Opts.HighlightTransparency or 0.5
                ObjectHandler.HighlightInst.OutlineTransparency = 1
                ObjectHandler.HighlightInst.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                ObjectHandler.HighlightInst.Adornee = Target
                ObjectHandler.HighlightInst.Parent = Target
            end

            ObjectHandler.HighlightInst.FillColor = Opts.HighlightColor
                or Color3.fromRGB(255, 255, 0)
        elseif ObjectHandler.HighlightInst then
            ObjectHandler.HighlightInst:Destroy()
            ObjectHandler.HighlightInst = nil
        end
    end

    function ObjectHandler:DrawBox(
        Left: number,
        Top: number,
        Width: number,
        Height: number,
        Color: Color3,
        Style: BoxStyle,
        Transparency: number,
        Thickness: number
    )
        local function MakeLine(Index: number, Props: { [string]: any })
            if self.BoxLines[Index] and self.BoxLines[Index].Parent then
                for K, V in Props do
                    self.BoxLines[Index][K] = V
                end
                return
            end
            if self.BoxLines[Index] then
                self.BoxLines[Index]:Destroy()
            end
            local Line = Instance.new("Frame")
            Line.BorderSizePixel = 0
            Line.BackgroundColor3 = Color
            Line.BackgroundTransparency = Transparency or 0
            Line.ZIndex = 9999
            for K, V in Props do
                Line[K] = V
            end
            Line.Parent = self.Library.ScreenGui
            self.BoxLines[Index] = Line
        end

        MakeLine(
            1,
            { Position = UDim2.fromOffset(Left, Top), Size = UDim2.fromOffset(Width, Thickness) }
        )
        MakeLine(2, {
            Position = UDim2.fromOffset(Left, Top + Height),
            Size = UDim2.fromOffset(Width, Thickness),
        })
        MakeLine(
            3,
            { Position = UDim2.fromOffset(Left, Top), Size = UDim2.fromOffset(Thickness, Height) }
        )
        MakeLine(4, {
            Position = UDim2.fromOffset(Left + Width, Top),
            Size = UDim2.fromOffset(Thickness, Height),
        })
    end

    function ObjectHandler:DrawName(
        Text: string,
        CenterX: number,
        TopY: number,
        Size: number,
        Color: Color3
    )
        if not self.NameLabel or not self.NameLabel.Parent then
            if self.NameLabel then
                self.NameLabel:Destroy()
            end
            self.NameLabel = Instance.new("TextLabel")
            self.NameLabel.BackgroundTransparency = 1
            self.NameLabel.BorderSizePixel = 0
            self.NameLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.NameLabel.RichText = true
            self.NameLabel.TextStrokeTransparency = 0.5
            self.NameLabel.ZIndex = 9999
            self.NameLabel.Parent = self.Library.ScreenGui
        end
        self.NameLabel.Text = Text
        self.NameLabel.TextColor3 = Color
        self.NameLabel.TextSize = Size
        self.NameLabel.Size = UDim2.fromOffset(200, Size + 4)
        self.NameLabel.Position = UDim2.fromOffset(CenterX - 100, TopY)
        self.NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function ObjectHandler:DrawDistance(
        Text: string,
        CenterX: number,
        BottomY: number,
        Color: Color3
    )
        if not self.DistanceLabel or not self.DistanceLabel.Parent then
            if self.DistanceLabel then
                self.DistanceLabel:Destroy()
            end
            self.DistanceLabel = Instance.new("TextLabel")
            self.DistanceLabel.BackgroundTransparency = 1
            self.DistanceLabel.BorderSizePixel = 0
            self.DistanceLabel.FontFace = Font.fromEnum(Enum.Font.Code)
            self.DistanceLabel.RichText = true
            self.DistanceLabel.TextStrokeTransparency = 0.5
            self.DistanceLabel.TextSize = 11
            self.DistanceLabel.ZIndex = 9999
            self.DistanceLabel.Parent = self.Library.ScreenGui
        end
        self.DistanceLabel.Text = Text
        self.DistanceLabel.TextColor3 = Color
        self.DistanceLabel.Size = UDim2.fromOffset(200, 16)
        self.DistanceLabel.Position = UDim2.fromOffset(CenterX - 100, BottomY)
        self.DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    end

    function ObjectHandler:DrawTracer(
        StartX: number,
        StartY: number,
        EndX: number,
        EndY: number,
        Color: Color3,
        Transparency: number
    )
        if not self.TracerLine or not self.TracerLine.Parent then
            if self.TracerLine then
                self.TracerLine:Destroy()
            end
            self.TracerLine = Instance.new("Frame")
            self.TracerLine.BorderSizePixel = 0
            self.TracerLine.ZIndex = 9998
            self.TracerLine.Parent = self.Library.ScreenGui
        end
        local DX = EndX - StartX
        local DY = EndY - StartY
        local Length = math.sqrt(DX * DX + DY * DY)
        local Angle = math.atan2(DY, DX)
        self.TracerLine.BackgroundColor3 = Color
        self.TracerLine.BackgroundTransparency = Transparency or 0
        self.TracerLine.Size = UDim2.fromOffset(Length, 1)
        self.TracerLine.Position = UDim2.fromOffset(StartX, StartY)
        self.TracerLine.Rotation = math.deg(Angle)
    end

    function ObjectHandler:ClearESP()
        for i = 1, #self.BoxLines do
            if self.BoxLines[i] then
                self.BoxLines[i]:Destroy()
                self.BoxLines[i] = nil
            end
        end
        if self.NameLabel then
            self.NameLabel:Destroy()
            self.NameLabel = nil
        end
        if self.DistanceLabel then
            self.DistanceLabel:Destroy()
            self.DistanceLabel = nil
        end
        if self.TracerLine then
            self.TracerLine:Destroy()
            self.TracerLine = nil
        end
        if self.HighlightInst then
            self.HighlightInst:Destroy()
            self.HighlightInst = nil
        end
    end

    function ObjectHandler:Destroy()
        if ObjectHandler.Destroyed then
            return
        end
        ObjectHandler.Destroyed = true
        ObjectHandler:ClearESP()
        self.Objects[Target] = nil
    end

    function ObjectHandler:Update()
        UpdateObjectESP()
    end

    self.Objects[Target] = ObjectHandler
    self:_StartUpdateLoop()

    return ObjectHandler
end

function ESP:RemovePlayerESP(Player: Player)
    local Handler = self.Players[Player]
    if Handler then
        Handler:Destroy()
    end
end

function ESP:RemoveObjectESP(Target: Instance)
    local Handler = self.Objects[Target]
    if Handler then
        Handler:Destroy()
    end
end

function ESP:SetEnabled(Enabled: boolean)
    self.Enabled = Enabled
    for _, Handler in self.Players do
        if not Handler.Destroyed then
            Handler:ClearESP()
        end
    end
    for _, Handler in self.Objects do
        if not Handler.Destroyed then
            Handler:ClearESP()
        end
    end
end

function ESP:SetBoxesVisible(Visible: boolean)
    self.BoxesVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Box = Visible
        end
    end
end

function ESP:SetNamesVisible(Visible: boolean)
    self.NamesVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Name = Visible
        end
    end
end

function ESP:SetTracersVisible(Visible: boolean)
    self.TracersVisible = Visible
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.Tracer = Visible
        end
    end
end

function ESP:SetTeamCheck(Enabled: boolean)
    self.TeamCheck = Enabled
    for _, Handler in self.Players do
        if not Handler.Destroyed and Handler.Options then
            Handler.Options.TeamCheck = Enabled
        end
    end
end

-- Aimbot + Magic Bullet system

export type AimbotHitbox = "Head" | "Torso" | "Limb" | "Random"
export type AimbotOptions = {
    Enabled: boolean?,
    SilentAim: boolean?,
    Prediction: boolean?,
    PredictionAmount: number?,
    Smoothness: number?,
    Hitbox: AimbotHitbox?,
    AutoFire: boolean?,
    AutoFireDelay: number?,
    FOV: number?,
    MaxDistance: number?,
    TeamCheck: boolean?,
    VisibleCheck: boolean?,
    MagicBullet: boolean?,
    MagicBulletChance: number?,
}

local AimbotDefaults: AimbotOptions = {
    Enabled = false,
    SilentAim = false,
    Prediction = true,
    PredictionAmount = 0.5,
    Smoothness = 0.8,
    Hitbox = "Torso",
    AutoFire = false,
    AutoFireDelay = 0.15,
    FOV = 60,
    MaxDistance = 1000,
    TeamCheck = true,
    VisibleCheck = false,
    MagicBullet = false,
    MagicBulletChance = 100,
}

local function GetHitboxPosition(Character: Model, Hitbox: AimbotHitbox): Vector3?
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid or Humanoid.Health <= 0 then
        return nil
    end

    if Hitbox == "Head" then
        local Head = Character:FindFirstChild("Head")
        return Head and Head.Position
    end

    if Hitbox == "Torso" then
        local Torso = Character:FindFirstChild("HumanoidRootPart")
            or Character:FindFirstChild("UpperTorso")
            or Character:FindFirstChild("LowerTorso")
            or Character:FindFirstChild("Torso")
        return Torso and Torso.Position
    end

    if Hitbox == "Limb" then
        local Limbs = {
            Character:FindFirstChild("Left Arm"),
            Character:FindFirstChild("Right Arm"),
            Character:FindFirstChild("Left Leg"),
            Character:FindFirstChild("Right Leg"),
            Character:FindFirstChild("LeftHand"),
            Character:FindFirstChild("RightHand"),
            Character:FindFirstChild("LeftFoot"),
            Character:FindFirstChild("RightFoot"),
        }
        local Valid = {}
        for _, Limb in Limbs do
            if Limb then
                table.insert(Valid, Limb)
            end
        end
        if #Valid > 0 then
            return Valid[math.random(1, #Valid)].Position
        end
        return GetHitboxPosition(Character, "Torso")
    end

    if Hitbox == "Random" then
        local Choices = { "Head", "Torso", "Limb" }
        return GetHitboxPosition(Character, Choices[math.random(1, #Choices)])
    end

    return GetHitboxPosition(Character, "Torso")
end

local function PredictPosition(Target: Model, HitPos: Vector3, PredictionAmount: number): Vector3
    local RootPart = Target:FindFirstChild("HumanoidRootPart")
        or Target:FindFirstChild("UpperTorso")
        or Target:FindFirstChild("Torso")
    if not RootPart then
        return HitPos
    end

    local Velocity = RootPart.AssemblyLinearVelocity
    if Velocity.Magnitude < 1 then
        return HitPos
    end

    return HitPos + Velocity * PredictionAmount
end

function ESP:SetAimbotEnabled(Enabled: boolean)
    self._AimbotOptions.Enabled = Enabled
end

function ESP:SetAimbotOptions(Options: AimbotOptions)
    for K, V in Options do
        if self._AimbotOptions[K] ~= nil then
            self._AimbotOptions[K] = V
        end
    end
end

function ESP:GetAimbotTarget(): (Player?, Vector3?)
    local Opts = self._AimbotOptions
    if not Opts.Enabled then
        return nil, nil
    end

    local LocalPlayer = Players.LocalPlayer
    local MyChar = LocalPlayer and LocalPlayer.Character
    local MyRoot = MyChar
        and (
            MyChar:FindFirstChild("HumanoidRootPart")
            or MyChar:FindFirstChild("UpperTorso")
            or MyChar:FindFirstChild("Torso")
        )
    if not MyRoot then
        return nil, nil
    end

    local MousePos = UserInputService:GetMouseLocation()
    local ClosestPlayer: Player? = nil
    local ClosestHitPos: Vector3? = nil
    local ClosestScreenDist = math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed or not Handler.TargetPlayer then
            continue
        end
        if Player == LocalPlayer then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if not Humanoid or Humanoid.Health <= 0 then
            continue
        end

        if Opts.TeamCheck and IsOnSameTeam(Player) then
            continue
        end

        local HitPos = GetHitboxPosition(Character, Opts.Hitbox)
        if not HitPos then
            continue
        end

        local Dist = (MyRoot.Position - HitPos).Magnitude
        if Dist > Opts.MaxDistance then
            continue
        end

        if Opts.VisibleCheck then
            local Camera = workspace.CurrentCamera
            local RaycastParams = RaycastParams.new()
            RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
            RaycastParams.FilterDescendantsInstances = { Camera, MyChar, Character }
            local Direction = (HitPos - MyRoot.Position).Unit
            local Result = workspace:Raycast(MyRoot.Position, Direction * Dist, RaycastParams)
            if Result then
                continue
            end
        end

        local TargetPos = Opts.Prediction
                and PredictPosition(Character, HitPos, Opts.PredictionAmount)
            or HitPos
        local ScreenPos = WorldToScreen(TargetPos)
        if not ScreenPos then
            continue
        end

        local DX = ScreenPos.X - MousePos.X
        local DY = ScreenPos.Y - MousePos.Y
        local ScreenDist = math.sqrt(DX * DX + DY * DY)

        if ScreenDist <= Opts.FOV and ScreenDist < ClosestScreenDist then
            ClosestScreenDist = ScreenDist
            ClosestPlayer = Player
            ClosestHitPos = TargetPos
        end
    end

    return ClosestPlayer, ClosestHitPos
end

function ESP:GetAimbotTargetPosition(Player: Player): Vector3?
    local Character = Player.Character
    if not Character then
        return nil
    end
    return GetHitboxPosition(Character, self._AimbotOptions.Hitbox)
end

-- Silent Aim: rotate character toward target without visible snapping
local function SetupSilentAim(self: any)
    local LastTargetPos = nil

    local SilentAimConnection = RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.SilentAim then
            LastTargetPos = nil
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        local MyRoot = MyChar
            and (
                MyChar:FindFirstChild("HumanoidRootPart")
                or MyChar:FindFirstChild("UpperTorso")
                or MyChar:FindFirstChild("Torso")
            )
        if not MyRoot then
            return
        end

        local Target, HitPos = self:GetAimbotTarget()
        if not Target or not HitPos then
            return
        end

        if Opts.Smoothness and Opts.Smoothness < 1 then
            if LastTargetPos then
                HitPos = LastTargetPos:Lerp(HitPos, 1 - Opts.Smoothness)
            end
            LastTargetPos = HitPos
        end

        local LookCF =
            CFrame.lookAt(MyRoot.Position, Vector3.new(HitPos.X, MyRoot.Position.Y, HitPos.Z))
        MyRoot.CFrame = LookCF
    end)
    table.insert(self.Connections, SilentAimConnection)
end

-- Magic Bullet: redirect projectiles / tool fire to target
local function SetupMagicBullet(self: any)
    local ProjectileConnection = nil

    local function CreateMagicTracker(Child: Instance)
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.MagicBullet then
            return
        end
        if not Child:IsA("BasePart") then
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        if not MyChar then
            return
        end

        local Handle = nil
        local Tool = MyChar:FindFirstChildOfClass("Tool")
        if Tool then
            Handle = Tool:FindFirstChild("Handle")
        end
        if not Handle then
            return
        end

        local DistFromHandle = Handle and (Child.Position - Handle.Position).Magnitude or 999
        if DistFromHandle > 20 then
            return
        end

        local Target, HitPos = self:GetAimbotTarget()
        if not Target or not HitPos then
            return
        end
        local TargetChar = Target.Character
        if not TargetChar then
            return
        end

        if math.random(1, 100) > Opts.MagicBulletChance then
            return
        end

        if Opts.Prediction then
            HitPos = PredictPosition(TargetChar, HitPos, Opts.PredictionAmount)
        end

        local AlignPos = Instance.new("AlignPosition")
        AlignPos.MaxForce = 1e9
        AlignPos.MaxVelocity = 1e9
        AlignPos.Responsiveness = 200
        AlignPos.Parent = Child

        local Attach0 = Instance.new("Attachment", Child)
        AlignPos.Attachment0 = Attach0

        local TargetRoot = TargetChar:FindFirstChild("HumanoidRootPart")
            or TargetChar:FindFirstChild("UpperTorso")
            or TargetChar:FindFirstChild("Torso")
            or TargetChar
        local Attach1 = Instance.new("Attachment", TargetRoot)
        Attach1.WorldPosition = HitPos
        AlignPos.Attachment1 = Attach1

        game:GetService("Debris"):AddItem(Attach1, 0.5)
        game:GetService("Debris"):AddItem(AlignPos, 1)
    end

    if ProjectileConnection then
        ProjectileConnection:Disconnect()
    end
    ProjectileConnection = workspace.ChildAdded:Connect(CreateMagicTracker)
    table.insert(self.Connections, ProjectileConnection)

    -- Also check existing projectiles once per second
    local ScanConnection = RunService.Stepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.MagicBullet then
            return
        end
        for _, Child in workspace:GetChildren() do
            if Child:IsA("BasePart") and Child.Name:find("[Pp]rojectile") then
                CreateMagicTracker(Child)
            end
        end
    end)
    table.insert(self.Connections, ScanConnection)
end

-- Auto-fire: fire tool when a target is in FOV
local function SetupAutoFire(self: any)
    local LastFire = 0
    local AutoFireConnection = RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        local Opts = self._AimbotOptions
        if not Opts.Enabled or not Opts.AutoFire then
            LastFire = 0
            return
        end

        local Target, _ = self:GetAimbotTarget()
        if not Target then
            return
        end

        local LocalPlayer = Players.LocalPlayer
        local MyChar = LocalPlayer and LocalPlayer.Character
        if not MyChar then
            return
        end

        local Tool = MyChar:FindFirstChildOfClass("Tool")
        if not Tool then
            return
        end

        local Now = tick()
        if Now - LastFire < Opts.AutoFireDelay then
            return
        end
        LastFire = Now

        local ClickFunction = Tool:FindFirstChild("Click")
        if ClickFunction and ClickFunction:IsA("BindableFunction") then
            ClickFunction:Invoke()
        end

        local Activate = Tool:FindFirstChild("Activate")
        if Activate and Activate:IsA("BindableFunction") then
            Activate:Invoke()
        end

        local ToolRemote = Tool:FindFirstChildWhichIsA("RemoteEvent")
            or Tool:FindFirstChildWhichIsA("RemoteFunction")
        if ToolRemote then
            ToolRemote:FireServer()
        end
    end)
    table.insert(self.Connections, AutoFireConnection)
end

function ESP:GetNearestPlayerToMouse(MaxDistance: number?): (Player?, number?)
    self:_EnsureLibrary()

    local MousePos = UserInputService:GetMouseLocation()
    local ClosestPlayer: Player? = nil
    local ClosestDistance = MaxDistance or math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed or not Handler.TargetPlayer then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            continue
        end

        local ScreenPos = WorldToScreen(Position3D)
        if not ScreenPos then
            continue
        end

        local DX = ScreenPos.X - MousePos.X
        local DY = ScreenPos.Y - MousePos.Y
        local Distance = math.sqrt(DX * DX + DY * DY)

        if Distance < ClosestDistance then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end

    return ClosestPlayer, ClosestDistance
end

function ESP:GetNearestPlayerToCharacter(MaxDistance: number?): (Player?, number?)
    self:_EnsureLibrary()

    local LocalPlayer = Players.LocalPlayer
    local MyChar = LocalPlayer and LocalPlayer.Character
    local MyPos = MyChar and GetCharacterPosition(MyChar)

    if not MyPos then
        return nil, nil
    end

    local ClosestPlayer: Player? = nil
    local ClosestDistance = MaxDistance or math.huge

    for Player, Handler in self.Players do
        if Handler.Destroyed then
            continue
        end

        local Character = Player.Character
        if not Character then
            continue
        end

        local Position3D = GetCharacterPosition(Character)
        if not Position3D then
            continue
        end

        local Distance = (Position3D - MyPos).Magnitude
        if Distance < ClosestDistance then
            ClosestDistance = Distance
            ClosestPlayer = Player
        end
    end

    return ClosestPlayer, ClosestDistance
end

function ESP:IsTargetInFOV(Target: Player | Model, FOVRadius: number): boolean
    self:_EnsureLibrary()

    local Character
    if typeof(Target) == "Instance" and Target:IsA("Player") then
        Character = Target.Character
    elseif typeof(Target) == "Instance" and Target:IsA("Model") then
        Character = Target
    else
        return false
    end

    if not Character then
        return false
    end

    local Position3D = GetCharacterPosition(Character)
    if not Position3D then
        return false
    end

    local ScreenPos = WorldToScreen(Position3D)
    if not ScreenPos then
        return false
    end

    local MousePos = UserInputService:GetMouseLocation()
    local DX = ScreenPos.X - MousePos.X
    local DY = ScreenPos.Y - MousePos.Y
    local Distance = math.sqrt(DX * DX + DY * DY)

    return Distance <= (FOVRadius or 60)
end

function ESP:LockOntoTarget(Player: Player)
    self:_EnsureLibrary()
    self.TargetLock = Player
end

function ESP:UnlockTarget()
    self.TargetLock = nil
end

function ESP:GetLockedTarget(): Player?
    return self.TargetLock
end

function ESP:GetAllPlayers(): { Player }
    local Result = {}
    for Player, Handler in self.Players do
        if not Handler.Destroyed then
            table.insert(Result, Player)
        end
    end
    return Result
end

function ESP:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, PlayerHandler in self.Players do
        PlayerHandler:Destroy()
    end
    for _, ObjectHandler in self.Objects do
        ObjectHandler:Destroy()
    end

    if self.FOVDrawing then
        self.FOVDrawing:Destroy()
        self.FOVDrawing = nil
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self.UpdateConnection = nil

    self.TargetLock = nil
end

return ESP
