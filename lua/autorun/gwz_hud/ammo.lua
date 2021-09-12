if CLIENT then
    
    local hide = {
        ["CHudAmmo"] = true,
        ["CHudSecondaryAmmo"] = true
    }
    pPlayer = LocalPlayer()

    hook.Add( "HUDShouldDraw", "HideHUD2", function( name )
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
        if ( hide[ name ] ) then
            return false
        end
    end)

    local lightfg = Color(197, 200, 191)
    local light_darker_fg = Color(165, 170, 170)

    secondaryammotype = 
    {
        2,
        9,
        10,
        8,
        10,
        11,
        14,
        21,
        22,
        24
    }

    hook.Add( "HUDPaint", "GWZ_AmmoPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
        pPlayer = LocalPlayer()
        if ( !IsValid( pPlayer ) ) then return end

        hud_scale = math.Clamp( GetConVar("gwz_hud_scale_multiplier"):GetInt(), 1, 5)
        hud_offset_h = math.Clamp( GetConVar("gwz_hud_offset_h"):GetInt(), 0, 100)
        hud_offset_v = math.Clamp( GetConVar("gwz_hud_offset_v"):GetInt(), 0, 100)
    
        weapon = pPlayer:GetActiveWeapon()

        if IsValid(weapon) then
            ammo1 = math.Clamp(weapon:Clip1(), 0, 9999)
            ammo1mag = math.Clamp(pPlayer:GetAmmoCount(weapon:GetPrimaryAmmoType()), 0, 9999)

            ammo2 = math.Clamp(weapon:Clip2(), 0, 9999)
            ammo2mag = math.Clamp(pPlayer:GetAmmoCount(weapon:GetSecondaryAmmoType()), 0, 9999)
            if (weapon:GetMaxClip1() > -1 and weapon:GetPrimaryAmmoType() ~= -1 and !pPlayer:InVehicle()) then
                draw.DrawText(ammo1, "GWZ_NumberBoldBlur", (ScrW() - 195) - hud_offset_h, ScrH() - 130 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 200 ), TEXT_ALIGN_RIGHT)
                draw.DrawText(ammo1, "GWZ_NumberBold",  (ScrW() - 197) - hud_offset_h, ScrH() - 132 * hud_scale - (hud_offset_v / 2), lightfg, TEXT_ALIGN_RIGHT)

                draw.DrawText(ammo1mag, "GWZ_NumberBlur",  (ScrW() - 198) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT)
                draw.DrawText(ammo1mag, "GWZ_Number",  (ScrW() - 200) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), light_darker_fg, TEXT_ALIGN_RIGHT)

                for _,v in pairs(secondaryammotype) do
                    if (weapon:GetSecondaryAmmoType() == v) then
                        draw.DrawText("| " .. ammo2mag, "GWZ_NumberBlur",  (ScrW() - 188) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 255 ), TEXT_ALIGN_LEFT)
                        draw.DrawText("| " .. ammo2mag, "GWZ_Number",  (ScrW() - 190) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), light_darker_fg, TEXT_ALIGN_LEFT)
                    end
                end
            elseif (weapon:GetMaxClip1() == -1 and !pPlayer:InVehicle()) then
                for _,v in pairs(secondaryammotype) do
                    if (weapon:GetSecondaryAmmoType() == v or weapon:GetPrimaryAmmoType() == v) then
                        draw.DrawText(ammo1mag, "GWZ_NumberBoldBlur", (ScrW() - 195) - hud_offset_h, ScrH() - 130 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 200 ), TEXT_ALIGN_RIGHT)
                        draw.DrawText(ammo1mag, "GWZ_NumberBold",  (ScrW() - 197) - hud_offset_h, ScrH() - 132 * hud_scale - (hud_offset_v / 2), lightfg, TEXT_ALIGN_RIGHT)
                    end
                end
            end
           
            if (pPlayer:InVehicle()) then
                local vehicle = pPlayer:GetVehicle()
                vehicle_ammo = select(3, vehicle:GetAmmo())
                draw.DrawText(vehicle_ammo, "GWZ_NumberBoldBlur", (ScrW() - 195) - hud_offset_h, ScrH() - 130 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 200 ), TEXT_ALIGN_RIGHT)
                draw.DrawText(vehicle_ammo, "GWZ_NumberBold",  (ScrW() - 197) - hud_offset_h, ScrH() - 132 * hud_scale - (hud_offset_v / 2), lightfg, TEXT_ALIGN_RIGHT)
            end
        end
    end)
end