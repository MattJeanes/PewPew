-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Torpedo"
BULLET.Author = "Divran"
BULLET.Description = "Launches a torpedo which can only travel under water."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/props_c17/canister01a.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"weapons/grenade_launcher1.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav", "weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "big_splosion"
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 40
BULLET.Gravity = 1.5
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 500
BULLET.Radius = 700
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
	self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )    
	self.FlightDirection = self.Entity:GetUp()
	self.Exploded = false
	self.Delay = 0
	self.Grav = 0
	
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
	-- Make it fly
	if (self.Entity:WaterLevel() == 0) then
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed / 2 )
		self.FlightDirection = self.FlightDirection - Vector(0,0,self.Bullet.Gravity / self.Bullet.Speed)
		self.FlightDirection.z = math.Clamp( self.FlightDirection.z, 0, self.FlightDirection.z )
		self.Entity:SetPos( self.Entity:GetPos() - Vector(0,0,self.Grav) )
		self.Grav = self.Grav + 0.3
		
		self.Delay = CurTime() + 0.5
	elseif (self.Entity:WaterLevel() > 0 and CurTime() < self.Delay and self.Delay > 0) then
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed / 2 )
		self.FlightDirection = self.FlightDirection - Vector(0,0,self.Bullet.Gravity / self.Bullet.Speed)
		self.FlightDirection.z = math.Clamp( self.FlightDirection.z, 0, self.FlightDirection.z )
		self.Entity:SetPos( self.Entity:GetPos() - Vector(0,0,self.Grav) )
		self.Grav = self.Grav + 0.05
	elseif (self.Entity:WaterLevel() > 0 and CurTime() > self.Delay) then
		self.Grav = 0
		self.Delay = 0
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
	end
	self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )
	
	-- Check if it hit something
	local trace = pewpew:Trace(self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed, self)
	
	if (trace.Hit) then
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

pewpew:AddWeapon( BULLET )
