
-- PewTool
-- This is the tool used to spawn all PewPew weapons

TOOL.Category = "PewPew"
TOOL.Name = "PewPew"
TOOL.ClientConVar[ "bulletname" ] = ""
TOOL.ClientConVar[ "model" ] = "models/combatmodels/tank_gun.mdl"
TOOL.ClientConVar[ "fire_key" ] = "1"
TOOL.ClientConVar[ "reload_key" ] = "2"
TOOL.ClientConVar[ "direction" ] = "1"

cleanup.Register("pewpew")

local PewPewModels = {	
	["models/combatmodels/tank_gun.mdl"] = {},
	["models/bull/pewpew_cannon_small.mdl"] = {},
	["models/bull/pewpew_cannon_medium.mdl"] = {},
	["models/bull/pewpew_cannon_big.mdl"] = {},
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


-- This needs to be shared...
function TOOL:GetCannonModel()
	local mdl = self:GetClientInfo("model")
	if (!util.IsValidModel(mdl) or !util.IsValidProp(mdl)) then return "models/combatmodels/tank_gun.mdl" end
	return mdl
end
						
if (SERVER) then
	AddCSLuaFile("pewpew.lua")
	CreateConVar("sbox_maxpewpew", 6)
	
	function TOOL:GetBulletName()
		local name = self:GetClientInfo("bulletname") or nil
		if (!name) then return end
		return name
	end
	
	function TOOL:GetDirection()
		local dir = tonumber(self:GetClientInfo("direction")) or 1
		return dir
	end
	
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
		
		-- Get the bullet
		local bullet = pewpew:GetWeapon( self:GetBulletName() )
		if (!bullet) then 
			ply:ChatPrint("[PewPew] That PewPew bullet does not exist!")
			return 
		end
		
		-- Check admin only
		if (bullet.AdminOnly and !ply:IsAdmin()) then 
			ply:ChatPrint("[PewPew] You must be an admin to spawn this PewPew weapon.")
			return false
		end
		if (bullet.SuperAdminOnly and !ply:IsSuperAdmin()) then
			ply:ChatPrint("[PewPew] You must be a super admin to spawn this PewPew weapon.")
			return false
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
	
	function TOOL:RightClick( trace )
		if (!trace) then return end
		local ply = self:GetOwner()

		
		-- Get the bullet
		local bullet = pewpew:GetWeapon( self:GetBulletName() )
		if (!bullet) then 
			ply:ChatPrint("[PewPew] That PewPew bullet does not exist!")
			return 
		end
		
		-- Check admin only
		if (bullet.AdminOnly and !ply:IsAdmin()) then 
			ply:ChatPrint("[PewPew] You must be an admin to spawn this PewPew weapon.")
			return false
		end
		if (bullet.SuperAdminOnly and !ply:IsSuperAdmin()) then
			ply:ChatPrint("[PewPew] You must be a super admin to spawn this PewPew weapon.")
			return false
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
			ply:ChatPrint("[PewPew] PewPew Weapon updated with bullet: " .. bullet.Name)
		else
			-- else create a new one
			local ent = self:CreateCannon( ply, trace, model, bullet, fire, reload, self:GetDirection() )
			if (!ent) then return end	
			
			ply:AddCount( "pewpew",ent )
			ply:AddCleanup( "pewpew", ent )

			undo.Create( "pewpew" )
				undo.AddEntity( ent )
				undo.SetPlayer( ply )
			undo.Finish()
				
			return true
		end
	end
	
	function TOOL:Reload( trace )
		if (trace.Hit) then
			if (trace.Entity and IsValid(trace.Entity) and !trace.Entity:IsPlayer()) then
				self:GetOwner():ConCommand("pewpew_model " .. trace.Entity:GetModel())
				self:GetOwner():ChatPrint("PewPew Cannon model set to: " .. trace.Entity:GetModel())
			end
		end
	end	
else
	language.Add( "Tool.pewpew.name", "PewTool" )
	language.Add( "Tool.pewpew.desc", "Used to spawn PewPew weaponry." )
	language.Add( "Tool.pewpew.0", "Primary: Spawn a PewPew weapon and weld it, Secondary: Spawn a PewPew weapon and don't weld it, Reload: Change the model of the weapon." )
	language.Add( "undone_pewpew", "Undone PewPew Weapon" )
	language.Add( "Cleanup_pewpew", "PewPew Weapons" )
	language.Add( "Cleaned_pewpew", "Cleaned up all PewPew Weapons" )
	language.Add( "SBoxLimit_pewpew", "You've reached the PewPew Weapon limit!" )
	
	
	function TOOL.BuildCPanel( CPanel )
		-- Header stuff
		CPanel:AddControl("Header", { Text = "#Tool.pewpew.name", Description = "#Tool.pewpew.desc" })
		
		CPanel:AddControl("ComboBox", {
			Label = "#Presets",
			MenuButton = "1",
			Folder = "pewpew",

			Options = {
				Default = {
					pewpew_model = "models/combatmodels/tank_gun.mdl",
					pewpew_bulletname = "",
				}
			},

			CVars = {
				[0] = "pewpew_model",
				[1] = "pewpew_bulletname",
			}
		})
		
		-- (Thanks to Grocel for making this selectable icon thingy)
		CPanel:AddControl( "PropSelect", {
			Label = "#Models (Or click Reload to select a model)",
			ConVar = "pewpew_model",
			Category = "PewPew",
			Models = PewPewModels
		})
		
		-- Directions
		local Directions = {}
		Directions.Label = "Fire Direction"
		Directions.Options = {}
		Directions.Options["Up"] = { pewpew_direction = 1 }
		Directions.Options["Down"] = { pewpew_direction = 2 }
		Directions.Options["Left"] = { pewpew_direction = 3 }
		Directions.Options["Right"] = { pewpew_direction = 4 }
		Directions.Options["Forward"] = { pewpew_direction = 5 }
		Directions.Options["Back"] = { pewpew_direction = 6 }
		CPanel:AddControl("ComboBox",Directions)
		
		local box = vgui.Create("DButton")
		CPanel:AddItem(box)
		box:SetText("Tree/Category")
		-- false = tree, true = category
		
		local label = vgui.Create("DLabel")
		label:SetText("Left click to select, right click for info.")
		label:SizeToContents()
		CPanel:AddItem(label)
		
		local panel = vgui.Create("DPanel")
		CPanel:AddItem(panel)
		panel:SetSize(285,500)
		
		
		----------------------------------------------------------------------------------------------------
		-- Tree
		----------------------------------------------------------------------------------------------------
		local tree = vgui.Create("DTree",panel)
		tree:Dock(FILL)
		
		local function AddNode( parent, folder, curtbl, curcat )
			parent = folder
			for k,v in pairs( curtbl ) do
				if (type(v) == "string") then
					local wpn = folder:AddNode( string.gsub( v, "_", " " ) )
					wpn.WeaponName = v
					wpn.Icon:SetImage( "icon16/page.png" )
					wpn.IsWeapon = true
				elseif (type(v) == "table") then	
					local temp = parent:AddNode( string.gsub( k, "_", " " ) )
					temp.Icon:SetImage("icon16/folder.png")
					AddNode( parent, temp, v, k )
				end
			end
		end
		AddNode( tree, tree, pewpew.Categories, curcat )
		
		local oldfunc = tree.DoClick
		function tree:DoClick( node )
			if (node.IsWeapon) then
				RunConsoleCommand("pewpew_bulletname", node.WeaponName)
				RunConsoleCommand("gmod_tool", "pewpew")
				RunConsoleCommand("pewpew_closeusemenu")
			else
				oldfunc( self, node )
			end
		end
		
		local oldfunc = tree.DoRightClick
		function tree:DoRightClick( node )
			if (node.IsWeapon) then
				RunConsoleCommand("PewPew_UseMenu", node.WeaponName)
			else
				oldfunc( self, node )
			end
		end
		
		----------------------------------------------------------------------------------------------------
		-- Category
		----------------------------------------------------------------------------------------------------
		
		-- Panel List 1
		local list1 = vgui.Create("DPanelList",panel)
		list1:SetAutoSize( false )
		list1:SetSpacing( 1 )
		list1:EnableHorizontal( false ) 
		list1:EnableVerticalScrollbar( true )
		list1:SetVisible( false )
		
		local categories = {}
		local catcontrols = {}
		local list2
		-- Loop through all weapons
		for k, v in ipairs( pewpew.Weapons ) do
			-- If the weapon is in a new category
			if (!categories[v.Category]) then
				categories[v.Category] = true
				-- Create a collapsible category derma item
				local cat = vgui.Create("DCollapsibleCategory",list1)
				cat:SetSize(146,50)
				cat:SetExpanded(0)
				cat:SetLabel(v.Category)
				catcontrols[#catcontrols+1] = cat
				function cat.Header:OnMousePressed()
					for k,v in ipairs( catcontrols ) do
						if ( v:GetExpanded() and v.Header != self ) then v:Toggle() end
						if (!v:GetExpanded() and v.Header == self ) then v:Toggle() end
					end
				end
				
				-- Create a list inside the category
				list2 = vgui.Create("DPanelList")
				list2:SetAutoSize( true )
				list2:SetSpacing( 2 )
				list2:EnableHorizontal( false )
				list2:EnableVerticalScrollbar( true )
				
				cat:SetContents( list2 )
				list1:AddItem(cat)
			end
			
			-- Add a button for the weapon
			local btn = vgui.Create("DButton")
			btn:SetSize( 48,20 )
			btn:SetText( v.Name )
			function btn:DoClick() RunConsoleCommand("pewpew_bulletname",v.Name) end
			function btn:DoRightClick() RunConsoleCommand("pewpew_usemenu",v.Name) end
			list2:AddItem( btn )
		end
		
		box.val = true
		function box:DoClick()
			self.val = !self.val
			if (self.val) then
				tree:SetVisible(true)
				list1:SetVisible(false)
			else
				tree:SetVisible(false)
				list1:SetVisible(true)
			end
		end
		
		function panel:PerformLayout()
			list1:SetSize(tree:GetSize())
		end
		
		local label = vgui.Create("DLabel")
		label:SetText([[To open this weapons menu in a seperate 
		window, use the console command: 
		'PewPew_WeaponMenu'
		or
		'+PewPew_WeaponMenu']])
		label:SizeToContents()
		
		CPanel:AddItem(label)
			
		CPanel:AddControl( "Numpad", { Label = "#Fire", Command = "pewpew_fire_key", ButtonSize = 22 } )
		CPanel:AddControl( "Numpad", { Label = "#Reload", Command = "pewpew_reload_key", ButtonSize = 22 } )
	end

	-- Ghost functions (Thanks to Grocel for making the base. I changed it a bit)
	function TOOL:UpdateGhostCannon( ent, player )
		if (!ent or !ent:IsValid()) then return end
		local trace = player:GetEyeTrace()
		
		if (!trace.Hit or (IsValid(trace.Entity) and trace.Entity:GetClass() == "pewpew_base_cannon") or trace.Entity:IsPlayer()) then
			ent:SetNoDraw( true )
			return
		end
		
		ent:SetAngles( trace.HitNormal:Angle() + Angle(90,0,0) )
		ent:SetPos( trace.HitPos - trace.HitNormal * ent:OBBMins().z )
		
		ent:SetNoDraw( false )
	end
	
	function TOOL:Think()
		local model = self:GetCannonModel()
		if (!self.GhostEntity or !self.GhostEntity:IsValid() or self.GhostEntity:GetModel() != model) then
			local trace = self:GetOwner():GetEyeTrace()
			self:MakeGhostEntity( Model(model), trace.HitPos, trace.HitNormal:Angle() + Angle(90,0,0) )
		end
		self:UpdateGhostCannon( self.GhostEntity, self:GetOwner() )
	end
end