local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

local gui = Instance.new("ScreenGui")
gui.Name = "LikeUI"
gui.ResetOnSpawn = false
gui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(1, -240, 0, 60)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -10, 0, 24)
title.Position = UDim2.new(0, 5, 0, 5)
title.Text = "Like Aquarium"
title.TextSize = 20
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.Parent = frame

local list = Instance.new("Frame")
list.Size = UDim2.new(1, -10, 1, -40)
list.Position = UDim2.new(0, 5, 0, 35)
list.BackgroundTransparency = 1
list.Parent = frame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = list

local function rebuild()
	for _, child in ipairs(list:GetChildren()) do
		if child:IsA("Frame") then child:Destroy() end
	end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player then
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundTransparency = 1
			row.Parent = list

			local nameLabel = Instance.new("TextLabel")
			nameLabel.Size = UDim2.new(1, -90, 1, 0)
			nameLabel.Position = UDim2.new(0, 0, 0, 0)
			nameLabel.BackgroundTransparency = 1
			nameLabel.Font = Enum.Font.Gotham
			nameLabel.TextSize = 14
			nameLabel.TextXAlignment = Enum.TextXAlignment.Left
			nameLabel.TextColor3 = Color3.new(1, 1, 1)
			nameLabel.Text = p.DisplayName
			nameLabel.Parent = row

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 80, 1, 0)
			btn.Position = UDim2.new(1, -80, 0, 0)
			btn.AnchorPoint = Vector2.new(1, 0)
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.BorderSizePixel = 0
			btn.AutoButtonColor = true
			btn.Font = Enum.Font.Gotham
			btn.TextSize = 14
			btn.Text = "Like"
			btn.Parent = row

			btn.MouseButton1Click:Connect(function()
				Remotes.LikeAquarium:FireServer(p.UserId)
			end)
		end
	end
end

rebuild()
Players.PlayerAdded:Connect(rebuild)
Players.PlayerRemoving:Connect(rebuild)
