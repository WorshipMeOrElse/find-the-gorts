local module = {}
local data_store_service = game:GetService('DataStoreService'):GetDataStore('12313276323126313209175330')
local player_data = {}
local players = game:GetService('Players')

local replicated_storage = game:GetService('ReplicatedStorage')
local new = replicated_storage:WaitForChild('new')
local refresh = replicated_storage:WaitForChild('refresh')

function module:LoadGorts(player)
	local data
	local retrieved, message = pcall(function()
		data = data_store_service:GetAsync(player.UserId)
	end)
	
	if not retrieved then
		player:Kick('Data hasn\'t loaded properly, please rejoin')
		warn(player.Name..' '..message)
		return nil
	end
	
	player_data[player.UserId] = data or {}
	return data or {}
end

function module:SaveGorts(player)
	data_store_service:SetAsync(player.UserId, player_data[player.UserId])
end

function module:Refresh(player)
	refresh:FireClient(player, player_data[player.UserId])
end

function module:AwardGort(player, gort)
	if player_data[player.UserId][gort.Name] == true then return end
	player_data[player.UserId][gort.Name] = true
	new:FireClient(player, gort.Name, gort.Decal.Texture)
	module:Refresh(player)
end

function module:HasGort(player, gort)
	return player_data[player.UserId][gort.Name] == true
end

game:BindToClose(function()
	for _, player in ipairs(players:GetPlayers()) do
		module:SaveGorts(player)
	end
end)

players.PlayerRemoving:Connect(function(player)
	module:SaveGorts(player)
	player_data[player.UserId] = nil
end)

return module