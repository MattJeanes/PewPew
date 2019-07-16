-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "2A42"
BULLET.Author = "Chippy"
BULLET.Description = "A 30mm Russian autocannon."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_40mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"chippy/2a42.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "gcombat_explosion"

-- Movement
BULLET.Speed = 200
--BULLET.Gravity = 0.04
BULLET.RecoilForce = 0
BULLET.Spread = 0.2
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 75
BULLET.Radius = 75
BULLET.RangeDamageMul = 2.8
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamageRadius = 75
BULLET.PlayerDamage = 70

-- Reload/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 50
BULLET.AmmoReloadtime = 10

BULLET.EnergyPerShot = 500

pewpew:AddWeapon( BULLET )
