
 local matLight= Material( "white_outline" )
   
 local matLight2= Material( "sprites/splodesprite" )
   
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 1
 	self.LifeTime = CurTime() + self.Time 
	
 	self.vOffset = data:GetOrigin()
	
	self.emitter = ParticleEmitter( self.vOffset )
	
		for i=0, (100) do
		
			local Pos = VectorRand():GetNormalized()
			local vec = VectorRand()
			
			//Really needs some work to look more impressive...
			local particle1 = self.emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset + vec * math.Rand(75,125))
			if (particle1) then
				particle1:SetVelocity(vec * -700 )
				particle1:SetLifeTime(0)
				particle1:SetDieTime(1.5)
				particle1:SetStartAlpha(math.Rand( 200, 255 ))
				particle1:SetEndAlpha(0)
				particle1:SetStartSize(75)
				particle1:SetEndSize(15)
				particle1:SetGravity(Vector(0,0,-600))
				particle1:SetRoll(math.Rand(0, 360))
				particle1:SetRollDelta(math.Rand(-10, 10))
				particle1:SetColor(255 , 255 , 255) 
			end
			
		end
		
	self.emitter:Finish()
	
 	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" ) 
 	self.Entity:SetPos( self.vOffset )  
 end 
   
   
 /*--------------------------------------------------------- 
    THINK 
    Returning false makes the entity die 
 ---------------------------------------------------------*/ 
 function EFFECT:Think( ) 
   
 	return ( self.LifeTime > CurTime() )  
 	 
 end 
   
   
   
 /*--------------------------------------------------------- 
    Draw the effect 
 ---------------------------------------------------------*/ 
 function EFFECT:Render() 
 end  