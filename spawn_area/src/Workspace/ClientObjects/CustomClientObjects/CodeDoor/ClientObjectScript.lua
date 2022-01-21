return function()
	local codedoor = script.Parent
	local code = '77696772657873676576'
	local input = ''
	
	local keypad = codedoor.KeyPad
	
	local pressed = function(key)
		key.Size *= 1.2
		task.wait(0.1)
		key.Size /= 1.2
	end
	
	for _, key in ipairs(keypad:GetChildren()) do
		if not string.find(key.Name, 'B') then continue end
	
		key.ClickDetector.MouseClick:Connect(function()
			input = input..string.gsub(key.Name, 'B', '')
	
			pressed(key)
		end)
	end
	
	local tweenservice = game:GetService('TweenService')
	
	local door = codedoor.Door
	local tween = tweenservice:Create(door, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {Transparency = 1, CanCollide = false})
	
	local enter = keypad.Enter
	enter.ClickDetector.MouseClick:Connect(function()
		pressed(enter)
		if code ~= input then input = '' return end
		tween:Play()
		tween.Completed:Wait()
		door:Destroy()
		script:Destroy()
	end)
	
	local clear = keypad.Clear
	clear.ClickDetector.MouseClick:Connect(function()
		input = ''
		pressed(clear)
	end)
end