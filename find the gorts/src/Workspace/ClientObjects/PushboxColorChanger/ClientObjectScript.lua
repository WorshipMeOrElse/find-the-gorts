return function()
	script.Parent.Touched:Connect(function(t)
		if t.Name == "Pushbox" then
			t.Color = script.Parent.Color
		end
	end)
end