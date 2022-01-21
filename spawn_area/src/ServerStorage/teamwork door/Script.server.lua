local R = script.Parent.R
local G = script.Parent.G
local B = script.Parent.B

for _, ob in pairs(script.Parent:GetChildren()) do
	if ob:IsA("BasePart") then
		ob.Touched:Connect(function(part)
			if part.Parent:FindFirstChild("Humanoid") then
				ob.Locked = true
			end
		end)
		ob.TouchEnded:Connect(function(part)
			if part.Parent:FindFirstChild("Humanoid") then
				ob.Locked = false
			end
		end)
	end
end
spawn(function()
	while true do
		wait()
		if R.Locked and G.Locked and B.Locked then
			script.Parent.CanCollide = false
			script.Parent.Transparency = 1
			script.Parent.SurfaceGui.Enabled = false
		else
			script.Parent.CanCollide = true
			script.Parent.Transparency = 0
			script.Parent.SurfaceGui.Enabled = true
		end
	end
end)
