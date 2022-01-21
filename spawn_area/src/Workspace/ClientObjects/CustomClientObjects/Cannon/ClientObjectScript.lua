return function()
	local player = game:GetService('Players').LocalPlayer
	local character = player.Character or player.CharacterAdded:Wait()
	local torso = character:WaitForChild('Torso')
	
	local cannon = script.Parent.Part
	
	game:GetService('RunService').RenderStepped:Connect(function()
		cannon.CFrame = CFrame.lookAt(cannon.Position,torso.Position)
	end)
end