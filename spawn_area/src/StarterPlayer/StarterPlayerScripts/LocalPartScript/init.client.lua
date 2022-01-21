local ts=game:GetService'TweenService'
local bounce = false
local uip=game:GetService'UserInputService'
local phs=game:GetService'PhysicsService'
local origlighting={}
local origcclighting={}
--if workspace:FindFirstChild('CPBricks') then
--	workspace.CPBricks:Destroy()
--end
function _G:SetLighting(c,ltype)
	if not c then return end
	local dur=2
	if ltype=='ColorCorrection' and game.Lighting:FindFirstChild('ColorCorrection') then
		if c=='Default' then c=origcclighting end
		for l,p in pairs(c) do
			if not origcclighting[l] then
				origcclighting[l]=game.Lighting.ColorCorrection[l]
			end
		end
		local conf=TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
		local tw=ts:Create(game.Lighting.ColorCorrection,conf,c)
		tw:Play()
		for l,p in pairs(c) do
			if type(p)=='string' or type(p)=='boolean' then 
				game.Lighting.ColorCorrection[l]=p
			end
		end
	else
		if c=='Default' then c=origlighting end
		for l,p in pairs(c) do
			if not origlighting[l] then
				origlighting[l]=game.Lighting[l]
			end
		end
		local conf=TweenInfo.new(3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out)
		local tw=ts:Create(game.Lighting,conf,c)
		tw:Play()
		for l,p in pairs(c) do
			if type(p)=='string' or type(p)=='boolean' then 
				game.Lighting[l]=p
			end
		end
	end
	wait(dur)
end

--all of the code below here is no longer used in new buttons but there for compatibility's sake
function CheckColor3(color)
	return pcall(function()
		local yeet=color:lerp(Color3.new(),1)
	end)
end
function GetAllButtons(color)
	local IsColor3=CheckColor3(color)
	local buttont={}
	for _,b in pairs(workspace:GetDescendants()) do
		if b.Name=='Button' and b:FindFirstChild'ClientObject' and b:FindFirstChild'Pressed' then
			local doinsert
			if color and IsColor3 then
				for _,d in pairs(b:GetDescendants()) do
					if d:IsA'BasePart' and d.Color==color then
						doinsert=true
					end
				end
			else
				doinsert=true
			end
			if doinsert then table.insert(buttont,#buttont+1,b) end
		end
	end
	return buttont
end

local mt={}
mt.__index=function(t,i)
	if i=='All' then
		return GetAllButtons()
	end
	return GetAllButtons(i)
end
mt.__newindex=function()
	
end
mt.__call=function(t,mode,val,color)
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
			spawn(function()
				require(scr)()
			end)
		end
	end
	if w.Name == "ClientObjectScript" then
		delay(.05,function()
			spawn(function()
				require(w)()
			end)
		end)
	elseif w:IsA("BasePart") then
		if w:FindFirstChild'SetCollisionGroup' then
			spawn(function()
				phs:SetPartCollisionGroup(w,w.SetCollisionGroup.Value)
			end)
		end
--		spawn(function()
--			while not game.Players.LocalPlayer.Character do wait() end
--			while game.Players.LocalPlayer.Character:WaitForChild("Head").CollisionGroupId == 0 do wait() end
--			w.CollisionGroupId = game.Players.LocalPlayer.Character:WaitForChild("Head").CollisionGroupId
--		end)
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
		for j,w in pairs(c:GetDescendants()) do
			ApplyPart(w)
		end
		v:Destroy()
	end
end

function initplr(p)
	local function initchar(c)
		if not c then return end
		for i,v in pairs(c:GetChildren()) do
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
game.Players.PlayerAdded:Connect(initplr)
for _,p in pairs(game.Players:GetPlayers()) do
	initplr(p)
end
local p=game.Players.LocalPlayer
local function initchar(c)
	if not c then return end
	for i,v in pairs(c:GetChildren()) do
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