local zone = script.Parent
local hammer = game.ReplicatedStorage.Hammer
local debounce = false
zone.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and debounce == false then
		if not player.Backpack:FindFirstChild("Hammer") and not hit.Parent:FindFirstChild("Hammer") then
			local clone = hammer:Clone()
			clone.Parent = player.Backpack	
			debounce = true
			wait(0.1)
			debounce = false
		end
	end
end)