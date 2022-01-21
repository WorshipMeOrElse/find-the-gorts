local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local Players = game:GetService("Players")

local Admins = {'mynameistrixxr'} -- Change this to your name.

ChatService.SpeakerAdded:Connect(function(PlrName)
	local Speaker = ChatService:GetSpeaker(PlrName)
	if not table.find(Admins, PlrName) then return end
	Speaker:SetExtraData('Tags', {{TagText = "Owner", TagColor = Color3.fromRGB(169, 252, 239)}})
end)