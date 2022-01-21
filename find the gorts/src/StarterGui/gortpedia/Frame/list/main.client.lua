local d=require(game.ReplicatedStorage.difficulties)
local gorts,totalgorts = {},0
for _,v in ipairs(workspace.gorts:GetChildren()) do
	local d = v:FindFirstChildWhichIsA('Decal')
	gorts[v.Name] = {
		name = v.Name;
		image = (d and d.Texture) or "http://www.roblox.com/asset/?id=8158806975";
		color = (d and d.Color3) or Color3.new(1,1,1);
		difficulty = v:GetAttribute('difficulty');
		description = (v:GetAttribute('description')) or "no description";
		location = v:GetAttribute('location')
	}
	totalgorts += 1
end
local pdata = {}
local currentinfo

local function info(gort)
	currentinfo = gort
	if gort then
		local ib = script.Parent.Parent.info
		ib.diff.Text = gort.difficulty
		ib.diff.TextColor3 = d[gort.difficulty][1]
		ib.icon.Image = gort.image
		ib.icon.ImageColor3 = gort.color
		ib.name.Text = gort.name
		if pdata[gort.name] then
			ib.found.Text = "this gort has been found!"
			ib.found.TextColor3 = Color3.new(0, 0.792157, 0.329412)
		else
			ib.found.Text = "this gort has not been found yet!"
			ib.found.TextColor3 = Color3.new(0.729412, 0.0823529, 0.0823529)
		end
		
		ib.desc.Text = gort.description
	end
end

local filter = "All"

game.ReplicatedStorage.refresh.OnClientEvent:Connect(function(data)
	pdata = data
	for _,v in pairs(script.Parent:GetChildren()) do
		if v:IsA("Frame") then
			v:Destroy()
		end
	end
	local foundgorts = 0
	for _,gort in pairs(gorts) do
		local wsl = workspace:FindFirstChild(gort.name)
		local c = script.gort:Clone()
		c.icon.ImageTransparency = (data[gort.name] and 0) or .5
		c.icon.ImageColor3 = gort.color
		local uic = Instance.new("UICorner")
		uic.Parent = c
		uic.CornerRadius = UDim.new(0,8)
		c.BackgroundColor3 = d[gort.difficulty][1]
		if data[gort.name] then
			foundgorts += 1
			c.BackgroundTransparency = 0
		end
		c.icon.Image = gort.image
		c.LayoutOrder = d[gort.difficulty][2]
		c.hitbox.MouseButton1Click:Connect(function()
			info(gort)
		end)
		if (gort.location == filter) or filter == "All" then
			c.Parent = script.Parent
		end
	end
	script.Parent.Parent.amount.Text = " "..tostring(foundgorts).."/"..tostring(totalgorts)
	info(currentinfo)
end)
script.Parent.Parent.Parent.open.MouseButton1Click:Connect(function()
	script.Parent.Parent.Visible = not script.Parent.Parent.Visible
end)

game.ReplicatedStorage.new.OnClientEvent:Connect(function(gortname,txt)
	game.StarterGui:SetCore("SendNotification",{
		Title="New Gort!";
		Text=gortname,
		Icon=txt,
		Duration = 5
	})
end)

local main = script.Parent.Parent
local filterdb = false
main.open.MouseButton1Click:Connect(function()
	filterdb = not filterdb
	main.areas.Visible = filterdb
end)

for _, b in ipairs(main.areas:GetChildren()) do
	if b:IsA("TextButton") then
		b.MouseButton1Click:Connect(function()
			filter = b.Text
			main.current.Text = filter
			game.ReplicatedStorage.refresh:FireServer()
			filterdb = not filterdb
			main.areas.Visible = filterdb
		end)
	end
end