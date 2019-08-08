-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "XR-8 Railgun"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Fires extremely fast moving rounds with deadly accuracy. Slices through armor like a hot knife through butter."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Trail = { StartSize = 10,
				 EndSize = 2,
				 Length = 0.3,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 255, 255, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"arty/railgun.wav"}
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 1000
--BULLET.Gravity = 0.02
BULLET.RecoilForce = 100
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 800
BULLET.NumberOfSlices = 8
BULLET.SliceDistance = 5000
BULLET.ReducedDamagePerSlice = 100

-- Reload/Ammo
BULLET.Reloadtime = 6.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 5500

pewpew:AddWeapon( BULLET )
