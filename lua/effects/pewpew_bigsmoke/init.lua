-- Big Smoke effect, made by Divran

 function EFFECT:Init( data ) 
	local Pos = data:GetOrigin()
	
	local emitter = ParticleEmitter( Vector(0,0,0) )
	
	for i=0, 35 do
		local particle = emitter:Add( "particles/smokey", Pos )
		if (particle) then
			local Deg = math.Rand(0,360)
			particle:SetVelocity( Vector(math.cos(Deg)*math.Rand(0,1),math.sin(Deg)*math.Rand(0,1),math.Rand(-0.1,0.8)) * 900 )
			particle:SetLifeTime( 0 )
			particle:SetDieTime( math.Rand(10,15) )
			particle:SetStartAlpha( math.Rand(180,220) )
			particle:SetEndAlpha( 0 )
			particle:SetStartSize( 200 )
			particle:SetEndSize( 1000 )
			particle:SetColor( 255, 255, 255 )
			particle:SetAirResistance( 50 )
		end
	end
	
	emitter:Finish()
end

function EFFECT:Think( )
	return false
end

function EFFECT:Render()
end