local init = script.Parent.Size
local init2 = script.Parent
local tw1 = game:GetService("TweenService"):Create(script.Parent,TweenInfo.new(1,Enum.EasingStyle.Bounce),{Size = init + Vector3.new(0, 1, 1)})
local tw2 = game:GetService("TweenService"):Create(script.Parent,TweenInfo.new(1,Enum.EasingStyle.Sine),{Size = init})
while true do
	tw1:Play()
	wait(1)
	tw2:Play()
	wait(1)
end