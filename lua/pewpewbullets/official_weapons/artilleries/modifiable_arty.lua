-- Modifiable Artillery

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Modifiable Artillery"
BULLET.Author = "Divran"
BULLET.Description = "An artillery with a modifiable speed."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/40mm.wav"}
BULLET.ExplosionSound = {"weapons/explode3.wav","weapons/explode4.wav", "weapons/explode5.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "HEATsplode"
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = "?"
BULLET.Gravity = 0.5
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 175
BULLET.Radius = 150
BULLET.RangeDamageMul = 2.6
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = nil
BULLET.PlayerDamage = 110
BULLET.PlayerDamageRadius = 150

-- Reloading/Ammo
BULLET.Reloadtime = 2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = nil
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 1000

BULLET.CustomInputs = { "Fire", "Reload", "Speed" }
BULLET.CustomOutputs = nil

BULLET.UseOldSystem = true

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Wire Input (This is called whenever a wire input is changed)
function BULLET:WireInput( inputname, value )
	if (inputname == "Speed") then
		self.CustomSpeed = math.Clamp(value,10,200)
	else
		self:InputChange( inputname, value )
	end
end

-- Initialize (Is called when the bullet initializes)
function BULLET:Fire()
	self.Bullet.Speed = self.CustomSpeed or 100
	self:OldSystem_FireBullet()
end

pewpew:AddWeapon( BULLET )
