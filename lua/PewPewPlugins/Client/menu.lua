-- Weapon Selection & Options Menu

local frame
local w,h = 600,600

local function CreateMenu()
	frame = vgui.Create("DFrame")
	frame:SetPos( ScrW()/2-w/2, ScrH()/2-h/2 )
	frame:SetSize( w, h )
	frame:SetTitle( "PewPew Weapon Selection Menu" )
	frame:SetVisible( false)
	frame:SetDraggable( true )
	frame:ShowCloseButton( true )
	frame:SetDeleteOnClose( false )
	frame:SetScreenLock( false )
	frame:MakePopup()
	
	--[[
	local psheet = vgui.Create("DPropertySheet",frame)
	psheet:SetPos( 4, 24 )
	psheet:SetSize( w - 8, h - 24 - 4 )
	
	
	
		-- Weapon selection tab
		local frame2 = vgui.Create("DPanel")
		frame2:StretchToParent( 2, 2, 2, 2 )
		function frame2:Paint() end
		
		local sliders = { 
				["Damage"] = { 	"Damage", -- Pretty name
								0, 3000, -- Min, max
								function( value ) return value or 0 end -- Change value if necessary
							 },
				["Spread"] = { 	"Accuracy",
								0, 3,
								function( value ) return value or 0 end
							 },
				["Reloadtime"] = { 	"Reload Time",
									0, 20,
									function( value ) return value or 0 end
								  },
				["Ammo"] = { 	"Ammo",
								0, 200,
								function( value ) return value or 0 end
						   },
				["AmmoReloadtime"] = { 	"Ammo Reload Time",
										0, 20,
										function( value ) return value or 0 end
									  },
				["EnergyPerShot"] = { 	"Energy Per Shot",
										0, 10000,
										function( value ) return value or 0 end
									},
			}
		
		
		local n = 0
		for k,v in pairs( sliders ) do
			local slider = vgui.Create("PewPew_StatusBar",frame2)
			sliders[k][5] = slider
			slider:SetPos( 310, 5 + n * 30 )
			slider:SetSize( 270, 25 )
			slider:SetText( v[1] )
			slider:SetMinMax( v[2], v[3] )
			n = n + 1
		end
	]]

		-- DTree
		local tree = vgui.Create("DTree", frame)
		tree:SetPadding( 5 )
		tree:SetPos( 2, 2 )
		tree:StretchToParent(4,24,4,4)
		--tree:SetSize( 300, frame:GetTall() - 4 )
		
	--[[
		local function UpdateSliders( wpn )
			if (!wpn) then return end
			for k,v in pairs( sliders ) do
				v[5]:SetValue( v[4](wpn[k]) )
			end
		end
	]]
		
		local function AddNode( parent, folder, curtbl, curcat )
			parent = folder
			for k,v in pairs( curtbl ) do
				if (type(v) == "string") then
					local wpn = folder:AddNode( string.gsub( v, "_", " " ) )
					wpn.WeaponName = v
					wpn.Icon:SetImage( "vgui/spawnmenu/file" )
					wpn.IsWeapon = true
				elseif (type(v) == "table") then	
					local temp = parent:AddNode( string.gsub( k, "_", " " ) )
					temp.Icon:SetImage("vgui/spawnmenu/Folder")
					AddNode( parent, temp, v, k )
				end
			end
		end
		AddNode( tree, tree, pewpew.Categories, curcat )
		
		local oldfunc = tree.DoClick
		function tree:DoClick( node )
			if (self.SelectedNode and self.SelectedNode == node and node.IsWeapon) then
				RunConsoleCommand("pewpew_bulletname", node.WeaponName)
				RunConsoleCommand("gmod_tool", "pewpew")
				RunConsoleCommand("pewpew_closeusemenu")
				frame:SetVisible( false )
			else
				--if (node.IsWeapon) then
				--	UpdateSliders( pewpew:GetWeapon( node.WeaponName ) )
				--else
					oldfunc( self, node )
				--end
				self.SelectedNode = node
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
		
		--psheet:AddSheet( "Weapon", frame2, nil, false, false, "Select Weapon" )
