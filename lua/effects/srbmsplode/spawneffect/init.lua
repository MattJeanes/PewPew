EFFECT.r = math.random(1, 255)
EFFECT.b = math.random(1, 255)
EFFECT.g = math.random(1, 255)

function EFFECT:Init( data )
	local NumParticles = 0
	local Pos = data:GetOrigin()
	local emitter = ParticleEmitter( Pos )
		for i= 0, 4 do
			local vel = (VectorRand()*20) * math.Rand( 0.001, 0.2 )
			vel.z = -((vel.x*vel.x) + (vel.y*vel.y))
			local particle = emitter:Add( "effects/yellowflare", Pos + VectorRand()*16 )
				particle:SetVelocity( vel )
				particle:SetDieTime( math.Rand( 2, 5 ) )
				particle:SetStartAlpha( 250 )
				particle:SetEndAlpha( 250 )
				particle:SetStartSize( 32 )
				particle:SetEndSize( 0 )
				particle:SetRoll( math.Rand( 0, 360 ) )
				particle:SetRollDelta( math.Rand( -5.5, 5.5 ) )
				particle:SetColor( self.r, self.b, self.g )	
		end
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()	
end



