-- Made by Divran

EFFECT.Mat = Material( "cable/cable2" )
/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )
	self.StartPos 	= data:GetStart()	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	self.TracerTime = 0.2
	self.Size = 3
	// Die when it reaches its target
	self.DieTime = CurTime() + self.TracerTime
end

/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

	if ( CurTime() > self.DieTime ) then
		return false 
	end
	
	return true

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render( )	
	self.Size = math.max( self.Size - 0.1, 2 )
	render.SetMaterial( self.Mat )
	render.DrawBeam( self.EndPos, 		
					 self.StartPos,
					 self.Size,					
					 0,					
					 0,				
					 Color( 0, 255, 0, 255 ) )
					 
end
