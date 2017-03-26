local function JoinCmds( ply )
	-- 1/0
	local val = "0"
	if (pewpew:GetConVar( "Damage" )) then val = "1" end
	ply:ConCommand( "pewpew_options_damage " .. val )
	local val = "0"
	if (pewpew:GetConVar( "Firing" )) then val = "1" end
	ply:ConCommand( "pewpew_options_firing " .. val )
	local val = "0"
	if (pewpew:GetConVar( "Numpads" )) then val = "1" end
	ply:ConCommand( "pewpew_options_numpads " .. val )
	local val = "0"
	if (pewpew:GetConVar( "EnergyUsage" )) then val = "1" end
	ply:ConCommand( "pewpew_options_energyusage " .. val )
	local val = "0"
	if (pewpew:GetConVar( "CoreDamageOnly" )) then val = "1" end
	ply:ConCommand( "pewpew_options_coredamage_only " .. val )
	local val = "0"
	if (pewpew.DamageLogSend) then val = "1" end
	ply:ConCommand( "pewpew_options_damagelog_sending " .. val )
	local val = "0"
	if (pewpew:GetConVar( "PropProtDamage" )) then val = "1" end
	ply:ConCommand( "pewpew_options_ppdamage " .. val )
	local val = "0"
	if (pewpew:GetConVar( "WeaponDesigner" )) then val = "1" end
	ply:ConCommand( "pewpew_options_wpn_designer" .. val )
	
	-- Vars
	ply:ConCommand( "pewpew_options_damagemul " .. pewpew:GetConVar( "DamageMul" ) )
	ply:ConCommand( "pewpew_options_coredamagemul " .. pewpew:GetConVar( "CoreDamageMul" ) )
	ply:ConCommand( "pewpew_options_repairrate " .. pewpew:GetConVar( "RepairToolHeal" ) )
	ply:ConCommand( "pewpew_options_repairrate_cores " .. pewpew:GetConVar( "RepairToolHealCores" ) )
end
hook.Add("PlayerInitialSpawn","PewPew_Convars_at_spawn",JoinCmds)