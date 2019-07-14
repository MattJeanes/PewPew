-- Bomb Rack

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Bomb Rack"
BULLET.Author = "Divran"
BULLET.Description = "Drops several bombs straight down onto your enemy."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_phx/mk-82.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"npc/attack_helicopter/aheli_mine_drop1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "athesplode"

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 300
BULLET.Radius = 250
BULLET.RangeDamageMul = 2.2
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 25
BULLET.PlayerDamageRadius = 200

-- Reloading/Ammo
BULLET.Reloadtime = 0.8
BULLET.Ammo = 5
BULLET.AmmoReloadtime = 8

BULLET.EnergyPerShot = 2000

BULLET.UseOldSystem = true

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)


-- Initialize (Is called when the entity initializes)
function BULLET:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	self.Entity:SetPos( self.Entity:GetPos() + self.Entity:GetUp() * 40 )
	self.Entity:NextThink(CurTime())
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetVelocity(self.Cannon:GetVelocity()+self.Cannon:GetUp()*50)
	end
	
	self.Timer = CurTime() + 50
	self.Collided = false
end

-- Think (Is called a lot of times :p)
function BULLET:Think()
	local vel = self:GetVelocity() -- For some reason setting the angle every tick makes it move REALLY slowly, so I used this hacky method of angling it
	self:SetAngles( vel:GetNormal():Angle() )
	self.Entity:GetPhysicsObject():SetVelocity( vel )
	if (self.Collided == true or CurTime() > self.Timer) then
		if (pewpew:GetConVar( "Damage" )) then
			pewpew:PlayerBlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), self.Bullet.Damage, self.Bullet.Radius)
		end
		pewpew:BlastDamage(self:GetPos(), self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, nil, self )
		
		if (self.Bullet.ExplosionEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin(self:GetPos())
			effectdata:SetStart(self:GetPos())
			effectdata:SetNormal(self.Entity:GetUp())
			util.Effect(self.Bullet.ExplosionEffect, effectdata)
		end
		
		-- Sounds
		if (self.Bullet.ExplosionSound) then
			local soundpath = ""
			if (table.Count(self.Bullet.ExplosionSound) > 1) then
				soundpath = table.Random(self.Bullet.ExplosionSound)
			else
				soundpath = self.Bullet.ExplosionSound[1]
			end
			sound.Play( soundpath, self.Entity:GetPos(),100,100)
		end
		
		self:Remove()
	end
end
-- This is called when the bullet collides (Advanced users only. It only works if you first override initialize and change it to vphysics)
function BULLET:PhysicsCollide(CollisionData, PhysObj)
	if (self.Collided == false) then
		self.Collided = true
	end
end

pewpew:AddWeapon( BULLET )
