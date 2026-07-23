--!strict
-- Cyan Visuals addon: Fullbright, Night Vision, X-Ray, Fog control, and FPS counter.

local Visuals = {}
Visuals.__index = Visuals

local RunService: RunService = game:GetService("RunService")
local Lighting: Lighting = game:GetService("Lighting")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type VisualsOptions = {
    Fullbright: boolean?,
    NightVision: boolean?,
    NightVisionIntensity: number?,
    XRay: boolean?,
    FogOverride: boolean?,
    FogStart: number?,
    FogEnd: number?,
    FogColor: Color3?,
    FPSCounter: boolean?,
}

local function GetHumanoid(Player: Player): Humanoid?
    local Character = Player and Player.Character
    return Character and Character:FindFirstChildOfClass("Humanoid")
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

local function CloneLightingProperties(LightingInstance: Lighting): { [string]: any }
    local Props = {}
    for _, Property in
        {
            "Ambient",
            "Brightness",
            "ColorShift_Top",
            "ColorShift_Bottom",
            "OutdoorAmbient",
            "FogStart",
            "FogEnd",
            "FogColor",
            "GlobalShadows",
            "ClockTime",
            "GeographicLatitude",
            "ExposureCompensation",
            "EnvironmentDiffuseScale",
            "EnvironmentSpecularScale",
        }
    do
        local Success, Value = pcall(function()
            return LightingInstance[Property]
        end)
        if Success then
            Props[Property] = Value
        end
    end
    return Props
end

function Visuals.new(Library: any, Options: VisualsOptions?)
    assert(typeof(Library) == "table", "Visuals requires a Cyan Library instance")

    local Config: VisualsOptions = Options or {}
    local ScreenGui = Library.ScreenGui
    assert(typeof(ScreenGui) == "Instance", "Visuals requires Library.ScreenGui")

    local SavedLighting = CloneLightingProperties(Lighting)
    local SavedAmbient = Lighting.Ambient
    local SavedOutdoorAmbient = Lighting.OutdoorAmbient
    local SavedBrightness = Lighting.Brightness
    local SavedShadows = Lighting.GlobalShadows
    local SavedFogStart = Lighting.FogStart
    local SavedFogEnd = Lighting.FogEnd
    local SavedFogColor = Lighting.FogColor
    local SavedClockTime = Lighting.ClockTime

    local NightVisionOverlay = Instance.new("Frame")
    NightVisionOverlay.Name = "CyanNightVision"
    NightVisionOverlay.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    NightVisionOverlay.BackgroundTransparency = 0.85
    NightVisionOverlay.BorderSizePixel = 0
    NightVisionOverlay.Size = UDim2.fromScale(1, 1)
    NightVisionOverlay.ZIndex = 100000
    NightVisionOverlay.Visible = false
    NightVisionOverlay.Active = false
    NightVisionOverlay.Parent = ScreenGui

    local FPSCounterLabel = Instance.new("TextLabel")
    FPSCounterLabel.Name = "CyanFPSCounter"
    FPSCounterLabel.BackgroundTransparency = 1
    FPSCounterLabel.BorderSizePixel = 0
    FPSCounterLabel.FontFace = Font.fromEnum(Enum.Font.Code)
    FPSCounterLabel.RichText = true
    FPSCounterLabel.Text = "FPS: --"
    FPSCounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    FPSCounterLabel.TextSize = 14
    FPSCounterLabel.TextStrokeTransparency = 0.5
    FPSCounterLabel.Position = UDim2.new(1, -80, 0, 6)
    FPSCounterLabel.Size = UDim2.fromOffset(74, 20)
    FPSCounterLabel.ZIndex = 10000
    FPSCounterLabel.Visible = false
    FPSCounterLabel.Parent = ScreenGui

    local XRayHighlights: { [Player]: Highlight } = {}

    local self: any = setmetatable({
        Library = Library,
        Fullbright = false,
        NightVision = false,
        NightVisionIntensity = Config.NightVisionIntensity or 0.85,
        XRay = false,
        FogOverride = false,
        FogStart = Config.FogStart or 0,
        FogEnd = Config.FogEnd or math.huge,
        FogColor = Config.FogColor or Color3.fromRGB(128, 128, 128),
        FPSCounter = false,
        FPSCounterDisplay = "",
        FPSTable = {},
        FPSIndex = 0,
        Connections = {},
        Destroyed = false,
        SavedLighting = SavedLighting,
    }, Visuals)

    if Config.Fullbright then
        self:SetFullbright(true)
    end
    if Config.NightVision then
        self:SetNightVision(true, Config.NightVisionIntensity)
    end
    if Config.XRay then
        self:SetXRay(true)
    end
    if Config.FogOverride then
        self:SetFogOverride(true, Config.FogStart, Config.FogEnd, Config.FogColor)
    end
    if Config.FPSCounter then
        self:SetFPSCounter(true)
    end

    if self.FPSCounter then
        self:_StartFPSLoop()
    end

    Library:OnUnload(function()
        self:Destroy()
    end)

    return self
