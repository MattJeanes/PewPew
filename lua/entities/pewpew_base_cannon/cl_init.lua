include('shared.lua')

function ENT:Initialize()
	self.Bullet = pewpew:GetWeapon(self.Entity:GetNWString("BulletName"))
	if (self.Bullet) then
		if (self.Bullet.CLCannonInitialize) then
			self.Bullet.CLCannonInitialize(self)
		end
	end
end

function ENT:Draw()
	if (self.Bullet and self.Bullet.CLCannonDraw) then
		self.Bullet.CLCannonDraw(self)
	else
		self.Entity:DrawModel()
		Wire_Render(self.Entity)
	end
end
 
function ENT:Think()
	if (self.Bullet) then
		if (self.Bullet.CLCannonThink) then
			return self.Bullet.CLCannonThink(self)
		end
		
		if (self.Bullet.Reloadtime and self.Bullet.Reloadtime < 0.5) then
			-- Run more often!
			self.Entity:NextThink(CurTime())
			return true
		end
	end
end