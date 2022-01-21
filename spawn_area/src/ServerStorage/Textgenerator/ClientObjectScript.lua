script.Parent.Transparency = 1
return function()
	local db = true
	script.Parent.Touched:Connect(function(hit)
		if hit.Parent:FindFirstChild("Humanoid") then
			if hit.Parent.Humanoid == game.Players.LocalPlayer.Character.Humanoid and db then
				db = false
				local TL = Instance.new("TextLabel",game.Players.LocalPlayer.PlayerGui.EffectGUI) 
				TL.Text = script.Parent.Text.Value
				TL.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
				TL.BackgroundTransparency = 0.4
				TL.TextColor3 = script.Parent.Color
				TL.Size = UDim2.fromScale(0.2,0.1)
				TL.Position = UDim2.fromScale(0.4,1)
				TL.TextWrapped = true
				TL.TextSize = 40
				TL.Font = Enum.Font.GothamSemibold
				local US = Instance.new("UIStroke",TL)
				US.Thickness = 2
				local UC = Instance.new("UICorner",TL)
				game:GetService("TweenService"):Create(TL, TweenInfo.new(.2),{Size = UDim2.fromScale(0.5,0.2), Position = UDim2.fromScale(0.25,0.6)}):Play()
				wait(script.Parent.Time.Value+.2)
				TL:Destroy()
				db = script.Parent.Repeat.Value 
			end
		end
	end)
end