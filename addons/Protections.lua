--!strict
-- Cyan Protections addon: Anti-kick, anti-crash, anti-idle, anti-lag, and anti-detection tools.

local Protections = {}
Protections.__index = Protections

local RunService: RunService = game:GetService("RunService")
local Players: Players = game:GetService("Players")
local UserInputService: UserInputService = game:GetService("UserInputService")
local TeleportService: TeleportService = game:GetService("TeleportService")
local CoreGui: CoreGui = game:GetService("CoreGui")
local Stats: Stats = game:GetService("Stats")

export type ProtectionOptions = {
	AntiKick: boolean?,
	AntiKickRejoin: boolean?,
	AntiCrash: boolean?,
	AntiCrashFilterParts: boolean?,
	AntiCrashFilterSounds: boolean?,
	AntiCrashFilterMeshes: boolean?,
	AntiCrashFilterParticles: boolean?,
	AntiIdle: boolean?,
	AntiIdleInterval: number?,
	AntiLag: boolean?,
	AntiLagGraphicsLevel: number?,
	AntiLagDisableShadows: boolean?,
	AntiLagDisableEffects: boolean?,
}

local function IsAlive(Player: Player): boolean
	local Character = Player and Player.Character
	if not Character then
		return false
	end
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	return Humanoid ~= nil and Humanoid.Health > 0
end

function Protections.new(Library: any, Options: ProtectionOptions?)
	assert(typeof(Library) == "table", "Protections requires a Cyan Library instance")

	local self: any = setmetatable({
		Library = Library,
		AntiKick = false,
		AntiKickRejoin = false,
		KickedByServer = false,
		KickMessage = "",
		AntiCrash = false,
		AntiCrashFilterParts = true,
		AntiCrashFilterSounds = true,
		AntiCrashFilterMeshes = true,
		AntiCrashFilterParticles = true,
		AntiIdle = false,
		AntiIdleInterval = 30,
		AntiLag = false,
		AntiLagGraphicsLevel = 1,
		AntiLagDisableShadows = true,
		AntiLagDisableEffects = true,
		SavedGraphicsLevel = nil,
		SavedShadows = nil,
		Connections = {},
		AntiIdleConnection = nil,
		AntiCrashConnection = nil,
		Destroyed = false,
	}, Protections)

	if Options then
		if Options.AntiKick then self:SetAntiKick(true, Options.AntiKickRejoin) end
		if Options.AntiCrash then self:SetAntiCrash(true) end
		if Options.AntiIdle then self:SetAntiIdle(true, Options.AntiIdleInterval) end
		if Options.AntiLag then self:SetAntiLag(true) end
	end

	Library:OnUnload(function()
		self:Destroy()
	end)

	return self
end

function Protections:_GiveConnection(Connection: RBXScriptConnection)
	table.insert(self.Connections, Connection)
	return Connection
end

-- Anti-Kick

function Protections:SetAntiKick(Enabled: boolean, Rejoin: boolean?)
	self.AntiKick = Enabled
	if Rejoin ~= nil then
		self.AntiKickRejoin = Rejoin
	end

	if Enabled then
		local LocalPlayer = Players.LocalPlayer
		if LocalPlayer then
			local Success, Connection = pcall(function()
				return LocalPlayer.OnTeleport:Connect(function(State, Message)
					if State == Enum.TeleportState.Failed and self.AntiKick then
						self.KickedByServer = true
						self.KickMessage = tostring(Message)
						if self.AntiKickRejoin then
							self:_RejoinGame()
						end
					end
				end)
			end)
			if Success then
				self._AntiKickConnection = Connection
				self:_GiveConnection(Connection)
			end
		end

		-- Block the Kick function by wrapping it
		local Success, Hooked = pcall(function()
			local OldKick = Players.LocalPlayer.Kick
			if OldKick then
				local Player = Players.LocalPlayer
				Player.Kick = function(...)
					if self.AntiKick then
						self.KickedByServer = true
						self.KickMessage = "Kick blocked by Cyan protections."
						if self.AntiKickRejoin then
							self:_RejoinGame()
						end
						return
					end
					return OldKick(...)
				end
			end
		end)
	else
		if self._AntiKickConnection then
			self._AntiKickConnection:Disconnect()
			self._AntiKickConnection = nil
		end
	end
end

function Protections:_RejoinGame()
	local PlaceId = game.PlaceId
	local JobId = game.JobId

	task.spawn(function()
		task.wait(1)
		local Success, Error = pcall(function()
			TeleportService:TeleportToPlaceInstance(PlaceId, JobId, Players.LocalPlayer)
		end)
		if not Success then
			warn("Cyan: Rejoin failed:", tostring(Error))
		end
	end)