end

concommand.Add("PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Open weapons menu
	if (!frame) then CreateMenu() end
	frame:SetVisible( true )	
end)

concommand.Add("+PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Open weapons menu
	if (!frame) then CreateMenu() end
	frame:SetVisible( true )
end)

concommand.Add("-PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Close weapons menu
	frame:SetVisible( false )
end)

--[[
local pewpew_weaponframe

-- Weapons Menu
local function CreateMenu2()
	-- Main frame
	pewpew_weaponframe = vgui.Create("DFrame")
	pewpew_weaponframe:SetPos( ScrW()-300,ScrH()/2-450/2 )
	pewpew_weaponframe:SetSize( 250, 450 )
	pewpew_weaponframe:SetTitle( "PewPew Weapons" )
	pewpew_weaponframe:SetVisible( false )
	pewpew_weaponframe:SetDraggable( true )
	pewpew_weaponframe:ShowCloseButton( true )
	pewpew_weaponframe:SetDeleteOnClose( false )
	pewpew_weaponframe:SetScreenLock( true )
	pewpew_weaponframe:MakePopup()
	
	local label = vgui.Create("DLabel", pewpew_weaponframe)
	label:SetText("Left click to select, right click for info.")
	label:SetPos( 6, 23 )
	label:SizeToContents()
	
	-- Panel List 1
	local list1 = vgui.Create("DPanelList", pewpew_weaponframe)
	list1:StretchToParent( 4, 40, 4, 4 )
	list1:SetAutoSize( false )
	list1:SetSpacing( 1 )
	list1:EnableHorizontal( false ) 
	list1:EnableVerticalScrollbar( true )

	-- Loop through all categories
	pewpew.CategoryControls = {}
	for key, value in pairs( pewpew.Categories ) do
		-- Create a Collapsible Category for each
		local cat = vgui.Create( "DCollapsibleCategory" )
		cat:SetSize( 146, 50 )
		cat:SetExpanded( 0 )
		cat:SetLabel( key )
		
		-- Create a list inside each collapsible category
		local list = vgui.Create("DPanelList")
		list:SetAutoSize( true )
		list:SetSpacing( 2 )
		list:EnableHorizontal( false ) 
		list:EnableVerticalScrollbar( true )
		
		-- Loop through all weapons in each category
		for key2, value2 in pairs( pewpew.Categories[key] ) do
			-- Create a button for each list
			local btn = vgui.Create("DButton")
			btn:SetSize( 48, 20 )
			btn:SetText( value2 )
			-- Set bullet, change weapon, and close menu
			btn.DoClick = function()
				RunConsoleCommand("pewpew_bulletname", value2)
				RunConsoleCommand("gmod_tool", "pewpew")
				pewpew_weaponframe:SetVisible( false )
				pewpew_frame:SetVisible( false )
			end
			btn.DoRightClick = function()
				RunConsoleCommand("PewPew_UseMenu", value2)
			end
			list:AddItem( btn )
		end
		
		cat:SetContents( list )
		function cat.Header:OnMousePressed()
			for k,v in ipairs( pewpew.CategoryControls ) do
				if ( v:GetExpanded() and v.Header != self ) then v:Toggle() end
				if (!v:GetExpanded() and v.Header == self ) then v:Toggle() end
			end
		end
		table.insert( pewpew.CategoryControls, cat )
		list1:AddItem( cat )
	end
end
timer.Simple(0.5, CreateMenu2)

concommand.Add("PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Open weapons menu
	pewpew_weaponframe:SetVisible( true )	
end)

concommand.Add("+PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Open weapons menu
	pewpew_weaponframe:SetVisible( true )
end)

concommand.Add("-PewPew_WeaponMenu", function( ply, cmd, arg )
	-- Open weapons menu
	pewpew_weaponframe:SetVisible( false )
end)
]]