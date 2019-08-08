-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "90mm Auto Loading Cannon (AP)"
BULLET.Author = "Divran"
BULLET.Description = "Aim away from face."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/37mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 150
--BULLET.Gravity = 0.5
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 600
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 500
BULLET.ReducedDamagePerSlice = 0

-- Reloading/Ammo
BULLET.Reloadtime = 3
BULLET.Ammo = 5
BULLET.AmmoReloadtime = 30

BULLET.EnergyPerShot = 3700

pewpew:AddWeapon( BULLET )
