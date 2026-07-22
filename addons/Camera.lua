--!strict
-- Cyan Camera addon: Third-person, FOV changer, view locking, camera spin, and freecam.

local CameraMan = {}
CameraMan.__index = CameraMan

local RunService: RunService = game:GetService("RunService")
local UserInputService: UserInputService = game:GetService("UserInputService")
local Players: Players = game:GetService("Players")
local TweenService: TweenService = game:GetService("TweenService")

export type CameraOptions = {
	ThirdPerson: boolean?,
	ThirdPersonDistance: number?,
	ThirdPersonSmoothness: number?,
	FOV: number?,
	FOVEnabled: boolean?,
	ViewLock: boolean?,
	ViewLockCFrame: CFrame?,
	Spin: boolean?,
	SpinSpeed: number?,
	Freecam: boolean?,
	FreecamSpeed: number?,
}

local function GetCharacter(Player: Player): Model?
	return Player and Player.Character
end

local function GetRootPart(Player: Player): BasePart?
	local Character = GetCharacter(Player)
	if not Character then
		return nil
	end
	return Character:FindFirstChild("HumanoidRootPart")
		or Character:FindFirstChild("UpperTorso")
		or Character:FindFirstChild("Torso")
end

local function IsLocalPlayer(Player: Player): boolean
	return Player == Players.LocalPlayer
end

function CameraMan.new(Library: any, Options: CameraOptions?)
	assert(typeof(Library) == "table", "Camera requires a Cyan Library instance")

	local self: any = setmetatable({
		Library = Library,
		ThirdPerson = false,
		ThirdPersonDistance = Options and Options.ThirdPersonDistance or 8,
		ThirdPersonSmoothness = Options and Options.ThirdPersonSmoothness or 0.15,
		FOV = Options and Options.FOV or 80,
		FOVEnabled = false,
		ViewLock = false,
		ViewLockCFrame = Options and Options.ViewLockCFrame or CFrame.identity,
		Spin = false,
		SpinSpeed = Options and Options.SpinSpeed or 30,
		Freecam = false,
		FreecamSpeed = Options and Options.FreecamSpeed or 50,
		SavedFOV = nil,
		SavedCameraType = nil,
		SavedCameraSubject = nil,
		SavedCFrame = nil,
		SavedFocus = nil,
		FreecamCFrame = CFrame.new(0, 10, 0),
		FreecamYaw = 0,
		FreecamPitch = 0,
		SpinAngle = 0,
		MouseSensitivity = 0.3,
		Connections = {},
		RenderConnection = nil,
		Destroyed = false,
	}, CameraMan)

	if Options then
		if Options.ThirdPerson then
			self:SetThirdPerson(true, Options.ThirdPersonDistance)
		end
		if Options.FOVEnabled and Options.FOV then
			self:SetFOV(Options.FOV, true)
		end
		if Options.Freecam then
			self:SetFreecam(true)
		end
		if Options.Spin then
			self:SetSpin(true, Options.SpinSpeed)
		end
		if Options.ViewLock then
			self:SetViewLock(true, Options.ViewLockCFrame)
		end
	end

	Library:OnUnload(function()
		self:Destroy()
	end)

	return self
end

function CameraMan:_GiveConnection(Connection: RBXScriptConnection)
	table.insert(self.Connections, Connection)
	return Connection
end

function CameraMan:_StartRender()
	if self.RenderConnection then
		return
	end

	self.RenderConnection = self:_GiveConnection(RunService.RenderStepped:Connect(function(DeltaTime)
		if self.Destroyed then
			return
		end

		local Camera = workspace.CurrentCamera
		if not Camera then
			return
		end

		local Player = Players.LocalPlayer
		local Character = GetCharacter(Player)
		local RootPart = GetRootPart(Player)

		if self.Freecam then
			self:_UpdateFreecam(Camera, DeltaTime)
			return
		end

		if self.ThirdPerson and RootPart then
			self:_UpdateThirdPerson(Camera, RootPart, DeltaTime)
		end

		if self.Spin and RootPart then
			self:_UpdateSpin(Camera, RootPart, DeltaTime)
		end

		if self.ViewLock then
			self:_UpdateViewLock(Camera, RootPart)
		end

		if self.FOVEnabled and self.FOV then
			Camera.FieldOfView = self.FOV
		elseif self.SavedFOV and not self.FOVEnabled then
			Camera.FieldOfView = self.SavedFOV
			self.SavedFOV = nil
		end

		if not self.ThirdPerson and not self.Freecam and not self.Spin and not self.ViewLock then
			if self.SavedCameraType then
				Camera.CameraType = self.SavedCameraType
				self.SavedCameraType = nil
			end
			if self.SavedCameraSubject then
				Camera.CameraSubject = self.SavedCameraSubject
				self.SavedCameraSubject = nil
			end
		end
	end))
