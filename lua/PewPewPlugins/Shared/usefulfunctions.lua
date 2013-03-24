-- Useful functions
------------------------------------------------------------------------------------------------------------

-- FindInCone (Note: copied from E2 then edited)
 function pewpew:FindInCone( Pos, Dir, Dist, Degrees )
	local found = ents.FindInSphere( Pos, Dist )
	local ret = {}

	local cosDegrees = math.cos(math.rad(Degrees))
	
	for _, v in pairs( found ) do
		if (Dir:Dot( ( v:GetPos() - Pos):GetNormalized() ) > cosDegrees) then
			ret[#ret+1] = v
		end	
	end
	
	return ret	
end

-- Get the fire direction
function pewpew:GetFireDirection( Index, Ent, Bullet )
	if (!Ent or !Ent:IsValid()) then return end
	local Dir
	local Pos
	local boxsize = Ent:OBBMaxs()-Ent:OBBMins()
	local bulletboxsize = Vector(0,0,30)
	
	if (Bullet) then
		bulletboxsize = Bullet:OBBMaxs()-Bullet:OBBMins()
	end
	
	if (Index == 1) then -- Up
		Dir = Ent:GetUp()
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.z/2+bulletboxsize.z/2)
	elseif (Index == 2) then -- Down
		Dir = Ent:GetUp() * -1
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.z/2+bulletboxsize.z/2)
	elseif (Index == 3) then -- Left
		Dir = Ent:GetRight() * -1
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.y/2+bulletboxsize.y/2)
	elseif (Index == 4) then -- Right
		Dir = Ent:GetRight()
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.y/2+bulletboxsize.y/2)
	elseif (Index == 5) then -- Forward
		Dir = Ent:GetForward()
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.x/2+bulletboxsize.x/2)
	elseif (Index == 6) then -- Back
		Dir = Ent:GetForward() * -1
		Pos = Ent:LocalToWorld(Ent:OBBCenter()) + Dir * (boxsize.x/2+bulletboxsize.x/2)
	end
	
	return Dir, Pos
end
