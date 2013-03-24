-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "EMP Cannon"
BULLET.Author = "Divran"
BULLET.Description = "Fires a bullet which releases an EMP on impact, disabling all wiring for 3 seconds."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/40mm.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 80
--BULLET.Gravity = 0.3
BULLET.RecoilForce = 350
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "EMPDamage"
BULLET.Damage = nil
BULLET.Radius = 300
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.Duration = 3
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 1
BULLET.Ammo = 3
BULLET.AmmoReloadtime = 6
BULLET.EnergyPerShot = 3000

pewpew:AddWeapon( BULLET )