-- Repair Tool
-- This tool repairs stuff

TOOL.Category = "PewPew"
TOOL.Name = "Repair Tool"
TOOL.ent = {}
						
if (SERVER) then
	AddCSLuaFile("pewpew_repair_tool.lua")
	TOOL.Timer = 0
	
	function TOOL:Think()
		if (CurTime() > self.Timer) then
			local ply = self:GetOwner()
			if (ply:KeyDown( IN_ATTACK )) then
				local trace = ply:GetEyeTrace()
				if (!trace.Hit) then return end
				if (trace.HitPos:Distance(ply:GetShootPos()) < 125 and trace.Entity and pewpew:CheckValid( trace.Entity )) then
					if (trace.Entity:GetClass() == "pewpew_core" and trace.Entity.pewpew and trace.Entity.pewpew.CoreHealth) then
						pewpew:RepairCoreHealth( trace.Entity, pewpew:GetConVar( "RepairToolHealCores" ) )
					elseif (trace.Entity.pewpew and trace.Entity.pewpew.Health) then
						pewpew:RepairHealth( trace.Entity, pewpew:GetConVar( "RepairToolHeal" ) )
					end
					-- Effect
					local effectdata = EffectData()
					effectdata:SetOrigin( trace.HitPos )
					effectdata:SetAngles( trace.HitNormal:Angle() )
					util.Effect( "Sparks", effectdata )
					-- Run slower!
					self.Timer = CurTime() + 0.1
					return true
				end
			end
		end
	end
else
	language.Add( "Tool.pewpew_repair_tool.name", "PewPew Repair Tool" )
	language.Add( "Tool.pewpew_repair_tool.desc", "Used to repair entities." )
	language.Add( "Tool.pewpew_repair_tool.0", "Primary: Hold to repair an entity, Reload: Toggle Health Vision." )
	
	TOOL.HealthVision = true
	TOOL.ReloadTimer = 0
	
	function TOOL:Reload()
		if (CurTime() > self.ReloadTimer) then
			self.HealthVision = !self.HealthVision
			if (self.HealthVision == true) then
				self:GetOwner():ChatPrint("Health Vision on.")
			else
				self:GetOwner():ChatPrint("Health Vision off.")
			end
			self.ReloadTimer = CurTime() + 0.2
		end
	end
	
	function TOOL.BuildCPanel( CPanel )
		local label = vgui.Create("DLabel", pewpew_weaponframe)
		label:SetText([[Usage:
		Aim at an entity and hold 
		down the fire button to heal the entity.
		
		You may notice entities having 
		"?/?" health. This means you CAN 
		change their health by changing its weight.

		If an entity does not have "?/?", 
		but instead has numbers, you CAN NOT 
		change its health by changing its weight.
		
		If you repair the entity to full health, 
		it will become "?/?" and you can 
		change its health using the weight tool again.
		
		You can also toggle the
		health icons using Reload.]])
		label:SizeToContents()
		
		CPanel:AddItem(label)
	end
	
	function TOOL:DrawHUD()
		local ply = self:GetOwner()
		if (!self.HealthVision) then return end
		
		-- Find all nearby entities
		local ents = ents.FindInSphere( ply:GetPos(), 2040 )
		for _, ent in pairs( ents ) do
			if (ent:GetMoveType() == MOVETYPE_VPHYSICS and ent:IsValid()) then
				-- Get the health and maxhealth
				local hp = ent:GetNWInt( "pewpewHealth" )
				local maxhealth = ent:GetNWInt( "pewpewMaxHealth" )
				-- Create vars
				local percent = 100
				local hp2 = "?"
				local maxhealth2 = "?"
				-- Check if valid
				if (hp and hp > 0 and maxhealth and maxhealth > 0) then
					-- Calculate percent
					percent = math.Round(hp / maxhealth * 100)
					hp2 = math.Round(hp)
					maxhealth2 = math.Round(maxhealth)
				end
				-- Create string
				local pos = ent:GetPos():ToScreen()
				local dist = ent:GetPos():Distance(ply:GetShootPos())
				local txt =  percent .. "% (" .. hp2 .. "/" .. maxhealth2 .. ")"
				surface.SetFont("DermaDefault")
				local length = surface.GetTextSize(txt)
				-- Draw string
				draw.WordBox( 6, pos.x - length / 2, pos.y + 20, txt, "DermaDefault", Color( 255 * (1-percent/100), 255 * (percent/100), 0, math.Clamp(2040-dist,0,255) ), Color( 50, 50, 50, math.Clamp(2040-dist,0,255) ) )
			end
		end
	end
end