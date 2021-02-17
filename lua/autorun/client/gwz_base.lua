// ===========================================================================
// Warzone-like hud for Garry's Mod by URAKOLOUY5
// ===========================================================================

// -----------------------------------------------------------------
// Purpose: Create all necessities for GWZ-hud
// -----------------------------------------------------------------

-- Main convars
CreateClientConVar("gwz_hud_enable", 1, true, false, "Enable drawing Warzone-like hud")

-- Main ints
local pPlayer = LocalPlayer()
local m_iPlayerColor = GetConVar("cl_playercolor")

local m_bAllowBreakEffect = false

GWZ = {}

-- Scheme fonts
surface.CreateFont( "GWZ_Small", {
	font = "Normative Pro Light",
	extended = false,
	shadow = true,	
	size = 20,
	antialias = true,
} )

surface.CreateFont( "GWZ_SmallNoShadow", {
	font = "Normative Pro Light",
	extended = false,	
	size = 20,
	antialias = true,	
} )

surface.CreateFont( "GWZ_Medium", {
	font = "Normative Pro Light",
	extended = false,
	shadow = true,	
	size = 30,
	antialias = true,	
} )

surface.CreateFont( "GWZ_MediumNoShadow", {
	font = "Normative Pro Light",
	extended = false,
	size = 30,
	antialias = true,	
} )

surface.CreateFont( "GWZ_Numbers", {
	font = "Roag-Bold",
	extended = false,
	shadow = true,	
	size = 30,
	antialias = true,	
} )

// -----------------------------------------------------------------
// Purpose: Client scheme for hud (to keep the idea from Modern 
// Warfare / Warzone, I did not decide to do the ability to change 
// colors in the hud)
// -----------------------------------------------------------------

-- Colors
local m_clMainBright = Color( 222, 218, 205 )
local m_clMainDark = Color( 61, 58, 56 )

-- Textures
local m_sBgGradient = Material( "hud/bg_gradient.png" )
local m_sHosterStar = Material( "hud/hoster_star.png" )

local m_sArmorBreakFullScreen = Material( "hud/armor_broken_fullscreen.png" )
local m_sArmorIcon = Material( "hud/armor_icon.png" )
local m_sArmorBox = Material( "hud/armor_circle.png" )
local m_sArmorBoxMedium = Material( "hud/armor_circle_med.png" )
local m_sArmorBoxUnbound = Material( "hud/armor_circle_unbound.png" )


// -----------------------------------------------------------------
// Purpose: Display player's information (nickname, current health 
// and armor) on hud
// -----------------------------------------------------------------
function GWZ.DrawPlayersInfo()
end

local hide = 
{
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
	if !pPlayer:Alive() then m_bAllowBreakEffect = false end
	
	-- Draw armor break under a all hud elements
	GWZ:ApplyArmorBreakEffect() 
	
	-- Draw user's info in bottom left corner
	GWZ:DrawUserInfo() 
	
	gameevent.Listen( "player_spawn" )
	hook.Add("player_spawn", "RemoveWarzoneBreakSound", function( data )
		m_bAllowBreakEffect = false
	end)	
end )

hook.Add( "HUDShouldDraw", "GWZ_HudShouldDraw", function( name )
	if ( hide[ name ] ) and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool() then return false end
end )

function GWZ:ApplyArmorBreakEffect() 
	if pPlayer:Armor() == 0 then
		surface.SetDrawColor( 145, 145, 145, 255 )
		surface.SetMaterial( m_sArmorBreakFullScreen )
		surface.DrawTexturedRect( 0 , 0, ScrW(), ScrH() )
	end
	
	-- Play armor break sound when it's broked by enemy
	if pPlayer:Armor() == 0 then
		if m_bAllowBreakEffect == true then
			surface.PlaySound("player/hit_armor_break_01.wav")
			m_bAllowBreakEffect = false
		end
	end	
end

