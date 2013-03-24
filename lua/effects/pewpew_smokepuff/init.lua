-- Smokepuff, made by Divran

function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local NumParticles = 32
	
	local emitter = ParticleEmitter( Pos )
	
	for i=0, NumParticles do
		particle = emitter:Add( "particles/smokey", Pos )
		if (particle) then
			particle:SetVelocity( VectorRand() * 2000 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand(2,3) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( math.Rand(10,80) )
			particle:SetStartSize( math.Rand(50,150) )
			particle:SetEndSize( math.Rand(200,400) )
			particle:SetColor( 70,70,70 )
			particle:SetRoll( math.Rand(-1,1) )
			particle:SetAirResistance( 500 )
			particle:SetGravity( Vector( 0,0,-500) )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end
