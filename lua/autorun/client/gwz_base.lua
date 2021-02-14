// -----------------------------------------------------------------
// Purpose: Create all necessities for GWZ-hud
// -----------------------------------------------------------------

CreateClientConVar("gwz_hud_enable", 1, true, false, "Enable drawing Warzone-like hud")


local pPlayer = LocalPlayer()
local m_iPlayerColor = GetConVar("cl_playercolor")

GWZ = {}

surface.CreateFont( "GWZ_Small", {
	font = "Ubuntu",
	extended = false,
	shadow = true,	
	size = 20,
} )

surface.CreateFont( "GWZ_Medium", {
	font = "Ubuntu",
	extended = false,
	shadow = true,	
	size = 30,
} )

// -----------------------------------------------------------------
// Purpose: Client scheme for hud (to keep the idea from Modern 
// Warfare / Warzone, I did not decide to do the ability to change 
// colors in the hud)
// -----------------------------------------------------------------

// local m_clHud = color(255, 255, 255, 255)

local m_sBgGradient = Material( "hud/bg_gradient.png" )
local m_sHosterStar = Material( "hud/hoster_star.png" )

local m_sArmorIcon = Material( "hud/armor_icon.png" )
local m_sArmorBox = Material( "hud/armor_circle.png" )

// -----------------------------------------------------------------
// Purpose: Display player's information (nickname, current health 
// and armor) on hud
// -----------------------------------------------------------------
function GWZ.DrawPlayersInfo()
end

local hide = {
	["CHudHealth"] = true,
	["CHudBattery"] = true,
	--["CHudAmmo"] = true,
	--["CHudSecondaryAmmo"] = true,
	["CHudSuitPower"] = true,
}

