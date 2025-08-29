local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local function fetchProfile()
	local ok, data = pcall(function()
		return Remotes.GetProfile:InvokeServer()
	end)
	if ok then return data end
	return nil
end

-- Minimal tank model: a transparent box with billboards for fish
local root = Instance.new("Folder")
root.Name = "TankViz"
root.Parent = Workspace

local function clearChildren()
	for _, c in ipairs(root:GetChildren()) do c:Destroy() end
end

local function makeBillboard(text, cf)
	local part = Instance.new("Part")
	part.Size = Vector3.new(1, 1, 1)
	part.CFrame = cf
	part.Anchored = true
	part.Transparency = 1
	part.CanCollide = false
	part.Parent = root

	local bb = Instance.new("BillboardGui")
	bb.Size = UDim2.new(0, 100, 0, 24)
	bb.Adornee = part
	bb.AlwaysOnTop = true
	bb.Parent = part

	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(1, 0, 1, 0)
	lbl.BackgroundTransparency = 0.2
	lbl.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
	lbl.TextColor3 = Color3.new(1, 1, 1)
	lbl.TextSize = 14
	lbl.Font = Enum.Font.Gotham
	lbl.Text = text
	lbl.Parent = bb

	return part
end

local function rebuild()
	clearChildren()
	local profile = fetchProfile()
	if not profile or not profile.Aquarium then return end
	local tanks = profile.Aquarium.Tanks or {}
	for idx, tank in ipairs(tanks) do
		local basePos = Vector3.new(0 + (idx - 1) * 8, 3, 0)
		-- tank box
		local box = Instance.new("Part")
		box.Size = Vector3.new(6, 4, 3)
		box.CFrame = CFrame.new(basePos)
		box.Anchored = true
		box.Transparency = 0.5
		box.Color = Color3.fromRGB(80, 120, 200)
		box.Parent = root
		-- fish labels
		for s, fish in ipairs(tank.slots or {}) do
			local offset = Vector3.new(-2.5 + (s - 1) * 1.0, 4.5, 0)
			makeBillboard((fish.name or "Fish") .. " [" .. (fish.rarity or "?") .. "]", CFrame.new(basePos + offset))
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
