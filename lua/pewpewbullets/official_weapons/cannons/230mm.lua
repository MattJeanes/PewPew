-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "230mm Cannon (Restricted)"
BULLET.Author = "Divran"
BULLET.Description = "Very slow rate of fire, very high damage."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = true

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_230mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/230mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "Enersplosion"

-- Movement
BULLET.Speed = 150
--BULLET.Gravity = 0.1
BULLET.RecoilForce = 700
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 1000
BULLET.Radius = 450
BULLET.RangeDamageMul = 2.4
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 300

-- Reloading/Ammo
BULLET.Reloadtime = 17.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 20000

pewpew:AddWeapon( BULLET )
