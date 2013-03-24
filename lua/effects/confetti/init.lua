/*---------------------------------------------------------
   Initializes the effect. The data is a table of data 
   which was passed from the server.
---------------------------------------------------------*/
function EFFECT:Init( data )
	
	self.Position = data:GetOrigin()
	local Pos = self.Position
	local Norm = Vector(0,0,2)
	
	Pos = Pos + Norm
 
	local NumParticles = 200
	local emitter = ParticleEmitter(Pos) 
	
	for i=1, (NumParticles) do
		local particle = emitter:Add("sprites/gmdm_pickups/light",Pos) 
		if (particle) then
			local Deg = math.Rand(0,360)
			particle:SetVelocity(Vector(math.cos(Deg)*math.Rand(0,1500),math.sin(Deg)*math.Rand(0,1500),math.Rand(1,1000)))
			particle:SetDieTime(math.random(2,10)) 
			particle:SetStartAlpha(180) 
			particle:SetStartSize(math.random(50,80)) 
			particle:SetEndSize(150) 
			particle:SetRoll(360) 
			particle:SetRollDelta(math.random(-0.6,0.6))
			particle:SetColor(math.Rand(0,255),math.Rand(0,255),math.Rand(0,255)) 
			particle:SetAirResistance(100) 
			particle:SetGravity(Vector(0,0,-600))
		end
	end
end

/*---------------------------------------------------------
   Think
---------------------------------------------------------*/
function EFFECT:Think()
	return false	
end

/*---------------------------------------------------------
   Draw the effect
---------------------------------------------------------*/
function EFFECT:Render()
end



