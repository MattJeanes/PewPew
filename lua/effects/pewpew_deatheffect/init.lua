-- Made by Divran

function EFFECT:Init( data )
	local Pos = data:GetOrigin()
	local Size = math.Round(data:GetScale())
	local emitter = ParticleEmitter( Pos )
	local clr=VectorRand() * 255
	local nr = math.max(math.Round(Size/15),4)
	for I=1, nr do
		local pos = VectorRand() * Size / 10
		local vel = pos:GetNormal() * Size / 3
		local smoke = emitter:Add( "particles/smokey", Pos + pos )
			smoke:SetVelocity( vel * math.Rand(1,5) )
			smoke:SetAirResistance( 250 )
			smoke:SetDieTime( math.Rand(1.8,2) )
			smoke:SetStartAlpha( 255 )
			smoke:SetEndAlpha( 25 )
			local clr = math.Rand(20,100)
			smoke:SetColor( clr,clr,clr )
			smoke:SetStartSize( math.max(Size/5,20) )
			smoke:SetEndSize( math.max(Size/4.8,50) )
		
		if (I<nr/4) then
			pos = VectorRand() * 2
			vel = pos:GetNormal() * Size / 10
			local flame = emitter:Add( "particles/flamelet"..math.random(1,5), Pos + pos )
				flame:SetVelocity( vel * 2 )
				flame:SetAirResistance( 150 )
				flame:SetDieTime( math.Rand(1.8,2) )
				flame:SetStartAlpha( 100 )
				flame:SetEndAlpha( 0 )
				local clr = math.Rand(100,200)
				flame:SetColor( clr,clr*(2/3),clr*(2/3) )
				flame:SetStartSize( math.max(Size/20,10) )
				flame:SetEndSize( math.max(Size/10,15) )
		end
		
		--[[ OLD EFFECT (pretty colored stars)
		local particle = emitter:Add( "effects/yellowflare", Pos + pos )
			particle:SetVelocity( vel )
			particle:SetDieTime( math.Rand( 1, 3 ) )
			particle:SetStartAlpha( 255 )
			particle:SetEndAlpha( 50 )
			particle:SetStartSize( math.max(Size / 3,50) )
			particle:SetEndSize( math.max(Size / 5,20) )
			particle:SetRoll( math.Rand(90, 360) )
			particle:SetColor( clr.r, clr.g, clr.b )
		]]
	end
	emitter:Finish()
end

function EFFECT:Think() return false end
function EFFECT:Render() end