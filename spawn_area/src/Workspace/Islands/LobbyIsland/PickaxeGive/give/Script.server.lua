local zone = script.Parent
local pickaxe = game.ReplicatedStorage.Pickaxe
local debounce = false
zone.Touched:Connect(function(hit)
	local player = game.Players:GetPlayerFromCharacter(hit.Parent)
	if player and debounce == false then
		if not player.Backpack:FindFirstChild("Pickaxe") and not hit.Parent:FindFirstChild("Pickaxe") then
			local clone = pickaxe:Clone()
			clone.Parent = player.Backpack	
			debounce = true
			wait(0.1)
			debounce = false
		end
	end
end)