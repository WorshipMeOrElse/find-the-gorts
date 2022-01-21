return function()
	local db = true
	local players = not script.Parent:FindFirstChild("IgnorePlayers")
	local boxes = not script.Parent:FindFirstChild("IgnoreBoxes")
	script.Parent.Touched:Connect(function(hit)
		if hit.Anchored == false and db == true and ((players and hit.Parent:FindFirstChild("Humanoid")) or (boxes and hit.Name == "Pushbox")) and not (script.Parent:FindFirstChild("Activated") and not script.Parent.Activated.Value) then
			db = false
			spawn(function()
				wait(0.05)
				db = true
			end)
			local bv = Instance.new("BodyVelocity")
			bv.MaxForce = Vector3.new(0, math.huge, 0)
			bv.Velocity = Vector3.new(0, script.Parent.Power.Value, 0)
			bv.Parent = hit
			game:GetService("Debris"):AddItem(bv,0.15)
		end
	end)
end