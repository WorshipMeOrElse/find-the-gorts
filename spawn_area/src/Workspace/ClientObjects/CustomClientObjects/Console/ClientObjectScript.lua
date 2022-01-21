return function()
	local console = script.Parent
	local gort = workspace.gorts:WaitForChild('Parappa Gort')
	gort.Parent = nil
	
	console.Activation.ClickDetector.MouseClick:Connect(function()
		console.Screen.SurfaceGui.Enabled = true
		gort.Parent = workspace.gorts
		
		local sound = game:GetService('SoundService').sound_effects.parappa_opening
		
		sound:Play()
		
		task.defer(function()
			sound.Ended:Wait()
			sound:Destroy()
			return
		end)
		
		console.Activation.ClickDetector:Destroy()
		script:Destroy()
	end)
end