end

function Visuals:_GiveConnection(Connection: RBXScriptConnection)
    table.insert(self.Connections, Connection)
    return Connection
end

function Visuals:_GetFPSEstimate(): number
    self.FPSIndex += 1
    self.FPSTable[self.FPSIndex] = tick()
    local Cutoff = self.FPSTable[self.FPSIndex - 60]
    if Cutoff then
        local FPS = 60 / (self.FPSTable[self.FPSIndex] - Cutoff)
        self.FPSCounterDisplay = string.format("%.0f", FPS)
        if FPS >= 55 then
            FPSCounterLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        elseif FPS >= 30 then
            FPSCounterLabel.TextColor3 = Color3.fromRGB(255, 200, 0)
        else
            FPSCounterLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    while self.FPSTable[self.FPSIndex - 120] do
        self.FPSTable[self.FPSIndex - 120] = nil
    end

    return tonumber(self.FPSCounterDisplay) or 0
end

function Visuals:_StartFPSLoop()
    if self._FPSConnection then
        return
    end

    self._FPSConnection = self:_GiveConnection(RunService.RenderStepped:Connect(function()
        if self.Destroyed then
            return
        end
        if self.FPSCounter and FPSCounterLabel then
            self:_GetFPSEstimate()
            FPSCounterLabel.Text = "FPS: " .. self.FPSCounterDisplay
        end
    end))
end

function Visuals:SetFullbright(Enabled: boolean)
    self.Fullbright = Enabled

    if Enabled then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        Lighting.Ambient = Color3.new(1, 1, 1)
        Lighting.FogEnd = math.huge
        Lighting.ClockTime = 14
    else
        Lighting.Brightness = self.SavedLighting.Brightness or 1
        Lighting.GlobalShadows = self.SavedLighting.GlobalShadows
        Lighting.OutdoorAmbient = self.SavedLighting.OutdoorAmbient or Color3.new(0.3, 0.3, 0.3)
        Lighting.Ambient = self.SavedLighting.Ambient or Color3.new(0.5, 0.5, 0.5)
        Lighting.ClockTime = self.SavedLighting.ClockTime or 12

        if not self.FogOverride then
            Lighting.FogEnd = self.SavedLighting.FogEnd or 500
        end
    end
end

function Visuals:SetNightVision(Enabled: boolean, Intensity: number?)
    self.NightVision = Enabled
    if Intensity then
        self.NightVisionIntensity = math.clamp(Intensity, 0, 1)
    end

    if Enabled then
        Lighting.Brightness = 2
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.new(0.8, 0.8, 0.8)
        Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
        NightVisionOverlay.BackgroundTransparency = self.NightVisionIntensity
        NightVisionOverlay.Visible = true
    else
        if not self.Fullbright then
            Lighting.Brightness = self.SavedLighting.Brightness or 1
            Lighting.GlobalShadows = self.SavedLighting.GlobalShadows
            Lighting.Ambient = self.SavedLighting.Ambient or Color3.new(0.5, 0.5, 0.5)
            Lighting.OutdoorAmbient = self.SavedLighting.OutdoorAmbient or Color3.new(0.3, 0.3, 0.3)
        end
        NightVisionOverlay.Visible = false
    end
end

