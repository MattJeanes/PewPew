util.AddNetworkString("PewPew_Option_Tool_SendLog")
pewpew.DamageLog = {}

function pewpew:AddDamageLog( TargetEntity, Damage, DamageDealer )
	local Time = os.date( "%c", os.time() )
	
	local DealerName = "-Unknown-"
	local Weapon = "-Unknown-"
	if (DamageDealer) then
		if (type(DamageDealer) == "Player") then
			DealerName = DamageDealer:Nick() or "-Error-"
		elseif type(DamageDealer)=="number" then
			DealerName="-Error-"
		elseif ((DamageDealer:GetClass() == "pewpew_base_cannon" or DamageDealer:GetClass() == "pewpew_base_bullet") and DamageDealer.Owner and DamageDealer.Owner:IsValid()) then
			DealerName = DamageDealer.Owner:Nick() or "-Error-"
			if (DamageDealer.Bullet) then
				Weapon = DamageDealer.Bullet.Name
			end
		end
	end
	
	local VicOwner = "-Unknown-"
	if (CPPI and TargetEntity:CPPIGetOwner()) then
		VicOwner = TargetEntity:CPPIGetOwner():Nick() or "-Error-"
	end
	
	local Died = false
	if (not IsValid(TargetEntity) or self:GetHealth( TargetEntity ) < Damage) then
		Died = true
	end
	
	if (#self.DamageLog > 0) then
		if (self.DamageLog[1] and self.DamageLog[1][4] and self.DamageLog[1][4] == TargetEntity) then
			self.DamageLog[1][1] = Time
			self.DamageLog[1][6] = self.DamageLog[1][6] + Damage
			self.DamageLog[1][5] = Weapon
			self.DamageLog[1][2] = DealerName
			self.DamageLog[1][7] = Died
		else
			table.insert( self.DamageLog, 1, { Time, DealerName, VicOwner, TargetEntity, Weapon, Damage, Died } )
		end
	else
		table.insert( self.DamageLog, 1, { Time, DealerName, VicOwner, TargetEntity, Weapon, Damage, Died } )
	end
end
hook.Add("PewPew_Damage","PewPew_DamageLog",pewpew.AddDamageLog)


function pewpew:PopDamageLogStack()
	if (!pewpew:GetConVar( "DamageLogSending" )) then return end
	if (#self.DamageLog > 0) then
		net.Start("PewPew_Option_Tool_SendLog")
			net.WriteTable( self.DamageLog )
		net.Broadcast()
		self.DamageLog = {}
	end
end

timer.Create( "PewPew_DamageLog_PopStack", 5, 0, function()
	pewpew:PopDamageLogStack()
end)
