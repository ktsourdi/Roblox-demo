-- Diagnostics: Lightweight runtime checks for common issues
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local okRemotes, remotes = pcall(function()
	return ReplicatedStorage:WaitForChild("RemoteEvents", 5)
end)
if not okRemotes or not remotes then
	warn("[Diagnostics] Missing RemoteEvents folder in ReplicatedStorage")
else
	local expected = {
		"BuyEgg","HatchEgg","PlaceFish","VisitBoost","LikeAquarium",
		"RedeemCode","Announcement","PlaceDecoration","SetOnboarding",
	}
	for _, name in ipairs(expected) do
		if not remotes:FindFirstChild(name) then
			warn("[Diagnostics] Missing remote:", name)
		end
	end
end

-- Validate ShopConfig and Decorations schemas
local okShop, ShopConfig = pcall(function()
	return require(ServerStorage:WaitForChild("ShopConfig"))
end)
local okDeco, Decorations = pcall(function()
	return require(ServerStorage:WaitForChild("Decorations"))
end)

if okShop and ShopConfig and ShopConfig.Eggs then
	for eggType, egg in pairs(ShopConfig.Eggs) do
		if type(egg.priceType) ~= "string" or type(egg.priceAmount) ~= "number" then
			warn("[Diagnostics] Egg has invalid pricing:", eggType)
		end
	end
else
	warn("[Diagnostics] ShopConfig not available or missing Eggs")
end

if okDeco and Decorations and Decorations.Items then
	for _, item in ipairs(Decorations.Items) do
		if type(item.id) ~= "string" then
			warn("[Diagnostics] Decoration missing id")
		end
		if type(item.price) ~= "number" then
			warn("[Diagnostics] Decoration has invalid price:", item.id)
		end
	end
else
	warn("[Diagnostics] Decorations data missing")
end

-- Periodically sample a profile (if present) for nil hazards
task.spawn(function()
	while true do
		task.wait(10)
		local any = Players:GetPlayers()[1]
		if any then
			local ProfileManager = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("ProfileManager"))
			local profile = ProfileManager:Get(any.UserId)
			if profile then
				if type(profile.Currencies) ~= "table" or type(profile.Inventory) ~= "table" then
					warn("[Diagnostics] Profile malformed for", any.UserId)
				end
			end
		end
	end
end)

print("🔍 Diagnostics loaded: runtime sanity checks active")


