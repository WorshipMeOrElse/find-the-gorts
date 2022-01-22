local module = {}

function module:GetButtons(color)
    local buttont={}

    if color == 'All' then
        for _,b in ipairs(workspace:GetDescendants()) do
            if not (b.Name=='Button' and b:FindFirstChild'ClientObject' and b:FindFirstChild'Pressed') then continue end
            table.insert(buttont, b) 
        end
    else
	    for _,b in ipairs(workspace:GetDescendants()) do
		    if not (b.Name=='Button' and b:FindFirstChild'ClientObject' and b:FindFirstChild'Pressed') then continue end
		  	for _,d in ipairs(b:GetDescendants()) do
				if not (d:IsA'BasePart' and d.Color==color) then continue end
                table.insert(buttont, b) 
            end
        end
    end

    return buttont
end

function module:SetButtons(value, color)
    for _, button in ipairs(color) do
        button.Pressed.Value = value
    end
end

return module