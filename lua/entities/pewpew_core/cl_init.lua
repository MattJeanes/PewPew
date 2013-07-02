include('shared.lua')

function ENT:Initialize()
	self.Bullet = nil
end

function ENT:Draw()      
	self.Entity:DrawModel()
	if WireLib then
		Wire_Render(self.Entity)
	end
end
