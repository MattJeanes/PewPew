

EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	

	local vOffset = data:GetOrigin()
	
	self.expl = {}
	self.expl[1] = "weapons/explode3.wav"
	self.expl[2] = "weapons/explode4.wav"
	self.expl[3] = "weapons/explode3.wav"
	
	local Low = vOffset - Vector(32, 32, 32 )
	local High = vOffset + Vector(32, 32, 32 )
	
	WorldSound( self.expl[ math.random(1,3) ], vOffset)
	
	local NumParticles = 200
	
	local emitter = ParticleEmitter( vOffset )
	
		for i=0, (NumParticles / 5) do
		
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ):GetNormalized()
		
			local particle = emitter:Add( "particles/smokey", vOffset + Pos * math.Rand(20, 150 ))
			if (particle) then
				particle:SetVelocity( Pos * math.Rand(50, 100) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 1, 2 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 100 )
				particle:SetEndSize( 200 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-0.2, 0.2) )
				particle:SetColor( 5 , 5 , 5 )
			end
			
		end
		
		for i=0, (NumParticles) do
		
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), 0 ):GetNormalized()
		
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), vOffset + Pos * math.Rand(250, 300 ))
			if (particle) then
				particle:SetVelocity( Pos * math.Rand(300, 1000) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.2, 1 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 1 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				particle:SetColor( 5 , 5 , 5 )
			end
			
		end
		
		for i=0, (NumParticles) do
		
			local Pos = Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(-1,1) ):GetNormalized()
		
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), vOffset + Pos * math.Rand(20, 40 ))
			if (particle) then
				particle:SetVelocity( Pos + Vector( math.Rand(-1,1), math.Rand(-1,1), math.Rand(0,2)):GetNormalized()  * math.Rand(50, 500) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 0.3, 0.6 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 1 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				particle:SetColor( 5 , 5 , 5 )
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
