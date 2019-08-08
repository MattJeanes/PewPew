-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "37mm Cannon (AP)"
BULLET.Author = "Divran"
BULLET.Description = "Rapid fire, low damage."
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
BULLET.Speed = 175
--BULLET.Gravity = 0.1
BULLET.RecoilForce = 100
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 300
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 300
BULLET.ReducedDamagePerSlice = 0

-- Reloading/Ammo
BULLET.Reloadtime = 2.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 2500

pewpew:AddWeapon( BULLET )
