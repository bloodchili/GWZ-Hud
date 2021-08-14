-- JUST COPIED AND EDITED FROM Half-Life (1&2) Death Screens
-- https://steamcommunity.com/sharedfiles/filedetails/?id=249765297

local NET = "gwz_falldamage";

if SERVER then
  util.AddNetworkString(NET);

  hook.Add("EntityTakeDamage", "GWZ_Damage", function(ent, dmginfo)
    if not ent:IsPlayer() then return end
    if not dmginfo:IsFallDamage() or dmginfo:GetDamage() < ent:Health() then return end
    net.Start(NET);
    net.Send(ent);
  end);
end

if CLIENT then
  -- Configuration
  local enabled = CreateClientConVar("gwz_hud_deathcamera_enable", 1, true, true);
  local mode = CreateClientConVar("gwz_hud_deathcamera_mode", 1, true, true);

  -- Variables
  local respawned = true;
  local killed = false;

  -- Calc view
  hook.Add( "CalcView", "GWZ_CalcView", function(ply, pos, angles, fov)
    local view = {}
  	if enabled:GetInt() == 1 then
      local traceBackward = util.QuickTrace(ply:LocalToWorld(Vector(-50,0,5)), -ply:GetForward(), ply)
      if not traceBackward.Hit then
        view.origin = ply:LocalToWorld(Vector(-50,0,5))
      else
        view.origin = ply:LocalToWorld(Vector(0,0,5))
      end       
  	  view.angles = Angle(angles.p, angles.y, angles.r);
      view.fov = 75;

  		if not LocalPlayer():Alive() then
        if killed then
          killed = true
        end
        return view;
  		end
  	else
  		return
  	end
  end);
end
