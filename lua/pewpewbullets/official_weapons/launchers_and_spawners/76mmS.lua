-- Smoke Grenade Launcher

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "76mm Smoke Grenade Launcher"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Fires a timed smoke grenade in a short range."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/Items/AR2_Grenade.mdl"
BULLET.Material = "phoenix_storms/gear"
BULLET.Color = nil
BULLET.Trail = { StartSize = 4,
				 EndSize = 0,
				 Length = 0.6,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 200, 200, 200, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"weapons/mortar/mortar_fire1.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "pewpew_bigsmoke"
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 10
BULLET.RecoilForce = 100
BULLET.Spread = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.03
BULLET.Ammo = 3
BULLET.AmmoReloadtime = 45

-- Other
BULLET.Lifetime = {1,1}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 2000

BULLET.UseOldSystem = true

-- Overrides

function BULLET:Initialize()
	self:DefaultInitialize()
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)
	
	-- Lifetime
	self.Lifetime = false
	if (self.Bullet.Lifetime) then
		if (self.Bullet.Lifetime[1] > 0 and self.Bullet.Lifetime[2] > 0) then
			if (self.Bullet.Lifetime[1] == self.Bullet.Lifetime[2]) then
				self.Lifetime = CurTime() + self.Bullet.Lifetime[1]
			else
				self.Lifetime = CurTime() + math.Rand(self.Bullet.Lifetime[1],self.Bullet.Lifetime[2])
			end
		end
	end
	
	-- Trail
	if (self.Bullet.Trail) then
		local trail = self.Bullet.Trail
		util.SpriteTrail( self.Entity, 0, trail.Color, false, trail.StartSize, trail.EndSize, trail.Length, 1/(trail.StartSize+trail.EndSize)*0.5, trail.Texture )
	end
	
	-- Material
	if (self.Bullet.Material) then
		self.Entity:SetMaterial( self.Bullet.Material )
	end
	
	constraint.NoCollide(self.Entity, self.Cannon.Entity, 0, 0)
	
	self.Entity:SetAngles( self.Entity:GetUp():Angle() )
	local phys = self.Entity:GetPhysicsObject()
	phys:SetMass(5)
	phys:ApplyForceCenter( self.Entity:GetForward() * phys:GetMass() * self.Bullet.Speed * 35 )
end

function BULLET:Think()
	-- Lifetime
	if (self.Lifetime) then
		if (CurTime() > self.Lifetime) then
			if (self.Bullet.ExplodeAfterDeath) then
				local tr = {}
				tr.start = self.Entity:GetPos()
				tr.endpos = self.Entity:GetPos()-Vector(0,0,10)
				tr.filter = self.Entity
				local trace = util.TraceLine( tr )
				self:Explode( trace )
			else
				self.Entity:Remove()
			end
		end
	end
	
	self.Entity:NextThink(CurTime() + 1)
	return true
end

pewpew:AddWeapon( BULLET )