end

function CameraMan:_SaveCameraState(Camera: Camera)
	if not self.SavedCameraType then
		self.SavedCameraType = Camera.CameraType
	end
	if not self.SavedCameraSubject then
		self.SavedCameraSubject = Camera.CameraSubject
	end
end

function CameraMan:_UpdateThirdPerson(Camera: Camera, RootPart: BasePart, DeltaTime: number)
	self:_SaveCameraState(Camera)
	Camera.CameraType = Enum.CameraType.Scriptable

	local CameraCFrame = Camera.CFrame
	local RootCFrame = RootPart.CFrame
	local Offset = RootCFrame.Position - CameraCFrame.Position
	local Distance = Offset.Magnitude
	local Direction = Offset.Unit

	local TargetDistance = self.ThirdPersonDistance
	local CurrentDistance = Distance

	local SmoothDistance = CurrentDistance + (TargetDistance - CurrentDistance) * math.min(1, DeltaTime / (self.ThirdPersonSmoothness or 0.15))
	local NewPosition = RootCFrame.Position - Direction * SmoothDistance

	local RaycastParams = RaycastParams.new()
	RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	RaycastParams.FilterDescendantsInstances = { RootPart.Parent, Camera }

	local Result = workspace:Raycast(RootCFrame.Position, -Direction * SmoothDistance, RaycastParams)
	local FinalDistance = SmoothDistance
	if Result then
		FinalDistance = math.min(SmoothDistance, (Result.Position - RootCFrame.Position).Magnitude - 0.5)
		NewPosition = RootCFrame.Position - Direction * FinalDistance
	end

	Camera.CFrame = CFrame.new(NewPosition, RootCFrame.Position)
	Camera.Focus = CFrame.new(RootCFrame.Position)
end

function CameraMan:_UpdateFreecam(Camera: Camera, DeltaTime: number)
	self:_SaveCameraState(Camera)
	Camera.CameraType = Enum.CameraType.Scriptable

	local Speed = self.FreecamSpeed * (UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and 3 or 1)
	local Forward = self.FreecamCFrame.LookVector
	local Right = self.FreecamCFrame.RightVector
	local Up = Vector3.new(0, 1, 0)
	local MoveVector = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		MoveVector += Forward
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		MoveVector -= Forward
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		MoveVector -= Right
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		MoveVector += Right
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.E) then
		MoveVector += Up
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
		MoveVector -= Up
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		MoveVector += Up
	end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
		MoveVector -= Up
	end

	if MoveVector.Magnitude > 0 then
		MoveVector = MoveVector.Unit * Speed * DeltaTime
		self.FreecamCFrame += MoveVector
	end

	if not UserInputService:GetFocusedTextBox() then
		local MouseDelta = UserInputService:GetMouseDelta()
		self.FreecamYaw -= MouseDelta.X * self.MouseSensitivity * DeltaTime * 60
		self.FreecamPitch = math.clamp(self.FreecamPitch - MouseDelta.Y * self.MouseSensitivity * DeltaTime * 60, -85, 85)
	end

	self.FreecamCFrame = CFrame.new(self.FreecamCFrame.Position) * CFrame.Angles(0, math.rad(self.FreecamYaw), 0) * CFrame.Angles(math.rad(self.FreecamPitch), 0, 0)

	Camera.CFrame = self.FreecamCFrame
	Camera.Focus = CFrame.new(self.FreecamCFrame.Position + self.FreecamCFrame.LookVector * 100)
end

function CameraMan:_UpdateSpin(Camera: Camera, RootPart: BasePart, DeltaTime: number)
	if not self.ThirdPerson then
		self:_SaveCameraState(Camera)
		Camera.CameraType = Enum.CameraType.Scriptable
	end

	self.SpinAngle = (self.SpinAngle + self.SpinSpeed * DeltaTime) % 360
	local RadAngle = math.rad(self.SpinAngle)
	local Offset = Vector3.new(math.sin(RadAngle) * self.ThirdPersonDistance, 2, math.cos(RadAngle) * self.ThirdPersonDistance)
	local Position = RootPart.Position + Offset

	local RaycastParams = RaycastParams.new()
	RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
	RaycastParams.FilterDescendantsInstances = { RootPart.Parent, workspace.CurrentCamera }
	local Result = workspace:Raycast(RootPart.Position, Offset, RaycastParams)
	if Result then
		Position = Result.Position - (Result.Position - RootPart.Position).Unit * 0.5
	end

	Camera.CFrame = CFrame.new(Position, RootPart.Position)
	Camera.Focus = CFrame.new(RootPart.Position)
end

