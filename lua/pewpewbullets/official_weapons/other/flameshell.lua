-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Flame Shell"
BULLET.Author = "Kouta"
BULLET.Description = "Makes an area nice and toasty"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false
BULLET.UseOldSystem = true

-- Appearance
BULLET.Model = "models/combatmodels/tankshell.mdl"
BULLET.Material = nil
BULLET.Color = Color(255,150,0)
BULLET.Trail = {StartSize=30, EndSize=0, Length=0.2, Texture="trails/smoke.vmt", Color=Color(125,125,125)}

-- Effects / Sounds
BULLET.FireSound = {"ambient/fire/gascan_ignite1.wav"}
BULLET.ExplosionSound = {"ambient/fire/ignite.wav"}
BULLET.FireEffect = "artyfire"
BULLET.ExplosionEffect = "firey"

-- Movement
BULLET.Speed = 65
--BULLET.Gravity = 0.2
BULLET.RecoilForce = 500
BULLET.Spread = 0

-- Damage
BULLET.DamageType = "BlastDamage" --FireDamage?
BULLET.Damage = 300
BULLET.Radius = 500
BULLET.RangeDamageMul = 1.6
BULLET.NumberOfSlices = nil
BULLET.SliceDistance = nil
BULLET.PlayerDamage = 200
BULLET.PlayerDamageRadius = 500

-- Reloading/Ammo
BULLET.Reloadtime = 11
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 9000

-- Explode (Is called when the bullet explodes)
function BULLET:Explode(trace)

	local Pos = self.Entity:GetPos()
	local Norm = self.Entity:GetUp()

	pewpew:PlayerBlastDamage(self.Entity, self.Entity, Pos+Norm*10, self.Bullet.Damage, self.Bullet.Radius)
	pewpew:BlastDamage(Pos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self )
	
	local vOffset = Pos+Vector(0,0,2)

	self.Entity:EmitSound("ambient/fire/ignite.wav", 90, 100)
	self.Entity:EmitSound("ambient/explosions/explode_4.wav", 80, 100)

	local effectdata = EffectData()
		effectdata:SetOrigin(vOffset)
		effectdata:SetStart(vOffset)
		effectdata:SetNormal(Norm)
	util.Effect(self.Bullet.ExplosionEffect, effectdata)

	//Set things on fire!
	local EIS = ents.FindInSphere(self.Entity:GetPos(), self.Bullet.Radius*1.5)
	
	for _,t in pairs(EIS) do
		if (t:GetClass() == "prop_physics" || t:IsPlayer() || t:IsNPC() && t ~= self.Entity && (not t:IsOnFire())) then
			t:Ignite(math.Rand(1,5),0) //Might make a check to stop huge things being ignited
		end
	end

	self.Entity:Remove()
end

pewpew:AddWeapon( BULLET )