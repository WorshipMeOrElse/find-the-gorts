local remote_manager = require(game:GetService("ReplicatedStorage"):WaitForChild('modules'):WaitForChild('remotemanager'))
local gort = workspace.gorts:WaitForChild('Poptart Gort')

remote_manager:GetConnection('poptart'):Connect(function()
    for _, decal in ipairs(gort:GetChildren()) do
        if not decal:IsA('Decal') then continue end
        decal.Transparency = 0
    end
    
    script:Destroy()
end)