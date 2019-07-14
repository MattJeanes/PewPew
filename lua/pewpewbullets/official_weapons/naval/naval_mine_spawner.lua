local BULLET = {}

-- Important Information
BULLET.Version = 2

-- General Information
BULLET.Name = "Naval Mine Spawner"
BULLET.Author = "Divran"
BULLET.Description = "Deploy in water. Mines will hover at designated height until touched. If height = 0, they will hover where spawned."
BULLET.AdminOnly = false
BULLET.SuperAdminOnly = true

-- Appearance
BULLET.Model = "models/Combine_Helicopter/helicopter_bomb01.mdl"

-- Effects / Sounds
BULLET.FireSound = {"npc/attack_helicopter/aheli_mine_drop1.wav"}

-- Damage
BULLET.DamageType = "BlastDamage"

-- Reloading/Ammo
BULLET.Reloadtime = 5
BULLET.Ammo = 0
BULLET.AmmoReloadtime = 0

-- Other
BULLET.Lifetime = {0,0}
BULLET.ExplodeAfterDeath = true
BULLET.EnergyPerShot = 10000

BULLET.CustomInputs = { "Fire", "Height" }

function BULLET:WireInput( inputname, value )
	if (inputname == "Height") then
		self.TargetHeight = math.max( value, 0 )
		if (self.TargetHeight == 0) then self.TargetHeight = nil end
	elseif (inputname == "Fire") then
		self:InputChange( "Fire", value )
	end		
end

function BULLET:Fire()
	local Dir, Pos = pewpew:GetFireDirection( self.Direction, self )
	
	local Bullet = pewpew:GetWeapon("Naval Mine")
	
	ply = self.Owner
	
	if (!Bullet) then 
		ply:ChatPrint("This server does not have Naval Mines.") 
		return 
	end
	
	if (!ply:CheckLimit("pewpew")) then return end
	local ent = ents.Create( "pewpew_base_cannon" )
	if (!ent:IsValid()) then return end
	
	-- Pos/Model/Angle
	ent:SetModel( self.Bullet.Model )
	
	if (!util.IsInWorld(Pos)) then return end
	
	ent:SetPos( Pos )
	ent:SetAngles( self.Entity:GetAngles() )

	
	ent:SetOptions( Bullet, ply, fire, reload )
	ent:Spawn()
	ent:Activate()
	
	ent.TargetHeight = self.TargetHeight
	
	local phys = ent:GetPhysicsObject()
	phys:Wake()
	
	phys:AddVelocity( Dir * 500 )
	self.Entity:GetPhysicsObject():ApplyForceCenter( Dir * -500 )
	
	ply:AddCount("pewpew",ent)
	ply:AddCleanup ( "pewpew", ent )

	undo.Create( "pewpew" )
		undo.AddEntity( ent )
		undo.SetPlayer( ply )
	undo.Finish()
	
	self:EmitSound( self.Bullet.FireSound[1] )
	if WireLib then
		WireLib.TriggerOutput( self.Entity, "Last Fired", ent or nil )
		WireLib.TriggerOutput( self.Entity, "Last Fired EntID", ent:EntIndex() or 0 )
	end
end

pewpew:AddWeapon( BULLET )
