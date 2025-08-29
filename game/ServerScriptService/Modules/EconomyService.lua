local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local FishData = require(ServerStorage:WaitForChild("FishData"))
local DecorationsData = require(ServerStorage:WaitForChild("Decorations"))
local TankData = require(ServerStorage:WaitForChild("TankData"))

local EconomyService = {}

local ProfileManager = nil
local BadgesService = nil

local visitBoostByUserId = {}

-- optional injected checks
function EconomyService:InjectDecorPermissionCheck(callback)
	self._CanUseDecor = callback
end

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
	if type(tankIndex) ~= "number" or type(fishIndex) ~= "number" then return false end
	local tanks = profile.Aquarium and profile.Aquarium.Tanks
	local inv = profile.Inventory and profile.Inventory.Fish
	if type(tanks) ~= "table" or type(inv) ~= "table" then return false end
	if tankIndex < 1 or tankIndex > #tanks then return false end
	if fishIndex < 1 or fishIndex > #inv then return false end
	local tank = tanks[tankIndex]
	local fish = inv[fishIndex]
	if not tank or not fish then return false end
	local tType = TankData.Types[tank.type]
	if not tType then return false end
	if #tank.slots >= tType.slots then return false end
	
	-- Create visual fish model in the game world
	local ModelFactory = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ModelFactory"))
	local fishModel = ModelFactory.createFishModel(fish)
	
	-- Position fish inside tank water on the proper platform (updated for bigger tanks)
	local tankPosition = Vector3.new(tankIndex * 14 - 14, 5, 5) -- align with new tank platforms
	local spawnPosition = CFrame.new(
		tankPosition.X + math.random(-3, 3), -- wider range for bigger tanks
		tankPosition.Y + math.random(0, 3),  -- more vertical space
		tankPosition.Z + math.random(-2, 2)  -- more depth
	)
	
	-- Use SetPrimaryPartCFrame since fishModel is now a Model
	if fishModel.PrimaryPart then
		fishModel:SetPrimaryPartCFrame(spawnPosition)
	else
		-- Fallback if no PrimaryPart
		fishModel:MoveTo(spawnPosition.Position)
	end
	
	-- Parent to workspace so it's visible
	fishModel.Parent = game.Workspace
	
	table.insert(tank.slots, fish)
	table.remove(inv, fishIndex)
	return true
end

-- Decorations: purchase and place into a tank; updates rating
function EconomyService:PlaceDecoration(userId, tankIndex, decorationId)
	local profile = ProfileManager:Get(userId)
	if not profile then return false end
	local tank = profile.Aquarium.Tanks[tankIndex]
	if not tank then return false end
	local item
	for _, deco in ipairs(DecorationsData.Items) do
		if deco.id == decorationId then item = deco break end
	end
	if not item then return false end
	-- VIP-only enforcement
	if item.vipOnly and self._CanUseDecor and not self._CanUseDecor(userId, decorationId) then
		return false
	end
	local price = item.price or 0
	if (profile.Currencies.Coins or 0) < price then return false end
	profile.Currencies.Coins -= price
	tank.decorations = tank.decorations or {}
	table.insert(tank.decorations, decorationId)
	-- update rating and trigger badge checks
	local rating = 0
	for _, t in ipairs(profile.Aquarium.Tanks) do
		for _, dId in ipairs(t.decorations or {}) do
			for _, d in ipairs(DecorationsData.Items) do
				if d.id == dId then
					rating += (d.rating or 0)
					break
				end
			end
		end
	end
	profile.Aquarium.Rating = rating
	if BadgesService then
		local player = game:GetService("Players"):GetPlayerByUserId(userId)
		if player then
			BadgesService:OnRating(player, rating)
		end
	end
	return true
end

-- Expose internals to other modules in MVP
function EconomyService:_setProfileManager(pm)
	ProfileManager = pm
end

function EconomyService:InjectLeaderboards(service)
	self._LeaderboardService = service
end

function EconomyService:InjectBadges(service)
	BadgesService = service
end

return EconomyService

