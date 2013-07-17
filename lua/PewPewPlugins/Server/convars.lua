-- Pewpew ConVars
-- These functions manage convars
------------------------------------------------------------------------------------------------------------

util.AddNetworkString("PewPew-SetOptions")

net.Receive("PewPew-SetOptions", function()
	RunConsoleCommand("pewpew_damage",net.ReadString())
	RunConsoleCommand("pewpew_firing",net.ReadString())
	RunConsoleCommand("pewpew_numpads",net.ReadString())
	RunConsoleCommand("pewpew_energyusage",net.ReadString())
	RunConsoleCommand("pewpew_coredamageonly",net.ReadString())
	RunConsoleCommand("pewpew_damagemul",net.ReadString())
	RunConsoleCommand("pewpew_coredamagemul",net.ReadString())
	RunConsoleCommand("pewpew_repairtoolheal",net.ReadString())
	RunConsoleCommand("pewpew_repairtoolhealcores",net.ReadString())
	RunConsoleCommand("pewpew_damagelogsending",net.ReadString())
	RunConsoleCommand("PewPew_PropProtDamage",net.ReadString())
	RunConsoleCommand("PewPew_WeaponDesigner",net.ReadString())
end)

pewpew.ConVars = {}

function pewpew:CreateConVar( ConVar, Type, Value, Callback )
	if (type(Value) == "boolean") then
		if (Value == true) then Value = "1" else Value = "0" end
	elseif (type(Value) != "string") then
		Value = tostring(Value)
	end
	self.ConVars[ConVar] = {}
	self.ConVars[ConVar].Var = CreateConVar( "PewPew_"..ConVar,Value,{FCVAR_ARCHIVE,FCVAR_SERVER_CAN_EXECUTE})
	self.ConVars[ConVar].Type = Type
	
	cvars.AddChangeCallback( "PewPew_"..ConVar, function( CVar, PreviousValue, NewValue )
		if (Callback) then
			Callback( Cvar, PreviousValue, NewValue )
		end
		for _,v in ipairs( player.GetAll() ) do
			v:ChatPrint("[PewPew] '" .. ConVar .. "' changed from " .. PreviousValue .. " to " .. NewValue .. ".")
		end
	end)
end

function pewpew:GetConVar( ConVar )
	local t = self.ConVars[ConVar]
	local ret = false
	if (t and t.Var) then
		local Type = t.Type
		if (Type) then
			if (Type == "bool") then
				ret = t.Var:GetBool()
			elseif (Type == "int") then
				ret = t.Var:GetInt()
			elseif (Type == "float") then
				ret = t.Var:GetFloat()
			end
		end
	end
	return ret
end

pewpew:CreateConVar( "Damage", "bool", true )
pewpew:CreateConVar( "Firing", "bool", true )
pewpew:CreateConVar( "Numpads", "bool", true )
pewpew:CreateConVar( "DamageMul", "float", 1 )
pewpew:CreateConVar( "RepairToolHeal", "float", 75 )
pewpew:CreateConVar( "EnergyUsage", "bool", ((CAF and CAF.GetAddon("Life Support") and CAF.GetAddon("Resource Distribution")) == true), function( CVar, From, To ) 
	if (!CAF) then
		To = tostring(To)
		if (To != "0") then
			timer.Simple( 0.1, function()
				RunConsoleCommand( "PewPew_EnergyUsage","0" )
				for _,v in ipairs( player.GetAll() ) do
					v:ChatPrint("[PewPew] You cannot enable energy usage when SB3 is not installed.")
				end
			end)
		end
	end
end )
pewpew:CreateConVar( "WeaponDesigner", "bool", false )
pewpew:CreateConVar( "AlwaysUseOldSystem", "bool", false )
pewpew:CreateConVar( "DamageLogSending", "bool", true )