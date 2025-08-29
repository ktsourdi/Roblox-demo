-- Fish Test Spawner: Creates professional fish models to verify the NEW system works
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

-- Wait for ModelFactory to load
task.wait(3)

local ModelFactory = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ModelFactory"))

print("🧹 CLEARING all old fish models...")

-- Clear ALL existing fish models first
for _, obj in pairs(workspace:GetChildren()) do
	if obj:IsA("Model") and (
		obj.Name:find("Fish") or 
		obj.Name:find("Test") or 
		obj.Name:find("fish") or
		obj.Name:find("test")
	) then
		obj:Destroy()
		print("🗑️ Removed old model: " .. obj.Name)
	end
end

print("🐠 Spawning NEW PROFESSIONAL fish models...")

-- Create BETTER test fish with all rarities
local testFish = {
	{name = "Common Goldfish", rarity = "Common"},
	{name = "Rare Angelfish", rarity = "Rare"},
	{name = "Epic Shark", rarity = "Epic"},
	{name = "Legendary Whale", rarity = "Legendary"},
	{name = "Mythic Dragon", rarity = "Mythic"},
	{name = "Common Guppy", rarity = "Common"}
}

for i, fish in ipairs(testFish) do
	local fishModel = ModelFactory.createFishModel(fish)
	
	-- Pick target tank (spread across 3 tanks)
	local tankIndex = ((i-1) % 3) + 1
	local tank = workspace:FindFirstChild("Tank" .. tankIndex)
	
	-- Default world fallback (in case tank not yet created)
	local spawnCFrame = CFrame.new((tankIndex-1) * 14 - 14, 6, 5)
	local swimCenter, swimHalf
	
	if tank then
		-- Use the tank's water volume to bound the fish
		local water = tank:FindFirstChild("Water")
		if water and water:IsA("BasePart") then
			-- Center is the water's world position, half extents from its size
			local half = water.Size * 0.5
			-- Leave a padding so fish never clip the glass
			local padding = Vector3.new(0.6, 0.6, 0.6)
			swimHalf = Vector3.new(
				math.max(half.X - padding.X, 0.5),
				math.max(half.Y - padding.Y, 0.5),
				math.max(half.Z - padding.Z, 0.5)
			)
			swimCenter = water.Position
			spawnCFrame = CFrame.new(swimCenter + Vector3.new(
				(math.random() * 2 - 1) * (swimHalf.X * 0.6),
				0,
				(math.random() * 2 - 1) * (swimHalf.Z * 0.6)
			))
		end
	end
	
	-- Apply initial transform
	if fishModel.PrimaryPart then
		fishModel:SetPrimaryPartCFrame(spawnCFrame)
	else
		fishModel:MoveTo(spawnCFrame.Position)
	end
	
	-- Set swim bounds via attributes (used by ModelFactory behavior)
	if swimCenter and swimHalf then
		fishModel:SetAttribute("SwimCenterX", swimCenter.X)
		fishModel:SetAttribute("SwimCenterY", swimCenter.Y)
		fishModel:SetAttribute("SwimCenterZ", swimCenter.Z)
		fishModel:SetAttribute("SwimHalfX", swimHalf.X)
		fishModel:SetAttribute("SwimHalfY", swimHalf.Y)
		fishModel:SetAttribute("SwimHalfZ", swimHalf.Z)
	end
	
	-- Parent fish beneath the tank for organization (fallback to workspace)
	fishModel.Parent = tank or workspace
	fishModel.Name = "ProfessionalFish_" .. i
	
	print("✅ Spawned " .. fish.rarity .. " fish '" .. fish.name .. "' in Tank " .. tankIndex)
end

print("🎣 NEW PROFESSIONAL FISH SPAWNED! Check the tanks now!")
