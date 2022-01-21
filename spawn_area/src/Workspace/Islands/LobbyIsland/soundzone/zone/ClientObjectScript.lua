return function()
	script.Parent.Touched:Connect(function(hit)
		script.Parent.oink.Playing = true
	end)
	script.Parent.TouchEnded:Connect(function(hit)
		script.Parent.oink.Playing = false
	end)
end