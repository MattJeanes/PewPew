-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Plasma Caster"
BULLET.Author = "Divran"
BULLET.Description = "An unrealistic railgun :)"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Material = nil
BULLET.Color = Color( 0, 255, 255 )
BULLET.Trail = { StartSize = 40,
				 EndSize = 35,
				 Length = 1,
				 Texture = "trails/laser.vmt",
				 Color = Color( 0, 255, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"LightDemon/Railgun.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "railgun"

-- Movement
BULLET.Speed = 90
BULLET.Gravity = 125
BULLET.RecoilForce = 0
BULLET.Spread = 0.15
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 100
BULLET.Radius = 75
BULLET.RangeDamageMul = 2.8
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = 70
BULLET.PlayerDamage = 50

-- Reload/Ammo
BULLET.Reloadtime = 0.2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 550

pewpew:AddWeapon( BULLET )
