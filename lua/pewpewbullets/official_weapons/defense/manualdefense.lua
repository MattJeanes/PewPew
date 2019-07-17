-- Manual Defense

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "M.P.S."
BULLET.Author = "Divran"
BULLET.Description = "The Manual Protection Sytem or M.P.S. will target incoming projectiles and shoot them down within a 75 degree cone in front of it."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"col32/gun4.wav"}
BULLET.FireEffect = "pewpew_defensebeam"

-- Damage
BULLET.DamageType = "DefenseDamage"
BULLET.Damage = 100
BULLET.Radius = 2000

-- Reloading/Ammo
BULLET.Reloadtime = 0.25
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 5000

BULLET.Gravity = 0

BULLET.CustomInputs = { "Fire", "Target [VECTOR]" }

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Wire Input (This is called whenever a wire input is changed)
function BULLET:WireInput( inputname, value )
	if (inputname == "Target") then
		self.Target = value
	else
		self:InputChange( inputname, value )
	end
end


local function findNearestNewSystem( Pos, Radius )
	local closest
	local closestDistance = Radius+0.01
	local closestPos
	for i=1,#pewpew.Bullets do
		local pos = pewpew.Bullets[i].Pos
		local dist = pos:Distance( Pos )
		if dist < closestDistance then
			closest = pewpew.Bullets[i]
			closestDistance = dist
			closestPos = pos
		end
	end
	
	return closest, closestDistance, closestPos
end

local function findNearestOldSystem( Pos, Radius )
	local temp1 = {}
	local temp2 = ents.FindInSphere( Pos, Radius )
	
	local closest
	local closestDistance = Radius+0.01
	local closestPos
	for i=1,#temp2 do
		if temp2[i]:GetClass() == "pewpew_base_bullet" then
			local pos = temp2[i]:GetPos()
			local dist = pos:Distance( Pos )
			if dist < closestDistance then
				closest = temp2[i]
				closestDistance = dist
				closestPos = pos
			end
		end
	end
	
	return closest, closestDistance, closestPos
end

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	if startpos:Distance( self.Target ) > self.Bullet.Radius then return end
	
	local found1, distance1, pos1 = findNearestNewSystem( self.Target, 120 )
	local found2, distance2, pos2 = findNearestOldSystem( self.Target, 120 )

	local finalFound, finalPos
	if found1 and found2 then
		finalFound = (distance1 < distance2) and found1 or found2
		finalPos = (distance1 < distance2) and pos1 or pos2
	else
		finalFound = found1 or found2
		finalPos = (finalFound == found1) and pos1 or pos2
	end

	if finalFound ~= nil then
		local tr = {start = startpos, endpos = pos, filter = self}
		local trace = util.TraceLine( tr )
		if IsValid( trace.Entity ) and pewpew:CheckValid( trace.Entity )  then -- Hit something else, deal damage to that instead
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage / 3, self.Entity )
			
			-- Sound
			self:EmitSound( self.Bullet.FireSound[1] )
			
			-- Effect
			local effectdata = EffectData()
			effectdata:SetOrigin( finalPos )
			effectdata:SetStart( startpos )
			util.Effect( self.Bullet.FireEffect, effectdata )
		else
			pewpew:DefenseDamage( finalFound, self.Bullet.Damage )
		
			-- Sound
			self:EmitSound( self.Bullet.FireSound[1] )
				
			-- Effect
			local effectdata = EffectData()
			effectdata:SetOrigin( finalPos )
			effectdata:SetStart( startpos )
			util.Effect( self.Bullet.FireEffect, effectdata )
		end
	end
end

pewpew:AddWeapon( BULLET )
