local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "7.62x51mm Machinegun"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "7.62x51mm Machinegun."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil
					

-- Effects / Sounds
BULLET.FireSound = {"arty/20mmauto.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "mghit"
BULLET.EmptyMagSound = {"weapons/pistol/pistol_empty.wav"}

-- Movement
BULLET.Speed = 125
--BULLET.Gravity = 0.1
BULLET.RecoilForce = 30
BULLET.Spread = 0.2
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 25
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.2
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 180

pewpew:AddWeapon( BULLET )
