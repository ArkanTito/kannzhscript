-- Roblox GUI Hack Menu (Delta-compatible)
-- Fitur: Fly, Speed, Jump, Noclip, ESP, Teleport, Fake Chat, Refresh Dropdown, Minimize

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local lp = Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")

-- Anti-AFK
lp.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

-- GUI Root
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

-- Container draggable
local container = Instance.new("Frame", gui)
container.BackgroundColor3 = Color3.fromRGB(25,25,25)
container.BorderSizePixel = 0
container.Size = UDim2.new(0,280,0,340)
container.Position = UDim2.new(0.05,0,0.3,0)
container.Active = true
container.Draggable = true

-- Header (minimize toggle)
local header = Instance.new("TextButton", container)
header.Size = UDim2.new(1,0,0,30)
header.BackgroundColor3 = Color3.fromRGB(50,50,50)
header.TextColor3 = Color3.new(1,1,1)
header.Text = "Hack Menu - Tap to Minimize"
local contentsVisible = true

-- Scrolling frame
local main = Instance.new("ScrollingFrame", container)
main.Size = UDim2.new(1,0,1,-30)
main.Position = UDim2.new(0,0,0,30)
main.BackgroundTransparency = 1
main.CanvasSize = UDim2.new(0,0,0,0)
main.ScrollBarThickness = 6

local layout = Instance.new("UIListLayout", main)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0,4)
local padding = Instance.new("UIPadding",main)
padding.PaddingTop = UDim.new(0,4)

-- Toggle visibility
header.MouseButton1Click:Connect(function()
	contentsVisible = not contentsVisible
	main.Visible = contentsVisible
	header.Text = contentsVisible and "Hack Menu - Tap to Minimize" or "MENU"
end)

-- Utility create button
local function newButton(txt, parent, cb)
	local b = Instance.new("TextButton", parent)
	b.Size = UDim2.new(1,-10,0,30)
	b.Text = txt
	b.BackgroundColor3 = Color3.fromRGB(70,70,70)
	b.TextColor3 = Color3.new(1,1,1)
	b.LayoutOrder = #main:GetChildren()
	cb(b)
	return b
end

-- Utility create input
local function newInput(label, default, cb)
	local frame = Instance.new("Frame", main)
	frame.Size = UDim2.new(1,-10,0,45)
	local L = Instance.new("TextLabel", frame)
	L.Size = UDim2.new(0.5,0,1,0)
	L.Text = label
	L.BackgroundTransparency = 1
	L.TextColor3 = Color3.new(1,1,1)
	local box = Instance.new("TextBox", frame)
	box.Size = UDim2.new(0.3,0,0.8,0)
	box.Position = UDim2.new(0.5,0,0.1,0)
	box.Text = tostring(default)
	box.BackgroundColor3 = Color3.fromRGB(80,80,80)
	box.TextColor3 = Color3.new(1,1,1)
	local btn = Instance.new("TextButton", frame)
	btn.Size = UDim2.new(0.2,0,0.8,0)
	btn.Position = UDim2.new(0.8,0,0.1,0)
	btn.Text = "Set"
	btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.MouseButton1Click:Connect(function()
		cb(box.Text)
	end)
	return box
end

-- Speed
newInput("Speed:", 16, function(v)
	local n = tonumber(v)
	if n and lp.Character then
		local hum = lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = n end
	end
end)

-- Jump
newInput("Jump:", 50, function(v)
	local n = tonumber(v)
	if n and lp.Character then
		local hum = lp.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.JumpPower = n end
	end
end)

-- Fly
do
	local flying=false
	local bv, bg, conn
	newButton("Fly: OFF", main, function(btn)
		btn.MouseButton1Click:Connect(function()
			flying = not flying
			btn.Text = "Fly: " .. (flying and "ON" or "OFF")
			if flying then
				local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
				if hrp then
					bv=Instance.new("BodyVelocity",hrp)
					bv.MaxForce=Vector3.new(1e5,1e5,1e5)
					bv.Velocity=Vector3.zero
					bg=Instance.new("BodyGyro",hrp)
					bg.MaxTorque=Vector3.new(1e5,1e5,1e5)
					conn = RunService.RenderStepped:Connect(function()
						local cam = workspace.CurrentCamera
						local dir = Vector3.zero
						if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
						if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
						bv.Velocity = dir.Unit * 50
						bg.CFrame = cam.CFrame
					end)
				end
			else
				if bv then bv:Destroy() end
				if bg then bg:Destroy() end
				if conn then conn:Disconnect() end
			end
		end)
	end)
