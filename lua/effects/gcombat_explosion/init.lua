
 local matLight	 = Material( "white_outline" )
   
   util.PrecacheSound( "weapons/explode3.wav" )
   util.PrecacheSound( "weapons/explode4.wav" )
   util.PrecacheSound( "weapons/explode5.wav" )
   
 /*--------------------------------------------------------- 
    Initializes the effect. The data is a table of data  
    which was passed from the server. 
 ---------------------------------------------------------*/ 
 function EFFECT:Init( data ) 
 	 
 	// This is how long the spawn effect  
 	// takes from start to finish. 
 	self.Time = 0.1
 	self.LifeTime = CurTime() + self.Time 
	
 	self.expl = {}
	self.expl[1] = "weapons/explode3.wav"
	self.expl[2] = "weapons/explode4.wav"
	self.expl[3] = "weapons/explode3.wav"
 	self.vOffset = data:GetOrigin()
	
 	self.Entity:SetModel( "models/Combine_Helicopter/helicopter_bomb01.mdl" ) 
 	self.Entity:SetPos( self.vOffset ) 
	sound.Play( self.expl[ math.random(1,3) ], self.vOffset)
	self.emitter = ParticleEmitter( self.vOffset ) 	
 end 
   
   
 /*--------------------------------------------------------- 
    THINK 
    Returning false makes the entity die 
 ---------------------------------------------------------*/ 
 function EFFECT:Think( ) 
   
   local NumParticles = 4	 
 	self.emitter = ParticleEmitter( self.vOffset ) 
 	 
 		for i=0, NumParticles do 
 		 
 			local particle = self.emitter:Add( "effects/spark", self.vOffset ) 
 			if (particle) then 
 				 
 				particle:SetVelocity( VectorRand() * math.Rand(0, 1400) ) 
 				 
 				particle:SetLifeTime( 0 ) 
 				particle:SetDieTime( math.Rand(0, 0.6) ) 
 				 
 				particle:SetStartAlpha( 255 ) 
 				particle:SetEndAlpha( 0 ) 
 				 
 				particle:SetStartSize( 30 ) 
 				particle:SetEndSize( 0 ) 
 				 
 				particle:SetRoll( math.Rand(0, 360) ) 
 				particle:SetRollDelta( math.Rand(-5, 5) ) 
 				 
 				particle:SetAirResistance( 400 ) 
 				 
 				particle:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
 			end 
			
			local particle1 = self.emitter:Add( "particles/smokey", self.vOffset ) 
 			if (particle1) then 
 				 
 				particle1:SetVelocity( VectorRand() * math.Rand(0, 1400) ) 
 				 
 				particle1:SetLifeTime( 0 ) 
 				particle1:SetDieTime( math.Rand(0, 1) ) 
 				 
 				particle1:SetStartAlpha( 255 ) 
 				particle1:SetEndAlpha( 0 ) 
 				 
 				particle1:SetStartSize( 40 ) 
 				particle1:SetEndSize( 100 ) 
 				 
 				particle1:SetRoll( math.Rand(0, 360) ) 
 				particle1:SetRollDelta( math.Rand(-0.5, 0.5) ) 
 				 
 				particle1:SetAirResistance( 400 ) 
 				 
 				particle1:SetGravity( Vector( 0, 0, 100 ) ) 
 			 
 			end 
 			 
 		end 
 		 
 	return ( self.LifeTime > CurTime() )  
 	 
 end 
   
   
   
 /*--------------------------------------------------------- 
    Draw the effect 
 ---------------------------------------------------------*/ 
 function EFFECT:Render() 
 	 
 	// What fraction towards finishing are we at 
 	local Fraction = (self.LifeTime - CurTime()) / self.Time 
 	Fraction = math.Clamp( Fraction, 0, 1 ) 
 	
	self.Entity:SetColor( Color(255, 255, 255, 255 * Fraction) )
	self.Entity:SetRenderMode(RENDERMODE_TRANSALPHA)
	self.Entity:SetModelScale( 10 * (1 - Fraction), 0 )
	
 		// Draw our model with the Light material 
 		render.MaterialOverride( matLight ) 
 			self.Entity:DrawModel() 
 		render.MaterialOverride( 0 ) 
 
   
 end  