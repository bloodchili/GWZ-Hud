hook.Add( "PopulateToolMenu", "GWZ_Settings", function()
spawnmenu.AddToolMenuOption( "Options", "GWZ Hud", "GWZHudClient", "Client", "", "", function(panel)
    panel:ClearControls();
    panel:AddControl( "Checkbox", { Label = "Enable HUD", Command = "gwz_hud_enable", });

    panel:Help("Appearance customization:")
    -- Scale multiplier
    panel:NumSlider( "Scale Multiplier", "gwz_hud_scale_multiplier", 1, 5 )
    -- Offset from corner horizontally
    panel:NumSlider( "Offset Horizontally", "gwz_hud_offset_h", 0, 100 )
    -- Offset from corner vertically
    panel:NumSlider( "Offset Vertically", "gwz_hud_offset_v", 0, 100 )

    panel:Help("Gameplay Features:")
    panel:AddControl( "Checkbox", { Label = "Enable deathscreen (WIP)", Command = "gwz_hud_deathcamera_enable", });
    panel:AddControl( "Checkbox", { Label = "Reduced effects", Command = "gwz_hud_reduce_effect", });
end);

spawnmenu.AddToolMenuOption( "Options", "GWZ Hud", "GWZHudServer", "Server", "", "", function(panel)
    panel:ClearControls();

    panel:Help("Game settings:")
    -- Realism mode (WIP)
    panel:AddControl( "Checkbox", { Label = "Max Realism Mode", Command = "gwz_hud_server_realism_mode", });
end);
end);