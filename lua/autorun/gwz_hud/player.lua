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
    name = "GWZ.BulletImpactFleshTorsoArmor",
    channel = CHAN_AUTO,
    volume = 0.75,
    level = 75,
    pitch = {99, 101},
    sound = {
    "player/blt_imp_flesh_npc_lyr_torso_03_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_04_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_05_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_06_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_09_armor.wav",
    "player/blt_imp_flesh_npc_lyr_torso_10_armor.wav"}                
} )

hook.Add("ScalePlayerDamage", "FleshHit", function (ply, hitgroup, dmginfo)
    if ( hitgroup == HITGROUP_HEAD ) then
        dmginfo:ScaleDamage( 2 )
    else
        dmginfo:ScaleDamage( 0.50 )
    end
end )