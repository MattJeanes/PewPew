-- EMP

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "EMP Bomb"
BULLET.Author = "Divran"
BULLET.Description = "EMP Bomb. No damage, but disables wiring for 15 seconds."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.ExplosionEffect = "HEATsplode"

-- Damage
BULLET.DamageType = "EMPDamage"
BULLET.Radius = 500
BULLET.Duration = 15

-- Reloading/Ammo
BULLET.Reloadtime = 1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = nil

BULLET.EnergyPerShot = 15500

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Pos = self.Entity:GetPos()
		
	-- Effect
	local effectdata = EffectData()
	effectdata:SetOrigin( Pos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
	
	-- Damage
	pewpew:EMPDamage( Pos, self.Bullet.Radius, self.Bullet.Duration, self )
	
	-- Still here?
	if (self.Entity:IsValid()) then
		self.Entity:Remove()
	end
end

pewpew:AddWeapon( BULLET )