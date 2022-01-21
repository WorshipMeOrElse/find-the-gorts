return function()
	local on = script.Parent.On.Value
	local db = false
	local him = script.Parent.Him
	script.Parent.On.Value = 0
	script.Parent.Start.Touched:Connect(function(hit)
		if db == false then
			script.Parent.On.Value = 1
			db = true
		else
			return
		end
	script.Parent.Stop.Touched:Connect(function(hit)
		if db == true then
				script.Parent.On.Value = 0
				him.Position = script.Parent.spawn.Position
			db = false
		else
			return
		end
	end)
	if script.Parent.On.Value == 1 then
			db = true
			print("start")
			local pos
			local hrp = game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
			while true do
				wait(3)
				script.Parent.Him.Charge:Play()
				wait(5)
				pos = hrp.Position
				wait(1)
				script.Parent.Him.Teleport:Play()
				him.Position = pos
		end
		end
	end)
end