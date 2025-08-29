local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local function fetchProfile()
	local ok, data = pcall(function()
		return Remotes.GetProfile:InvokeServer()
	end)
	if ok then return data end
	return nil
end

local function setFlag(key)
	Remotes.SetOnboarding:FireServer(key, true)
end

local tips = {
	{ key = "Shop", text = "Welcome! Buy a Common Egg in the Shop to start.", anchor = UDim2.new(0, 12, 0, 12) },
	{ key = "Inventory", text = "Open Inventory and place your fish into Tank 1.", anchor = UDim2.new(0, 12, 0, 200) },
	{ key = "Decor", text = "Buy a decoration and place it into Tank 1.", anchor = UDim2.new(0, 560, 0, 12) },
	{ key = "Friends", text = "Use Visit Friends to boost tickets together.", anchor = UDim2.new(0, 12, 0, 480) },
}

local gui = Instance.new("ScreenGui")
gui.Name = "OnboardingUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local bubble = Instance.new("TextLabel")
bubble.Size = UDim2.new(0, 280, 0, 64)
bubble.Position = UDim2.new(0, 12, 0, 12)
bubble.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
bubble.TextColor3 = Color3.new(1, 1, 1)
bubble.TextWrapped = true
bubble.TextSize = 16
bubble.Font = Enum.Font.Gotham
bubble.Visible = false
bubble.Parent = gui

local nextBtn = Instance.new("TextButton")
nextBtn.Size = UDim2.new(0, 80, 0, 24)
nextBtn.Position = UDim2.new(0, 190, 0, 70)
nextBtn.BackgroundColor3 = Color3.fromRGB(70, 100, 70)
nextBtn.TextColor3 = Color3.new(1, 1, 1)
nextBtn.TextSize = 14
nextBtn.Text = "Got it"
nextBtn.Font = Enum.Font.Gotham
nextBtn.Visible = false
nextBtn.Parent = gui

local current = 1

local function advance()
	local profile = fetchProfile()
	if not profile then return end
	local flags = (profile.Stats and profile.Stats.Onboarding) or {}
	-- Find first not completed tip
	current = 1
	for i, t in ipairs(tips) do
		if not flags[t.key] then current = i break end
	end
	if current > #tips then
		bubble.Visible = false
		nextBtn.Visible = false
		return
	end
	local tip = tips[current]
	bubble.Position = tip.anchor
	bubble.Text = tip.text
	bubble.Visible = true
	nextBtn.Visible = true
end

nextBtn.MouseButton1Click:Connect(function()
	local tip = tips[current]
	if tip then
		setFlag(tip.key)
		task.delay(0.2, advance)
	end
end)

advance()

