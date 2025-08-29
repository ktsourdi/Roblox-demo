-- Ambient Effects: Adds particles, sounds, and atmosphere to the aquarium lobby
local workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

-- Add bubble effects to fountain
local function addFountainBubbles()
	local fountain = workspace:FindFirstChild("FountainWater")
	if fountain then
		local attachment = Instance.new("Attachment")
		attachment.Parent = fountain
		
		local bubbles = Instance.new("ParticleEmitter")
		bubbles.Parent = attachment
		bubbles.Texture = "rbxassetid://241650934" -- Bubble texture
		bubbles.Lifetime = NumberRange.new(3, 5)
		bubbles.Rate = 20
		bubbles.SpreadAngle = Vector2.new(45, 45)
		bubbles.Speed = NumberRange.new(2, 4)
		bubbles.VelocityInheritance = 0
		bubbles.Color = ColorSequence.new(Color3.fromRGB(150, 200, 255))
		bubbles.Size = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.2),
			NumberSequenceKeypoint.new(0.5, 0.5),
			NumberSequenceKeypoint.new(1, 0.1)
		}
		bubbles.Transparency = NumberSequence.new{
			NumberSequenceKeypoint.new(0, 0.3),
			NumberSequenceKeypoint.new(1, 1)
		}
	end
end

-- Add gentle swaying to plants
local function animatePlants()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Plant" then
			local tween = TweenService:Create(
				obj,
				TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
				{Rotation = Vector3.new(0, 15, 0)}
			)
			tween:Play()
		end
	end
end

-- Add floating particles around trees
local function addTreeParticles()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "TreeLeaves" then
			local attachment = Instance.new("Attachment")
			attachment.Parent = obj
			
			local leaves = Instance.new("ParticleEmitter")
			leaves.Parent = attachment
			leaves.Texture = "rbxassetid://241650934"
			leaves.Lifetime = NumberRange.new(8, 12)
			leaves.Rate = 2
			leaves.SpreadAngle = Vector2.new(360, 180)
			leaves.Speed = NumberRange.new(0.5, 2)
			leaves.Acceleration = Vector3.new(0, -2, 0)
			leaves.Color = ColorSequence.new(Color3.fromRGB(100, 200, 100))
			leaves.Size = NumberSequence.new(0.3)
			leaves.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0.5),
				NumberSequenceKeypoint.new(1, 1)
			}
		end
	end
end

-- Add ambient water sounds
local function addAmbientSounds()
	local sound = Instance.new("Sound")
	sound.Name = "AmbientWater"
	sound.SoundId = "rbxassetid://131961136" -- Water ambient sound
	sound.Volume = 0.3
	sound.Looped = true
	sound.Parent = workspace
	sound:Play()
end

-- Add glowing effects to benches at night
local function addBenchGlow()
	for _, obj in pairs(workspace:GetChildren()) do
		if obj.Name == "Bench" then
			local pointLight = Instance.new("PointLight")
			pointLight.Color = Color3.fromRGB(255, 200, 100)
			pointLight.Brightness = 0.3
			pointLight.Range = 8
			pointLight.Parent = obj
		end
	end
end

-- Wait for environment to load, then add effects
task.wait(2)
addFountainBubbles()
animatePlants()
addTreeParticles()
addAmbientSounds()
addBenchGlow()

print("✨ Ambient Effects: Particles, sounds, and atmosphere added to aquarium lobby!")
