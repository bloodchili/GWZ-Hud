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
end

local lightfg = Color(197, 200, 191)
local light_darker_fg = Color(165, 170, 170)

hook.Add( "HUDPaint", "GWZ_AmmoPaint", function()
    pPlayer = LocalPlayer()    
    weapon = pPlayer:GetActiveWeapon()
    if IsValid(weapon) then
        ammo1 = math.Clamp(weapon:Clip1(), 0, 9999)
        ammo1mag = math.Clamp(pPlayer:GetAmmoCount(weapon:GetPrimaryAmmoType()), 0, 9999)
        if (weapon:GetMaxClip1() > -1) then
            draw.DrawText(ammo1, "GWZ_NumberBoldBlur",  ScrW() - 195, ScrH() - 130, Color( 0, 0, 0, 200 ), TEXT_ALIGN_RIGHT)
            draw.DrawText(ammo1, "GWZ_NumberBold",  ScrW() - 197, ScrH() - 132, lightfg, TEXT_ALIGN_RIGHT)

            draw.DrawText(ammo1mag, "GWZ_NumberBlur",  ScrW() - 198, ScrH() - 90, Color( 0, 0, 0, 255 ), TEXT_ALIGN_RIGHT)
            draw.DrawText(ammo1mag, "GWZ_Number",  ScrW() - 200, ScrH() - 90, light_darker_fg, TEXT_ALIGN_RIGHT)

            surface.SetDrawColor( 255, 255, 255, alpha )
            surface.SetTexture( weapon.WepSelectIcon )

            surface.DrawTexturedRect( ScrW() - 420, ScrH() - 132, 128, 64)
        end 
    end
end)