-- Pew Core
-- This tool spawns PewPew Cores

TOOL.Category = "PewPew"
TOOL.Name = "PewPew Core"
TOOL.ClientConVar[ "model" ] = "models/Combine_Helicopter/helicopter_bomb01.mdl"

cleanup.Register("pewpew_cores")

local PewPewModels = {
	["models/Combine_Helicopter/helicopter_bomb01.mdl"] = {},
	["models/props_combine/combine_interface001.mdl"] = {}, 
	["models/props_combine/combine_interface002.mdl"] = {},
	["models/props_combine/combine_interface003.mdl"] = {},
	["models/props_combine/breenconsole.mdl"] = {},
	["models/props_lab/reciever01b.mdl"] = {},
	["models/props_lab/reciever01a.mdl"] = {},
	["models/props_lab/reciever_cart.mdl"] = {},
	["models/props_lab/securitybank.mdl"] = {},
	["models/props_lab/servers.mdl"] = {},
	["models/props_lab/workspace002.mdl"] = {},
	["models/props_lab/workspace003.mdl"] = {},
	["models/props_lab/workspace004.mdl"] = {},
	["models/props_combine/weaponstripper.mdl"] = {}
}


-- This needs to be shared...
function TOOL:GetCoreModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/Combine_Helicopter/helicopter_bomb01.mdl" end
	return mdl
end
						
if (SERVER) then
	AddCSLuaFile("pewpew_core.lua")
	CreateConVar("sbox_maxpewpew_cores", 6)

	function TOOL:CreateCore( ply, trace, model )
		local ent = ents.Create( "pewpew_core" )
		if (!ent:IsValid()) then return end
		ent:SetOptions( ply )
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
		if (!ply:CheckLimit("pewpew_cores")) then return end
		local model = self:GetCoreModel()
		if (!model) then return end
		local ent = self:CreateCore( ply, trace, model )
		if (!ent) then return end
		
		local traceent = trace.Entity
					
		if (!traceent:IsWorld() and !traceent:IsPlayer()) then
			local weld = constraint.Weld( ent, trace.Entity, 0, trace.PhysicsBone, 0 )
			local nocollide = constraint.NoCollide( ent, trace.Entity, 0, trace.PhysicsBone )
		end
			
		ply:AddCount("pewpew_cores",ent)
		ply:AddCleanup ( "pewpew_cores", ent )

		undo.Create( "pewpew_core" )
			undo.AddEntity( ent )
			undo.AddEntity( weld )
			undo.AddEntity( nocollide )
			undo.SetPlayer( ply )
		undo.Finish()
	end
	
	function TOOL:RightClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		if (!ply:CheckLimit("pewpew_cores")) then return end
		local model = self:GetCoreModel()
		if (!model) then return end
		local ent = self:CreateCore( ply, trace, model )
		if (!ent) then return end
		
		ply:AddCount("pewpew_cores",ent)
		ply:AddCleanup ( "pewpew_cores", ent )

		undo.Create( "pewpew_core" )
			undo.AddEntity( ent )
			undo.SetPlayer( ply )
		undo.Finish()
	end

	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and ValidEntity(trace.Entity)) then
				self:GetOwner():ConCommand("pewpew_core_model " .. trace.Entity:GetModel())
				self:GetOwner():ChatPrint("PewPew Core model set to: " .. trace.Entity:GetModel())
			end
		end
	end	
else
	language.Add( "Tool.pewpew_core.name", "PewPew Cores" )
	language.Add( "Tool.pewpew_core.desc", "Used to spawn PewPew cores." )
	language.Add( "Tool.pewpew_core.0", "Primary: Spawn a PewPew core and weld it, Secondary: Spawn a PewPew core and don't weld it, Reload: Change the model of the core." )
	language.Add( "undone_pewpew_core", "Undone PewPew core" )
	language.Add( "Cleanup_pewpew_cores", "PewPew Cores" )
	language.Add( "Cleaned_pewpew_cores", "Cleaned up all PewPew Cores" )
	language.Add( "SBoxLimit_pewpew_cores", "You've reached the PewPew Core limit!" )
	
	
	function TOOL.BuildCPanel( CPanel )
		-- Header stuff
		CPanel:AddControl("Header", { Text = "#Tool.pewpew_core.name", Description = "#Tool.pewpew_core.desc" })
		
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
			ConVar = "pewpew_core_model",
			Category = "PewPew",
			Models = PewPewModels
		})
	end

	-- Ghost functions
	function TOOL:UpdateGhostCore( ent, player )
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
		local model = self:GetCoreModel()
		if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model) then
			local trace = self:GetOwner():GetEyeTrace()
			self:MakeGhostEntity( Model(model), trace.HitPos, trace.HitNormal:Angle() + Angle(90,0,0) )
		end
		self:UpdateGhostCore( self.GhostEntity, self:GetOwner() )
	end
end