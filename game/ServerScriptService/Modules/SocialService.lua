local SocialService = {}

local ProfileManager = nil
local LeaderboardService = nil

function SocialService:Init(profileManager, leaderboardService)
	ProfileManager = profileManager
	LeaderboardService = leaderboardService
end

function SocialService:HandleLike(fromPlayer, targetUserId)
	if not fromPlayer or not targetUserId then return end
	if fromPlayer.UserId == targetUserId then return end
	local targetProfile = ProfileManager:Get(targetUserId)
	if not targetProfile then return end
	local likedBy = targetProfile.Stats.LikedBy or {}
	local key = tostring(fromPlayer.UserId)
	if likedBy[key] then return end

	likedBy[key] = true
	targetProfile.Stats.LikedBy = likedBy
	targetProfile.Stats.Likes = (targetProfile.Stats.Likes or 0) + 1

	if LeaderboardService then
		LeaderboardService:UpdateLikes(targetUserId, targetProfile.Stats.Likes)
	end
end

return SocialService

