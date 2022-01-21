-- Cindering
-- Twitter: @Cindering_

-- This script gets placed into StarterPlayerScripts where it will locally play the background music for each player.

local plr = game.Players.LocalPlayer
local char
local torso

local container = game.ReplicatedStorage:WaitForChild("CinderingBGM")
local settings = require(container:WaitForChild("Settings"))
local musicfolder = container:WaitForChild("MusicFolder")
local globalfolder = musicfolder:WaitForChild("GlobalMusic")
local zonesfolder = musicfolder:WaitForChild("MusicZones")
local servercount = container:WaitForChild("ObjectCount").Value

function GetMatchingCount() --objects can take some time to actually replicate to the client. make sure that the client sees the correct # of objects in the music folder before initializing the rest of the script
	local count = 0
	local function recurse(instance)
		for _,v in pairs(instance:GetChildren()) do
			count = count + 1
			recurse(v)
		end
	end
	recurse(musicfolder)
	if count == servercount then return true end
end

while not GetMatchingCount() do
	wait(.5)
end


function IsCleanRotation(v3values) --check to see whether the rotation is at clean 90 degree increments so we can use the more simplistic calculations for it
	for _,v in pairs(v3values) do
		if not (v%90 <= 0.01 or v%90 >= 89.99) then --why not just check for (v%90 == 0)? because rotations can suffer from floating point inaccuracies
			return false
		end
	end
	return true
end


--now, load the zone & music data into the script

local zones = {}
local music = {}
local globali

if settings.UseMusicZones == true then
	for i,zone in pairs(zonesfolder:GetChildren()) do
		if zone:IsA("Model") and zone:FindFirstChild("Music") then
			music[i] = {}
			for _,sound in pairs(zone.Music:GetChildren()) do --save all of the music data for this zone
				if sound:IsA("Sound") then
					table.insert(music[i], {["SoundId"] = sound.SoundId, ["Volume"] = sound.Volume, ["Pitch"] = sound.Pitch})
				end
			end
			
			zones[i] = {
				["Priority"] = zone:FindFirstChild("Priority") and zone.Priority.Value or 1,
				["Parts"] = {},
				["Music"] = music[i]
			}
	
			for _,part in pairs(zone:GetChildren()) do
				if part:IsA("Part") then
					
					if IsCleanRotation({part.Rotation.X,part.Rotation.Y,part.Rotation.Z}) == true then --store the min and max X/Y/Z position coordinates of this part
						local lx,ly,lz = math.huge,math.huge,math.huge
						local mx,my,mz = -math.huge,-math.huge,-math.huge
						local function ApplyValues(p)
							if p.x < lx then lx = p.x end
							if p.x > mx then mx = p.x end
							if p.y < ly then ly = p.y end
							if p.y > my then my = p.y end
							if p.z < lz then lz = p.z end
							if p.z > mz then mz = p.z end
						end
						local points = {}
						--a bunch of sloppy math stuff to calculate the coordinates on each of the part's faces so we can figure out the min and max values. mathematicians, pls don't kill me if i'm doing this terribly
						local cf1 = part.CFrame
						local cf2 = (part.CFrame * CFrame.Angles(0,math.pi/2,0))
						local cf3 = (part.CFrame * CFrame.Angles(math.pi/2,0,0))
						local lvz = (cf1.lookVector * (part.Size.Z/2))
						local lvx = (cf2.lookVector * (part.Size.X/2))
						local lvy = (cf3.lookVector * (part.Size.Y/2))
						points[1] = cf1+lvz
						points[2] = cf1-lvz
						points[3] = cf2+lvx
						points[4] = cf2-lvx
						points[5] = cf3+lvy
						points[6] = cf3-lvy
						for _,p in pairs(points) do
							ApplyValues(p)
						end 
						table.insert(zones[i]["Parts"],{["Coordinates"] = {lx=lx,ly=ly,lz=lz, mx=mx,my=my,mz=mz}})
					else --save a reference to the part itself to be used for GetTouchingParts(), since it has a complex rotation that can't be solved with my own feeble calculations
						table.insert(zones[i]["Parts"],{["Part"] = part})
					end
					
				end
			end
		end
	end
