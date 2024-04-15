
local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local BanList = ServerStorage:WaitForChild("BanList")

local function IsPlayerBanned(player)
	for _, bannedPlayer in ipairs(BanList:GetChildren()) do
		if bannedPlayer.Name == player.Name then
			return true
		end
	end
	return false
end

local function OnPlayerJoin(player)
	if IsPlayerBanned(player) then
		player:Kick("You have been banned from this game for cheating.")
		return
	end

	-- Example: Check for abnormal movement speed
	player.Character.Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
		if player.Character.Humanoid.WalkSpeed > 16 then -- Maximum normal walk speed
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for using an unauthorized game modification.")
		end
	end)

	-- Example: Check for flying
	player.Character.HumanoidRootPart:GetPropertyChangedSignal("Position"):Connect(function()
		local currentPosition = player.Character.HumanoidRootPart.Position
		local previousPosition = player.Character.HumanoidRootPart:GetAttribute("PreviousPosition")

		if previousPosition and (currentPosition - previousPosition).Magnitude > 10 then
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for flying.")
		end

		player.Character.HumanoidRootPart:SetAttribute("PreviousPosition", currentPosition)
	end)

	-- Check for teleportation
	player.Character.HumanoidRootPart.Touched:Connect(function(hit)
		if hit and hit.Parent and hit.Parent:IsA("Model") and hit.Parent:FindFirstChild("Humanoid") then
			local humanoid = hit.Parent.Humanoid
			if humanoid.Health == 0 then
				-- Log and handle the cheating behavior
				player:Kick("You have been kicked for teleporting.")
			end
		end
	end)

	-- Check for speed hacks
	player.Character.Humanoid.WalkSpeedChanged:Connect(function()
		if player.Character.Humanoid.WalkSpeed > 32 then -- Maximum normal walk speed
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for using a speed hack.")
		end
	end)

	-- Check for exploit tool usage
	player.Character.ChildAdded:Connect(function(child)
		if child:IsA("Tool") and child:FindFirstChild("Handle") then
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for using an exploit tool.")
		end
	end)

	-- Check for invisible players
	player.Character.ChildAdded:Connect(function(child)
		if child:IsA("Part") and child.Transparency == 1 then
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for using invisibility.")
		end
	end)

	-- Check for camera manipulation
	local function CheckCamera()
		local camera = game.Workspace.CurrentCamera
		local playerCharacter = player.Character
		if camera and playerCharacter then
			local cameraSubject = camera.CameraSubject
			if cameraSubject and cameraSubject.Parent == playerCharacter then
				-- Log and handle the cheating behavior
				player:Kick("You have been kicked for manipulating the camera.")
			end
		end
	end

	game:GetService("RunService").Stepped:Connect(CheckCamera)

	-- Check for script injection
	player.Character.DescendantAdded:Connect(function(descendant)
		if descendant:IsA("Script") and not descendant:IsDescendantOf(game:GetService("StarterPlayer")) then
			-- Log and handle the cheating behavior
			player:Kick("You have been kicked for injecting scripts.")
		end
	end)

	-- Check for memory editing
	player.Character.Humanoid.Died:Connect(function()
		if player.Character and player.Character.Parent then
			
			player:Kick("You have been kicked for editing memory.")
		end
	end)

	

end

Players.PlayerAdded:Connect(OnPlayerJoin)
