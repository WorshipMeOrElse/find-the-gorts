--this is mainly for making remotes more script based instead of instance based
--I was also too lazy to install the aerogameframework
local module = {}
local remotes_folder = script:WaitForChild('Folder')

function module:CreateEvent()
    local event = Instance.new('RemoteEvent')
    event.Parent = remotes_folder
    return event
end

function module:CreateFunction()
    local func = Instance.new('RemoteFunction')
    func.Parent = remotes_folder
    return func
end

local run_service = game:GetService("RunService")

function module:GetConnection(name)
    local instance = remotes_folder[name]
    local isclient = run_service:IsClient()

    if instance:IsA('RemoteEvent') then
        if isclient then
            return instance.OnClientEvent
        else
            return instance.OnServerEvent
        end
    else
        if isclient then
            return instance.OnClientInvoke
        else
            return instance.OnServerInvoke
        end
    end
end

return module