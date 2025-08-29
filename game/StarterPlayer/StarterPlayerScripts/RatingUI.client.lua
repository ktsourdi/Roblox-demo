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

local gui = Instance.new("ScreenGui")
gui.Name = "RatingUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 160, 0, 40)
frame.Position = UDim2.new(1, -180, 0, 12)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, -10, 1, -10)
label.Position = UDim2.new(0, 5, 0, 5)
label.Text = "Rating: -"
label.TextSize = 18
label.TextColor3 = Color3.new(1, 1, 1)
label.BackgroundTransparency = 1
label.Font = Enum.Font.GothamBold
label.Parent = frame

local function refresh()
	local profile = fetchProfile()
	if profile and profile.Aquarium then
		label.Text = "Rating: " .. tostring(profile.Aquarium.Rating or 0)
	end
end

refresh()
task.spawn(function()
	while true do
		task.wait(5)
		refresh()
	end
end)
