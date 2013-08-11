E2Lib.RegisterExtension("pewpew", true)

__e2setcost( 5 )

-- Returns 1 if the entity is a PewPew Cannon
e2function number entity:pewIsCannon()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() == "pewpew_base_cannon") then return 1 end
	return 0
end

__e2setcost( 10 )

-- Returns the health of the entity
e2function number entity:pewHealth()
	if (!validPhysics(this)) then return 0 end
	return pewpew:GetHealth( this ) or 0
end

-- Returns the max health of the entity
e2function number entity:pewMaxHealth()
	if (!validPhysics(this)) then return 0 end
	return pewpew:GetMaxHealth( this ) or 0
end

__e2setcost( 15 )

-- Returns the health of the core or the entity's core
e2function number entity:pewCoreHealth()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() == "pewpew_core" and this.pewpew and this.pewpew.CoreHealth) then 
		return this.pewpew.CoreHealth 
	elseif (this.Core and validPhysics(this.Core) and this.Core.pewpew and this.Core.pewpew.CoreHealth) then
		return this.Core.pewpewCoreHealth
	end
	return 0
end

-- Returns the maximum health of the core or the entity's core
e2function number entity:pewCoreMaxHealth()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() == "pewpew_core" and this.pewpew and this.pewpew.CoreMaxHealth) then 
		return this.pewpewCoreMaxHealth 
	elseif (this.Core and validPhysics(this.Core) and this.Core.pewpew and this.Core.pewpew.CoreMaxHealth) then
		return this.Core.pewpew.CoreMaxHealth
	end
	return 0
end

__e2setcost( 10 )

-- Returns the name of the bullet of the cannon
e2function string entity:pewBulletName()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.Name or ""
end

-- Returns the damage
e2function number entity:pewDamage()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Damage or 0
end

e2function number entity:pewDPS()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	local dmg = this.Bullet.Damage * (1/this.Bullet.Reloadtime)
	return dmg or 0
end

-- Returns the amount of ammo
e2function number entity:pewAmmo()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Ammo or 0
end

-- Returns the max ammo
e2function number entity:pewMaxAmmo()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Ammo or 0
end

-- Returns the damage radius
e2function number entity:pewDamageRadius()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Radius or 0
end

-- Returns the number of slices
e2function number entity:pewNumberOfSlices()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.NumberOfSlices or 0
end

-- Returns the max slice distance
e2function number entity:pewSliceDistance()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.SliceDistance or 0
end

-- Returns the reload time
e2function number entity:pewReloadTime()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Reloadtime or 0
end

-- Returns the ammo reload time
e2function number entity:pewAmmoReloadTime()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.AmmoReloadtime or 0
end

-- Returns the spread
e2function number entity:pewSpread()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Spread or 0
end

-- Returns the damage vs players
e2function number entity:pewPlayerDamage()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.PlayerDamage or 0
end

-- Returns the radius vs players
e2function number entity:pewPlayerDamageRadius()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.PlayerDamageRadius or 0
end

-- Returns the speed of the bullet
e2function number entity:pewSpeed()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Speed or 0
end

-- Returns the gravity per second
e2function number entity:pewGravity()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet._Gravity or 0
end

-- Returns the gravity per tick
e2function number entity:pewGravitySec()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.Gravity or 600
end

-- Returns the recoil force
e2function number entity:pewRecoilForce()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	return this.Bullet.RecoilForce or 0
end

-- Returns the damage type
e2function string entity:pewDamageType()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.DamageType or ""
end

-- Returns the author of the bullet
e2function string entity:pewAuthor()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.Author or ""
end

-- Returns the description of the bullet
e2function string entity:pewDescription()
	if (!validPhysics(this)) then return "" end
	if (this:GetClass() != "pewpew_base_cannon") then return "" end
	return this.Bullet.Description or ""
end

-- Returns 1 if the cannon can fire and 0 if not
e2function number entity:pewCanFire()
	if (!validPhysics(this)) then return 0 end
	if (this:GetClass() != "pewpew_base_cannon") then return 0 end
	local ret = 0
	if (this.CanFire) then
		ret = 1
	end
	return ret
end

__e2setcost( 20 )

e2function void entity:pewFire( number fire )
	if (!validPhysics(this)) then return end
	if (this:GetClass() != "pewpew_base_cannon") then return end
	this:InputChange( "Fire", fire )	
end

__e2setcost(1)
e2function number pewBullets()
	return #pewpew.Bullets
end

local function getByUniqueID( id )
	for i=1,#pewpew.Bullets do
		if pewpew.Bullets[i].RemoveTimer == id then return pewpew.Bullets[i] end
	end
