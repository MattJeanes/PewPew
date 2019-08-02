-- PewPew Weapon Handler
-- Takes care of adding and managing all the available bullets

-- Load all the bullet files
function pewpew:LoadWeapons()
	self.Weapons = {}
	self.Categories = {}
	
	self:LoadDirectory( "pewpewbullets" )
end
concommand.Add("PewPew_LoadBullets",function(ply,cmd,args) 
	if (ply:IsSuperAdmin() or !ply:IsValid()) then
		pewpew:LoadWeapons()
	end
end)

-- Reloads all weapons on the map (useful if you've just updated several weapons and done pewpew:LoadWeapons())
function pewpew:ReloadWeapons()
	local weps = ents.FindByClass("pewpew_base_cannon")
	for k,v in ipairs( weps ) do
		if (v:IsValid()) then
			local name = v.Bullet.Name
			v.Bullet = table.Copy( self:GetWeapon( name ) )
			print( "[PewPew] Reloaded weapon: " .. tostring(v) .. " with bullet: " .. name )
		end
	end
end
concommand.Add("PewPew_ReloadWeapons",function(ply,cmd,args)
	if (ply:IsSuperAdmin() or !ply:IsValid()) then
		pewpew:ReloadWeapons()
	end
end)

local CurrentCategory = ""
local CurrentCategoryTable = {}

function pewpew:LoadDirectory( Dir ) -- Thanks to Jcw87 for fixing this function
	-- Get the category
	if (string.find(Dir, "/")) then
		CurrentCategory = string.Right( Dir, string.find( string.reverse( Dir ), "/", 1, true ) - 1 )
		CurrentCategory = string.gsub( CurrentCategory, "_", " " )
		local Temp = string.Explode( "/", Dir )
		
		local Temp2 = self.Categories
		for k,v in ipairs( Temp ) do
			if (k != 1) then
				if (!Temp2[v]) then
					Temp2[v] = {}
				end
				Temp2 = Temp2[v]
			end
		end
		CurrentCategoryTable = Temp2
	else
		CurrentCategory = "pewpewbullets"
		CurrentCategoryTable = self.Categories
	end
	
	local entries,directories = file.Find( Dir .. "/*", "LUA")
	for _, entry in ipairs ( entries ) do
		if string.EndsWith(entry, ".lua") then
			if (SERVER) then 
				AddCSLuaFile( Dir .. "/" .. entry )
			end
			include( Dir .. "/" .. entry )
		end
	end
	for _, directory in ipairs( directories ) do
		self:LoadDirectory( Dir .. "/" .. directory )
	end
end


-- Add the weapons to the weapon list
function pewpew:AddWeapon( weapon )
	if (SERVER) then print("[PewPew] Added Bullet: " .. weapon.Name) end
	table.insert( self.Weapons, weapon )
	weapon.Category = CurrentCategory
	table.insert( CurrentCategoryTable, weapon.Name )
	if (SERVER) then umsg.PoolString(weapon.Name) end
end

-- Allows you to find a bullet
function pewpew:GetWeapon( WeaponName )
	for _, wpn in pairs( self.Weapons ) do
		if (string.lower(wpn.Name) == string.lower(WeaponName)) then
			return wpn
		end
	end
end