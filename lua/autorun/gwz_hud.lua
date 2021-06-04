
GWZ = {}

-- Inspired (and copied) by DyaMetR's dev
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
GWZ:IncludeFile("gwz_hud/player.lua")

GWZ:IncludeFile("gwz_hud/health.lua")