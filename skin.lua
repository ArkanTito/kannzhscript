-- Roblox GUI Hack Menu Lengkap
-- Fitur: Fly, Speed, JumpPower, Noclip, ESP, Teleport, Minimize/Maximize

-- Layanan Roblox
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK
lp.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HackMenu"

local main = Instance.new("ScrollingFrame", gui)
main.Size = UDim2.new(0, 300, 0, 350)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0
main.AutomaticCanvasSize = Enum.AutomaticSize.Y
main.CanvasSize = UDim2.new(0, 0, 0, 0)
main.ScrollBarThickness = 6

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local maximize = Instance.new("TextButton", gui)
maximize.Size = UDim2.new(0, 100, 0, 40)
maximize.Position = main.Position
maximize.Text = "Show Menu"
maximize.Visible = false
maximize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Fungsi membuat label input
local function createInput(labelText, defaultValue, y)
	local label = Instance.new("TextLabel", main)
	label.Size = UDim2.new(0.8, 0, 0, 20)
	label.Position = UDim2.new(0.1, 0, 0, y)
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox", main)
	box.Size = UDim2.new(0.5, 0, 0, 25)
	box.Position = UDim2.new(0.1, 0, 0, y + 25)
	box.Text = tostring(defaultValue)
	box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	box.TextColor3 = Color3.new(1, 1, 1)

	local btn = Instance.new("TextButton", main)
	btn.Size = UDim2.new(0.3, 0, 0, 25)
	btn.Position = UDim2.new(0.62, 0, 0, y + 25)
	btn.Text = "Set"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)

	return box, btn
end

-- Speed
local speedBox, speedBtn = createInput("Speed:", 16, 10)
speedBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(speedBox.Text)
		if num then hum.WalkSpeed = num end
	end
end)

-- JumpPower
local jumpBox, jumpBtn = createInput("Jump:", 50, 70)
jumpBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(jumpBox.Text)
		if num then hum.JumpPower = num end
	end
end)

-- Fly
local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.new(0.8, 0, 0, 30)
flyBtn.Position = UDim2.new(0.1, 0, 0, 130)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyBtn.TextColor3 = Color3.new(1, 1, 1)

local flying, flyVel, flyGyro, flyConn
local keys = {}

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe then keys[input.KeyCode] = true end
end)
UserInputService.InputEnded:Connect(function(input, gpe)
	if not gpe then keys[input.KeyCode] = false end
end)

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	flyBtn.Text = "Fly: " .. (flying and "ON" or "OFF")
	if flying then
		local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
		if hrp then
			flyVel = Instance.new("BodyVelocity", hrp)
			flyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
			flyVel.Velocity = Vector3.zero
			flyGyro = Instance.new("BodyGyro", hrp)
			flyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
			flyGyro.CFrame = hrp.CFrame
			flyConn = RunService.RenderStepped:Connect(function()
				if not flying then return end
				local dir = Vector3.zero
				local cam = workspace.CurrentCamera
				local spd = tonumber(speedBox.Text) or 50
				if keys[Enum.KeyCode.W] then dir += cam.CFrame.LookVector end
				if keys[Enum.KeyCode.S] then dir -= cam.CFrame.LookVector end
				if keys[Enum.KeyCode.A] then dir -= cam.CFrame.RightVector end
				if keys[Enum.KeyCode.D] then dir += cam.CFrame.RightVector end
				if keys[Enum.KeyCode.E] then dir += cam.CFrame.UpVector end
				if keys[Enum.KeyCode.Q] then dir -= cam.CFrame.UpVector end
				flyVel.Velocity = dir.Magnitude > 0 and dir.Unit * spd or Vector3.zero
				flyGyro.CFrame = cam.CFrame
			end)
		end
	else
		if flyVel then flyVel:Destroy() end
		if flyGyro then flyGyro:Destroy() end
		if flyConn then flyConn:Disconnect() end
	end
end)

-- Noclip
local noclipBtn = flyBtn:Clone()
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Position = flyBtn.Position + UDim2.new(0, 0, 0, 40)
noclipBtn.Parent = main