end

local BulletInfo = { -- Only strings or numbers
	Name = "s",
	Author = "s",
	Description = "s",
	Speed = "n",
	Gravity = "n",
	RecoilForce = "n",
	Spread = "n",
	DamageType = "s",
	Damage = "n",
	Radius = "n",
	RangeDamageMul = "n",
	NumberOfSlices = "n",
	SliceDistance = "n",
	Duration = "n",
	PlayerDamage = "n",
	PlayerDamageRadius = "n",
	Reloadtime = "n",
	Ammo = "n",
	AmmoReloadtime = "n",
	EnergyPerShot = "n",
}

__e2setcost(10)

e2function table pewBulletInfo( id )
	local t = {n={},ntypes={},s={},stypes={},size=0}
	
	local bullet = getByUniqueID( id )
	if not bullet then return t end
	local WeaponData = bullet.WeaponData
	
	local size = 0
	for infokey,infotype in pairs( BulletInfo ) do
		self.prf = self.prf + 0.1
		if WeaponData[infokey] then
			size = size + 1
			local default = infotype == "n" and 0 or ""
			t.s[infokey] = WeaponData[infokey] or default
			t.stypes[infokey] = infotype
		end
	end
	
	t.size = size
	
	return t
end

e2function table pewBulletInfo( string name )
	local t = {n={},ntypes={},s={},stypes={},size=0}
	
	local WeaponData = pewpew:GetWeapon( name )
	if not WeaponData then return t end
	
	local size = 0
	for infokey,infotype in pairs( BulletInfo ) do
		self.prf = self.prf + 0.1
		if WeaponData[infokey] then
			size = size + 1
			t.s[infokey] = WeaponData[infokey]
			t.stypes[infokey] = infotype
		end
	end
	
	t.size = size
	
	return t
end


__e2setcost(1)
-- Positions & stuff
e2function vector pewBulletPos( id )
	local bullet = getByUniqueID( id )
	if not bullet then return {0,0,0} end
	return bullet.Pos or {0,0,0}
end

e2function vector pewBulletVel( id )
	local bullet = getByUniqueID( id )
	if not bullet then return {0,0,0} end
	return bullet.Vel or {0,0,0}
end

e2function entity pewBulletOwner( id )
	local bullet = getByUniqueID( id )
	if not bullet then return end
	return bullet.Owner
end

e2function entity pewBulletCannon( id )
	local bullet = getByUniqueID( id )
	if not bullet then return end
	return bullet.Cannon
end

__e2setcost(5)
e2function array pewFindByOwner( entity owner )
	if not IsValid( owner ) or not owner:IsPlayer() then return {} end
	local r = {}
	for i=1,#pewpew.Bullets do
		self.prf = self.prf + 0.1
		local bullet = pewpew.Bullets[i]
		if bullet.Owner == owner then
			r[#r+1] = bullet.RemoveTimer
		end
	end
	
	return r
end

e2function array pewFindByCannon( entity cannon )
	if not IsValid( cannon ) or cannon:GetClass() ~= "pewpew_base_cannon" then return {} end
	local r = {}
	for i=1,#pewpew.Bullets do
		self.prf = self.prf + 0.1
		local bullet = pewpew.Bullets[i]
		if bullet.Cannon == cannon then
			r[#r+1] = bullet.RemoveTimer
		end
	end
	
	return r
end


e2function array pewFindInSphere( vector pos, radius )
	local pos = Vector(pos[1],pos[2],pos[3])
	local r = {}
	for i=1,#pewpew.Bullets do
		self.prf = self.prf + 0.1
		local bullet = pewpew.Bullets[i]
		if bullet.Pos:Distance( pos ) <= radius then
			r[#r+1] = bullet.RemoveTimer
		end
	end
	
	return r
end


local function inrange( pos, minpos, maxpos )
	if pos.x < minpos.x then return false end
	if pos.y < minpos.y then return false end
	if pos.z < minpos.z then return false end

	if pos.x > maxpos.x then return false end
	if pos.y > maxpos.y then return false end
	if pos.z > maxpos.z then return false end
	
	return true
end

e2function array pewFindInBox( vector minpos, vector maxpos )
	local minpos = Vector(minpos[1],minpos[2],minpos[3])
	local maxpos = Vector(maxpos[1],maxpos[2],maxpos[3])
	local r = {}
	for i=1,#pewpew.Bullets do
		self.prf = self.prf + 0.1
		local bullet = pewpew.Bullets[i]
		if inrange(bullet.Pos,minpos,maxpos) then
			r[#r+1] = bullet.RemoveTimer
		end
	end
	
	return r
end

__e2setcost(nil)