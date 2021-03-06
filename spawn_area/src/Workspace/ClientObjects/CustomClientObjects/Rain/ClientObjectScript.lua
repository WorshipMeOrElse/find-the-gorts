local player = game:GetService('Players').LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local lighting = game:GetService('Lighting')
local oil_color_correction = script:WaitForChild('ColorCorrection')

local elevator = script.Parent
local oil = elevator:WaitForChild('oil_hitbox')
local speed = elevator:GetAttribute('Speed')

local oiled = false

return function()
	oil.Touched:Connect(function(touched)
		if touched.Parent ~= character or oiled then return end
		oiled = true
		oil_color_correction.Parent = lighting
	end)
	
	elevator.Touched:Connect(function(touched)
		if touched.Name ~= 'HumanoidRootPart' or not oiled then return end
		if character.Torso:FindFirstChild('elevator_velocity') then return end
		local elevator_velocity = Instance.new('BodyVelocity')
		elevator_velocity.MaxForce = Vector3.new(0, math.huge, 0)
		elevator_velocity.Velocity = Vector3.new(0, speed, 0)
		elevator_velocity.Name = 'elevator_velocity'
		elevator_velocity.Parent = character.HumanoidRootPart
	end)
	
	elevator.TouchEnded:Connect(function(touched)
		if touched.Name ~= 'HumanoidRootPart' then return end

		local velocity = touched:FindFirstChild('elevator_velocity')
		if not velocity then return end
		oiled = false
		velocity:Destroy()
		oil_color_correction.Parent = script
	end)
end