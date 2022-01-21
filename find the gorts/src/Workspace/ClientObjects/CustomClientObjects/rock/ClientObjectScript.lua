return function()
	script.Parent.pos.Touched:Connect(function(t)
		if t.Name == "Collide" and script.Parent.Exploded.Value == 0 then
			script.Parent.PickaxeHit:Play()
			local x = Instance.new("Explosion")
			x.Parent = script.Parent.pos
			x.Position = script.Parent.pos.Position
			x.BlastRadius = 0
			x.BlastPressure = 0
			for _, parts in pairs (script.Parent:GetChildren()) do --cry
				if parts:IsA("BasePart") and parts.Name == "Rock" then
					parts.Transparency = 1
					parts.CanCollide = false
				end
			end
			script.Parent.Exploded.Value = 1
			t:FindFirstAncestorOfClass("Tool"):Destroy()
		end
	end)
end