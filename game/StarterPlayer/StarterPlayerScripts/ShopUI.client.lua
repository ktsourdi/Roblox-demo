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
gui.Name = "ShopUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 210)
frame.Position = UDim2.new(0, 12, 0, 12)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Egg Shop"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

local balance = Instance.new("TextLabel")
balance.Size = UDim2.new(1, -10, 0, 18)
balance.Position = UDim2.new(0, 5, 0, 34)
balance.Text = "Tickets: -  Coins: -"
balance.TextSize = 16
balance.TextColor3 = Color3.new(0.9, 0.9, 0.9)
balance.BackgroundTransparency = 1
balance.Font = Enum.Font.Gotham
balance.Parent = frame

local result = Instance.new("TextLabel")
result.Size = UDim2.new(1, -10, 0, 18)
result.Position = UDim2.new(0, 5, 0, 56)
result.Text = "Last hatch: -"
result.TextSize = 14
result.TextColor3 = Color3.fromRGB(200, 230, 255)
result.BackgroundTransparency = 1
result.Font = Enum.Font.Gotham
result.Parent = frame

local function makeEggButton(text, xOffset, eggType)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 80, 0, 32)
	btn.Position = UDim2.new(0, xOffset, 0, 90)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Parent = frame

	btn.MouseButton1Click:Connect(function()
		local before = fetchProfile()
		Remotes.BuyEgg:FireServer(eggType)
		Remotes.HatchEgg:FireServer(eggType)
		task.delay(0.2, function()
			local after = fetchProfile()
			if after and after.Inventory and before and before.Inventory then
				local bCount = #before.Inventory.Fish
				local aCount = #after.Inventory.Fish
				if aCount > bCount then
					local fish = after.Inventory.Fish[aCount]
					if fish then
						result.Text = "Last hatch: " .. (fish.rarity or "?") .. " " .. (fish.name or "Fish")
					end
				end
			end
			if after and after.Currencies then
				balance.Text = string.format("Tickets: %d  Coins: %d", after.Currencies.Tickets or 0, after.Currencies.Coins or 0)
			end
		end)
	end)

	return btn
end

makeEggButton("Common", 10, "Common")
makeEggButton("Rare", 95, "Rare")
makeEggButton("Mythic", 180, "Mythic")

local function refresh()
	local data = fetchProfile()
	if data and data.Currencies then
		balance.Text = string.format("Tickets: %d  Coins: %d", data.Currencies.Tickets or 0, data.Currencies.Coins or 0)
	end
	local shop = fetchShop()
	if shop and shop.Eggs and shop.Eggs.Event and shop.Eggs.Event.enabled then
		local existing = frame:FindFirstChild("EventEggButton")
		if not existing then
			local btn = Instance.new("TextButton")
			btn.Name = "EventEggButton"
			btn.Size = UDim2.new(0, 240, 0, 28)
			btn.Position = UDim2.new(0, 10, 0, 130)
			btn.Text = "Event Egg"
			btn.BackgroundColor3 = Color3.fromRGB(80, 50, 90)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = true
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Parent = frame
			btn.MouseButton1Click:Connect(function()
				local before = fetchProfile()
				Remotes.BuyEgg:FireServer("Event")
				Remotes.HatchEgg:FireServer("Event")
				task.delay(0.2, function()
					local after = fetchProfile()
					if after and after.Inventory and before and before.Inventory then
						local bCount = #before.Inventory.Fish
						local aCount = #after.Inventory.Fish
						if aCount > bCount then
							local fish = after.Inventory.Fish[aCount]
							if fish then
								result.Text = "Last hatch: " .. (fish.rarity or "?") .. " " .. (fish.name or "Fish")
							end
						end
					end
					if after and after.Currencies then
						balance.Text = string.format("Tickets: %d  Coins: %d", after.Currencies.Tickets or 0, after.Currencies.Coins or 0)
					end
				end)
			end)
		end
	else
		local existing = frame:FindFirstChild("EventEggButton")
		if existing then existing:Destroy() end
	end
end

refresh()
Remotes.Announcement.OnClientEvent:Connect(function()
	refresh()
end)
