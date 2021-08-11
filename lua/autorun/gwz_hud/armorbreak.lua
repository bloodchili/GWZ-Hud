if CLIENT then
    efArmorBreak = Material( "hud/armor_broken_fullscreen.png", "smooth")
    pPlayer = LocalPlayer()

    isPlayed = false;
    alpha = 255
    start = 0;

    hook.Add( "HUDPaint", "GWZ_ArmorBreakPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end        
        if ( !IsValid( pPlayer ) ) then return end

        if pPlayer:Armor() == 0 then
            if not isPlayed then
                alpha = 255
            end
            
            isPlayed = true;

            alpha = Lerp(( SysTime() - start ) / 0.05, alpha, 0)
			surface.SetDrawColor( 255, 255, 255, alpha )
            surface.SetMaterial( efArmorBreak )
            surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
        end

        if pPlayer:Armor() > 0 then
            isPlayed = false
        end
    end)
end