local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function ensureFolder(parent, name)
	local folder = parent:FindFirstChild(name)
	if not folder then
		folder = Instance.new("Folder")
		folder.Name = name
		folder.Parent = parent
	end
	return folder
end

local function ensureRemote(folder, name)
	local remote = folder:FindFirstChild(name)
	if not remote then
		remote = Instance.new("RemoteEvent")
		remote.Name = name
		remote.Parent = folder
	end
	return remote
end

local function ensureRemoteFunction(folder, name)
	local remoteFn = folder:FindFirstChild(name)
	if not remoteFn then
		remoteFn = Instance.new("RemoteFunction")
		remoteFn.Name = name
		remoteFn.Parent = folder
	end
	return remoteFn
end

local remotesFolder = ensureFolder(ReplicatedStorage, "RemoteEvents")
ensureRemote(remotesFolder, "BuyEgg")
ensureRemote(remotesFolder, "HatchEgg")
ensureRemote(remotesFolder, "PlaceFish")
ensureRemote(remotesFolder, "VisitBoost")
ensureRemote(remotesFolder, "LikeAquarium")
ensureRemote(remotesFolder, "RedeemCode")
ensureRemote(remotesFolder, "Announcement")
ensureRemoteFunction(remotesFolder, "GetProfile")

