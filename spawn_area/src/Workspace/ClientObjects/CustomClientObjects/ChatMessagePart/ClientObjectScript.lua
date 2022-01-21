return function()
	local db = false
	local plr = game.Players.LocalPlayer
	plr.Chatted:Connect(function(msg)
		if msg == ("/e NFDIBOJDBM-6842") and not db then
			db = true
			local parts = script.Parent.build:GetChildren()
			script.Parent.Sound:Play()
			for i = 1, #parts do
				parts[i].Transparency = 0
				parts[i].CanCollide = true
			end
		end
	end)
end