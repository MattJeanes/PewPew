-- Basic Laser

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Beam laser"
BULLET.Author = "Divran"
BULLET.Description = "Fires a constant laser beam."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false


-- Effects / Sounds
BULLET.ExplosionEffect = "pewpew_laserbeam"


-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 4

-- Reloading/Ammo
BULLET.Reloadtime = 0.01
BULLET.Ammo = 10
BULLET.AmmoReloadtime = 5

BULLET.EnergyPerShot = 10

BULLET.Gravity = 0

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	-- Deal damage
	local trace = pewpew:Trace( startpos, Dir * 100000 )

	if (trace and trace.Hit and trace.Entity and trace.Entity:IsValid()) then
		-- Stargate shield damage
		if (trace.Entity:GetClass() == "shield") then
			trace.Entity:Hit(nil,trace.HitPos,self.Bullet.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
		else
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
		end
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos or ( startpos + self.Entity:GetUp() * 100000 )  )
	effectdata:SetStart( startpos )
	effectdata:SetEntity( self.Entity )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

pewpew:AddWeapon( BULLET )
