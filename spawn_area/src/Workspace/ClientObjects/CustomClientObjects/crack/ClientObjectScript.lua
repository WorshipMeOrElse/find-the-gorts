return function()
	local p
	local text = false
	script.Parent.Part.Touched:Connect(function(part)
		if part.Name == "Impact" and script.Parent.Exploded.Value == 0 then
			script.Parent.Part.Explode:Play()
			local x = Instance.new("Explosion")
			x.Parent = script.Parent.Part
			x.Position = script.Parent.Part.Position
			x.BlastRadius = 0
			x.BlastPressure = 0
			script.Parent.Exploded.Value = 1
			script.Parent.Part.Transparency = 1
			script.Parent.Part.Decal.Transparency = 1
			script.Parent.Part.CanCollide = false
			part:FindFirstAncestorOfClass("Tool"):Destroy()
		end		
		if part.Name == "Impact2" and script.Parent.Exploded.Value == 0 and not text then
			text = true
			local TL = Instance.new("TextLabel",game.Players.LocalPlayer.PlayerGui.EffectGUI) 
			TL.Text = "That's a pickaxe..."
			TL.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
			TL.BackgroundTransparency = 0.4
			TL.TextColor3 = Color3.new(1, 0, 0)
			TL.Size = UDim2.fromScale(0.2,0.1)
			TL.Position = UDim2.fromScale(0.4,1)
			TL.TextWrapped = true
			TL.TextSize = 40
			TL.Font = Enum.Font.GothamSemibold
			local US = Instance.new("UIStroke",TL)
			US.Thickness = 2
			local UC = Instance.new("UICorner",TL)
			game:GetService("TweenService"):Create(TL, TweenInfo.new(.2),{Size = UDim2.fromScale(0.5,0.2), Position = UDim2.fromScale(0.25,0.6)}):Play()
			wait(1.2)
			TL:Destroy()
			text = false
		end
	end)
end		