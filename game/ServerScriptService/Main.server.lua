local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local ModulesFolder = ServerScriptService:WaitForChild("Modules")

local ProfileManager = require(ModulesFolder:WaitForChild("ProfileManager"))
local ShopService = require(ModulesFolder:WaitForChild("ShopService"))
local EconomyService = require(ModulesFolder:WaitForChild("EconomyService"))
local SocialService = require(ModulesFolder:WaitForChild("SocialService"))
local EventsService = require(ModulesFolder:WaitForChild("EventsService"))
local LeaderboardService = require(ModulesFolder:WaitForChild("LeaderboardService"))
local BadgesService = require(ModulesFolder:WaitForChild("BadgesService"))
local RateLimiter = require(ModulesFolder:WaitForChild("RateLimiter"))

-- Inject dependencies
ShopService:Init(ProfileManager, BadgesService)
EconomyService:Init(ProfileManager)
SocialService:Init(ProfileManager, LeaderboardService)
EventsService:Init(ProfileManager)
EconomyService:InjectLeaderboards(LeaderboardService)
EconomyService:InjectBadges(BadgesService)

-- Remote wiring for placement
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
local function deepCopy(tbl)
	local result = {}
	for k, v in pairs(tbl) do
		if type(v) == "table" then
			result[k] = deepCopy(v)
		else
			result[k] = v
		end
	end
	return result
end

local function profileForClient(profile)
	local out = {
		Currencies = deepCopy(profile.Currencies or {}),
		Inventory = deepCopy(profile.Inventory or {}),
		Aquarium = deepCopy(profile.Aquarium or {}),
		Stats = {
			Likes = profile.Stats and profile.Stats.Likes or 0,
			Onboarding = deepCopy((profile.Stats and profile.Stats.Onboarding) or {}),
		}
	}
	return out
end

local limiter = RateLimiter.new(2, 5)

Remotes.GetProfile.OnServerInvoke = function(player)
	if not limiter:allow("GetProfile:" .. player.UserId, 1, 4) then return nil end
	local profile = ProfileManager:Get(player.UserId)
	if not profile then
		for _ = 1, 10 do
			task.wait(0.05)
			profile = ProfileManager:Get(player.UserId)
			if profile then break end
		end
	end
	if not profile then return nil end
	return profileForClient(profile)
end
Remotes.PlaceFish.OnServerEvent:Connect(function(player, tankIndex, fishIndex)
	if not limiter:allow("PlaceFish:" .. player.UserId, 2, 6) then return end
	EconomyService:PlaceFish(player.UserId, tankIndex, fishIndex)
end)

-- Simple social visit boost MVP
Remotes.VisitBoost.OnServerEvent:Connect(function(player, targetUserId)
	if not limiter:allow("VisitBoost:" .. player.UserId, 60, 2) then return end
	local BOOST = 1.25
	local DURATION = 5 * 60
	EconomyService:ApplyVisitBoost(player.UserId, BOOST, DURATION)
	if typeof(targetUserId) == "number" then
		EconomyService:ApplyVisitBoost(targetUserId, BOOST, DURATION)
	end
end)

Remotes.LikeAquarium.OnServerEvent:Connect(function(player, targetUserId)
	if not limiter:allow("Like:" .. player.UserId, 10, 3) then return end
	SocialService:HandleLike(player, targetUserId)
end)

Remotes.RedeemCode.OnServerEvent:Connect(function(player, code)
	if not limiter:allow("RedeemCode:" .. player.UserId, 10, 3) then return end
	EventsService:RedeemCode(player, code)
end)

-- Decor placement
Remotes.PlaceDecoration.OnServerEvent:Connect(function(player, tankIndex, decorationId)
	if not limiter:allow("PlaceDecoration:" .. player.UserId, 2, 4) then return end
	EconomyService:PlaceDecoration(player.UserId, tankIndex, decorationId)
end)

