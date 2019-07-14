-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Nebelwerfer"
BULLET.Author = "Free Fall"
BULLET.Description = "Fires smoking artillery rounds."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_c17/canister01a.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"weapons/rpg/rocketfire1.wav"}
BULLET.ExplosionSound = nil -- Custom, see PhysicsCollideFunc
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 50
BULLET.Gravity = nil
BULLET.RecoilForce = 500
BULLET.Spread = 2

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 200
BULLET.Radius = 450
BULLET.RangeDamageMul = 2.6
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 40
BULLET.PlayerDamageRadius = 250

-- Reloading/Ammo
BULLET.Reloadtime = 0.3
BULLET.Ammo = 6
BULLET.AmmoReloadtime = 6

BULLET.EnergyPerShot = 400

BULLET.UseOldSystem = true

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Initialize (Is called when the entity initializes)
function BULLET:Initialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	self.Fuse = CurTime() + 1
	self.Burning = true
	
	self.Entity:SetPos(self.Entity:GetPos() + self.Entity:GetUp() * 40)
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	self:SetNetworkedBool("Burning", true)
	
	self.Entity:NextThink(CurTime())
end

-- Think
function BULLET:Think()
	if (self.Burning and CurTime() > self.Fuse) then
		self.Burning = false
		
		self:SetNetworkedBool("Burning", false)
	end
	
	if (not self.Burning and self.Entity:GetVelocity():Length() < 1) then
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
		
		self.Entity:EmitSound("ambient/explosions/explode_" .. math.random(1,4) .. ".wav", 500, 100)
		
		self:Remove()
	end
	
	if (self.Burning) then
		local phys = self.Entity:GetPhysicsObject()
		if (phys:IsValid()) then
			phys:ApplyForceCenter(self.Entity:GetUp() * phys:GetMass() * self.Bullet.Speed)
		end
		
		self.Entity:NextThink(CurTime())
		return true
	end
end

-- This is called when the bullet collides (Advanced users only. It only works if you first override initialize and change it to vphysics)
function BULLET:PhysicsCollide(CollisionData, PhysObj)
	if (not (self.Cannon:IsValid() and PhysObj == self.Cannon:GetPhysicsObject()) and not self.Burning) then
		if (pewpew:GetConVar( "Damage" )) then
			pewpew:PlayerBlastDamage(self.Entity, self.Entity, CollisionData.HitPos, self.Bullet.Damage, self.Bullet.Radius)
		end
		if (pewpew:CheckValid(CollisionData.HitEntity)) then
			pewpew:PointDamage(CollisionData.HitEntity,self.Bullet.Damage,self)
			pewpew:BlastDamage(CollisionData.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul,CollisionData.HitEntity,self)
		else
			pewpew:BlastDamage(CollisionData.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul,nil,self)
		end
		
		
		if (self.Bullet.ExplosionEffect) then
			local effectdata = EffectData()
			effectdata:SetOrigin(CollisionData.HitPos)
			effectdata:SetStart(CollisionData.HitPos)
			effectdata:SetNormal(CollisionData.HitNormal)
			util.Effect(self.Bullet.ExplosionEffect, effectdata)
		end
		
		self.Entity:EmitSound("ambient/explosions/explode_" .. math.random(1,4) .. ".wav", 500, 100)
		
		self:Remove()
	end
end

function BULLET:CLInitialize()
	self.ParticleEmitter = ParticleEmitter(Vector(0,0,0))
end

function BULLET:CLThink()
	self.Burning = self:GetNetworkedBool("Burning")
	
	local Pos = self.Entity:GetPos()
	
	if (self.Burning) then	
		for i = 0, 8 do
			local particle = self.ParticleEmitter:Add("particles/flamelet" .. math.random(1,5), Pos + (self.Entity:GetUp() * -30 * i))
			if (particle) then
				particle:SetVelocity((self.Entity:GetUp() * -30) )
				particle:SetLifeTime(0)
				particle:SetDieTime(0.2)
				particle:SetStartAlpha(math.random( 200, 255 ) )
				particle:SetEndAlpha(0)
				particle:SetStartSize(40 - 4 * i)
				particle:SetEndSize(0)
				particle:SetRoll(math.random(0, 360))
				particle:SetRollDelta(math.random(-10, 10))
				particle:SetColor(255, 255, 255) 
			end
		end
	else
		local particle = self.ParticleEmitter:Add("particles/smokey", Pos + VectorRand() * math.random(1, 20))
		if (particle) then
			particle:SetVelocity(self.Entity:GetUp() * math.random(50, 100) * -1)
			particle:SetLifeTime(0)
			particle:SetDieTime(math.random(2, 8))
			particle:SetStartAlpha(math.random( 200, 255))
			particle:SetEndAlpha(0)
			particle:SetStartSize(30)
			particle:SetEndSize(400)
			particle:SetRoll( math.random(0, 360))
			particle:SetRollDelta(math.random(-0.2, 0.2))
			particle:SetColor(255 , 255 , 255) 
		end
	end
	
	self.Entity:NextThink(CurTime()+0.05)
	return true
end

pewpew:AddWeapon( BULLET )
