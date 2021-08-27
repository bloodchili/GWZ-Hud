----------------------------------------------------
-- Near Death effect
-- : Makes the screen slightly black&white, plays 
--   near death sound
----------------------------------------------------

-- Variables
vignette_alpha = 0

isPlayed_sndNearDeath = false
isPlayed_sndNearDeathEnd = false

start = 0;

if CLIENT then
    local efVignette = Material( "hud/vignette.png" );
    local efBlood = Material( "hud/blood-overlay.png" );
    local postprocces = false

    sound.Add( {
        name = "neardeath",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 0,
        pitch = 100,
        sound = "player/plr_neardeath.wav"
    } )

    sound.Add( {
        name = "neardeath_end",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 0,
        pitch = 100,
        sound = "player/plr_neardeath_end.wav"
    } )    

    util.PrecacheSound("neardeath");
    util.PrecacheSound("neardeath_end");

    if (IsValid(LocalPlayer())) then
        pPlayer = LocalPlayer();
    end;

    local color_tab = {
        ["$pp_colour_addr"] = 0,
        ["$pp_colour_addg"] = 0,
        ["$pp_colour_addb"] = 0,
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
        ["$pp_colour_mulr"] = 0,
        ["$pp_colour_mulg"] = 0,
        ["$pp_colour_mulb"] = 0
    };

    net.Receive( "StopNearDeathSound", function( len, ply )
        timer.Simple(0.1, function()
            color_tab["$pp_colour_contrast"] = 1;
            color_tab["$pp_colour_colour"] = 1;        
        end)

        timer.Simple(0.1, function()
            alpha = 0
            if (neardeathend ~= nil and neardeath ~= nil) then
                neardeathend:Stop()
                neardeath:Stop()
            end
        end)
    end)

    hook.Add( "HUDPaint", "GWZ_NearDeath", function()
        if !GetConVar("gwz_hud_enable"):GetBool() then return end        

        pPlayer = LocalPlayer()

        if ( !IsValid( pPlayer ) ) then return end

        if not neardeathend and not neardeath then
            neardeath = CreateSound(pPlayer, "neardeath");
        end

        surface.SetDrawColor( 255, 255, 255, vignette_alpha );
        surface.SetMaterial( efVignette );
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );

        surface.SetDrawColor( 255, 255, 255, vignette_alpha );
        surface.SetMaterial( efBlood );
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );        

        if pPlayer:Alive() and pPlayer:Health() < 20 then
            neardeathend = CreateSound(pPlayer, "neardeath_end");
            
            postprocces = true
            vignette_alpha = Lerp(10 * RealFrameTime(), vignette_alpha, 225);
            color_tab["$pp_colour_contrast"] = 1.3;
            color_tab["$pp_colour_colour"] = 0.53;
            neardeathend:Stop();

            -- Play start sound
            if !neardeath:IsPlaying() and !isPlayed_sndNearDeath then
                neardeath:Play();
                isPlayed_sndNearDeath = true;
                isPlayed_sndNearDeathEnd = false;
            end
        end

        if pPlayer:Alive() and pPlayer:Health() > 20 then
            postprocces = false
            vignette_alpha = Lerp(10 * RealFrameTime(), vignette_alpha, 0);
            color_tab["$pp_colour_contrast"] = 1;
            color_tab["$pp_colour_colour"] = 1;
            neardeath:Stop();
            if (neardeathend ~= nil) then
                -- Play end sound
                if !neardeathend:IsPlaying() and !isPlayed_sndNearDeathEnd then
                    neardeathend:Play();

                    isPlayed_sndNearDeathEnd = true;
                    isPlayed_sndNearDeath = false;
                end
            end
        end
    end)

    hook.Add("RenderScreenspaceEffects", "GWZ_NearDeathPostProcess", function()
        if !GetConVar("gwz_hud_enable"):GetBool() then return end
        
        if (postprocces) then   
            DrawColorModify( color_tab );
        end

        if LocalPlayer():IsValid() and LocalPlayer():Alive() and pPlayer:Health() < 20 then
            DrawMotionBlur( 0.17, 0.99, 0 )
        end
    end )
end

if SERVER then
    util.AddNetworkString( "StopNearDeathSound" )
    
    hook.Add("PlayerSpawn", "GWZ_PlayerSpawnAfterNearDeath", function(ply)
        if (ply:IsValid()) then
            net.Start("StopNearDeathSound")
        end
        net.Send(ply)
    end)

    hook.Add("PlayerDeath", "GWZ_PlayerDeathAfterNearDeath", function(ply)
        net.Start("StopNearDeathSound")
        net.Send(ply)
    end)
end