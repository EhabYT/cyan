--!strict
-- Cyan UI Utilities addon: Watermark, Notification Presets, Color Palette.

local UIUtilities = {}
UIUtilities.__index = UIUtilities

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Stats: Stats = game:GetService("Stats")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

export type WatermarkOptions = {
	Visible: boolean?,
	Position: UDim2?,
	Title: string?,
	ShowFPS: boolean?,
	ShowPing: boolean?,
	ShowPlayers: boolean?,
	ShowTime: boolean?,
	TextSize: number?,
}

export type PaletteColor = {
	Name: string,
	Color: Color3,
}

export type ColorPaletteOptions = {
	Visible: boolean?,
	Position: UDim2?,
	Colors: { PaletteColor }?,
	OnColorSelected: ((Color3, string) -> ())?,
}

export type UIUtilitiesOptions = {
	Watermark: WatermarkOptions?,
	ColorPalette: ColorPaletteOptions?,
}

local function GetFPS(): number
	return math.floor(1 / RunService.RenderStepped:Wait())
end

local function GetPing(): string
	local PingStats = Stats.Network.ServerStatsItem
	local Ping = ""
	pcall(function()
		Ping = PingStats["Data Ping"]:GetValueString()
	end)
	return Ping
end

local DefaultPalette: { PaletteColor } = {
	{ Name = "Red", Color = Color3.fromRGB(255, 50, 50) },
	{ Name = "Orange", Color = Color3.fromRGB(255, 150, 50) },
	{ Name = "Yellow", Color = Color3.fromRGB(255, 255, 50) },
	{ Name = "Lime", Color = Color3.fromRGB(50, 255, 50) },
	{ Name = "Green", Color = Color3.fromRGB(50, 200, 50) },
	{ Name = "Cyan", Color = Color3.fromRGB(50, 255, 255) },
	{ Name = "Teal", Color = Color3.fromRGB(50, 150, 200) },
	{ Name = "Blue", Color = Color3.fromRGB(50, 100, 255) },
	{ Name = "Purple", Color = Color3.fromRGB(200, 50, 255) },
	{ Name = "Pink", Color = Color3.fromRGB(255, 50, 200) },
	{ Name = "White", Color = Color3.fromRGB(255, 255, 255) },
	{ Name = "Gray", Color = Color3.fromRGB(150, 150, 150) },
	{ Name = "Black", Color = Color3.fromRGB(30, 30, 30) },
}

