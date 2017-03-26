-- Big Laser

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Big Star Wars Laser"
BULLET.Author = "Divran"
BULLET.Description = "A big Star Wars laser."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/PenisColada/redlaser.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"starwars/large.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "pewpew_starwars_laserhit"

-- Movement
BULLET.Speed = 115
BULLET.Gravity = 0
BULLET.RecoilForce = 0
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 745

-- Reloading/Ammo
BULLET.Reloadtime = 1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 1200

pewpew:AddWeapon( BULLET )