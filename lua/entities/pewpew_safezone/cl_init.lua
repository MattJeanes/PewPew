include('shared.lua')

function ENT:Draw()      
	self.Entity:DrawModel()
	Wire_Render(self.Entity)
end
