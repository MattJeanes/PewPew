-- pewpew_gcombatcompatibility
-- These functions take care of GCombat compatibility
------------------------------------------------------------------------------------------------------------
COMBATDAMAGEENGINE = 1
gcombat = {}

------------------------------------------------------------------------------------------------------------
-- Blast Damage GCombat compatibility

function gcombat.hcgexplode( position, radius, damage, pierce)
	pewpew:BlastDamage( position, radius, damage, 0.6 )
end
cbt_hcgexplode = gcombat.hcgexplode

function gcombat.nrgexplode( position, radius, damage, pierce)
	pewpew:BlastDamage( position, radius, damage, 0.6 )
end
cbt_nrgexplode = gcombat.nrgexplode

------------------------------------------------------------------------------------------------------------
-- Point Damage GCombat compatibility

function gcombat.devhit( entity, damage, pierce )
	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end

	pewpew:PointDamage( entity, damage )
	
	-- did it die?
	if (!entity:IsValid()) then
		attack = 2
	end
	
	return attack
end
cbt_dealdevhit = gcombat.devhit

function gcombat.hcghit( entity, damage, pierce, src, dest)
	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end
	
	pewpew:PointDamage( entity, damage )
	
	-- did it die?
	if (!entity:IsValid()) then
		attack = 2
	end
	
	-- fix for Gau-8
	if (type(src) != "Vector") then src = entity:GetPos() end
	if (type(dest) != "Vector") then dest = entity:GetPos() + Vector(0,0,1) end
	
	if (attack == 2) then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "Explosion", effectdata1 )
	elseif attack == 1 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "HelicopterMegaBomb", effectdata1 )
	elseif attack == 0 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "RPGShotDown", effectdata1 )
	end
	return attack
end
cbt_dealhcghit = gcombat.hcghit

function gcombat.nrghit( entity, damage, pierce, src, dest)

	-- default to fail
	local attack = 0
	
	-- success?
	if (pewpew:CheckValid( entity )) then attack = 1 end
	
	pewpew:PointDamage( entity, damage )
	
	-- died?
	if (!entity:IsValid()) then
		attack = 2
	end
	
	-- effects
	if (attack == 2) then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		effectdata1:SetScale( 10 )
		effectdata1:SetRadius( 100 )
		util.Effect( "cball_bounce", effectdata1 )
	elseif attack == 1 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		util.Effect( "ener_succeed", effectdata1 )
	elseif attack == 0 then
		local effectdata1 = EffectData()
		effectdata1:SetOrigin(src)
		effectdata1:SetStart(dest)
		util.Effect( "ener_fail", effectdata1 )
	end
	return attack
end
cbt_dealnrghit = gcombat.nrghit

------------------------------------------------------------------------------------------------------------
-- Useless heat functions ...
function gcombat.applyheat(ent, temp) end
cbt_applyheat = gcombat.applyheat

function gcombat.emitheat( position, radius, temp, own) end
cbt_emitheat = gcombat.emitheat

------------------------------------------------------------------------------------------------------------
-- The GCombat Death ray didn't like it when these didn't exist:
local gcbt_p_ent = {}
propent = {}

function propent.new( maxents, maxtime )
	local TD = {}
	TD.dietime = CurTime() + maxtime
	TD.maxents = maxents
	TD.entl0 = 0
	local ind = #gcbt_p_ent + 1
	gcbt_p_ent[ind] = TD
	return ind
end

function propent.think( id )
	return (gcbt_p_ent[id].dietime > CurTime())
end

function propent.addme( id )
	gcbt_p_ent[id].entl0 = gcbt_p_ent[id].entl0 + 1
end

function propent.delme( id )
	gcbt_p_ent[id].entl0 = gcbt_p_ent[id].entl0 - 1
end

function propent.canmakemore( id )
	return (gcbt_p_ent[id].entl0 < gcbt_p_ent[id].maxents)
end

------------------------------------------------------------------------------------------------------------
-- Other
function gcombat.registerent( ent, health, armor ) end
function gcombat.validate( ent ) return pewpew:CheckValid( ent ) end

