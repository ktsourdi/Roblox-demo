-- Minimal UI: Ultra-compact interface that takes almost no screen space
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

-- Function to create tiny toggle buttons
local function createTinyButton(emoji, position, onClick)
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.Parent = playerGui
	
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 25, 0, 25)
	button.Position = position
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 0.3
	button.BorderSizePixel = 0
	button.Text = emoji
	button.TextSize = 16
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.GothamBold
	button.Parent = gui
	
	-- Rounded corners
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = button
	
	button.MouseButton1Click:Connect(onClick)
	
	return gui, button
end

-- Tiny decorations button
local decorGui, decorButton = createTinyButton("🏺", UDim2.new(1, -35, 0, 10), function()
	-- Toggle decoration panel
	local decorPanel = playerGui:FindFirstChild("DecorPanel")
	if decorPanel then
		decorPanel:Destroy()
	else
		-- Create mini decoration panel
		decorPanel = Instance.new("ScreenGui")
		decorPanel.Name = "DecorPanel"
		decorPanel.ResetOnSpawn = false
		decorPanel.Parent = playerGui
		
		local panel = Instance.new("Frame")
		panel.Size = UDim2.new(0, 120, 0, 80)
		panel.Position = UDim2.new(1, -130, 0, 40)
		panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		panel.BackgroundTransparency = 0.2
		panel.BorderSizePixel = 0
		panel.Parent = decorPanel
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = panel
		
		-- Quick decoration buttons
		local decorItems = {"🌱 Plant 50", "🗿 Rock 50", "🪸 Coral 150"}
		for i, item in ipairs(decorItems) do
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, -10, 0, 20)
			btn.Position = UDim2.new(0, 5, 0, 5 + (i-1)*22)
			btn.Text = item
			btn.TextSize = 10
			btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
			btn.TextColor3 = Color3.new(1, 1, 1)
			btn.BorderSizePixel = 0
			btn.Font = Enum.Font.Gotham
			btn.Parent = panel
			
			local btnCorner = Instance.new("UICorner")
			btnCorner.CornerRadius = UDim.new(0, 4)
			btnCorner.Parent = btn
		end
	end
end)

-- Tiny social button
local socialGui, socialButton = createTinyButton("👥", UDim2.new(1, -35, 0, 40), function()
	-- Quick social actions
	Remotes.VisitBoost:FireServer(player.UserId)
	-- Visual feedback
	socialButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	task.wait(0.2)
	socialButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
end)

-- Tiny codes button
local codesGui, codesButton = createTinyButton("📝", UDim2.new(1, -35, 0, 70), function()
	-- Toggle code input
	local codePanel = playerGui:FindFirstChild("CodePanel")
	if codePanel then
		codePanel:Destroy()
	else
		codePanel = Instance.new("ScreenGui")
		codePanel.Name = "CodePanel"
		codePanel.ResetOnSpawn = false
		codePanel.Parent = playerGui
		
		local panel = Instance.new("Frame")
		panel.Size = UDim2.new(0, 140, 0, 50)
		panel.Position = UDim2.new(1, -150, 0, 100)
		panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		panel.BackgroundTransparency = 0.2
		panel.BorderSizePixel = 0
		panel.Parent = codePanel
		
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0, 8)
		corner.Parent = panel
		
		local input = Instance.new("TextBox")
		input.Size = UDim2.new(1, -50, 0, 20)
		input.Position = UDim2.new(0, 5, 0, 5)
		input.Text = "Enter code"
		input.TextSize = 10
		input.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
		input.TextColor3 = Color3.new(1, 1, 1)
		input.BorderSizePixel = 0
		input.Font = Enum.Font.Gotham
		input.Parent = panel
		
		local inputCorner = Instance.new("UICorner")
		inputCorner.CornerRadius = UDim.new(0, 4)
		inputCorner.Parent = input
		
		local submit = Instance.new("TextButton")
		submit.Size = UDim2.new(0, 40, 0, 20)
		submit.Position = UDim2.new(1, -45, 0, 5)
		submit.Text = "✓"
		submit.TextSize = 12
		submit.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
		submit.TextColor3 = Color3.new(1, 1, 1)
		submit.BorderSizePixel = 0
		submit.Font = Enum.Font.GothamBold
		submit.Parent = panel
		
		local submitCorner = Instance.new("UICorner")
		submitCorner.CornerRadius = UDim.new(0, 4)
		submitCorner.Parent = submit
		
		local hint = Instance.new("TextLabel")
		hint.Size = UDim2.new(1, -10, 0, 15)
		hint.Position = UDim2.new(0, 5, 0, 30)
		hint.Text = "Try: FISHY, JELLY"
		hint.TextSize = 8
		hint.TextColor3 = Color3.fromRGB(200, 200, 200)
		hint.BackgroundTransparency = 1
		hint.Font = Enum.Font.Gotham
		hint.Parent = panel
		
		submit.MouseButton1Click:Connect(function()
			if input.Text ~= "" and input.Text ~= "Enter code" then
				Remotes.RedeemCode:FireServer(input.Text)
				codePanel:Destroy()
			end
		end)
	end
end)

-- Tiny settings button
local settingsGui, settingsButton = createTinyButton("⚙️", UDim2.new(1, -35, 0, 100), function()
	-- Quick toggle for main UI panels
	local shopUI = playerGui:FindFirstChild("ShopUI")
	local inventoryUI = playerGui:FindFirstChild("InventoryUI")
	
	if shopUI then shopUI.Enabled = not shopUI.Enabled end
	if inventoryUI then inventoryUI.Enabled = not inventoryUI.Enabled end
	
	-- Visual feedback
	settingsButton.Text = shopUI and shopUI.Enabled and "⚙️" or "👁️"
end)

print("🔥 Minimal UI: Ultra-compact interface created - takes <5% screen space!")
