-- Star Wars Laser Hit effect
-- Made by Divran

function EFFECT:Init( data ) 
 	self.vOffset = data:GetOrigin()
	local dir = data:GetNormal()
	local emitter = ParticleEmitter( self.vOffset )

	for i=1,25 do	
		
		-- Thanks to Techni for these equations
		local n = 360/25*i
		local Vec = Vector(math.sin(n),math.cos(n),0)

		-- Fucks up if it hits a perfectly vertical wall..
		if (dir.z == 0) then
			Vec = Vector(math.sin(n),0,math.cos(n))
		end
		
		--local ang = Angle(math.acos(dir.z),0,math.acos(dir.z))
		--Vec:Rotate(ang)
		
		local CurDir = (Vec:Cross(dir)):GetNormalized()
		
		local particle = emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset + dir * 5 )
		particle:SetVelocity( dir + CurDir * 100 )
		particle:SetLifeTime( 0 )
		particle:SetDieTime( 1 )
		particle:SetStartAlpha( 255 )
		particle:SetEndAlpha( 0 )
		particle:SetStartSize( 5 )
		particle:SetEndSize( 20 )
		particle:SetAirResistance( 50 )
		particle:SetColor( 60, 60, 200 )
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

 