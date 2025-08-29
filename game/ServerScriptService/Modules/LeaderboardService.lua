local DataStoreService = game:GetService("DataStoreService")

local LeaderboardService = {}

local LikesODS = DataStoreService:GetOrderedDataStore("AquariumLikes_v1")
local TicketsODS = DataStoreService:GetOrderedDataStore("AquariumTickets_v1")

function LeaderboardService:UpdateLikes(userId, likes)
	pcall(function()
		LikesODS:SetAsync(tostring(userId), likes)
	end)
end

function LeaderboardService:UpdateTickets(userId, tickets)
	pcall(function()
		TicketsODS:SetAsync(tostring(userId), tickets)
	end)
end

return LeaderboardService

