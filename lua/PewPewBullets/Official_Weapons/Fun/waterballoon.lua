-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Water Balloons"	
BULLET.Author = "Kouta"
BULLET.Description = "Soak your childhood enemies"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/maxofs2d/balloon_classic.mdl"
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"weapons/stickybomblauncher_shoot.wav"}
BULLET.ExplosionSound = {"ambient/water/water_splash1.wav","ambient/water/water_splash2.wav","ambient/water/water_splash3.wav"}
BULLET.FireEffect = "MuzzleFlash"
BULLET.ExplosionEffect = ""

-- Movement
BULLET.Speed = 25
--BULLET.Gravity = 0.25
BULLET.RecoilForce = 0
BULLET.Spread = 1.5
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
BULLET.Reloadtime = 0.45
BULLET.Ammo = 6
BULLET.AmmoReloadtime = 5

BULLET.EnergyPerShot = 400

-- Initialize (Is called when the bullet initializes)
function BULLET:CLInitialize()   
	pewpew:DefaultBulletInitialize( self )
	self.Prop:SetColor(Color(math.random(25,255), math.random(25,255), math.random(25,255), 255))
end

-- Explode (Is called when the bullet explodes)
function BULLET:CLExplode(trace)
	
	local vOffset = trace.HitPos+Vector(0,0,2)
	local Norm = trace.HitNormal
	local splash = math.random(13,16)

	self.Prop:EmitSound("weapons/ar2/npc_ar2_altfire.wav", 80, 130)

	local effectdata = EffectData()
		effectdata:SetOrigin(vOffset)
		effectdata:SetStart(vOffset)
		effectdata:SetNormal(Norm)
		effectdata:SetRadius(splash)
		effectdata:SetScale(splash)

	util.Effect( "watersplash", effectdata )
end

pewpew:AddWeapon( BULLET )