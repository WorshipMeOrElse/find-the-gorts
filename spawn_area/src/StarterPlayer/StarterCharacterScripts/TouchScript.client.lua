local tween_service = game:GetService("TweenService")
local lighting = game:GetService('Lighting')
local origlighting={}
local origcclighting={}

local function SetLighting(c,ltype)
	if not c then return end
	c = (c=='Default' and origlighting) or c

	if ltype=='ColorCorrection' and lighting:FindFirstChild('ColorCorrection') then
		for l, _ in pairs(c) do
			if origcclighting[l] then continue end
			origcclighting[l]=lighting.ColorCorrection[l]
		end

		tween_service:Create(lighting.ColorCorrection, TweenInfo.new(3), c):Play()

		for l,p in pairs(c) do
			if not (type(p)=='string' or type(p)=='boolean') then continue end
			lighting.ColorCorrection[l]=p
		end
	else
		for l, _ in pairs(c) do
			if origlighting[l] then continue end
			origlighting[l]=lighting[l]
		end

		tween_service:Create(lighting, TweenInfo.new(3), c):Play()

		for l,p in pairs(c) do
			if not (type(p)=='string' or type(p)=='boolean') then continue end
			lighting[l]=p
		end
	end

	task.wait(2)
end

local character = script.Parent
local damage_event = game:GetService('ReplicatedStorage'):WaitForChild('DamageEvent')

character:WaitForChild("Humanoid").Touched:Connect(function(tP)
	if tP.Name=='LightingChanger' and tP:FindFirstChild'Configuration' then
		SetLighting(require(tP.Configuration))
	elseif tP:FindFirstChild("kills") then
		damage_event:FireServer('Normal')
	elseif tP:FindFirstChild("ouch") then
		damage_event:FireServer('HighDamage')
	elseif tP:FindFirstChild("instakills") then
		damage_event:FireServer('Instakill')
	end
end)