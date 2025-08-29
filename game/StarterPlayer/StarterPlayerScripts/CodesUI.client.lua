local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local gui = Instance.new("ScreenGui")
gui.Name = "CodesUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 80)
frame.Position = UDim2.new(0, 290, 0, 12)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Codes"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

local input = Instance.new("TextBox")
input.Size = UDim2.new(0, 150, 0, 28)
input.Position = UDim2.new(0, 5, 0, 40)
input.PlaceholderText = "Enter code"
input.Font = Enum.Font.Gotham
input.TextSize = 14
input.Text = ""
input.TextColor3 = Color3.new(1, 1, 1)
input.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
input.BorderSizePixel = 0
input.ClearTextOnFocus = false
input.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 90, 0, 28)
btn.Position = UDim2.new(0, 160, 0, 40)
btn.Text = "Redeem"
btn.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
btn.TextColor3 = Color3.new(1, 1, 1)
btn.BorderSizePixel = 0
btn.AutoButtonColor = true
btn.Font = Enum.Font.Gotham
btn.TextSize = 14
btn.Parent = frame

btn.MouseButton1Click:Connect(function()
	local code = string.upper(string.trim(input.Text))
	if code ~= "" then
		Remotes.RedeemCode:FireServer(code)
		input.Text = ""
	end
end)
