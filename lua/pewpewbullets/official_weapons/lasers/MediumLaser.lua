-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Medium Laser"
BULLET.Author = "Colonel Thirty Two"
BULLET.Description = "Laser weapon with medium rate of fire. Does not slice through entities."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"Lasers/Medium/Laser.wav"}
BULLET.ExplosionEffect = "MedLaser"

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 155
BULLET.PlayerDamage = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.Lifetime = {0,0} 
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 600

BULLET.Gravity = 0


-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local direction, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	-- Deal damage
	local trace = pewpew:Trace( startpos, direction * 100000 )
	local HitPos = trace.HitPos or StartPos + direction * 100000
	if (trace.Entity and trace.Entity:IsValid()) then
		-- Stargate shield damage
		if (trace.Entity:GetClass() == "shield") then
			trace.Entity:Hit(nil,trace.HitPos,self.Bullet.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
		else
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
		end
	end

	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + direction * self.Bullet.SliceDistance)  )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddWeapon( BULLET )