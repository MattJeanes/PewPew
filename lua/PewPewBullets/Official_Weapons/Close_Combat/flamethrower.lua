-- Basic Cannon

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Flamethrower"
BULLET.Author = "Divran"
BULLET.Description = "Kill it with fire!"
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/weapons/w_bugbait.mdl" 
BULLET.Material = nil
BULLET.Color = Color(255,255,255,0)
BULLET.Trail = nil

-- Effects / Sounds
BULLET.FireSound = {"ambient/fire/mtov_flame2.wav"}
BULLET.ExplosionSound = nil
BULLET.FireEffect = nil
BULLET.ExplosionEffect = nil
BULLET.EmptyMagSound = nil

-- Movement
BULLET.Speed = 70
BULLET.Gravity = 0.08
BULLET.RecoilForce = 0
BULLET.Spread = 3
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "FireDamage"
BULLET.DPS = 20
BULLET.Duration = 5

-- Reloading/Ammo
BULLET.Reloadtime = 0.1
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.EnergyPerShot = 100

-- Custom Functions 
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Initialize (Is called when the bullet initializes)
function BULLET:Initialize()
	self.Exploded = false
	self.Speed = self.WeaponData.Speed
	self.TraceDelay = CurTime() + (self.Speed*2)/1000
	self.Vel = self.Dir
end

-- Think
function BULLET:Think(Index)
	-- Make it fly
	self.Speed = self.Speed - 0.5
	if (self.Speed < 3) then
		self.Exp = true
	end
	
	self.Pos = self.Pos + self.Vel * math.Clamp( self.Speed, 4, 70 ) / 2
	self.Vel = self.Vel - Vector(0,0,self.WeaponData.Gravity / self.WeaponData.Speed)
	
	//self.Entity:SetAngles( self.Dir:Angle() + Angle(90,0,0) )
	
	local hitsolid = bit.band(util.PointContents( self.Pos ), CONTENTS_SOLID) > 0
	if ((self.RemoveTimer and self.RemoveTimer < CurTime()) -- There's no way a bullet can fly for that long.
		or hitsolid) then -- It flew out of the map
		local trace = pewpew:Trace( self.Pos - self.Vel * self.Speed, self.Vel * self.Speed )
		pewpew:ExplodeBullet( Index, self, trace )
	else			
		if (CurTime() > self.TraceDelay) then
			local trace = pewpew:Trace( self.Pos - self.Vel * self.Speed, self.Vel * self.Speed )
			
			if (trace.Hit and !self.Exploded) or self.Exp then
				self.Exploded = true
				pewpew:ExplodeBullet( Index, self, trace )
			end
		end
	end
end

-- Client side overrides:

function BULLET:CLInitialize()
	self.emitter = ParticleEmitter( Vector(0,0,0) )
	self.delta = 15
	self.delay = CurTime() + 0.01
	self.Speed = self.WeaponData.Speed
	self.TraceDelay = CurTime() + (self.Speed*2)/1000
	self.Vel = self.Dir
	self.Prop:SetColor(Color(255,255,255,0))
	self.Prop:SetRenderMode(RENDERMODE_TRANSALPHA)
end

function BULLET:CLThink(Index)
	self.Speed = self.Speed - 0.5
	if (self.Speed < 3) then
		self.Exp=true
	end

	self.Pos = self.Pos + self.Vel * math.Clamp( self.Speed, 4, 70 ) / 2
	self.Vel = self.Vel - Vector(0,0,self.WeaponData.Gravity / self.WeaponData.Speed)
	
	if (CurTime() > self.delay) then
		local add = 2
		if (self.delta > 100) then add = 4 end
		self.delta = math.Clamp(self.delta + add,2,180)
		local Pos = self.Prop:GetPos()
		local particle = self.emitter:Add("particles/flamelet" .. math.random(1,5), Pos)
		if (particle) then
			particle:SetLifeTime(0)
			particle:SetDieTime(1)
			particle:SetStartAlpha(math.random( 200, 255 ) )
			particle:SetEndAlpha(0)
			particle:SetStartSize(self.delta)
			particle:SetEndSize(self.delta-10)
			--particle:SetRoll(math.random(-5, 5))
			particle:SetRollDelta(math.random(-5, 5))
			particle:SetColor(255, 255, 255) 
		end
		self.delay = CurTime() + math.Rand(0.01,0.04)
	end
	
	local hitsolid = bit.band(util.PointContents( self.Pos ), CONTENTS_SOLID) > 0
	local hitsolid2 = bit.band(util.PointContents( self.Pos + self.Vel * (pewpew.ServerTick or (1/66.667)) * (LagCompensation or 1) ), CONTENTS_SOLID) > 0
	
	if ((self.RemoveTimer and self.RemoveTimer < CurTime()) -- There's no way a bullet can fly for that long.
		or hitsolid -- It flew out of the map
		or hitsolid2) then -- It's going to fly out of the map in the next tick
		pewpew:RemoveBullet( Index )
	
	elseif (self.Prop and self.Prop:IsValid()) then
		self.Prop:SetPos( self.Pos )
		self.Prop:SetAngles( self.Vel:Angle() + Angle( 90,0,0 ))
		if (CurTime() > self.TraceDelay) then
			local trace = pewpew:Trace( self.Pos - self.Vel * self.Speed, self.Vel * self.Speed )
			
			if (trace.Hit and !self.Exploded) or self.Exp then
				self.Exploded = true
				pewpew:RemoveBullet( Index )
			end
		end
	end
end

pewpew:AddWeapon( BULLET )