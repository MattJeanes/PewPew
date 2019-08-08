-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "105mm Cannon (AP)"
BULLET.Author = "Divran"
BULLET.Description = "Slow rate of fire, high damage."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/105mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 145
--BULLET.Gravity = 0.1
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 800
BULLET.NumberOfSlices = 3
BULLET.SliceDistance = 550
BULLET.ReducedDamagePerSlice = 0

-- Reloading/Ammo
BULLET.Reloadtime = 7
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 9500

pewpew:AddWeapon( BULLET )
