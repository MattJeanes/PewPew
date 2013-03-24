
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
	
 	
 	self.vOffset = data:GetOrigin()
	local dir = data:GetNormal()
	local emitter = ParticleEmitter( self.vOffset )
		for i=0, (8) do
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset + (dir * 10 * i))
			if (particle) then
				particle:SetVelocity((dir * 60 * i) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( 0.1 )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 17 - 1 * i )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-40, 40) )
				particle:SetColor( 255 , 218 , 97 )
			end
		end
		
		for i=0, 2 do
		
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ):GetNormalized() 
		
			local particle = emitter:Add( "particles/smokey", self.vOffset + dir * math.Rand(10, 40 ))
			if (particle) then
				particle:SetVelocity(VectorRand() * 20 + dir * math.Rand(60,100))
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.5, 0.5 ) )
				particle:SetStartAlpha( math.Rand( 20, 40 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 50 )
				particle:SetEndSize( 5 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-0.2, 0.2) )
				
				particle:SetAirResistance( 20 ) 
 				 
 				particle:SetGravity( Vector( 0, 0, 4 ) ) 
				
				particle:SetColor( 255 , 255 , 255 ) 
			end
			
		end
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

 