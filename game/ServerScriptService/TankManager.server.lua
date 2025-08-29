-- Tank Manager: Creates and manages physical aquarium tanks in the world
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local ModelFactory = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ModelFactory"))

-- Create physical tanks on the platforms
local function createTanks()
	local tankTypes = {"Small", "Medium", "Large"}
	
	for i = 1, 3 do
		local platform = workspace:FindFirstChild("TankPlatform" .. i)
		if platform then
			local tankType = tankTypes[i] or "Small"
			local tank = ModelFactory.createTankModel(tankType)
			tank:SetPrimaryPartCFrame(CFrame.new(
				platform.Position.X,
				platform.Position.Y + 4, -- above platform (higher for bigger tanks)
				platform.Position.Z
			))
			tank.Parent = workspace
			tank.Name = "Tank" .. i
			
			-- Add a subtle glow effect to make tanks more appealing
			for _, part in pairs(tank:GetChildren()) do
				if part:IsA("BasePart") and part.Name == "Water" then
					local pointLight = Instance.new("PointLight")
					pointLight.Color = Color3.fromRGB(100, 200, 255)
					pointLight.Brightness = 0.5
					pointLight.Range = 10
					pointLight.Parent = part
				end
			end
		end
	end
end

-- Wait a moment for environment to load, then create tanks
task.wait(1)
createTanks()

print("🐠 Tank Manager: Physical aquarium tanks created on platforms!")
