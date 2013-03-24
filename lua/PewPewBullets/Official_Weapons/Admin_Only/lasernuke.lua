-- Basic Laser

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Laser Nuke"
BULLET.Author = "Divran"
BULLET.Description = "BLAAAAAARGH"
BULLET.AdminOnly = true
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"npc/strider/fire.wav"}
BULLET.ExplosionSound = { "ambient/explosions/citadel_end_explosion1.wav", "ambient/explosions/citadel_end_explosion2.wav" }
BULLET.FireEffect = "Deathbeam2"
BULLET.ExplosionEffect = "breachsplode"

-- Damage
BULLET.DamageType = "BlastDamage" -- custom
BULLET.Damage = 100000
BULLET.Radius = 7000
BULLET.RangeDamageMul = 2.2
BULLET.PlayerDamage = 5000
BULLET.PlayerDamageRadius = 5000

-- Reloading/Ammo
BULLET.Reloadtime = 11
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 11000000

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	local trace = pewpew:Trace( startpos, Dir * 100000 )
	local HitPos = trace.HitPos or StartPos + Dir * 100000
	
	-- Effects
	self:EmitSound( self.Bullet.FireSound[1] )
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos or (startpos + Dir * 50000 ) )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
	
	local effectdata = EffectData()
	effectdata:SetOrigin( HitPos )
	effectdata:SetStart( startpos )
	util.Effect( self.Bullet.FireEffect, effectdata )
	
	-- Sounds
	if (self.Bullet.ExplosionSound) then
		local soundpath = ""
		if (table.Count(self.Bullet.ExplosionSound) > 1) then
			soundpath = table.Random(self.Bullet.ExplosionSound)
		else
			soundpath = self.Bullet.ExplosionSound[1]
		end
		sound.Play( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
	end
	
	if (pewpew:GetConVar( "Damage" )) then
		if (trace.Entity and trace.Entity:IsValid()) then
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
			pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, trace.Entity, self )
		else
			pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self.Entity, self )
		end
		pewpew:PlayerBlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
	end
end

pewpew:AddWeapon( BULLET )