phs = game:GetService("PhysicsService")

local def='Default'
local plr='Player'
local otherplrs='OtherPlayers'
local collidewplrs='OnlyCollideWithPlayers'
local nocollidewplrs='DoNotCollideWithPlayers'
phs:CreateCollisionGroup(plr)
phs:CreateCollisionGroup(otherplrs)
phs:CreateCollisionGroup(collidewplrs)
phs:CreateCollisionGroup(nocollidewplrs)
phs:CollisionGroupSetCollidable(plr,otherplrs,false)
phs:CollisionGroupSetCollidable(def,otherplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs,otherplrs,false)
phs:CollisionGroupSetCollidable(nocollidewplrs,otherplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs,def,false)
phs:CollisionGroupSetCollidable(collidewplrs,nocollidewplrs,false)
phs:CollisionGroupSetCollidable(plr,nocollidewplrs,false)

--[[
local players = game:GetService('Players')
game:GetService('Players').PlayerAdded:Connect(function(p)
	phs:CreateCollisionGroup(p.Name)
	phs:CollisionGroupSetCollidable(p.Name,p.Name,true)
	for i,v in ipairs(game.Players:GetChildren()) do
		if v ~= p then
			phs:CollisionGroupSetCollidable(p.Name,v.Name,false)
		end
	end
	p.CharacterAdded:connect(function(c)
		for i,v in ipairs(c:GetChildren()) do
			if v:IsA("BasePart") then
				phs:SetPartCollisionGroup(v,p.Name)
			end
		end
		c.ChildAdded:connect(function(v)
			if v:IsA("BasePart") then
				phs:SetPartCollisionGroup(v,p.Name)
			end
		end)
	end)
end)

players.PlayerRemoving:Connect(function(p)
	phs:RemoveCollisionGroup(p.Name)
end)
]]