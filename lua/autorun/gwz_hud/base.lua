-- ====================================================================
--                GWZ HUD by Den Urakolouy (URAKOLOUY5)
--       Inspired by many huds of DyaMetR and Modern Warfare &
--                         Warzone itself.
-- ====================================================================

-- Base

-- Enable draw of GWZ Hud
CreateClientConVar("gwz_hud_enable", "1", true, false, "Enable draw of GWZ Hud")

-- Enable fall damage like Modern Warfare
CreateConVar("gwz_gameplay_falldamage", 0, FCVAR_REPLICATED && FCVAR_ARCHIVE, "Enable fall damage like Modern Warfare", 0, 1)

function GWZ.isEnabled()
    return GetConVar("gwz_hud_enable") >= 1
end

