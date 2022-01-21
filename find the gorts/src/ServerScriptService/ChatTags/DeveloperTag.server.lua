local ServerScriptService = game:GetService("ServerScriptService")
local ChatService = require(ServerScriptService:WaitForChild("ChatServiceRunner"):WaitForChild("ChatService"))
local Players = game:GetService("Players")

local Admins = {'Unpickled', 'TheNooobly', 'Deelusion', 'poopyman112234', 'seanieplays', 'MMO_nster'} -- Change this to your name.

ChatService.SpeakerAdded:Connect(function(PlrName)
	local Speaker = ChatService:GetSpeaker(PlrName)
	if not table.find(Admins, PlrName) then return end
	Speaker:SetExtraData('Tags', {{TagText = "Developer", TagColor = Color3.fromRGB(0, 62, 177)}})
end)