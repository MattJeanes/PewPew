-- Basic Laser

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Particle Beam"
BULLET.Author = "Zio_Matrix"
BULLET.Description = "Fires a very powerful constant particle beam. Overheats with extended use."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Movement
BULLET.Spread = 0.4

-- Effects / Sounds
BULLET.ExplosionEffect = "pewpew_particlebeam"
BULLET.OverheatSound = {"ambient/machines/thumper_shutdown1.wav"}


-- Damage
BULLET.DamageType = "PointDamage"
BULLET.Damage = 60

-- Reloading/Ammo
BULLET.Reloadtime = 0.05
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0
BULLET.EnergyPerShot = 150

function BULLET:Initialize()   
  self.Overheated = false
end

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Dir, startpos = pewpew:GetFireDirection( self.Direction, self )
	
	local num = self.Bullet.Spread
	if (num) then
		local spread = Angle(math.Rand(-num,num),math.Rand(-num,num),0)
		Dir:Rotate(spread)
	end
	
	-- Deal damage
	local trace = pewpew:Trace( startpos, Dir * 100000 )

	if (trace and trace.Hit and trace.Entity and trace.Entity:IsValid()) then
		pewpew:PointDamage( trace.Entity, self.Bullet.Damage, self )
	end
	
	local effectdata = EffectData()
	effectdata:SetOrigin( trace.HitPos or ( startpos + self.Entity:GetUp() * 100000 )  )
	effectdata:SetStart( startpos )
	effectdata:SetEntity( self.Entity )
	util.Effect( self.Bullet.ExplosionEffect, effectdata )
end

-- Wire Input (This is called whenever a wire input is changed) (Is run on: Cannon)
function BULLET:WireInput( name, value )
	if (name == "Fire") then
		if (value != 0) then
			self.Firing = true
		else
			self.Firing = false
		end
		if (value != 0 and self.CanFire == true) then
			self.LastFired = CurTime()
			self.CanFire = false
			if WireLib then WireLib.TriggerOutput(self.Entity, "Can Fire", 0) end
		end
	end
end

-- Cannon Think (Is run on: Cannon)
function BULLET:CannonThink()
	if (!self.ChargeSound) then self.ChargeSound = CreateSound( self.Entity, "/ambient/alarms/combine_bank_alarm_loop4.wav" ) end
	if (!self.FireNoise) then self.FireNoise = CreateSound( self.Entity, "ambient/energy/force_field_loop1.wav" ) end
	if (!self.OverheatLevel) then self.OverheatLevel = 0 end
	if (!self.OverheatLevelAlarm) then self.OverheatLevelAlarm = 0 end
	self.ChargeSound:ChangePitch(math.max(self.OverheatLevelAlarm,1),0)
	self.FireNoise:ChangePitch(math.max(80,1),0)
	
	if (self.Firing and not self.Overheated) then
		self:FireBullet()
		self.OverheatLevel = self.OverheatLevel + 1
		if (!self.ChargeSound:IsPlaying()) then
			self.ChargeSound:Play()
		end
		if (!self.FireNoise:IsPlaying()) then
			self.FireNoise:Play()
		end
	elseif (!self.Firing and not self.Overheated) then
		self.OverheatLevel = self.OverheatLevel - 3
		self.FireNoise:Stop()
	end
	
	if (self.OverheatLevel < 150) then
		self.OverheatLevelAlarm = 0
	else
		self.OverheatLevelAlarm = 200
	end
	
	if (self.OverheatLevel >= 200) then
		self.Overheated = true
		self.FireNoise:Stop()
		self:EmitSound( self.Bullet.OverheatSound[1] )
	end
	
	if (self.Overheated) then
		self.OverheatLevel = self.OverheatLevel - 2
	end
	
	if (self.OverheatLevel <= 0) then
		self.Overheated = false
		self.OverheatLevel = 0
	end
	
	if (self.Bullet.Reloadtime and self.Bullet.Reloadtime < 0.5) then
		-- Run more often!
		self.Entity:NextThink( CurTime() + self.Bullet.Reloadtime )
		return true
	end
end

function BULLET:OnRemove()
	if (self.ChargeSound:IsPlaying()) then self.ChargeSound:Stop() end
end

pewpew:AddWeapon( BULLET )
