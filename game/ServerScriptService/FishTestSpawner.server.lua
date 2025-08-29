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
	
	-- Position in tanks (spread across 3 tanks)
	local tankIndex = ((i-1) % 3) + 1
	local x = (tankIndex-1) * 14 - 14  -- Tank positions: -14, 0, 14
	local y = 6 + math.random(0, 2)    -- Height within tank
	local z = 5 + math.random(-3, 3)   -- Random position in tank
	
	if fishModel.PrimaryPart then
		fishModel:SetPrimaryPartCFrame(CFrame.new(x, y, z))
	else
		fishModel:MoveTo(Vector3.new(x, y, z))
	end
	
	fishModel.Parent = workspace
	fishModel.Name = "ProfessionalFish_" .. i
	
	print("✅ Spawned " .. fish.rarity .. " fish '" .. fish.name .. "' in Tank " .. tankIndex)
end

print("🎣 NEW PROFESSIONAL FISH SPAWNED! Check the tanks now!")
