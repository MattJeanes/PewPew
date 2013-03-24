-- Weapon Designer
-- With this tool you can make your own (basic) weapons
if SERVER then util.AddNetworkString("PewPew_WeaponDesigner") end

TOOL.Category = "PewPew"
TOOL.Name = "Weapon Designer"

TOOL.ClientConVar[ "model" ] = "models/combatmodels/tank_gun.mdl"
TOOL.ClientConVar[ "fire_key" ] = "1"
TOOL.ClientConVar[ "reload_key" ] = "2"
TOOL.ClientConVar[ "direction" ] = "1"

local PewPewModels = { 
	["models/combatmodels/tank_gun.mdl"] = {},
	["models/props_junk/TrafficCone001a.mdl"] = {},
	["models/props_lab/huladoll.mdl"] = {},
	["models/props_c17/oildrum001.mdl"] = {},
	["models/props_trainstation/trainstation_column001.mdl"] = {},
	["models/Items/combine_rifle_ammo01.mdl"] = {},
	["models/props_combine/combine_mortar01a.mdl"] = {},
	["models/props_combine/breenlight.mdl"] = {},
	["models/props_c17/pottery03a.mdl"] = {},
	["models/props_junk/PopCan01a.mdl"] = {},
	["models/props_trainstation/trainstation_post001.mdl"] = {},
	["models/props_c17/signpole001.mdl"] = {}
}

function TOOL:GetCannonModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/combatmodels/tank_gun.mdl" end
	return mdl
end

local Weapon = {}
				
//require("datastream")	Fixit
if (SERVER) then
	function TOOL:GetDirection()
		local dir = tonumber(self:GetClientInfo("direction")) or 1
		return dir
	end
	
	net.Receive( "PewPew_WeaponDesigner", function(l)
		if tobool(pewpew:GetConVar( "WeaponDesigner" ))==true then
			Weapon = net.ReadTable()
			Weapon.Name = "Weapon Designer Bullet"
		end
	end)
	
	function TOOL:CreateCannon( ply, trace, Model, Bullet, fire, reload, Dir )
		if (!ply:CheckLimit("pewpew")) then return end
		local ent = ents.Create( "pewpew_base_cannon" )
		if (!ent:IsValid()) then return end
		
		-- Pos/Model/Angle
		ent:SetModel( Model )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		
		ent:SetOptions( Bullet, ply, fire, reload, Dir )
		
		ent:Spawn()
		ent:Activate()
		return ent
	end
	
	function TOOL:LeftClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()
		
		if (!pewpew:GetConVar( "WeaponDesigner" )) then 
			ply:ChatPrint("[PewPew] The Weapon Designer is currently disabled.")
			return 
		end
		
		-- Get the bullet
		local bullet = Weapon
		if (!bullet or table.Count(bullet) == 0) then 
			ply:ChatPrint("[PewPew] You must create a weapon first.")
			return 
		end
		
		-- Get the model
		local model = self:GetCannonModel()
		if (!model) then return end
		
		-- Numpad buttons
		local fire = self:GetClientNumber( "fire_key" )
		local reload = self:GetClientNumber( "reload_key" )
		
		-- If the trace hit an entity
		local traceent = trace.Entity
		if (traceent and traceent:IsValid() and traceent:GetClass() == "pewpew_base_cannon") then
			if (traceent.Owner != ply and !ply:IsAdmin()) then
				ply:ChatPrint("[PewPew] You are not allowed to update other people's cannons.")
				return
			end
			-- Update it
			traceent:SetOptions( bullet, ply, fire, reload, self:GetDirection() )
			ply:ChatPrint("[PewPew] PewPew Cannon updated with bullet: " .. bullet.Name)
		else
			-- else create a new one
			
			local ent = self:CreateCannon( ply, trace, model, bullet, fire, reload, self:GetDirection() )
			if (!ent or !ent:IsValid()) then return end
			
			if (!traceent:IsWorld() and !traceent:IsPlayer()) then
				local weld = constraint.Weld( ent, trace.Entity, 0, trace.PhysicsBone, 0 )
				local nocollide = constraint.NoCollide( ent, trace.Entity, 0, trace.PhysicsBone )
			end
				
			ply:AddCount( "pewpew", ent)
			ply:AddCleanup( "pewpew", ent )

			undo.Create( "pewpew" )
				undo.AddEntity( ent )
				undo.AddEntity( weld )
				undo.AddEntity( nocollide )
				undo.SetPlayer( ply )
			undo.Finish()
		end
			
		return true
	end
	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and ValidEntity(trace.Entity) and !trace.Entity:IsPlayer()) then
				self:GetOwner():ConCommand("pewpew_model " .. trace.Entity:GetModel())
				self:GetOwner():ChatPrint("PewPew Cannon model set to: " .. trace.Entity:GetModel())
			end
		end
	end	
