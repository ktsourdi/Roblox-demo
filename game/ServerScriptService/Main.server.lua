local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")

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
		}
	}
	return out
end

local limiter = RateLimiter.new(2, 5)

Remotes.GetProfile.OnServerInvoke = function(player)
	if not limiter:allow("GetProfile:" .. player.UserId, 1, 4) then return nil end
	local profile = ProfileManager:Get(player.UserId)
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

-- Shop/config info
local ServerStorage = game:GetService("ServerStorage")
local ShopConfig = require(ServerStorage:WaitForChild("ShopConfig"))
local Decorations = require(ServerStorage:WaitForChild("Decorations"))
Remotes.GetShop.OnServerInvoke = function(player)
	if not limiter:allow("GetShop:" .. player.UserId, 1, 3) then return nil end
	return {
		Eggs = ShopConfig.Eggs,
		Decorations = Decorations.Items,
	}
end

