AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:DefaultInitialize()
	self.Entity:PhysicsInit( SOLID_VPHYSICS ) 	
	self.Entity:SetMoveType( MOVETYPE_NONE )
	self.Entity:SetSolid( SOLID_NONE )
	self.Entity:SetNWString("BulletName", self.Bullet.Name)
	self.FlightDirection = self.Entity:GetUp()
	self.Exploded = false
	local tk = pewpew.ServerTick or 66.7
	self.TraceDelay = CurTime() + (self.Bullet.Speed + (1/(self.Bullet.Speed*tk)) * 0) / (1/tk) * tk
	
	if (self.Bullet.Version >= 2) then
		local n = self.Bullet.Spread
		if (n and n != 0) then
			self.Vel = (self.FlightDirection * self.Bullet.Speed * math.Rand(1-n/100,1+n/100) * (1/tk)) * (tk/(1/66))
		else
			self.Vel = (self.FlightDirection * self.Bullet.Speed * (1/tk)) * (tk/(1/66))
		end
	end
	
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
	
	-- Color
	if (self.Bullet.Color) then
		local C = self.Bullet.Color
		self.Entity:SetColor( C.r, C.g, C.b, C.a or 255 )
	end
end

function ENT:Initialize()
	-- Spacebuild 3 is way too slow at this.
	if (self.Bullet.AffectedBySBGravity) then
		if (CAF and CAF.GetAddon("Spacebuild")) then
			CAF.GetAddon("Spacebuild").PerformEnvironmentCheckOnEnt(self.Entity)
			CAF.GetAddon("Spacebuild").OnEnvironmentChanged(self.Entity)
			self.Entity.environment:UpdateGravity(self.Entity)
			self.Entity.environment:UpdatePressure(self.Entity)
		end
	end
	
	if (self.Bullet.Initialize) then
		-- Allows you to override the Initialize function
		self.Bullet.Initialize( self )
	else
		self:DefaultInitialize()
	end
	self.Entity:NextThink( CurTime() )
end   

function ENT:SetOptions( BULLET, Cannon, ply )
	self.Bullet = table.Copy(BULLET)
	self.Cannon = Cannon
	self.Owner = ply
	self.Entity:SetNWString("BulletName", self.Bullet.Name)
	self:SetNWString( "PewPew_OwnerName", ply:Nick() )
end

