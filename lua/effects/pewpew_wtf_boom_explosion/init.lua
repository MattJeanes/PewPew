

EFFECT.Mat = Material( "effects/select_ring" )

/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	local vOffset = data:GetOrigin()
	local emitter = ParticleEmitter( Vector(0,0,0) )
	NumParticles = 200
	
	-- Shock wave
	for i=0, 180 do
		local Deg = (360/180)*i
		local particle = emitter:Add( "particles/smokey", vOffset + Vector(0,0,100))
		if (particle) then
			particle:SetVelocity( Vector( math.cos(Deg), math.sin(Deg), 0) * 8000 + VectorRand() * 200 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 8, 10 ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 800 )
			particle:SetEndSize( 100 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 45 , 45 , 45 )
			particle:SetAirResistance( 100 )
		end
		particle = emitter:Add( "particles/smokey", vOffset + Vector(0,0,100))
		if (particle) then
			particle:SetVelocity( (Vector( math.cos(Deg+45), math.sin(Deg+45),0)) * 6500 + VectorRand() * 100 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 8, 10 ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 800 )
			particle:SetEndSize( 100 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-0.2, 0.2) )
			particle:SetColor( 45 , 45 , 45 )
			particle:SetAirResistance( 100 )
		end
	end
	
	-- Pillar
	for h=0, 6 do
		for i=0, 10 do
			local Deg = math.Rand(0,360)
			local particle = emitter:Add( "particles/flamelet"..math.random(1,5), vOffset + Vector( math.cos(Deg)*math.Rand(0,500), math.sin(Deg)*math.Rand(0,500), h * 250))
			if (particle) then
				particle:SetVelocity( Vector(0,0,0) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 8, 10 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 320 )
				particle:SetEndSize( 100 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-2, 2) )
				particle:SetColor( 255 , 100 , 100 )
			end
		end
	end
	
	-- Tip
	for i=0, 80 do
		local Pos = VectorRand()
		Pos.z = math.Rand(0,1)
		local particle = emitter:Add( "particles/flamelet"..math.random(1,5), vOffset + Vector( 0,0, 2000))
		if (particle) then
			particle:SetVelocity( Pos * 2000 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand( 8, 10 ) )
			particle:SetStartAlpha( math.Rand( 200, 255 ) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 600 )
			particle:SetEndSize( 300 )
			particle:SetRoll( math.Rand(0, 360) )
			particle:SetRollDelta( math.Rand(-2, 2) )
			particle:SetColor( 255 , 100 , 100 )
			particle:SetAirResistance( 40 )
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
