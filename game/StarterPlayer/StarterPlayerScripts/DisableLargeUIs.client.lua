-- Disable Large UIs: Automatically hides the large UI panels that are taking up too much space
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Wait a moment for other UIs to load, then disable the large ones
task.wait(2)

-- List of large UI panels to disable
local largeUIPanels = {
	"CodesUI",
	"FriendsUI", 
	"LikeUI",
	"OnboardingUI",
	"PurchasesUI",
	"RatingUI",
	"AnnouncementUI"
}

-- Disable large panels
for _, panelName in ipairs(largeUIPanels) do
	local panel = playerGui:FindFirstChild(panelName)
	if panel then
		panel.Enabled = false
		print("🔇 Disabled large UI panel:", panelName)
	end
end

-- Also disable the old decoration UI if CompactUI is available
local compactUI = playerGui:FindFirstChild("CompactDecorations")
if compactUI then
	local decorUI = playerGui:FindFirstChild("DecorUI")
	if decorUI then
		decorUI.Enabled = false
		print("🔇 Disabled old DecorUI - using CompactUI instead")
	end
end

print("✨ UI Cleanup: Large panels disabled, keeping only essential compact UIs!")
