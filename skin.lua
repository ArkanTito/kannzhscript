-- Roblox GUI Hack Menu Lengkap + Fix Scroll/Drag + Fake Chat

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

-- Container utama yang bisa dipindah
local container = Instance.new("Frame", gui)
container.Size = UDim2.new(0, 320, 0, 360)
container.Position = UDim2.new(0.05, 0, 0.3, 0)
container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
container.Active = true
container.Draggable = true
container.BorderSizePixel = 0

-- Scroll area
local main = Instance.new("ScrollingFrame", container)
main.Size = UDim2.new(1, 0, 1, -40)
main.Position = UDim2.new(0, 0, 0, 40)
main.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
main.BorderSizePixel = 0
main.ScrollBarThickness = 6
main.AutomaticCanvasSize = Enum.AutomaticSize.Y

-- Layout dan padding
local layout = Instance.new("UIListLayout", main)
layout.Padding = UDim.new(0, 8)
layout.SortOrder = Enum.SortOrder.LayoutOrder

local padding = Instance.new("UIPadding", main)
padding.PaddingTop = UDim.new(0, 10)
padding.PaddingLeft = UDim.new(0, 10)
padding.PaddingRight = UDim.new(0, 10)
padding.PaddingBottom = UDim.new(0, 10)

-- Tombol minimize/maximize
local header = Instance.new("TextButton", container)
header.Size = UDim2.new(1, 0, 0, 40)
header.Position = UDim2.new(0, 0, 0, 0)
header.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
header.Text = "Hack Menu - Klik Untuk Minimize"
header.TextColor3 = Color3.new(1, 1, 1)

header.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
	header.Text = main.Visible and "Hack Menu - Klik Untuk Minimize" or "Hack Menu - Klik Untuk Maximize"
end)

-- Fungsi membuat input
local function createInput(labelText, defaultValue, onClick)
	local holder = Instance.new("Frame", main)
	holder.Size = UDim2.new(1, -10, 0, 50)
	holder.BackgroundTransparency = 1

	local label = Instance.new("TextLabel", holder)
	label.Size = UDim2.new(0.4, 0, 1, 0)
	label.Text = labelText
	label.BackgroundTransparency = 1
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextXAlignment = Enum.TextXAlignment.Left

	local box = Instance.new("TextBox", holder)
	box.Size = UDim2.new(0.3, 0, 0.8, 0)
	box.Position = UDim2.new(0.42, 0, 0.1, 0)
	box.Text = tostring(defaultValue)
	box.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	box.TextColor3 = Color3.new(1, 1, 1)

	local btn = Instance.new("TextButton", holder)
	btn.Size = UDim2.new(0.25, 0, 0.8, 0)
	btn.Position = UDim2.new(0.74, 0, 0.1, 0)
	btn.Text = "Set"
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)

	btn.MouseButton1Click:Connect(function()
		onClick(box.Text)
	end)

	return box, btn
end

-- Speed
createInput("Speed:", 16, function(val)
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(val)
		if num then hum.WalkSpeed = num end
	end
end)

-- Jump
createInput("Jump:", 50, function(val)
	local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
	if hum then
		local num = tonumber(val)
		if num then hum.JumpPower = num end
	end
end)

-- Fitur Fake Chat
local fakeHolder = Instance.new("Frame", main)
fakeHolder.Size = UDim2.new(1, -10, 0, 90)
fakeHolder.BackgroundTransparency = 1

local fakeLabel = Instance.new("TextLabel", fakeHolder)
fakeLabel.Size = UDim2.new(1, 0, 0.3, 0)
fakeLabel.Text = "Fake Chat:"
fakeLabel.BackgroundTransparency = 1
fakeLabel.TextColor3 = Color3.new(1, 1, 1)
fakeLabel.TextXAlignment = Enum.TextXAlignment.Left

local nameBox = Instance.new("TextBox", fakeHolder)
nameBox.Size = UDim2.new(0.5, -5, 0.3, 0)
nameBox.Position = UDim2.new(0, 0, 0.3, 0)
nameBox.PlaceholderText = "Nama Player"
nameBox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
nameBox.TextColor3 = Color3.new(1, 1, 1)

local msgBox = nameBox:Clone()
msgBox.Position = UDim2.new(0.5, 5, 0.3, 0)
msgBox.PlaceholderText = "Pesan Chat"
msgBox.Parent = fakeHolder

local sendBtn = Instance.new("TextButton", fakeHolder)
sendBtn.Size = UDim2.new(1, 0, 0.3, 0)
sendBtn.Position = UDim2.new(0, 0, 0.7, 0)
sendBtn.Text = "Kirim Pesan Chat Palsu"
sendBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
sendBtn.TextColor3 = Color3.new(1, 1, 1)

sendBtn.MouseButton1Click:Connect(function()
	game.StarterGui:SetCore("ChatMakeSystemMessage", {
		Text = nameBox.Text .. ": " .. msgBox.Text,
		Color = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.SourceSansBold,
		FontSize = Enum.FontSize.Size24
	})
end)

-- Selesai: fitur tambahan lainnya bisa disisipkan juga setelah ini
-- Misalnya fly, noclip, teleport, dll seperti yang kamu punya sebelumnya
