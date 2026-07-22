--!strict
-- Cyan Radar addon: a 2D top-down minimap showing player positions, facing direction,
-- and configurable zoom/range with team colors and FOV overlay.

local Radar = {}
Radar.__index = Radar

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")

export type BlipStyle = "Dot" | "Arrow" | "Ring"
export type RadarPosition = "TopLeft" | "TopRight" | "BottomLeft" | "BottomRight" | "Custom"

export type RadarOptions = {
	Range: number?,
	Zoom: number?,
	Size: number?,
	Position: RadarPosition?,
	CustomPosition: UDim2?,
	BackgroundTransparency: number?,
	BackgroundColor: Color3?,
	BorderColor: Color3?,
	ShowLocalFOV: boolean?,
	FOVColor: Color3?,
	FOVTransparency: number?,
	FOVAngle: number?,
	BlipStyle: BlipStyle?,
	BlipSize: number?,
	ShowNames: boolean?,
	ShowGrid: boolean?,
	TeamColor: Color3?,
	EnemyColor: Color3?,
	LocalColor: Color3?,
	DotColor: Color3?,
	Visible: boolean?,
	UpdateInterval: number?,
}

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

local function GetCharacterCFrame(Character: Model): CFrame?
	local RootPart = Character:FindFirstChild("HumanoidRootPart")
		or Character:FindFirstChild("UpperTorso")
		or Character:FindFirstChild("Torso")
	if RootPart then
		return RootPart.CFrame
	end
	return nil
end

local function IsOnSameTeam(Target: Player): boolean
	local LocalPlayer = Players.LocalPlayer
	if not LocalPlayer then
		return false
	end
	return LocalPlayer.Team and Target.Team and LocalPlayer.Team == Target.Team
end

local function CreateRadarInstance(ClassName: string, Properties: { [string]: any }): Instance
	local Inst = Instance.new(ClassName)
	for Key, Value in Properties do
		Inst[Key] = Value
	end
	return Inst
end

