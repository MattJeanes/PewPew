-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "120mm HE Cannon"
BULLET.Author = "Chippu"
BULLET.Description = "120mm High Explosive tank cannon."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"chippy/120mm.wav"}
BULLET.ExplosionSound = {"weapons/explode1.wav","weapons/explode2.wav"}
BULLET.FireEffect = "cannon_flare"
BULLET.ExplosionEffect = "big_splosion"

-- Movement
BULLET.Speed = 120
--BULLET.Gravity = 0.056
BULLET.RecoilForce = 800
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 1750
BULLET.Radius = 800
BULLET.RangeDamageMul = 3
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 600
BULLET.PlayerDamageRadius = 1000

-- Reloading/Ammo
BULLET.Reloadtime = 8
BULLET.Ammo = 25
BULLET.AmmoReloadtime = 100

BULLET.EnergyPerShot = 14000

pewpew:AddWeapon( BULLET )