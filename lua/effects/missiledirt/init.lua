
/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )

local startpos = self.Position
	self.smokeparticles = {}
	local rVec = VectorRand()*5	
	local vOffset = data:GetOrigin() 

 	local emitter = ParticleEmitter( vOffset ) 
 	 
 		for i=0, 35 do 
 		 
 			local particle = emitter:Add( "particles/smokey", vOffset ) 
 			if (particle) then 
 				 
 				particle:SetVelocity( VectorRand() * math.Rand(0, 200) ) 
 				 
 				particle:SetLifeTime( 0 ) 
 				particle:SetDieTime( math.Rand(6, 10) ) 
 				 
 				particle:SetStartAlpha( 255 ) 
 				particle:SetEndAlpha( 75 ) 
 				 
 				particle:SetStartSize( 420 ) 
 				particle:SetEndSize( 10 ) 
 				 
 				particle:SetRoll( math.Rand(0, 360) ) 
 				particle:SetRollDelta( math.Rand(-5, 5) ) 
				
				particle:SetColor( 65, 65, 65)
 				 
 				particle:SetAirResistance( 5 ) 
 				 
 				particle:SetGravity( Vector( 0, 0, -50 ) ) 
 			 
 			end 
			
		end 

		for i=0, 35 do
				
			local particle1 = emitter:Add( "particle/particle_composite", vOffset + Vector( math.random( -400, 400 ), math.random( -400, 400 ), math.random( -100, 400 ) ) )
			if (particle1) then 
				particle1:SetVelocity( Vector( 0, 0, -100 ) )			
				particle1:SetDieTime( math.random( 10, 20 ) ) 			
				particle1:SetStartAlpha( math.random( 40, 255 ) ) 			
				particle1:SetStartSize( math.random( 220, 280 ) ) 			
				particle1:SetEndSize( math.random( 280, 320 ) ) 
				particle1:SetEndAlpha( math.random( 25, 100 ) ) 			
				particle1:SetRoll( 0 )			
				particle1:SetRollDelta( 0 ) 			
				particle1:SetColor( 45, 45, 45) 			
				particle1:VelocityDecay( true )
			end			  
		end

		for i=0, 20 do
				
			local particle2 = emitter:Add( "particles/smokey", vOffset + Vector( math.random( -400, 400 ), math.random( -400, 400 ), math.random( -100, 400 ) ) )
			if (particle2) then 
				particle2:SetVelocity( Vector( 0, 0, -100 ) )			
				particle2:SetDieTime( math.random( 1, 5 ) ) 			
				particle2:SetStartAlpha( math.random( 40, 255 ) ) 			
				particle2:SetStartSize( math.random( 120, 180 ) ) 			
				particle2:SetEndSize( math.random( 180, 220 ) ) 
				particle2:SetEndAlpha( math.random( 25, 100 ) ) 			
				particle2:SetRoll( 0 )			
				particle2:SetRollDelta( 0 ) 			
				particle2:SetColor( 125, 85, 35) 			
				particle2:VelocityDecay( true )
			end			  
		end
 		 
 	emitter:Finish() 

end


/*---------------------------------------------------------
   THINK
---------------------------------------------------------*/
function EFFECT:Think( )

end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()

end