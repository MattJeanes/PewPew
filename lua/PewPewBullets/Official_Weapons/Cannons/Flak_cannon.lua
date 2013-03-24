-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Flak Cannon"
BULLET.Author = "Divran"
BULLET.Description = "Shoots bullets which explode in midair, making it easier to shoot down airplanes."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/40mm.wav"}
BULLET.ExplosionSound = {"weapons/pipe_bomb1.wav","weapons/pipe_bomb2.wav","weapons/pipe_bomb3.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "pewpew_smokepuff"

-- Movement
BULLET.Speed = 135
--BULLET.Gravity = 0.06
BULLET.RecoilForce = 400
BULLET.Spread = 1
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 250
BULLET.Radius = 850
BULLET.RangeDamageMul = 2
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 500
BULLET.PlayerDamageRadius = 1000

-- Reloading/Ammo
BULLET.Reloadtime = 2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = nil
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 2000

BULLET.CustomInputs = { "Fire", "Lifetime" }

pewpew:AddWeapon( BULLET )

-- Wire Input (This is called whenever a wire input is changed)
BULLET.WireInputOverride = true
function BULLET:WireInput( self, inputname, value )
	if (inputname == "Lifetime") then
		self.Lifetime = value
	else
		self:InputChange( inputname, value )
	end
end

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize(Bullet)   
	pewpew:DefaultBulletInitialize( Bullet )
	-- Lifetime
	if (Bullet.Cannon.Lifetime) then
		Bullet.BulletData.Lifetime = CurTime() + Bullet.Cannon.Lifetime
	end
end