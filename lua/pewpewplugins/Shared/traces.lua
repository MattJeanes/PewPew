local v = FindMetaTable("Vector")
local Length = v.Length
local Dot = v.Dot
local sqrt = math.sqrt

-- Helper functions

local function RaySphereIntersection( Start, Dir, Pos, Radius ) -- Thanks to Feha
	local A = 2 * Length(Dir)^2
	local B = 2 * Dot(Dir,Start - Pos)
	local C = Length(Pos)^2 + Length(Start)^2 - 2 * Dot(Pos,Start) - Radius^2
	local BAC4 = B^2-(2*A*C)
	if (BAC4 >= 0 and B < 0) then
		return Start + ((-sqrt(BAC4) - B) / A)*Dir
	end
end

local function RayPlaneIntersection( Start, Dir, Pos, Normal ) -- Thanks to Feha
	local A = Dot(Normal, Dir)
	if (A < 0) then
		local B = Dot(Normal, Pos-Start)
		if (B < 0) then
			return (Start + Dir * (B/A))
		end
	elseif (A == 0) then
		if (Dot(Normal, Pos-Start) == 0) then
			return Start
		end
	end
	
	return false
end

local function RayCircleIntersection( Start, Dir, Pos, Normal, Radius )
	local HitPos = RayPlaneIntersection( Start, Dir, Pos, Normal )
	if (HitPos) then
		local Dist = Length(Pos-HitPos)
		if (Dist < Radius) then return HitPos, Dist end
	end
	return false
end

if (SERVER) then umsg.PoolString("PewPew_Stargate_EH_Position_Change") end

