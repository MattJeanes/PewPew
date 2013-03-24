
 local matLight	 = Material( "w=" )
   
   local matLight2			= Material( "sprites/splodesprite" )
   
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 5
 	self.LifeTime = CurTime() + self.Time 
	
 	self.vOffset = data:GetOrigin()
	
	self.emitter = ParticleEmitter( self.vOffset )
	
		for i=0, (25) do
		
			local Pos = VectorRand():GetNormalized()
		
			local particle = self.emitter:Add( "particles/smokey", self.vOffset + Pos * math.Rand(100, 300 ))
			if (particle) then
				particle:SetVelocity( Pos * math.Rand(50, 75) )
				particle:SetLifeTime( 0 )
				particle:SetDieTime( math.Rand( 45, 45 ) )
				particle:SetStartAlpha( math.Rand( 200, 255 ) )
				particle:SetEndAlpha( 0 )
				particle:SetStartSize( 700 )
				particle:SetEndSize( 600 )
				particle:SetRoll( math.Rand(0, 360) )
				particle:SetRollDelta( math.Rand(-0.2, 0.2) )
				particle:SetColor( 255 , 255 , 255 )
			end
			
			local vec = VectorRand()
			
			local particle1 = self.emitter:Add( "particles/flamelet"..math.random(1,5), self.vOffset + vec * math.Rand(300,400))
			if (particle1) then
				particle1:SetVelocity(vec * -400 )
				particle1:SetLifeTime( 0 )
				particle1:SetDieTime( 0.01 )
				particle1:SetStartAlpha( math.Rand( 0, 0 ) )
				particle1:SetEndAlpha( 0 )
				particle1:SetStartSize( 500 )
				particle1:SetEndSize( 30 )
				particle1:SetRoll( math.Rand(0, 360) )
				particle1:SetRollDelta( math.Rand(-10, 10) )
				particle1:SetColor( 0 , 0 , 0 ) 
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
 	 
 	// What fraction towards finishing are we at 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp( Fraction, 0, 1 ) 
 	
	self.Entity:SetColor( 0, 0, 0, 0 * Fraction )
	self.Entity:SetModelScale( Vector() * 100 * (1 - Fraction) )
	
 		// Draw our model with the Light material 
 		SetMaterialOverride( matLight ) 
 			self.Entity:DrawModel() 
 		SetMaterialOverride( 0 ) 
 
   
 end  