-- PewPew Use Menu

local pewpew_frame
local pewpew_list

-- Use Menu
local function CreateMenu()
	pewpew_frame = vgui.Create("DFrame")
	pewpew_frame:SetPos( ScrW()/2+100,ScrH()/2-420/2 )
	pewpew_frame:SetSize( 600, 420 )
	pewpew_frame:SetTitle( "PewPew Cannon Information" )
	pewpew_frame:SetVisible( false )
	pewpew_frame:SetDraggable( true )
	pewpew_frame:ShowCloseButton( true )
	pewpew_frame:SetDeleteOnClose( false )
	pewpew_frame:SetScreenLock( true )
	pewpew_frame:MakePopup()
	
	pewpew_list = vgui.Create( "DPanelList", pewpew_frame )
	pewpew_list:StretchToParent( 2, 23, 2, 2 )
	pewpew_list:SetSpacing( 2 )
	pewpew_list:EnableHorizontal( true )
	pewpew_list:EnableVerticalScrollbar( true )
end
timer.Simple( 2, CreateMenu )

local list = {}		
local function SetTable( Bullet )
	local rld = Bullet.Reloadtime
	if (!rld or rld == 0) then rld = 1 end
	list[1] = 	{"Name", 				Bullet.Name}
	list[2] = 	{"Author", 				Bullet.Author}
	list[3] = 	{"Description", 		Bullet.Description}
	list[4] = 	{"Category", 			Bullet.Category }
	list[5] = 	{"Damage Type",			Bullet.DamageType}
	list[6] = 	{"Damage",	 			Bullet.Damage}
	list[7] = 	{"DPS",					(Bullet.Damage or 0) * (1/rld)}
	list[8] = 	{"Radius", 				Bullet.Radius}
	list[9] = 	{"PlayerDamage", 		Bullet.PlayerDamage}
	list[10] = 	{"PlayerDamageRadius", 	Bullet.PlayerDamageRadius}
	list[11] = 	{"Speed", 				Bullet.Speed}
	list[12] = 	{"Gravity", 			tostring(Bullet._Gravity) .. " units per second, or " .. tostring(Bullet.Gravity or 600) .. " units per tick"}
	list[13] =	{"RecoilForce", 		Bullet.RecoilForce}
	list[14] = 	{"Spread",				Bullet.Spread}
	list[15] = 	{"Reloadtime", 			Bullet.Reloadtime}
	list[16] = 	{"Ammo", 				Bullet.Ammo}
	list[17] = 	{"AmmoReloadtime", 		Bullet.AmmoReloadtime}
	list[18] = 	{"EnergyPerShot",		Bullet.EnergyPerShot}
end

local function OpenUseMenu( bulletname )
	local Bullet = pewpew:GetWeapon( bulletname )
	if (Bullet) then
		pewpew_list:Clear()
		SetTable( Bullet )
		for _, value in ipairs( list ) do
			local pnl = vgui.Create("DPanel")
			pnl:SetSize( 594, 20 )
			--function pnl:Paint() return true end
		
			local label = vgui.Create("DLabel",pnl)
			label:SetPos( 4, 4 )
			label:SetText( value[1] )
			label:SizeToContents()
			
			local box = vgui.Create("DTextEntry",pnl)
			box:SetPos( 135, 0 )
			box:SetText( tostring(value[2] or "- none -") or "- none -" )
			box:SetWidth( 592 )
			box:SetMultiline( false )
			
			pewpew_list:AddItem( pnl )
		end
		pewpew_frame:SetVisible( true )
	else
		LocalPlayer():ChatPrint("Bullet not found!")
	end
end

concommand.Add("PewPew_UseMenu", function( ply, cmd, arg )
	OpenUseMenu( table.concat(arg, " ") )
end)

concommand.Add("PewPew_CloseUseMenu", function( ply,cmd,arg )
	pewpew_frame:SetVisible( false )
end)