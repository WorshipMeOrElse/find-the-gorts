local tween_service = game:GetService("TweenService")
local lighting = game:GetService('Lighting')
local origlighting={}
local origcclighting={}

local function SetLighting(c,ltype)
	if not c then return end
	c = (c=='Default' and origlighting) or c

	local is_color_correction = (ltype=='ColorCorrection' and lighting:FindFirstChild('ColorCorrection'))
	local thing_to_edit = (is_color_correction and lighting.ColorCorrection) or lighting
	local lighting_table = (is_color_correction and origcclighting) or origlighting

	tween_service:Create(thing_to_edit, TweenInfo.new(3), c):Play()
	for l, p in pairs(c) do
		if lighting_table[l] then continue end
		lighting_table[l] = thing_to_edit[l]

		if not (type(p)=='string' or type(p)=='boolean') then continue end
		thing_to_edit[l] = p
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