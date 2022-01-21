local hp = script.Parent.Hitpoints.Value
local inithp = hp
local db = true
return function()
	local plr = game.Players.LocalPlayer
	plr.Chatted:Connect(function(msg)
		if (msg =="/e dance" or msg == "/e Dance") and plr.Character.HumanoidRootPart and db then
			db = false
			if (script.Parent.Position - plr.Character.HumanoidRootPart.Position).Magnitude < 15 then
				hp -= 1
				if hp ~= inithp + 1 and hp > 0 then
					script.Parent["1"].Transparency = 1-(1/(hp))
					script.Parent["2"].Transparency = 1-(1/(hp))
					if not script.Sound.IsPaused then
						script.Sound:Play()
					else
						script.Sound:Resume()
					end
					wait(script.Sound.TimeLength/inithp)
					script.Sound:Pause()
				end
				if hp == 0 then 
					script.Shatter:Play()
					script.Parent.CanCollide = false
					script.Parent.Transparency = 1
					script.Parent["1"].Transparency = 1
					script.Parent["2"].Transparency = 1
				end
			end
			db = true
		end
	end)
end