-- PewPew Bullet Control
-- These functions make bullets fly
if SERVER then
	util.AddNetworkString("PewPew_FireBullet")
	util.AddNetworkString("PewPew_RemoveBullet")
	util.AddNetworkString("PewPew_ServerTick")
end
------------------------------------------------------------------------------------------------------------

pewpew.Bullets = {}

------------------------------------------------------------------------------------------------------------
-- Add and Remove
function pewpew:FireBullet( Pos, Dir, Owner, WeaponData, Cannon, FireDir )
	if (CLIENT) then return end -- Shouldn't be needed. But just in case
	
	-- Does any other addon have anything to say about this?
	if (self:CallHookBool("PewPew_FireBullet",Pos,Dir,WeaponData,Cannon,Owner) == false) then return end
	
	local n = WeaponData.Spread
	local SpeedOffset = 1
	if (n and n > 0) then
		SpeedOffset = math.Rand(1,1+n/100)
	end
	
	if not (Cannon and Dir and SpeedOffset and FireDir and Owner and WeaponData and WeaponData.Name) then return end
	
	local constrainedEnts = constraint.GetAllConstrainedEntities(Cannon)
	local Filter = {}
	
	local DistanceCheck = WeaponData.Speed + Cannon:GetVelocity():Length()
	
	for _,v in pairs( constrainedEnts ) do
		if v:GetPos():Distance(Cannon:GetPos()) < DistanceCheck then
			Filter[#Filter+1] = v
			if #Filter > 1000 then break end
		end
	end
	
	net.Start("PewPew_FireBullet")
		net.WriteEntity(Cannon)
		net.WriteFloat(Dir.x)
		net.WriteFloat(Dir.y)
		net.WriteFloat(Dir.z)
		net.WriteFloat(SpeedOffset)
		net.WriteUInt(FireDir,8) -- FireDir is used to get the position on the client (better than sending the position as well)
		net.WriteEntity(Owner)
		net.WriteString(WeaponData.Name)
		net.WriteTable(Filter)
	net.Broadcast()
	--print("bullet sent")
	
	local NewBullet = { Pos = Pos, Dir = Dir, Owner = Owner, Cannon = Cannon, WeaponData = WeaponData, BulletData = {}, RemoveTimer = CurTime() + 60, SpeedOffset = SpeedOffset, Filter = Filter }
	table.insert( self.Bullets, NewBullet )
	self:BulletInitialize( NewBullet )
	
end

if (CLIENT) then
	local function ClientFireBullet()
		-- Cannon
		local Cannon = net.ReadEntity()
		
		-- Pos/Dir
		local Dir = Vector(net.ReadFloat(), net.ReadFloat(), net.ReadFloat())
		local SpeedOffset = net.ReadFloat()
		local FireDir = net.ReadUInt(8)
		local temp, Pos = pewpew:GetFireDirection( FireDir, Cannon )
		
		-- Owner
		local Owner = net.ReadEntity()
		
		-- Weapon
		local WpnName = net.ReadString()
		local Weapon = pewpew:GetWeapon( WpnName )
		if (!Weapon) then return end
		if not Pos then return end
		
		-- Filter
		local Filter = net.ReadTable()
		
		if (#pewpew.Bullets < (GetConVarNumber("PewPew_MaxBullets") or 255)) then
			local ent = ClientsideModel(Weapon.Model)
			if (ent) then
				ent:SetPos(Pos)
				ent:SetAngles(Dir:Angle() + Angle(90,0,0) + (Weapon.AngleOffset or Angle(0,0,0)) )
				ent:Spawn()
			end
			Filter[#Filter+1] = ent
			local NewBullet = { Pos = Pos, Dir = Dir, Owner = Owner, WeaponData = Weapon, BulletData = {}, Prop = ent, RemoveTimer = CurTime() + 30, SpeedOffset = SpeedOffset, Filter = Filter }
			if (ent) then ent.PewPewTable = NewBullet end
			table.insert( pewpew.Bullets, NewBullet )
			pewpew:BulletInitialize( NewBullet )
			--print("bullet recieved")
		end
	end
	net.Receive("PewPew_FireBullet",ClientFireBullet)
end

local RemoveBulletsTable = {}

function pewpew:RemoveBullet( Index )
	table.insert( RemoveBulletsTable, Index )
end

if (SERVER) then
	concommand.Add("PewPew_BulletWasRemovedClientSide",function(ply,cmd,args)
		local n = ply:GetNWInt( "PewPew_BulletAmount", 0 )
		if (n > 0) then
			ply:SetNWInt( "PewPew_BulletAmount", n - 1 )
		end
	end)
end

function pewpew:ClearRemoveBulletsTable()
	for k,v in ipairs( RemoveBulletsTable ) do
		if (self.Bullets[v]) then
			if (CLIENT) then
				if (self.Bullets[v].Prop and self.Bullets[v].Prop:IsValid()) then
					self.Bullets[v].Prop:Remove()
				end
				local n = LocalPlayer():GetNWInt( "PewPew_BulletAmount", 0 )
				if (n > 0) then
					RunConsoleCommand( "PewPew_BulletWasRemovedClientSide" )
				end
			end
			table.remove( self.Bullets, v )
		end
	end
	RemoveBulletsTable = {}
end

if (SERVER) then
	function pewpew:RemoveClientBullet( Index )
		net.Start("PewPew_RemoveBullet")
			net.WriteUInt( Index - 128, 8)
		net.Broadcast()
	end
else
	net.Receive( "PewPew_RemoveBullet", function()
		local Index = net.ReadUInt(8) + 128
		pewpew:RemoveBullet( Index )
	end)
end

------------------------------------------------------------------------------------------------------------
-- Initialize
function pewpew:DefaultBulletInitialize( Bullet )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	B.Exploded = false
	local tk = self.ServerTick or (1/66.7)
	local tk66=(1/66.7)
	--B.TraceDelay = CurTime() + ((D.Speed * Bullet.SpeedOffset) / (1/tk66) * tk66)
	--B.TraceDelay = CurTime() + (D.Speed) * (1/tk)
	--B.TraceDelay = CurTime() + (D.Speed + (1/(D.Speed*tk)) * 0) / (1/tk) * tk
	
	Bullet.Vel = (Bullet.Dir * D.Speed * Bullet.SpeedOffset * (1/tk)) * (tk/(1/66))
	
	
	-- Lifetime
	B.Lifetime = false
	if (D.Lifetime) then
		if (D.Lifetime[1] > 0 and D.Lifetime[2] > 0) then
			if (D.Lifetime[1] == D.Lifetime[2]) then
				B.Lifetime = CurTime() + D.Lifetime[1]
			else
				B.Lifetime = CurTime() + math.Rand(D.Lifetime[1],D.Lifetime[2])
			end
		end
	end
	if (CLIENT) then
		if (Bullet.Prop) then
		--[[
			-- Trail
			if (D.Trail) then
				local trail = ents.Create("env_spritetrail")
				print("TRAIL:",tostring(trail))
				trail:SetPos( Bullet.Prop:GetPos() )
				trail:SetEntity("Parent",Bullet.Prop)
				local trl = D.Trail
				trail:SetKeyValue("lifetime",tostring(trl.Length))
				trail:SetKeyValue("startwidth",tostring(trl.StartSize))
				trail:SetKeyValue("endwidth",tostring(trl.EndSize))
				trail:SetKeyValue("spritename",tostring(trl.Texture))
				local clr = trl.Color
				trail:SetKeyValue("rendercolor",tostring(clr.r) .. " " .. tostring(clr.g) .. " " .. tostring(clr.b))
				trail:SetKeyValue("renderamt","5")
				trail:SetKeyValue("rendermode","0")
				trail:Spawn()
			end
		]]
			
			
			-- Material
			if (D.Material) then
				Bullet.Prop:SetMaterial( D.Material )
			end
			
			-- Color
			if (D.Color) then
				local C = D.Color
				Bullet.Prop:SetColor( Color(C.r, C.g, C.b, C.a or 255) )
				if C.a then Bullet.Prop:SetRenderMode(RENDERMODE_TRANSALPHA) end
			end
		end
	end
end

function pewpew:BulletInitialize( Bullet )
	if (SERVER) then
		if (Bullet.WeaponData.Initialize) then
			-- Allows you to override the Initialize function
			Bullet.WeaponData.Initialize( Bullet )
		else
			self:DefaultBulletInitialize( Bullet )
		end
	else
		if (Bullet.WeaponData.CLInitialize) then
			Bullet.WeaponData.CLInitialize( Bullet )
		else
			self:DefaultBulletInitialize( Bullet )
		end
	end
end

------------------------------------------------------------------------------------------------------------
-- Tick

function pewpew:DefaultBulletThink( Bullet, Index, LagCompensation )	
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	
	--[[ OLD CODE
	-- Make it fly
	Bullet.Pos = Bullet.Pos + Bullet.Dir * D.Speed * (LagCompensation or 1)
	local grav = D.Gravity or 0

	if (D.AffectedByNoGrav) then
		if (CAF and CAF.GetAddon("Spacebuild")) then
			if (false) then -- TODO: Gravity check
				grav = grav
			end
		end
	end
	
	if (grav and grav != 0) then -- Only pull if needed
		Bullet.Dir = Bullet.Dir - Vector(0,0,grav / (D.Speed or 1)) * (LagCompensation or 1)
		Bullet.Dir:Normalize()
	end
	]]
	
	local grav = 600
	local tk = self.ServerTick or (1/66.667)
	if (D.Gravity != nil) then grav = D.Gravity end
	-- TODO: Spacebuild gravity
	
	if (grav and grav > 0) then
		Bullet.Vel = Bullet.Vel - Vector(0,0,grav) * tk * (LagCompensation or 1)
	end
	Bullet.Pos = Bullet.Pos + Bullet.Vel * tk * (LagCompensation or 1)
	
	-- Lifetime
	if (B.Lifetime) then
		if (CurTime() > B.Lifetime) then
			if (CLIENT) then
				self:RemoveBullet( Index )
			else
				if (D.ExplodeAfterDeath) then
					local trace = pewpew:DefaultTraceBullet( Bullet )
					self:ExplodeBullet( Index, Bullet, trace )
				else
					self:RemoveBullet( Index )
				end
			end
		end
	end
	
	if (CLIENT) then 
		local contents = util.PointContents( Bullet.Pos )
		local contents2 = util.PointContents( Bullet.Pos + Bullet.Vel * (self.ServerTick or (1/66.667)) * (LagCompensation or 1) )
		if ((Bullet.RemoveTimer and Bullet.RemoveTimer < CurTime()) -- There's no way a bullet can fly for that long.
			or contents == 1 -- It flew out of the map
			or contents2 == 1) then -- It's going to fly out of the map in the next tick
			self:RemoveBullet( Index )
		
		elseif (Bullet.Prop and Bullet.Prop:IsValid()) then
			Bullet.Prop:SetPos( Bullet.Pos )
			Bullet.Prop:SetAngles( Bullet.Vel:Angle() + Angle( 90,0,0 ) + (D.AngleOffset or Angle(0,0,0)) )
			--if (CurTime() > B.TraceDelay) then
				local trace = pewpew:DefaultTraceBullet( Bullet )
				
				if (trace.Hit and !B.Exploded) then
					B.Exploded = true
					if (D.CLExplode) then D.CLExplode( Bullet, trace ) end
					self:RemoveBullet( Index )
				end
			--end
		end
	else
		local contents = util.PointContents( Bullet.Pos )
		if ((Bullet.RemoveTimer and Bullet.RemoveTimer < CurTime()) -- There's no way a bullet can fly for that long.
			or contents == 1) then -- It flew out of the map
			self:ExplodeBullet( Index, Bullet, pewpew:DefaultTraceBullet( Bullet ) )
		else			
			--if (CurTime() > B.TraceDelay) then
				local trace = pewpew:DefaultTraceBullet( Bullet )
				
				if (trace.Hit and !B.Exploded) then
					B.Exploded = true
					self:ExplodeBullet( Index , Bullet, trace )
				end
			--end
		end
	end
end

------------------
-- Recieve tick
local LastTick = 0
local HasTick = false
if SERVER then pewpew.ServerTick = 0 end

if (CLIENT) then
	net.Receive("PewPew_ServerTick",function()
		pewpew.ServerTick = net.ReadFloat()
	end)
else
	function pewpew.SendTick(ply)
		timer.Simple(2,function()
			net.Start("PewPew_ServerTick")
				net.WriteFloat(pewpew.ServerTick)
			net.Broadcast()
		end)
	end
	hook.Add("PlayerInitialSpawn", "PewPew-SendTick", pewpew.SendTick)
	timer.Create("PewPew-SendTick", 30, 0, pewpew.SendTick)
end

concommand.Add("pewpew_sendtick", pewpew.SendTick)
-----------------

function pewpew:BulletThink()
	if (SERVER) then
		if (HasTick != nil) then
			if (HasTick == false) then
				LastTick = CurTime()
				HasTick = true
			else
				self.ServerTick = (CurTime() - LastTick)
				HasTick = nil
			end
		end
	else
		LastTick = CurTime() - LastTick
	end
			
	for k,v in pairs( self.Bullets ) do
		if (SERVER) then
			if (v.WeaponData.Think) then
				-- Allows you to override the think function
				v.WeaponData.Think( v, k )
			else
				self:DefaultBulletThink( v, k )
			end
		else
			local LagCompensation = LastTick / self.ServerTick
			if (v.WeaponData.CLThink) then
				-- Allows you to override the think function
				v.WeaponData.CLThink( v, k, LagCompensation )
			else
				self:DefaultBulletThink( v, k, LagCompensation)
			end
			
		end
	end -- Loop end
	self:ClearRemoveBulletsTable()
	if (CLIENT) then LastTick = CurTime() end
end
hook.Add("Tick","PewPew_BulletThink",function() pewpew:BulletThink() end)
--if (SERVER) then hook.Add("Tick","PewPew_BulletThink",function() pewpew:BulletThink() end) end
--if (CLIENT) then hook.Add("Think","PewPew_BulletThink",function() pewpew:BulletThink() end) end

------------------------------------------------------------------------------------------------------------
-- Trace
------------------------------------------------------------------------------------------------------------
function pewpew:DefaultTraceBullet( Bullet )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	
	local Pos = Bullet.Pos - Bullet.Vel * (self.ServerTick or (1/66.667))
	local Dir = Bullet.Vel * (self.ServerTick or (1/66.667))
	local Filter = Bullet.Filter
	return pewpew:Trace( Pos, Dir, Filter, Bullet )
end

------------------------------------------------------------------------------------------------------------
-- Explode
------------------------------------------------------------------------------------------------------------

function pewpew:DefaultExplodeBullet( Index, Bullet, trace )
	local D = Bullet.WeaponData
	local B = Bullet.BulletData
	-- Effects
	if (D.ExplosionEffect) then
		local effectdata = EffectData()
		effectdata:SetOrigin( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetStart( trace.HitPos + trace.HitNormal * 5 )
		effectdata:SetNormal( trace.HitNormal )
		util.Effect( D.ExplosionEffect, effectdata )
	end
	
	-- Sounds
	if (D.ExplosionSound) then
		local soundpath = ""
		if (table.Count(D.ExplosionSound) > 1) then
			soundpath = table.Random(D.ExplosionSound)
		else
			soundpath = D.ExplosionSound[1]
		end
		sound.Play( soundpath, trace.HitPos+trace.HitNormal*5,100,100)
	end
	
	-- Damage
	local damagetype = D.DamageType
	if (damagetype and type(damagetype) == "string") then
		local damagedealer = Bullet.Cannon
		if (not IsValid(damagedealer)) then damagedealer = Bullet.Owner end
		if (damagetype == "BlastDamage") then			
			self:BlastDamage( trace.HitPos + trace.HitNormal * 3, D.Radius, D.Damage, D.RangeDamageMul, nil, damagedealer )
			
			-- Player Damage
			if (D.PlayerDamageRadius and D.PlayerDamage and self:GetConVar( "Damage" )) then
				pewpew:PlayerBlastDamage( damagedealer, damagedealer, trace.HitPos + trace.HitNormal * 10, D.PlayerDamageRadius, D.PlayerDamage )
			end
		elseif (damagetype == "PointDamage") then
			self:PointDamage( trace.Entity, D.Damage, damagedealer )
		elseif (damagetype == "SliceDamage") then
			self:SliceDamage( trace.HitPos, Bullet.Vel, D.Damage, D.NumberOfSlices or 1, D.SliceDistance or 50, D.ReducedDamagePerSlice or 0, damagedealer )
		elseif (damagetype == "EMPDamage") then
			self:EMPDamage( trace.HitPos, D.Radius, D.Duration, damagedealer )
		elseif (damagetyp == "DefenseDamage") then
			self:DefenseDamage( trace.Entity, D.Damage )
		elseif (damagetype == "FireDamage") then
			pewpew:FireDamage( trace.Entity, D.DPS, D.Duration, damagedealer )
		end
	end
	
	-- Stargate shield damage
	if (trace.Entity and trace.Entity:IsValid() and trace.Entity:GetClass() == "shield") then
		local a = { IsPlayer = function() return false end }
		local b = {}
		setmetatable(b,a)
		trace.Entity:Hit(b,trace.HitPos,D.Damage*pewpew:GetConVar("StargateShield_DamageMul"),trace.HitNormal)
	end
	
	-- Remove the bullet
	self:RemoveBullet( Index )
end

function pewpew:ExplodeBullet( Index, Bullet, trace )
	if (!trace) then return end
	
	if (Bullet.WeaponData.Explode) then
		-- Allows you to override the Explode function
		Bullet.WeaponData.Explode( Bullet, Index, trace )
	else
		self:DefaultExplodeBullet( Index, Bullet, trace )
	end
end