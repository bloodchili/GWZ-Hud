if CLIENT then
    efArmorBreak = Material( "hud/armor_broken_fullscreen.png", "smooth")
    pPlayer = LocalPlayer()


    -- hook.Add( "HUDPaint", "GWZ_ArmorBreakPaint", function()
        -- if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end        
        -- if ( !IsValid( pPlayer ) ) then return end

        -- if pPlayer:Armor() == 0 then
            -- surface.SetDrawColor( 255, 255, 255, 255 )
            -- surface.SetMaterial( efArmorBreak )
            -- surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
        -- end
    -- end)
end