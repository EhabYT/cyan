--!strict
-- Cyan HUD addon: a lightweight, draggable status panel for experience-owned data.

local HUD = {}
HUD.__index = HUD

local RunService: RunService = game:GetService("RunService")
local Stats: Stats? = nil
pcall(function()
    Stats = game:GetService("Stats")
end)

export type TextInfo = {
    Text: string,
    Value: string | number?,
    Order: number?,
    Visible: boolean?,
}

export type ProgressInfo = {
    Text: string,
    Value: number?,
    Order: number?,
    Visible: boolean?,
    Format: ((number) -> string)?,
}

export type TimerInfo = {
    Text: string,
    Duration: number,
    Remaining: number?,
    Running: boolean?,
    Order: number?,
    Visible: boolean?,
    OnCompleted: (() -> ())?,
}

export type CounterInfo = {
    Text: string,
    Value: number?,
    Order: number?,
    Visible: boolean?,
}

export type WaypointInfo = {
    Text: string,
    Target: Vector3 | BasePart | Attachment | Model | (() -> Vector3?),
    Order: number?,
    Visible: boolean?,
    MaxDistance: number?,
}

export type MarkerInfo = {
    Text: string,
    Target: BasePart | Attachment,
    Color: Color3?,
    MaxDistance: number?,
    AlwaysOnTop: boolean?,
    Visible: boolean?,
}

export type InteractionInfo = MarkerInfo & {
    ActionText: string?,
    HoldDuration: number?,
    OnTriggered: ((Player) -> ())?,
}

export type PartyMember = {
    Id: string,
    Name: string,
    Status: string | number?,
    Visible: boolean?,
}

export type PerformanceInfo = {
    Text: string?,
    Order: number?,
    Visible: boolean?,
    PingProvider: (() -> string | number?)?,
}

export type Options = {
    Title: string?,
    Position: UDim2?,
    Visible: boolean?,
    UpdateInterval: number?,
}

local function ToDisplayText(Value: any): string
    if Value == nil then
        return ""
    end

    return tostring(Value)
end

local function EnsureLibrary(Library: any)
    assert(typeof(Library) == "table", "HUD requires a Cyan Library instance")
    assert(typeof(Library.AddDraggableMenu) == "function", "HUD requires Library:AddDraggableMenu")
    assert(typeof(Library.AddToRegistry) == "function", "HUD requires Library:AddToRegistry")
    assert(typeof(Library.OnUnload) == "function", "HUD requires Library:OnUnload")
end

local function CreateTextLabel(Library: any, Parent: Instance, Properties: { [string]: any }): TextLabel
    local Label = Instance.new("TextLabel")
    Label.BackgroundTransparency = 1
    Label.BorderSizePixel = 0
    Label.FontFace = Library.Scheme.Font
    Label.RichText = true
    Label.TextColor3 = Library.Scheme.FontColor
    Label.TextSize = 14
    Label.Size = UDim2.fromScale(1, 1)
    Label.Parent = Parent

    for Property, Value in Properties do
        Label[Property] = Value
    end

    Library:AddToRegistry(Label, {
        FontFace = "Font",
        TextColor3 = "FontColor",
    })

    return Label
end

local CompassDirections = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }

local function ResolveWorldPosition(Target: any): Vector3?
    local TargetType = typeof(Target)
    if TargetType == "Vector3" then
        return Target
    elseif TargetType == "function" then
        local Success, Position = pcall(Target)
        return if Success and typeof(Position) == "Vector3" then Position else nil
    elseif TargetType ~= "Instance" then
        return nil
    end

    if Target:IsA("Attachment") then
        return Target.WorldPosition
    elseif Target:IsA("BasePart") then
        return Target.Position
    elseif Target:IsA("Model") then
        return Target:GetPivot().Position
    end

    return nil
end

local function GetCompassDirection(Camera: Camera, Position: Vector3): (number, string)
    local Offset = Position - Camera.CFrame.Position
    local FlatDistance = Vector2.new(Offset.X, Offset.Z).Magnitude
    if FlatDistance <= 0.001 then
        return 0, "HERE"
    end

    local Angle = math.atan2(Offset.X, -Offset.Z)
    local Sector = math.floor((math.deg(Angle) + 22.5) / 45) % 8 + 1
    return FlatDistance, CompassDirections[Sector]