end

-- Anti-Crash

function Protections:SetAntiCrash(Enabled: boolean, FilterParts: boolean?, FilterSounds: boolean?, FilterMeshes: boolean?, FilterParticles: boolean?)
	self.AntiCrash = Enabled
	if FilterParts ~= nil then self.AntiCrashFilterParts = FilterParts end
	if FilterSounds ~= nil then self.AntiCrashFilterSounds = FilterSounds end
	if FilterMeshes ~= nil then self.AntiCrashFilterMeshes = FilterMeshes end
	if FilterParticles ~= nil then self.AntiCrashFilterParticles = FilterParticles end

	if Enabled then
		if self.AntiCrashConnection then
			return
		end

		self.AntiCrashConnection = self:_GiveConnection(workspace.DescendantAdded:Connect(function(Descendant)
			if not self.AntiCrash then
				return
			end

			task.spawn(function()
				task.wait(0.1)
				if not Descendant or not Descendant.Parent then
					return
				end

				local ShouldRemove = false

				if self.AntiCrashFilterParts and Descendant:IsA("Part") or Descendant:IsA("UnionOperation") then
					local Size = Descendant.Size
					local Volume = Size.X * Size.Y * Size.Z
					if Volume > 100000 then
						ShouldRemove = true
					end
					if Descendant:IsA("Part") and Descendant.Shape == Enum.PartType.Ball and Descendant.Size.X > 500 then
						ShouldRemove = true
					end
				end

				if self.AntiCrashFilterSounds and Descendant:IsA("Sound") then
					if Descendant.Playing then
						Descendant:Stop()
					end
					Descendant.Volume = 0
					Descendant.PlayOnRemove = false
					task.delay(5, function()
						if Descendant and Descendant.Parent then
							Descendant:Destroy()
						end
					end)
				end

				if self.AntiCrashFilterMeshes and (Descendant:IsA("MeshPart") or Descendant:IsA("SpecialMesh")) then
					local Size = Descendant:IsA("MeshPart") and Descendant.Size or (Descendant:IsA("SpecialMesh") and Descendant.Scale or Vector3.new(1, 1, 1))
					local Volume = Size.X * Size.Y * Size.Z
					if Volume > 50000 then
						ShouldRemove = true
					end
				end

				if self.AntiCrashFilterParticles and (Descendant:IsA("ParticleEmitter") or Descendant:IsA("Beam") or Descendant:IsA("Smoke") or Descendant:IsA("Fire")) then
					ShouldRemove = true
				end

				if ShouldRemove and Descendant.Parent then
					Descendant:Destroy()
				end
			end)
		end))

		self:_GiveConnection(workspace.DescendantRemoving:Connect(function(Descendant)
			if not self.AntiCrash then
				return
			end
			if Descendant:IsA("BasePart") and Descendant:IsA("Part") then
				local PartCount = 0
				for _, Part in ipairs(workspace:GetDescendants()) do
					if Part:IsA("Part") or Part:IsA("UnionOperation") or Part:IsA("MeshPart") then
						PartCount += 1
						if PartCount > 5000 then
							break
						end
					end
				end
				if PartCount > 5000 then
					local Parts = workspace:GetDescendants()
					local RemovedCount = 0
					for _, Part in ipairs(Parts) do
						if (Part:IsA("Part") or Part:IsA("UnionOperation") or Part:IsA("MeshPart"))
							and (not Part.Anchored or Part.Size.Magnitude < 2) then
							Part:Destroy()
							RemovedCount += 1
							if RemovedCount >= 2000 then
								break
							end
						end
					end
				end
			end
		end))
	else
		if self.AntiCrashConnection then
			self.AntiCrashConnection:Disconnect()
			self.AntiCrashConnection = nil
		end
	end
end

-- Anti-Idle

