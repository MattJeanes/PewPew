include('shared.lua')

function ENT:Initialize()
	self.Bullet = pewpew:GetWeapon(self.Entity:GetNWString("BulletName"))
	if (self.Bullet) then
		if (self.Bullet.CLInitialize) then
			self.Bullet.CLInitialize(self)
		end
	end
end

function ENT:Draw()
	if (self.Bullet and self.Bullet.CLDraw) then
		self.Bullet.CLDraw(self)
	else
		self.Entity:DrawModel()
	end
end
 
function ENT:Think()
	if (self.Bullet) then
		if (self.Bullet.CLThink) then
			return self.Bullet.CLThink(self)
		end
		
		if (self.Bullet.Reloadtime < 0.5) then
			-- Run more often!
			self.Entity:NextThink(CurTime())
			return true
		end
	end
end