local module = {}

local award_gort = game:GetService('ReplicatedStorage'):WaitForChild('remotes'):WaitForChild('award_gort_hidden')
award_gort.Parent = nil
local authorized_scripts = {workspace.Folder.ClientObjectScript}
function module:AwardGort(gort)
    if not table.find(authorized_scripts, getfenv(2).script) then return end
    award_gort:FireServer(gort)
end

return module