local remote_manager = require(game:GetService("ReplicatedStorage"):WaitForChild('modules'):WaitForChild('remotemanager'))
local remote = remote_manager:CreateEvent()
remote.Name = 'poptart'

local sound = game:GetService('SoundService').sound_effects:WaitForChild('tada')
local gort = workspace.gorts:WaitForChild('Poptart Gort')
local gort_manager = require(game:GetService('ServerStorage'):WaitForChild('modules'):WaitForChild('gort_manager'))
local toaster = script.Parent

for _, decal in ipairs(gort:GetChildren()) do
    if not decal:IsA('Decal') then continue end
    decal.Transparency = 1
end

toaster:WaitForChild('ClickDetector').MouseClick:Connect(function(player_who_clicked)
    toaster.visuals.Parent = player_who_clicked.PlayerGui
    remote:FireClient(player_who_clicked)
    sound:Play()
    gort_manager:AwardGort(player_who_clicked, gort)
    remote:Destroy()
    script:Destroy()
end)