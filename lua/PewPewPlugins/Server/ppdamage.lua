
pewpew:CreateConVar( "PropProtDamage", "bool", false )

-- If Prop Protection Damage is on, only deal damage if the owner of the damaged entity has the owner of the weapon in their PP friends list
function pewpew:PropProtDamage( TargetEntity, Damage, DamageDealer )
	if (!CPPI) then return end
	if (self:GetConVar("PropProtDamage")) then
		local TargetEntityOwner = TargetEntity:CPPIGetOwner()
		local Friends = TargetEntityOwner:CPPIGetFriends()
		local WeaponOwner
		if (type(DamageDealer) == "Player") then 
			WeaponOwner = DamageDealer
		elseif (type(DamageDealer) == "Entity" and (DamageDealer:GetClass() == "pewpew_base_cannon" or DamageDealer:GetClass() == "pewpew_base_bullet")) then 
			WeaponOwner = DamageDealer.Owner 
		end
		if (!TargetEntityOwner or !Friends or !WeaponOwner) then return end
		local Found = false
		if (TargetEntityOwner == WeaponOwner) then 
			Found = true
		else
			for k,v in pairs( Friends ) do
				if (v == WeaponOwner) then
					Found = true
					break
				end
			end
		end
		if (!Found) then print("PP DAMAGE FALSE") return false end
	end
end
hook.Add("PewPew_ShouldDamage","PewPew_PropProtectionDamage",pewpew.PropProtDamage)