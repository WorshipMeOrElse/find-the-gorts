return function()
	local db = false
	local plr = game.Players.LocalPlayer
	plr.Chatted:Connect(function(msg)
		if (msg == "/e MECHANICAL") and not db then
			db = true
			local x = Instance.new("Explosion")
			script.Parent.Anchored = false
			x.Parent = script.Parent
			x.BlastPressure = 50	
			x.Position = script.Parent.Position
			x.BlastRadius = 0
			script.Parent.Parent.Sound:Play()		
--			script.Parent.Transparency = 1
--			script.Parent.CanCollide = false
			end
	end)
end