local gui = script.Parent.Parent.Parent
local clientobjectscript = workspace.ClientObjects.CustomClientObjects.studio_gort_computer.ClientObjectScript

script.Parent.Activated:Connect(function()
	gui.Parent = clientobjectscript
end)