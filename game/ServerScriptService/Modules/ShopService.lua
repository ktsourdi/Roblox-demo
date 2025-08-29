local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local ShopConfig = require(ServerStorage:WaitForChild("ShopConfig"))
local FishData = require(ServerStorage:WaitForChild("FishData"))
local RandomUtil = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RandomUtil"))

local ShopService = {}

local ProfileManager = nil -- to be injected
local BadgesService = nil -- optional injection
local RateLimiter = require(game:GetService("ServerScriptService"):WaitForChild("Modules"):WaitForChild("RateLimiter"))
local limiter = RateLimiter.new(2, 5)

function ShopService:Init(profileManager, badgesService)
	ProfileManager = profileManager
	BadgesService = badgesService

	Remotes.BuyEgg.OnServerEvent:Connect(function(player, eggType)
		if not limiter:allow("BuyEgg:" .. player.UserId, 2, 4) then return end
		self:HandleBuyEgg(player, eggType)
	end)

	Remotes.HatchEgg.OnServerEvent:Connect(function(player, eggType)
		if not limiter:allow("HatchEgg:" .. player.UserId, 2, 4) then return end
		self:HandleHatchEgg(player, eggType)
	end)
end

function ShopService:HandleBuyEgg(player, eggType)
	local profile = ProfileManager:Get(player.UserId)
	if not profile then return end
	local egg = ShopConfig.Eggs[eggType]
	if not egg then return end
	-- No charge here; charging happens on hatch to prevent free hatch exploit
	Remotes.Announcement:FireAllClients(player.Name .. " bought a " .. eggType .. " Egg!")
end

local function pickFromEventPool()
	local pool = FishData.FishByRarity.Event
	if not pool or #pool == 0 then return nil end
	local index = math.random(1, #pool)
	local fish = pool[index]
	-- Tag as Epic by default for event, could be varied later
	return { id = fish.id, name = fish.name, rarity = "Epic" }
end

local function pickFishByRarity(targetRarity)
	local pool = FishData.FishByRarity[targetRarity]
	if not pool or #pool == 0 then return nil end
	local index = math.random(1, #pool)
	local fish = pool[index]
	return { id = fish.id, name = fish.name, rarity = targetRarity }
end

function ShopService:HandleHatchEgg(player, eggType)
	local profile = ProfileManager:Get(player.UserId)
	if not profile then return end
	local egg = ShopConfig.Eggs[eggType]
	if not egg then return end
	-- Validate event egg enable
	if eggType == "Event" and egg.enabled ~= true then return end
	-- Charge currency here (authoritative)
	local currencyName = egg.priceType
	local price = egg.priceAmount
	if not (profile.Currencies[currencyName] and profile.Currencies[currencyName] >= price) then
		return
	end
	profile.Currencies[currencyName] -= price

	local fish
	if egg.pool == "Event" then
		fish = pickFromEventPool()
	else
		local rarity = RandomUtil.weightedRandom(egg.weights)
		fish = pickFishByRarity(rarity)
	end
	if not fish then return end

	table.insert(profile.Inventory.Fish, fish)

	if fish.rarity == "Legendary" or fish.rarity == "Mythic" then
		Remotes.Announcement:FireAllClients(player.Name .. " hatched a " .. fish.rarity .. " " .. fish.name .. "!")
	end

	if BadgesService then
		BadgesService:OnHatch(player, fish.rarity)
	end
end

return ShopService