function CameraMan:_UpdateViewLock(Camera: Camera, RootPart: BasePart?)
	self:_SaveCameraState(Camera)

	if self.ViewLockCFrame then
		local LookAt = self.ViewLockCFrame.Position

		if self.ThirdPerson and RootPart then
			local Direction = (LookAt - Camera.CFrame.Position).Unit
			local NewPosition = RootPart.Position - Direction * self.ThirdPersonDistance
			Camera.CFrame = CFrame.new(NewPosition, LookAt)
		else
			if RootPart then
				local CurrentPos = RootPart.Position
				Camera.CFrame = CFrame.new(CurrentPos, LookAt)
				Camera.CFrame += Vector3.new(0, 2, 0)
			else
				local CameraPos = Camera.CFrame.Position
				Camera.CFrame = CFrame.new(CameraPos, LookAt)
			end
		end
		Camera.Focus = CFrame.new(LookAt)
	end
end

function CameraMan:SetThirdPerson(Enabled: boolean, Distance: number?)
	self.ThirdPerson = Enabled
	if Distance then
		self.ThirdPersonDistance = math.clamp(Distance, 1, 100)
	end

	if Enabled then
		if self.Freecam then
			self:SetFreecam(false)
		end
		self:_StartRender()
	elseif not self.Freecam and not self.Spin and not self.ViewLock then
		local Camera = workspace.CurrentCamera
		if Camera then
			if self.SavedCameraType then
				Camera.CameraType = self.SavedCameraType
				self.SavedCameraType = nil
			end
			if self.SavedCameraSubject then
				Camera.CameraSubject = self.SavedCameraSubject
				self.SavedCameraSubject = nil
			end
		end
	end
end

function CameraMan:SetFOV(FOV: number, Enabled: boolean?)
	self.FOV = math.clamp(FOV, 1, 180)
	if Enabled ~= nil then
		self.FOVEnabled = Enabled
	else
		self.FOVEnabled = true
	end

	if self.FOVEnabled then
		self:_StartRender()
	end
end

function CameraMan:ResetFOV()
	self.FOVEnabled = false
	local Camera = workspace.CurrentCamera
	if Camera then
		Camera.FieldOfView = self.SavedFOV or 80
	end
end

function CameraMan:SetViewLock(Enabled: boolean, Target: CFrame?)
	self.ViewLock = Enabled
	if Target then
		self.ViewLockCFrame = Target
	end

	if Enabled then
		if self.Freecam then
			self:SetFreecam(false)
		end
		self:_StartRender()
	elseif not self.ThirdPerson and not self.Freecam and not self.Spin then
		local Camera = workspace.CurrentCamera
		if Camera and self.SavedCameraType then
			Camera.CameraType = self.SavedCameraType
			self.SavedCameraType = nil
		end
	end
end

function CameraMan:SetSpin(Enabled: boolean, Speed: number?)
	self.Spin = Enabled
	if Speed then
		self.SpinSpeed = Speed
	end

	if Enabled then
		self._StartRender()
	elseif not self.ThirdPerson and not self.Freecam and not self.ViewLock then
		local Camera = workspace.CurrentCamera
		if Camera and self.SavedCameraType then
			Camera.CameraType = self.SavedCameraType
			self.SavedCameraType = nil
		end
	end
end

function CameraMan:SetFreecam(Enabled: boolean)
	if Enabled == self.Freecam then
		return
	end

	self.Freecam = Enabled

	if Enabled then
		if self.ThirdPerson then
			self:SetThirdPerson(false)
		end
		if self.Spin then
			self:SetSpin(false)
		end

		local Camera = workspace.CurrentCamera
		if Camera then
			self.FreecamCFrame = Camera.CFrame
			local _, Yaw, Pitch = Camera.CFrame:ToOrientation()
			self.FreecamYaw = math.deg(Yaw)
			self.FreecamPitch = math.deg(Pitch)
		end
		self:_StartRender()
	else
		local Camera = workspace.CurrentCamera
		if Camera then
			Camera.CameraType = self.SavedCameraType or Enum.CameraType.Custom
			self.SavedCameraType = nil
			if self.SavedCameraSubject then
				Camera.CameraSubject = self.SavedCameraSubject
				self.SavedCameraSubject = nil
			end
		end
	end
end

function CameraMan:SetFreecamSpeed(Speed: number)
	self.FreecamSpeed = math.max(1, Speed)
end

function CameraMan:ResetAll()
	self:SetThirdPerson(false)
	self:SetViewLock(false)
	self:SetSpin(false)
	self:SetFreecam(false)
	self:ResetFOV()
end

function CameraMan:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true

	self:ResetAll()

	if self.RenderConnection then
		self.RenderConnection:Disconnect()
		self.RenderConnection = nil
	end

	for Index = #self.Connections, 1, -1 do
		local Connection = table.remove(self.Connections, Index)
		if Connection and Connection.Connected then
			Connection:Disconnect()
		end
	end
end

return CameraMan