local noclip, noclipConn
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")
	if noclip then
		noclipConn = RunService.Stepped:Connect(function()
			if lp.Character then
				for _, part in pairs(lp.Character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

-- ESP
local espEnabled = false
local espBtn = flyBtn:Clone()
espBtn.Text = "ESP: OFF"
espBtn.Position = noclipBtn.Position + UDim2.new(0, 0, 0, 40)
espBtn.Parent = main

local function createESP(plr)
	if plr == lp then return end
	local char = plr.Character or plr.CharacterAdded:Wait()
	local head = char:WaitForChild("Head", 5)
	if not head then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end

	local billboard = Instance.new("BillboardGui", head)
	billboard.Name = "ESP"
	billboard.Adornee = head
	billboard.Size = UDim2.new(0, 100, 0, 40)
	billboard.StudsOffset = Vector3.new(0, 2.5, 0)
	billboard.AlwaysOnTop = true

	local label = Instance.new("TextLabel", billboard)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = plr.Name
	label.TextColor3 = Color3.new(1, 0, 0)
	label.TextStrokeTransparency = 0.5
	label.TextScaled = true

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			local box = Instance.new("BoxHandleAdornment", part)
			box.Name = "ESPBox"
			box.Adornee = part
			box.AlwaysOnTop = true
			box.Size = part.Size
			box.Color3 = Color3.fromRGB(0, 255, 0)
			box.Transparency = 0.7
		end
	end
end

local function removeESP(plr)
	local char = plr.Character
	if not char then return end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end

	local head = char:FindFirstChild("Head")
	if head and head:FindFirstChild("ESP") then head.ESP:Destroy() end

	for _, part in pairs(char:GetChildren()) do
		if part:IsA("BasePart") then
			for _, adorn in pairs(part:GetChildren()) do
				if adorn:IsA("BoxHandleAdornment") and adorn.Name == "ESPBox" then adorn:Destroy() end
			end
		end
	end
end

espBtn.MouseButton1Click:Connect(function()
	espEnabled = not espEnabled
	espBtn.Text = "ESP: " .. (espEnabled and "ON" or "OFF")
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= lp then
			if espEnabled then createESP(p) else removeESP(p) end
		end
	end
end)

Players.PlayerAdded:Connect(function(p)
	if espEnabled then
		p.CharacterAdded:Connect(function()
			task.wait(1)
			createESP(p)
		end)
	end
end)

-- Teleport
local tpLabel = Instance.new("TextLabel", main)
tpLabel.Size = UDim2.new(0.8, 0, 0, 20)
tpLabel.Position = UDim2.new(0.1, 0, 0, 290)
tpLabel.Text = "Teleport ke Player:"
tpLabel.BackgroundTransparency = 1
tpLabel.TextColor3 = Color3.new(1, 1, 1)
tpLabel.TextXAlignment = Enum.TextXAlignment.Left

local tpBox = Instance.new("TextBox", main)
tpBox.Size = UDim2.new(0.5, 0, 0, 25)
tpBox.Position = tpLabel.Position + UDim2.new(0, 0, 0, 25)
tpBox.PlaceholderText = "Nama Player"
tpBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tpBox.TextColor3 = Color3.new(1, 1, 1)

local tpBtn = Instance.new("TextButton", main)
tpBtn.Size = UDim2.new(0.3, 0, 0, 25)
tpBtn.Position = tpBox.Position + UDim2.new(0.52, 0, 0, 0)
tpBtn.Text = "Teleport"
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpBtn.TextColor3 = Color3.new(1, 1, 1)

tpBtn.MouseButton1Click:Connect(function()
	local name = tpBox.Text
	for _, p in pairs(Players:GetPlayers()) do
		if string.lower(p.Name):sub(1, #name) == string.lower(name) then
			local targetChar = p.Character
			local hrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
			local myHRP = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
			if hrp and myHRP then
				myHRP.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
			end
		end
	end
end)

-- Minimize / Maximize
minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	maximize.Visible = true
end)

maximize.MouseButton1Click:Connect(function()
	main.Visible = true
	maximize.Visible = false
end)

-- Reset fly jika karakter respawn atau mati
lp.CharacterAdded:Connect(function()
	flying = false
	flyBtn.Text = "Fly: OFF"
	if flyVel then flyVel:Destroy() end
	if flyGyro then flyGyro:Destroy() end
	if flyConn then flyConn:Disconnect() flyConn = nil end
end)
