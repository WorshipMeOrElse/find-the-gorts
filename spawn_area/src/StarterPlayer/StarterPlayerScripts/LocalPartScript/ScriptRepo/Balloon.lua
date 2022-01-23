local ts=game:GetService'TweenService'
local function tween(part,time,inf)
	local tweeninf=TweenInfo.new(
		time,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)
	local tw=ts:Create(part,tweeninf,inf)
	tw:Play()
end

local sounds={
	Inflate='rbxassetid://11895499',
	Pop='rbxassetid://11895500'
}
local function Play(snd,par)
	local s=Instance.new('Sound')
	s.SoundId=sounds[snd] or ''
	s.Parent = par
	s:Play()
	game.Debris:AddItem(s,10)
	return s
end

local userinput=game:GetService('UserInputService')
local NOJUMPALLOWED=script.Parent:FindFirstChild'CannotDismount' and script.Parent.CannotDismount.Value

local bdelay = false

return function()
	local WaitTime=script.Parent:FindFirstChild'WaitTime' and script.Parent.WaitTime.Value or 5
	local MaxHeight=script.Parent:FindFirstChild'MaxHeight' and script.Parent.MaxHeight.Value or 20
	local Force=script.Parent:FindFirstChild'Force' and script.Parent.Force.Value or 5

	WaitTime = WaitTime <= 0 and math.huge or WaitTime

	local Riding = false
	local val

	if script.Parent.Name=='ButtonActivatedBalloonDispenser' then
		val=Instance.new('BoolValue')
		val.Name='Activated'
		val.Parent = script.Parent
	end

	for _,d in ipairs(script.Parent:GetChildren()) do
		if not d:IsA('Decal') then continue end
		d.Color3=script.Parent.Color
	end

	script.Parent.Touched:Connect(function(part)
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

		local Rope = Instance.new("RopeConstraint")
		local Balloon = Instance.new("Part")
		local Bar = Instance.new("Part")
		local A2 = Instance.new("Attachment")
		local P1 = Instance.new("Attachment")
		local P2 = Instance.new("Attachment")
		local Weld = Instance.new("WeldConstraint")

		Bar.Size = Vector3.new(3,0.4,0.4)
		Bar.Material = Enum.Material.SmoothPlastic
		Bar.CanCollide = false
		Bar.CFrame = part.Parent:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0,2.6,0)
		Bar.CustomPhysicalProperties = PhysicalProperties.new(10,0,0)
		Bar.Color = script.Parent.Color

		Balloon.Shape='Ball'
		Balloon.Material='Neon'
		Balloon.Size = Vector3.new(2,2,2)
		Balloon.CanCollide = true
		Balloon.Color=script.Parent.Color
		Balloon.CustomPhysicalProperties = PhysicalProperties.new(20,0,0) 
		Balloon.CFrame = script.Parent.CFrame

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

		A2.Parent = Balloon
		P1.Parent = Balloon
		P2.Parent = Bar

		Rope.Length = 8
		Rope.Visible = true
		Rope.Color = BrickColor.new("Really black")
		Rope.Attachment0 = P1
		Rope.Attachment1 = P2
		Rope.Parent = Balloon

		Bar.Parent = script.Parent.Parent

		Weld.Part0 = part.Parent:FindFirstChild("HumanoidRootPart")
		Weld.Part1 = Bar
		Weld.Parent = Bar

		Balloon.Parent = script.Parent.Parent

		local ZPA = Instance.new("Animation")
		ZPA.AnimationId = "rbxassetid://3268037702"
		local ZPAT = part.Parent:FindFirstChild("Humanoid"):LoadAnimation(ZPA)
		ZPAT:Play()

		local pos=script.Parent.Position.Y
		local StartTime=os.clock
		local sound=Play('Inflate',Balloon)
		tween(sm,2,{Scale=Vector3.new(1,1.25,1)})

		repeat 
			task.wait() 
		until (os.clock()-StartTime>WaitTime or Bar.Position.Y>pos+MaxHeight) or autodisconnect or part.Parent:WaitForChild("Humanoid").Health<=0

		if sound then 
			sound:Destroy() 
		end

		Play('Pop',Balloon)
		BV:Destroy()
		local cf=Balloon.CFrame
		Balloon.Size=Vector3.new()
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
		part.Parent:WaitForChild("Humanoid"):ChangeState'Jumping'
	end)
end