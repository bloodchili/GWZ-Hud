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
        ["$pp_colour_brightness"] = 0,
        ["$pp_colour_contrast"] = 1,
        ["$pp_colour_colour"] = 1,
    };

    hook.Add( "HUDPaint", "GWZ_NearDeath", function()
        pPlayer = LocalPlayer()

        if not neardeathend and not neardeath then
            neardeathend = CreateSound(pPlayer, "neardeath_end");
            neardeath = CreateSound(pPlayer, "neardeath");
            print("CREATED FUCKING SOUNDS");
        end

        surface.SetDrawColor( 255, 255, 255, vignette_alpha );
        surface.SetMaterial( efVignette );
        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() );

        if pPlayer:Alive() and pPlayer:Health() < 20 then
            vignette_alpha = Lerp((SysTime() - start) / 0.1, vignette_alpha, 255);
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
            vignette_alpha = Lerp((SysTime() - start) / 0.1, vignette_alpha, 0);
            color_tab["$pp_colour_contrast"] = 1;
            color_tab["$pp_colour_colour"] = 1;
            neardeath:Stop();
            -- Play end sound
            if !neardeathend:IsPlaying() and !isPlayed_sndNearDeathEnd then
                neardeathend:Play();

                isPlayed_sndNearDeathEnd = true;
                isPlayed_sndNearDeath = false;
            end
        end

    end)

    hook.Add("RenderScreenspaceEffects", "GWZ_NearDeathPostProcess", function()
            DrawColorModify( color_tab );
    end )
end