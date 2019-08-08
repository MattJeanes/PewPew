-- Railgun

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "V10LTR Railcannon"
BULLET.Author = "Hexwolf (Base by Divran)"
BULLET.Description = "Fires extremely fast moving rounds with deadly accuracy. Slices through armor like a hot knife through butter. Requires a short charge up before firing."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Appearance
BULLET.Model = "models/combatmodels/tankshell_120mm.mdl"
BULLET.Trail = { StartSize = 10,
				 EndSize = 2,
				 Length = 5,
				 Texture = "trails/smoke.vmt",
				 Color = Color( 255, 255, 255, 255 ) }

-- Effects / Sounds
BULLET.FireSound = {"arty/railgun.wav"}
BULLET.ExplosionEffect = "HEATsplode"

-- Movement
BULLET.Speed = 1000
--BULLET.Gravity = 0.02
BULLET.RecoilForce = 100
BULLET.Spread = 0
BULLET.AffectedBySBGravity = true

-- Damage
BULLET.DamageType = "SliceDamage"
BULLET.Damage = 1000
BULLET.NumberOfSlices = 10
BULLET.SliceDistance = 5000
BULLET.ReducedDamagePerSlice = 0

-- Reload/Ammo
BULLET.Reloadtime = 0.08
BULLET.Ammo = 1
BULLET.AmmoReloadtime = 6

-- Other
BULLET.EnergyPerShot = 80

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
	elseif (name == "Reload") then
		if (self.Ammo and self.Ammo > 0 and self.Ammo < self.Bullet.Ammo) then
			if (self.Bullet.Ammo and self.Bullet.Ammo > 0 and self.Bullet.AmmoReloadtime and self.Bullet.AmmoReloadtime > 0) then
				if (value != 0) then
					if (self.Ammo and self.Ammo > 0) then
						self.Ammo = 0
						self.LastFired = CurTime() + self.Bullet.Reloadtime
						self.CanFire = false
						if WireLib then
							WireLib.TriggerOutput( self.Entity, "Can Fire", 0)
							WireLib.TriggerOutput( self.Entity, "Ammo", 0 )
						end
					end
				end
			end
		end
	end
end

-- Cannon Think (Is run on: Cannon)
function BULLET:CannonThink()
	if (!self.ChargeSound) then self.ChargeSound = CreateSound( self.Entity, "ambient/machines/spin_loop.wav" ) end
	if (!self.ChargeUpTime) then self.ChargeUpTime = 0 end
	if (CurTime() - self.LastFired > self.Bullet.Reloadtime and self.CanFire == false) then -- if you can fire
		if (self.Ammo <= 0 and self.Bullet.Ammo > 0) then -- check for ammo
			-- if we don't have any ammo left...
			if (self.Firing) then -- if you are holding down fire
				-- Sound
				if (self.Bullet.EmptyMagSound and self.SoundTimer and CurTime() > self.SoundTimer) then
					self.SoundTimer = CurTime() + self.Bullet.Reloadtime
					local soundpath = ""
					if (table.Count(self.Bullet.EmptyMagSound) > 1) then
						soundpath = table.Random(self.Bullet.EmptyMagSound)
					else
						soundpath = self.Bullet.EmptyMagSound[1]
					end
					self:EmitSound( soundpath )
				end			
			end
			self.CanFire = false
			if WireLib then WireLib.TriggerOutput( self.Entity, "Can Fire", 0) end
			if (CurTime() - self.LastFired > self.Bullet.AmmoReloadtime) then -- check ammo reloadtime
				self.Ammo = self.Bullet.Ammo
				if WireLib then WireLib.TriggerOutput( self.Entity, "Ammo", self.Ammo ) end
				self.CanFire = true
				if (self.Firing) then 
					self.LastFired = CurTime()
					self.CanFire = false
				elseif WireLib then
					WireLib.TriggerOutput( self.Entity, "Can Fire", 1)
				end
			end
		else
			-- if we DO have ammo left
			self.CanFire = true
			if (self.Firing) then
				self.LastFired = CurTime()
				self.CanFire = false
				if (self.ChargeUpTime >= 145) then
					self:FireBullet()
				else
					self.ChargeUpTime = self.ChargeUpTime + 5
				end
				if (!self.ChargeSound:IsPlaying()) then
					self.ChargeSound:Play()
				end
				self.ChargeSound:ChangePitch(math.max(self.ChargeUpTime,1),0)
			elseif WireLib then
				WireLib.TriggerOutput( self.Entity, "Can Fire", 1 )
			end
		end
	end
	if (!self.Firing or self.Ammo == 0) then
		if (self.ChargeUpTime > 0) then 
			self.ChargeUpTime = self.ChargeUpTime - 2
			self.ChargeSound:ChangePitch(math.max(self.ChargeUpTime,1),0)
		else 
			self.ChargeSound:Stop() 
		end
	end
	if (self.Bullet.Reloadtime and self.Bullet.Reloadtime < 0.5) then
		-- Run more often!
		self.Entity:NextThink( CurTime() )
		return true
	end
end

function BULLET:OnRemove()
	if (self.ChargeSound:IsPlaying()) then self.ChargeSound:Stop() end
end

pewpew:AddWeapon( BULLET )