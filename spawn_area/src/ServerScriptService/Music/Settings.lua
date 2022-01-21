-- Looking for how exactly to set up your background music? Open the Readme/Instructions script!


local settings = {}

settings.UseGlobalBackgroundMusic = true  -- If you want to play Global Background Music for everyone in your game, set this to true.

settings.UseMusicZones = true  -- If you are using the Background Music Zones to play specific music in certain areas, set this to true.

-- You may turn both of these on at once. In that case, zone-specific music will play in the appropriate zones, and global background music will play whenever you're not within any zone.

	
settings.DisplayMuteButton = true  -- If set to true, there will be a button in the bottom-right corner of the screen allowing players to mute the background music.
	
settings.MusicFadeoutTime = 1  -- How long music takes to fade out, in seconds.

settings.MusicOnlyPlaysWithinZones = false  -- (This setting only applies when UseGlobalBackgroundMusic is set to false) If a player walks into an area that's not covered by any music zone, what should happen? If true, music will stop playing. If false, the music from the previous zone will continue to play.

return settings
