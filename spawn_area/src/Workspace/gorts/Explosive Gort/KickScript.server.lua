local players = game:GetService('Players')
local gort = script.Parent
local sound = gort.Sound
local gort_manager = require(game:GetService('ServerStorage'):WaitForChild('modules'):WaitForChild('gort_manager'))

gort.Touched:Connect(function(touched)
	local player = players:GetPlayerFromCharacter(touched.Parent)
	if not player then return end
	if gort_manager:HasGort(player, gort) then return end
	sound:Play()
	player:Kick([[
	
						you just got exploded boom boom
						still got the gort tho
						rejoin to collect it lol
						theres no use anyways its dead
						]])
end)