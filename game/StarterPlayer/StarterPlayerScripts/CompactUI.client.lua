-- Compact UI: Creates small, collapsible panels for decorations and other features
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Create compact decorations panel
local decorGui = Instance.new("ScreenGui")
decorGui.Name = "CompactDecorations"
decorGui.ResetOnSpawn = false
decorGui.Parent = playerGui

local decorFrame = Instance.new("Frame")
decorFrame.Size = UDim2.new(0, 30, 0, 30)
decorFrame.Position = UDim2.new(1, -40, 0, 10)
decorFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
decorFrame.BorderSizePixel = 0
decorFrame.Parent = decorGui

-- Decorations button
local decorButton = Instance.new("TextButton")
decorButton.Size = UDim2.new(1, 0, 1, 0)
decorButton.BackgroundTransparency = 1
decorButton.Text = "🏺"
decorButton.TextSize = 20
decorButton.TextColor3 = Color3.new(1, 1, 1)
decorButton.Font = Enum.Font.GothamBold
decorButton.Parent = decorFrame

-- Expandable decorations panel (much smaller)
local decorPanel = Instance.new("Frame")
decorPanel.Size = UDim2.new(0, 160, 0, 120)
decorPanel.Position = UDim2.new(1, -170, 0, 50)
decorPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
decorPanel.BorderSizePixel = 0
decorPanel.Visible = false
decorPanel.Parent = decorGui

local decorTitle = Instance.new("TextLabel")
decorTitle.Size = UDim2.new(1, -10, 0, 20)
decorTitle.Position = UDim2.new(0, 5, 0, 5)
decorTitle.Text = "Decorations"
decorTitle.TextSize = 16
decorTitle.TextColor3 = Color3.new(1, 1, 1)
decorTitle.BackgroundTransparency = 1
decorTitle.Font = Enum.Font.GothamBold
decorTitle.Parent = decorPanel

local decorList = Instance.new("ScrollingFrame")
decorList.Size = UDim2.new(1, -10, 1, -30)
decorList.Position = UDim2.new(0, 5, 0, 25)
decorList.BackgroundTransparency = 1
decorList.ScrollBarThickness = 2
decorList.CanvasSize = UDim2.new(0, 0, 0, 200)
decorList.Parent = decorPanel

-- Add some sample decorations for testing
local function createDecorItem(name, price)
	local item = Instance.new("Frame")
	item.Size = UDim2.new(1, 0, 0, 20)
	item.BackgroundTransparency = 1
	item.Parent = decorList
	
	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0.7, 0, 1, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.TextSize = 10
	nameLabel.Font = Enum.Font.Gotham
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.Parent = item
	
	local buyBtn = Instance.new("TextButton")
	buyBtn.Size = UDim2.new(0.3, 0, 1, 0)
	buyBtn.Position = UDim2.new(0.7, 0, 0, 0)
	buyBtn.Text = price .. "💰"
	buyBtn.TextSize = 9
	buyBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
	buyBtn.TextColor3 = Color3.new(1, 1, 1)
	buyBtn.BorderSizePixel = 0
	buyBtn.Font = Enum.Font.Gotham
	buyBtn.Parent = item
end

createDecorItem("Plant", "50")
createDecorItem("Rock", "50") 
createDecorItem("Coral", "150")
createDecorItem("Light", "75")

local decorLayout = Instance.new("UIListLayout")
decorLayout.Padding = UDim.new(0, 2)
decorLayout.Parent = decorList

-- Toggle decorations panel
local decorOpen = false
decorButton.MouseButton1Click:Connect(function()
	decorOpen = not decorOpen
	decorPanel.Visible = decorOpen
	
	local tween = TweenService:Create(
		decorFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back),
		{Rotation = decorOpen and 45 or 0}
	)
	tween:Play()
end)

-- Create compact social panel
local socialGui = Instance.new("ScreenGui")
socialGui.Name = "CompactSocial"
socialGui.ResetOnSpawn = false
socialGui.Parent = playerGui

local socialFrame = Instance.new("Frame")
socialFrame.Size = UDim2.new(0, 30, 0, 30)
socialFrame.Position = UDim2.new(1, -40, 0, 50)
socialFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
socialFrame.BorderSizePixel = 0
socialFrame.Parent = socialGui

local socialButton = Instance.new("TextButton")
socialButton.Size = UDim2.new(1, 0, 1, 0)
socialButton.BackgroundTransparency = 1
socialButton.Text = "👥"
socialButton.TextSize = 18
socialButton.TextColor3 = Color3.new(1, 1, 1)
socialButton.Font = Enum.Font.GothamBold
socialButton.Parent = socialFrame