end
	
if settings.UseGlobalBackgroundMusic == true then
	globali = #music + 1
	music[globali] = {}
	for _,sound in pairs(globalfolder:GetChildren()) do
		if sound:IsA("Sound") then
			table.insert(music[globali], {["SoundId"] = sound.SoundId, ["Volume"] = sound.Volume, ["Pitch"] = sound.Pitch})
		end
	end
end
--end this enormous, disgusting block of code


--mute button stuff
local canmute = settings.DisplayMuteButton
local clonegui
if canmute then
	clonegui = script.MuteButtonGui:clone()
end
script.MuteButtonGui:Destroy()

local musicon = true

function SetButtonStyle(button)
	button.Text = "Music: ".. (musicon and "ON" or "OFF")
	button.Style = musicon and Enum.ButtonStyle.RobloxRoundDefaultButton or Enum.ButtonStyle.RobloxRoundDropdownButton
	button.TextColor3 = musicon and Color3.new(1,1,1) or Color3.new(.2,.2,.23)
end

function CreateButton()
	local gui = clonegui:clone()
	local button = gui.Button
	button.Visible = true
	SetButtonStyle(button)
	button.MouseButton1Click:connect(function()
		musicon = not musicon
		local bgm = script:FindFirstChild("BGM")
		if bgm then
			bgm.Volume = musicon and bgm.OriginalVolume.Value or 0
		end
		SetButtonStyle(button)
	end)
	gui.Parent = plr:WaitForChild("PlayerGui")
end

function CharInit()
	char = plr.Character
	torso = char:WaitForChild("HumanoidRootPart")
	--if canmute then CreateButton() end
end

if plr.Character and plr.Character.Parent ~= nil then
	CharInit()
end
plr.CharacterAdded:connect(function()
	CharInit()
end)

--now, get to playing the music

local FadeoutTime = settings.MusicFadeoutTime

function PlaySound(sounddata)
	if sounddata == nil then return end
	local sound = Instance.new("Sound")
	sound.Looped = true
	sound.SoundId = sounddata.SoundId
	sound.Volume = musicon and sounddata.Volume or 0
	local v = Instance.new("NumberValue",sound)
	v.Name = "OriginalVolume"
	v.Value = sounddata.Volume
	sound.Pitch = sounddata.Pitch
	sound.Name = "BGM"
	sound.Parent = script
	sound:Play()
end

function FadeOutSound(sound)
	local basevol = sound.Volume
	local count = math.ceil(30*FadeoutTime)
	if count < 1 then
		count = 1
	end
	for i=1,count do
		if sound then
			sound.Volume = sound.Volume - (basevol / count)
			wait(1/30)
		end
	end
	if sound then
		sound:Stop()
		sound:Destroy()
	end
end


if settings.UseGlobalBackgroundMusic == true and settings.UseMusicZones == false then
	if #music[globali] == 1 then --global BGM with just 1 song? ez pz
		PlaySound(music[1][1])
		return
	elseif #music[globali] == 0 then --there's no music to play...?
		return
	end
end



local recentindices = {} --keeps track of recently selected indicies, so as not to play repeat music tracks
math.randomseed(tick())
local currentzone
local zoneplayingmusic

function CheckIfRecent(i)
	for _,v in pairs(recentindices) do
		if v == i then
			return true
		end
	end
	return false
end

