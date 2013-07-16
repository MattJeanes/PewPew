-- Low Velocity Artillery

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Low Velocity Artillery"
BULLET.Author = "Divran"
BULLET.Description = "Has a low initial velocity, making it easier to fire in high arcs to shoot above walls without hitting the top of the map. Otherwise has the same stats as the basic artillery."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"arty/cannon.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "artyfire"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 50
BULLET.RecoilForce = 500
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 800
BULLET.Radius = 500
BULLET.RangeDamageMul = 1.6
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 450
BULLET.PlayerDamageRadius = 500

-- Reloading/Ammo
BULLET.Reloadtime = 7.5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 8000

pewpew:AddWeapon( BULLET )
