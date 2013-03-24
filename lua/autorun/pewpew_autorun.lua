// Merged autoruns into one file, mainly because there are some things that need to be done shared that another Lua file with a small bit of code is messy - and not much is gained by splitting them.

if SERVER then
	-- PewPew Server Autorun
	-- Initialize variables
	pewpew = {}

	-- Include files
	include("pewpew_weaponhandler.lua")
	include("pewpew_damagecontrol.lua")
	include("pewpew_bulletcontrol.lua")

	-- Add Plugin files
	local function AddFiles( folder, files, N )
		for k,v in ipairs( files ) do
			if (N == 1) then
				AddCSLuaFile(folder..v)
			elseif (N == 2) then
				AddCSLuaFile(folder..v)
				include(folder..v)
			elseif (N == 3) then
				include(folder..v)
			end
		end
	end
	AddFiles( "PewPewPlugins/Server/", file.Find("PewPewPlugins/Server/*.lua", "LUA"), 3 )
	AddFiles( "PewPewPlugins/Shared/", file.Find("PewPewPlugins/Shared/*.lua", "LUA"), 2 )
	AddFiles( "PewPewPlugins/Client/", file.Find("PewPewPlugins/Client/*.lua", "LUA"), 1 )

	-- Add files
	AddCSLuaFile("pewpew_weaponhandler.lua")
	AddCSLuaFile("pewpew_bulletcontrol.lua")
	AddCSLuaFile()

	-- Run functions
	pewpew:LoadWeapons()

	-- If we got this far without errors, it's safe to assume the addon is installed.
	pewpew.Installed = true
elseif CLIENT then
	-- PewPew Client Autorun
	-- Initialize variables
	pewpew = {}

	-- Include files
	include("pewpew_weaponhandler.lua")
	include("pewpew_bulletcontrol.lua")

	-- Include Plugin files
	local function AddFiles( folder, files )
		for k,v in ipairs( files ) do
			include(folder .. v)
		end
	end
	AddFiles( "PewPewPlugins/Client/", file.Find("PewPewPlugins/Client/*.lua", "LUA") )
	AddFiles( "PewPewPlugins/Shared/", file.Find("PewPewPlugins/Shared/*.lua", "LUA") )


	-- Run functions
	pewpew:LoadWeapons()

	-- If we got this far without errors, it's safe to assume the addon is installed.
	pewpew.Installed = true
end

// Soundscripts are now done by lua, so we adjust accordingly.
// Shared code

sound.Add(
{
	name = "PewPew_Fire_Rocket",
	channel = CHAN_WEAPON,
	soundlevel = 20,
	sound = "^arty/rocket.wav"
})