----------------------------------------------------
-- Health 
----------------------------------------------------
CreateConVar("gwz_hud_server_realism_mode", "0", FCVAR_LUA_SERVER, false)

if CLIENT then
    local hidehealth = {
        ["CHudHealth"] = true,
        ["CHudBattery"] = true
    }

    CreateClientConVar("gwz_hud_offset_h", "0", true, false, "Offsets the HUD horizontally (minimum 1, maximum 100)")
    CreateClientConVar("gwz_hud_offset_v", "0", true, false, "Offsets the HUD vertically (minimum 1, maximum 100)")
    CreateClientConVar("gwz_hud_scale_multiplier", "1", true, false, "Scale of the HUD (minimum 1, maximum 5)")

    -- Shared fonts (for other hud elements too )
    function CreateFonts()
        multiplier = math.Clamp(GetConVar("gwz_hud_scale_multiplier"):GetFloat(), 0.2, 5)

        surface.CreateFont("GWZ_SmallNickname", {
            font = "Roag-UltraLight",
            extended = false,
            shadow = true,
            size = multiplier * 16,
            antialias = true,
        })

        surface.CreateFont("GWZ_VerySmall", {
            font = "Open Sans Regular",
            extended = false,
            size = multiplier * 28,
            antialias = true,
        })

        surface.CreateFont("GWZ_Small", {
            font = "Roag-UltraLight",
            extended = false,
            shadow = true,
            size = multiplier * 30,
            antialias = true,
        })

        surface.CreateFont("GWZ_SmallBlur", {
            font = "Roag-Light",
            extended = false,
            shadow = true,
            blursize = 1,
            size = multiplier * 30,
            antialias = true,
        })

        surface.CreateFont("GWZ_NumberBoldBlur", {
            font = "Liberation Sans Bold",
            extended = false,
            blursize = 2,
            size = multiplier * 50,
            antialias = true,
        })

        surface.CreateFont("GWZ_NumberBold", {
            font = "Liberation Sans Bold",
            extended = false,
            size = multiplier * 50,
            antialias = true,
        })

        surface.CreateFont("GWZ_NumberBlur", {
            font = "Roag-Regular",
            extended = false,
            blursize = 2,
            size = multiplier * 30,
            antialias = true,
        })

        surface.CreateFont("GWZ_Number", {
            font = "Roag-Regular",
            extended = false,
            size = multiplier * 30,
            antialias = true,
        })
    end

    CreateFonts()

    cvars.AddChangeCallback("gwz_hud_scale_multiplier", function()
        CreateFonts()
    end)

    hook.Add("HUDShouldDraw", "GWZ_HealthHideHUD", function(name)
        if (hidehealth[name]) and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool() then return false end
    end)

    -- Textures
    local bgGradient = Material("hud/bg_gradient.png")
    local iconServerAdmin = Material("hud/icon_serveradmin.png")
    local iconArmor = Material("hud/armor_icon.png", "smooth")
    local bgArmorGrain = Material("hud/bg_armor_grain.png", "noclamp")
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
    imageposoffset = 0
    lenght = 169

    hook.Add("HUDPaint", "GWZ_HealthPaint", function()
        if not GetConVar("gwz_hud_enable"):GetBool() or not GetConVar("cl_drawhud"):GetBool() then return end
        if GetConVar("gwz_hud_server_realism_mode"):GetBool() then return end
        if (not IsValid(LocalPlayer())) then return end
        local pPlayer = LocalPlayer()

        if pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 30, background_alpha, 255)
            text_alpha = Lerp(FrameTime() * 30, text_alpha, 255)
            dark_background_alpha = Lerp(FrameTime() * 30, dark_background_alpha, 155)
            light_background_alpha = Lerp(FrameTime() * 30, light_background_alpha, 191)
            armor_icon_alpha = Lerp(FrameTime() * 30, armor_icon_alpha, 200)
        end

        if not pPlayer:Alive() then
            start = SysTime()
            background_alpha = Lerp(FrameTime() * 50, background_alpha, 0)
            text_alpha = Lerp(FrameTime() * 50, text_alpha, 0)
            dark_background_alpha = Lerp(FrameTime() * 100, dark_background_alpha, 0)
            light_background_alpha = Lerp(FrameTime() * 50, light_background_alpha, 0)
            armor_icon_alpha = Lerp(FrameTime() * 30, armor_icon_alpha, 0)
            allow_armorbreak_effect = false
        end

        hud_offset_h = math.Clamp(GetConVar("gwz_hud_offset_h"):GetInt(), 0, 100)
        hud_offset_v = math.Clamp(GetConVar("gwz_hud_offset_v"):GetInt(), 0, 100)
        hud_scale = math.Clamp(GetConVar("gwz_hud_scale_multiplier"):GetFloat(), 1, 5)
        -- Draw transparent background with gradient
        surface.SetDrawColor(255, 255, 255, background_alpha)
        surface.SetMaterial(bgGradient)
        surface.DrawTexturedRect((35 + hud_offset_h) * hud_scale, ScrH() - 104 * hud_scale - (hud_offset_v / 2), 322 * hud_scale, 70 * hud_scale)
        local playerColor = Vector(GetConVar("cl_playercolor"):GetString())
        playerColor = playerColor + Vector(0.45, 0.45, 0.45)
        playerColor = playerColor:ToColor()
        -- Draw user's nickname
        surface.SetFont("GWZ_SmallNickname")
        surface.SetTextColor(playerColor.r, playerColor.g, playerColor.b, text_alpha)
        surface.SetTextPos((61 + hud_offset_h) * hud_scale, ScrH() - 99 * hud_scale - (hud_offset_v / 2))
        surface.DrawText(pPlayer:GetName())

        -- Draw a star if user is a superadmin
        if pPlayer:IsSuperAdmin() then
            surface.SetDrawColor(playerColor.r, playerColor.g, playerColor.b, text_alpha)
            surface.SetMaterial(iconServerAdmin)
            surface.DrawTexturedRect((40 + hud_offset_h) * hud_scale, ScrH() - 98 * hud_scale - (hud_offset_v / 2), 16 * hud_scale, 16 * hud_scale)
        end

        --- Draw healthbar
        -- Background
        surface.SetDrawColor(rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha)
        surface.DrawRect((64 + hud_offset_h) * hud_scale, ScrH() - 65 * hud_scale - (hud_offset_v / 2), 197 * hud_scale, 8 * hud_scale)
        local healthscale = math.Remap(pPlayer:Health(), 0, pPlayer:GetMaxHealth(), 0, 195 * hud_scale)
        -- Foreground red
        surface.SetDrawColor(rect_redbg.r, rect_redbg.g, rect_redbg.b, dark_background_alpha)
        start = SysTime()
        lenght = Lerp(FrameTime() * 2, lenght, math.Clamp(healthscale, 0, 195))
        surface.DrawRect((65 + hud_offset_h) * hud_scale, ScrH() - 64 * hud_scale - (hud_offset_v / 2), lenght, 6 * hud_scale)
        -- Foreground health
        surface.SetDrawColor(rect_lightbg.r, rect_lightbg.g, rect_lightbg.b, light_background_alpha)
        surface.DrawRect((65 + hud_offset_h) * hud_scale, ScrH() - 64 * hud_scale - (hud_offset_v / 2), healthscale, 6 * hud_scale)
        --- Draw armorbar   
        -- Background
        surface.SetDrawColor(rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha)
        surface.DrawRect((64 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 63 * hud_scale, 10 * hud_scale)
        surface.SetDrawColor(rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha)
        surface.DrawRect((130 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 63 * hud_scale, 10 * hud_scale)
        surface.SetDrawColor(rect_darkbg.r, rect_darkbg.g, rect_darkbg.b, dark_background_alpha)
        surface.DrawRect((197 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 63 * hud_scale, 10 * hud_scale)
        -- Armor chunks
        surface.SetDrawColor(0, 110, 200, background_alpha)
        --surface.SetMaterial( bgArmorGrain )
        armor1Lenght = math.Remap(pPlayer:Armor(), 0, pPlayer:GetMaxArmor() / 3, 0, 63)
        armor1Lenght = math.Clamp(armor1Lenght, 0, 63)
        surface.DrawRect((64 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 0 + armor1Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10)
        surface.SetDrawColor(0, 110, 200, background_alpha)
        --surface.SetMaterial( bgArmorGrain )
        armor2Lenght = math.Remap(pPlayer:Armor(), pPlayer:GetMaxArmor() / 3, pPlayer:GetMaxArmor() / 1.5, 0, 63)
        armor2Lenght = math.Clamp(armor2Lenght, 0, 63)
        surface.DrawRect((130 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 0 + armor2Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10)
        surface.SetDrawColor(0, 110, 200, background_alpha)
        --surface.SetMaterial( bgArmorGrain )
        armor3Lenght = math.Remap(pPlayer:Armor(), pPlayer:GetMaxArmor() / 1.5, pPlayer:GetMaxArmor(), 0, 63)
        armor3Lenght = math.Clamp(armor3Lenght, 0, 63)
        surface.DrawRect((197 + hud_offset_h) * hud_scale, ScrH() - 78 * hud_scale - (hud_offset_v / 2), 0 + armor3Lenght * hud_scale, 10 * hud_scale, 0, 0, 63, 10)

        if (pPlayer:Armor() > 0 and pPlayer:Alive()) then
            allow_armorbreak_effect = true
        end

        if pPlayer:Armor() == 0 and allow_armorbreak_effect then
            surface.PlaySound("player/hit_armor_break_01.wav")
            allow_armorbreak_effect = false
        end

        if pcall(function() return pPlayer:GetArmorPlates() end) then
            local bind = input.LookupBinding("+armorplate")
            bindtext = ""

            if bind == nil then
                bindtext = "UNBOUND"
            else
                bindtext = string.upper(bind)
            end

            bindtextlen = string.len(bindtext)

            -- janky way to do this -- i tried to remap or use surface.GetTextSize()...
            if (bindtextlen == 1) then
                bindtextlen_remap = 19
                divide = 5
            elseif (bindtextlen == 2) then
                bindtextlen_remap = 36
                divide = 4
            elseif (bindtextlen == 3) then
                bindtextlen_remap = 54
                divide = 3
            elseif (bindtextlen == 4) then
                bindtextlen_remap = 72
                divide = 3
            elseif (bindtextlen == 5) then
                bindtextlen_remap = 90
                divide = 3
            elseif (bindtextlen == 6) then
                bindtextlen_remap = 108
                divide = 2.5
            elseif (bindtextlen == 7) then
                bindtextlen_remap = 126
                divide = 2
            elseif (bindtextlen == 8) then
                bindtextlen_remap = 144
                divide = 2
            elseif (bindtextlen == 9) then
                bindtextlen_remap = 162
                divide = 2
            elseif (bindtextlen == 10) then
                bindtextlen_remap = 180
                divide = 2
            end

            bindtextlen_remap = bindtextlen_remap * hud_scale
            --print("bindtextlen = " .. bindtextlen .. "\n" .. "bindtextlen_remap = " .. bindtextlen_remap .. "\n")
            boxsize = bindtextlen_remap
            -- Draw armor icon
            surface.SetDrawColor(255, 255, 255, armor_icon_alpha)
            surface.SetMaterial(iconArmor)
            surface.DrawTexturedRect((330 + hud_offset_h) * hud_scale + (boxsize / divide), ScrH() - 104 * hud_scale - (hud_offset_v / 2), 59 * hud_scale, 68 * hud_scale)
            draw.RoundedBox(10 * (hud_scale / 2), (348 + hud_offset_h) * hud_scale, ScrH() - 40 * hud_scale - (hud_offset_v / 2), boxsize + 3, 24 * hud_scale, Color(255, 255, 255, armor_icon_alpha))
            surface.SetFont("GWZ_VerySmall")
            surface.SetTextColor(0, 0, 0, text_alpha)
            surface.SetTextPos((350 + hud_offset_h) * hud_scale, ScrH() - 43 * hud_scale - (hud_offset_v / 2))
            surface.DrawText(bindtext)
        end
    end)
end