-- Social panel
local socialPanel = Instance.new("Frame")
socialPanel.Size = UDim2.new(0, 150, 0, 100)
socialPanel.Position = UDim2.new(1, -160, 0, 90)
socialPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
socialPanel.BorderSizePixel = 0
socialPanel.Visible = false
socialPanel.Parent = socialGui

local likeButton = Instance.new("TextButton")
likeButton.Size = UDim2.new(1, -10, 0, 30)
likeButton.Position = UDim2.new(0, 5, 0, 5)
likeButton.Text = "❤️ Like Aquarium"
likeButton.TextSize = 12
likeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
likeButton.TextColor3 = Color3.new(1, 1, 1)
likeButton.BorderSizePixel = 0
likeButton.Font = Enum.Font.Gotham
likeButton.Parent = socialPanel

local visitButton = Instance.new("TextButton")
visitButton.Size = UDim2.new(1, -10, 0, 30)
visitButton.Position = UDim2.new(0, 5, 0, 40)
visitButton.Text = "🚀 Visit Boost"
visitButton.TextSize = 12
visitButton.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
visitButton.TextColor3 = Color3.new(1, 1, 1)
visitButton.BorderSizePixel = 0
visitButton.Font = Enum.Font.Gotham
visitButton.Parent = socialPanel

-- Toggle social panel
local socialOpen = false
socialButton.MouseButton1Click:Connect(function()
	socialOpen = not socialOpen
	socialPanel.Visible = socialOpen
end)

-- Create compact codes panel
local codesGui = Instance.new("ScreenGui")
codesGui.Name = "CompactCodes"
codesGui.ResetOnSpawn = false
codesGui.Parent = playerGui

local codesFrame = Instance.new("Frame")
codesFrame.Size = UDim2.new(0, 30, 0, 30)
codesFrame.Position = UDim2.new(1, -40, 0, 90)
codesFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
codesFrame.BorderSizePixel = 0
codesFrame.Parent = codesGui

local codesButton = Instance.new("TextButton")
codesButton.Size = UDim2.new(1, 0, 1, 0)
codesButton.BackgroundTransparency = 1
codesButton.Text = "📝"
codesButton.TextSize = 18
codesButton.TextColor3 = Color3.new(1, 1, 1)
codesButton.Font = Enum.Font.GothamBold
codesButton.Parent = codesFrame

-- Codes panel
local codesPanel = Instance.new("Frame")
codesPanel.Size = UDim2.new(0, 180, 0, 80)
codesPanel.Position = UDim2.new(1, -190, 0, 130)
codesPanel.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
codesPanel.BorderSizePixel = 0
codesPanel.Visible = false
codesPanel.Parent = codesGui

local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, -70, 0, 25)
codeInput.Position = UDim2.new(0, 5, 0, 5)
codeInput.Text = "Enter code..."
codeInput.TextSize = 12
codeInput.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
codeInput.TextColor3 = Color3.new(1, 1, 1)
codeInput.BorderSizePixel = 0
codeInput.Font = Enum.Font.Gotham
codeInput.Parent = codesPanel

local redeemButton = Instance.new("TextButton")
redeemButton.Size = UDim2.new(0, 60, 0, 25)
redeemButton.Position = UDim2.new(1, -65, 0, 5)
redeemButton.Text = "Redeem"
redeemButton.TextSize = 12
redeemButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
redeemButton.TextColor3 = Color3.new(1, 1, 1)
redeemButton.BorderSizePixel = 0
redeemButton.Font = Enum.Font.Gotham
redeemButton.Parent = codesPanel

local codesInfo = Instance.new("TextLabel")
codesInfo.Size = UDim2.new(1, -10, 0, 40)
codesInfo.Position = UDim2.new(0, 5, 0, 35)
codesInfo.Text = "Try: FISHY, JELLY"
codesInfo.TextSize = 10
codesInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
codesInfo.BackgroundTransparency = 1
codesInfo.Font = Enum.Font.Gotham
codesInfo.TextWrapped = true
codesInfo.Parent = codesPanel

-- Toggle codes panel
local codesOpen = false
codesButton.MouseButton1Click:Connect(function()
	codesOpen = not codesOpen
	codesPanel.Visible = codesOpen
end)

-- Wire up functionality
redeemButton.MouseButton1Click:Connect(function()
	if codeInput.Text ~= "" and codeInput.Text ~= "Enter code..." then
		Remotes.RedeemCode:FireServer(codeInput.Text)
		codeInput.Text = "Enter code..."
	end
end)

likeButton.MouseButton1Click:Connect(function()
	-- For demo - you'd normally target another player
	Remotes.LikeAquarium:FireServer(player.UserId)
end)

visitButton.MouseButton1Click:Connect(function()
	-- For demo - self boost
	Remotes.VisitBoost:FireServer(player.UserId)
end)

print("📱 Compact UI: Created collapsible panels for decorations, social, and codes!")
