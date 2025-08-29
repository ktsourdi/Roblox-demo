-- Environment Setup: Creates a beautiful aquarium lobby with grass, decorations, etc.
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")

-- Clear existing baseplate if it exists
local baseplate = workspace:FindFirstChild("Baseplate")
if baseplate then baseplate:Destroy() end

-- Create main floor
local floor = Instance.new("Part")
floor.Name = "Floor"
floor.Size = Vector3.new(100, 1, 100)
floor.Position = Vector3.new(0, -0.5, 0)
floor.Anchored = true
floor.Material = Enum.Material.Concrete
floor.Color = Color3.fromRGB(180, 180, 180)
floor.Parent = workspace

-- Create grass areas around the edges
for i = 1, 20 do
	local grass = Instance.new("Part")
	grass.Name = "Grass"
	grass.Size = Vector3.new(8, 0.2, 8)
	grass.Position = Vector3.new(
		math.random(-45, 45),
		0.1,
		math.random(-45, 45)
	)
	grass.Anchored = true
	grass.Material = Enum.Material.Grass
	grass.Color = Color3.fromRGB(100, 180, 100)
	grass.Parent = workspace
	
	-- Add some flowers/plants on grass
	if math.random() > 0.5 then
		local plant = Instance.new("Part")
		plant.Name = "Plant"
		plant.Size = Vector3.new(0.5, 2, 0.5)
		plant.Position = grass.Position + Vector3.new(
			math.random(-3, 3),
			1,
			math.random(-3, 3)
		)
		plant.Anchored = true
		plant.Material = Enum.Material.Neon
		plant.Color = Color3.fromRGB(80, 200, 80)
		plant.Shape = Enum.PartType.Cylinder
		plant.Parent = workspace
	end
end

-- Create aquarium display area with nice floor pattern
local aquariumFloor = Instance.new("Part")
aquariumFloor.Name = "AquariumFloor"
aquariumFloor.Size = Vector3.new(40, 0.1, 20)
aquariumFloor.Position = Vector3.new(0, 0.05, 0)
aquariumFloor.Anchored = true
aquariumFloor.Material = Enum.Material.Marble
aquariumFloor.Color = Color3.fromRGB(220, 220, 255)
aquariumFloor.Parent = workspace

-- Create decorative walls/barriers
for i = 1, 4 do
	local wall = Instance.new("Part")
	wall.Name = "DecoWall"
	wall.Size = Vector3.new(2, 8, 0.5)
	wall.Anchored = true
	wall.Material = Enum.Material.Brick
	wall.Color = Color3.fromRGB(140, 100, 80)
	
	if i == 1 then wall.Position = Vector3.new(-25, 4, 0)
	elseif i == 2 then wall.Position = Vector3.new(25, 4, 0)
	elseif i == 3 then wall.Position = Vector3.new(0, 4, -15)
	else wall.Position = Vector3.new(0, 4, 15) end
	
	wall.Parent = workspace
end

-- Add some trees around the perimeter
for i = 1, 8 do
	local trunk = Instance.new("Part")
	trunk.Name = "TreeTrunk"
	trunk.Size = Vector3.new(1, 8, 1)
	trunk.Position = Vector3.new(
		math.random(-40, 40),
		4,
		math.random(-40, 40)
	)
	trunk.Anchored = true
	trunk.Material = Enum.Material.Wood
	trunk.Color = Color3.fromRGB(101, 67, 33)
	trunk.Parent = workspace
	
	-- Tree leaves
	local leaves = Instance.new("Part")
	leaves.Name = "TreeLeaves"
	leaves.Size = Vector3.new(6, 6, 6)
	leaves.Position = trunk.Position + Vector3.new(0, 6, 0)
	leaves.Anchored = true
	leaves.Material = Enum.Material.Grass
	leaves.Color = Color3.fromRGB(50, 150, 50)
	leaves.Shape = Enum.PartType.Ball
	leaves.Parent = workspace
end

-- Create a central fountain
local fountain = Instance.new("Part")
fountain.Name = "Fountain"
fountain.Size = Vector3.new(6, 3, 6)
fountain.Position = Vector3.new(0, 1.5, -25)
fountain.Anchored = true
fountain.Material = Enum.Material.Marble
fountain.Color = Color3.fromRGB(200, 200, 255)
fountain.Shape = Enum.PartType.Cylinder
fountain.Parent = workspace

-- Fountain water
local fountainWater = Instance.new("Part")
fountainWater.Name = "FountainWater"
fountainWater.Size = Vector3.new(5, 0.5, 5)
fountainWater.Position = fountain.Position + Vector3.new(0, 1, 0)
fountainWater.Anchored = true
fountainWater.Material = Enum.Material.ForceField
fountainWater.Color = Color3.fromRGB(100, 150, 255)
fountainWater.Transparency = 0.3
fountainWater.Parent = workspace

-- Add some benches for sitting
for i = 1, 6 do
	local bench = Instance.new("Part")
	bench.Name = "Bench"
	bench.Size = Vector3.new(4, 1, 1.5)
	bench.Position = Vector3.new(
		math.random(-30, 30),
		0.5,
		math.random(-30, 30)
	)
	bench.Anchored = true
	bench.Material = Enum.Material.Wood
	bench.Color = Color3.fromRGB(139, 69, 19)
	bench.Parent = workspace
end

-- Create tank display platforms (bigger for larger tanks)
for i = 1, 3 do
	local platform = Instance.new("Part")
	platform.Name = "TankPlatform" .. i
	platform.Size = Vector3.new(12, 1.5, 8)
	platform.Position = Vector3.new(i * 14 - 14, 0.75, 5)
	platform.Anchored = true
	platform.Material = Enum.Material.Concrete
	platform.Color = Color3.fromRGB(200, 200, 220)
	platform.Parent = workspace
	
	-- Add a sign above each platform
	local sign = Instance.new("Part")
	sign.Name = "TankSign" .. i
	sign.Size = Vector3.new(6, 3, 0.3)
	sign.Position = platform.Position + Vector3.new(0, 6, -4.5)
	sign.Anchored = true
	sign.Material = Enum.Material.Wood
	sign.Color = Color3.fromRGB(101, 67, 33)
	sign.Parent = workspace
	
	-- Sign text
	local surfaceGui = Instance.new("SurfaceGui")
	surfaceGui.Face = Enum.NormalId.Front
	surfaceGui.Parent = sign
	
	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "Tank " .. i
	textLabel.TextColor3 = Color3.new(1, 1, 1)
	textLabel.TextScaled = true
	textLabel.Font = Enum.Font.GothamBold
	textLabel.Parent = surfaceGui
end

-- Improve lighting for a nice aquarium atmosphere
lighting.Brightness = 1.5
lighting.OutdoorAmbient = Color3.fromRGB(100, 150, 200)
lighting.TimeOfDay = "14:00:00"

-- Add a skybox for better atmosphere
local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxassetid://12064107"
sky.SkyboxDn = "rbxassetid://12064152"
sky.SkyboxFt = "rbxassetid://12064121"
sky.SkyboxLf = "rbxassetid://12064115"
sky.SkyboxRt = "rbxassetid://12064131"
sky.SkyboxUp = "rbxassetid://12064140"
sky.Parent = lighting

print("🌿 Environment setup complete! Aquarium lobby created with grass, trees, fountain, and platforms.")