function UIUtilities.new(Library: any, Options: UIUtilitiesOptions?)
	assert(typeof(Library) == "table", "UIUtilities requires a Cyan Library instance")

	local Config: UIUtilitiesOptions = Options or {}
	local self: any = setmetatable({
		Library = Library,
		Config = Config,
		Watermark = nil,
		WatermarkOptions = Config.Watermark or {},
		ColorPaletteMenu = nil,
		ColorPaletteOptions = Config.ColorPalette or {},
		PaletteCallback = (Config.ColorPalette or {}).OnColorSelected or nil,
		Connections = {},
		Destroyed = false,
	}, UIUtilities)

	-- Watermark
	local WmOpts = self.WatermarkOptions
	local WmHolder, WmContainer = Library:AddDraggableMenu(
		WmOpts.Title and WmOpts.Title .. " — Info" or "Watermark"
	)
	if WmOpts.Position then
		WmHolder.Position = WmOpts.Position
	end
	WmHolder.Visible = WmOpts.Visible ~= false
	self.Watermark = WmHolder
	self.WatermarkContainer = WmContainer

	local function BuildWatermark()
		for _, Child in WmContainer:GetChildren() do
			if Child:IsA("TextLabel") or Child:IsA("Frame") then
				Child:Destroy()
			end
		end

		if not WmHolder.Visible then
			return
		end

		local FPS = GetFPS()
		local FPSColor: Color3
		if FPS >= 55 then
			FPSColor = Color3.fromRGB(0, 255, 0)
		elseif FPS >= 30 then
			FPSColor = Color3.fromRGB(255, 255, 0)
		else
			FPSColor = Color3.fromRGB(255, 0, 0)
		end

		local Lines: { string } = {}
		if WmOpts.ShowFPS ~= false then
			table.insert(Lines, string.format("<b>FPS:</b> <font color='rgb(%d,%d,%d)'>%d</font>", FPSColor.R * 255, FPSColor.G * 255, FPSColor.B * 255, FPS))
		end
		if WmOpts.ShowPing ~= false then
			local Ping = GetPing()
			table.insert(Lines, "<b>Ping:</b> " .. (Ping ~= "" and Ping or "N/A"))
		end
		if WmOpts.ShowPlayers ~= false then
			table.insert(Lines, string.format("<b>Players:</b> %d / %d", #Players:GetPlayers(), Players.MaxPlayers))
		end
		if WmOpts.ShowTime ~= false then
			table.insert(Lines, "<b>Time:</b> " .. os.date("%H:%M:%S"))
		end

		local Text = table.concat(Lines, "  |  ")
		local Label = Instance.new("TextLabel")
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0
		Label.FontFace = Library.Scheme.Font
		Label.RichText = true
		Label.TextColor3 = Library.Scheme.FontColor
		Label.TextSize = WmOpts.TextSize or 13
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Text = Text
		Label.Size = UDim2.new(1, -10, 0, 20)
		Label.Parent = WmContainer

		Library:AddToRegistry(Label, {
			FontFace = "Font",
			TextColor3 = "FontColor",
		})
	end

	local WmConnection = RunService.Heartbeat:Connect(function()
		if self.Destroyed then
			return
		end
		BuildWatermark()
	end)
	table.insert(self.Connections, WmConnection)

	-- Color Palette
	local PalOpts = self.ColorPaletteOptions
	local Colors = PalOpts.Colors or DefaultPalette
	local PalHolder, PalContainer = Library:AddDraggableMenu("Color Palette")
	if PalOpts.Position then
		PalHolder.Position = PalOpts.Position
	else
		PalHolder.Position = UDim2.fromOffset(300, 6)
	end
	PalHolder.Visible = PalOpts.Visible ~= false
	self.ColorPaletteMenu = PalHolder
	self.ColorPaletteContainer = PalContainer

	local PaletteGrid = Instance.new("UIGridLayout")
	PaletteGrid.CellSize = UDim2.fromOffset(30, 30)
	PaletteGrid.CellPadding = UDim2.fromOffset(4, 4)
	PaletteGrid.FillDirection = Enum.FillDirection.Horizontal
	PaletteGrid.StartCorner = Enum.StartCorner.TopLeft
	PaletteGrid.Parent = PalContainer

	for _, ColorEntry in Colors do
		local ColorBtn = Instance.new("ImageButton")
		ColorBtn.BackgroundColor3 = ColorEntry.Color
		ColorBtn.BorderSizePixel = 0
		ColorBtn.Size = UDim2.fromOffset(30, 30)
		ColorBtn.AutoButtonColor = false
		ColorBtn.Parent = PalContainer

		local Corner = Instance.new("UICorner")
		Corner.CornerRadius = UDim.new(0, 4)
		Corner.Parent = ColorBtn

		local Hover = Instance.new("Frame")
		Hover.BackgroundColor3 = Color3.new(1, 1, 1)
		Hover.BackgroundTransparency = 1
		Hover.BorderSizePixel = 0
		Hover.Size = UDim2.fromScale(1, 1)
		Hover.ZIndex = 2
		Hover.Parent = ColorBtn

		local HoverCorner = Instance.new("UICorner")
		HoverCorner.CornerRadius = UDim.new(0, 4)
		HoverCorner.Parent = Hover

		ColorBtn.MouseEnter:Connect(function()
			Hover.BackgroundTransparency = 0.8
		end)
		ColorBtn.MouseLeave:Connect(function()
			Hover.BackgroundTransparency = 1
		end)

		ColorBtn.MouseButton1Click:Connect(function()
			setclipboard(ColorEntry.Color.R .. "," .. ColorEntry.Color.G .. "," .. ColorEntry.Color.B)
			Library:Notify({
				Title = "Color Copied",
				Description = string.format("%s: %.3f, %.3f, %.3f", ColorEntry.Name, ColorEntry.Color.R, ColorEntry.Color.G, ColorEntry.Color.B),
				Time = 2,
			})
			if self.PaletteCallback then
				self.PaletteCallback(ColorEntry.Color, ColorEntry.Name)
			end
		end)
	end

	Library:OnUnload(function()
		self:Destroy()
	end)

	return self
end

-- Watermark methods
function UIUtilities:SetWatermarkVisible(Visible: boolean)
	if self.Watermark then
		self.Watermark.Visible = Visible
	end
end

function UIUtilities:SetWatermarkTitle(Title: string)
	if self.Watermark and self.Watermark:FindFirstChildOfClass("TextLabel") then
		local Label = self.Watermark:FindFirstChildOfClass("TextLabel")
		Label.Text = Title
	end
end

function UIUtilities:SetWatermarkOption(Option: string, Value: boolean)
	if Option == "FPS" then
		self.WatermarkOptions.ShowFPS = Value
	elseif Option == "Ping" then
		self.WatermarkOptions.ShowPing = Value
	elseif Option == "Players" then
		self.WatermarkOptions.ShowPlayers = Value
	elseif Option == "Time" then
		self.WatermarkOptions.ShowTime = Value
	end
end

-- Notification Presets
function UIUtilities:Notify(Title: string, Description: string, Time: number?)
	self.Library:Notify({
		Title = Title,
		Description = Description,
		Time = Time or 5,
	})
end

function UIUtilities:NotifySuccess(Description: string, Title: string?, Time: number?)
	self.Library:Notify({
		Title = Title or "Success",
		Description = Description,
		Time = Time or 4,
	})
end

function UIUtilities:NotifyError(Description: string, Title: string?, Time: number?)
	self.Library:Notify({
		Title = Title or "Error",
		Description = Description,
		Time = Time or 6,
	})
end

function UIUtilities:NotifyInfo(Description: string, Title: string?, Time: number?)
	self.Library:Notify({
		Title = Title or "Info",
		Description = Description,
		Time = Time or 4,
	})
end

function UIUtilities:NotifyWarning(Description: string, Title: string?, Time: number?)
	self.Library:Notify({
		Title = Title or "Warning",
		Description = Description,
		Time = Time or 5,
	})
end

-- Color Palette methods
function UIUtilities:SetPaletteVisible(Visible: boolean)
	if self.ColorPaletteMenu then
		self.ColorPaletteMenu.Visible = Visible
	end
end

function UIUtilities:SetPaletteCallback(Callback: (Color3, string) -> ())
	self.PaletteCallback = Callback
end

function UIUtilities:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	local Index = table.find(self.Library.DraggableElements, self.Watermark)
	if Index then
		table.remove(self.Library.DraggableElements, Index)
	end
	local Index2 = table.find(self.Library.DraggableElements, self.ColorPaletteMenu)
	if Index2 then
		table.remove(self.Library.DraggableElements, Index2)
	end

	if self.Watermark then
		self.Watermark:Destroy()
	end
	if self.ColorPaletteMenu then
		self.ColorPaletteMenu:Destroy()
	end

	for i = #self.Connections, 1, -1 do
		local Connection = table.remove(self.Connections, i)
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
end

return UIUtilities
