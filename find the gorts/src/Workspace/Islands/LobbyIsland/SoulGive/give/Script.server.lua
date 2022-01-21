local zone = script.Parent
local soul = game.ReplicatedStorage.Soul
local debounce = false
zone.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and debounce == false then
		if not player.Backpack:FindFirstChild("Soul") and not hit.Parent:FindFirstChild("Soul") then
			debounce = true
			local clone = soul:Clone()
			clone.Parent = player.Backpack	
			wait(0.5)
			debounce = false
		end
	end
end)