aliveplayers = 0

if CLIENT then
    local mGroups = Material("hud/counter_groups.png", "smooth")
    local mPlayers = Material("hud/counter_players.png", "smooth")
    local mkills = Material("hud/counter_kill.png", "smooth")

    local enable = CreateClientConVar("gwz_hud_enable_counter", 1, true, true);
    local numberofalive = 0

    net.Receive("AlivePlayers", function()
        numberofalive = net.ReadInt(32)
    end)

    hook.Add( "HUDPaint", "GWZ_Counter", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("cl_drawhud"):GetBool() or !enable:GetBool() then return end
        if GetConVar("gwz_hud_server_realism_mode"):GetBool() then return end
        if ( !IsValid( LocalPlayer() ) ) then return end
        if (game.SinglePlayer()) then return end

        surface.SetFont("GWZ_VerySmall")

        --- Number of kills
        -- Icon        
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(mkills)
        surface.DrawTexturedRect(ScrW() - 155, 50, 17, 22)

        surface.SetTextColor( 0, 0, 0 )
        surface.SetTextPos(ScrW() - 130, 46)
        surface.DrawText(LocalPlayer():Frags())

        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos(ScrW() - 132, 44)
        surface.DrawText(LocalPlayer():Frags())

        -- Icon
        surface.SetDrawColor(255,255,255,255)
        surface.SetMaterial(mPlayers)
        surface.DrawTexturedRect(ScrW() - 220, 50, 16, 22)

        surface.SetTextColor( 0, 0, 0 )
        surface.SetTextPos(ScrW() - 193, 46)
        surface.DrawText(numberofalive)

        surface.SetTextColor( 255, 255, 255 )
        surface.SetTextPos(ScrW() - 195, 44)
        surface.DrawText(numberofalive)
    end )
end

if SERVER then
    util.AddNetworkString("AlivePlayers")

    hook.Add("PlayerSpawn", "GWZ_AddAlivePlayers", function(ply)
        aliveplayers = aliveplayers + 1
        PrintMessage( HUD_PRINTTALK, aliveplayers )

        net.Start("AlivePlayers")
        net.WriteInt(aliveplayers, 32)
        for _,player in pairs (player.GetAll()) do
            net.Send(player)
        end
    end)

    hook.Add("PlayerDeath", "GWZ_RemoveAlivePlayers", function(ply)
        aliveplayers = aliveplayers - 1
        PrintMessage( HUD_PRINTTALK, aliveplayers )

        net.Start("AlivePlayers")
        net.WriteInt(aliveplayers, 32)
        for _,player in pairs (player.GetAll()) do
            net.Send(player)
        end
    end)
end