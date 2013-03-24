-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "100 cal explosive rounds"
BULLET.Author = "Divran"
BULLET.Description = "100 caliber machinegun with explosive rounds."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil 
BULLET.Color = nil 
BULLET.Trail = nil 

-- Effects / Sounds
BULLET.FireSound = {"arty/40mm.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "HEATsplode"
BULLET.EmptyMagSound = {"weapons/ar2/ar2_empty.wav"}

-- Movement
BULLET.Speed = 85
--BULLET.Gravity = 0.2
BULLET.RecoilForce = 80
BULLET.Spread = 0.3
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 120
BULLET.Radius = 50
BULLET.RangeDamageMul = 2.9
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 150
BULLET.PlayerDamageRadius = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.4
BULLET.Ammo = 20
BULLET.AmmoReloadtime = 4

BULLET.EnergyPerShot = 600

pewpew:AddWeapon( BULLET )