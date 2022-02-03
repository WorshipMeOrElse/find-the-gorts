local code = 'StudioGort.Transparency=0'

local input = script.Parent.Parent
local gui = input.Parent
local clientobjectscript = workspace.ClientObjects.CustomClientObjects.studio_gort_computer.ClientObjectScript
local gort = script.Parent:WaitForChild('Studio Gort')
gort.Parent = nil

local check = function()
	if string.gsub(input.Text, "%s+", "") ~= code then return end
	
	task.defer(function()
		gui.Parent = clientobjectscript
		gort.Parent = workspace
		script.Parent:Destroy()
		return
	end)
end

input.FocusLost:ConnectParallel(check)
input.TextBoxFocusReleased:Connect(check)