local rate = script.Parent.Time.Value
local tw = game:GetService("TweenService")
local db = false
return function()
	script.Parent.Transparency = 1
	script.Parent.Decal.Transparency = 1
	script.Parent.Destination.Transparency = 1
	script.Parent.Destination.Decal.Transparency = 1
	script.Parent.Touched:Connect(function(hit)
		if hit.Parent == game.Players.LocalPlayer.Character and not db then
			db = true
			script.Explode:Play()
			local torso = hit.Parent:FindFirstChild("Torso")
			if not torso:FindFirstChild("ElevatorVelocity") and (hit.Parent:FindFirstChild("Humanoid")) then
				local velocity = Instance.new("BodyVelocity", torso)
				velocity.Name = "ElevatorVelocity"
				local uv=script.Parent.CFrame.LookVector
				local maxf=Vector3.new(0,math.huge,0)
				if uv.X ~= 0 then maxf = Vector3.new(math.huge, maxf.Y, maxf.Z) end
				if uv.Z ~= 0 then maxf = Vector3.new(maxf.X, maxf.Y, math.huge) end

				velocity.MaxForce = maxf
				velocity.Velocity = script.Parent.CFrame.LookVector * script.Parent.Power.Value
				wait(rate/4)
				velocity:Destroy()
			end
			wait(rate/2)
			tw:Create(game.Players.LocalPlayer.Character.HumanoidRootPart,TweenInfo.new(rate/4),{CFrame = script.Parent.Destination.CFrame}):Play()
			db = false
		end
	end)
end