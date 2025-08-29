local Players = game:GetService("Players")

local EventsService = {}

local ProfileManager = nil

local DAILY_COINS = 100

local Codes = {
	FISHY = { Tickets = 500 },
	JELLY = { Coins = 250 },
}

local function isSameDay(t1, t2)
	local d1 = os.date("*t", t1)
	local d2 = os.date("*t", t2)
	return d1.year == d2.year and d1.yday == d2.yday
end

function EventsService:Init(profileManager)
	ProfileManager = profileManager
	Players.PlayerAdded:Connect(function(player)
		local profile = ProfileManager:Get(player.UserId)
		if not profile then return end
		local now = os.time()
		local last = profile.Stats.LastDailyLogin or 0
		if last == 0 or not isSameDay(now, last) then
			profile.Currencies.Coins += DAILY_COINS
			profile.Stats.LastDailyLogin = now
		end
	end)
end

function EventsService:RedeemCode(player, code)
	local profile = ProfileManager:Get(player.UserId)
	if not profile or not code then return end
	code = string.upper(code)
	local redeemed = profile.Stats.RedeemedCodes or {}
	if redeemed[code] then return end
	local reward = Codes[code]
	if not reward then return end
	if reward.Tickets then
		profile.Currencies.Tickets += reward.Tickets
	end
	if reward.Coins then
		profile.Currencies.Coins += reward.Coins
	end
	redeemed[code] = true
	profile.Stats.RedeemedCodes = redeemed
end

return EventsService

