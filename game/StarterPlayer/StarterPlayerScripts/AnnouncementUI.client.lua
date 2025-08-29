local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local gui = Instance.new("ScreenGui")
gui.Name = "AnnouncementUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local banner = Instance.new("TextLabel")
banner.Size = UDim2.new(1, 0, 0, 36)
banner.Position = UDim2.new(0, 0, 0, -40)
banner.BackgroundColor3 = Color3.fromRGB(20, 50, 90)
banner.TextColor3 = Color3.new(1, 1, 1)
banner.Text = ""
banner.TextSize = 18
banner.Font = Enum.Font.GothamBold
banner.Parent = gui

local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(0, 120, 0, 120)
overlay.AnchorPoint = Vector2.new(0.5, 0.5)
overlay.Position = UDim2.new(0.5, 0, 0.5, 0)
overlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.Visible = false
overlay.Parent = gui

local function showBanner(msg)
	banner.Text = msg
	TweenService:Create(banner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0, 0, 0, 0) }):Play()
	task.delay(3, function()
		TweenService:Create(banner, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = UDim2.new(0, 0, 0, -40) }):Play()
	end)
end

local function hatchPop()
	overlay.BackgroundTransparency = 0.2
	overlay.Visible = true
	overlay.Size = UDim2.new(0, 50, 0, 50)
	TweenService:Create(overlay, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 140, 0, 140), BackgroundTransparency = 0.85 }):Play()
	task.delay(0.3, function()
		overlay.Visible = false
	end)
end

Remotes.Announcement.OnClientEvent:Connect(function(message)
	showBanner(message)
	if string.find(string.lower(message or ""), "hatched") then
		hatchPop()
	end
end)
