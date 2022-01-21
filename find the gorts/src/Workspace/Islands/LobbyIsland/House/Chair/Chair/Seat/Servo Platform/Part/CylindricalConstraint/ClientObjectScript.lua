return function()
	local h = game.Players.LocalPlayer.Character.Humanoid
	repeat wait() h = game.Players.LocalPlayer.Character.Humanoid until script.Parent.Parent.Parent.Parent.Occupant == h
	script.Parent.Parent.Parent.Parent.Sound:Play()
	while true do
		wait(script.Parent.Parent.Parent.Delay.Value)
		script.Parent.AngularSpeed = script.Parent.Parent.Parent.Speed.Value
		script.Parent.TargetAngle += script.Parent.Parent.Parent.Angle.Value
	end
end