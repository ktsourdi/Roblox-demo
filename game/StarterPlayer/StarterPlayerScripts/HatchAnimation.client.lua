-- Testing Rojo sync! 🚀
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("RemoteEvents")

-- MVP: listen for announcement and print; wire simple hatch feedback
Remotes.Announcement.OnClientEvent:Connect(function(message)
	print("[Announcement]", message)
end)

-- Example: trigger hatch animation placeholder when hatching
-- In UI, after sending BuyEgg/HatchEgg, play a tween/particle here.

-- Added via Rojo sync test! This should appear instantly in Studio!

