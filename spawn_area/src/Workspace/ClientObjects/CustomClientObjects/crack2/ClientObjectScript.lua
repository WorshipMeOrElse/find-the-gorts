return function ()
	local p
	local text = false
	script.Parent.Part.Touched:Connect(function(part)
		if part.Name == "Inside" and script.Parent.Exploded.Value == 0 then
			script.Parent.Part.Explode:Play()
			local x = Instance.new("Explosion")
			x.Parent = script.Parent.Part
			x.Position = script.Parent.Part.Position
			x.BlastRadius = 0
			x.BlastPressure = 0
			script.Parent.Exploded.Value = 1
			script.Parent.Part.Transparency = 1
			--script.Parent.Part.Decal.Transparency = 1
			script.Parent.Part.CanCollide = false
			part:FindFirstAncestorOfClass("Tool"):Destroy()
		end
	end)
end