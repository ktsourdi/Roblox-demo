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

-- Inject dependencies
ShopService:Init(ProfileManager, BadgesService)
EconomyService:Init(ProfileManager)
SocialService:Init(ProfileManager, LeaderboardService)
EventsService:Init(ProfileManager)
EconomyService:InjectLeaderboards(LeaderboardService)

-- Remote wiring for placement
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
Remotes.PlaceFish.OnServerEvent:Connect(function(player, tankIndex, fishIndex)
	EconomyService:PlaceFish(player.UserId, tankIndex, fishIndex)
end)

-- Simple social visit boost MVP
Remotes.VisitBoost.OnServerEvent:Connect(function(player, targetUserId)
	local BOOST = 1.25
	local DURATION = 5 * 60
	EconomyService:ApplyVisitBoost(player.UserId, BOOST, DURATION)
	EconomyService:ApplyVisitBoost(targetUserId, BOOST, DURATION)
end)

Remotes.LikeAquarium.OnServerEvent:Connect(function(player, targetUserId)
	SocialService:HandleLike(player, targetUserId)
end)

Remotes.RedeemCode.OnServerEvent:Connect(function(player, code)
	EventsService:RedeemCode(player, code)
end)

