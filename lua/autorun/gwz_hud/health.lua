----------------------------------------------------
-- Health 
----------------------------------------------------

if CLIENT then
    local hide = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true
    }

    CreateClientConVar("gwz_hud_offset_from_corner", "0", true, false, "Offsets the HUD horizontally (minimum 1, maximum 100)")
    CreateClientConVar("gwz_hud_scale_multiplier", "1", true, false, "Scale of the HUD (minimum 0, maximum 5)")

    function CreateFonts()
        multiplier = math.Clamp(GetConVar("gwz_hud_scale_multiplier"):GetFloat(), 1, 5)
        
        surface.CreateFont( "GWZ_SmallNickname", {
            font = "Open Sans Light",
            extended = false,
            shadow = true,	
            size = multiplier * 20,
            antialias = true,
        } )
    end
    
    cvars.AddChangeCallback("gwz_hud_scale_multiplier", function()
        CreateFonts()
    end)

    hook.Add( "HUDShouldDraw", "HideHUD", function( name )
        if ( hide[ name ] ) and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool() then return false end
    end )

    -- Textures
    local bgGradient = Material( "hud/bg_gradient.png" )
    local iconServerAdmin = Material( "hud/icon_serveradmin.png" )

    -- By default set is as false
    hud_isDisplayed = false
    background_alpha = 0
    text_alpha = 0

    hook.Add( "HUDPaint", "GWZ_HealthPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end        
        if ( !IsValid( LocalPlayer() ) ) then return end

        local pPlayer = LocalPlayer()

        if pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 30, background_alpha, 255)
            text_alpha = Lerp(FrameTime() * 30, text_alpha, 255)
        end

        if !pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 50, background_alpha, 0)       
            text_alpha = Lerp(FrameTime() * 50, text_alpha, 0)
        end

        hud_offset = math.Clamp(GetConVar("gwz_hud_offset_from_corner"):GetInt(), 0, 100)
        hud_scale = math.Clamp(GetConVar("gwz_hud_scale_multiplier"):GetFloat(), 1, 5)

        -- Draw transparent background with gradient
        surface.SetDrawColor( 255, 255, 255, background_alpha )
        surface.SetMaterial( bgGradient )
        surface.DrawTexturedRect( (35 + hud_offset) * hud_scale, ScrH() - 104 * hud_scale - (hud_offset / 2), 322 * hud_scale, 70 * hud_scale)

        local playerColor = Vector( GetConVarString( "cl_playercolor" ) )
        playerColor = playerColor + Vector(0.45, 0.45, 0.45)
        playerColor = playerColor:ToColor()

        -- Draw user's nickname
        surface.SetFont( "GWZ_SmallNickname" )
        surface.SetTextColor( playerColor, text_alpha )
        surface.SetTextPos( ( 70 + hud_offset) * hud_scale, ScrH() - 98 * hud_scale - (hud_offset / 2)) 
        surface.DrawText( pPlayer:GetName() )

        -- Draw a star if user is a superadmin
        if pPlayer:IsSuperAdmin() then
            surface.SetDrawColor( playerColor, text_alpha )
            surface.SetMaterial( iconServerAdmin )
            surface.DrawTexturedRect( (45 + hud_offset) * hud_scale, ScrH() - 96 * hud_scale - (hud_offset / 2), 16 * hud_scale, 16 * hud_scale)
        end

    end )
end