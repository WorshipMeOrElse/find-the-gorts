local phs = game:GetService('PhysicsService')
local origlighting={}

--all of the code below here is no longer used in new buttons but there for compatibility's sake
function GetAllButtons(color)
	local buttont={}
	for _,b in pairs(workspace:GetDescendants()) do
		if b.Name=='Button' and b:FindFirstChild'ClientObject' and b:FindFirstChild'Pressed' then
			local doinsert
			if color then
				for _,d in pairs(b:GetDescendants()) do
					if d:IsA'BasePart' and d.Color==color then
						doinsert=true
					end
				end
			else
				doinsert=true
			end
			if doinsert then 
				table.insert(buttont, #buttont+1, b) 
			end
		end
	end
	return buttont
end

local mt={}
mt.__index=function(_,i)
	if i=='All' then
		return GetAllButtons()
	end
	return GetAllButtons(i)
end
mt.__newindex=function()
	
end
mt.__call=function(_,mode,val,color)
	if mode=='Get' then
		return GetAllButtons()
	elseif mode=='SetAll' then
		for _,b in pairs(GetAllButtons(color)) do
			b.Pressed.Value=val
		end
	end
end

_G.Buttons=setmetatable({},mt)

function ApplyPart(w)
	if w.Name=='ChangeLighting' then
		for p,l in pairs(require(w)) do
			if not origlighting[p] then
				origlighting[p]=game.Lighting[p]
			end
			game.Lighting[p]=l
		end
	end
	if w.Name=='LightingChanger' and w:IsA'BasePart' then
		w.Transparency=1
	end
	if w:FindFirstChild'invisible' and w:IsA'BasePart' then
		w.Transparency=1
	end
	if w.Name == "RunRepoScript" and w:IsA"StringValue" then
		local scr = script.ScriptRepo:FindFirstChild(w.Value)
		if scr then
			scr = scr:Clone()
			scr.Name = "RepoScript"
			scr.Parent = w.Parent
			task.spawn(function()
				require(scr)()
			end)
		end
	end
	
	if w.Name == "ClientObjectScript" then
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

local function addChildren(p,np)
	p.ChildAdded:Connect(function(v)
		local c = v.Clone()
		c.Parent = np
		addChildren(v,c)
		ApplyPart(p)
	end)
end

local addPart = function(v)
	if v.Name == "ClientObject" then
		local c = v.Parent:Clone()
		c.Parent = v.Parent.Parent
		v.Parent:Destroy()
		addChildren(v,c)
		ApplyPart(c)
		for _,w in pairs(c:GetDescendants()) do
			ApplyPart(w)
		end
		v:Destroy()
	end
end

function initplr(p)
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

for _,d in pairs(workspace:GetDescendants()) do
	addPart(d)
end