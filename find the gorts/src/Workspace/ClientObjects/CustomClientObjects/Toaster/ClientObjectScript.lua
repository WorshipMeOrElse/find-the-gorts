return function()
	local clickdetector = script.Parent.ClickDetector
	local gort = workspace.gorts["Poptart Gort"]
	gort.Parent = nil
	
	local sound = game:GetService('SoundService').sound_effects:WaitForChild('tada')
	
	clickdetector.MouseClick:Connect(function()
		gort.Parent = workspace.gorts
		sound:Play()
		clickdetector:Destroy()
	end)
end