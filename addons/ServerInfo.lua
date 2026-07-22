--!strict
-- Cyan ServerInfo addon: server stats panel, player info overlay, and session data display.

local ServerInfo = {}
ServerInfo.__index = ServerInfo

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local Stats: Stats = game:GetService("Stats")
local UserInputService: UserInputService = game:GetService("UserInputService")
local MarketplaceService: MarketplaceService = game:GetService("MarketplaceService")

export type ServerInfoOptions = {
	Visible: boolean?,
	Position: UDim2?,
	UpdateInterval: number?,
	ShowServerInfo: boolean?,
	ShowPlayerInfo: boolean?,
}

local function GetCharacterPosition(Character: Model): Vector3?
	local Root = Character:FindFirstChild("HumanoidRootPart")
		or Character:FindFirstChild("UpperTorso")
		or Character:FindFirstChild("Torso")
		or Character:FindFirstChild("Head")
	return Root and Root.Position or Character:GetPivot().Position
end

function ServerInfo.new(Library: any, Options: ServerInfoOptions?)
	assert(typeof(Library) == "table", "ServerInfo requires a Cyan Library instance")
	assert(typeof(Library.AddDraggableMenu) == "function", "ServerInfo requires Library:AddDraggableMenu")

	local Config: ServerInfoOptions = Options or {}
	local Holder, Container = Library:AddDraggableMenu("Server Info")
	if typeof(Config.Position) == "UDim2" then
		Holder.Position = Config.Position
	end
	Holder.Visible = Config.Visible ~= false

	local self: any = setmetatable({
		Library = Library,
		Holder = Holder,
		Container = Container,
		ShowServerInfo = Config.ShowServerInfo ~= false,
		ShowPlayerInfo = Config.ShowPlayerInfo ~= false,
		Visible = Config.Visible ~= false,
		UpdateInterval = math.clamp(Config.UpdateInterval or 0.3, 0.1, 2),
		DisplayElapsed = 0,
		Labels = {},
		PlayerDropdown = nil,
		SelectedPlayer = nil,
		SessionStart = os.time(),
		Connections = {},
		UpdateConnection = nil,
		Destroyed = false,
	}, ServerInfo)

	local TextStyle = {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		FontFace = Library.Scheme.Font,
		RichText = true,
		TextColor3 = Library.Scheme.FontColor,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
	}

	local function CreateLabel(Parent: Instance, Text: string, SizeY: number, Order: number): TextLabel
		local Label = Instance.new("TextLabel")
		Label.BackgroundTransparency = 1
		Label.BorderSizePixel = 0
		Label.FontFace = Library.Scheme.Font
		Label.RichText = true
		Label.TextColor3 = Library.Scheme.FontColor
		Label.TextSize = 13
		Label.TextXAlignment = Enum.TextXAlignment.Left
		Label.Text = Text
		Label.Size = UDim2.new(1, -10, 0, SizeY or 18)
		Label.LayoutOrder = Order or 0
		Label.Parent = Parent

		Library:AddToRegistry(Label, {
			FontFace = "Font",
			TextColor3 = "FontColor",
		})
		return Label
	end

	local function RefreshDisplay()
		for _, Label in self.Labels do
			if Label and Label.Parent then
				Label:Destroy()
			end
		end
		self.Labels = {}

		if not self.Visible then
			return
		end

		local Order = 0

		local function AddText(Text: string, Color: Color3?)
			Order += 1
			local L = CreateLabel(Container, Text, 18, Order)
			if Color then
				L.TextColor3 = Color
			end
			table.insert(self.Labels, L)
		end

		if self.ShowServerInfo then
			AddText("<b>Server</b>", Library.Scheme.AccentColor)
			AddText(string.format("  Game: %s", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name or "Unknown"))
			local PingStats = Stats.Network.ServerStatsItem
			local Ping = ""
			pcall(function()
				Ping = PingStats["Data Ping"]:GetValueString()
			end)
			AddText(string.format("  Ping: %s", Ping ~= "" and Ping or "N/A"))

			local PlayerCount = #Players:GetPlayers()
			local MaxPlayers = Players.MaxPlayers
			AddText(string.format("  Players: %d / %d", PlayerCount, MaxPlayers))

			local PlaceIdStr = tostring(game.PlaceId)
			AddText(string.format("  Place ID: %s", PlaceIdStr))

			local JobId = game.JobId
			if #JobId > 16 then
				JobId = JobId:sub(1, 16) .. "..."
			end
			AddText(string.format("  Job ID: %s", JobId))

			local Elapsed = os.difftime(os.time(), self.SessionStart)
			local Hours = math.floor(Elapsed / 3600)
			local Minutes = math.floor((Elapsed % 3600) / 60)
			local Seconds = math.floor(Elapsed % 60)
			AddText(string.format("  Session: %02d:%02d:%02d", Hours, Minutes, Seconds))
			AddText("") -- spacer
		end

		if self.ShowPlayerInfo and self.SelectedPlayer then
			local Player = self.SelectedPlayer
			if Player and Player.Parent then
				AddText("<b>Player Info</b>", Library.Scheme.AccentColor)
				AddText(string.format("  Name: %s", Player.Name))
				AddText(string.format("  Display: %s", Player.DisplayName))
				AddText(string.format("  User ID: %d", Player.UserId))

				local Team = Player.Team
				AddText(string.format("  Team: %s", Team and Team.Name or "None"))

				local Character = Player.Character
				if Character then
					local Humanoid = Character:FindFirstChildOfClass("Humanoid")
					if Humanoid then
						AddText(string.format("  Health: %.0f / %.0f", Humanoid.Health, Humanoid.MaxHealth))
					end

					local Position = GetCharacterPosition(Character)
					if Position then
						AddText(string.format("  Position: %.0f, %.0f, %.0f", Position.X, Position.Y, Position.Z))
						local LocalPlayer = Players.LocalPlayer
						local MyChar = LocalPlayer and LocalPlayer.Character
						if MyChar then
							local MyPos = GetCharacterPosition(MyChar)
							if MyPos then
								local Dist = (Position - MyPos).Magnitude
								AddText(string.format("  Distance: %.0f studs", Dist))
							end
						end
					end
				else
					AddText("  [Character not loaded]")
				end
			else
				AddText("<b>Player Info</b>", Library.Scheme.AccentColor)
				AddText("  [Player left]")
				self.SelectedPlayer = nil
			end
		end
	end

	function Self:SetVisible(Visible: boolean)
		self.Visible = Visible
		Holder.Visible = Visible
		if not Visible then
			for _, Label in self.Labels do
				if Label and Label.Parent then
					Label:Destroy()
				end
			end
			self.Labels = {}
		end
	end

	function Self:Toggle()
		self:SetVisible(not self.Visible)
	end

	function Self:SelectPlayer(Player: Player?)
		self.SelectedPlayer = Player
	end

	function Self:GetPlayerList(): { Player }
		return Players:GetPlayers()
	end

	if self.ShowPlayerInfo then
		local DropdownLabel = CreateLabel(Container, "Click a player below:", 18, 0)
		table.insert(self.Labels, DropdownLabel)

		for _, Player in Players:GetPlayers() do
			local PlayerButton = Instance.new("TextButton")
			PlayerButton.BackgroundColor3 = Library.Scheme.MainColor
			PlayerButton.BorderSizePixel = 0
			PlayerButton.FontFace = Library.Scheme.Font
			PlayerButton.RichText = true
			PlayerButton.TextColor3 = Library.Scheme.FontColor
			PlayerButton.TextSize = 13
			PlayerButton.TextXAlignment = Enum.TextXAlignment.Left
			PlayerButton.Text = string.format("  %s", Player.Name)
			PlayerButton.Size = UDim2.new(1, -10, 0, 20)
			PlayerButton.LayoutOrder = 100 + (Player.UserId % 1000)
			PlayerButton.Parent = Container

			Library:AddToRegistry(PlayerButton, {
				BackgroundColor3 = "MainColor",
				FontFace = "Font",
				TextColor3 = "FontColor",
			})

			local Corner = Instance.new("UICorner")
			Corner.CornerRadius = UDim.new(0, Library.CornerRadius / 2)
			Corner.Parent = PlayerButton

			table.insert(self.Labels, PlayerButton)

			local TeamColor = Player.Team and Player.Team.TeamColor.Color
			local PingLabel = Instance.new("TextLabel")
			PingLabel.BackgroundTransparency = 1
			PingLabel.FontFace = Library.Scheme.Font
			PingLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
			PingLabel.TextSize = 11
			PingLabel.TextXAlignment = Enum.TextXAlignment.Right
			PingLabel.Text = ""
			PingLabel.Size = UDim2.new(0.4, -4, 1, 0)
			PingLabel.Position = UDim2.new(0.6, 0, 0, 0)
			PingLabel.Parent = PlayerButton

			PlayerButton.MouseButton1Click:Connect(function()
				self:SelectPlayer(Player)
			end)

			RunService.Heartbeat:Connect(function()
				if PlayerButton and PlayerButton.Parent then
					local PingStats = Stats.Network.ServerStatsItem
					local Ping = ""
					pcall(function()
						Ping = PingStats["Data Ping"]:GetValueString()
					end)
					PingLabel.Text = Ping ~= "" and Ping or ""
				end
			end)
		end
	end

	self._RefreshConnection = RunService.Heartbeat:Connect(function()
		if self.Destroyed then
			return
		end
		self.DisplayElapsed += RunService.Heartbeat:Wait()
		if self.DisplayElapsed < self.UpdateInterval then
			return
		end
		self.DisplayElapsed = 0
		RefreshDisplay()
	end)
	table.insert(self.Connections, self._RefreshConnection)

	Library:OnUnload(function()
		self:Destroy()
	end)

	return self
end

function ServerInfo:SetShowServerInfo(Show: boolean)
	self.ShowServerInfo = Show
end

function ServerInfo:SetShowPlayerInfo(Show: boolean)
	self.ShowPlayerInfo = Show
end

function ServerInfo:SetUpdateInterval(Seconds: number)
	self.UpdateInterval = math.clamp(Seconds, 0.1, 2)
end

function ServerInfo:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	for _, Label in self.Labels do
		if Label and Label.Parent then
			Label:Destroy()
		end
	end
	self.Labels = {}

	local Index = table.find(Library.DraggableElements, self.Holder)
	if Index then
		table.remove(Library.DraggableElements, Index)
	end

	if self.Holder then
		self.Holder:Destroy()
	end

	for i = #self.Connections, 1, -1 do
		local Connection = table.remove(self.Connections, i)
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
	self._RefreshConnection = nil
end

return ServerInfo
