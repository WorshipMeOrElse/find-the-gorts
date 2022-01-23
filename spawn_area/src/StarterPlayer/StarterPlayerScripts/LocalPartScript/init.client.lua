--all of the code below here is no longer used in new buttons but there for compatibility's sake
local phs = game:GetService('PhysicsService')
local lighting = game:GetService('Lighting')
local origlighting={}

local function ApplyPart(w)
	if w.Name=='ChangeLighting' then
		for p,l in ipairs(require(w)) do
			if not origlighting[p] then
				origlighting[p]=lighting[p]
			end

			lighting[p]=l
		end
	elseif (w.Name=='LightingChanger') and w:IsA'BasePart' then
		w.Transparency=1
	elseif w.Name == "RunRepoScript" and w:IsA"StringValue" then
		local scr = script.ScriptRepo:FindFirstChild(w.Value)

		if not scr then 
			warn('error inside of '..w.Parent..': reposcript named '..w.Value..' not found!') 
			return 
		end

		scr = scr:Clone()
		scr.Name = "RepoScript"
		scr.Parent = w.Parent
		task.defer(function()
			require(scr)()
		end)
	elseif w.Name == "ClientObjectScript" then
		task.delay(.05,function()
			require(w)()
		end)
	elseif w:IsA("BasePart") then
		if w:FindFirstChild('SetCollisionGroup') then
			task.spawn(function()
				phs:SetPartCollisionGroup(w,w.SetCollisionGroup.Value)
			end)
		end
	end
end

for _,d in ipairs(workspace:GetDescendants()) do
	if d.Name == "ClientObject" then
		local parent = d.Parent
		ApplyPart(parent)
		for _,w in ipairs(parent:GetDescendants()) do
			ApplyPart(w)
		end
		d:Destroy()
	end
end

local function initplr(p)
	local function initchar(c)
		if not c then return end
		for _,v in pairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				phs:SetPartCollisionGroup(v,'OtherPlayers')
			end
		end
		c.ChildAdded:connect(function(v)
			if v:IsA("BasePart") then
				phs:SetPartCollisionGroup(v,'OtherPlayers')
			end
		end)
	end
	p.CharacterAdded:Connect(initchar)
	initchar(p.Character)
end

local players = game:GetService('Players')
players.PlayerAdded:Connect(initplr)

for _,p in ipairs(players:GetPlayers()) do
	initplr(p)
end

local p = players.LocalPlayer
local function initchar(c)
	if not c then return end
	for _,v in pairs(c:GetChildren()) do
		if v:IsA("BasePart") then
			phs:SetPartCollisionGroup(v,'Player')
		end
	end

	c.ChildAdded:connect(function(v)
		if v:IsA("BasePart") then
			phs:SetPartCollisionGroup(v,'Player')
		end
	end)
end

p.CharacterAdded:Connect(initchar)
initchar(p.Character)