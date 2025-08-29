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

local function fetchShop()
	local ok, data = pcall(function()
		return Remotes.GetShop:InvokeServer()
	end)
	if ok then return data end
	return nil
end

local gui = Instance.new("ScreenGui")
gui.Name = "DecorUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 140)
frame.Position = UDim2.new(0, 200, 0, 10)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 18)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Decorations"
title.TextSize = 14
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

local ratingLabel = Instance.new("TextLabel")
ratingLabel.Size = UDim2.new(1, -10, 0, 14)
ratingLabel.Position = UDim2.new(0, 5, 0, 25)
ratingLabel.Text = "Rating: -"
ratingLabel.TextSize = 12
ratingLabel.TextColor3 = Color3.new(0.9, 0.9, 0.9)
ratingLabel.BackgroundTransparency = 1
ratingLabel.Font = Enum.Font.Gotham
ratingLabel.Parent = frame

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -10, 1, -45)
list.Position = UDim2.new(0, 5, 0, 40)
list.BackgroundTransparency = 1
list.ScrollBarThickness = 4
list.CanvasSize = UDim2.new(0, 0, 0, 200)
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = list

local function refresh()
	local profile = fetchProfile()
	if profile and profile.Aquarium then
		ratingLabel.Text = "Rating: " .. tostring(profile.Aquarium.Rating or 0)
	end
end

local function rebuild()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	local shop = fetchShop()
	if not shop or not shop.Decorations then return end
	for _, item in ipairs(shop.Decorations) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, -10, 0, 22)
		row.BackgroundTransparency = 1
		row.Parent = list

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -60, 1, 0)
		nameLabel.Position = UDim2.new(0, 0, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Font = Enum.Font.Gotham
		nameLabel.TextSize = 9
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextColor3 = Color3.new(1, 1, 1)
		nameLabel.Text = string.format("%s (+%d⭐ x%.1f)", item.name, item.rating or 0, item.multiplier or 1)
		nameLabel.Parent = row

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 55, 1, 0)
		btn.Position = UDim2.new(1, -55, 0, 0)
		btn.AnchorPoint = Vector2.new(1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.BorderSizePixel = 0
		btn.AutoButtonColor = true
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 9
		btn.Text = "$" .. (item.price or 0)
		btn.Parent = row

		btn.MouseButton1Click:Connect(function()
			Remotes.PlaceDecoration:FireServer(1, item.id)
			task.delay(0.25, function()
				refresh()
			end)
		end)
	end
end

rebuild()
refresh()

Remotes.Announcement.OnClientEvent:Connect(function()
	refresh()
end)
