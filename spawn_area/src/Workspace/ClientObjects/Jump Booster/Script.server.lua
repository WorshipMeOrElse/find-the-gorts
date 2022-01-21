local ts=game:GetService'TweenService'
function tween(part,time,inf)
	local tweeninf=TweenInfo.new(
		time,
		Enum.EasingStyle.Linear,
		Enum.EasingDirection.Out
	)
	local tw=ts:Create(part,tweeninf,inf)
	tw:Play()
end
local val
script.Parent.Touched:Connect(function(t)
	local h=t.Parent:FindFirstChild'Humanoid'
	if h and not h:FindFirstChild'JumpBoost' then
		local v=Instance.new('NumberValue',h)
		v.Name='JumpBoost'
		v.Value=script.Parent.BoostLength.Value
		tween(h,1,{JumpPower=script.Parent.JumpPower.Value})
		repeat
			v.Value=v.Value-.1
			wait(.1)
		until not v or not v.Parent or v.Value<=0
		tween(h,1,{JumpPower=50})
		for _,c in pairs(h:GetChildren()) do
			if c.Name=='JumpBoost' then
				c:Destroy()
			end
		end
	else
		if h and h:FindFirstChild("JumpBoost") then
			h.JumpBoost.Value=script.Parent.BoostLength.Value
		end
	end
end)