hook.Add( "HUDPaint", "GWZHudPaint", function()
	local pPlayer = LocalPlayer()
	if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
	if !pPlayer:Alive() then return end
	
	-- Draw transparent background with gradient
	surface.SetDrawColor( 255, 255, 255, 205 )
	surface.SetMaterial( m_sBgGradient )
	surface.DrawTexturedRect( 100 , ScrH() - 200, 394, 120 )
	
	-- Draw user's name in it's background
	surface.SetFont( "GWZ_Small" )
	surface.SetTextColor( 222, 218, 205 )
	surface.SetTextPos( 150 , ScrH() - 180 ) 
	surface.DrawText( pPlayer:GetName() )
	
	-- Draw a star near player's name if he's superadmin
	if pPlayer:IsSuperAdmin() then
		surface.SetDrawColor( 196, 192, 180, 205 )
		surface.SetMaterial( m_sHosterStar )
		surface.DrawTexturedRect( 126 , ScrH() - 177, 16, 16 )
	end
	
	-- Draw armor icon (VManip Warzone Armir plates)
	if pPlayer:GetArmorPlates() > 0 then
		surface.SetDrawColor( 255, 255, 255, 250 )
		surface.SetMaterial( m_sArmorIcon )
		surface.DrawTexturedRect( 455 , ScrH() - 185, 50, 59 )

		surface.SetDrawColor( 255, 255, 255, 200 )		
		surface.SetMaterial( m_sArmorBox )
		surface.DrawTexturedRect( 465 , ScrH() - 135, 30, 35 )	

		m_inputWarzoneArmor = input.LookupBinding( "+armorplate" )
		m_inputWarzoneArmor = string.upper(m_inputWarzoneArmor) 
		
		surface.SetFont( "GWZ_Small" )
		surface.SetTextColor( 0, 0, 0 )
		surface.SetTextPos( 475 , ScrH() - 130 ) 
		surface.DrawText( m_inputWarzoneArmor )	

		surface.SetFont( "GWZ_Medium" )
		surface.SetTextColor( 255, 255, 255 )
		surface.SetTextPos( 500 , ScrH() - 165 ) 
		surface.DrawText( pPlayer:GetArmorPlates() )		
	end
	
	if pPlayer:GetArmorPlates() == 0 then
		surface.SetDrawColor( 255, 255, 255, 150 )
		surface.SetMaterial( m_sArmorIcon )
		surface.DrawTexturedRect( 455 , ScrH() - 185, 50, 59 )
		
		surface.SetDrawColor( 255, 255, 255, 100 )		
		surface.SetMaterial( m_sArmorBox )
		surface.DrawTexturedRect( 465 , ScrH() - 135, 30, 35 )	

		m_inputWarzoneArmor = input.LookupBinding( "+armorplate" )
		m_inputWarzoneArmor = string.upper(m_inputWarzoneArmor) 
		
		surface.SetFont( "GWZ_Small" )
		surface.SetTextColor( 64, 64, 64 )
		surface.SetTextPos( 475 , ScrH() - 130 ) 
		surface.DrawText( m_inputWarzoneArmor )
	end

	
	-- Draw health bar
	surface.SetDrawColor( 61, 58, 56 )
    surface.DrawRect(150 , ScrH() - 140, 171, 8)
	
	if pPlayer:Health() > 100 then
		healthBarLenght = 171
	else
		healthBarLenght = pPlayer:Health() * 1.71
	end
	
	surface.SetDrawColor( 222, 218, 205 )
    surface.DrawRect(150 , ScrH() - 140, healthBarLenght, 8)
	
	-- Draw armor plates	
	surface.SetDrawColor( 61, 58, 56 )
	surface.DrawRect(150 , ScrH() - 155, 55, 8)
		
	surface.SetDrawColor( 61, 58, 56 )
	surface.DrawRect(207 , ScrH() - 155, 55, 8)
		
	surface.SetDrawColor( 61, 58, 56 )
	surface.DrawRect(264 , ScrH() - 155, 55, 8)
	
	
	if ( pPlayer:Armor() < 100 || pPlayer:Armor() == 100)  then 
		armorBar1Lenght = 55
	end
	if ( pPlayer:Armor() < 95 || pPlayer:Armor() == 95)  then 
		armorBar1Lenght = 49
	end	
	if ( pPlayer:Armor() < 85 || pPlayer:Armor() == 85)  then 
		armorBar1Lenght = 46
	end		
	if (pPlayer:Armor() < 80 || pPlayer:Armor() == 80)  then 
		armorBar1Lenght = 35
	end	
	if (pPlayer:Armor() < 75 || pPlayer:Armor() == 75) then 
		armorBar1Lenght = 24	
	end		
	if (pPlayer:Armor() < 70 || pPlayer:Armor() == 70) then 
 		armorBar1Lenght = 13
	end
	
	if (pPlayer:Armor() < 60 || pPlayer:Armor() == 60) then 
 		armorBar2Lenght = 50
	end	
	if (pPlayer:Armor() < 55 || pPlayer:Armor() == 55) then 
 		armorBar2Lenght = 35
	end	
	if (pPlayer:Armor() < 50 || pPlayer:Armor() == 50) then 
 		armorBar2Lenght = 29
	end	
	if (pPlayer:Armor() < 45 || pPlayer:Armor() == 45) then 
 		armorBar2Lenght = 24
	end	
	if (pPlayer:Armor() < 40 || pPlayer:Armor() == 40) then 
 		armorBar2Lenght = 13
	end
	
	if (pPlayer:Armor() < 25 || pPlayer:Armor() == 25) then 
 		armorBar3Lenght = 50
	end
	if (pPlayer:Armor() < 20 || pPlayer:Armor() == 20) then 
 		armorBar3Lenght = 36
	end
	if (pPlayer:Armor() < 15 || pPlayer:Armor() == 15) then 
 		armorBar3Lenght = 24
	end	
	if (pPlayer:Armor() < 10 || pPlayer:Armor() == 10) then 
 		armorBar3Lenght = 13
	end		
	
	if (pPlayer:Armor() == 100 || pPlayer:Armor() > 66) then 
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(150, ScrH() - 155, 55, 8)
		
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(207 , ScrH() - 155, 55, 8)
		
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(264 , ScrH() - 155, armorBar1Lenght, 8)
	end
	
	if (pPlayer:Armor() == 66 || pPlayer:Armor() > 33) then
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(150 , ScrH() - 155, 55, 8)
		
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(207 , ScrH() - 155, armorBar2Lenght, 8)
	end
	
	if (pPlayer:Armor() == 33 || pPlayer:Armor() > 0) then
		surface.SetDrawColor( 58, 101, 181 )
		surface.DrawRect(150 , ScrH() - 155, armorBar3Lenght, 8)
	end
end )

hook.Add( "HUDShouldDraw", "GWZ_HudShouldDraw", function( name )
	if ( hide[ name ] ) and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool() then return false end
end )



 