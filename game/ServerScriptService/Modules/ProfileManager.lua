-- ProfileManager: wraps ProfileService-like behavior using DataStoreService for MVP
local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ProfileManager = {}

local ProfileStore = DataStoreService:GetDataStore("AquariumProfiles_v1")

local ProfileTemplate = {
	Currencies = { Tickets = 250, Coins = 500 },
	Inventory = { Fish = {}, Decorations = {} },
	Aquarium = { Tanks = { { type = "Small", slots = {}, decorations = {} } }, Rating = 0 },
	Stats = { Likes = 0, TicketsEarnedLifetime = 0, LastDailyLogin = 0, LikedBy = {}, RedeemedCodes = {}, Onboarding = { Shop = false, Inventory = false, Decor = false, Friends = false } },
}

local activeProfiles = {}

local AUTOSAVE_INTERVAL = 120 -- seconds

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

-- Remove ephemeral/internal keys (e.g., fields starting with "_") to avoid
-- persisting runtime-only data into DataStores. Applies recursively.
local function sanitizeForSave(tbl)
	if type(tbl) ~= "table" then return tbl end
	local out = {}
	for k, v in pairs(tbl) do
		local isInternal = (type(k) == "string" and string.sub(k, 1, 1) == "_")
		if not isInternal then
			if type(v) == "table" then
				out[k] = sanitizeForSave(v)
			else
				out[k] = v
			end
		end
	end
	return out
end

local function mergeTemplate(saved, template)
	local out = deepCopy(template)
	if type(saved) ~= "table" then
		return out
	end
	for k, v in pairs(saved) do
		if type(v) == "table" and type(out[k]) == "table" then
			out[k] = mergeTemplate(v, out[k])
		else
			out[k] = v
		end
	end
	return out
end

function ProfileManager:Get(userId)
	return activeProfiles[userId]
end

function ProfileManager:GetAll()
	return activeProfiles
end

function ProfileManager:LoadAsync(player)
	local userId = player.UserId
	local key = tostring(userId)
	local success, data = pcall(function()
		return ProfileStore:GetAsync(key)
	end)
	if not success then
		warn("Failed to load profile for", userId, data)
		data = nil
	end
	local profile = mergeTemplate(data, ProfileTemplate)
	-- Ensure any stray internal keys from previous saves are removed at load.
	profile = mergeTemplate(sanitizeForSave(profile), ProfileTemplate)
	activeProfiles[userId] = profile
	return profile
end

function ProfileManager:SaveAsync(userId)
	local profile = activeProfiles[userId]
	if not profile then return end
	local key = tostring(userId)
	-- Store a sanitized copy to keep the DataStore clean of runtime-only fields
	local payload = sanitizeForSave(profile)
	local success, err = pcall(function()
		ProfileStore:SetAsync(key, payload)
	end)
	if not success then
		warn("Failed to save profile for", userId, err)
	end
end

function ProfileManager:Release(userId)
	self:SaveAsync(userId)
	activeProfiles[userId] = nil
end

Players.PlayerAdded:Connect(function(player)
	ProfileManager:LoadAsync(player)
end)

Players.PlayerRemoving:Connect(function(player)
	ProfileManager:Release(player.UserId)
end)

game:BindToClose(function()
	for userId, _ in pairs(activeProfiles) do
		ProfileManager:SaveAsync(userId)
	end
end)

-- Periodic autosave loop (server only)
if RunService:IsServer() then
	task.spawn(function()
		while true do
			task.wait(AUTOSAVE_INTERVAL)
			for userId, _ in pairs(activeProfiles) do
				ProfileManager:SaveAsync(userId)
			end
		end
	end)
end

return ProfileManager

