local player = game:GetService('Players').LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local animator = character:WaitForChild('Humanoid'):WaitForChild('Animator')

local animationid = 'rbxassetid://7968970539'

local playanimation = function()
	local temp_animation = Instance.new('Animation')
	temp_animation.AnimationId = animationid
	animator:LoadAnimation(temp_animation):Play()
	temp_animation:Destroy()
end

local tool = script.Parent
tool.Activated:Connect(function()
	tool.Enabled = false
	
	playanimation()
	task.wait(0.2)
	tool.Enabled = true
end)