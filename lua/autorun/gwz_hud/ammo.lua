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

    isHL2weapon = false

    local lightfg = Color(197, 200, 191)
    local light_darker_fg = Color(165, 170, 170)

    hook.Add( "HUDPaint", "GWZ_AmmoPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
        pPlayer = LocalPlayer()
        if ( !IsValid( pPlayer ) ) then return end

        hud_offset_h = math.Clamp( GetConVar("gwz_hud_offset_h"):GetInt(), 0, 100)
        hud_offset_v = math.Clamp( GetConVar("gwz_hud_offset_v"):GetInt(), 0, 100)
    
        weapon = pPlayer:GetActiveWeapon()

        hl2weapons = 
        {
            "weapon_crowbar",
            "weapon_pistol",
            "weapon_357",
            "weapon_smg1",
            "weapon_ar2",
            "weapon_shotgun",
            "weapon_crossbow",
            "weapon_frag",
            "weapon_rpg",
            "weapon_stunstick",
            "weapon_slam",
            "weapon_bugbait",
            "weapon_physcannon",
            "weapon_physgun"
        }        

        if IsValid(weapon) then
            ammo1 = math.Clamp(weapon:Clip1(), 0, 9999)
            ammo1mag = math.Clamp(pPlayer:GetAmmoCount(weapon:GetPrimaryAmmoType()), 0, 9999)
            if (weapon:GetMaxClip1() > -1) then
                draw.DrawText(ammo1, "GWZ_NumberBoldBlur", (ScrW() - 195) - hud_offset_h, ScrH() - 130 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 200 ), TEXT_ALIGN_RIGHT)
                draw.DrawText(ammo1, "GWZ_NumberBold",  (ScrW() - 197) - hud_offset_h, ScrH() - 132 * hud_scale - (hud_offset_v / 2), lightfg, TEXT_ALIGN_RIGHT)

                draw.DrawText(ammo1mag, "GWZ_NumberBlur",  (ScrW() - 198) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT)
                draw.DrawText(ammo1mag, "GWZ_Number",  (ScrW() - 200) - hud_offset_h, ScrH() - 90 * hud_scale - (hud_offset_v / 2), light_darker_fg, TEXT_ALIGN_RIGHT)
            end  

            if weapon.WepSelectIcon ~= null then
                surface.SetDrawColor( 255, 255, 255, alpha )
                surface.SetTexture( weapon.WepSelectIcon )
                surface.DrawTexturedRect( ScrW() - 420, ScrH() - 132, 128, 64)
            end
        end
    end)
end