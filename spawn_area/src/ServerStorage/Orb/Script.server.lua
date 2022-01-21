local init = script.Parent.Base.CFrame
local init2 = script.Parent.Base
local tw1 = game:GetService("TweenService"):Create(script.Parent.PrimaryPart,TweenInfo.new(2,Enum.EasingStyle.Sine),{CFrame = init * CFrame.new(0, 1, 0)})
local tw2 = game:GetService("TweenService"):Create(script.Parent.PrimaryPart,TweenInfo.new(2,Enum.EasingStyle.Sine),{CFrame = init})
while true do
	tw1:Play()
	wait(2)
	tw2:Play()
	wait(2)
end