function ENT:DefaultExplode( trace )
	-- Effects
	if (self.Bullet.ExplosionEffect) then
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetStart( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetNormal( trace.HitNormal )
		util.Effect( self.Bullet.ExplosionEffect, effectdata )
	end
	
	-- Sounds
	if (self.Bullet.ExplosionSound) then
		local soundpath = ""
		if (table.Count(self.Bullet.ExplosionSound) > 1) then
			soundpath = table.Random(self.Bullet.ExplosionSound)
		else
			soundpath = self.Bullet.ExplosionSound[1]
		end
		sound.Play( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
	end
		
	-- Damage
	local damagetype = self.Bullet.DamageType
	local damaged = false
	if (damagetype and type(damagetype) == "string") then
		if (damagetype == "BlastDamage") then
			if (trace.Entity and trace.Entity:IsValid()) then
				-- Stargate shield damage
				if (trace.Entity:GetClass() == "shield") then
					trace.Entity:Hit(nil,trace.HitPos,self.Bullet.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
					damaged = true
				else
					pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
				end
				pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, trace.Entity, self )
			else
				pewpew:BlastDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Damage, self.Bullet.RangeDamageMul, self )
			end
			
			-- Player Damage
			if (self.Bullet.PlayerDamageRadius and self.Bullet.PlayerDamage and pewpew:GetConVar( "Damage" )) then
				pewpew:PlayerBlastDamage( self.Entity, self.Entity, trace.HitPos + trace.HitNormal * 10, self.Bullet.PlayerDamageRadius, self.Bullet.PlayerDamage )
			end
		elseif (damagetype == "PointDamage") then
			pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
		elseif (damagetype == "SliceDamage") then
			pewpew:SliceDamage( trace.HitPos, self.FlightDirection, self.Bullet.Damage, self.Bullet.NumberOfSlices or 1, self.Bullet.SliceDistance or 50, self.Bullet.ReducedDamagePerSlice or 0, self )
		elseif (damagetype == "EMPDamage") then
			pewpew:EMPDamage( trace.HitPos, self.Bullet.Radius, self.Bullet.Duration, self )
		elseif (damagetype == "DefenseDamage") then
			pewpew:DefenseDamage( trace.Entity, self.Bullet.Damage )
		elseif (damagetype == "FireDamage") then
			pewpew:FireDamage( trace.Entity, self.Bullet.DPS, self.Bullet.Duration, self )
		end
	end
	
	-- Stargate shield damage
	if (trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "shield" and !damaged) then
		trace.Entity:Hit(self,trace.HitPos,self.Bullet.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
	end
	
	-- Remove the bullet
	self.Entity:Remove()
end

function ENT:Explode(trace)
	if (!trace) then
		trace = pewpew:Trace( self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed)
	end
	if (self.Bullet.Explode) then
		-- Allows you to override the Explode function
		self.Bullet.Explode( self, trace )
	else
		self:DefaultExplode( trace )
	end
end

function ENT:DefaultThink()

	if (self.Bullet.Version <= 1 or self.Bullet.UseOldSystem) then
		-- Make it fly
		self.Entity:SetPos( self.Entity:GetPos() + self.FlightDirection * self.Bullet.Speed )
		local grav = self.Bullet.Gravity or 0
		
		-- Make the bullet not fall down in space
		if (self.Bullet.AffectedByNoGrav) then
			if (CAF and CAF.GetAddon("Spacebuild")) then
				if (self.environment) then
					grav = grav * self.environment:GetGravity()
				end
			end
		end
	
	
		if (grav and grav != 0) then -- Only pull it down if needed
			self.FlightDirection = self.FlightDirection - Vector(0,0,grav / (self.Bullet.Speed or 1))
			if (self.Bullet.Version == 1) then self.FlightDirection:Normalize() end
		end
		
		self.Entity:SetAngles( self.FlightDirection:Angle() + Angle(90,0,0) )
	else	
		local grav = 600
		local tk = pewpew.ServerTick or (1/66.667)
		if (self.Bullet.Gravity != nil) then grav = self.Bullet.Gravity end
		-- TODO: Spacebuild gravity
		if (grav and grav > 0) then
			self.Vel = self.Vel - Vector(0,0,grav) * tk
		end
		self.Pos = self.Pos + self.Vel * tk
		
		self:SetPos( self.Pos )
		self:SetAngles( self.Vel:Angle() + Angle(90,0,0) + (self.Bullet.AngleOffset or Angle(0,0,0)) )
	end
		

	
	-- Lifetime
	if (self.Lifetime) then
		if (CurTime() > self.Lifetime) then
			if (self.Bullet.ExplodeAfterDeath and not self.Exploded) then
				self.Exploded = true
				local trace = pewpew:Trace( self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed, self )
				self:Explode( trace )
			else
				self.Entity:Remove()
			end
		end
	end
	
	if (CurTime() > self.TraceDelay) then
		local trace = pewpew:Trace( self:GetPos() - self.FlightDirection * self.Bullet.Speed, self.FlightDirection * self.Bullet.Speed, self )

		if (!trace) then error("[PewPew] Invalid trace") return end
			
		if (trace.Hit and !self.Exploded) then	
			self.Exploded = true
			self:Explode( trace )
		else			
			-- Run more often!
			self.Entity:NextThink( CurTime() )
			return true
		end
	else			
		-- Run more often!
		self.Entity:NextThink( CurTime() )
		return true
	end
end

function ENT:Think()
	if (self.Bullet.Think) then
		-- Allows you to override the think function
		return self.Bullet.Think( self )
	else
		return self:DefaultThink()
	end
end

function ENT:PhysicsCollide(CollisionData, PhysObj)
	if (self.Bullet.PhysicsCollide) then
		self.Bullet.PhysicsCollide(self, CollisionData, PhysObj)
	end
end