-- GUI untuk Ganti Skin Roblox
-- Script ini hanya bisa jalan di executor (exploit) dengan loadstring

-- Buat GUI sederhana
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Button1 = Instance.new("TextButton")
local Button2 = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0, 250, 0, 150)
Frame.Position = UDim2.new(0.5, -125, 0.5, -75)
Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame.BorderSizePixel = 0

Button1.Parent = Frame
Button1.Position = UDim2.new(0.1, 0, 0.2, 0)
Button1.Size = UDim2.new(0.8, 0, 0.3, 0)
Button1.Text = "Ganti Skin ke Style 1"
Button1.BackgroundColor3 = Color3.fromRGB(100, 200, 100)

Button2.Parent = Frame
Button2.Position = UDim2.new(0.1, 0, 0.6, 0)
Button2.Size = UDim2.new(0.8, 0, 0.3, 0)
Button2.Text = "Ganti Skin ke Style 2"
Button2.BackgroundColor3 = Color3.fromRGB(100, 100, 200)

-- Fungsi untuk ganti skin
function applySkin(id)
    local desc = game.Players.LocalPlayer.Character.Humanoid:GetAppliedDescription()
    desc.Shirt = id.Shirt
    desc.Pants = id.Pants
    desc.Head = id.Head or desc.Head
    desc.Face = id.Face or desc.Face
    desc.HairAccessory = id.Hair or ""
    game.Players.LocalPlayer.Character.Humanoid:ApplyDescription(desc)
end

-- Skin Style 1
local skin1 = {
    Shirt = 14407675989, -- ID kaos
    Pants = 14407681597, -- ID celana
    Face = 7074786,      -- Smile
    Hair = 62234425      -- ID aksesori rambut
}

-- Skin Style 2
local skin2 = {
    Shirt = 14407695397,
    Pants = 14407699166,
    Face = 86487700,     -- ID wajah lain
    Hair = 451221329     -- ID rambut
}

Button1.MouseButton1Click:Connect(function()
    applySkin(skin1)
end)

Button2.MouseButton1Click:Connect(function()
    applySkin(skin2)
end)
