function getPlatformColor(pl)
	if pl:FindFirstChild"ColorOverride" and pl.ColorOverride:IsA"Color3Value" then
		return pl.ColorOverride.Value
	else
		return pl.Color
	end
end
local p = game.Players:GetPlayerFromCharacter(script.Parent)
script.Parent:WaitForChild("Humanoid").Touched:connect(function(tP,hP)
	if tP.Name=='LightingChanger' and tP:IsA'BasePart' and tP:FindFirstChild'Configuration' then
		local c=require(tP.Configuration)
		if _G.SetLighting then
			_G:SetLighting(c)
		end
	end
	if tP:FindFirstChild("kills") then
		if (tP.Name=='ButtonActivatedPlatform' or tP.Parent.Parent.Name=="Beat Blocks") and tP.CanCollide==false then return end
		if script.Parent.Humanoid.Health > 0 and hP.Name ~= "Part" then
			game.ReplicatedStorage.DamageEvent:FireServer('Normal')
		end
	end
	if tP:FindFirstChild("ouch") then
		if (tP.Name=='ButtonActivatedPlatform' or tP.Parent.Parent.Name=="Beat Blocks") and tP.CanCollide==false then return end
		if script.Parent.Humanoid.Health > 0 and hP.Name ~= "Part" then
			game.ReplicatedStorage.DamageEvent:FireServer('HighDamage')
		end
	end
	if tP:FindFirstChild("instakills") then
		if (tP.Name=='ButtonActivatedPlatform' or tP.Parent.Parent.Name=="Beat Blocks") and tP.CanCollide==false then return end
		if script.Parent.Humanoid.Health > 0 and hP.Name ~= "Part" then
			game.ReplicatedStorage.DamageEvent:FireServer('Instakill')
		end
	end
end)