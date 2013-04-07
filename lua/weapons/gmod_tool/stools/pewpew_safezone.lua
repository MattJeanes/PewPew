
-- Pew Safe Zone
-- This tool spawns PewPew Safe Zones

TOOL.Category = "PewPew"
TOOL.Name = "PewPew Safe Zone"
TOOL.ClientConVar[ "model" ] = "models/Combine_Helicopter/helicopter_bomb01.mdl"

cleanup.Register("pewpew_safezones")

local PewPewModels = {
	["models/Combine_Helicopter/helicopter_bomb01.mdl"] = {},
	["models/props_junk/TrafficCone001a.mdl"] = {},
	["models/props_lab/huladoll.mdl"] = {},
	["models/props_combine/breenlight.mdl"] = {},
	["models/props_c17/pottery03a.mdl"] = {},
	["models/Combine_Helicopter/helicopter_bomb01.mdl"] = {}
}


-- This needs to be shared...
function TOOL:GetZoneModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/Combine_Helicopter/helicopter_bomb01.mdl" end
	return mdl
end
						
if (SERVER) then
	CreateConVar("sbox_maxpewpew_safezones", 2)

	function TOOL:CreateZone( ply, trace, model )
		local ent = ents.Create( "pewpew_safezone" )
		if (!ent:IsValid()) then return end
		ent:SetModel( model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:Spawn()
		ent:Activate()
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		if (!WireLib) then ply:ChatPrint("Wiremod is not installed.") return end
		if (!ply:CheckLimit("pewpew_safezones")) then return end
		local model = self:GetZoneModel()
		if (!model) then return end
		local ent = self:CreateZone( ply, trace, model )
		if (!ent) then return end
		
		local traceent = trace.Entity
					
		if (!traceent:IsWorld() and !traceent:IsPlayer()) then
			local weld = constraint.Weld( ent, trace.Entity, 0, trace.PhysicsBone, 0 )
			local nocollide = constraint.NoCollide( ent, trace.Entity, 0, trace.PhysicsBone )
		end
			
		ply:AddCount("pewpew_safezones",ent)
		ply:AddCleanup ( "pewpew_safezones", ent )

		undo.Create( "pewpew_safezone" )
			undo.AddEntity( ent )
			undo.AddEntity( weld )
			undo.AddEntity( nocollide )
			undo.SetPlayer( ply )
		undo.Finish()
	end
	
	function TOOL:RightClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()

		if (!ply:CheckLimit("pewpew_safezones")) then return end
		local model = self:GetZoneModel()
		if (!model) then return end
		local ent = self:CreateZone( ply, trace, model )
		if (!ent) then return end
		
		ply:AddCount("pewpew_safezones",ent)
		ply:AddCleanup ( "pewpew_safezones", ent )

		undo.Create( "pewpew_safezone" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
	end

	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and IsValid(trace.Entity)) then
				self:GetOwner():ConCommand("pewpew_safezone_model " .. trace.Entity:GetModel())
				self:GetOwner():ChatPrint("PewPew Safe Zone model set to: " .. trace.Entity:GetModel())
			end
		end
	end	
else
	language.Add( "Tool.pewpew_safezone.name", "PewPew Safe Zones" )
	language.Add( "Tool.pewpew_safezone.desc", "Used to spawn PewPew Safe Zone." )
	language.Add( "Tool.pewpew_safezone.0", "Primary: Spawn a PewPew Safe Zone and weld it, Secondary: Spawn a PewPew Safe Zone and don't weld it, Reload: Change the model of the Safe Zone." )
	language.Add( "undone_pewpew_safezone", "Undone PewPew Safe Zone" )
	language.Add( "Cleanup_pewpew_safezones", "PewPew Safe Zone" )
	language.Add( "Cleaned_pewpew_safezones", "Cleaned up all PewPew Safe Zone" )
	language.Add( "SBoxLimit_pewpew_safezones", "You've reached the PewPew Safe Zone limit!" )
	
	
	function TOOL.BuildCPanel( CPanel )
		-- Header stuff
		CPanel:AddControl("Header", { Text = "#Tool.pewpew_safezone.name", Description = "#Tool.pewpew_safezone.desc" })
		
		-- Models
		CPanel:AddControl("ComboBox", {
			Label = "#Presets",
			MenuButton = "1",
			Folder = "pewpew",

			Options = {
				Default = {
					pewpew_model = "models/Combine_Helicopter/helicopter_bomb01.mdl"
				}
			},

			CVars = {
				[0] = "pewpew_model"
			}
		})
		
		-- (Thanks to Grocel for making this selectable icon thingy)
		CPanel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "pewpew_safezone_model",
			Category = "PewPew",
			Models = PewPewModels
		})
	end

	-- Ghost functions
	function TOOL:UpdateGhostZone( ent, player )
		if (!ent or !ent:IsValid()) then return end
		local trace = player:GetEyeTrace()
		
		if (!trace.Hit or trace.Entity:IsPlayer()) then
			ent:SetNoDraw( true )
			return
		end
		
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		
		ent:SetNoDraw( false )
	end
	
	function TOOL:Think()
		local model = self:GetZoneModel()
		if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model) then
			local trace = self:GetOwner():GetEyeTrace()
			self:MakeGhostEntity( Model(model), trace.HitPos, trace.HitNormal:Angle() + Angle(90,0,0) )
		end
		self:UpdateGhostZone( self.GhostEntity, self:GetOwner() )
	end
end