-- Onboarding flags
Remotes.SetOnboarding.OnServerEvent:Connect(function(player, key, value)
	if not limiter:allow("SetOnboard:" .. player.UserId, 2, 6) then return end
	if type(key) ~= "string" then return end
	local profile = ProfileManager:Get(player.UserId)
	if not profile then return end
	profile.Stats = profile.Stats or {}
	profile.Stats.Onboarding = profile.Stats.Onboarding or {}
	profile.Stats.Onboarding[key] = value == true
end)

-- Shop/config info
local ServerStorage = game:GetService("ServerStorage")
local ShopConfig = require(ServerStorage:WaitForChild("ShopConfig"))
local Decorations = require(ServerStorage:WaitForChild("Decorations"))
Remotes.GetShop.OnServerInvoke = function(player)
	if not limiter:allow("GetShop:" .. player.UserId, 1, 3) then return nil end
	return {
		Eggs = ShopConfig.Eggs,
		Decorations = Decorations.Items,
		Gamepasses = ShopConfig.Gamepasses,
		DevProducts = ShopConfig.DevProducts,
	}
end

-- Marketplace: gamepasses + dev products
local OwnedGamepasses = {}

local function ownsGamepass(userId, passId)
	if type(passId) ~= "number" or passId <= 0 then return false end
	local cache = OwnedGamepasses[userId]
	if cache and cache[passId] ~= nil then
		return cache[passId]
	end
	local ok, result = pcall(function()
		return MarketplaceService:UserOwnsGamePassAsync(userId, passId)
	end)
	if not OwnedGamepasses[userId] then OwnedGamepasses[userId] = {} end
	OwnedGamepasses[userId][passId] = ok and result or false
	return OwnedGamepasses[userId][passId]
end

Players.PlayerAdded:Connect(function(player)
	-- Pre-cache common passes
	ownsGamepass(player.UserId, ShopConfig.Gamepasses.ExtraTankSlots)
	ownsGamepass(player.UserId, ShopConfig.Gamepasses.FasterHatching)
	ownsGamepass(player.UserId, ShopConfig.Gamepasses.VIPDecor)
end)

-- Inject VIP decor permission into economy service
EconomyService:InjectDecorPermissionCheck(function(userId, decorationId)
	if decorationId == "glow_coral" then
		return ownsGamepass(userId, ShopConfig.Gamepasses.VIPDecor)
	end
	return true
end)

MarketplaceService.ProcessReceipt = function(receipt)
	local player = Players:GetPlayerByUserId(receipt.PlayerId)
	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	local productId = receipt.ProductId
	-- Map product IDs to rewards
	local rewarded = false
	if productId == ShopConfig.DevProducts.EggBundle3 then
		local profile = ProfileManager:Get(player.UserId)
		if profile then
			profile.Currencies.Tickets += 300
			rewarded = true
		end
	elseif productId == ShopConfig.DevProducts.EggBundle5 then
		local profile = ProfileManager:Get(player.UserId)
		if profile then
			profile.Currencies.Tickets += 600
			rewarded = true
		end
	elseif productId == ShopConfig.DevProducts.EggBundle10 then
		local profile = ProfileManager:Get(player.UserId)
		if profile then
			profile.Currencies.Tickets += 1300
			rewarded = true
		end
	elseif productId == ShopConfig.DevProducts.TicketBoost then
		EconomyService:ApplyVisitBoost(player.UserId, 1.5, 10 * 60)
		rewarded = true
	elseif productId == ShopConfig.DevProducts.EventDecor then
		local profile = ProfileManager:Get(player.UserId)
		if profile and profile.Aquarium and profile.Aquarium.Tanks and profile.Aquarium.Tanks[1] then
			-- Grant glow_coral to first tank for simplicity
			local tank = profile.Aquarium.Tanks[1]
			tank.decorations = tank.decorations or {}
			table.insert(tank.decorations, "glow_coral")
			rewarded = true
		end
	end
	-- Invalidate gamepass cache for this user on any pass purchase
	if receipt.ProductType == Enum.ProductType.GamePass then
		OwnedGamepasses[receipt.PlayerId] = nil
	end
	return rewarded and Enum.ProductPurchaseDecision.PurchaseGranted or Enum.ProductPurchaseDecision.NotProcessedYet
end

