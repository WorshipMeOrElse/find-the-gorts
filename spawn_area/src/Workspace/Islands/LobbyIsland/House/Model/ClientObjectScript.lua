return function ()
	local sound = script.Parent.Sound
	script.Parent.zone.Touched:Connect(function()
		sound.Playing = true
	end)
	
	script.Parent.zone.TouchEnded:Connect(function()
		sound.Playing = false
	end)
end