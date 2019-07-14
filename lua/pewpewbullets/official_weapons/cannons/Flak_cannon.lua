-- Basic Cannon

if SERVER then util.AddNetworkString("PewPew-FlakLifetime") end

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
BULLET.Damage = 125
BULLET.Radius = 425
BULLET.RangeDamageMul = 2
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 35
BULLET.PlayerDamageRadius = 750

-- Reloading/Ammo
BULLET.Reloadtime = 2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = nil
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 2000

BULLET.CustomInputs = { "Fire", "Lifetime" }

if CLIENT then
	net.Receive("PewPew-FlakLifetime", function() local n=net.ReadFloat() BULLET.Lifetime={n,n} end)
end

-- Wire Input (This is called whenever a wire input is changed)
BULLET.WireInputOverride = true
function BULLET:WireInput( inputname, value )
	if (inputname == "Lifetime") then
		self.Lifetime = value
		net.Start("PewPew-FlakLifetime")
			net.WriteFloat(value)
		net.Broadcast()
	else
		self:InputChange( inputname, value )
	end
end

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize()
	pewpew:DefaultBulletInitialize( self )
	-- Lifetime
	if (self.Cannon.Lifetime) then
		self.Lifetime = CurTime() + self.Cannon.Lifetime
	end
end

pewpew:AddWeapon( BULLET )
