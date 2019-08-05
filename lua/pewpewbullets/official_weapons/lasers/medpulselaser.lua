-- Basic Laser

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Medium Pulse Laser"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Fires a laser up to 3 times rapidly, dealing moderate damage."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"Lasers/Small/Laser.wav"}
BULLET.ExplosionEffect = "ISSmallPulseBeam"

-- Damage
BULLET.DamageType = "SliceDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 25
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 50000
BULLET.ReducedDamagePerSlice = 0

-- Reloading/Ammo
BULLET.Reloadtime = 0.3
BULLET.Ammo = 3
BULLET.AmmoReloadtime = 0.5

BULLET.EnergyPerShot = 1000

BULLET.Gravity = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()		
	local Dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	-- Deal damage
	local HitPos = pewpew:SliceDamage( startpos, Dir, self.Bullet.Damage, self.Bullet.NumberOfSlices, self.Bullet.SliceDistance, self.Bullet.ReducedDamagePerSlice, self )
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + Dir * self.Bullet.SliceDistance)  )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddWeapon( BULLET )
