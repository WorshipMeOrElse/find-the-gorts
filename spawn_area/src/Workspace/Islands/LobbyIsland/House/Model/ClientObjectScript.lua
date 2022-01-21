return function ()
	local sound = script.Parent.Sound
	script.Parent.zone.Touched:Connect(function(hit)
		sound.Playing = true
	end)
	script.Parent.zone.TouchEnded:Connect(function(stop)
		sound.Playing = false
	end)
end