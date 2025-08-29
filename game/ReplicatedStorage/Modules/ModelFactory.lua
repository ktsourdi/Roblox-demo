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
	
	-- Determine size based on tank type
	local tankSizes = {
		Small = {glass = Vector3.new(8, 6, 5), water = Vector3.new(7.6, 5.2, 4.6)},
		Medium = {glass = Vector3.new(10, 7, 6), water = Vector3.new(9.6, 6.2, 5.6)},
		Large = {glass = Vector3.new(12, 8, 7), water = Vector3.new(11.6, 7.2, 6.6)}
	}
	
	local size = tankSizes[sizeType] or tankSizes.Small
	
	-- Glass walls (transparent)
	local glass = Instance.new("Part")
	glass.Name = "Glass"
	glass.Anchored = true
	glass.Size = size.glass
	glass.Transparency = 0.7
	glass.Color = Color3.fromRGB(200, 220, 255)
	glass.Material = Enum.Material.Glass
	glass.CanCollide = false
	glass.Parent = model
	
	-- Water inside tank
	local water = Instance.new("Part")
	water.Name = "Water"
	water.Anchored = true
	water.Size = size.water
	water.Position = Vector3.new(0, -0.3, 0)
	water.Transparency = 0.6
	water.Color = Color3.fromRGB(100, 180, 255)
	water.Material = Enum.Material.ForceField
	water.CanCollide = false
	water.Parent = model
	
	-- Add glass frame for better visibility
	local frame = Instance.new("Part")
	frame.Name = "Frame"
	frame.Anchored = true
	frame.Size = Vector3.new(size.glass.X + 0.2, size.glass.Y + 0.2, size.glass.Z + 0.2)
	frame.Transparency = 0.3
	frame.Color = Color3.fromRGB(150, 150, 150)
	frame.Material = Enum.Material.Metal
	frame.CanCollide = false
	frame.Parent = model
	
	-- Set primary part for easier positioning
	model.PrimaryPart = glass
	
	return model
end

