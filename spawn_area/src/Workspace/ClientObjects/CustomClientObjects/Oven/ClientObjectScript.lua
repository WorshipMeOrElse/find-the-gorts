local db = false
local door = script.Parent.Part
local tl = script.Parent.SurfaceGui.TextLabel
function gettime(inittime,minutes)
	local min = string.split(tostring(minutes-((os.clock() - inittime)/60)%60),".")[1]
	if string.len(min) == 1 then min = "0"..min end
	local sec = string.split(tostring(60-(os.clock() - inittime)% 60),".")[1]
	if string.len(sec) == 1 then sec = "0"..sec end
	return 	min..":"..sec
end

return function()
	door.ClickDetector.MouseClick:Connect(function(plr)
		if plr == game.Players.LocalPlayer and not db then
			db = true
			door.Color = Color3.fromRGB(188, 155, 93)
			local inittime = os.clock()
			repeat tl.Text =  gettime(inittime,5) wait()
			until (os.clock() - inittime) >= 600
			door.Transparency = 1
			door.CanCollide = false
			inittime = os.clock()
			local TL = Instance.new("TextLabel",game.Players.LocalPlayer.PlayerGui.EffectGUI) 
			TL.Text = "You have 5 minutes before your pizza burns!"
			TL.BackgroundColor3 = Color3.new(0.196078, 0.196078, 0.196078)
			TL.BackgroundTransparency = 0.4
			TL.TextColor3 = Color3.fromRGB(255, 255, 255)
			TL.Size = UDim2.fromScale(0.2,0.1)
			TL.Position = UDim2.fromScale(0.4,1)
			TL.TextWrapped = true
			TL.TextSize = 40
			TL.Font = Enum.Font.GothamSemibold
			local US = Instance.new("UIStroke",TL)
			US.Thickness = 2
			local UC = Instance.new("UICorner",TL)
			game:GetService("TweenService"):Create(TL, TweenInfo.new(.2),{Size = UDim2.fromScale(0.5,0.2), Position = UDim2.fromScale(0.25,0.6)}):Play()
			spawn(function() wait(5)
			TL:Destroy() end)
			repeat tl.Text =  gettime(inittime,5) wait()
			until (os.clock() - inittime) >= 300
			door.Transparency = 0.7
			door.CanCollide = true
			door.Color = Color3.fromRGB(188, 0, 0)
			tl.Text = "Your pizza has burnt. Please rejoin to try again."
		end
	end)
end