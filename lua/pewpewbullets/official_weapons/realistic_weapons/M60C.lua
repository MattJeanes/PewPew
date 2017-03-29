local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "M60C machinegun"
BULLET.Author = "Chippy"
BULLET.Description = "50cal machinegun, commonly used as the doorgun for the UH-1."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_25mm.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"chippy/m60.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = "muzzleflash"
BULLET.ExplosionEffect = "mghit"
BULLET.EmptyMagSound = {"weapons/shotgun/shotgun_empty.wav"}

-- Movement
BULLET.Speed = 130
--BULLET.Gravity = 0.15
BULLET.RecoilForce = 80
BULLET.Spread = 0.30
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 70
BULLET.Radius = nil
BULLET.RangeDamageMul = nil
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = nil
BULLET.PlayerDamageRadius = nil

-- Reloading/Ammo
BULLET.Reloadtime = 0.113
BULLET.Ammo = 50
BULLET.AmmoReloadtime = 10

BULLET.EnergyPerShot = 300

pewpew:AddWeapon( BULLET )