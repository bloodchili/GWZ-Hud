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
    panel:AddControl( "Checkbox", { Label = "Classic hitmark sound", Command = "gwz_hud_hitmark_snd_style", });

    panel:Help("Hud Features:")
    panel:AddControl( "Checkbox", { Label = "Enable player's stats", Command = "gwz_hud_enable_healthpanel", });
    panel:AddControl( "Checkbox", { Label = "Enable player's ammo counter", Command = "gwz_hud_enable_ammo", });
    panel:AddControl( "Checkbox", { Label = "Enable hitmarker", Command = "gwz_hud_enable_hitmarker", });
    panel:AddControl( "Checkbox", { Label = "Enable damage indicator", Command = "gwz_hud_enable_attackindicator", });
    panel:AddControl( "Checkbox", { Label = "Enable armor break effect", Command = "gwz_hud_enable_armorbreak", });
    panel:AddControl( "Checkbox", { Label = "Enable \"Near Death\" effect", Command = "gwz_hud_enable_neardeath", });
    panel:AddControl( "Checkbox", { Label = "Enable stats (frags, players on server)", Command = "gwz_hud_enable_counter", });
end);

spawnmenu.AddToolMenuOption( "Options", "GWZ Hud", "GWZHudServer", "Server", "", "", function(panel)
    panel:ClearControls();

    panel:Help("Game settings:")
    -- Realism mode (WIP)
    panel:AddControl( "Checkbox", { Label = "Max Realism Mode", Command = "gwz_hud_server_realism_mode", });
    
end);
end);