-- GUI Menu Lengkap: Fly, Speed, Jump, Noclip
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "HackMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0

local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

local maximize = Instance.new("TextButton", gui)
maximize.Size = UDim2.new(0, 100, 0, 40)
maximize.Position = UDim2.new(0.05, 0, 0.3, 0)
maximize.Text = "Show Menu"
maximize.Visible = false
maximize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Speed input
local speedLabel = Instance.new("TextLabel", main)
speedLabel.Size = UDim2.new(0.8, 0, 0, 20)
speedLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
speedLabel.Text = "Speed:"
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local speedBox = Instance.new("TextBox", main)
speedBox.Size = UDim2.new(0.5, 0, 0, 25)
speedBox.Position = UDim2.new(0.1, 0, 0.17, 0)
speedBox.Text = "16"
speedBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
speedBox.TextColor3 = Color3.new(1,1,1)

local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.new(0.3, 0, 0, 25)
speedBtn.Position = UDim2.new(0.62, 0, 0.17, 0)
speedBtn.Text = "Set"
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1,1,1)

-- Jump input
local jumpLabel = speedLabel:Clone()
jumpLabel.Text = "Jump:"
jumpLabel.Position = UDim2.new(0.1, 0, 0.32, 0)
jumpLabel.Parent = main

local jumpBox = speedBox:Clone()
jumpBox.Text = "50"
jumpBox.Position = UDim2.new(0.1, 0, 0.39, 0)
jumpBox.Parent = main

local jumpBtn = speedBtn:Clone()
jumpBtn.Text = "Set"
jumpBtn.Position = UDim2.new(0.62, 0, 0.39, 0)
jumpBtn.Parent = main

-- Fly button
local flyBtn = Instance.new("TextButton", main)
flyBtn.Size = UDim2.new(0.8, 0, 0, 30)
flyBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
flyBtn.Text = "Fly: OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
flyBtn.TextColor3 = Color3.new(1,1,1)

-- Noclip button
local noclipBtn = flyBtn:Clone()
noclipBtn.Position = UDim2.new(0.1, 0, 0.68, 0)
noclipBtn.Text = "Noclip: OFF"
noclipBtn.Parent = main

-- Functionality
speedBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(speedBox.Text)
		if num then
			hum.WalkSpeed = num
		end
	end
end)

jumpBtn.MouseButton1Click:Connect(function()
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(jumpBox.Text)
		if num then
			hum.JumpPower = num
		end
	end
end)

-- Fly Script
local flying = false
local flyVel, flyGyro
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

			game:GetService("RunService").RenderStepped:Connect(function()
				if not flying then return end
				local cam = workspace.CurrentCamera
				local dir = Vector3.zero
				if lp:GetMouse().W then dir = dir + cam.CFrame.LookVector end
				if lp:GetMouse().S then dir = dir - cam.CFrame.LookVector end
				if lp:GetMouse().A then dir = dir - cam.CFrame.RightVector end
				if lp:GetMouse().D then dir = dir + cam.CFrame.RightVector end
				flyVel.Velocity = dir * (tonumber(speedBox.Text) or 50)
				flyGyro.CFrame = cam.CFrame
			end)
		end
	else
		if flyVel then flyVel:Destroy() end
		if flyGyro then flyGyro:Destroy() end
	end
end)

-- Noclip Script
local noclip = false
noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = "Noclip: " .. (noclip and "ON" or "OFF")

	game:GetService("RunService").Stepped:Connect(function()
		if noclip and lp.Character then
			for _, v in pairs(lp.Character:GetDescendants()) do
				if v:IsA("BasePart") and v.CanCollide then
					v.CanCollide = false
				end
			end
		end
	end)
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
