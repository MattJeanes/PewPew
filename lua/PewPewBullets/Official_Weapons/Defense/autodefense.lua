-- Automatic Defense

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Automatic Defense"
BULLET.Author = "Divran"
BULLET.Description = "This defense will automatically aquire targets in front of it. Has 2500 range."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"col32/gun4.wav"}
BULLET.FireEffect = "pewpew_defensebeam"

-- Damage
BULLET.DamageType = "DefenseDamage"
BULLET.Damage = 50

-- Reloading/Ammo
BULLET.Reloadtime = 0.15
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 2000

BULLET.Gravity = 0

BULLET.CustomInputs = { "Fire" }
BULLET.CustomOutputs = { }

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	-- Find all entities
	local entities = pewpew:FindInCone( self.Entity:GetPos(), self.Entity:GetUp(), 2500, 75 )
	
	-- Loop through all entities to find the closest one
	local TargetEnt = nil
	local Dist = 4000
	for _, v in pairs( entities ) do
		if (v:GetClass() == "pewpew_base_bullet") then
			local Dist2 = v:GetPos():Distance(self:GetPos())
			if (Dist > Dist2 and v.Owner != self.Owner) then
				Dist = Dist2
				TargetEnt = v
			end
		end
	end
	

	if (TargetEnt and TargetEnt:IsValid()) then
		local tr = {}
		tr.start = self.Entity:GetPos()
		tr.endpos = TargetEnt:GetPos()
		tr.filter = self.Entity
		local trace = util.TraceLine( tr )
		if (trace.Hit) then
			if (trace.Entity and pewpew:CheckValid(trace.Entity)) then
				-- Damage
				pewpew:PointDamage( trace.Entity, self.Bullet.Damage / 3, self.Entity )
				-- Sound
				self:EmitSound( self.Bullet.FireSound[1] )
				
				-- Effect
				local effectdata = EffectData()
				effectdata:SetOrigin( trace.HitPos )
				effectdata:SetStart( self.Entity:GetPos() )
				util.Effect( self.Bullet.FireEffect, effectdata )
			end
		else
			-- Damage
			pewpew:DefenseDamage( TargetEnt, self.Bullet.Damage )
					
			-- Sound
			self:EmitSound( self.Bullet.FireSound[1] )
			
			-- Effect
			local effectdata = EffectData()
			effectdata:SetOrigin( TargetEnt:GetPos() )
			effectdata:SetStart( self.Entity:GetPos() )
			util.Effect( self.Bullet.FireEffect, effectdata )
		end
	end
end

pewpew:AddWeapon( BULLET )