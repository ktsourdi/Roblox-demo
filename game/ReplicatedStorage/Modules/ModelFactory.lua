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
	
	-- Glass walls (transparent)
	local glass = Instance.new("Part")
	glass.Name = "Glass"
	glass.Anchored = true
	glass.Size = Vector3.new(6, 4, 3)
	glass.Transparency = 0.8
	glass.Color = Color3.fromRGB(200, 220, 255)
	glass.Material = Enum.Material.Glass
	glass.CanCollide = false
	glass.Parent = model
	
	-- Water inside tank
	local water = Instance.new("Part")
	water.Name = "Water"
	water.Anchored = true
	water.Size = Vector3.new(5.6, 3.2, 2.6)
	water.Position = Vector3.new(0, -0.2, 0)
	water.Transparency = 0.7
	water.Color = Color3.fromRGB(100, 180, 255)
	water.Material = Enum.Material.ForceField
	water.CanCollide = false
	water.Parent = model
	
	return model
end

function ModelFactory.createFishModel(fish)
	-- Try to find a pre-made MeshPart inside ReplicatedStorage/FishModels
	local FishModels = ReplicatedStorage:WaitForChild("FishModels", 5)
	local template = FishModels and FishModels:FindFirstChild(fish.id)

	local mesh
	if template and template:IsA("MeshPart") then
		mesh = template:Clone()
	else
		-- Fallback: create a MeshPart from ids stored in FishData
		mesh = Instance.new("MeshPart")
		mesh.MeshId    = fish.meshId and ("rbxassetid://" .. tostring(fish.meshId)) or ""
		mesh.TextureID = fish.textureId and ("rbxassetid://" .. tostring(fish.textureId)) or ""
		mesh.Size      = Vector3.new(1.6, 1.0, 0.6)
	end

	mesh.Name       = fish.name or "Fish"
	mesh.Anchored   = false
	mesh.CanCollide = false
	mesh.CastShadow = false

	-- Physics objects for idle swimming -----------------------------------
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.MaxForce = Vector3.new(4e3, 4e3, 4e3)
	bodyPos.D = 250
	bodyPos.P = 1000
	bodyPos.Parent = mesh

	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce = Vector3.new(4e3, 0, 4e3)
	bodyVel.Velocity = Vector3.new()
	bodyVel.Parent   = mesh

	-- Wander loop to keep fish moving gently
	task.spawn(function()
		while mesh.Parent do
			bodyPos.Position = mesh.Position + Vector3.new(math.random(-2,2), math.random(-1,1), math.random(-2,2))
			bodyVel.Velocity = Vector3.new(math.random(-1,1), 0, math.random(-1,1))
			task.wait(math.random(4,7))
		end
	end)

	-- Face velocity
	local hb
	hb = game:GetService("RunService").Heartbeat:Connect(function()
		if not mesh.Parent then hb:Disconnect() return end
		local v = bodyVel.Velocity
		if v.Magnitude > 0.05 then
			mesh.CFrame = CFrame.new(mesh.Position, mesh.Position + v)
		end
	end)

	return mesh
end

return ModelFactory

