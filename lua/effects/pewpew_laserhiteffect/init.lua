
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	self.vOffset = data:GetOrigin()
	local dir = data:GetNormal()
	local emitter = ParticleEmitter( self.vOffset )
	
	local particle = emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset + dir * 2 )
	particle:SetLifeTime( 0 )
	particle:SetDieTime( 0.2 )
	particle:SetStartAlpha( 255 )
	particle:SetEndAlpha( 50 )
	particle:SetStartSize( 50 )
	particle:SetEndSize( 0 )
	particle:SetColor( 200, 30, 30 )

	emitter:Finish() 
 end 
   
   
/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )
	return false
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end

 