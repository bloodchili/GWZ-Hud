isPlayed = true

if CLIENT then
    local enable = CreateClientConVar("gwz_hud_enable_armorbreak", 1, true, true);
    efArmorBreak = Material( "hud/armor_broken_fullscreen.png", "smooth")
    efArmorBreakCircle = Material( "hud/armor_broken_circle.png", "smooth")
    pPlayer = LocalPlayer()

    alpha = 255
    alphaCircle = 255
    circled_original_w = ScrW() - 799
    circled_original_h = ScrH()
    circled_w = circled_original_w
    circled_h = circled_original_h
    start = 0;

    hook.Add( "HUDPaint", "GWZ_ArmorBreakPaint", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !enable:GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
        if ( !IsValid( pPlayer ) ) then return end

        if pPlayer:Armor() == 0 && !isPlayed then
            if (!GetConVar("gwz_hud_reduce_effect"):GetBool()) then
                alpha = 255;
            else
                alpha = 128;
            end
            alphaCircle = 255

            circled_w = circled_original_w
            circled_h = circled_original_h

            -- Broken "glass" effect
            alpha = Lerp(( SysTime() - start ) / 0.0005, alpha, 0)
            surface.SetDrawColor( 255, 255, 255, alpha )
            surface.SetMaterial( efArmorBreak )
            surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )

            if (!GetConVar("gwz_hud_reduce_effect"):GetBool()) then
                pPlayer:ScreenFade( SCREENFADE.IN, Color( 0, 80, 240, 32 ), 0.3, 0 )
            else
                pPlayer:ScreenFade( SCREENFADE.IN, Color( 0, 80, 240, 8 ), 0.2, 0 )
            end

            isPlayed = true;
        end

        if pPlayer:Armor() > 0 then
            isPlayed = false
        end
    end)
end

if SERVER then
hook.Add( "PlayerDeath", "GWZ_ArmorBreakDisallowOnDeath", function()
    isPlayed = true
end)
end