function pewpew:Trace( pos, dir, filter, Bullet ) -- Bullet arg is only necessary for Stargate Event Horizons. It's made to work for bullets, but can be used for lasors as well.
	if (StarGate) then -- If Stargate is installed
	
		if (SERVER) then
			local trace = StarGate.Trace:New( pos, dir, filter )
			
			trace.HitShield = false
			
			if (trace.Hit and trace.Entity and trace.Entity:IsValid()) then
				if (trace.Entity:GetClass() == "shield") then
					local HitPos = RaySphereIntersection( trace.HitPos, dir, trace.Entity:GetPos(), trace.Entity:GetNWInt("size",0) )
					if (HitPos) then
						trace.HitPos = HitPos
						trace.HitNormal = (HitPos - trace.Entity:GetPos()):GetNormal()
						trace.HitShield = true
						return trace
					else
						if (!filter) then filter = {} elseif (type(filter) == "Entity") then filter = {filter} end
						filter[#filter+1] = trace.Entity
						return self:Trace( trace.HitPos, dir, filter )
					end
				elseif (trace.Entity:GetClass() == "event_horizon") then
					if (trace.Entity:GetParent() and string.find(trace.Entity:GetParent():GetClass(),"stargate_") and Bullet) then
						local newpos, newdir = GetTeleportedVector( trace.Entity, trace.Entity.Target, trace.HitPos, dir:GetNormalized() )
						if (Bullet.BulletData and Bullet.BulletData.TraceDelay) then
							Bullet.BulletData.TraceDelay = CurTime() + (Bullet.WeaponData.Speed * Bullet.SpeedOffset) / (1/pewpew.ServerTick) * pewpew.ServerTick
						end
						Bullet.Pos = newpos
						Bullet.Vel = newdir * (1/pewpew.ServerTick) * Length(dir)
						pos = newpos
						dir = newdir * Length(dir)
						if (!filter) then filter = {} elseif (type(filter) == "Entity") then filter = {filter} end
						filter[#filter+1] = trace.Entity
						filter[#filter+1] = trace.Entity:GetParent()
						filter[#filter+1] = trace.Entity:GetParent().Target
						filter[#filter+1] = trace.Entity:GetParent().Target.EventHorizon
						return self:Trace( pos, dir, filter, Bullet )
					end
				end
			end
			
			return trace		
		else
			for k,v in ipairs( pewpew.SGShields ) do
				if (v and IsValid( v ) and !v:GetNWBool("depleted", false) and !v:GetNWBool("containment",false)) then
					local HitPos = RaySphereIntersection( pos, dir, v:GetPos(), v:GetNWInt("size",1) )
					if (HitPos and pos:Distance(HitPos) <= dir:Length()) then
						local ret = {}
						ret.HitPos = HitPos
						ret.Hit = true
						ret.HitNormal = (HitPos - v:GetPos()):GetNormal()
						ret.Entity = v
						return ret
					end
				end
			end
			
			-- This doesn't work because there's no reliable way to get the target of a gate client side afaik
			--[[ If no SG shield was hit, go on with an EH check...
			if (Bullet) then
				for k,v in ipairs( pewpew.SGGates ) do
					if (v and IsValid( v ) and v._IsOpen) then
						local hit, _ = RayCircleIntersection( pos, dir, v:LocalToWorld(v:OBBCenter()), v:GetForward(), 103 )
						if (hit) then
							local newpos, newdir = v:GetTeleportedVector( pos, dir:GetNormalized() )
							Bullet.Pos = newpos
							Bullet.Vel = newdir * (1/pewpew.ServerTick) * Length(dir)
							pos = newpos
							dir = newdir * Length(dir)
							if (Bullet.Prop and Bullet.Prop:IsValid()) then Bullet.Prop:SetPos( newpos ) end
							if (!filter) then filter = {} elseif (type(filter) == "Entity") then filter = {filter} end
							filter[#filter+1] = v
							return self:Trace( pos, dir, filter, Bullet )
						end						
					end
				end
			end]]
			
			-- No shield or EH was hit. Use a regular trace.
			local tr = {}
			tr.start = pos
			tr.endpos = pos + dir
			tr.filter = filter
			return util.TraceLine( tr )
		end
	else -- If Stargate isn't installed
		local tr = {}
		tr.start = pos
		tr.endpos = pos + dir
		tr.filter = filter
		return util.TraceLine( tr )
	end
	
end

-- Keep track of stargate shields and gates. Used for the pewpew trace to remove bullets at the right time and check for EHs.
if (CLIENT) then
	pewpew.SGShields = {}
	--pewpew.SGGates = {}

	hook.Add("OnEntityCreated","PewPew_StargateShield_Spawn",function( ent )
		if (ent and IsValid( ent )) then
			if (ent:GetClass() == "shield") then
				pewpew.SGShields[#pewpew.SGShields+1] = ent
			end--[[elseif (string.find(ent:GetClass(),"stargate_") and ent.IsStargate) then
				pewpew.SGGates[#pewpew.SGGates+1] = ent
			elseif (ent:GetClass() == "event_horizon") then -- Hacky way of checking if a gate is opening
				timer.Simple(0,function(ent)
					-- Get SG
					local SG = ent:GetParent()
					if (SG and SG:IsValid() and SG.IsStargate) then
						if (!table.HasValue( pewpew.SGGates, SG )) then
							pewpew.SGGates[#pewpew.SGGates+1] = SG
						end
						SG._IsOpen = true
					end
				end,ent)
			end]]
		end
	end)

	hook.Add("OnEntityRemoved","PewPew_StargateShield_Remove",function( ent )
		if (ent:GetClass() == "shield") then
			for k,v in ipairs( pewpew.SGShields ) do
				if (v == ent) then
					table.remove( pewpew.SGShields, k )
					return
				end
			end
		end--[[elseif (string.find(ent:GetClass(),"stargate_") and ent.IsStargate) then
			for k,v in ipairs( pewpew.SGGates ) do
				if (v == ent) then
					table.remove( pewpew.SGGates, k )
					return
				end
			end
		elseif (ent:GetClass() == "event_horizon") then -- Hacky way of checking if a gate is closing
			timer.Simple(0,function(ent)
				-- Get SG
				local SG = ent:GetParent()
				if (SG and SG:IsValid() and SG.IsStargate) then
					SG._IsOpen = nil
				end
			end,ent)
		end]]
	end)
	--[[
	hook.Add("Initialize","PewPew_StargateInitialize",function()
		timer.Simple(10,function()
			local e = ents.FindByClass("stargate_*")
			for k,v in ipairs( e ) do
				if (v.IsStargate) then
					pewpew.SGGates[#pewpew.SGGates+1] = v
				end
			end
		end)
	end)
	]]
end