function GWZ:DrawUserInfo() 
	-- Draw transparent background with gradient
	surface.SetDrawColor( 255, 255, 255, 205 )
	surface.SetMaterial( m_sBgGradient )
	surface.DrawTexturedRect( 2 , ScrH() - 120, 394, 120 )
	
	-- Draw user's name in it's background
	surface.SetFont( "GWZ_Small" )
	surface.SetTextColor( m_clMainBright )
	surface.SetTextPos( 53 , ScrH() - 100 ) 
	surface.DrawText( pPlayer:GetName() )
	
	-- Draw a star near player's name if he's superadmin
	if pPlayer:IsSuperAdmin() then
		surface.SetDrawColor( 196, 192, 180, 205 )
		surface.SetMaterial( m_sHosterStar )
		surface.DrawTexturedRect( 30 , ScrH() - 99, 16, 16 )
	end

	-- Draw armor icon (VManip Warzone Armir plates)	
	m_inputWarzoneArmorText = "UNBOUND"
	
	m_inputWarzoneArmor = input.LookupBinding( "+armorplate" )
	if m_inputWarzoneArmor then
		m_inputWarzoneArmorText = string.upper(m_inputWarzoneArmor) 
	end
	
	if !m_inputWarzoneArmor then
		m_inputWarzoneArmorText = "UNBOUND"
	end
	
	if pPlayer:GetArmorPlates() > 0 then
	
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 1) then
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 433 , ScrH() - 53, 30, 35 )

			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 423 , ScrH() - 115, 50, 59 )
			
			surface.SetFont( "GWZ_Medium" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 479 , ScrH() - 99 ) 
			surface.DrawText( pPlayer:GetArmorPlates() )
		end	
		
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 2) then
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 437 , ScrH() - 53, 32, 35 )

			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 429 , ScrH() - 115, 50, 59 )
			
			surface.SetFont( "GWZ_Medium" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 483 , ScrH() - 99 ) 
			surface.DrawText( pPlayer:GetArmorPlates() )
		end	
		
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 3) then
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 437, ScrH() - 53, 42, 35 )

			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 433 , ScrH() - 115, 50, 59 )
			
			surface.SetFont( "GWZ_Medium" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 488 , ScrH() - 99 ) 
			surface.DrawText( pPlayer:GetArmorPlates() )	
		end	

		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 4) then
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.SetMaterial( m_sArmorBoxMedium )
			surface.DrawTexturedRect( 436, ScrH() - 53, 60, 35 )

			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 439 , ScrH() - 115, 50, 59 )
			
			surface.SetFont( "GWZ_Medium" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 492 , ScrH() - 99 ) 
			surface.DrawText( pPlayer:GetArmorPlates() )	
		end	

		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 5) then
			surface.SetDrawColor( 255, 255, 255, 200 )
			surface.SetMaterial( m_sArmorBoxMedium )
			surface.DrawTexturedRect( 436, ScrH() - 53, 65, 35 )

			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 444 , ScrH() - 115, 50, 59 )
			
			surface.SetFont( "GWZ_Medium" )
			surface.SetTextColor( 255, 255, 255 )
			surface.SetTextPos( 496 , ScrH() - 99 ) 
			surface.DrawText( pPlayer:GetArmorPlates() )
		end				
			
		if !m_inputWarzoneArmor then
			surface.SetDrawColor( 255, 255, 255, 250 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 455 , ScrH() - 115, 50, 59 )
			
			surface.SetDrawColor( 255, 255, 255, 255 )		
			surface.SetMaterial( m_sArmorBoxUnbound )
			surface.DrawTexturedRect( 431 , ScrH() - 54, 104, 35 )	
		end
				
		surface.SetFont( "GWZ_SmallNoShadow" )
		surface.SetTextColor( 0, 0, 0 )
		surface.SetTextPos( 443.1 , ScrH() - 45.2 ) 
		surface.DrawText( m_inputWarzoneArmorText )			
	end
	
	if pPlayer:GetArmorPlates() == 0 then
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 1) then
			surface.SetDrawColor( 255, 255, 255, 90 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 433 , ScrH() - 53, 30, 35 )

			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 423 , ScrH() - 115, 50, 59 )
		end	
		
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 2) then
			surface.SetDrawColor( 255, 255, 255, 90 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 437 , ScrH() - 53, 32, 35 )

			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 429 , ScrH() - 115, 50, 59 )
		end	
		
		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 3) then
			surface.SetDrawColor( 255, 255, 255, 90 )
			surface.SetMaterial( m_sArmorBox )
			surface.DrawTexturedRect( 437, ScrH() - 53, 42, 35 )

			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 433 , ScrH() - 115, 50, 59 )	
		end	

		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 4) then
			surface.SetDrawColor( 255, 255, 255, 90 )
			surface.SetMaterial( m_sArmorBoxMedium )
			surface.DrawTexturedRect( 436, ScrH() - 53, 60, 35 )

			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 439 , ScrH() - 115, 50, 59 )
		end	

		if (m_inputWarzoneArmor && string.len(m_inputWarzoneArmor) == 5) then
			surface.SetDrawColor( 255, 255, 255, 90 )
			surface.SetMaterial( m_sArmorBoxMedium )
			surface.DrawTexturedRect( 436, ScrH() - 53, 65, 35 )

			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 444 , ScrH() - 115, 50, 59 )
		end				
			
		if !m_inputWarzoneArmor then
			surface.SetDrawColor( 255, 255, 255, 150 )
			surface.SetMaterial( m_sArmorIcon )
			surface.DrawTexturedRect( 455 , ScrH() - 115, 50, 59 )
			
			surface.SetDrawColor( 255, 255, 255, 255 )		
			surface.SetMaterial( m_sArmorBoxUnbound )
			surface.DrawTexturedRect( 431 , ScrH() - 54, 104, 35 )	
		end
		
		surface.SetFont( "GWZ_SmallNoShadow" )
		surface.SetTextColor( 0, 0, 0 )
		surface.SetTextPos( 443.1 , ScrH() - 45.2 ) 
		surface.DrawText( m_inputWarzoneArmorText )			
	end

	
	-- Draw health bar
	surface.SetDrawColor( m_clMainDark )
    surface.DrawRect(50 , ScrH() - 60, 171, 8)
	
	if pPlayer:Health() > 100 then
		healthBarLenght = 171
	else
		healthBarLenght = pPlayer:Health() * 1.71
	end
	
	surface.SetDrawColor( m_clMainBright )
    surface.DrawRect( 50 , ScrH() - 60, healthBarLenght, 8)
	
	-- Draw armor plates	
	surface.SetDrawColor( m_clMainDark )
	surface.DrawRect(50 , ScrH() - 73, 55, 8)
		
	surface.SetDrawColor( m_clMainDark )
	surface.DrawRect(108 , ScrH() - 73, 55, 8)
		
	surface.SetDrawColor( m_clMainDark )
	surface.DrawRect(166 , ScrH() - 73, 55, 8)
	
	
	------------------------------------------------------------------
	if ( pPlayer:Armor() > 0 || pPlayer:Armor() == 8)  then 
		armorBar1Lenght = 13.75
	end	
	
	if ( pPlayer:Armor() > 8 || pPlayer:Armor() == 16)  then 
		armorBar1Lenght = 27.5
	end	
	
	if ( pPlayer:Armor() > 16 || pPlayer:Armor() == 24)  then 
		armorBar1Lenght = 41.25
	end	
	
	if ( pPlayer:Armor() > 24 || pPlayer:Armor() == 33)  then 
		armorBar1Lenght = 55
	end	
	------------------------------------------------------------------
	
	if ( pPlayer:Armor() > 33 || pPlayer:Armor() == 41)  then 
		armorBar2Lenght = 13.75
	end	
	
	if ( pPlayer:Armor() > 41 || pPlayer:Armor() == 49)  then 
		armorBar2Lenght = 27.5
	end	
	
	if ( pPlayer:Armor() > 49 || pPlayer:Armor() == 57)  then 
		armorBar2Lenght = 41.25
	end	
	
	if ( pPlayer:Armor() > 57 || pPlayer:Armor() == 66)  then 
		armorBar2Lenght = 55
	end	
	------------------------------------------------------------------
	
	if ( pPlayer:Armor() > 66 || pPlayer:Armor() == 74)  then 
		armorBar3Lenght = 13.75
	end	
	
	if ( pPlayer:Armor() > 74 || pPlayer:Armor() == 82)  then 
		armorBar3Lenght = 27.5
	end	
	
	if ( pPlayer:Armor() > 82 || pPlayer:Armor() == 90)  then 
		armorBar3Lenght = 41.25
	end
			
	if ( pPlayer:Armor() > 90 || pPlayer:Armor() == 100)  then 
		armorBar3Lenght = 55
	end	
	------------------------------------------------------------------

	if (pPlayer:Armor() > 66) then 
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(50 , ScrH() - 73, 55, 8)
			
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(108 , ScrH() - 73, 55, 8)
			
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(166 , ScrH() - 73, armorBar3Lenght, 8)
	end

	if (pPlayer:Armor() > 33) then 
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(50 , ScrH() - 73, 55, 8)
		
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(108 , ScrH() - 73, armorBar2Lenght, 8)
	end
	
	if (pPlayer:Armor() > 0) then 
		surface.SetDrawColor( 38, 95, 179 )
		surface.DrawRect(50 , ScrH() - 73, armorBar1Lenght, 8)
	end	
	
	if pPlayer:Armor() > 0 then
		m_bAllowBreakEffect = true
	end
end
