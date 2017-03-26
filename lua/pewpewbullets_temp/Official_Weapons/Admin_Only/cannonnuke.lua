-- Cannon Nuke

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Cannon Nuke"
BULLET.Author = "Divran"
BULLET.Description = "BLAAAAAARGH"
BULLET.AdminOnly = true
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = { "arty/arty.wav" }
BULLET.ExplosionSound = { "ambient/explosions/citadel_end_explosion1.wav", "ambient/explosions/citadel_end_explosion2.wav" }
BULLET.FireEffect = "artyfire"
BULLET.ExplosionEffect = "breachsplode"

-- Movement
BULLET.Speed = 150
--BULLET.Gravity = 0.2
BULLET.RecoilForce = 1000
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 100000
BULLET.Radius = 7000
BULLET.RangeDamageMul = 2.2
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 5000
BULLET.PlayerDamageRadius = 5000

-- Reloading/Ammo
BULLET.Reloadtime = 11
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 11000000

pewpew:AddWeapon( BULLET )