--------------------------------------------------------
-- Compatibility
-- Since there may be code changes in later versions of PewPew, 
-- older weapons might break over time
-- This file provides compatibility with previous versions,
-- to make all weapons work, no matter how old.
-- If a weapon's version is nil, it is version 1.0.
--------------------------------------------------------

pewpew.Compatibility = {}

pewpew.Compatibility[1] = function( self, weapon ) -- Make weapons at version 1 work with the latest PewPew version
	-- Convert blast damage multiplier
	if (weapon.RangeDamageMul) then
		weapon.RangeDamageMul = 3-(1-weapon.RangeDamageMul)*2
	end
	
	-- Convert gravity
	if (weapon.Gravity and weapon.Gravity != 0) then
		weapon.Gravity = weapon.Gravity * (1/self.ServerTick)
	end
	weapon._Gravity = weapon.Gravity * pewpew.ServerTick ^ 2
	
	-- Convert Speed
	--if (weapon.Speed and type(weapon.Speed) == "number") then
	--	weapon.Speed = weapon.Speed * (1/pewpew.ServerTick)
	--end
	
	-- Convert functions
	if (weapon.WireInputOverride == true and weapon.WireInput) then
		weapon.WireInputOverride = nil
	end
	
	if (weapon.FireOverride == true and weapon.Fire) then
		weapon.FireOverride = nil
	end
	
	if (weapon.InitializeOverride == true and weapon.InitializeFunc) then
		weapon.InitializeOverride = nil
		weapon.Initialize = weapon.InitializeFunc
		weapon.InitializeFunc = nil
	end
	
	if (weapon.CannonThinkOverride == true and weapon.CannonThinkFunc) then
		weapon.CannonThinkOverride = nil
		weapon.CannonThink = weapon.CannonThinkFunc
		weapon.CannonThinkFunc = nil
	end
	
	if (weapon.ThinkOverride == true and weapon.ThinkFunc) then
		weapon.ThinkOverride = nil
		weapon.Think = weapon.ThinkFunc
		weapon.ThinkFunc = nil
	end
	
	if (weapon.ExplodeOverride == true and weapon.Explode) then
		weapon.ExplodeOverride = nil
	end
	
	if (weapon.CannonPhysicsCollideOverride == true and weapon.CannonPhysicsCollideFunc) then
		weapon.CannonPhysicsCollideOverride = nil
		weapon.CannonPhysicsCollide = weapon.CannonPhysicsCollideFunc
		weapon.CannonPhysicsCollideFunc = nil
	end
	
	if (weapon.CannonTouchOverride == true and weapon.CannonTouchFunc) then
		weapon.CannonTouchOverride = nil
		weapon.CannonTouch = weapon.CannonTouchFunc
		weapon.CannonTouchFunc = nil
	end
	
	if (weapon.PhysicsCollideOverride == true and weapon.PhysicsCollideFunc) then
		weapon.PhysicsCollideOverride = nil
		weapon.PhysicsCollide = weapon.PhysicsCollideFunc
		weapon.PhysicsCollideFunc = nil
	end
	
	if (weapon.CLInitializeOverride == true and weapon.CLInitializeFunc) then
		weapon.CLInitializeOverride = nil
		weapon.CLInitialize = weapon.CLInitializeFunc
		weapon.CLInitializeFunc = nil
	end
	
	if (weapon.CLCannonInitializeOverride == true and weapon.CLCannonInitializeFunc) then
		weapon.CLCannonInitializeOverride = nil
		weapon.CLCannonInitialize = weapon.CLCannonInitializeFunc
		weapon.CLCannonInitializeFunc = nil
	end
	
	if (weapon.CLThinkOverride == true and weapon.CLThinkFunc) then
		weapon.CLThinkOverride = nil
		weapon.CLThink = weapon.CLThinkFunc
		weapon.CLThinkFunc = nil
	end
	
	if (weapon.CLCannonThinkOverride == true and weapon.CLCannonThinkFunc) then
		weapon.CLCannonThinkOverride = nil
		weapon.CLCannonThink = weapon.CLCannonThinkFunc
		weapon.CLCannonThinkFunc = nil
	end
	
	if (weapon.CLDrawOverride == true and weapon.CLDrawFunc) then
		weapon.CLDrawOverride = nil
		weapon.CLDraw = weapon.CLDrawFunc
		weapon.CLDrawFunc = nil
	end

	if (weapon.CLCannonDrawOverride == true and weapon.CLCannonDrawFunc) then
		weapon.CLCannonDrawOverride = nil
		weapon.CLCannonDraw = weapon.CLCannonDrawFunc
		weapon.CLCannonDrawFunc = nil
	end
end

pewpew.Compatibility[0] = pewpew.Compatibility[1]

pewpew.Compatibility[2] = function( self, weapon )
	//print("hello")
	if (!weapon.Gravity) then -- Add gravity to be used by the E2 functions and client side menus, if weapon.Gravity is nil.
		//print("gravity didnt exist")
		weapon._Gravity = 600 * pewpew.ServerTick ^ 2
	else -- Add gravity to be used by the E2 functions and client side menus, if the weapon uses a custom gravity value
		//print("gravity existed")
		weapon._Gravity = weapon.Gravity * pewpew.ServerTick ^ 2
	end
	//print("_gravity: " .. pewpew._Gravity)
end

function pewpew:MakeCompatible( weapon )
	if (!weapon.Version) then 
		weapon.Version = 0
	end
	if (pewpew.Compatibility[weapon.Version]) then
		pewpew.Compatibility[weapon.Version]( pewpew, weapon )
	end
end

local function temp()
	if (pewpew.ServerTick and pewpew.ServerTick != 0) then
		for k,v in ipairs( pewpew.Weapons ) do 
			pewpew:MakeCompatible( v ) 
		end 
	else
		timer.Simple( 1, temp ) -- The timer is here to let pewpew.ServerTick load
	end
end

hook.Add("Initialize","PewPew_Compatibility_Modifying",temp)