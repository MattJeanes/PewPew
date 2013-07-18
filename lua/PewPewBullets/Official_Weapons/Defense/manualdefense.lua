-- Manual Defense

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Manual Defense"
BULLET.Author = "Divran"
BULLET.Description = "This defense will kill the target PewPew bullet if it is in range. Has 3000 range."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Effects / Sounds
BULLET.FireSound = {"col32/gun4.wav"}
BULLET.FireEffect = "pewpew_defensebeam"

-- Damage
BULLET.DamageType = "DefenseDamage"
BULLET.Damage = 100

-- Reloading/Ammo
BULLET.Reloadtime = 0.25
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.ExplodeAfterDeath = false
BULLET.EnergyPerShot = 5000

BULLET.Gravity = 0

BULLET.CustomInputs = { "Fire", "Target [ENTITY]" }

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)

-- Wire Input (This is called whenever a wire input is changed)
function BULLET:WireInput( inputname, value )
	if (inputname == "Target") then
		if (value and value:IsValid() and value:GetClass() == "pewpew_base_bullet") then
			self.Target = value
		end
	else
		self:InputChange( inputname, value )
	end
end

-- Fire (Is called before the cannon is about to fire)
function BULLET:Fire()
	local Distance = 3500
	if (self.Target) then
		Distance = self.Target:GetPos():Distance(self.Entity:GetPos())
	end
	if (Distance < 3000) then
		local tr = {}
		tr.start = self.Entity:GetPos()
		tr.endpos = self.Target:GetPos()
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
			pewpew:DefenseDamage( self.Target, self.Bullet.Damage )
					
			-- Sound
			self:EmitSound( self.Bullet.FireSound[1] )
			
			-- Effect
			local effectdata = EffectData()
			effectdata:SetOrigin( self.Target:GetPos() )
			effectdata:SetStart( self.Entity:GetPos() )
			util.Effect( self.Bullet.FireEffect, effectdata )
		end
	end
end

pewpew:AddWeapon( BULLET )