end

function HUD.new(Library: any, Options: Options?)
    EnsureLibrary(Library)

    local Config: Options = Options or {}
    assert(typeof(Config) == "table", "HUD options must be a table")

    local Holder, Container = Library:AddDraggableMenu(Config.Title or "HUD")
    if typeof(Config.Position) == "UDim2" then
        Holder.Position = Config.Position
    end
    Holder.Visible = Config.Visible ~= false

    local Self: any = setmetatable({
        Library = Library,
        Holder = Holder,
        Container = Container,
        Title = Config.Title or "HUD",
        Visible = Config.Visible ~= false,
        Entries = {},
        Timers = {},
        Waypoints = {},
        Markers = {},
        PartyEntries = {},
        PerformanceEntries = {},
        Connections = {},
        UpdateInterval = math.clamp(Config.UpdateInterval or (Library.IsMobile and 0.15 or 0.1), 0.05, 1),
        DisplayElapsed = 0,
        Destroyed = false,
    }, HUD)

    local function CreateEntry(Index: string, Height: number, Order: number?, Visible: boolean?)
        assert(typeof(Index) == "string" and Index ~= "", "HUD entry index must be a non-empty string")
        assert(
            Self.Entries[Index] == nil and Self.Markers[Index] == nil,
            string.format("HUD index %q already exists", Index)
        )

        local Frame = Instance.new("Frame")
        Frame.BackgroundColor3 = Library.Scheme.MainColor
        Frame.BorderSizePixel = 0
        Frame.Size = UDim2.new(1, 0, 0, Height)
        Frame.LayoutOrder = Order or 0
        Frame.Visible = Visible ~= false
        Frame.Parent = Container
        Library:AddToRegistry(Frame, {
            BackgroundColor3 = "MainColor",
        })
        Library:AddOutline(Frame)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius / 2)
        Corner.Parent = Frame
        table.insert(Library.Corners, Corner)

        local Entry: any = {
            Frame = Frame,
            Destroyed = false,
            Index = Index,
        }
        Self.Entries[Index] = Entry

        return Entry
    end

    function Self:AddText(Index: string, Info: TextInfo | string)
        assert(not Self.Destroyed, "HUD has been destroyed")

        local TextData: any = Info
        if typeof(TextData) == "string" then
            TextData = { Text = TextData }
        end
        assert(typeof(TextData) == "table" and typeof(TextData.Text) == "string", "HUD text entry requires Text")

        local Entry = CreateEntry(Index, 24, TextData.Order, TextData.Visible)
        local NameLabel = CreateTextLabel(Library, Entry.Frame, {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(0.58, -8, 1, 0),
            Text = TextData.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
        })
        local ValueLabel = CreateTextLabel(Library, Entry.Frame, {
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -8, 0, 0),
            Size = UDim2.new(0.42, -8, 1, 0),
            Text = ToDisplayText(TextData.Value),
            TextTransparency = 0.2,
            TextXAlignment = Enum.TextXAlignment.Right,
        })

        Entry.Text = TextData.Text
        Entry.Value = TextData.Value
        Entry.NameLabel = NameLabel
        Entry.ValueLabel = ValueLabel

        function Entry:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD text must be a string")
            Entry.Text = Text
            NameLabel.Text = Text
        end

        function Entry:SetValue(Value: string | number?)
            Entry.Value = Value
            ValueLabel.Text = ToDisplayText(Value)
        end

        function Entry:SetVisible(Visible: boolean)
            Entry.Frame.Visible = Visible == true
        end

        function Entry:Destroy()
            if Entry.Destroyed then
                return
            end
            Entry.Destroyed = true
            Self.Entries[Index] = nil
            Entry.Frame:Destroy()
        end

        Entry:SetValue(TextData.Value)
        return Entry
    end

    function Self:AddProgress(Index: string, Info: ProgressInfo)
        assert(not Self.Destroyed, "HUD has been destroyed")
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD progress entry requires Text")

        local Entry = CreateEntry(Index, 42, Info.Order, Info.Visible)
        local Label = CreateTextLabel(Library, Entry.Frame, {
            Position = UDim2.fromOffset(8, 0),
            Size = UDim2.new(1, -16, 0, 18),
            Text = Info.Text,
            TextXAlignment = Enum.TextXAlignment.Left,
        })

        local Bar = Instance.new("Frame")
        Bar.BackgroundColor3 = Library.Scheme.BackgroundColor
        Bar.BorderSizePixel = 0
        Bar.Position = UDim2.fromOffset(8, 25)
        Bar.Size = UDim2.new(1, -16, 0, 9)
        Bar.Parent = Entry.Frame
        Library:AddToRegistry(Bar, {
            BackgroundColor3 = "BackgroundColor",
        })

        local BarCorner = Instance.new("UICorner")
        BarCorner.CornerRadius = UDim.new(1, 0)
        BarCorner.Parent = Bar

        local Fill = Instance.new("Frame")
        Fill.BackgroundColor3 = Library.Scheme.AccentColor
        Fill.BorderSizePixel = 0
        Fill.Size = UDim2.fromScale(0, 1)
        Fill.Parent = Bar
        Library:AddToRegistry(Fill, {
            BackgroundColor3 = "AccentColor",
        })

        local FillCorner = Instance.new("UICorner")
        FillCorner.CornerRadius = UDim.new(1, 0)
        FillCorner.Parent = Fill

        Entry.Text = Info.Text
        Entry.Value = 0
        Entry.Label = Label
        Entry.Bar = Bar
        Entry.Fill = Fill

        function Entry:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD text must be a string")
            Entry.Text = Text
            Label.Text = Text
        end

        function Entry:SetValue(Value: number)
            assert(typeof(Value) == "number" and Value == Value, "HUD progress value must be a number")
            Entry.Value = math.clamp(Value, 0, 1)
            Fill.Size = UDim2.fromScale(Entry.Value, 1)
            if typeof(Info.Format) == "function" then
                Label.Text = Info.Format(Entry.Value)
            else
                Label.Text = string.format("%s  %d%%", Entry.Text, math.floor(Entry.Value * 100 + 0.5))
            end
        end

        function Entry:SetVisible(Visible: boolean)
            Entry.Frame.Visible = Visible == true
        end

        function Entry:Destroy()
            if Entry.Destroyed then
                return
            end
            Entry.Destroyed = true
            Self.Entries[Index] = nil
            Entry.Frame:Destroy()
        end

        Entry:SetValue(Info.Value or 0)
        return Entry
    end

    function Self:_GiveConnection(Connection: RBXScriptConnection)
        table.insert(Self.Connections, Connection)
        return Connection
    end

    function Self:_StopUpdateLoopIfIdle()
        if next(Self.Timers) or next(Self.Waypoints) or next(Self.PerformanceEntries) or not Self.UpdateConnection then
            return
        end

        if Self.UpdateConnection.Connected then
            Self.UpdateConnection:Disconnect()
        end
        local ConnectionIndex = table.find(Self.Connections, Self.UpdateConnection)
        if ConnectionIndex then
            table.remove(Self.Connections, ConnectionIndex)
        end
        Self.UpdateConnection = nil
    end

    function Self:_StartUpdateLoop()
        if Self.UpdateConnection then
            return
        end

        Self.UpdateConnection = Self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
            if Self.Destroyed then
                return
            end

            -- Count every rendered frame for accurate FPS, but update visible text less often.
            for Index, Performance in Self.PerformanceEntries do
                if Performance.Destroyed or Performance.Entry.Destroyed then
                    Self.PerformanceEntries[Index] = nil
                else
                    Performance.Elapsed += DeltaTime
                    Performance.Frames += 1
                end
            end

            Self.DisplayElapsed += DeltaTime
            if Self.DisplayElapsed < Self.UpdateInterval then
                return
            end

            local DisplayDelta = Self.DisplayElapsed
            Self.DisplayElapsed = 0

            for Index, Timer in Self.Timers do
                if Timer.Destroyed or Timer.Entry.Destroyed then
                    Self.Timers[Index] = nil
                elseif Timer.Running then
                    Timer:SetRemaining(Timer.Remaining - DisplayDelta)
                end
            end

            local Camera = workspace.CurrentCamera
            if Camera then
                for Index, Waypoint in Self.Waypoints do
                    if Waypoint.Destroyed or Waypoint.Entry.Destroyed then
                        Self.Waypoints[Index] = nil
                    else
                        local Position = ResolveWorldPosition(Waypoint.Target)
                        if Position then
                            local Distance, Direction = GetCompassDirection(Camera, Position)
                            local Value = if Waypoint.MaxDistance and Distance > Waypoint.MaxDistance
                                then "Out of range"
                                else string.format("%.0f studs • %s", Distance, Direction)
                            Waypoint.Entry:SetValue(Value)
                        else
                            Waypoint.Entry:SetValue("Unavailable")
                        end
                    end
                end
            end

            for _, Performance in Self.PerformanceEntries do
                if Performance.Elapsed >= 0.5 then
                    local FPS = math.floor(Performance.Frames / Performance.Elapsed + 0.5)
                    local Ping = nil
                    if typeof(Performance.PingProvider) == "function" then
                        local Success, Value = pcall(Performance.PingProvider)
                        Ping = if Success then Value else nil
                    elseif Stats then
                        pcall(function()
                            Ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValueString()
                        end)
                    end

                    local Value = string.format("%d FPS", FPS)
                    if Ping ~= nil then
                        Value ..= " • " .. tostring(Ping)
                    end
                    Performance.Entry:SetValue(Value)
                    Performance.Elapsed = 0
                    Performance.Frames = 0
                end
            end

            Self:_StopUpdateLoopIfIdle()
        end))
    end

    function Self:AddCounter(Index: string, Info: CounterInfo)
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD counter requires Text")

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = Info.Value or 0,
            Order = Info.Order,
            Visible = Info.Visible,
        })
        Entry.Count = tonumber(Info.Value) or 0

        function Entry:SetCount(Value: number)
            assert(typeof(Value) == "number" and Value == Value, "HUD counter value must be a number")
            Entry.Count = Value
            Entry:SetValue(Value)
        end

        function Entry:Add(Delta: number?)
            Entry:SetCount(Entry.Count + (Delta or 1))
        end

        return Entry
    end

    function Self:AddTimer(Index: string, Info: TimerInfo)
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD timer requires Text")
        assert(typeof(Info.Duration) == "number" and Info.Duration > 0, "HUD timer duration must be positive")

        local Entry = Self:AddProgress(Index, {
            Text = Info.Text,
            Value = 0,
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Timer: any = {
            Entry = Entry,
            Duration = Info.Duration,
            Remaining = math.clamp(Info.Remaining or Info.Duration, 0, Info.Duration),
            Running = Info.Running ~= false,
            Destroyed = false,
            OnCompleted = Info.OnCompleted,
        }
        Self.Timers[Index] = Timer

        local function RefreshDisplay()
            local Minutes = math.floor(Timer.Remaining / 60)
            local Seconds = math.floor(Timer.Remaining % 60)
            Entry.Label.Text = string.format("%s  %02d:%02d", Info.Text, Minutes, Seconds)
        end

        function Timer:SetRemaining(Remaining: number)
            assert(
                typeof(Remaining) == "number" and Remaining == Remaining,
                "HUD timer remaining value must be a number"
            )
            Timer.Remaining = math.clamp(Remaining, 0, Timer.Duration)
            Entry:SetValue(Timer.Remaining / Timer.Duration)
            RefreshDisplay()

            if Timer.Remaining <= 0 and Timer.Running then
                Timer.Running = false
                if typeof(Timer.OnCompleted) == "function" then
                    pcall(Timer.OnCompleted)
                end
            end
        end

        function Timer:Start()
            if not Timer.Destroyed and Timer.Remaining > 0 then
                Timer.Running = true
            end
        end

        function Timer:Pause()
            Timer.Running = false
        end

        function Timer:Reset(Remaining: number?)
            Timer:SetRemaining(Remaining or Timer.Duration)
            Timer.Running = true
        end

        function Timer:Destroy()
            if Timer.Destroyed then
                return
            end
            Timer.Destroyed = true
            Self.Timers[Index] = nil
            Self:Remove(Index)
        end

        Timer:SetRemaining(Timer.Remaining)
        Self:_StartUpdateLoop()
        return Timer
    end

    function Self:AddCooldown(Index: string, Info: TimerInfo)
        return Self:AddTimer(Index, Info)
    end

    function Self:AddProgressRing(Index: string, Info: ProgressInfo)
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD progress ring requires Text")

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = "○ 0%",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Glyphs = { "○", "◔", "◑", "◕", "●" }

        function Entry:SetValue(Value: number)
            assert(typeof(Value) == "number" and Value == Value, "HUD progress ring value must be a number")
            Entry.Progress = math.clamp(Value, 0, 1)
            local GlyphIndex = math.clamp(math.floor(Entry.Progress * (#Glyphs - 1) + 1.5), 1, #Glyphs)
            Entry.Value = Entry.Progress
            Entry.ValueLabel.Text = string.format("%s %d%%", Glyphs[GlyphIndex], math.floor(Entry.Progress * 100 + 0.5))
            if typeof(Info.Format) == "function" then
                Entry.ValueLabel.Text = Info.Format(Entry.Progress)
            end
        end

        Entry:SetValue(Info.Value or 0)
        return Entry
    end

    function Self:AddWaypoint(Index: string, Info: WaypointInfo)
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD waypoint requires Text")
        assert(
            ResolveWorldPosition(Info.Target) ~= nil or typeof(Info.Target) == "function",
            "HUD waypoint target is invalid"
        )

        local Entry = Self:AddText(Index, {
            Text = Info.Text,
            Value = "Locating...",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Waypoint: any = {
            Entry = Entry,
            Target = Info.Target,
            MaxDistance = Info.MaxDistance,
            Destroyed = false,
        }
        Self.Waypoints[Index] = Waypoint

        function Waypoint:SetTarget(Target: any)
            assert(
                ResolveWorldPosition(Target) ~= nil or typeof(Target) == "function",
                "HUD waypoint target is invalid"
            )
            Waypoint.Target = Target
        end

        function Waypoint:Destroy()
            if Waypoint.Destroyed then
                return
            end
            Waypoint.Destroyed = true
            Self.Waypoints[Index] = nil
            Self:Remove(Index)
        end

        Self:_StartUpdateLoop()
        return Waypoint
    end

    function Self:AddObjectiveTracker(Index: string, Info: WaypointInfo)
        return Self:AddWaypoint(Index, Info)
    end

    function Self:AddObjectiveMarker(Index: string, Info: MarkerInfo)
        assert(typeof(Index) == "string" and Index ~= "", "HUD marker index must be a non-empty string")
        assert(typeof(Info) == "table" and typeof(Info.Text) == "string", "HUD marker requires Text")
        assert(
            typeof(Info.Target) == "Instance" and (Info.Target:IsA("BasePart") or Info.Target:IsA("Attachment")),
            "HUD marker target must be a BasePart or Attachment"
        )
        assert(
            Self.Markers[Index] == nil and Self.Entries[Index] == nil,
            string.format("HUD index %q already exists", Index)
        )

        local Billboard = Instance.new("BillboardGui")
        Billboard.Name = "CyanObjective_" .. Index
        Billboard.Adornee = Info.Target
        Billboard.AlwaysOnTop = Info.AlwaysOnTop == true
        Billboard.LightInfluence = 0
        Billboard.MaxDistance = Info.MaxDistance or 250
        Billboard.Size = UDim2.fromOffset(180, 32)
        Billboard.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
        Billboard.Enabled = Self.Visible and Info.Visible ~= false
        Billboard.Parent = Library.ScreenGui

        local Label = CreateTextLabel(Library, Billboard, {
            BackgroundColor3 = Library.Scheme.BackgroundColor,
            BackgroundTransparency = 0.15,
            Text = Info.Text,
            TextColor3 = Info.Color or Library.Scheme.FontColor,
            TextScaled = true,
        })
        local LabelRegistry = {
            FontFace = "Font",
            BackgroundColor3 = "BackgroundColor",
        }
        if Info.Color == nil then
            LabelRegistry.TextColor3 = "FontColor"
        end
        Library:AddToRegistry(Label, LabelRegistry)

        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, Library.CornerRadius)
        Corner.Parent = Label

        local Marker: any = {
            Billboard = Billboard,
            Label = Label,
            Index = Index,
            Destroyed = false,
            UserVisible = Info.Visible ~= false,
        }
        Self.Markers[Index] = Marker

        function Marker:_ApplyVisibility()
            Billboard.Enabled = Self.Visible and Marker.UserVisible
        end

        function Marker:SetText(Text: string)
            assert(typeof(Text) == "string", "HUD marker text must be a string")
            Label.Text = Text
        end

        function Marker:SetVisible(Visible: boolean)
            Marker.UserVisible = Visible == true
            Marker:_ApplyVisibility()
        end

        function Marker:Destroy()
            if Marker.Destroyed then
                return
            end
            Marker.Destroyed = true
            Self.Markers[Index] = nil
            Billboard:Destroy()
        end

        return Marker
    end

    function Self:AddInteractionPrompt(Index: string, Info: InteractionInfo)
        assert(
            typeof(Info) == "table" and typeof(Info.Target) == "Instance",
            "HUD interaction prompt requires a target"
        )

        local ActionText = Info.ActionText or "Interact"
        local Marker = Self:AddObjectiveMarker(Index, {
            Text = string.format("[%s] %s", ActionText, Info.Text),
            Target = Info.Target,
            Color = Info.Color,
            MaxDistance = Info.MaxDistance,
            AlwaysOnTop = false,
            Visible = Info.Visible,
        })

        local Prompt = Instance.new("ProximityPrompt")
        Prompt.ActionText = ActionText
        Prompt.ObjectText = Info.Text
        Prompt.MaxActivationDistance = math.min(Info.MaxDistance or 12, 50)
        Prompt.HoldDuration = math.max(0, Info.HoldDuration or 0)
        Prompt.RequiresLineOfSight = true
        Prompt.Enabled = Self.Visible and Info.Visible ~= false
        Prompt.Parent = Info.Target

        local Connection = Prompt.Triggered:Connect(function(Player)
            if typeof(Info.OnTriggered) == "function" then
                pcall(Info.OnTriggered, Player)
            end
        end)

        local BaseDestroy = Marker.Destroy
        Marker.Prompt = Prompt
        function Marker:_ApplyVisibility()
            local Visible = Self.Visible and Marker.UserVisible
            Marker.Billboard.Enabled = Visible
            Prompt.Enabled = Visible
        end
        function Marker:SetVisible(Visible: boolean)
            Marker.UserVisible = Visible == true
            Marker:_ApplyVisibility()
        end
        function Marker:Destroy()
            if Marker.Destroyed then
                return
            end
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
            Prompt:Destroy()
            BaseDestroy(Marker)
        end

        return Marker
    end

    function Self:SetParty(Members: { PartyMember })
        assert(typeof(Members) == "table", "HUD party members must be a table")
        local Active = {}

        for Order, Member in Members do
            assert(
                typeof(Member) == "table" and typeof(Member.Id) == "string" and typeof(Member.Name) == "string",
                "HUD party member is invalid"
            )
            local EntryIndex = "party:" .. Member.Id
            Active[EntryIndex] = true
            local Entry = Self.PartyEntries[EntryIndex]
            if not Entry then
                Entry = Self:AddText(EntryIndex, {
                    Text = Member.Name,
                    Value = Member.Status,
                    Order = Order,
                    Visible = Member.Visible,
                })
                Self.PartyEntries[EntryIndex] = Entry
            else
                Entry:SetText(Member.Name)
                Entry:SetValue(Member.Status)
                Entry:SetVisible(Member.Visible ~= false)
            end
        end

        for EntryIndex, Entry in Self.PartyEntries do
            if not Active[EntryIndex] then
                Entry:Destroy()
                Self.PartyEntries[EntryIndex] = nil
            end
        end
    end

    function Self:AddPerformance(Index: string, Info: PerformanceInfo?)
        Info = Info or {}
        assert(typeof(Info) == "table", "HUD performance options must be a table")

        local Entry = Self:AddText(Index, {
            Text = Info.Text or "Performance",
            Value = "Measuring...",
            Order = Info.Order,
            Visible = Info.Visible,
        })
        local Performance: any = {
            Entry = Entry,
            PingProvider = Info.PingProvider,
            Elapsed = 0,
            Frames = 0,
            Destroyed = false,
        }
        Self.PerformanceEntries[Index] = Performance

        function Performance:Destroy()
            if Performance.Destroyed then
                return
            end
            Performance.Destroyed = true
            Self.PerformanceEntries[Index] = nil
            Self:Remove(Index)
        end

        Self:_StartUpdateLoop()
        return Performance
    end

    function Self:SetUpdateInterval(Seconds: number)
        assert(typeof(Seconds) == "number" and Seconds == Seconds, "HUD update interval must be a number")
        Self.UpdateInterval = math.clamp(Seconds, 0.05, 1)
    end

    function Self:Alert(Info: { [string]: any } | string, Time: number?)
        return Library:Notify(Info, Time)
    end

    function Self:GetEntry(Index: string)
        return Self.Entries[Index]
    end

    function Self:Remove(Index: string): boolean
        local Entry = Self.Entries[Index]
        if not Entry then
            local Marker = Self.Markers[Index]
            if Marker then
                Marker:Destroy()
                return true
            end
            return false
        end

        local Timer = Self.Timers[Index]
        if Timer then
            Timer.Destroyed = true
            Self.Timers[Index] = nil
        end
        local Waypoint = Self.Waypoints[Index]
        if Waypoint then
            Waypoint.Destroyed = true
            Self.Waypoints[Index] = nil
        end
        local Performance = Self.PerformanceEntries[Index]
        if Performance then
            Performance.Destroyed = true
            Self.PerformanceEntries[Index] = nil
        end
        Self.PartyEntries[Index] = nil

        Entry:Destroy()
        Self:_StopUpdateLoopIfIdle()
        return true
    end

    function Self:Clear()
        local EntryIndexes = {}
        for Index in Self.Entries do
            table.insert(EntryIndexes, Index)
        end
        for _, Index in EntryIndexes do
            Self:Remove(Index)
        end
    end

    function Self:ClearMarkers()
        local Markers = {}
        for _, Marker in Self.Markers do
            table.insert(Markers, Marker)
        end
        for _, Marker in Markers do
            Marker:Destroy()
        end
    end

    function Self:SetVisible(Visible: boolean)
        Self.Visible = Visible == true
        Holder.Visible = Self.Visible
        for _, Marker in Self.Markers do
            Marker:_ApplyVisibility()
        end
    end

    function Self:Toggle()
        Self:SetVisible(not Self.Visible)
    end

    function Self:SetTitle(Title: string)
        assert(typeof(Title) == "string", "HUD title must be a string")
        Self.Title = Title
        for _, Child in Holder:GetChildren() do
            if Child:IsA("TextLabel") and Child.Size.Y.Offset == 34 then
                Child.Text = Title
                break
            end
        end
    end

    function Self:Destroy()
        if Self.Destroyed then
            return
        end
        Self.Destroyed = true
        Self:Clear()
        Self:ClearMarkers()

        for Index = #Self.Connections, 1, -1 do
            local Connection = table.remove(Self.Connections, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end
        Self.UpdateConnection = nil

        local DraggableIndex = table.find(Library.DraggableElements, Holder)
        if DraggableIndex then
            table.remove(Library.DraggableElements, DraggableIndex)
        end

        Holder:Destroy()
    end

    Library:OnUnload(function()
        Self:Destroy()
    end)

    return Self
end

return HUD
