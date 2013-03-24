-- Made by Divran

EFFECT.Mat = Material( "cable/redlaser" )
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Ent	 	= data:GetEntity()
	
	if (!self.Ent:IsValid()) then return false end
	
	self.Dir 		= self.EndPos - self.StartPos
	self.LocalStartPos   = self.Ent:WorldToLocal(self.StartPos)
	self.LocalEndPos = self.Ent:WorldToLocal(self.EndPos)
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	
	// Die when it reaches its target
	self.DieTime = CurTime() + 0.1
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if self.DieTime and ( CurTime() > self.DieTime ) then
		return false 
	end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )
	local Pos = self.StartPos
	local EPos = self.EndPos
	if (self.Ent:IsValid()) then
		Pos = self.Ent:LocalToWorld(self.LocalStartPos)
		EPos = self.Ent:LocalToWorld(self.LocalEndPos)
	end
	
	render.SetMaterial( self.Mat )
	render.DrawBeam( Pos, 		
					 EPos,
					 20,					
					 0,					
					 0,				
					 Color( 255, 255, 255, 255 ) )	 
end