function ModelFactory.createFishModel(fish)
	-- Create a professional-looking fish model that always works
	local model = Instance.new("Model")
	model.Name = fish.name or "Fish"
	
	-- Fish body (main part) - elongated fish shape
	local body = Instance.new("Part")
	body.Name = "Body"
	body.Size = Vector3.new(2.4, 1.2, 0.8)
	body.Shape = Enum.PartType.Block
	body.Material = Enum.Material.Neon
	body.Color = rarityColors[fish.rarity or "Common"] or Color3.fromRGB(100, 150, 255)
	body.CanCollide = false
	body.Anchored = false
	body.TopSurface = Enum.SurfaceType.Smooth
	body.BottomSurface = Enum.SurfaceType.Smooth
	body.Parent = model
	
	-- Make body fish-shaped with sphere mesh
	local bodyMesh = Instance.new("SpecialMesh")
	bodyMesh.MeshType = Enum.MeshType.Sphere
	bodyMesh.Scale = Vector3.new(1, 0.65, 0.5)
	bodyMesh.Parent = body
	
	-- Always add fish parts for the best-looking fish
	-- Fish tail - large and impressive
	local tail = Instance.new("Part")
	tail.Name = "Tail"
	tail.Size = Vector3.new(0.6, 1.8, 0.3)
	tail.Shape = Enum.PartType.Block
	tail.Material = Enum.Material.Neon
	tail.Color = body.Color
	tail.CanCollide = false
	tail.Anchored = false
	tail.TopSurface = Enum.SurfaceType.Smooth
	tail.BottomSurface = Enum.SurfaceType.Smooth
	
	-- Triangle tail shape
	local tailMesh = Instance.new("SpecialMesh")
	tailMesh.MeshType = Enum.MeshType.Wedge
	tailMesh.Scale = Vector3.new(1, 1, 0.8)
	tailMesh.Parent = tail
	
	-- Attach tail to body
	local weld = Instance.new("WeldConstraint")
	weld.Part0 = body
	weld.Part1 = tail
	weld.Parent = body
	tail.CFrame = body.CFrame * CFrame.new(-1.5, 0, 0) * CFrame.Angles(0, math.rad(90), 0)
	tail.Parent = model
	
	-- Eyes - large and prominent
	local leftEye = Instance.new("Part")
	leftEye.Name = "LeftEye"
	leftEye.Size = Vector3.new(0.4, 0.4, 0.25)
	leftEye.Shape = Enum.PartType.Ball
	leftEye.Material = Enum.Material.Neon
	leftEye.Color = Color3.new(1, 1, 1)
	leftEye.CanCollide = false
	leftEye.Anchored = false
	
	-- Eye pupil
	local leftPupil = Instance.new("Part")
	leftPupil.Name = "LeftPupil"
	leftPupil.Size = Vector3.new(0.2, 0.2, 0.2)
	leftPupil.Shape = Enum.PartType.Ball
	leftPupil.Material = Enum.Material.Neon
	leftPupil.Color = Color3.new(0, 0, 0)
	leftPupil.CanCollide = false
	leftPupil.Anchored = false
	
	local rightEye = leftEye:Clone()
	rightEye.Name = "RightEye"
	local rightPupil = leftPupil:Clone()
	rightPupil.Name = "RightPupil"
	
	-- Weld eyes to body
	local leftWeld = Instance.new("WeldConstraint")
	leftWeld.Part0 = body
	leftWeld.Part1 = leftEye
	leftWeld.Parent = body
	
	local leftPupilWeld = Instance.new("WeldConstraint")
	leftPupilWeld.Part0 = leftEye
	leftPupilWeld.Part1 = leftPupil
	leftPupilWeld.Parent = leftEye
	
	local rightWeld = Instance.new("WeldConstraint")
	rightWeld.Part0 = body
	rightWeld.Part1 = rightEye
	rightWeld.Parent = body
	
	local rightPupilWeld = Instance.new("WeldConstraint")
	rightPupilWeld.Part0 = rightEye
	rightPupilWeld.Part1 = rightPupil
	rightPupilWeld.Parent = rightEye
	
	-- Position eyes at front of fish
	leftEye.CFrame = body.CFrame * CFrame.new(1, 0.4, 0.35)
	leftPupil.CFrame = leftEye.CFrame * CFrame.new(0.08, 0, 0)
	rightEye.CFrame = body.CFrame * CFrame.new(1, 0.4, -0.35)
	rightPupil.CFrame = rightEye.CFrame * CFrame.new(0.08, 0, 0)
	
	leftEye.Parent = model
	leftPupil.Parent = model
	rightEye.Parent = model
	rightPupil.Parent = model
	
	-- Add dorsal fin
	local topFin = Instance.new("Part")
	topFin.Name = "TopFin"
	topFin.Size = Vector3.new(0.3, 1.2, 0.15)
	topFin.Shape = Enum.PartType.Block
	topFin.Material = Enum.Material.Neon
	topFin.Color = body.Color
	topFin.CanCollide = false
	topFin.Anchored = false
	
	local topFinMesh = Instance.new("SpecialMesh")
	topFinMesh.MeshType = Enum.MeshType.Wedge
	topFinMesh.Scale = Vector3.new(0.7, 1, 1)
	topFinMesh.Parent = topFin
	
	local topFinWeld = Instance.new("WeldConstraint")
	topFinWeld.Part0 = body
	topFinWeld.Part1 = topFin
	topFinWeld.Parent = body
	topFin.CFrame = body.CFrame * CFrame.new(0, 0.8, 0) * CFrame.Angles(0, 0, math.rad(90))
	topFin.Parent = model
	
	-- Add side fins (pectoral fins)
	local leftSideFin = Instance.new("Part")
	leftSideFin.Name = "LeftFin"
	leftSideFin.Size = Vector3.new(0.8, 0.2, 0.1)
	leftSideFin.Shape = Enum.PartType.Block
	leftSideFin.Material = Enum.Material.Neon
	leftSideFin.Color = body.Color
	leftSideFin.CanCollide = false
	leftSideFin.Anchored = false
	
	local leftFinMesh = Instance.new("SpecialMesh")
	leftFinMesh.MeshType = Enum.MeshType.Wedge
	leftFinMesh.Parent = leftSideFin
	
	local rightSideFin = leftSideFin:Clone()
	rightSideFin.Name = "RightFin"
	
	-- Weld side fins
	local leftFinWeld = Instance.new("WeldConstraint")
	leftFinWeld.Part0 = body
	leftFinWeld.Part1 = leftSideFin
	leftFinWeld.Parent = body
	
	local rightFinWeld = Instance.new("WeldConstraint")
	rightFinWeld.Part0 = body
	rightFinWeld.Part1 = rightSideFin
	rightFinWeld.Parent = body
	
	-- Position side fins
	leftSideFin.CFrame = body.CFrame * CFrame.new(0.2, -0.2, 0.6) * CFrame.Angles(0, math.rad(30), math.rad(15))
	rightSideFin.CFrame = body.CFrame * CFrame.new(0.2, -0.2, -0.6) * CFrame.Angles(0, math.rad(-30), math.rad(-15))
	
	leftSideFin.Parent = model
	rightSideFin.Parent = model
	
	-- Set primary part for easy positioning
	model.PrimaryPart = body
	
	-- Scale fish based on rarity
	local rarityScales = {
		Common = 0.8,
		Rare = 1.0,
		Epic = 1.3,
		Legendary = 1.6,
		Mythic = 2.0
	}
	
	local scale = rarityScales[fish.rarity or "Common"] or 1.0
	
	-- Apply scale to all parts
	for _, part in pairs(model:GetChildren()) do
		if part:IsA("BasePart") then
			part.Size = part.Size * scale
		end
	end
	
	-- Add swimming physics
	local bodyPos = Instance.new("BodyPosition")
	bodyPos.MaxForce = Vector3.new(4000, 4000, 4000)
	bodyPos.D = 500
	bodyPos.P = 3000
	bodyPos.Position = body.Position
	bodyPos.Parent = body
	
	local bodyVel = Instance.new("BodyVelocity")
	bodyVel.MaxForce = Vector3.new(2000, 0, 2000)
	bodyVel.Velocity = Vector3.new(0, 0, 0)
	bodyVel.Parent = body
	
	-- Swimming behavior - keep within tank bounds if attributes exist
	task.spawn(function()
		while model.Parent and body.Parent do
			local center = Vector3.new(
				model:GetAttribute("SwimCenterX") or body.Position.X,
				model:GetAttribute("SwimCenterY") or body.Position.Y,
				model:GetAttribute("SwimCenterZ") or body.Position.Z
			)
			local half = Vector3.new(
				model:GetAttribute("SwimHalfX") or 3,
				model:GetAttribute("SwimHalfY") or 2,
				model:GetAttribute("SwimHalfZ") or 2
			)
			local function randHalf(h)
				return (math.random() * 2 - 1) * h
			end
			local target = Vector3.new(
				center.X + randHalf(half.X),
				center.Y + randHalf(half.Y),
				center.Z + randHalf(half.Z)
			)
			bodyPos.Position = target
			
			-- Random velocity for more natural movement
			bodyVel.Velocity = Vector3.new(
				math.random(-2, 2),
				0,
				math.random(-2, 2)
			)
			
			task.wait(math.random(2, 4))
		end
	end)
	
	-- Face movement direction
	local hb
	hb = game:GetService("RunService").Heartbeat:Connect(function()
		if not model.Parent or not body.Parent then 
			hb:Disconnect() 
			return 
		end
		
		local vel = bodyVel.Velocity
		if vel.Magnitude > 0.1 then
			local lookDirection = (body.Position + vel).Unit
			body.CFrame = CFrame.new(body.Position, body.Position + vel)
		end
	end)
	
	return model
end

return ModelFactory

