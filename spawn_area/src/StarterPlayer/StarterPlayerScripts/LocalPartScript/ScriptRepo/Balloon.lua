local ts=game:GetService'TweenService'
local function tween(part,time,inf)
	local tw=ts:Create(part,TweenInfo.new(time),inf)
	tw:Play()
end

local sounds={
	Inflate='rbxassetid://11895499',
	Pop='rbxassetid://11895500'
}

local debris = game:GetService('Debris')
local parent = script.Parent
local function Play(snd)
	local s=Instance.new('Sound')
	s.SoundId=sounds[snd]
	s.Parent = workspace
	s:Play()

	debris:AddItem(s, s.TimeLength)
	return s
end

local userinput=game:GetService('UserInputService')
local NOJUMPALLOWED= parent:FindFirstChild'CannotDismount' and parent.CannotDismount.Value

local bdelay = false

return function()
	local WaitTime=parent:FindFirstChild'WaitTime' and parent.WaitTime.Value or 5
	WaitTime = WaitTime <= 0 and math.huge or WaitTime
	local MaxHeight=parent:FindFirstChild'MaxHeight' and parent.MaxHeight.Value or 20
	local Force=parent:FindFirstChild'Force' and parent.Force.Value or 5

	local Riding = false
	local val

	if parent.Name == 'ButtonActivatedBalloonDispenser' then
		val=Instance.new('BoolValue')
		val.Name='Activated'
		val.Parent = parent
	end

	for _,d in ipairs(parent:GetChildren()) do
		if not d:IsA('Decal') then continue end
		d.Color3=parent.Color
	end

	parent.Touched:Connect(function(part)
		local plr = game.Players:GetPlayerFromCharacter(part.Parent)
		if not (part.Parent:FindFirstChild("Humanoid") and not (val and not val.Value) and plr == game.Players.LocalPlayer and bdelay ~= true) then return end
		if Riding then return end
		Riding = true
		bdelay = true

		local autodisconnect
		if not NOJUMPALLOWED then
			userinput.JumpRequest:Connect(function()
				autodisconnect=true
			end)
		end

		local Bar = Instance.new("Part")
		Bar.Size = Vector3.new(3,0.4,0.4)
		Bar.Material = Enum.Material.SmoothPlastic
		Bar.CanCollide = false
		Bar.CFrame = part.Parent:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,2.6,0)
		Bar.CustomPhysicalProperties = PhysicalProperties.new(10,0,0)
		Bar.Color = parent.Color

		local Balloon = Instance.new("Part")
		Balloon.Shape='Ball'
		Balloon.Material='Neon'
		Balloon.Size = Vector3.new(2,2,2)
		Balloon.CanCollide = true
		Balloon.Color=parent.Color
		Balloon.CustomPhysicalProperties = PhysicalProperties.new(20,0,0) 
		Balloon.CFrame = parent.CFrame

		local BG=Instance.new('BodyGyro')
		BG.MaxTorque=Vector3.new(math.huge,math.huge,math.huge)
		BG.CFrame=CFrame.new()
		BG.Parent = Balloon
		
		local BV=Instance.new('BodyVelocity')
		BV.MaxForce=Vector3.new(0,10000000,0)
		BV.Velocity=Vector3.new(0,Force,0)
		BV.Parent = Balloon

		local sm=Instance.new('SpecialMesh')
		sm.MeshType='Sphere'
		sm.Scale=Vector3.new()
		sm.Parent = Balloon
		
		local A2 = Instance.new("Attachment")
		A2.Parent = Balloon
		local P1 = Instance.new("Attachment")
		P1.Parent = Balloon
		local P2 = Instance.new("Attachment")
		P2.Parent = Bar

		local Rope = Instance.new("RopeConstraint")
		Rope.Length = 8
		Rope.Visible = true
		Rope.Color = BrickColor.new("Really black")

		Rope.Attachment0 = P1

		Rope.Attachment1 = P2
		Rope.Parent = Balloon

		Bar.Parent = parent.Parent

		local Weld = Instance.new("WeldConstraint")
		Weld.Part0 = part.Parent:FindFirstChild("HumanoidRootPart")
		Weld.Part1 = Bar
		Weld.Parent = Bar

		Balloon.Parent = parent.Parent

		local ZPA = Instance.new("Animation")
		ZPA.AnimationId = "rbxassetid://3268037702"
		local ZPAT = part.Parent:FindFirstChild("Humanoid"):LoadAnimation(ZPA)
		ZPAT:Play()

		local pos=parent.Position.Y
		local StartTime=os.clock
		local sound=Play('Inflate')
		tween(sm,2,{Scale=Vector3.new(1,1.25,1)})

		repeat 
			task.wait() 
		until (os.clock()-StartTime>WaitTime or Bar.Position.Y>pos+MaxHeight) or autodisconnect or part.Parent:WaitForChild("Humanoid").Health<=0

		if sound then 
			sound:Destroy() 
		end

		Play('Pop')
		BV:Destroy()
		local cf=Balloon.CFrame
		Balloon.CFrame=cf
		Weld:Destroy()
		Balloon.Transparency=1
		Riding=false

		task.defer(function() 
			task.wait(0.5) 
			bdelay = false 
		end)

		Bar.CanCollide=true
		Balloon.CanCollide=true

		task.delay(7,function()
			tween(Bar,5,{Transparency=1})
			task.wait(5)
			Bar:Destroy()
			Balloon:Destroy()
		end)

		ZPAT:Stop()
		ZPAT:Destroy()
		part.Parent.Humanoid:ChangeState('Jumping')
	end)
end