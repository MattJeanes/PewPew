-- Deathray

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Deathray"
BULLET.Author = "Free Fall"
BULLET.Description = "Combine laser and lightning. What do you get?"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false
BULLET.UseOldSystem = true

-- Appearance
BULLET.Model = nil
BULLET.Material = nil
BULLET.Color = nil
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = "npc/strider/fire.wav"
BULLET.FireEffect = nil
BULLET.ExplosionEffect = "big_splosion"
BULLET.ExplosionSound = nil

-- Movement
BULLET.Speed = nil
BULLET.Gravity = nil
BULLET.RecoilForce = nil
BULLET.Spread = nil

-- Damage
BULLET.DamageType = "BlastDamage"
BULLET.Damage = 600
BULLET.Radius = 500
BULLET.RangeDamageMul = 1.6
BULLET.PlayerDamage = 140
BULLET.PlayerDamageRadius = 400

-- Reloading/Ammo
BULLET.Reloadtime = 8
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.EnergyPerShot = 8000

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Dir, Pos = pewpew:GetFireDirection( self.Direction, self )
		
	self:EmitSound(self.Bullet.FireSound, 100, 100)
	
	local trace = pewpew:Trace( Pos, Dir * 100000 )
	
	local ent = ents.Create("pewpew_base_bullet")
	ent:SetPos(trace.HitPos)
	ent:SetAngles(trace.HitNormal:Angle() + Angle(90, 0, 0))
	ent:SetOptions(self.Bullet, self, self.Owner )
	ent:GetTable().MoreLeft = 20
	ent:Spawn()
	ent:Activate()

	if (trace.Entity and trace.Entity:IsValid()) then
		if (trace.Entity and trace.Entity:IsValid()) then
			-- Stargate shield damage
			if (trace.Entity:GetClass() == "shield") then
				trace.Entity:Hit(nil,trace.HitPos,self.Bullet.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
			else
				pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
			end
		end
		pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, trace.Entity, self )
	else
		pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, nil, self )
	end
	
	-- Player Damage
	if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew:GetConVar( "Damage" )) then
		pewpew:PlayerBlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin(trace.HitPos)
	effectdata:SetStart(Pos)
	util.Effect( "Deathbeam", effectdata )
	
	local effectdata = EffectData()
	effectdata:SetOrigin(trace.HitPos)
	effectdata:SetStart(trace.HitPos +  trace.Normal * 10)
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize()
	self.Entity:SetModel("models/weapons/w_bugbait.mdl") 
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetMoveType(MOVETYPE_NONE)
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetColor(Color(100,100,100,0))
	self.Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
	
	self.FlightDirection = self.Entity:GetUp()
	self.Exploded = false
	self.Living = true
	
	self:SetNetworkedEntity("LaserTarget", self.Entity)
end

-- Think (Is called a lot of times :p)
function BULLET:Think( )
	if (self.Living == false) then self:Remove() return false end
	
	if (self.MoreLeft > 0) then
		local trace = util.QuickTrace(self:GetPos() + self:GetUp() * 300, self:GetUp() * -900 + VectorRand() * 600, self.Entity)
		if trace.Hit then
			local ent = ents.Create("pewpew_base_bullet")
			ent:SetPos(trace.HitPos)
			ent:SetAngles(trace.HitNormal:Angle() + Angle(90, 0, 0))
			ent:SetOptions(self.Bullet, self, self.Owner )
			ent:GetTable().MoreLeft = self.MoreLeft - 1
			ent:Spawn()
			ent:Activate()
			
			self:SetNetworkedEntity("LaserTarget", ent)
			
			if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew:GetConVar( "Damage" )) then
				pewpew:PlayerBlastDamage(self.Entity, self.Entity, trace.HitPos, self.Bullet.PlayerDamageRadius / 2, self.Bullet.PlayerDamage / 6)
			end
			pewpew:BlastDamage(trace.HitPos, self.Bullet.Radius / 2, self.Bullet.Damage / 6, self.Bullet.RangeDamageMul, nil, self )
			
			self.MoreLeft = 0
		end
	end
	
	self.Living = false
	
	self:NextThink(CurTime() + 2)
	return true
end

if (CLIENT) then
	local Laser = Material( "sprites/rollermine_shock" )

	function BULLET:CLDraw()
		local Pos = self:GetPos()
		
		local LaserTarget = self:GetNetworkedEntity("LaserTarget")
		if (not LaserTarget or not LaserTarget:IsValid()) then LaserTarget = self.Entity end
		
		render.SetMaterial(Laser)
		local DirMins = LaserTarget:GetPos() - Pos
		
		render.StartBeam(7)
		render.AddBeam(Pos, 64, 0, Color(255, 255, 255, 255))
		for i = 2, 6 do
			local CurPos = Pos + (i / 7) * DirMins + VectorRand() * 40
			render.AddBeam(CurPos, 64, CurTime() + (i / 5), Color(255, 255, 255, 255))
		end
		render.AddBeam(LaserTarget:GetPos(), 64, 1, Color(255, 255, 255, 255))
		render.EndBeam()
	end
end

pewpew:AddWeapon( BULLET )