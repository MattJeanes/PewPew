-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "120mm Cannon (Canister)"
BULLET.Author = "Chippy"
BULLET.Description = "120mm cannon firing canister shells. (Hold fire until completion)."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"chippy/120mm.wav"}
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "muzzleflash"

-- Movement
BULLET.Speed = 150
BULLET.Gravity = 0
BULLET.RecoilForce = 800
BULLET.Spread = 1.5
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "PointDamage" -- Look in gcombat_damagecontrol.lua for available damage types
BULLET.Damage = 5

-- Reloading/Ammo
BULLET.Reloadtime = 0
BULLET.Ammo = 30
BULLET.AmmoReloadtime = 12

BULLET.EnergyPerShot = 14000

pewpew:AddWeapon( BULLET )
