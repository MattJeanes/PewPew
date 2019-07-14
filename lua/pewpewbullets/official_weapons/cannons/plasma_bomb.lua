-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Plasma Cannon"
BULLET.Author = "Colonel Thirty Two"
BULLET.Description = "Shoots balls of plasma at people"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_230mm.mdl"
BULLET.Material = nil
BULLET.Color = Color(150,150,255,255)
BULLET.Trail = { StartSize = 10,
				 EndSize = 2,
				 Length = 0.6,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 150, 150, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"col32/bomb3.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "enersplosion"

-- Movement
BULLET.Speed = 75
BULLET.RecoilForce = 500
BULLET.Spread = 0
--BULLET.Gravity = 0.06
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 140
BULLET.Radius = 250
BULLET.RangeDamageMul = 2.2
BULLET.PlayerDamage = 99
BULLET.PlayerDamageRadius = 100

-- Reload/Ammo
BULLET.Reloadtime = 3
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 6000

pewpew:AddWeapon( BULLET )
