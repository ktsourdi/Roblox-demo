local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local FishData = require(ServerStorage:WaitForChild("FishData"))
local DecorationsData = require(ServerStorage:WaitForChild("Decorations"))
local TankData = require(ServerStorage:WaitForChild("TankData"))

local EconomyService = {}

local ProfileManager = nil

local visitBoostByUserId = {}

function EconomyService:Init(profileManager)
	ProfileManager = profileManager
	RunService.Heartbeat:Connect(function(step)
		self:_tick(step)
	end)
end

function EconomyService:ApplyVisitBoost(userId, multiplier, durationSeconds)
	visitBoostByUserId[userId] = {
		expiresAt = os.time() + durationSeconds,
		multiplier = multiplier,
	}
end

local function calcDecorationMultiplier(decoIds)
	local mult = 1
	for _, decoId in ipairs(decoIds or {}) do
		for _, item in ipairs(DecorationsData.Items) do
			if item.id == decoId then
				mult *= item.multiplier
				break
			end
		end
	end
	return mult
end

local function sumFishRates(fishArray)
	local total = 0
	for _, fish in ipairs(fishArray or {}) do
		local rarity = fish.rarity or "Common"
		total += (FishData.BaseRates[rarity] or 0)
	end
	return total
end

function EconomyService:_computeTicketsPerMinute(profile)
	local tpm = 0
	for _, tank in ipairs(profile.Aquarium.Tanks) do
		local base = sumFishRates(tank.slots)
		local decoMult = calcDecorationMultiplier(tank.decorations)
		local tType = TankData.Types[tank.type] or { capacityScaler = 1 }
		tpm += base * decoMult * (tType.capacityScaler or 1)
	end
	local boost = 1
	local uid = profile._UserId
	local boostInfo = uid and visitBoostByUserId[uid]
	if boostInfo and boostInfo.expiresAt > os.time() then
		boost = boostInfo.multiplier
	else
		visitBoostByUserId[uid] = nil
	end
	return tpm * boost
end

local accumulator = {}

function EconomyService:_tick(delta)
	for userId, profile in pairs(ProfileManager and ProfileManager:GetAll() or {}) do
		profile._UserId = userId
		local tpm = self:_computeTicketsPerMinute(profile)
		local tps = tpm / 60
		accumulator[userId] = (accumulator[userId] or 0) + delta * tps
		if accumulator[userId] >= 1 then
			local whole = math.floor(accumulator[userId])
			accumulator[userId] -= whole
			profile.Currencies.Tickets += whole
			profile.Stats.TicketsEarnedLifetime += whole
			-- update lifetime tickets leaderboard if present
			if self._LeaderboardService then
				self._LeaderboardService:UpdateTickets(userId, profile.Stats.TicketsEarnedLifetime)
			end
		end
	end
end

-- Placement API (MVP): place a fish by inventory index into a tank
function EconomyService:PlaceFish(userId, tankIndex, fishIndex)
	local profile = ProfileManager:Get(userId)
	if not profile then return false end
	local tank = profile.Aquarium.Tanks[tankIndex]
	local fish = profile.Inventory.Fish[fishIndex]
	if not tank or not fish then return false end
	local tType = TankData.Types[tank.type]
	if #tank.slots >= tType.slots then return false end
	table.insert(tank.slots, fish)
	table.remove(profile.Inventory.Fish, fishIndex)
	return true
end

-- Expose internals to other modules in MVP
function EconomyService:_setProfileManager(pm)
	ProfileManager = pm
end

function EconomyService:InjectLeaderboards(service)
	self._LeaderboardService = service
end

return EconomyService

