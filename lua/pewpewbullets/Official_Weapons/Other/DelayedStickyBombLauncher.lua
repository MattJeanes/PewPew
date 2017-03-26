-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Delayed Sticky-Bomb Launcher"
BULLET.Author = "Free Fall"
BULLET.Description = "Fires a bomb that will stick to whatever it hits and explodes short time after"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false
BULLET.UseOldSystem = true

-- Appearance
BULLET.Model = "models/Roller.mdl"

-- Effects / Sounds
BULLET.FireSound = {"arty/25mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 5000
BULLET.RecoilForce = 800
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 300
BULLET.Radius = 800
BULLET.RangeDamageMul = 1.6
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 3.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 3500

-- Overrides

BULLET.FireOverride = false

function BULLET:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	self.Propelled = false
	self.Sticked = false
	self.StickBlow = 0
	self.TraceDelay = CurTime() + self.Bullet.Speed / 1000 / 2
	
	constraint.NoCollide(self, self.Cannon.Entity, 0, 0)
	
	self:NextThink(CurTime())
end

function BULLET:Think()
	if (not self.Propelled) then
		local phys = self:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:ApplyForceCenter((self:GetUp() * phys:GetMass() * self.Bullet.Speed)*((pewpew.ServerTick or (1/66))/(1/66)))
		end
		
		self.Propelled = true
	end
	
	if (self.StickEntity and not self.Sticked) then
		constraint.Weld(self, self.StickEntity, 0, 0, 0, true)
		
		self.Sticked = true
		self.StickBlow = CurTime() + (math.random(20, 50) / 10)
	end
	
	if (self.Sticked and CurTime() >= self.StickBlow) then
		if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew:GetConVar( "Damage" )) then
			pewpew:PlayerBlastDamage(self, self, self:GetPos(), self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage)
		end
		
		if (self.Bullet.ExplosionEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetStart(self:GetPos())
			effectdata:SetNormal(self:GetUp())
			util.Effect(self.Bullet.ExplosionEffect, effectdata)
		end
		
		if (self.Bullet.ExplosionSound) then
			local soundpath = ""
			if (table.Count(self.Bullet.ExplosionSound) > 1) then
				soundpath = table.Random(self.Bullet.ExplosionSound)
			else
				soundpath = self.Bullet.ExplosionSound[1]
			end
			sound.Play(soundpath, self:GetPos(), 100, 100)
		end
		
		pewpew:BlastDamage(self:GetPos(), self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self, self )
		
		self:Remove()
	end
	
	self:NextThink(CurTime() + 0.25)
	return true
end

function BULLET:PhysicsCollide(CollisionData, PhysObj)
	if (not (self.Cannon:IsValid() and PhysObj == self.Cannon:GetPhysicsObject()) and self.Propelled and not self.Sticked) then
		local Entity = CollisionData.HitEntity
		if not Entity:IsPlayer() then
			self.StickEntity = Entity
		end
		self:NextThink(CurTime())
	end
end

pewpew:AddWeapon( BULLET )