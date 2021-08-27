
GWZ = {}

-- Inspired (and copied) by DyaMetR's dev (I've planned do this in every single lua file)
function GWZ:IncludeFile(file)
    if SERVER then
      include(file);
      AddCSLuaFile(file);
    end
    
    if CLIENT then
      include(file);
    end
end

GWZ:IncludeFile("gwz_hud/base.lua")

GWZ:IncludeFile("gwz_hud/settings.lua")

GWZ:IncludeFile("gwz_hud/player.lua")
GWZ:IncludeFile("gwz_hud/hitmarker.lua")
GWZ:IncludeFile("gwz_hud/neardeath.lua")
GWZ:IncludeFile("gwz_hud/deathcamera.lua")

GWZ:IncludeFile("gwz_hud/armorbreak.lua")

GWZ:IncludeFile("gwz_hud/health.lua")
GWZ:IncludeFile("gwz_hud/ammo.lua")
