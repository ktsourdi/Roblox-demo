local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local function fetchShop()
	local ok, data = pcall(function()
		return Remotes.GetShop:InvokeServer()
	end)
	if ok then return data end
	return nil
end

local gui = Instance.new("ScreenGui")
gui.Name = "PurchasesUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 180)
frame.Position = UDim2.new(1, -280, 0, 200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Purchases"
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
layout.Padding = UDim.new(0, 6)
layout.Parent = list

local function addButton(text, onClick)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 28)
	btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = true
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 14
	btn.Text = text
	btn.Parent = list
	btn.MouseButton1Click:Connect(onClick)
end

local function rebuild()
	for _, c in ipairs(list:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
	local shop = fetchShop()
	if not shop then return end
	if shop.Gamepasses and shop.Gamepasses.VIPDecor and shop.Gamepasses.VIPDecor > 0 then
		addButton("Buy Gamepass: VIP Decor", function()
			MarketplaceService:PromptGamePassPurchase(player, shop.Gamepasses.VIPDecor)
		end)
	end
	if shop.DevProducts then
		if shop.DevProducts.EggBundle3 and shop.DevProducts.EggBundle3 > 0 then
			addButton("Buy: Ticket Bundle Small", function()
				MarketplaceService:PromptProductPurchase(player, shop.DevProducts.EggBundle3)
			end)
		end
		if shop.DevProducts.EggBundle5 and shop.DevProducts.EggBundle5 > 0 then
			addButton("Buy: Ticket Bundle Medium", function()
				MarketplaceService:PromptProductPurchase(player, shop.DevProducts.EggBundle5)
			end)
		end
		if shop.DevProducts.EggBundle10 and shop.DevProducts.EggBundle10 > 0 then
			addButton("Buy: Ticket Bundle Large", function()
				MarketplaceService:PromptProductPurchase(player, shop.DevProducts.EggBundle10)
			end)
		end
		if shop.DevProducts.TicketBoost and shop.DevProducts.TicketBoost > 0 then
			addButton("Buy: Ticket Boost (10m)", function()
				MarketplaceService:PromptProductPurchase(player, shop.DevProducts.TicketBoost)
			end)
		end
		if shop.DevProducts.EventDecor and shop.DevProducts.EventDecor > 0 then
			addButton("Buy: Event Decor (Glow Coral)", function()
				MarketplaceService:PromptProductPurchase(player, shop.DevProducts.EventDecor)
			end)
		end
	end
end

rebuild()
-- Could listen to GetShop changes via announcement or periodic refresh
