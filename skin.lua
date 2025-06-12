-- GUI Template Menu: Drag, Minimize, Speed Hack, Jump Hack
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local chr = lp.Character or lp.CharacterAdded:Wait()

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "CustomMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 200)
main.Position = UDim2.new(0.05, 0, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.Active = true
main.Draggable = true
main.BorderSizePixel = 0

-- Minimize Button
local minimize = Instance.new("TextButton", main)
minimize.Size = UDim2.new(0, 30, 0, 30)
minimize.Position = UDim2.new(1, -35, 0, 5)
minimize.Text = "-"
minimize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimize.TextColor3 = Color3.new(1, 1, 1)

-- Maximize Button (hidden by default)
local maximize = Instance.new("TextButton", gui)
maximize.Size = UDim2.new(0, 100, 0, 40)
maximize.Position = UDim2.new(0.05, 0, 0.3, 0)
maximize.Text = "Show Menu"
maximize.Visible = false
maximize.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
maximize.TextColor3 = Color3.new(1, 1, 1)

-- Speed Hack Button
local speedBtn = Instance.new("TextButton", main)
speedBtn.Size = UDim2.new(0.8, 0, 0, 40)
speedBtn.Position = UDim2.new(0.1, 0, 0.3, 0)
speedBtn.Text = "Speed Hack: OFF"
speedBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedBtn.TextColor3 = Color3.new(1, 1, 1)

-- Jump Hack Button
local jumpBtn = Instance.new("TextButton", main)
jumpBtn.Size = UDim2.new(0.8, 0, 0, 40)
jumpBtn.Position = UDim2.new(0.1, 0, 0.55, 0)
jumpBtn.Text = "Jump Hack: OFF"
jumpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
jumpBtn.TextColor3 = Color3.new(1, 1, 1)

-- Functionality
local speedOn = false
local jumpOn = false

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	local humanoid = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.WalkSpeed = speedOn and 100 or 16
	end
	speedBtn.Text = "Speed Hack: " .. (speedOn and "ON" or "OFF")
end)

jumpBtn.MouseButton1Click:Connect(function()
	jumpOn = not jumpOn
	local humanoid = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		humanoid.JumpPower = jumpOn and 120 or 50
	end
	jumpBtn.Text = "Jump Hack: " .. (jumpOn and "ON" or "OFF")
end)

-- Minimize & Maximize Logic
minimize.MouseButton1Click:Connect(function()
	main.Visible = false
	maximize.Visible = true
end)

maximize.MouseButton1Click:Connect(function()
	main.Visible = true
	maximize.Visible = false
end)
