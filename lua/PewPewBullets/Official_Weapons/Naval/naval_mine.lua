-- Naval Mine

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Naval Mine"
BULLET.Author = "Divran"
BULLET.Description = "Deploy in water. Mines will explode when touched."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "Enersplosion"
BULLET.ExplosionEffect = nil

-- Movement
BULLET.Speed = nil
BULLET.Gravity = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 3000
BULLET.Radius = 1000
BULLET.RangeDamageMul = 2.6
BULLET.PlayerDamage = 2000
BULLET.PlayerDamageRadius = 950

-- Reloading/Ammo
BULLET.Reloadtime = 1
BULLET.Ammo = 0

BULLET.EnergyPerShot = 20000

function BULLET:Fire() end

BULLET.CustomInputs = {}
BULLET.CustomOutputs = {}

function BULLET:CannonThink()
	local phys = self.Entity:GetPhysicsObject()
	if (!phys) then return end
	
	-- Check the height from the water floor every few seconds
	if (!self.TraceDist or CurTime() > self.NextTrace) then
		local tr = {}
		tr.start = self:GetPos()
		tr.endpos = self:GetPos() - Vector(0,0,99999999)
		tr.filter = self.Entity
		local trace = util.TraceLine( tr )
		self.TraceDist = trace.HitPos:Distance(self:GetPos())
		if (!self.TargetHeight) then self.TargetHeight = self.TraceDist end
		self.NextTrace = CurTime() + 2
	end
	
	if (self.TraceDist and (self:WaterLevel() > 0)) then -- Make sure it has a trace distance, and make sure it's below the water level
		-- Apply force to make it hover
		local diff = self.TargetHeight - self.TraceDist
		phys:ApplyForceCenter( ( Vector(0,0,diff*0.5-0.35) - self.Entity:GetVelocity() * Vector(0.2,0.2,0.8) ) * 35 )
	elseif (!(self:WaterLevel() > 0)) then -- If it jumps above the water, set the distance again
		local tr = {}
		tr.start = self:GetPos()
		tr.endpos = self:GetPos() - Vector(0,0,99999999)
		tr.filter = self.Entity
		local trace = util.TraceLine( tr )
		self.TraceDist = trace.HitPos:Distance(self:GetPos()) - 30
		self.TargetHeight = self.TraceDist
		self.NextTrace = CurTime() + 2
	end
	self:NextThink( CurTime() )
	return true
end

function BULLET:CannonPhysicsCollide( Data, PhysObj )

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