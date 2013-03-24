

EFFECT.Mat = Material( "cable/blue_elec" )


/*---------------------------------------------------------
   Init( data table )
---------------------------------------------------------*/
function EFFECT:Init( data )

	self.StartPos 	= data:GetStart()	
	
	self.EndPos 	= data:GetOrigin()
	self.Dir 		= self.EndPos - self.StartPos
	local vOffset = self.EndPos
	
	self.fDelta = 3
	
	
	self.Entity:SetRenderBoundsWS( self.StartPos, self.EndPos )
	local effectdata = EffectData()
			effectdata:SetOrigin( self.EndPos + self.Dir:GetNormalized() * -2 )
		util.Effect( "Enersplosion", effectdata )
	
	self.TracerTime = math.Rand( 0.2, 0.3 )
	self.Length = math.Rand( 0.1, 0.15 )
	
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
	self.fDelta = math.Max( self.fDelta - 0.5, 0)
			
	render.SetMaterial( self.Mat )
	
	render.DrawBeam( self.EndPos, 		
					 self.StartPos,
					 2 + self.fDelta * 16,					
					 0,					
					 0,				
					 Color( 255, 0, 0, 255 ) )
					 
end
