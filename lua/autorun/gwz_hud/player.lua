sound.Add( {
    name = "GWZ.BulletImpactFleshTorso",
    channel = CHAN_AUTO,
    volume = 0.75,
    level = 75,
    pitch = {99, 101},
    sound = {
    "player/blt_imp_flesh_npc_lyr_torso_03.wav",
    "player/blt_imp_flesh_npc_lyr_torso_04.wav",
    "player/blt_imp_flesh_npc_lyr_torso_05.wav",
    "player/blt_imp_flesh_npc_lyr_torso_06.wav",
    "player/blt_imp_flesh_npc_lyr_torso_07.wav",
    "player/blt_imp_flesh_npc_lyr_torso_08.wav",
    "player/blt_imp_flesh_npc_lyr_torso_09.wav",
    "player/blt_imp_flesh_npc_lyr_torso_10.wav"}
} )

sound.Add( {
    name = "GWZ.BulletImpactFleshHead",
    channel = CHAN_AUTO,
    volume = 1,
    level = 75,
    pitch = 100,
    sound = {
    "player/blt_imp_flesh_npc_lyr_torso_03.wav",
    "player/blt_imp_flesh_npc_lyr_torso_04.wav",
    "player/blt_imp_flesh_npc_lyr_torso_05.wav",
    "player/blt_imp_flesh_npc_lyr_torso_06.wav",
    "player/blt_imp_flesh_npc_lyr_torso_07.wav",
    "player/blt_imp_flesh_npc_lyr_torso_08.wav",
    "player/blt_imp_flesh_npc_lyr_torso_09.wav",
    "player/blt_imp_flesh_npc_lyr_torso_10.wav"}
} )

sound.Add( {
    name = "GWZ.BulletImpactFleshHard",
    channel = CHAN_AUTO,
    volume = 1,
    level = 75,
    pitch = 60,
    sound = {
    "player/blt_imp_flesh_plr_02.wav",
    "player/blt_imp_flesh_plr_03.wav",
    "player/blt_imp_flesh_plr_04.wav",
    "player/blt_imp_flesh_plr_05.wav",
    "player/blt_imp_flesh_plr_06.wav",
    "player/blt_imp_flesh_plr_09.wav",
    "player/blt_imp_flesh_plr_10.wav",
    "player/blt_imp_flesh_plr_11.wav",
    "player/blt_imp_flesh_plr_12.wav",
    "player/blt_imp_flesh_plr_13.wav",
    "player/blt_imp_flesh_plr_14.wav"}
} )

sound.Add( {
    name = "GWZ.BulletImpactFleshTorsoArmor",
    channel = CHAN_AUTO,
    volume = 1,
    level = 75,
    pitch = 100,
    sound = {
    "player/blt_imp_flesh_npc_lyr_torso_03_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_04_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_05_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_06_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_09_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_10_armor.wav"}
} )

local NET = "gwz_death_net";

local isPlayedDeathSound = false;

if SERVER then

hook.Add("ScalePlayerDamage", "FleshHit", function (ply, hitgroup, dmginfo)
    if !GetConVar("gwz_hud_enable"):GetBool() then return end
    ply:StopSound("Flesh.BulletImpact")
    if ( hitgroup == HITGROUP_HEAD && dmginfo:GetAmmoType() != 7 ) then
        dmginfo:ScaleDamage( 2 )
        ply:EmitSound("GWZ.BulletImpactFleshHead")
        ply:ViewPunchReset( 0 )
        ply:ViewPunch( Angle( math.Rand( -3, 3 ), math.Rand( -5, 5 ), math.Rand( -1, 2  ) ) )
    else
        dmginfo:ScaleDamage( 0.50 )
        ply:ViewPunchReset( 0 )
        ply:ViewPunch( Angle( math.Rand( -0.5, 0.76 ), math.Rand( -2, 1), math.Rand( -0.11, 0.34 ) ) )
        if (dmginfo:GetAmmoType() == 7) then
            ply:EmitSound("GWZ.BulletImpactFleshHard")
        else
            ply:EmitSound("GWZ.BulletImpactFleshTorso")
        end
    end
end )

hook.Add( "PlayerHurt", "hurt_effect_fade", function( ply )
    if !GetConVar("gwz_hud_enable"):GetBool() then return end

    if (!GetConVar("gwz_hud_reduce_effect"):GetBool()) then
        ply:ScreenFade( SCREENFADE.IN, Color( 100, 0, 0, 128 ), 0.1, 0 );
    else
        ply:ScreenFade( SCREENFADE.IN, Color( 100, 0, 0, 32 ), 0.1, 0 );
    end
end )

util.AddNetworkString(NET)

hook.Add( "PlayerDeath", "PlayerDeathSound", function( victim, inflictor, attacker )
    -- Send data about attacker
    net.Start(NET);
    net.WriteBool(attacker == victim);
    net.WriteBool(attacker:GetClass() == "worldspawn");
    net.Send(victim);
end )

end

if CLIENT then
    local wasSuicide = false
    local wasWorldspawn = false

    CreateClientConVar("gwz_hud_reduce_effect", 0, true, true);

    net.Receive(NET, function(len)
        wasSuicide = net.ReadBool()
        wasWorldspawn = net.ReadBool()
    end);

    hook.Add("HUDPaint", "GWZ_DeathScreen", function()
        if !GetConVar("gwz_hud_enable"):GetBool() then return end
        if (!wasSuicide && !wasWorldspawn && !LocalPlayer():Alive() && !isPlayedDeathSound) then
        surface.PlaySound("player/plr_death_by_kill.wav")
        isPlayedDeathSound = true
    end

    if (LocalPlayer():Alive()) then
        isPlayedDeathSound = false;
    end
end)

end