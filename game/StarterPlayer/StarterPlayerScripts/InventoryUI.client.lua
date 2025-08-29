local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local function fetchProfile()
	local ok, data = pcall(function()
		return Remotes.GetProfile:InvokeServer()
	end)
	if ok then return data end
	return nil
end

local rarityColors = {
	Common = Color3.fromRGB(180, 200, 220),
	Rare = Color3.fromRGB(100, 160, 255),
	Epic = Color3.fromRGB(180, 100, 255),
	Legendary = Color3.fromRGB(255, 170, 60),
	Mythic = Color3.fromRGB(255, 60, 120),
}

local gui = Instance.new("ScreenGui")
gui.Name = "InventoryUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 260)
frame.Position = UDim2.new(0, 12, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Inventory"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

local list = Instance.new("Frame")
list.Size = UDim2.new(1, -10, 1, -40)
list.Position = UDim2.new(0, 5, 0, 35)
list.BackgroundTransparency = 1
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = list

local function rebuild()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	local data = fetchProfile()
	if not data or not data.Inventory then return end
	for i, fish in ipairs(data.Inventory.Fish or {}) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 28)
		row.BackgroundTransparency = 1
		row.Parent = list

		local icon = Instance.new("Frame")
		icon.Size = UDim2.new(0, 18, 0, 18)
		icon.Position = UDim2.new(0, 0, 0.5, -9)
		icon.BackgroundColor3 = rarityColors[fish.rarity or "Common"] or Color3.new(1, 1, 1)
		icon.BorderSizePixel = 0
		icon.Parent = row

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -120, 1, 0)
		nameLabel.Position = UDim2.new(0, 24, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 14
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.Text = string.format("%s (%s)", fish.name or "Fish", fish.rarity or "?")
		nameLabel.Parent = row

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 90, 1, 0)
		btn.Position = UDim2.new(1, -90, 0, 0)
		btn.AnchorPoint = Vector2.new(1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = true
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.Text = "Place T1"
		btn.Parent = row

		btn.MouseButton1Click:Connect(function()
			Remotes.PlaceFish:FireServer(1, i)
			task.delay(0.2, rebuild)
		end)
	end
end

rebuild()
Remotes.Announcement.OnClientEvent:Connect(function()
	rebuild()
end)
