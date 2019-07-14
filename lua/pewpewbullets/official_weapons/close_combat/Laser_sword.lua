-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Laser Sword"
BULLET.Author = "Divran"
BULLET.Description = "May the force be with you."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireEffect = "pewpew_swordeffect"

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 50
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 200
BULLET.ReducedDamagePerSlice = 0

-- Reloading/Ammo
BULLET.Reloadtime = 0.05
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 75

BULLET.Gravity = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	-- Deal damage
	local HitPos = pewpew:SliceDamage( startpos, Dir, self.Bullet.Damage, self.Bullet.NumberOfSlices, self.Bullet.SliceDistance, self.Bullet.ReducedDamagePerSlice, self )
	
	local effectdata = EffectData()
	effectdata:SetStart( startpos )
	effectdata:SetOrigin( HitPos or (startpos + Dir * self.Bullet.SliceDistance) )
	effectdata:SetEntity( self.Entity )
	util.Effect( self.Bullet.FireEffect, effectdata )
end

pewpew:AddWeapon( BULLET )
