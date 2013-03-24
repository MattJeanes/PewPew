-- PewPew Damage Control
-- These functions take care of damage.
------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------
-- Whitelist/Blacklist

-- Entities in the Never Ever list will NEVER EVER take damage by PewPew weaponry.
pewpew.NeverEverList = { "pewpew_base_bullet", "gmod_ghost", "shield", "trigger", "func", "event_horizon" }
-- Entity types in the blacklist will deal their damage to the first non-blacklisted entity they are constrained to. If they are not constrained to one, they take the damage themselves
pewpew.DamageBlacklist = { "gmod_wire" }
-- Entity types in the whitelist will ALWAYS be harmed by PewPew weaponry, even if they are in the blacklist as well.
pewpew.DamageWhitelist = { "gmod_wire_turret", "gmod_wire_forcer", "gmod_wire_grabber" }

------------------------------------------------------------------------------------------------------------
-- Hook calling:
function pewpew:CallHookBool( HookName, ... )
	local ret = {hook.Call(HookName,nil,self,...)}
	if (ret and table.Count(ret) >0) then
		for k,v in pairs( ret ) do
			if (v == false) then
				return false
			end
		end
	end
	return true
end

function pewpew:CallHookNum( HookName, ... )
	local ret = {hook.Call(HookName,nil,self,...)}
	if (ret and table.Count(ret) >0) then
		for k,v in pairs( ret ) do
			if (type(v) == "number") then return v end
		end
	end
	return nil
end

------------------------------------------------------------------------------------------------------------
-- Damage Types:

