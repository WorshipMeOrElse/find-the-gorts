local phs = game:GetService('PhysicsService')
local lighting = game:GetService('Lighting')
local origlighting={}

local function ApplyPart(w)
	if w.Name=='LightingChanger' then
		w.Transparency = 1
	elseif w.Name=='ChangeLighting' then
		for p,l in ipairs(require(w)) do
			lighting[p]=l

			if origlighting[p] then continue end
			origlighting[p]=lighting[p]
		end
	elseif w.Name == "RunRepoScript" and w:IsA"StringValue" then
		local scr = script.ScriptRepo[w.Value]

		scr = scr:Clone()
		scr.Name = 'RepoScript'
		scr.Parent = w.Parent
		task.defer(function()
			require(scr)()
		end)
	elseif w.Name == "ClientObjectScript" then
		task.defer(function()
			require(w)()
		end)
	elseif w:FindFirstChild('SetCollisionGroup') then
		phs:SetPartCollisionGroup(w, w.SetCollisionGroup.Value)
	end
end

for _,d in ipairs(workspace:GetDescendants()) do
	if d.Name == "ClientObject" then
		local clone = d.Parent:Clone()
		clone.Parent = d.Parent.Parent
		d.Parent:Destroy()
		ApplyPart(clone)
		for _,w in ipairs(clone:GetDescendants()) do
			ApplyPart(w)
		end
		d:Destroy()
	end
end

local function initplr(p)
	local function initchar(c)
		for _,v in ipairs(c:GetChildren()) do
			if not v:IsA("BasePart") then continue end
			phs:SetPartCollisionGroup(v,'OtherPlayers')
		end
	end

	p.CharacterAdded:Connect(initchar)
	initchar(p.Character or p.CharacterAdded:Wait())
end

local players = game:GetService('Players')
players.PlayerAdded:Connect(initplr)

for _,p in ipairs(players:GetPlayers()) do
	initplr(p)
end

local p = players.LocalPlayer
local function initchar(c)
	for _,v in ipairs(c:GetChildren()) do
		if not v:IsA("BasePart") then continue end
		phs:SetPartCollisionGroup(v,'Player')
	end
end

p.CharacterAdded:Connect(initchar)