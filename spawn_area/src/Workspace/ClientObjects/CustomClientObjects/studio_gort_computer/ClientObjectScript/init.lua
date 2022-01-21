return function()
	local gui = script.studio_gort
	local gort = workspace.gorts:WaitForChild('Studio Gort')
	gort.Parent = nil
	local playergui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
	
	script.Parent.ClickDetector.MouseClick:Connect(function()
		gort.Parent = gui.script_editor.Actor
		gui.Parent = playergui
	end)
end