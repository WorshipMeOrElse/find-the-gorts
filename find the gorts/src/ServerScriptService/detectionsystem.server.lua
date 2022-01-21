local gort_manager = require(game:GetService('ServerStorage'):WaitForChild('modules'):WaitForChild('gort_manager'))
local players = game:GetService('Players')
local gorts = {}

for _,v in ipairs(workspace.gorts:GetChildren()) do
	local d = v:FindFirstChildWhichIsA("Decal")
	gorts[v.Name] = {
		name = v.Name;
		image = d and d.Texture or "http://www.roblox.com/asset/?id=8158806975";
		color = d and d.Color3 or Color3.new(1,1,1);
		difficulty = v:GetAttribute('difficulty');
	}
	
	v.Touched:Connect(function(hit)
		local player = players:GetPlayerFromCharacter(hit.Parent)
		if not player then return end
		gort_manager:AddGort(player, v)
	end)
end

game.Players.PlayerAdded:Connect(function(plr)
	gort_manager:LoadGorts(plr)
	gort_manager:Refresh(plr)
end)

game.ReplicatedStorage.refresh.OnServerEvent:Connect(function(plr)
	gort_manager:Refresh(plr)
end)