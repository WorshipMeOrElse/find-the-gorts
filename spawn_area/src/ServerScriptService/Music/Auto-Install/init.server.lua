-- Cindering
-- Twitter: @Cindering_

--[[
	
	When the game is run, this script automatically places all of the model's contents into the correct locations and deletes any leftover clutter.
	
	All you have to do is configure the music IDs and/or zones as described in the README - the rest will be automatically handled! 
	
--]]

local settings = require(script.Parent.Settings)

if settings.UseGlobalBackgroundMusic == false and settings.UseMusicZones == false then
	error("Cindering's BGM error: You have disabled both Global Background Music and Music Zones. You must change at least one of these settings to 'true'.")
	return
end

local name1 = "[1] Global Background Music"
local name2 = "[2] Background Music Zones"

local container = Instance.new("Folder")
container.Name = "CinderingBGM"

script.Parent.Settings.Parent = container

script.LocalBackgroundMusic.Parent = game.StarterPlayer.StarterPlayerScripts

local music = Instance.new("Folder")
local zones = Instance.new("Folder",music)
zones.Name = "MusicZones"
local global = Instance.new("Folder",music)
global.Name = "GlobalMusic"

if settings.UseMusicZones == true then
	local folder = script.Parent:FindFirstChild(name2) or game.ReplicatedStorage:FindFirstChild(name2) or workspace:FindFirstChild(name2) or game:FindFirstChild(name2,true) -- never know where someone might accidentally drag that folder...
	
	if folder then
		for _,model in pairs(folder:GetChildren()) do
			if (model:IsA("Model") and model:FindFirstChild("Music")) then
				model.Parent = zones
			end
		end
	else
		error("Cindering's BGM error: Your background music zones folder could not be found! You may have deleted/renamed the original folder. It should be named: "..name2)
		return
	end
end

if settings.UseGlobalBackgroundMusic == true then
	local folder = script.Parent:FindFirstChild(name1) or game.ReplicatedStorage:FindFirstChild(name1) or workspace:FindFirstChild(name1) or game:FindFirstChild(name1,true)
	
	if folder then
		for _,v in pairs(folder:GetChildren()) do
			if v:IsA("Sound") then
				v.Parent = global
			end
		end
	else
		error("Cindering's BGM error: Your global background music folder could not be found! You may have deleted/renamed the original folder. It should be named: "..name1)
		return
	end
end

if settings.UseGlobalBackgroundMusic == true and #global:GetChildren() == 0 then
	warn("Cindering's BGM warning: Your global background music folder is completely empty; no music will be played from there.")
end
if settings.UseMusicZones == true and #zones:GetChildren() == 0 then
	warn("Cindering's BGM warning: Your background music zones folder is completely empty; no music will be played from there.")
end

music.Name = "MusicFolder"
music.Parent = container

local count = 0
function recurse(instance)
	for _,v in pairs(instance:GetChildren()) do
		count = count + 1
		recurse(v)
	end
end
recurse(music)
local val = Instance.new("IntValue",container)
val.Name = "ObjectCount"
val.Value = count

container.Parent = game.ReplicatedStorage

script.Parent:Destroy()