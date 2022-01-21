local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local Players = game:GetService("Players")

local Admins = {'theCoolKidaround2020', 'porkchopen', 'xgold4428', 'pnmpki'} -- Change this to your name.

ChatService.SpeakerAdded:Connect(function(PlrName)
	local Speaker = ChatService:GetSpeaker(PlrName)
	if not table.find(Admins, PlrName) then return end
	Speaker:SetExtraData('Tags', {{TagText = "Tester", TagColor = Color3.fromRGB(101, 207, 35)}})
end)