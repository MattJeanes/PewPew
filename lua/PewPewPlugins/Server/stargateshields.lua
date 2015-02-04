--[[ Disabled due to conflicts. TODO: Fix properly
pewpew:CreateConVar("StargateShield_DamageMul","float",0.25)

local function check( ent, dlr )
	if not IsValid(ent) then return false end
	local shields = ents.FindByClass("shield")
	for k,v in pairs( shields ) do
		if ((not v:GetNWBool("depleted", false)) and (not v:GetNWBool("containment",false))) then
			local size = v:GetNWInt("size") + 100
			if (ent:GetPos():Distance( v:GetPos() ) < size) then
				return false
			end
		end
	end
end

local function checkblast( pos, size, damage )
	local shields = ents.FindByClass("shield")
	for k,v in pairs( shields ) do
		if ((not v:GetNWBool("depleted", false)) and (not v:GetNWBool("containment",false))) then
			local size2 = v:GetNWInt("size",0) + 100
			local dir = (pos-v:GetPos())
			if (size + size2 < dir:Length()) then
				dir:Normalize()
				local pos2 = v:GetPos() + dir * size
				if v.Hit then v:Hit(nil,pos2,damage*pewpew:GetConVar("StargateShield_DamageMul"),dir) end
			end
		end
	end
end

-- Block damage from being dealt if the damaged prop is inside a shield
function pewpew:BlockBlastDamage( TargetEntity,Position, Radius, Damage, a, b, DamageDealer )
	checkblast( Position, Radius, Damage )
	return check(TargetEntity,DamageDealer)
end
hook.Add("PewPew_ShouldDoBlastDamage","PewPew_StargeShield_BlastDamage",pewpew.BlockBlastDamage)

-- Block emp damage from being dealt if the damaged prop is inside a shield
function pewpew:BlockEMPDamage( ent,a,b,c )
	return check(ent)
end
hook.Add("PewPew_ShouldDoEMPDamage","PewPew_StargateShield_EMPDamage",pewpew.BlockEMPDamage)

-- Block point damage from being dealt if the damaged prop is inside a shield
function pewpew:BlockPointDamage( TargetEntity,a,DamageDealer )
	return check(TargetEntity,DamageDealer)
end
hook.Add("PewPew_ShouldDoPointDamage","PewPew_StargateShield_PointDamage",pewpew.BlockPointDamage)

-- Block Fire damage from being dealt if the damaged prop is inside a shield
function pewpew:BlockFireDamage( TargetEntity,a,b,c )
	return check(TargetEntity)
end
hook.Add( "PewPew_ShouldDoFireDamage","PewPew_StargateShield_FireDamage",pewpew.BlockFireDamage)

-- Block ANY damage from beind dealt if the damaged prop is inside a shield
function pewpew:BlockDamage( TargetEntity )
	return check(TargetEntity)
end
hook.Add("PewPew_ShouldDamage","PewPew_StargateShield_BaseDamage",pewpew.BlockDamage)
]]--
