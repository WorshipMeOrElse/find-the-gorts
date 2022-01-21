local frame = script.Parent.Parent.Frame
local open = true

--temporary starts here
local jumpscare = script.jumpscare
local image = script.image

script.Parent.Activated:Connect(function()
	if not open then return end
	
	open = false
	image.Parent = script.Parent.Parent
	game:GetService('TweenService'):Create(image, TweenInfo.new(4.08, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {ImageTransparency = 1}):Play()
	jumpscare:Play()
	task.wait(4.08)
	image.ImageTransparency = 0
	image.Parent = script
	open = true
end)
--temporary ends here

--[[
script.Parent.Activated:Connect(function()
	open = not open
	frame.Visible = open
end)
]]