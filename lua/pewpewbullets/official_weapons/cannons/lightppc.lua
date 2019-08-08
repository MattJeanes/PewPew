-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Light Particle Projection Cannon "
BULLET.Author = "Hexwolf (Base by Colonel Thirty Two)"
BULLET.Description = "Fires a condensed ball of superheated particles, causes electronics to briefly malfunction."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_230mm.mdl"
BULLET.Material = nil
BULLET.Color = Color(0,255,255,255)
BULLET.Trail = { StartSize = 10,
				 EndSize = 2,
				 Length = 100,
				 Texture = "trails/physbeam",
				 Color = Color( 0,255,255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"col32/bomb3.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 150
--BULLET.Gravity = 0.0
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = false

-- Damage
BULLET.DamageType = "EMPDamage"
BULLET.Damage = 500
BULLET.Radius = 200
BULLET.Duration = 2
BULLET.RangeDamageMul = 2.2
BULLET.PlayerDamage = 75
BULLET.PlayerDamageRadius = 150

-- Reload/Ammo
BULLET.Reloadtime = 6
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 6000

pewpew:AddWeapon( BULLET )
