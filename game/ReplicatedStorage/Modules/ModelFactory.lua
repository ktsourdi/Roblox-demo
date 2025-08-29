local ModelFactory = {}

local rarityColors = {
	Common = Color3.fromRGB(180, 200, 220),
	Rare = Color3.fromRGB(100, 160, 255),
	Epic = Color3.fromRGB(180, 100, 255),
	Legendary = Color3.fromRGB(255, 170, 60),
	Mythic = Color3.fromRGB(255, 60, 120),
}

function ModelFactory.createTankModel(sizeType)
	local model = Instance.new("Model")
	model.Name = sizeType .. "Tank"
	local base = Instance.new("Part")
	base.Name = "Glass"
	base.Anchored = true
	base.Size = Vector3.new(6, 4, 3)
	base.Transparency = 0.5
	base.Color = Color3.fromRGB(80, 120, 200)
	base.Parent = model
	local water = Instance.new("Part")
	water.Name = "Water"
	water.Anchored = true
	water.Size = Vector3.new(5.8, 3.6, 2.8)
	water.Position = Vector3.new(0, 0.2, 0)
	water.Transparency = 0.6
	water.Color = Color3.fromRGB(60, 150, 220)
	water.Material = Enum.Material.Glass
	water.Parent = model
	return model
end

function ModelFactory.createFishModel(fish)
	local model = Instance.new("Model")
	model.Name = fish.name or "Fish"
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(0.8, 0.4, 0.2)
	body.Shape = Enum.PartType.Block
	body.Material = Enum.Material.SmoothPlastic
	body.Color = rarityColors[fish.rarity or "Common"] or Color3.new(1, 1, 1)
	body.CanCollide = false
	body.Anchored = true
	body.Parent = model
	local fin = Instance.new("Part")
	fin.Name = "Fin"
	fin.Size = Vector3.new(0.2, 0.2, 0.05)
	fin.Color = Color3.fromRGB(255, 255, 255)
	fin.Material = Enum.Material.SmoothPlastic
	fin.CanCollide = false
	fin.Anchored = true
	fin.Parent = model
	return model
end

return ModelFactory