function Protections:SetAntiIdle(Enabled: boolean, Interval: number?)
	self.AntiIdle = Enabled
	if Interval then
		self.AntiIdleInterval = math.max(10, Interval)
	end

	if Enabled then
		if self.AntiIdleConnection then
			return
		end

		self.AntiIdleConnection = self:_GiveConnection(RunService.Heartbeat:Connect(function()
			if not self.AntiIdle then
				return
			end

			local LocalPlayer = Players.LocalPlayer
			if not LocalPlayer then
				return
			end

			local Character = LocalPlayer.Character
			if not Character then
				return
			end

			local Humanoid = Character:FindFirstChildOfClass("Humanoid")
			local RootPart = Character:FindFirstChild("HumanoidRootPart")
				or Character:FindFirstChild("UpperTorso")

			if Humanoid and RootPart and Humanoid.Health > 0 then
				local CurrentTime = tick()
				if not self._LastAntiIdleTime then
					self._LastAntiIdleTime = CurrentTime
				end

				if CurrentTime - self._LastAntiIdleTime >= self.AntiIdleInterval then
					self._LastAntiIdleTime = CurrentTime
					RootPart.Velocity = RootPart.Velocity + Vector3.new(0, 0.1, 0)
				end
			end
		end))
	else
		if self.AntiIdleConnection then
			self.AntiIdleConnection:Disconnect()
			self.AntiIdleConnection = nil
		end
		self._LastAntiIdleTime = nil
	end
end

-- Anti-Lag

function Protections:SetAntiLag(Enabled: boolean, GraphicsLevel: number?)
	self.AntiLag = Enabled
	if GraphicsLevel then
		self.AntiLagGraphicsLevel = math.clamp(GraphicsLevel, 1, 10)
	end

	if Enabled then
		local Success, Settings = pcall(function()
			return UserInputService:GetUserGameSettings()
		end)
		if Success and Settings then
			if self.SavedGraphicsLevel == nil then
				self.SavedGraphicsLevel = Settings.SavedQualityLevel
			end
			if self.SavedShadows == nil then
				self.SavedShadows = Settings.GlobalShadows
			end

			Settings.SavedQualityLevel = self.AntiLagGraphicsLevel
			if self.AntiLagDisableShadows then
				Settings.GlobalShadows = false
			end
		end

		if self.AntiLagDisableEffects then
			local function DisableEffects(Instance: Instance)
				for _, Child in Instance:GetDescendants() do
					if Child:IsA("ParticleEmitter") or Child:IsA("Smoke") or Child:IsA("Fire") or Child:IsA("Sparkles") then
						Child.Enabled = false
					end
					if Child:IsA("BloomEffect") or Child:IsA("BlurEffect") or Child:IsA("SunRaysEffect")
						or Child:IsA("ColorCorrectionEffect") or Child:IsA("DepthOfFieldEffect") then
						Child.Enabled = false
					end
				end
			end
			DisableEffects(game:GetService("Lighting"))
			DisableEffects(workspace)
		end
	else
		local Success, Settings = pcall(function()
			return UserInputService:GetUserGameSettings()
		end)
		if Success and Settings then
			if self.SavedGraphicsLevel then
				Settings.SavedQualityLevel = self.SavedGraphicsLevel
				self.SavedGraphicsLevel = nil
			end
			if self.SavedShadows ~= nil then
				Settings.GlobalShadows = self.SavedShadows
				self.SavedShadows = nil
			end
		end

		if self.AntiLagDisableEffects then
			local function EnableEffects(Instance: Instance)
				for _, Child in Instance:GetDescendants() do
					if Child:IsA("BloomEffect") or Child:IsA("BlurEffect") or Child:IsA("SunRaysEffect")
						or Child:IsA("ColorCorrectionEffect") or Child:IsA("DepthOfFieldEffect") then
						Child.Enabled = true
					end
				end
			end
			EnableEffects(game:GetService("Lighting"))
		end
	end
end

function Protections:SetAntiLagGraphicsLevel(Level: number)
	self.AntiLagGraphicsLevel = math.clamp(Level, 1, 10)
	if self.AntiLag then
		self:SetAntiLag(true)
	end
end

-- Chat monitor
function Protections:GetChatLog(): { { Player: string, Message: string, Time: number } }
	return self.ChatLog or {}
end

-- Status

function Protections:GetStatus(): { [string]: boolean }
	return {
		AntiKick = self.AntiKick,
		AntiCrash = self.AntiCrash,
		AntiIdle = self.AntiIdle,
		AntiLag = self.AntiLag,
	}
end

function Protections:DisableAll()
	self:SetAntiKick(false)
	self:SetAntiCrash(false)
	self:SetAntiIdle(false)
	self:SetAntiLag(false)
end

function Protections:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	self:DisableAll()

	for Index = #self.Connections, 1, -1 do
		local Connection = table.remove(self.Connections, Index)
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
	self.AntiCrashConnection = nil
	self.AntiIdleConnection = nil
	self._AntiKickConnection = nil
end

return Protections
