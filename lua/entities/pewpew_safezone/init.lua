AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')

function ENT:Initialize()   
	self.Entity:PhysicsInit( SOLID_VPHYSICS )  	
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	
	if WireLib then
		self.Inputs = WireLib.CreateInputs( self.Entity, { "On", "Radius" } )
		self.Outputs = WireLib.CreateOutputs( self.Entity, { "IsOn", "CurrentRadius" } )
	end
	
	self.Radius = self.Radius or 1000
	pewpew:AddSafeZone( Vector(0,0,0), self.Radius, self.Entity )
	self.On = true
	if WireLib then
		WireLib.TriggerOutput( self.Entity, "IsOn", 1 )
		WireLib.TriggerOutput( self.Entity, "CurrentRadius", self.Radius )
	end
	self.ChangeDelay = 0
end

function ENT:SetRadius(radius)
	radius=math.Clamp(tonumber(radius),50,2000)
	if (self.Radius != radius) then
		self.Radius = radius
		pewpew:ModifySafeZone( self.Entity, Vector(0,0,0), self.Radius, self.Entity )
		if WireLib then
			WireLib.TriggerOutput( self.Entity, "CurrentRadius", self.Radius )
		end
		return true
	end
	return false
end

function ENT:TriggerInput( name, value )

	-- Do not allow changes too often
	if (self.ChangeDelay > CurTime()) then return end
	
	if (name == "On") then
		if (value != 0) then -- If value is not 0
			if (!self.On) then -- If currently off
				-- Turn on
				pewpew:AddSafeZone( Vector(0,0,0), self.Radius, self.Entity )
				self.On = true
				if WireLib then
					WireLib.TriggerOutput( self.Entity, "IsOn", 1 )
				end
				self.ChangeDelay = CurTime() + 5
			end
		else -- If value is 0
			if (self.On) then -- If currently on
				-- Turn off
				pewpew:RemoveSafeZone( self.Entity )
				self.On = false
				if WireLib then
					WireLib.TriggerOutput( self.Entity, "IsOn", 0 )
				end
				self.ChangeDelay = CurTime() + 5
			end
		end
	elseif (name == "Radius") then
		local success=self:SetRadius(value)
		if success then
			self.ChangeDelay = CurTime() + 5
		end
	end
	
	if (self.ChangeDelay > CurTime()) then -- If ChangeDelay was set to something higher, color the safe zone red to show that you cannot change its inputs at the moment, then after 5 seconds color it back.
		local _,_,_,a = self:GetColor()
		self:SetColor( 255,0,0,a )
		
		timer.Simple( 5, function( ent ) 
			if (ent and ent:IsValid()) then
				local _,_,_,a = ent:GetColor()
				ent:SetColor( 255,255,255,a )
			end
		end,self)
	end
		
end

function ENT:OnRemove() pewpew:RemoveSafeZone( self.Entity ) end