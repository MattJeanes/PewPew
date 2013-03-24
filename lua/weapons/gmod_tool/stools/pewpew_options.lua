-- Options tool
-- This tool has admin options and a button to open the damage log

TOOL.Category = "PewPew"
TOOL.Name = "Options Tool"
				
			
if (CLIENT) then
	CreateClientConVar("PewPew_MaxBullets", "255", true)
	language.Add( "Tool.pewpew_options.name", "PewPew Option Tool" )
	language.Add( "Tool.pewpew_options.desc", "This tool helps you change settings & administrate your server." )
	language.Add( "Tool.pewpew_options.0", "-nothing-" )
	
	pewpew.DamageLog = {}
	
	local pewpew_logframe
	local pewpew_loglist
	
	local function UpdateLogMenu()
		if (pewpew.DamageLog and #pewpew.DamageLog > 0) then
			pewpew_loglist:Clear()
			for k,v in ipairs( pewpew.DamageLog ) do
				local ent = v[4]
				if (type(ent) == "number") then
					if (Entity(ent):IsValid()) then
						ent = tostring(Entity(ent))
					else
						pewpew.DamageLog[k][2] = "- Died -"
						ent = "- Died -"
					end
				end
				pewpew_loglist:AddLine( v[1], v[2], v[3], ent, v[5], v[6], v[7] )
			end			
		end
	end
	
	net.Receive( "PewPew_Option_Tool_SendLog", function()
	local t=net.ReadTable()
		for k,v in pairs( t ) do
			if (v[7] == true) then v[7] = "Yes" else v[7] = "No" end
			table.insert( pewpew.DamageLog, 1, v )
		end
		print("table read")
		UpdateLogMenu()
	end)
	
	
	local function OpenLogMenu()
		pewpew_logframe:SetVisible( true )
	end
	concommand.Add("PewPew_OpenLogMenu",OpenLogMenu)

	local function CreateLogMenu()
		pewpew_logframe = vgui.Create("DFrame")
		pewpew_logframe:SetPos( ScrW() - 750, 50 )
		pewpew_logframe:SetSize( 700, ScrH() - 100 )
		pewpew_logframe:SetTitle( "PewPew DamageLog" )
		pewpew_logframe:SetVisible( false )
		pewpew_logframe:SetDraggable( true )
		pewpew_logframe:ShowCloseButton( true )
		pewpew_logframe:SetDeleteOnClose( false )
		pewpew_logframe:SetScreenLock( true )
		pewpew_logframe:MakePopup()
		
		pewpew_loglist = vgui.Create( "DListView", pewpew_logframe )
		pewpew_loglist:StretchToParent( 2, 23, 2, 2 )
		local w = pewpew_loglist:GetWide()
		local a = pewpew_loglist:AddColumn( "Time" )
		a:SetWide(w*(1/6))
		local b = pewpew_loglist:AddColumn( "Damage Dealer" )
		b:SetWide(w*(1/6))
		local c = pewpew_loglist:AddColumn( "Victim Entity Owner" )
		c:SetWide(w*(1/6))
		local d = pewpew_loglist:AddColumn( "Victim Entity" )
		d:SetWide(w*(1/6))
		local e = pewpew_loglist:AddColumn( "Weapon" )
		e:SetWide(w*(1/6))
		local f = pewpew_loglist:AddColumn( "Damage" )
		f:SetWide(w*(0.5/6))
		local g = pewpew_loglist:AddColumn( "Died?" )
		g:SetWide(w*(0.5/6))
	end
	CreateLogMenu()
	
	function TOOL.BuildCPanel( CPanel )
		CPanel:AddControl( "Label", {Text="Maximum about of bullets that will spawn clientside, reduce this number if you're lagging due to bullets."} )
		
		local slider = vgui.Create("DNumSlider")
		slider:SetText( "Max Client Bullets:" )
		slider:SetMinMax( 0, 255 )
		slider:SetDecimals( 0 )
		slider:SetConVar( "PewPew_MaxBullets" )
		slider:SetValue( 255 ) -- PROBLEM: This does not set it to -1. It defaults to 0 anyway...
		
		CPanel:AddItem( slider )

		CPanel:AddControl( "Label", {Text="-----------------------------------------------------"} )
		CPanel:AddControl( "Button", {Label="Log Menu",Description="Open the Log Menu",Text="Log Menu",Command="PewPew_OpenLogMenu"} )
		CPanel:AddControl( "Label", {Text="-----------------------------------------------------"} )
		CPanel:AddControl( "Label", {Text="Changing the below options if you're not admin is pointless." } )
		CPanel:AddControl( "CheckBox", {Label="Toggle Damage",Description="Toggle Damage",Command="pewpew_options_damage"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Firing",Description="Toggle Firing",Command="pewpew_options_firing"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Numpads",Description="Toggle Numpads",Command="pewpew_options_numpads"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Energy Usage",Description="Toggle Energy Usage",Command="pewpew_options_energyusage"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Damage Log Sending",Description="Toggle Damage Log Sending",Command="pewpew_options_damagelog_sending"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Core Damage Only",Description="Toggle Core Damage Only",Command="pewpew_options_coredamage_only"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Prop Prot. Dmg",Description="Toggle Prop Prot. Dmg",Command="pewpew_options_ppdamage"} )
		CPanel:AddControl( "CheckBox", {Label="Toggle Weapon Designer",Description="Toggle Weapon Designer",Command="pewpew_options_wpn_designer"} )
		CPanel:AddControl( "Slider", {Label="Damage Multiplier",Description="Damage Multiplier",Type="Float",Min="0.01",Max="10",Command="pewpew_options_damagemul"} )
		CPanel:AddControl( "Slider", {Label="Damage Core Multiplier",Description="Damage Core Multiplier",Type="Float",Min="0.01",Max="10",Command="pewpew_options_coredamagemul"} )
		CPanel:AddControl( "Slider", {Label="Repair Tool Heal Rate",Description="Repair Tool Heal Rate",Type="Integer",Min="20",Max="10000",Command="pewpew_options_repairrate"} )
		CPanel:AddControl( "Slider", {Label="Repair Tool Heal Rate vs Cores",Description="Repair Tool Heal Rate vs Cores",Type="Integer",Min="20",Max="10000",Command="pewpew_options_repairrate_cores"} )
		CPanel:AddControl( "Button", {Label="Apply Changes",Description="Apply Changes",Text="Apply Changes",Command="pewpew_cl_applychanges"} )
	end
	
	local dmg = CreateClientConVar("pewpew_options_damage","1",false,false)
	local firing = CreateClientConVar("pewpew_options_firing","1",false,false)
	local numpads = CreateClientConVar("pewpew_options_numpads","1",false,false)
	local energy = CreateClientConVar("pewpew_options_energyusage","0",false,false)
	local coreonly = CreateClientConVar("pewpew_options_coredamage_only","0",false,false)
	local damagemul = CreateClientConVar("pewpew_options_damagemul","1",false,false)
	local damagemulcores = CreateClientConVar("pewpew_options_coredamagemul","1",false,false)
	local repair = CreateClientConVar("pewpew_options_repairrate","75",false,false)
	local repaircores = CreateClientConVar("pewpew_options_repairrate_cores","200",false,false)
	local damagelog = CreateClientConVar("pewpew_options_damagelog_sending","1",false,false)
	local ppdamage = CreateClientConVar("pewpew_options_ppdamage","0",false,false)
	local weapondesigner = CreateClientConVar("pewpew_options_wpn_designer","0",false,false)
	
	local function Apply( ply, cmd, args )
		RunConsoleCommand("pewpew_damage",dmg:GetString())
		RunConsoleCommand("pewpew_firing",firing:GetString())
		RunConsoleCommand("pewpew_numpads",numpads:GetString())
		RunConsoleCommand("pewpew_energyusage",energy:GetString())
		RunConsoleCommand("pewpew_coredamageonly",coreonly:GetString())
		RunConsoleCommand("pewpew_damagemul",damagemul:GetString())
		RunConsoleCommand("pewpew_coredamagemul",damagemulcores:GetString())
		RunConsoleCommand("pewpew_repairtoolheal",repair:GetString())
		RunConsoleCommand("pewpew_repairtoolhealcores",repaircores:GetString())
		RunConsoleCommand("pewpew_damagelogsending",damagelog:GetString())
		RunConsoleCommand("PewPew_PropProtDamage",ppdamage:GetString())
		RunConsoleCommand("PewPew_WeaponDesigner",weapondesigner:GetString())
	end
	concommand.Add("pewpew_cl_applychanges", Apply)
	
	local function drawname( v, owner )
		local pos = v:GetPos():ToScreen()
		local name = owner or v:GetNWString("PewPew_OwnerName","- Error -")
		surface.SetFont("DermaDefault")
		local w = surface.GetTextSize( name )
		draw.WordBox( 2, pos.x - w / 2, pos.y, name, "DermaDefault", Color( 0,0,0,255 ), Color( 50,200,50,255 ) )
	end
	
	function TOOL:DrawHUD()
		for k,v in ipairs( ents.FindByClass("pewpew_base_cannon") ) do drawname( v ) end
		for k,v in ipairs( ents.FindByClass("pewpew_base_bullet") ) do drawname( v ) end
		for k,v in ipairs( pewpew.Bullets ) do
			if (v.Prop and IsValid(v.Prop) and v.Owner) then
				drawname(v.Prop,v.Owner:Nick())
			else
				drawname(v)
			end
		end
	end
end