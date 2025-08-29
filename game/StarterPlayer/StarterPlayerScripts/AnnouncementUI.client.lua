local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local gui = Instance.new("ScreenGui")
gui.Name = "AnnouncementUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local banner = Instance.new("TextLabel")
banner.Size = UDim2.new(1, 0, 0, 36)
banner.Position = UDim2.new(0, 0, 0, 0)
banner.BackgroundColor3 = Color3.fromRGB(20, 50, 90)
banner.TextColor3 = Color3.new(1, 1, 1)
banner.Text = ""
banner.TextSize = 18
banner.Font = Enum.Font.GothamBold
banner.Visible = false
banner.Parent = gui

local function showMessage(msg)
	banner.Text = msg
	banner.Visible = true
	task.delay(4, function()
		banner.Visible = false
	end)
end

Remotes.Announcement.OnClientEvent:Connect(function(message)
	showMessage(message)
end)
