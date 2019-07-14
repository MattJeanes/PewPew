-- Helicopter Bomb

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Helicopter Bomb"
BULLET.Author = "Divran"
BULLET.Description = "Drops a bomb very much like the one the attack helicopter drops in HL2."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"npc/attack_helicopter/aheli_mine_drop1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "big_splosion"


-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 300
BULLET.Radius = 400
BULLET.RangeDamageMul = 2.2
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 100
BULLET.PlayerDamageRadius = 100

-- Reloading/Ammo
BULLET.Reloadtime = 3
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 3800

BULLET.UseOldSystem = true

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Initialize (Is called when the entity initializes)
function BULLET:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	self.Entity:NextThink(CurTime())
	
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:SetVelocity(self.Cannon:GetVelocity())
	end
	
	self.Entity.BombSound = CreateSound(self.Entity,Sound("npc/attack_helicopter/aheli_mine_seek_loop1.wav"))
	self.Entity.BombSound:Play()
	self.Timer = CurTime() + 50
	self.Collided = 0
end

-- Think (Is called a lot of times :p)
function BULLET:Think()
	if (CurTime() > self.Timer) then
		if (pewpew:GetConVar( "Damage" )) then
			pewpew:PlayerBlastDamage(self.Entity, self.Entity, self.Entity:GetPos(), self.Bullet.Damage, self.Bullet.Radius)
		end
		pewpew:BlastDamage(self:GetPos(), self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self.Entity, self )
		
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
		
		self.Entity.BombSound:Stop()
		self:Remove()
	end
end

-- This is called when the bullet collides (Advanced users only. It only works if you first override initialize and change it to vphysics)
function BULLET:PhysicsCollide(CollisionData, PhysObj)
	if (CollisionData.HitEntity:IsWorld() and self.Collided == 0) then
		self.Timer = CurTime() + 8
		self.Collided = 1
	end
	if (!CollisionData.HitEntity:IsWorld() and (self.Collided == 0 or self.Collided == 1)) then
		self.Timer = CurTime() + 0.1
		self.Collided = 2
	end
end

pewpew:AddWeapon( BULLET )
