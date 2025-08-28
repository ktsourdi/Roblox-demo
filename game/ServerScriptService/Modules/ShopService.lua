local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local ShopConfig = require(ServerStorage:WaitForChild("ShopConfig"))
local FishData = require(ServerStorage:WaitForChild("FishData"))
local RandomUtil = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("RandomUtil"))

local ShopService = {}

local ProfileManager = nil -- to be injected
local BadgesService = nil -- optional injection

function ShopService:Init(profileManager, badgesService)
	ProfileManager = profileManager
	BadgesService = badgesService

	Remotes.BuyEgg.OnServerEvent:Connect(function(player, eggType)
		self:HandleBuyEgg(player, eggType)
	end)

	Remotes.HatchEgg.OnServerEvent:Connect(function(player, eggType)
		self:HandleHatchEgg(player, eggType)
	end)
end

function ShopService:HandleBuyEgg(player, eggType)
	local profile = ProfileManager:Get(player.UserId)
	if not profile then return end
	local egg = ShopConfig.Eggs[eggType]
	if not egg then return end
	local currencyName = egg.priceType
	local price = egg.priceAmount
	if profile.Currencies[currencyName] and profile.Currencies[currencyName] >= price then
		profile.Currencies[currencyName] -= price
		-- In MVP, buying egg immediately hatches on client call, but we could grant an egg item.
		Remotes.Announcement:FireAllClients(player.Name .. " bought a " .. eggType .. " Egg!")
	else
		-- insufficient funds, optionally respond via RemoteFunction in future
	end
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

	local rarity = RandomUtil.weightedRandom(egg.weights)
	local fish = pickFishByRarity(rarity)
	if not fish then return end

	table.insert(profile.Inventory.Fish, fish)

	if rarity == "Legendary" or rarity == "Mythic" then
		Remotes.Announcement:FireAllClients(player.Name .. " hatched a " .. rarity .. " " .. fish.name .. "!")
	end

	if BadgesService then
		BadgesService:OnHatch(player, rarity)
	end
end

return ShopService

