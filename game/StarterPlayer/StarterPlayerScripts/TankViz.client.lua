-- DISABLED: This script was creating duplicate tanks - now handled by TankManager.server.lua
return

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")
local ModelFactory = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("ModelFactory"))

local function fetchProfile()
	local ok, data = pcall(function()
		return Remotes.GetProfile:InvokeServer()
	end)
	if ok then return data end
	return nil
end

-- Minimal tank models with fish
local root = Instance.new("Folder")
root.Name = "TankViz"
root.Parent = Workspace

local function clearChildren()
	for _, c in ipairs(root:GetChildren()) do c:Destroy() end
end

local function animateFish(part, baseCFrame, offset)
	task.spawn(function()
		local t = math.random()
		while part.Parent do
			t += 0.03
			local y = math.sin(t * 2) * 0.2
			local x = math.sin(t + offset) * 0.3
			part.CFrame = baseCFrame * CFrame.new(x, y, 0)
			task.wait(0.05)
		end
	end)
end

local function rebuild()
	clearChildren()
	local profile = fetchProfile()
	if not profile or not profile.Aquarium then return end
	local tanks = profile.Aquarium.Tanks or {}
	for idx, tank in ipairs(tanks) do
		local model = ModelFactory.createTankModel(tank.type or "Small")
		model.Parent = root
		local basePos = Vector3.new(0 + (idx - 1) * 10, 3, 0)
		for _, p in ipairs(model:GetChildren()) do
			if p:IsA("BasePart") then
				p.CFrame = CFrame.new(basePos + Vector3.new(0, 0, 0))
			end
		end
		for s, fish in ipairs(tank.slots or {}) do
			local fishModel = ModelFactory.createFishModel(fish)
			fishModel.Parent = model
			local body = fishModel:FindFirstChild("Body")
			local fin = fishModel:FindFirstChild("Fin")
			local slotOffset = Vector3.new(-3 + (s - 1) * 0.8, 4.5, 0)
			local cf = CFrame.new(basePos + slotOffset)
			if body then
				body.CFrame = cf
				animateFish(body, cf, s * 0.7)
			end
			if fin and body then
				fin.CFrame = body.CFrame * CFrame.new(0.45, 0, 0)
			end
		end
	end
end

rebuild()

-- Refresh periodically
task.spawn(function()
	while true do
		task.wait(5)
		rebuild()
	end
end)