function SelectRandomMusic(musiclist) --select a random number, excluding ones that were already used recently
	if musiclist == nil or #musiclist == 0 then return end
	local possiblenumbers = {}
	local selectedindex
	for i=1,#musiclist do
		if not CheckIfRecent(i) then
			table.insert(possiblenumbers,i)
		end
	end
	local selectedindex = possiblenumbers[math.random(1,#possiblenumbers)]
	table.insert(recentindices,selectedindex)
	if #recentindices > math.ceil(#musiclist / 2) then
		table.remove(recentindices,1)
	end
	return musiclist[selectedindex]
end

function IsInZone(zonedata)
	if torso and torso.Parent ~= nil then
		local p = torso.Position
		for _,data in pairs(zonedata["Parts"]) do
			if data["Coordinates"] then
				local t = data["Coordinates"]
				if (p.x > t.lx and p.x < t.mx and p.y > t.ly and p.y < t.my and p.z > t.lz and p.z < t.mz) then --is the character within all the coordinates of the zone?
					return true
				end
			elseif data["Part"] then --complex part? create a clone of the part and check if it's touching the character's torso
				local part = data["Part"]:clone()
				part.Anchored = true
				part.Parent = workspace.CurrentCamera or workspace
				part.CanCollide = true
				local touching = part:GetTouchingParts()
				part:Destroy()
				for _,v in pairs(touching) do
					if v == torso then
						return true
					end
				end
			end
		end
		return false
	end
end

function CalculateCurrentZone()
	local priority = -math.huge
	local oldzone = currentzone
	local selectedzone
	if currentzone then
		if IsInZone(currentzone) then
			selectedzone = currentzone
			priority = currentzone["Priority"]
		end
	end
	for _,zone in pairs(zones) do
		if zone["Priority"] > priority and IsInZone(zone) then
			priority = zone["Priority"]
			selectedzone = zone
		end
	end
	currentzone = selectedzone
	if currentzone ~= oldzone and (currentzone ~= nil or settings.UseGlobalBackgroundMusic == true) then
		recentindices = {}
	end
	return currentzone,oldzone
end


function RunCycle() --the main cycle which will continuously run, checking which zones (if any) the character is in and playing new music when necessary
	local bgm = script:FindFirstChild("BGM")
	if settings.UseMusicZones == true then
		local zone,oldzone = CalculateCurrentZone()
		if zone ~= oldzone and zone ~= zoneplayingmusic and bgm then
			if (zone == nil and (settings.UseGlobalBackgroundMusic == true or settings.MusicOnlyPlaysWithinZones == true)) or zone ~= nil then
				FadeOutSound(bgm)
				return
			end
		elseif zone and bgm == nil then
			PlaySound(SelectRandomMusic(zone["Music"]))
			zoneplayingmusic = zone
			return
		elseif zone == nil and oldzone and settings.MusicOnlyPlaysWithinZones == false and settings.UseGlobalBackgroundMusic == false and bgm == nil then
			PlaySound(SelectRandomMusic(oldzone["Music"]))
			zoneplayingmusic = oldzone
			return
		elseif zoneplayingmusic and settings.MusicOnlyPlaysWithinZones == false and settings.UseGlobalBackgroundMusic == false and bgm == nil then
			PlaySound(SelectRandomMusic(zoneplayingmusic["Music"]))
			return
		elseif settings.UseGlobalBackgroundMusic == true and bgm == nil then
			PlaySound(SelectRandomMusic(music[globali]))
			zoneplayingmusic = nil
			return
		end
	elseif bgm == nil and settings.UseGlobalBackgroundMusic == true then
		PlaySound(SelectRandomMusic(music[globali]))
		return
	end
	
	if bgm and (settings.UseGlobalBackgroundMusic == true and zoneplayingmusic == nil and #music[globali] > 1) or (zoneplayingmusic and #zoneplayingmusic["Music"] > 1) then
		local length = bgm.TimeLength
		local pos = bgm.TimePosition
		if length ~= 0 and length - pos < FadeoutTime + .5 then
			FadeOutSound(bgm)
		end
	end
end

while wait(.5) do
	RunCycle()
end


-- Cindering
-- Twitter: @Cindering_