------------------------------------------------------------------------------------------------------------
-- Core

pewpew:CreateConVar( "CoreDamageMul", "float", 1 )
pewpew:CreateConVar( "CoreDamageOnly", "bool", false )
pewpew:CreateConVar( "RepairToolHealCores", "float", 200 )

pewpew.tempdmg = 0

function pewpew:CheckForCore( TargetEntity, Damage, DamageDealer )
	if (TargetEntity:IsValid()) then --self:CheckValid( TargetEntity )) then
		if (TargetEntity:GetClass() == "pewpew_core") then -- If the entity is a core
			self:DamageCore( TargetEntity, Damage ) -- Deal damage to core
			return false -- Prevent damage to the core
		elseif (TargetEntity.pewpew and self:CheckValid( TargetEntity.pewpew.Core )) then -- If the entity is connected to a core
			self:DamageCore( TargetEntity.pewpew.Core, Damage ) -- Deal damage to core
			return false -- Prevent damage to the original target
		end
	end
	if (self:GetConVar("CoreDamageOnly")) then return false end
end
hook.Add("PewPew_ShouldDamage", "PewPew_CheckForCore", pewpew.CheckForCore )

-- Dealing damage to cores
function pewpew:DamageCore( ent, Damage )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent:GetClass() != "pewpew_core") then return end
	ent.pewpew.CoreHealth = ent.pewpew.CoreHealth - math.abs(Damage) * self:GetConVar("CoreDamageMul")
	ent:SetNWInt("pewpewHealth",ent.pewpew.CoreHealth)
	-- Wire Output
	if WireLib then
		WireLib.TriggerOutput( ent, "Health", ent.pewpew.CoreHealth or 0 )
	end
	self:CheckIfDeadCore( ent )
	pewpew.tempdmg = pewpew.tempdmg + 1
end

-- Repairs the entity by the set amount
function pewpew:RepairCoreHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent:GetClass() != "pewpew_core") then return end
	if (!ent.pewpew.CoreHealth or !ent.pewpew.CoreMaxHealth or ent.pewpew.CoreHealth == ent.pewpew.CoreMaxHealth) then return end
	if (!amount or amount == 0) then return end
	-- Add health
	ent.pewpew.CoreHealth = math.Clamp(ent.pewpew.CoreHealth+math.abs(amount),0,ent.pewpew.CoreMaxHealth)
	ent:SetNWInt("pewpewHealth",ent.pewpew.CoreHealth or 0)
		-- Wire Output
	WireLib.TriggerOutput( ent, "Health", ent.pewpew.CoreHealth or 0 )
end

function pewpew:CheckIfDeadCore( ent )
	if (!ent.pewpew) then ent.pewpew = {} return end
	if (ent.pewpew.CoreHealth <= 0) then
		ent:RemoveAllProps()
	end	
end