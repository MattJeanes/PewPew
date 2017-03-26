-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Depth Charge"
BULLET.Author = "Zio_Matrix"
BULLET.Description = "Launches a Depth Charge that explodes underwater."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_c17/oildrum001.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"weapons/grenade_launcher1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav", "weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "pewpew_c4_explosion"
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 40
BULLET.Gravity = 1.5
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 2500
BULLET.Radius = 350
BULLET.RangeDamageMul = 2.4
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = nil
BULLET.PlayerDamage = 350
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 5000

BULLET.UseOldSystem = true -- because I'm too lazy to convert it :/


-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize()   
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS) 
	self.FlightDirection = self.Entity:GetUp()
	self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(0,0,90) )
	
	local phys = self.Entity:GetPhysicsObject()
	phys:Wake()
	
	self.Grav = 0
	self.Hit = false
	self.Sink = false
	self.SinkCheck = false
	self.SinkStop = false
	self.SinkDet = 0
	
	-- Trail
	if (self.Bullet.Trail) then
		local trail = self.Bullet.Trail
		util.SpriteTrail( self.Entity, 0, trail.Color, false, trail.StartSize, trail.EndSize, trail.Length, 1/(trail.StartSize+trail.EndSize)*0.5, trail.Texture )
	end
	
	-- Material
	if (self.Bullet.Material) then
		self.Entity:SetMaterial( self.Bullet.Material )
	end
	
	-- Color
	if (self.Bullet.Color) then
		local C = self.Bullet.Color
		self.Entity:SetColor( C.r, C.g, C.b, C.a or 255 )
	end
end

-- Think
function BULLET:Think()
	-- Make it sink
	if (self.Entity:WaterLevel() > 0 and not self.SinkStop) then
		self.Grav = 1.7
		self.Delay = 0
		self.Sink = true
		self.Entity:SetPos( self.Entity:GetPos() - Vector(0,0,self.Grav))
	end
	
	if (self.Sink and not self.SinkCheck) then
		self.SinkDet = CurTime() + (math.random(30, 50) / 10)
		self.SinkCheck = true
	end

	local pos = self.Entity:GetPos()
	local tracedata = {}
	tracedata.start = pos
	tracedata.endpos = self.Entity:GetPos() - Vector(0,0,50)
	tracedata.filter = self
	local trace = util.TraceLine(tracedata)		
	
	if (trace.Hit and self.Entity:WaterLevel() > 0) then
		self.SinkStop = true
	end
	
	-- Detonates either on a timer, or on collision with something underwater
	if (self.Sink and CurTime() >= self.SinkDet) then
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
		
		self.Entity:EmitSound(table.Random(self.Bullet.ExplosionSound), 500, 100)
		
		self:Remove()
	end
	
	self.Entity:NextThink(CurTime())
	return true
end

function BULLET:PhysicsCollide(CollisionData, PhysObj)
	if (not (self.Entity:IsValid() and PhysObj == self.Entity:GetPhysicsObject()) and self.Sink) then
		local Entity = CollisionData.HitEntity
		
		self.Hit = true
		self:NextThink(CurTime())
	end
end

pewpew:AddWeapon( BULLET )