function Radar.new(Library: any, Options: RadarOptions?)
	assert(typeof(Library) == "table", "Radar requires a Cyan Library instance")
	assert(typeof(Library.ScreenGui) == "Instance", "Radar requires Library.ScreenGui")

	local Config: RadarOptions = Options or {}
	local Size = Config.Size or 180
	local HalfSize = Size / 2

	local ScreenGui = Library.ScreenGui

	local Holder = CreateRadarInstance("Frame", {
		Name = "CyanRadar",
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(Size + 8, Size + 8),
		Position = UDim2.fromOffset(6, 6),
		ZIndex = 9000,
		Visible = Config.Visible ~= false,
		Parent = ScreenGui,
	})

	local function ApplyPosition(Position: RadarPosition)
		if Position == "TopRight" then
			Holder.AnchorPoint = Vector2.new(1, 0)
			Holder.Position = UDim2.new(1, -6, 0, 6)
		elseif Position == "BottomLeft" then
			Holder.AnchorPoint = Vector2.new(0, 1)
			Holder.Position = UDim2.new(0, 6, 1, -6)
		elseif Position == "BottomRight" then
			Holder.AnchorPoint = Vector2.new(1, 1)
			Holder.Position = UDim2.new(1, -6, 1, -6)
		elseif Position == "Custom" and Config.CustomPosition then
			Holder.AnchorPoint = Vector2.new(0, 0)
			Holder.Position = Config.CustomPosition
		else
			Holder.AnchorPoint = Vector2.new(0, 0)
			Holder.Position = UDim2.fromOffset(6, 6)
		end
	end

	ApplyPosition(Config.Position or "TopLeft")

	local BorderFrame = CreateRadarInstance("Frame", {
		BackgroundColor3 = Config.BackgroundColor or Library.Scheme.BackgroundColor,
		BackgroundTransparency = Config.BackgroundTransparency or 0.2,
		Size = UDim2.fromOffset(Size, Size),
		Position = UDim2.fromOffset(4, 4),
		ZIndex = 9001,
		Parent = Holder,
	})

	local BorderCorner = CreateRadarInstance("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = BorderFrame,
	})

	local BorderStroke = CreateRadarInstance("UIStroke", {
		Color = Config.BorderColor or Library.Scheme.OutlineColor,
		Thickness = 1.5,
		Parent = BorderFrame,
	})

	local ClipFrame = CreateRadarInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ClipsDescendants = true,
		ZIndex = 9002,
		Parent = BorderFrame,
	})

	local MaskCorner = CreateRadarInstance("UICorner", {
		CornerRadius = UDim.new(1, 0),
		Parent = ClipFrame,
	})

	local RadarCanvas = CreateRadarInstance("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Position = UDim2.fromScale(0, 0),
		ZIndex = 9003,
		Parent = ClipFrame,
	})

	local FOVCone = CreateRadarInstance("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxasset://textures/ui/WhiteCircle.png",
		ImageColor3 = Config.FOVColor or Library.Scheme.AccentColor,
		ImageTransparency = Config.FOVTransparency or 0.7,
		Size = UDim2.fromScale(2, 2),
		Position = UDim2.fromScale(-0.5, -0.5),
		Visible = Config.ShowLocalFOV ~= false,
		ZIndex = 9004,
		Parent = RadarCanvas,
	})

	local CrosshairV = CreateRadarInstance("Frame", {
		BackgroundColor3 = Config.BorderColor or Library.Scheme.OutlineColor,
		BackgroundTransparency = 0.5,
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromOffset(1, Size),
		ZIndex = 9005,
		Parent = RadarCanvas,
	})

	local CrosshairH = CreateRadarInstance("Frame", {
		BackgroundColor3 = Config.BorderColor or Library.Scheme.OutlineColor,
		BackgroundTransparency = 0.5,
		Position = UDim2.fromOffset(0, 0),
		Size = UDim2.fromOffset(Size, 1),
		ZIndex = 9005,
		Parent = RadarCanvas,
	})

	-- Grid rings
	local GridRings = {}
	if Config.ShowGrid ~= false then
		local RingDistances = { 0.25, 0.5, 0.75 }
		for _, Fraction in RingDistances do
			local Ring = CreateRadarInstance("Frame", {
				BackgroundTransparency = 1,
				Position = UDim2.fromScale(0.5 - Fraction / 2, 0.5 - Fraction / 2),
				Size = UDim2.fromScale(Fraction, Fraction),
				ZIndex = 9004,
				Parent = RadarCanvas,
			})
			local RingCorner = CreateRadarInstance("UICorner", {
				CornerRadius = UDim.new(1, 0),
				Parent = Ring,
			})
			local RingStroke = CreateRadarInstance("UIStroke", {
				Color = Config.BorderColor or Library.Scheme.OutlineColor,
				Thickness = 1,
				Transparency = 0.7,
				Parent = Ring,
			})
			GridRings[#GridRings + 1] = Ring
		end
	end

	local Self: any = setmetatable({
		Library = Library,
		Holder = Holder,
		BorderFrame = BorderFrame,
		ClipFrame = ClipFrame,
		RadarCanvas = RadarCanvas,
		FOVCone = FOVCone,
		CrosshairV = CrosshairV,
		CrosshairH = CrosshairH,
		GridRings = GridRings,
		Blips = {},
		BlipPool = {},
		NameLabels = {},
		Range = Config.Range or 150,
		Zoom = Config.Zoom or 1,
		Size = Size,
		HalfSize = HalfSize,
		BackgroundTransparency = Config.BackgroundTransparency or 0.2,
		BackgroundColor = Config.BackgroundColor or Library.Scheme.BackgroundColor,
		BorderColor = Config.BorderColor or Library.Scheme.OutlineColor,
		ShowLocalFOV = Config.ShowLocalFOV ~= false,
		FOVColor = Config.FOVColor or Library.Scheme.AccentColor,
		FOVTransparency = Config.FOVTransparency or 0.7,
		FOVAngle = Config.FOVAngle or 90,
		BlipStyle = Config.BlipStyle or "Arrow",
		BlipSize = Config.BlipSize or 4,
		ShowNames = Config.ShowNames or false,
		ShowGrid = Config.ShowGrid ~= false,
		TeamColor = Config.TeamColor or Color3.fromRGB(0, 255, 0),
		EnemyColor = Config.EnemyColor or Color3.fromRGB(255, 50, 50),
		LocalColor = Config.LocalColor or Color3.fromRGB(0, 150, 255),
		DotColor = Config.DotColor or Color3.fromRGB(255, 255, 255),
		Visible = Config.Visible ~= false,
		UpdateInterval = math.clamp(Config.UpdateInterval or 0.1, 0.03, 0.5),
		DisplayElapsed = 0,
		Connections = {},
		UpdateConnection = nil,
		Destroyed = false,
		PositionMode = Config.Position or "TopLeft",
		CustomPosition = Config.CustomPosition,
	}, Radar)

	local function CreateBlip(Player: Player): Frame
		local Blip = CreateRadarInstance("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0,
			Size = UDim2.fromOffset(Self.BlipSize * 2, Self.BlipSize * 2),
			Position = UDim2.fromScale(0.5, 0.5),
			ZIndex = 9010,
			Visible = false,
			Parent = RadarCanvas,
		})

		local BlipCorner = CreateRadarInstance("UICorner", {
			CornerRadius = UDim.new(1, 0),
			Parent = Blip,
		})

		local NameLabel = CreateRadarInstance("TextLabel", {
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			FontFace = Font.fromEnum(Enum.Font.Code),
			RichText = true,
			Text = Player.Name,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = 10,
			TextStrokeTransparency = 0.6,
			Size = UDim2.fromOffset(60, 14),
			Position = UDim2.fromOffset(Self.BlipSize * 2 + 2, -Self.BlipSize),
			ZIndex = 9011,
			Visible = Self.ShowNames,
			Parent = Blip,
		})

		local DirectionArrow = CreateRadarInstance("Frame", {
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			Size = UDim2.fromOffset(6, 2),
			Position = UDim2.fromOffset(-3, Self.BlipSize - 1),
			ZIndex = 9012,
			Visible = Self.BlipStyle == "Arrow",
			Parent = Blip,
		})

		local Entry: any = {
			Blip = Blip,
			DirectionArrow = DirectionArrow,
			NameLabel = NameLabel,
			Player = Player,
		}
		Self.Blips[Player] = Entry
		return Blip
	end

	local function GetBlip(Player: Player): Frame?
		local Entry = Self.Blips[Player]
		if Entry then
			return Entry.Blip
		end
		return nil
	end

	local function UpdateRadar()
		if Self.Destroyed or not Self.Visible then
			return
		end

		local LocalPlayer = Players.LocalPlayer
		if not LocalPlayer then
			return
		end

		local MyCharacter = LocalPlayer.Character
		if not MyCharacter then
			return
		end

		local MyPosition = GetCharacterPosition(MyCharacter)
		local MyCFrame = GetCharacterCFrame(MyCharacter)
		if not MyPosition or not MyCFrame then
			return
		end

		local EffectiveRange = Self.Range / Self.Zoom
		local Scale = Self.HalfSize / EffectiveRange
		local MyForward = -MyCFrame.LookVector
		local MyAngle = math.atan2(MyForward.X, MyForward.Z)

		if Self.ShowLocalFOV then
			Self.FOVCone.Visible = true
			Self.FOVCone.Rotation = math.deg(MyAngle) - 90 - Self.FOVAngle / 2
		else
			Self.FOVCone.Visible = false
		end

		local BlipSize = Self.BlipSize
		local BlipStyle = Self.BlipStyle

		local function UpdateBlip(Player: Player)
			local Character = Player.Character
			if not Character then
				return
			end

			if Player == LocalPlayer then
				return
			end

			local TargetPos = GetCharacterPosition(Character)
			if not TargetPos then
				return
			end

			local RelativePos = TargetPos - MyPosition
			local Distance = RelativePos.Magnitude

			if Distance > EffectiveRange then
				local BlipFrame = GetBlip(Player)
				if BlipFrame then
					BlipFrame.Visible = false
				end
				return
			end

			local RotatedX = RelativePos.X * math.cos(-MyAngle) - RelativePos.Z * math.sin(-MyAngle)
			local RotatedZ = RelativePos.X * math.sin(-MyAngle) + RelativePos.Z * math.cos(-MyAngle)

			local ScreenX = Self.HalfSize + RotatedX * Scale
			local ScreenY = Self.HalfSize - RotatedZ * Scale

			ScreenX = math.clamp(ScreenX, 2, Self.Size - 2)
			ScreenY = math.clamp(ScreenY, 2, Self.Size - 2)

			local BlipFrame = GetBlip(Player)
			if not BlipFrame then
				BlipFrame = CreateBlip(Player)
			end

			BlipFrame.Position = UDim2.fromOffset(ScreenX - BlipSize, ScreenY - BlipSize)
			BlipFrame.Size = UDim2.fromOffset(BlipSize * 2, BlipSize * 2)
			BlipFrame.Visible = true

			local IsTeam = IsOnSameTeam(Player)
			local BlipColor = if IsTeam then Self.TeamColor else Self.EnemyColor
			BlipFrame.BackgroundColor3 = BlipColor

			if BlipStyle == "Arrow" then
				local TargetCFrame = GetCharacterCFrame(Character)
				if TargetCFrame then
					local TargetForward = -TargetCFrame.LookVector
					local TargetAngle = math.deg(math.atan2(TargetForward.X, TargetForward.Z) - MyAngle)
					if BlipFrame.DirectionArrow and BlipFrame.DirectionArrow.Parent then
						BlipFrame.DirectionArrow.Visible = true
						BlipFrame.DirectionArrow.BackgroundColor3 = BlipColor
						BlipFrame.DirectionArrow.Rotation = -TargetAngle
					end
				end
			end

			if Self.ShowNames and BlipFrame.NameLabel then
				BlipFrame.NameLabel.Visible = true
			elseif BlipFrame.NameLabel then
				BlipFrame.NameLabel.Visible = false
			end
		end

		for _, Player in Players:GetPlayers() do
			if Player ~= LocalPlayer then
				UpdateBlip(Player)
			end
		end

		-- Local player indicator
		local LocalBlip = GetBlip(LocalPlayer)
		if not LocalBlip then
			local Blip = CreateBlip(LocalPlayer)
			LocalBlip = Blip
		end
		if LocalBlip then
			LocalBlip.Position = UDim2.fromOffset(Self.HalfSize - BlipSize + 1, Self.HalfSize - BlipSize + 1)
			LocalBlip.Size = UDim2.fromOffset(BlipSize * 2, BlipSize * 2)
			LocalBlip.BackgroundColor3 = Self.LocalColor
			LocalBlip.Visible = true
			if LocalBlip.DirectionArrow then
				LocalBlip.DirectionArrow.Visible = BlipStyle == "Arrow"
				LocalBlip.DirectionArrow.BackgroundColor3 = Self.LocalColor
				LocalBlip.DirectionArrow.Rotation = 0
			end
			if LocalBlip.NameLabel then
				LocalBlip.NameLabel.Visible = false
			end
		end

		-- Hide blips for disconnected players
		local ActivePlayers = {}
		for _, Player in Players:GetPlayers() do
			ActivePlayers[Player] = true
		end
		for Player, Entry in Self.Blips do
			if not ActivePlayers[Player] and Entry.Blip then
				Entry.Blip.Visible = false
			end
		end
	end

	-- Drag support
	local Dragging = false
	local DragStart: Vector2?
	local DragPos: UDim2?

	local function StartDrag(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1
			and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		Dragging = true
		DragStart = Input.Position
		DragPos = Holder.Position
	end

	local function EndDrag(Input: InputObject)
		if Input.UserInputType ~= Enum.UserInputType.MouseButton1
			and Input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		Dragging = false
	end

	local function DoDrag(Input: InputObject)
		if not Dragging or not DragStart or not DragPos then
			return
		end
		if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
			return
		end
		local Delta = Input.Position - DragStart
		Holder.AnchorPoint = Vector2.new(0, 0)
		Holder.Position = UDim2.fromOffset(DragPos.X.Offset + Delta.X, DragPos.Y.Offset + Delta.Y)
	end

	BorderFrame.InputBegan:Connect(StartDrag)
	BorderFrame.InputEnded:Connect(EndDrag)
	Self:_GiveConnection(UserInputService.InputChanged:Connect(DoDrag))

	function Self:_GiveConnection(Connection: RBXScriptConnection)
		table.insert(Self.Connections, Connection)
		return Connection
	end

	function Self:_StartUpdateLoop()
		if Self.UpdateConnection then
			return
		end
		Self.UpdateConnection = Self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
			if Self.Destroyed then
				return
			end
			Self.DisplayElapsed += DeltaTime
			if Self.DisplayElapsed < Self.UpdateInterval then
				return
			end
			Self.DisplayElapsed = 0
			UpdateRadar()
		end))
	end

	function Self:SetRange(Range: number)
		assert(typeof(Range) == "number" and Range > 0, "Radar range must be a positive number")
		Self.Range = Range
	end

	function Self:SetZoom(Zoom: number)
		assert(typeof(Zoom) == "number" and Zoom > 0, "Radar zoom must be a positive number")
		Self.Zoom = Zoom
	end

	function Self:SetVisible(Visible: boolean)
		Self.Visible = Visible
		Holder.Visible = Visible
		if not Visible then
			for _, Entry in Self.Blips do
				if Entry.Blip then
					Entry.Blip.Visible = false
				end
			end
		end
	end

	function Self:Toggle()
		Self:SetVisible(not Self.Visible)
	end

	function Self:SetPosition(Position: RadarPosition, CustomPosition: UDim2?)
		Self.PositionMode = Position
		Self.CustomPosition = CustomPosition
		ApplyPosition(Position)
	end

	function Self:SetBackgroundTransparency(Transparency: number)
		assert(typeof(Transparency) == "number", "Transparency must be a number")
		Self.BackgroundTransparency = math.clamp(Transparency, 0, 1)
		BorderFrame.BackgroundTransparency = Self.BackgroundTransparency
	end

	function Self:SetShowFOV(Enabled: boolean)
		Self.ShowLocalFOV = Enabled
		FOVCone.Visible = Enabled and Self.Visible
	end

	function Self:SetFOVAngle(Angle: number)
		Self.FOVAngle = math.clamp(Angle, 10, 360)
	end

	function Self:SetBlipStyle(Style: BlipStyle)
		Self.BlipStyle = Style
		for _, Entry in Self.Blips do
			if Entry.DirectionArrow then
				Entry.DirectionArrow.Visible = Style == "Arrow"
			end
		end
	end

	function Self:SetShowNames(Show: boolean)
		Self.ShowNames = Show
		for _, Entry in Self.Blips do
			if Entry.NameLabel then
				Entry.NameLabel.Visible = Show
			end
		end
	end

	function Self:SetBlipSize(Size: number)
		assert(typeof(Size) == "number" and Size > 0, "Blip size must be a positive number")
		Self.BlipSize = Size
	end

	function Self:SetTeamColor(Color: Color3)
		Self.TeamColor = Color
	end

	function Self:SetEnemyColor(Color: Color3)
		Self.EnemyColor = Color
	end

	function Self:Destroy()
		if Self.Destroyed then
			return
		end
		Self.Destroyed = true

		for _, Entry in Self.Blips do
			if Entry.Blip then
				Entry.Blip:Destroy()
			end
		end
		Self.Blips = {}

		for Index = #Self.Connections, 1, -1 do
			local Connection = table.remove(Self.Connections, Index)
			if Connection and Connection.Connected then
				Connection:Disconnect()
			end
		end
		Self.UpdateConnection = nil

		if Holder then
			Holder:Destroy()
		end
	end

	Self:_StartUpdateLoop()

	Library:OnUnload(function()
		Self:Destroy()
	end)

	return Self
end

return Radar
