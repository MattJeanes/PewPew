-- Homing Missile

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Homing Missile - Air to surface"
BULLET.Author = "Divran"
BULLET.Description = "Slow moving, deadly missile. Its limitation is that it can't fly up."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/aamissile.mdl"
BULLET.Material = "phoenix_storms/gear"
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/rocket.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav","weapons/explode5.wav"}
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "v2splode"

-- Movement
BULLET.Speed = 35
BULLET.Gravity = 0
BULLET.RecoilForce = 60
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 1800
BULLET.Radius = 550
BULLET.RangeDamageMul = 2.4
BULLET.PlayerDamage = 500
BULLET.PlayerDamageRadius = 400

-- Reloading/Ammo
BULLET.Reloadtime = 10
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.Lifetime = {4,4}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 10000

BULLET.UseOldSystem = true

BULLET.CustomInputs = { "Fire", "X", "Y", "Z", "XYZ [VECTOR]" }


-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Wire Input (This is called whenever a wire input is changed)
function BULLET:WireInput( inputname, value )
	if (inputname == "Fire") then
		if (value != 0) then
			self.Firing = true
		else
			self.Firing = false
		end
		if (value != 0 and self.CanFire == true) then
			self.LastFired = CurTime()
			self.CanFire = false
			if WireLib then WireLib.TriggerOutput(self.Entity, "Can Fire", 0) end
			self:FireBullet()
		end
	elseif (inputname == "X") then
		if (!self.TargetPos) then self.TargetPos = Vector(0,0,0) end
		self.TargetPos.x = value
	elseif (inputname == "Y") then
		if (!self.TargetPos) then self.TargetPos = Vector(0,0,0) end
		self.TargetPos.y = value
	elseif (inputname == "Z") then
		if (!self.TargetPos) then self.TargetPos = Vector(0,0,0) end
		self.TargetPos.z = value
	elseif (inputname == "XYZ") then
		self.TargetPos = value
	end		
end

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize()   
	self:DefaultInitialize()
	self.TargetDir = self.FlightDirection
	self.MaxZ = self.TargetDir.z
	if (self.Cannon:IsValid()) then
		if (self.Cannon.TargetPos and self.Cannon.TargetPos != Vector(0,0,0)) then
			self.TargetDir = (self.Cannon.TargetPos-self:GetPos()):GetNormalized()
		end
	end

	local trail = ents.Create("env_fire_trail")
	trail:SetPos( self.Entity:GetPos() - self.Entity:GetUp() * 20 )
	trail:Spawn()
	trail:SetParent( self.Entity )
end

-- Think
function BULLET:Think()
	-- Make it fly
	self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
	if (self.Cannon and self.Cannon:IsValid() and self.Cannon.TargetPos) then
		self.FlightDirection = self.FlightDirection + (self.TargetDir-self.FlightDirection) / 20
		self.FlightDirection = self.FlightDirection:GetNormalized()
		
		self.TargetDir = (self.Cannon.TargetPos-self:GetPos()):GetNormalized()
			
		if (self.TargetDir.z < self.MaxZ) then self.MaxZ = self.TargetDir.z end
		self.TargetDir.z = math.min( self.TargetDir.z, self.MaxZ )
	end
	self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )

--[[
	-- Make it fly
	self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
	--if (self.TargetDir != Vector(0,0,0)) then
		self.FlightDirection = self.FlightDirection + (self.TargetDir-self.FlightDirection) / 20
		self.FlightDirection = self.FlightDirection:GetNormalized()
	--end
	if (self.Cannon:IsValid()) then
		if (self.Cannon.TargetPos and self.Cannon.TargetPos != Vector(0,0,0)) then
			self.TargetDir = (self.Cannon.TargetPos-self:GetPos()):GetNormalized()
			if (self.TargetDir.z < self.MaxZ) then self.MaxZ = self.TargetDir.z end
			self.TargetDir.z = math.min( self.TargetDir.z, self.MaxZ )
		end
	end
	self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )
]]
	
	-- Lifetime
	if (self.Lifetime) then
		if (CurTime() > self.Lifetime) then
			if (self.Bullet.ExplodeAfterDeath) then
				local trace = pewpew:Trace(self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed, self)
				self:Explode( trace )
			else
				self.Entity:Remove()
			end
		end
	end
	
	if (CurTime() > self.TraceDelay) then
		-- Check if it hit something
		local trace = pewpew:Trace(self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed, self)
		
		if (trace.Hit and !self.Exploded) then	
			self.Exploded = true
			self:Explode( trace )
		else			
			-- Run more often!
			self.Entity:NextThink( CurTime() )
			return true
		end
	else			
		-- Run more often!
		self.Entity:NextThink( CurTime() )
		return true
	end
end

pewpew:AddWeapon( BULLET )