end

-- Noclip
do
	local nc=false
	local conn
	newButton("Noclip: OFF", main, function(btn)
		btn.MouseButton1Click:Connect(function()
			nc = not nc
			btn.Text = "Noclip: " .. (nc and "ON" or "OFF")
			if nc then
				conn = RunService.Stepped:Connect(function()
					if lp.Character then
						for _,p in pairs(lp.Character:GetDescendants()) do
							if p:IsA("BasePart") then p.CanCollide=false end
						end
					end
				end)
			else
				if conn then conn:Disconnect() end
			end
		end)
	end)
end

-- ESP Toggle
do
	local en=false
	local function applyESP(p)
		if p==lp then return end
		local c = p.Character
		if not c then return end
		local head=c:FindFirstChild("Head")
		if not head then return end
		local g=Instance.new("BillboardGui",head)
		g.Name="ESP_Light"
		g.Size=UDim2.new(0,80,0,30)
		g.Adornee=head
		g.AlwaysOnTop=true
		local lbl=Instance.new("TextLabel",g)
		lbl.Size=UDim2.new(1,0,1,0)
		lbl.BackgroundTransparency=1
		lbl.Text=p.Name
		lbl.TextColor3=Color3.new(1,0,0)
	end
	local function cleanup(p)
		if p.Character then
			local h=p.Character:FindFirstChild("Head")
			if h then
				local child=h:FindFirstChild("ESP_Light")
				if child then child:Destroy() end
			end
		end
	end
	newButton("ESP: OFF", main, function(btn)
		btn.MouseButton1Click:Connect(function()
			en = not en
			btn.Text = "ESP: " .. (en and "ON" or "OFF")
			for _,p inpairs(Players:GetPlayers()) do
				if en then applyESP(p) else cleanup(p) end
			end
		end)
	end)
	Players.PlayerAdded:Connect(function(p) if en then applyESP(p) end end)
	Players.PlayerRemoving:Connect(cleanup)
end

-- Dropdown Teleport + Refresh
do
	local list, visible=false
	local frame=Instance.new("Frame",container)
	frame.Size=UDim2.new(0.8,0,0,0)
	frame.Position=UDim2.new(0.1,0,0,260)
	frame.ClipsDescendants=true

	local mainBtn = newButton("Teleport: Select Player", main, function(btn)
		mainBtn = btn
		btn.MouseButton1Click:Connect(function()
			visible = not visible
			frame.Visible = visible
			if visible then frame:ClearAllChildren() end
			local idx=1
			for _,p in ipairs(Players:GetPlayers()) do
				if p~=lp then
					local b=Instance.new("TextButton",frame)
					b.Size = UDim2.new(1,0,0,25)
					b.Position = UDim2.new(0,0,0,25*(idx-1))
					b.Text=p.Name
					b.BackgroundColor3 = Color3.fromRGB(80,80,80)
					b.TextColor3=Color3.new(1,1,1)
					b.MouseButton1Click:Connect(function()
						local t = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
						local m = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
						if t and m then m.CFrame = t.CFrame + Vector3.new(0,3,0) end
						visible=false; frame.Visible=false
					end)
					idx+=1
				end
			end
			-- refresh button
			local b=Instance.new("TextButton",frame)
			b.Size = UDim2.new(1,0,0,25)
			b.Position = UDim2.new(0,0,0,25*(idx-1))
			b.Text="🔄 Refresh"
			b.BackgroundColor3 = Color3.fromRGB(100,100,100)
			b.TextColor3=Color3.new(1,1,1)
			b.MouseButton1Click:Connect(function()
				-- just reopen
				frame:ClearAllChildren()
				mainBtn:MouseButton1Click()
			end)
			frame.Size = UDim2.new(0.8,0,0,25*idx)
		end)
	end)
end

-- Fake Chat
newButton("Send Fake Chat", main, function(btn)
	btn.MouseButton1Click:Connect(function()
		game.StarterGui:SetCore("ChatMakeSystemMessage", {
			Text = "<SYSTEM> Fake message working!",
			Color = Color3.new(1,1,1),
			Font = Enum.Font.SourceSansBold
		})
	end)
end)
