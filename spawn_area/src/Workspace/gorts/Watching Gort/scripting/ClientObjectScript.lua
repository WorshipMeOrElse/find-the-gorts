return function()
	local camera = workspace.CurrentCamera
	local part = script.Parent.Parent
	local path_children = script.Parent["Really stupid tightrope"]:GetChildren()
	
	while true do
		local dot_product = camera.CFrame.LookVector:Dot(part.CFrame.LookVector)
		local looking = dot_product > -1 and dot_product < -0.97
		local transparency = looking and 0 or 1
		
		for _, part in ipairs(path_children) do
			part.Transparency = transparency
			part.CanCollide = looking
		end
		
		task.wait(1)
	end
end