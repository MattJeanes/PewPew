include('shared.lua')

function ENT:Initialize()
	self.Bullet = nil
end

function ENT:Draw()      
	self.Entity:DrawModel()
	Wire_Render(self.Entity)
end