else
	language.Add( "Tool.pewpew_weapon_designer.name", "PewPew Weapon Designer" )
	language.Add( "Tool.pewpew_weapon_designer.desc", "Create your own PewPew weapons" )
	language.Add( "Tool.pewpew_weapon_designer.0", "Primary: Spawn the PewPew weapon and weld it, Secondary: Open the Weapon Designer Menu, Reload: Change the model of the weapon." )
	
	local Menu = nil
	
	local function GetVal( Text, Type, Type2 )
		if (Type == "String") then
			return Text
		elseif (Type == "Number") then
			return tonumber(Text)
		elseif (Type == "Table") then
			if (Type2 == "String") then
				return { Text }
			elseif (Type2 == "Number") then
				return { tonumber(Text) }
			end
		end
	end
	
	
	local Tbl1 = { 	[1]={Txt = "DamageType", 				Default = "PointDamage", 	Desc = "", Type="String"},
					[2]={Txt = "Damage", 					Default = "100", 			Desc = "", Type="Number"},
					[3]={Txt = "Radius",					Default = "100", 			Desc = "", Type="Number"},
					[4]={Txt = "RangeDamageMul",		 	Default = "0.5", 			Desc = "Only used in BlastDamage. Must be between 0 and 1", Type="Number"},
					[5]={Txt = "PlayerDamage",				Default = "",				Desc = "Only used in BlastDamage", Type="Number"},
					[6]={Txt = "PlayerDamageRadius",		Default = "", 				Desc = "Only used in BlastDamage", Type="Number"},
					[7]={Txt = "NumberOfSlices",			Default = "", 				Desc = "Only used in SliceDamage", Type="Number"},
					[8]={Txt = "SliceDistance",				Default = "", 				Desc = "Only used in SliceDamage", Type="Number"},
					[9]={Txt = "Duration",					Default = "", 				Desc = "Only used in EMPDamage", Type="Number"},
					[10]={Txt = "Speed",					Default = "70", 			Desc = "", Type="Number"},
					[11]={Txt = "Gravity",					Default = "0.1", 			Desc = "", Type="Number"},
					[12]={Txt = "RecoilForce",				Default = "1000", 			Desc = "", Type="Number"},
					[13]={Txt = "Spread",					Default = "0.1", 			Desc = "", Type="Number"} }
	
	local Tbl2 = { 	[1]={Txt = "Reloadtime", 				Default = "1", 				Desc = "", Type="Number"},
					[2]={Txt = "Ammo", 						Default = "0", 				Desc = "If you set this to 0, it will have infinite ammo", Type="Number"},
					[3]={Txt = "AmmoReloadtime", 			Default = "0", 				Desc = "", Type="Number"},
					[4]={Txt = "EnergyPerShot", 			Default = "1000", 			Desc = "", Type="Number"},
					[5]={Txt = "Model",						Default = "models/combatmodels/tankshell.mdl", Desc = "", Type="String"},
					[6]={Txt = "ExplosionEffect",			Default = "big_splosion", 	Desc = "", Type="String"},
					[7]={Txt = "FireEffect", 				Default = "cannon_flare", 	Desc = "", Type="String"},
					[8]={Txt = "FireSound", 				Default = "arty/37mm.wav", 	Desc = "", Type="Table", Type2 = "String"},
					[9]={Txt = "ExplosionSound", 			Default = "weapons/explode1.wav", 	Desc = "", Type="Table", Type2 = "String"},}
					
	--local Tbl3 = { 	1={Txt = "Radius",					Desc = ""},
	
	local function CreateWeaponDesignerMenu()
		Menu = vgui.Create("DFrame")
		local w,h = 800, 400
		Menu:SetPos( ScrW() / 2 - w / 2, ScrH() / 2 - h / 2 )
		Menu:SetSize( w, h )
		Menu:SetTitle( "PewPew Weapon Designer" )
		Menu:SetVisible( false )
		Menu:SetDraggable( true )
		Menu:ShowCloseButton( true )
		Menu:SetDeleteOnClose( false )
		Menu:SetScreenLock( true )
		Menu:MakePopup()
		
		local CreateButton = vgui.Create("DButton",Menu)
		CreateButton:SetPos( w - 80, 2 )
		CreateButton:SetSize( 50, 20 )
		CreateButton:SetText( "OK" )
		function CreateButton:DoClick()
			for k,v in ipairs( Tbl1 ) do
				if (v.textbox) then
					Weapon[v.Txt] = GetVal( v.textbox:GetValue(), v.Type, v.Type2 )
				end
			end
			for k,v in ipairs( Tbl2 ) do
				if (v.textbox) then
					Weapon[v.Txt] = GetVal( v.textbox:GetValue(), v.Type, v.Type2 )
				end
			end
			Weapon.Version=1
			net.Start("PewPew_WeaponDesigner")
				net.WriteTable(Weapon)
			net.SendToServer()
			
			Menu:SetVisible( false )
		end
		
		local TabHolder = vgui.Create("DPropertySheet",Menu)
		TabHolder:SetPos( 2, 24 )
		TabHolder:SetSize( w - 4, h - 24 - 2 )
	
		local function CreateTextBoxes( TargetTab, TargetTable )
			local list = vgui.Create("DPanelList",TargetTab)
			list:SetSize( w - 6, h - 6 )
			list:SetSpacing( 2 )
			list:EnableHorizontal( true )
			list:EnableVerticalScrollbar( true )
			
			for k,v in ipairs( TargetTable ) do
				local pnl = vgui.Create("DPanel")
				pnl:SetSize( w-6, 20 )
				--function pnl:Paint() return true end
			
				local label = vgui.Create("DLabel",pnl)
				label:SetPos( 4, 4 )
				label:SetText( v.Txt )
				label:SizeToContents()
				
				local box = vgui.Create("DTextEntry",pnl)
				box:SetPos( 135, 0 )
				box:SetWidth( 200 )
				box:SetText( v.Default )
				-- Default values
				if (v.Default and v.Default != "") then 
					Weapon[v.Txt] = GetVal( v.Default, v.Type, v.Type2 )
				end
				box:SetMultiline( false )
				function box:OnEnter()
					Weapon[v.Txt] = GetVal( self:GetValue(), v.Type, v.Type2 )
				end
				v.textbox = box
				
				local label2 = vgui.Create("DLabel",pnl)
				label2:SetPos( 200 + 135 + 4 + 10, 4 )
				label2:SetText( v.Desc )
				label2:SizeToContents()
				
				list:AddItem( pnl )
			end
		end
	
		local Tab1 = vgui.Create("DPanel",TabHolder)
		CreateTextBoxes( Tab1, Tbl1 )
		TabHolder:AddSheet( "Damage & Movement", Tab1, nil, false, false, nil )
		
		local Tab2 = vgui.Create("DPanel",TabHolder)
		CreateTextBoxes( Tab2, Tbl2 )
		TabHolder:AddSheet( "Appearance, Ammo and Reloading", Tab2, nil, false, false, nil )
		
		--[[
		local Tab3 = vgui.Create("DPanel",TabHolder)
		CreateTextBoxes( Tab3, Tbl3 )
		TabHolder:AddSheet( "Appearance", Tab3, nil, false, false, nil )
		]]
	end
	CreateWeaponDesignerMenu()

	local function OpenWeaponDesignerMenu()
		Menu:SetVisible( true )
	end
	concommand.Add("PewPew_OpenWeaponDesignerMenu",OpenWeaponDesignerMenu)
	
	function TOOL.RightClick()
		Menu:SetVisible( true )
	end
	
	function TOOL.BuildCPanel( CPanel )
		CPanel:AddControl( "Button", {Label="Weapon Designer Menu",Description="Open the Weapon Designer Menu",Text="Weapon Designer Menu",Command="PewPew_OpenWeaponDesignerMenu"} )
		
		CPanel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "pewpew_weapon_designer_model",
			Category = "PewPew",
			Models = PewPewModels
		})
		
		-- Directions
		local Directions = {}
		Directions.Label = "Fire Direction"
		Directions.Options = {}
		Directions.Options["Up"] = { pewpew_weapon_designer_direction = 1 }
		Directions.Options["Down"] = { pewpew_weapon_designer_direction = 2 }
		Directions.Options["Left"] = { pewpew_weapon_designer_direction = 3 }
		Directions.Options["Right"] = { pewpew_weapon_designer_direction = 4 }
		Directions.Options["Forward"] = { pewpew_weapon_designer_direction = 5 }
		Directions.Options["Back"] = { pewpew_weapon_designer_direction = 6 }
		CPanel:AddControl("ComboBox",Directions)
		
		CPanel:AddControl( "Numpad", { Label = "#Fire", Command = "pewpew_weapon_designer_fire_key", ButtonSize = 22 } )
		CPanel:AddControl( "Numpad", { Label = "#Reload", Command = "pewpew_weapon_designer_reload_key", ButtonSize = 22 } )
	end
	
	
end