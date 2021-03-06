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
		thing_to_edit[l] = p
	end

	task.wait(2)
end

local damage_event = game:GetService('ReplicatedStorage'):WaitForChild('DamageEvent')

script.Parent:WaitForChild("Humanoid").Touched:Connect(function(tP)
	if tP.Name=='LightingChanger' and tP:FindFirstChild'Configuration' then
		SetLighting(require(tP.Configuration))
	else
		local damage = (tP:FindFirstChild("kills") and 'Normal') or (tP:FindFirstChild('ouch') and 'HighDamage') or (tP:FindFirstChild('instakills') and 'Instakill') or nil
		if not damage then return end
		damage_event:FireServer(damage)
 	end	
end)