local BadgeService = game:GetService("BadgeService")

local BadgesService = {}

BadgesService.BadgeIds = {
	FirstHatch = 0,
	MythicHatch = 0,
	Rating10 = 0,
	Rating25 = 0,
	Rating50 = 0,
}

local function tryAward(player, badgeId)
	if type(badgeId) ~= "number" or badgeId <= 0 then return end
	local ok, has = pcall(function()
		return BadgeService:UserHasBadgeAsync(player.UserId, badgeId)
	end)
	if ok and not has then
		pcall(function()
			BadgeService:AwardBadge(player.UserId, badgeId)
		end)
	end
end

function BadgesService:OnHatch(player, rarity)
	tryAward(player, self.BadgeIds.FirstHatch)
	if rarity == "Mythic" then
		tryAward(player, self.BadgeIds.MythicHatch)
	end
end

function BadgesService:OnRating(player, rating)
	if rating >= 50 then
		tryAward(player, self.BadgeIds.Rating50)
	elseif rating >= 25 then
		tryAward(player, self.BadgeIds.Rating25)
	elseif rating >= 10 then
		tryAward(player, self.BadgeIds.Rating10)
	end
end

return BadgesService

