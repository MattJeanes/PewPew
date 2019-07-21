-- Homing Missile

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Salvo Six"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Rapidly fires a spectacle of up to six light explosive partial tracking missiles."
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
BULLET.Speed = 175
BULLET.Gravity = 0
BULLET.RecoilForce = 60
BULLET.Spread = 0.75

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 60
BULLET.Radius = 100
BULLET.RangeDamageMul = 2.8
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 20
BULLET.PlayerDamageRadius = 100

-- Reloading/Ammo
BULLET.Reloadtime = 0.01
BULLET.Ammo = 6
BULLET.AmmoReloadtime = 12

BULLET.Lifetime = {0.4,6}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 7000

BULLET.CustomInputs = { "Fire", "X", "Y", "Z", "XYZ [VECTOR]" }

BULLET.UseOldSystem = true
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
	
	self.TargetDir = self.Entity:GetUp()
	if (self.Cannon:IsValid()) then
		if (self.Cannon.TargetPos and self.Cannon.TargetPos != Vector(0,0,0)) then
			self.TargetDir = (self.Cannon.TargetPos-self:GetPos()):GetNormalized()
		end
	end
	
	-- Lifetime
	self.Lifetime = CurTime() + self.Bullet.Lifetime[2]
	self.Thrust = CurTime() + self.Bullet.Lifetime[1]
