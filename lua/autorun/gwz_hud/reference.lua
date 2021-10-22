if CLIENT then
    local ref1 = Material("hud/reference_1.png")

    hook.Add( "HUDPaint", "OOf", function()
        surface.SetDrawColor(255,255,255,128)
        surface.SetMaterial(ref1)
        //surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
    end )
end