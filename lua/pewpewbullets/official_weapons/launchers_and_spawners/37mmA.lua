-- Grenade Launcher

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "37mm Auto Grenade Launcher"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Rapidly fires timed grenades."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/Items/AR2_Grenade.mdl"
BULLET.Material = "phoenix_storms/gear"
BULLET.Color = nil
BULLET.Trail = { StartSize = 4,
				 EndSize = 0,
				 Length = 0.6,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 200, 200, 200, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"weapons/mortar/mortar_fire1.wav"}
BULLET.ExplosionSound = nil -- the sound is included in the effect
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "explosion"
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 60
BULLET.RecoilForce = 100
BULLET.Spread = 2

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 150
BULLET.Radius = 150
BULLET.RangeDamageMul = 2.6
BULLET.PlayerDamage = 75
BULLET.PlayerDamageRadius = 100

-- Reloading/Ammo
BULLET.Reloadtime = 0.25
BULLET.Ammo = 20
BULLET.AmmoReloadtime = 10

-- Other
BULLET.Lifetime = {3,3}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 4000

BULLET.UseOldSystem = true

-- Overrides

function BULLET:Initialize()
	self:DefaultInitialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
		
	self.Entity:SetAngles( self.Entity:GetUp():Angle() )
	local phys = self.Entity:GetPhysicsObject()
	phys:SetMass(5)
	phys:ApplyForceCenter( self.Entity:GetForward() * phys:GetMass() * self.Bullet.Speed * 35 )
end

function BULLET:Think()
	-- Lifetime
	if (self.Lifetime) then
		if (CurTime() > self.Lifetime) then
			if (self.Bullet.ExplodeAfterDeath) then
				local tr = {}
				tr.start = self.Entity:GetPos()
				tr.endpos = self.Entity:GetPos()-Vector(0,0,10)
				tr.filter = self.Entity
				local trace = util.TraceLine( tr )
				self:Explode( trace )
			else
				self.Entity:Remove()
			end
		end
	end
	
	self.Entity:NextThink(CurTime() + 1)
	return true
end

pewpew:AddWeapon( BULLET )