function Visuals:_UpdateXRayPlayer(Player: Player)
    if self.Destroyed then
        return
    end

    local Character = Player.Character
    if not Character then
        local Existing = XRayHighlights[Player]
        if Existing then
            Existing:Destroy()
            XRayHighlights[Player] = nil
        end
        return
    end

    local RootPart = GetRootPart(Player)
    if not RootPart then
        return
    end

    if self.XRay then
        local Highlight = XRayHighlights[Player]
        if not Highlight or not Highlight.Parent then
            if Highlight then
                Highlight:Destroy()
            end
            Highlight = Instance.new("Highlight")
            Highlight.FillTransparency = 0.5
            Highlight.OutlineTransparency = 1
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = Player.Team and Player.Team.TeamColor.Color
                or Color3.fromRGB(255, 255, 255)
            Highlight.Parent = Character
            XRayHighlights[Player] = Highlight
        end
        Highlight.Adornee = Character
    else
        local Existing = XRayHighlights[Player]
        if Existing then
            Existing:Destroy()
            XRayHighlights[Player] = nil
        end
    end
end

function Visuals:SetXRay(Enabled: boolean)
    self.XRay = Enabled

    for _, Player in Players:GetPlayers() do
        if Player ~= Players.LocalPlayer then
            self:_UpdateXRayPlayer(Player)
        end
    end

    if Enabled then
        if not self._XRayConnection then
            self._XRayConnection = self:_GiveConnection(Players.PlayerAdded:Connect(function(Player)
                Player.CharacterAdded:Connect(function()
                    task.wait(0.5)
                    self:_UpdateXRayPlayer(Player)
                end)
                self:_UpdateXRayPlayer(Player)
            end))
            self:_GiveConnection(Players.PlayerRemoving:Connect(function(Player)
                local Existing = XRayHighlights[Player]
                if Existing then
                    Existing:Destroy()
                    XRayHighlights[Player] = nil
                end
            end))
        end

        self:_GiveConnection(RunService.Heartbeat:Connect(function()
            if not self.XRay then
                return
            end
            for _, Player in Players:GetPlayers() do
                if Player ~= Players.LocalPlayer then
                    self:_UpdateXRayPlayer(Player)
                end
            end
        end))
    end
end

function Visuals:SetFogOverride(Enabled: boolean, Start: number?, End: number?, Color: Color3?)
    self.FogOverride = Enabled

    if Enabled then
        if Start then
            self.FogStart = Start
            Lighting.FogStart = Start
        end
        if End then
            self.FogEnd = End
        end
        Lighting.FogEnd = self.FogEnd
        if Color then
            self.FogColor = Color
            Lighting.FogColor = Color
        end
    else
        Lighting.FogStart = self.SavedLighting.FogStart or 0
        Lighting.FogEnd = self.SavedLighting.FogEnd or 500
        Lighting.FogColor = self.SavedLighting.FogColor or Color3.fromRGB(128, 128, 128)
    end
end

function Visuals:ResetFog()
    self.FogOverride = false
    Lighting.FogStart = self.SavedLighting.FogStart or 0
    Lighting.FogEnd = self.SavedLighting.FogEnd or 500
    Lighting.FogColor = self.SavedLighting.FogColor or Color3.fromRGB(128, 128, 128)
end

function Visuals:SetFPSCounter(Enabled: boolean)
    self.FPSCounter = Enabled
    FPSCounterLabel.Visible = Enabled

    if Enabled then
        self:_StartFPSLoop()
    end
end

function Visuals:ResetAll()
    self:SetFullbright(false)
    self:SetNightVision(false)
    self:SetXRay(false)
    self:ResetFog()
    self:SetFPSCounter(false)
end

function Visuals:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    self:ResetAll()

    for _, Highlight in XRayHighlights do
        Highlight:Destroy()
    end

    if NightVisionOverlay then
        NightVisionOverlay:Destroy()
    end
    if FPSCounterLabel then
        FPSCounterLabel:Destroy()
    end

    for Index = #self.Connections, 1, -1 do
        local Connection = table.remove(self.Connections, Index)
        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end
    self._FPSConnection = nil
    self._XRayConnection = nil
end

return Visuals
