-- C4

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "C4 (Do Not Spawn)"
BULLET.Author = "Divran"
BULLET.Description = "C4. High damage, low radius."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = true

-- Effects / Sounds
BULLET.FireSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "pewpew_c4_explosion"

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 2000
BULLET.Radius = 350
BULLET.RangeDamageMul = 2.6
BULLET.PlayerDamage = 500
BULLET.PlayerDamageRadius = 350

-- Reloading/Ammo
BULLET.Reloadtime = 1
BULLET.Ammo = 0

BULLET.EnergyPerShot = 20000

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Pos = self.Entity:GetPos()
	local Norm = self.Entity:GetUp()
	
	-- Sound
	soundpath = table.Random(self.Bullet.FireSound)
	self:EmitSound( soundpath )
		
	-- Effect
	local effectdata = EffectData()
	effectdata:SetOrigin( Pos )
	effectdata:SetNormal( Norm )
	util.Effect( self.Bullet.FireEffect, effectdata )
	
	-- Damage
	if (pewpew:GetConVar( "Damage" )) then
		pewpew:PlayerBlastDamage( self.Entity, self.Entity, Pos + Norm * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
	end
	pewpew:BlastDamage( Pos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self.Entity, self )
	
	-- Still here?
	if (self.Entity:IsValid()) then
		self.Entity:Remove()
	end
end

pewpew:AddWeapon( BULLET )
