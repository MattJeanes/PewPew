-- Automatic Defense

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "A.P.S."
BULLET.Author = "Divran"
BULLET.Description = "The Active Protection System, or A.P.S. will automatically target and destroy projectiles in a 75 degree cone infront of it."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"col32/gun4.wav"}
BULLET.FireEffect = "pewpew_defensebeam"

-- Damage
BULLET.DamageType = "DefenseDamage"
BULLET.Damage = 50
BULLET.Radius = 1000
BULLET.Degrees = 75

-- Reloading/Ammo
BULLET.Reloadtime = 0.15
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 2000

BULLET.Gravity = 0

BULLET.CustomInputs = { "Fire" }
BULLET.CustomOutputs = { }

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

local function isInCone( vPos, Pos, Dir, cosDegrees )
	return Dir:Dot( (vPos - Pos):GetNormalized() ) > cosDegrees
end

-- FindInCone (Note: copied from E2 then edited)
local function getClosestInCone( Entities, Pos, Dir, Degrees )
	if #Entities == 0 then return end
	local cosDegrees = math.cos(math.rad(Degrees))
	
	local closest
	local closestDist = 0
	local closestPos
	if Entities[1].GetPos then -- It's an array of entities
		for i=1,#Entities do
			local ent = Entities[i]
			local vPos = ent:GetPos()
			if isInCone( vPos, Pos, Dir, cosDegrees ) then
				local dist = vPos:Distance( Pos )
				if closest == nil or closestDist > dist then
					closest = ent
					closestDist = dist
					closestPos = vPos
				end
			end
		end
	else -- It's an array of pewpew bullets
		for i=1,#Entities do
			local ent = Entities[i]
			local vPos = ent.Pos
			if isInCone( vPos, Pos, Dir, cosDegrees ) then
				local dist = vPos:Distance( Pos )
				if closest == nil or closestDist > dist then
					closest = ent
					closestDist = dist
					closestPos = vPos
				end
			end
		end
	end
	
	return closest, closestDist, closestPos
end

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	
	local temp1 = {}
	local temp2 = ents.FindInSphere( startpos, self.Bullet.Radius )
	for i=1,#temp2 do
		if temp2[i]:GetClass() == "pewpew_base_bullet" then temp1[#temp1+1] = temp2[i] end
	end

	local found1, distance1, pos1 = getClosestInCone( pewpew.Bullets, startpos, dir, self.Bullet.Degrees )
	local found2, distance2, pos2 = getClosestInCone( temp1, startpos, dir, self.Bullet.Degrees )
	
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