-- Blast Damage (A normal explosion)  (The damage formula is " (1-(Distance/Radius)^RangeDamageMul))")
function pewpew:BlastDamage( Position, Radius, Damage, RangeDamageMul, IgnoreEnt, DamageDealer )
		if (!self:GetConVar( "Damage" )) then return end
	if (!Radius or Radius <= 0) then return end
	if (!Damage or Damage <= 0) then return end
	local targets = ents.FindInSphere( Position, Radius )
	if (!targets or #targets == 0) then return end
	local DamagedProps = {}
	
	-- Maybe an addon thinks there is no use to even start the loop?
	if (self:CallHookBool("PewPew_InitBlastDamage",Position,Radius,Damage,RangeDamageMul,IgnoreEnt,DamageDealer) == false) then return end
	
	for _, ent in ipairs( targets ) do
		if (self:CheckValid( ent )) then
			if (IgnoreEnt) then
				if (ent != IgnoreEnt) then
					-- Do any other addons or scripts in this addon have anything to say about this?
					if (self:CallHookBool("PewPew_ShouldDoBlastDamage",ent,Position,Radius,Damage,RangeDamageMul,IgnoreEnt,DamageDealer)) then
						DamagedProps[#DamagedProps+1] = ent
						--table.insert( DamagedProps, ent )
					end
				end
			else
				if (self:CallHookBool("PewPew_ShouldDoBlastDamage",ent,Position,Radius,Damage,RangeDamageMul,IgnoreEnt,DamageDealer)) then
					DamagedProps[#DamagedProps+1] = ent
					--table.insert( DamagedProps, ent )
				end
			end
		end
	end
	
	-- Entities that are too close for the trace to work correctly. (Inspired by GCombat)
	local tooclose = ents.FindInSphere( Position, 5 )
	
	local tr = {}
	tr.start = Position
	tr.mask = MASK_SOLID
	tr.filter = tooclose
	
	--local Mul = (3-(1-RangeDamageMul)*2)
	local Mul = RangeDamageMul
	
	for _, ent in ipairs( DamagedProps ) do		
		tr.endpos = ent:LocalToWorld( ent:OBBCenter() )
		local trace = util.TraceLine( tr )
		local Distance = Position:Distance( ent:GetPos() )
		if ((!trace.Hit) or -- If the entity has a hole in its center (stargates?),
			(trace.Hit and trace.Entity and trace.Entity == ent) or -- or if the trace hit the entity,
			(Distance < Radius * (RangeDamageMul / 5))) then -- or if the entity is just really close to the center of the explosion
			local Mul = 1-(Distance/Radius)^Mul
			local Dmg = Damage * Mul
			self:DealDamageBase( ent, Dmg, DamageDealer )
		end
	end
end

local PLAYER = FindMetaTable("player")
if (PLAYER) then
	local OldFunc = PLAYER.GodEnable
	function PLAYER:GodEnable()
		self.PewPew_God = true
		OldFunc( self )
	end
	local OldFunc = PLAYER.GodDisable
	function PLAYER:GodDisable()
		self.PewPew_God = false
		OldFunc( self )
	end
end

-- Helper function. Should be used in place of util.BlastDamage in all pewpew weapons
function pewpew:PlayerBlastDamage( Inflictor, Attacker, Pos, Radius, Damage )
	
	-- Check safe zone
	if (self:FindSafeZone( Pos )) then return end
	
	local disablegod = {}
	
	local plys = ents.FindInSphere(Pos, Radius)
	for k,v in pairs( plys ) do
		if (v:IsPlayer() and !v.PewPew_God) then
			if (!pewpew:CallHookBool( "PewPew_ShouldDamage", v, Damage, Inflictor )) then
				v:GodEnable()
				table.insert( disablegod, v )
			end
		end
	end
	
	util.BlastDamage( Inflictor, Attacker, Pos, Radius, Damage )
	
	for k,v in ipairs( disablegod ) do
		v:GodDisable()
	end
end

-- Point Damage - (Deals damage to 1 single entity)
function pewpew:PointDamage( TargetEntity, Damage, DamageDealer )
	if (!self:GetConVar( "Damage" )) then return end
	if (TargetEntity:IsPlayer()) then
		if (DamageDealer and DamageDealer:IsValid()) then
			if (self:CallHookBool("PewPew_ShouldDoPointDamage",TargetEntity,Damage,DamageDealer)) then
				TargetEntity:TakeDamage( Damage, DamageDealer )
			end
		end
	else
		if (self:CallHookBool("PewPew_ShouldDoPointDamage",TargetEntity,Damage,DamageDealer)) then
			self:DealDamageBase( TargetEntity, Damage, DamageDealer )
		end
	end
end

-- Slice damage - (Deals damage to a number of entities in a line. It is stopped by the world)
function pewpew:SliceDamage( StartPos, Direction, Damage, NumberOfSlices, MaxRange, ReducedDamagePerSlice, DamageDealer )
	-- First trace
	local tr = {}
	tr.start = StartPos
	tr.endpos = StartPos + Direction * MaxRange
	local trace = util.TraceLine( tr )
	local Hit = trace.Hit
	local HitWorld = trace.HitWorld
	local HitPos = trace.HitPos
	local HitEnt = trace.Entity
	
	-- Check dmg
	if (!self:GetConVar( "Damage" )) then
		if (Hit) then
			return HitPos
		else
			return StartPos + Direction * MaxRange
		end
	end
	
	-- Maybe an addon thinks there is no use to even start the loop?
	if (self:CallHookBool("PewPew_InitSliceDamage",StartPos,Direction,Damage,NumberOfSlices,MaxRange,ReducedDamagePerSlice,DamageDealer) == false) then 	
		if (Hit) then
			return HitPos
		else
			return StartPos + Direction * MaxRange
		end 
	end
	
	local ret = HitPos
	for I=1, NumberOfSlices do
		if (HitEnt and HitEnt:IsValid()) then -- if the trace hit an entity
			if (StartPos:Distance(HitPos) > MaxRange) then -- check distance
				return StartPos + Direction * MaxRange
			else
				if (self:CallHookBool("PewPew_ShouldDoSliceDamage",HitEnt,StartPos,Direction,Damage,NumberOfSlices,MaxRange,ReducedDamagePerSlice,DamageDealer)) then
					if (HitEnt:IsPlayer()) then
						HitEnt:TakeDamage( Damage, DamageDealer ) -- deal damage to players
					elseif (self:CheckValid( HitEnt )) then
						self:DealDamageBase( HitEnt, Damage, DamageDealer ) -- Deal damage to entities
					end
				end
				-- Reduce damage after hit
				if (ReducedDamagePerSlice != 0) then
					Damage = Damage - ReducedDamagePerSlice
					if (Damage <= 0) then return HitPos end
				end
				
				-- new trace
				local tr = {}
				tr.start = HitPos
				tr.endpos = HitPos + Direction * MaxRange
				tr.filter = HitEnt
				ret = HitPos
				local trace = util.TraceLine( tr )
				Hit = trace.Hit
				HitWorld = trace.HitWorld
				HitPos = trace.HitPos
				HitEnt = trace.Entity
			end
		elseif (HitWorld) then-- if the trace hit the world
			if (StartPos:Distance(HitPos) > MaxRange) then -- check distance
				return StartPos + Direction * MaxRange
			else
				return HitPos
			end
		elseif (!Hit) then -- if the trace hit nothing
			return StartPos + Direction * MaxRange
		end
	end
	return ret or HitPos or StartPos + Direction * MaxRange
end

-- EMPDamage - (Electro Magnetic Pulse. Disables all wiring within the radius for the duration)
pewpew.EMPAffected = {}

-- Override TriggerInput
local OriginalFunc = WireLib.TriggerInput
function WireLib.TriggerInput(ent, name, value, ...)
	-- My addition
	if (pewpew.EMPAffected[ent:EntIndex()] and pewpew.EMPAffected[ent:EntIndex()][1]) then  -- if it is affected
		if (CurTime() < pewpew.EMPAffected[ent:EntIndex()][2]) then -- if the time isn't up yet
			return
		else -- if the time is up
			pewpew.EMPAffected[ent:EntIndex()] = nil 
		end
	end
	
	OriginalFunc( ent, name, value, ... )
end

-- Add to EMPAffected
function pewpew:EMPDamage( Position, Radius, Duration, DamageDealer )
		-- Check damage
		if (!self:GetConVar( "Damage" )) then return end
	-- Check for errors
	if (!Position or !Radius or !Duration) then return end
	
	-- Find all entities in the radius
	local ents = ents.FindInSphere( Position, Radius )
	
	-- Loop through all found entities
	for _, ent in pairs(ents) do
		if (ent.TriggerInput) then
			if (self:CallHookBool("PewPew_ShouldDoEMPDamage",ent,Position,Radius,Duration,DamageDealer)) then
				if (!self.EMPAffected[ent:EntIndex()]) then self.EMPAffected[ent:EntIndex()] = {} end
				if (self.EMPAffected[ent:EntIndex()][1]) then -- if it is already affected
					self.EMPAffected[ent:EntIndex()][2] = CurTime() + Duration -- edit the duration
				else
					self.EMPAffected[ent:EntIndex()][1] = true -- affect it
					self.EMPAffected[ent:EntIndex()][2] = CurTime() + Duration -- set duration
				end
			end
		end
	end
end

-- Fire Damage (Damages an entity over time)
function pewpew:FireDamage( TargetEntity, DPS, Duration, DamageDealer )
		-- Check damage
		if (!self:GetConVar( "Damage" )) then return end
	-- Check for errors
	if (!TargetEntity or !self:CheckValid(TargetEntity) or !DPS or !Duration) then return end
	
	-- See if any other addon/plugin wants to stop this damage
	if (self:CallHookBool("PewPew_ShouldDoFireDamage",TargetEntity,DPS,Duration,DamageDealer) == false) then return end
	
	-- Effect
	TargetEntity:Ignite( Duration )
	
	-- Initial damage
	self:DealDamageBase( TargetEntity, DPS/10 )
	
	-- Start a timer
	local timername = "pewpew_firedamage_"..TargetEntity:EntIndex()..CurTime()
	timer.Create( timername, 0.1, Duration*10, function( TargetEntity, DPS, timername ) 
		-- Damage
		pewpew:DealDamageBase( TargetEntity, DPS/10, DamageDealer )
		-- Auto remove timer if dead
		if (!TargetEntity or !TargetEntity:IsValid()) then timer.Remove( timername ) end
	end, TargetEntity, DPS, timername, DamageDealer )
end

-- Defense Damage (Used to destroy PewPew bullets. Each PewPew Bullet has 100 health.)
function pewpew:DefenseDamage( TargetEntity, Damage )
	-- Check for errors
	if (!TargetEntity or TargetEntity:GetClass() != "pewpew_base_bullet" or !Damage or Damage == 0 or !TargetEntity.Bullet) then return end

	if (self:CallHookBool("PewPew_ShouldDoDefenseDamage",TargetEntity,Damage) == false) then return end
	
	-- Does it have health?
	if (!TargetEntity.pewpew) then TargetEntity.pewpew = {} end
	if (!TargetEntity.pewpew.Health) then TargetEntity.pewpew.Health = 100 end
	
	-- Damage
	TargetEntity.pewpew.Health = TargetEntity.pewpew.Health - Damage
	-- Did it die?
	if (TargetEntity.pewpew.Health <= 0) then
		if (TargetEntity.Bullet.ExplodeAfterDeath and TargetEntity.Bullet.ExplodeAfterDeath == true) then
			TargetEntity:Explode()
		else
			TargetEntity:Remove()
		end
	end
end

------------------------------------------------------------------------------------------------------------
-- Base Code

-- Base code for dealing damage
function pewpew:DealDamageBase( TargetEntity, Damage, DamageDealer )
		if (!self:GetConVar( "Damage" )) then return end
	-- Check for errors
	if (!Damage or Damage == 0) then return end
	if (!self:CheckValid( TargetEntity )) then return end
	
	-- Multiply damage
	Damage = Damage * self:GetConVar( "DamageMul" )
	
	-- Check if the entity has too much health
	self:ReduceHealth( TargetEntity )
	
	-- Do any other addons or scripts in this addon have anything to say about this?
	if(self:CallHookBool("PewPew_ShouldDamage", TargetEntity, Damage, DamageDealer ) == false) then return end	
	
	-- See if any other addon/plugin wants to change this damage
	local dmg = self:CallHookNum("PewPew_CalcDamage", TargetEntity, Damage, DamageDealer )
	if (dmg) then Damage = dmg end
	
	if (!self:CheckNeverEverList( TargetEntity )) then return end
	if (!self:CheckAllowed( TargetEntity )) then
		local temp = constraint.GetAllConstrainedEntities( TargetEntity )
		local OldEnt = TargetEntity
		for _, ent in pairs( temp ) do
			if (self:CheckAllowed( ent )) then
				TargetEntity = ent
				break
			end
		end
	end
	
	-- Check for table
	if (!TargetEntity.pewpew) then TargetEntity.pewpew = {} end
	if (!TargetEntity.pewpew.Health) then self:SetHealth( TargetEntity ) end
	
	-- Deal damage
	TargetEntity.pewpew.Health = TargetEntity.pewpew.Health - math.abs(Damage)
	TargetEntity:SetNWInt("pewpewHealth",TargetEntity.pewpew.Health)
	self:CheckIfDead( TargetEntity )
	
	-- Allow others to hook
	self:CallHookBool("PewPew_Damage",TargetEntity,Damage,DamageDealer)
end

------------------------------------------------------------------------------------------------------------
-- Health

-- Set the health of a spawned entity
function pewpew:SetHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	local health = self:GetHealth( ent )
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return 0 end
	local mass = phys:GetMass() or 0
	ent.pewpew.Health = health
	ent.pewpew.MaxMass = mass
	ent:SetNWInt("pewpewHealth",health)
	ent:SetNWInt("pewpewMaxHealth",health)
end

-- Repairs the entity by the set amount
function pewpew:RepairHealth( ent, amount )
	-- Check for errors
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (!ent.pewpew.Health or !ent.pewpew.MaxMass) then return end
	if (!amount or amount == 0) then return end
	-- Get the max allowed health
	local maxhealth = self:GetMaxHealth( ent )
	-- Add health
	ent.pewpew.Health = math.Clamp(ent.pewpew.Health+math.abs(amount),0,maxhealth)
	-- Make the health changeable again with weight tool
	if (ent.pewpew.Health == maxhealth) then
		ent.pewpew.Health = nil
		ent.pewpew.MaxMass = nil
	end
	ent:SetNWInt("pewpewHealth",ent.pewpew.Health or 0)
	ent:SetNWInt("pewpewMaxHealth",maxhealth or 0)
end

-- Returns the health of the entity without setting it
function pewpew:GetHealth( ent )
	if (!self:CheckValid( ent )) then return 0 end
	if (!self:CheckAllowed( ent )) then return 0 end
	if (!ent.pewpew) then ent.pewpew = {} end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return 0 end
	local mass = phys:GetMass() or 0
	local volume = phys:GetVolume() / 1000
	if (ent.pewpew.Health) then
		-- Check if the entity has too much health (if the player changed the mass to something huge then back again)
		if (ent.pewpew.Health > mass / 5 + volume) then
			return (mass / 5 + volume) * (mass/ent.pewpew.MaxMass)
		end
		return ent.pewpew.Health
	else
		return (mass / 5 + volume)
	end
end

-- Returns the maximum health of the entity without setting it
function pewpew:GetMaxHealth( ent )
	if (!self:CheckValid( ent )) then return 0 end
	if (!self:CheckAllowed( ent )) then return 0 end
	if (!ent.pewpew) then ent.pewpew = {} end
	local phys = ent:GetPhysicsObject()
	if (!phys:IsValid()) then return 0 end
	local volume = phys:GetVolume() / 1000
	local mass = phys:GetMass() or 0
	if (ent.pewpew.MaxMass) then
		if (mass >= ent.pewpew.MaxMass) then
			return ent.pewpew.MaxMass / 5 + volume
		else
			return (mass / 5 + volume) * (mass/ent.pewpew.MaxMass)
		end
	else
		local mass = phys:GetMass() or 0
		return mass / 5 + volume
	end
end

-- Reduce the health if it's too much (if the player changed the mass to something huge then back again)
function pewpew:ReduceHealth( ent )
	if (!self:CheckValid( ent )) then return end
	if (!self:CheckAllowed( ent )) then return end
	if (!ent.pewpew) then ent.pewpew = {} end
	if (!ent.pewpew.Health) then return end
	local maxhp = self:GetMaxHealth( ent )
	if (ent.pewpew.Health > maxhp) then
		ent.pewpew.Health = maxhp
		ent:SetNWInt("pewpewHealth",ent.pewpew.Health or 0)
		ent:SetNWInt("pewpewMaxHealth",maxhp or 0)
	end
end

------------------------------------------------------------------------------------------------------------
-- Checks

-- Check if the entity should be removed
function pewpew:CheckIfDead( ent )
	if (!ent.pewpew) then ent.pewpew = {} end
	if (ent.pewpew.Health <= 0) then
		local effectdata = EffectData()
		effectdata:SetOrigin( ent:LocalToWorld(ent:OBBCenter()) )
		effectdata:SetScale( (ent:OBBMaxs() - ent:OBBMins()):Length() )
		util.Effect( "pewpew_deatheffect", effectdata )
		ent:Remove()
	end
end

function pewpew:CheckAllowed( entity )
	for _, str in pairs( self.DamageWhitelist ) do
		if (entity:GetClass() == str) then return true end
	end
	for _, str in pairs( self.DamageBlacklist ) do
		if (string.find( entity:GetClass(), str )) then return false end
	end
	return true
end

function pewpew:CheckNeverEverList( entity )
	for _, str in pairs( self.NeverEverList ) do
		if (string.find( entity:GetClass(), str)) then return false end
	end
	return true
end

function pewpew:CheckValid( entity )
	if (!entity) then return false end
	if (!entity:IsValid()) then return false end
	if (entity:IsWorld()) then return false end
	if (entity:GetMoveType() != MOVETYPE_VPHYSICS) then -- This made it unable to kill parented props
		if (!(entity:GetMoveType() == MOVETYPE_NONE and entity:GetParent() != nil)) then -- So I added this check as well
			return false 
		end
	end
	local phys = entity:GetPhysicsObject()
	if (!phys:IsValid()) then return false end
	if (!phys:GetVolume()) then return false end
	if (!phys:GetMass()) then return false end
	return true
end