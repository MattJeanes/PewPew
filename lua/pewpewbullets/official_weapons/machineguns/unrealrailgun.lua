-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Plasma Caster"
BULLET.Author = "Divran"
BULLET.Description = "Rapidly fired super-heated balls of plasma that can burn through flesh and stone alike. "
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
BULLET.Speed = 50
BULLET.Gravity = 75
BULLET.RecoilForce = 0
BULLET.Spread = 0.17
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 50
BULLET.NumberOfSlices = 1
BULLET.SliceDistance = 150
BULLET.ReducedDamagePerSlice = 25

-- Reload/Ammo
BULLET.Reloadtime = 0.2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 550

pewpew:AddWeapon( BULLET )
