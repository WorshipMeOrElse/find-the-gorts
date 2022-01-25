local unitmass=workspace.Gravity

local p=script.Parent
local m=p.Parent
local vf= m.Base.VectorForce
local db=true

local totalmass=0

for _,v in ipairs(m:GetDescendants()) do
	if not (v:IsA("BasePart") and v.Anchored==false) then continue end
	totalmass=totalmass+((v.Size.X*v.Size.Y*v.Size.Z)*v.CustomPhysicalProperties.Density*unitmass)
end

local defaultforce=Vector3.new(0,0,1)*totalmass + Vector3.new(0,0,100)
vf.Force=Vector3.new(0,0,-1)*totalmass

return function()
	local thing
	thing=game:GetService('RunService').Heartbeat:Connect(function()
		if not p or not p:FindFirstChild('PrismaticConstraint') then
			thing:Disconnect()
			return
		end

		if p.PrismaticConstraint.CurrentPosition >= (p.PrismaticConstraint.UpperLimit-0.2) and db==true then
			db=false
			vf.Force=defaultforce*3
			repeat
				task.wait(.1)
			until p.PrismaticConstraint.CurrentPosition <= (p.PrismaticConstraint.LowerLimit+0.2)
			vf.Force=defaultforce
			db=true
		end
	end)
end