-- Made by Divran

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	local pos = data:GetOrigin()
	local norm = data:GetNormal()
	local NumParticles = 15
	
	local emitter = ParticleEmitter( Vector(0,0,0) )
	
	for i=0, NumParticles do
		local particle = emitter:Add( "particles/smokey", pos )
		if (particle) then
			local vec = norm + VectorRand() * 2 + Vector(0,0,math.Rand(0.1,1))
			particle:SetVelocity( vec * 500 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( 3 )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( math.Rand(200,300) )
			particle:SetEndSize( math.Rand(160,200) )
			particle:SetColor( 75,75,75 )
			particle:SetRoll( math.Rand(0, 5) )
			particle:SetRollDelta( 0 )
			particle:SetAirResistance( 200 )
			particle:SetGravity( Vector(0,7,-50) )
		end
		local particle2 = emitter:Add( "particles/flamelet"..math.random(1,5), pos )
		if (particle2) then
			local vec = norm + VectorRand() + Vector(0,0,math.Rand(0.1,2))
			particle2:SetVelocity( vec * 400 )
			particle2:SetLifeTime( 0 )
			particle2:SetDieTime( 4 )
			particle2:SetStartAlpha( 100 )
			particle2:SetEndAlpha( 0 )
			particle2:SetStartSize( 70 )
			particle2:SetEndSize( 40 )
			particle2:SetColor( 255,150,150 )
			particle2:SetRoll( math.Rand(0, 4) )
			particle2:SetRollDelta( 0 )
			particle2:SetAirResistance( 200 )
			particle2:SetGravity( Vector(0,5,-40) )
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
