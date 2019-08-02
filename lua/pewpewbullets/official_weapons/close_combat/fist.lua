-- Fist

local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Impact Driver"
BULLET.Author = "Divran"
BULLET.Description = "The damage of this weapon depends on its impact speed. Will not damage constrained entities."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = false

-- Damage
BULLET.DamageType = "PointDamage"
BULLET.PlayerDamage = 100
BULLET.PlayerDamageRadius = 50

-- Reloading/Ammo
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

BULLET.CustomInputs = {}
BULLET.CustomOutputs = {}

-- Custom Functions (Only for adv users)
-- (If you set the override var to true, the cannon/bullet will run these instead. Use these functions to do stuff which is not possible with the above variables)
-- I suggest you erase any functions you are not using to minimize file size.

-- Cannon Think (Is run on: Cannon)
function BULLET:CannonThink() end

function BULLET:Fire() end

function BULLET:CannonPhysicsCollide( Data, PhysObj )
	if (pewpew:GetConVar( "Firing" ) and pewpew:GetConVar( "Damage" )) then
		if (!self.LastHit) then self.LastHit = 0 end
		if (CurTime() > self.LastHit) then
			local Target = Data.HitEntity
			
			if (Target:IsWorld()) then return end
			if (!pewpew:CheckValid(Target)) then return end
			
			local Ent = self.Entity
			
			-- Check constrained entities
			if (constraint.HasConstraints( Target ) and constraint.HasConstraints( Ent )) then
				local const = constraint.GetAllConstrainedEntities( Target )
				if (table.Count(const)) then
					for k,v in pairs(const) do
						if (v == Ent) then return false end
					end
				end
			end
			
			local TargetVel = Data.TheirOldVelocity
			local SelfVel = Data.OurOldVelocity
			local Vel = (TargetVel - SelfVel):Length()
			
			local Damage = math.Clamp(Vel ^ 2 / 250,1,2500)

			pewpew:PointDamage( Target, Damage, self )
			
			self.LastHit = CurTime() + 0.25
		end
	end
end

pewpew:AddWeapon( BULLET )
