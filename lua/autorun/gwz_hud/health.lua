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

    // Shared fonts (for other hud elements too :D )
    function CreateFonts()
        multiplier = math.Clamp(GetConVar("gwz_hud_scale_multiplier"):GetFloat(), 1, 5)
        
        surface.CreateFont( "GWZ_SmallNickname", {
            font = "Open Sans Light",
            extended = false,
            shadow = true,	
            size = multiplier * 18,
            antialias = true,
        } )

        surface.CreateFont( "GWZ_VerySmall", {
            font = "Open Sans",
            extended = false,
            size = multiplier * 28,
            antialias = true,
        } )

        surface.CreateFont( "GWZ_Small", {
            font = "Open Sans",
            extended = false,
            shadow = true,	
            size = multiplier * 30,
            antialias = true,
        } )

        surface.CreateFont( "GWZ_SmallBlur", {
            font = "Open Sans",
            extended = false,
            shadow = true,
            blursize = 1,
            size = multiplier * 30,
            antialias = true,
        } )  
        
        surface.CreateFont( "GWZ_NumberBoldBlur", {
            font = "Liberation Sans Bold",
            extended = false,
            blursize = 2,
            size = multiplier * 50,
            antialias = true,
        } )

        surface.CreateFont( "GWZ_NumberBold", {
            font = "Liberation Sans Bold",
            extended = false,
            size = multiplier * 50,
            antialias = true,
        } )

        surface.CreateFont( "GWZ_NumberBlur", {
            font = "Liberation Sans",
            extended = false,
            blursize = 2,
            size = multiplier * 30,
            antialias = true,
        } )
        
        surface.CreateFont( "GWZ_Number", {
            font = "Liberation Sans",
            extended = false,
            size = multiplier * 30,
            antialias = true,
        } )        
    end

    CreateFonts()
    
    cvars.AddChangeCallback("gwz_hud_scale_multiplier", function()
        CreateFonts()
    end)

    hook.Add( "HUDShouldDraw", "HideHUD", function( name )
        if ( hide[ name ] ) and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool() then return false end
    end )

    -- Textures
    local bgGradient = Material( "hud/bg_gradient.png" )
    local iconServerAdmin = Material( "hud/icon_serveradmin.png" )
    local iconArmor = Material( "hud/armor_icon.png", "smooth" )
    local bgArmorGrain = Material( "hud/bg_armor_grain.png", "noclamp")

    local rect_darkbg = Color(61, 58, 56, 155)
    local rect_lightbg = Color(197, 200, 191)
    local rect_redbg = Color(183, 18, 26, 155)

    -- By default set is as false
    hud_isDisplayed = false
    background_alpha = 0
    dark_background_alpha = 0
    light_background_alpha = 0
    text_alpha = 0
    lowhp_alpha = 0
    armor_icon_alpha = 0

    allow_armorbreak_effect = false

    textpos = 367
    imagepos = 312
    imageposoffset = 0

    lenght = 169

    hook.Add( "HUDPaint", "GWZ_HealthPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end        
        if ( !IsValid( LocalPlayer() ) ) then return end

        local pPlayer = LocalPlayer()

        if pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 30, background_alpha, 255)
            text_alpha = Lerp(FrameTime() * 30, text_alpha, 255)
            dark_background_alpha = Lerp(FrameTime() * 30, dark_background_alpha, 155)
            light_background_alpha = Lerp(FrameTime() * 30, light_background_alpha, 191)
            armor_icon_alpha = Lerp(FrameTime() * 30, armor_icon_alpha, 200)
        end

        if !pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 50, background_alpha, 0)       
            text_alpha = Lerp(FrameTime() * 50, text_alpha, 0)
            dark_background_alpha = Lerp(FrameTime() * 100, dark_background_alpha, 0)
            light_background_alpha = Lerp(FrameTime() * 50, light_background_alpha, 0)
            armor_icon_alpha = Lerp(FrameTime() * 30, armor_icon_alpha, 0)            

            allow_armorbreak_effect = false;
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
        surface.SetTextColor( playerColor.r, playerColor.g, playerColor.b, text_alpha )
        surface.SetTextPos( ( 61 + hud_offset) * hud_scale, ScrH() - 98 * hud_scale - (hud_offset / 2)) 
        surface.DrawText( pPlayer:GetName() )

        -- Draw a star if user is a superadmin
        if pPlayer:IsSuperAdmin() then
            surface.SetDrawColor( playerColor.r, playerColor.g, playerColor.b, text_alpha )
            surface.SetMaterial( iconServerAdmin )
            surface.DrawTexturedRect( (40 + hud_offset) * hud_scale, ScrH() - 98 * hud_scale - (hud_offset / 2), 16 * hud_scale, 16 * hud_scale)
        end

        local function sinlerp(t, from, to)
            return from + math.sin(t * math.pi * 0.5) * (to - from)
        end

        --- Draw healthbar
        -- Background
        surface.SetDrawColor( rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha )
        surface.DrawRect((64 + hud_offset) * hud_scale, ScrH() - 65 * hud_scale - (hud_offset / 2), 197 * hud_scale, 8 * hud_scale)

        -- Foreground red
        surface.SetDrawColor( rect_redbg.r, rect_redbg.g, rect_redbg.b, dark_background_alpha )
        start = SysTime()
        lenght = Lerp(FrameTime() * 2, lenght, pPlayer:Health() * 1.95)
        surface.DrawRect((65 + hud_offset) * hud_scale, ScrH() - 64 * hud_scale - (hud_offset / 2), lenght * hud_scale, 6 * hud_scale)

        -- Foreground health
        surface.SetDrawColor( rect_lightbg.r, rect_lightbg.g, rect_lightbg.b, light_background_alpha )
        surface.DrawRect((65 + hud_offset) * hud_scale, ScrH() - 64 * hud_scale - (hud_offset / 2), pPlayer:Health() * 1.95 * hud_scale, 6 * hud_scale)

        --- Draw armorbar   
        -- Background
        surface.SetDrawColor( rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha )
        surface.DrawRect( (64 + hud_offset) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 63 * hud_scale, 10 * hud_scale )

        surface.SetDrawColor( rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha )
        surface.DrawRect( (130 + hud_offset) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 63 * hud_scale, 10 * hud_scale )

        surface.SetDrawColor( rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha )
        surface.DrawRect( (197 + hud_offset) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 63 * hud_scale, 10 * hud_scale )
        
        -- Armor chunks
        surface.SetDrawColor( 0, 130, 255, background_alpha )
        surface.SetMaterial( bgArmorGrain )
        armor1Lenght = math.Clamp((pPlayer:Armor() / 4) * 7.63, 0, 63)
        surface.DrawTexturedRectUV( (64 + hud_offset) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 0 + armor1Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10 )

        surface.SetDrawColor( 0, 130, 255, background_alpha )
        surface.SetMaterial( bgArmorGrain )
        armor2Lenght = math.Clamp((pPlayer:Armor() - 40) * 2.2, 0, 63)
        surface.DrawTexturedRectUV( (130 + hud_scale) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 0 + armor2Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10 )

        surface.SetDrawColor( 0, 130, 255, background_alpha )
        surface.SetMaterial( bgArmorGrain )
        armor3Lenght = math.Clamp((pPlayer:Armor() - 70) * 2.2, 0, 63)
        surface.DrawTexturedRectUV( (197 + hud_scale) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset / 2), 0 + armor3Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10 )

        if (pPlayer:Armor() > 0 and pPlayer:Alive()) then
            allow_armorbreak_effect = true
        end

        if pPlayer:Armor() == 0 and allow_armorbreak_effect then
            surface.PlaySound("player/hit_armor_break_01.wav")
            allow_armorbreak_effect = false            
        end

        if pcall(function() return pPlayer:GetArmorPlates() end) then 
            -- Draw armor icon
            surface.SetDrawColor( 255, 255, 255, armor_icon_alpha )
            surface.SetMaterial( iconArmor )
            surface.DrawTexturedRect( (imagepos + hud_offset) * hud_scale, ScrH() - 104 * hud_scale - (hud_offset / 2), 59 * hud_scale, 68 * hud_scale)

            if pPlayer:GetArmorPlates() == 0 and pPlayer:Alive() then
                armor_icon_alpha = Lerp(FrameTime() * 20, armor_icon_alpha, 70)
            end

            if pPlayer:GetArmorPlates() > 0 and pPlayer:Alive() then
                armor_icon_alpha = Lerp(FrameTime() * 20, armor_icon_alpha, 200)

                surface.SetFont( "GWZ_SmallBlur" )
                surface.SetTextColor( 0, 0, 0, text_alpha )
                surface.SetTextPos( ( imagepos + 54 + hud_offset) * hud_scale, ScrH() - 86 * hud_scale - (hud_offset / 2)) 
                surface.DrawText( pPlayer:GetArmorPlates() )
    
                surface.SetFont( "GWZ_Small" )
                surface.SetTextColor( 255, 255, 255, text_alpha )
                surface.SetTextPos( ( (imagepos + 54) + hud_offset) * hud_scale, ScrH() - 85 * hud_scale - (hud_offset / 2)) 
                surface.DrawText( pPlayer:GetArmorPlates() )                
            end

            bind = input.LookupBinding( "+armorplate" )
            if bind == nil then
                bindtext = "UNBOUND"
            else
                bindtext = string.upper(bind)
            end

            surface.SetFont( "GWZ_VerySmall" )
            draw.RoundedBox(10 * (hud_scale / 2), (331.5 + hud_offset) * hud_scale, ScrH() - 40 * hud_scale - (hud_offset / 2), select(1, surface.GetTextSize(bindtext)) + (6 * hud_scale), 24 * hud_scale, Color(255, 255, 255, armor_icon_alpha) )

            surface.SetTextColor( 0, 0, 0, text_alpha )
            surface.SetTextPos( ( 334 + hud_offset) * hud_scale, ScrH() - 43 * hud_scale - (hud_offset / 2)) 

            imageposoffset = select(1, surface.GetTextSize(bindtext))
            imagepos = 308 + (imageposoffset / 2)

            surface.DrawText(bindtext)
        end
    end )

    local pPlayer = LocalPlayer()   
end