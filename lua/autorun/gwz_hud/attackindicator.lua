-- Based on/off "HUD Attack Indicator"

if SERVER then
    util.AddNetworkString( "GWZ_CreateIndicator" )

    local function AllowIndicator(victim)
        if victim then
            if !GetConVar("gwz_hud_server_realism_mode"):GetBool() and IsValid(victim) and victim:IsPlayer() then
                return true
            else
                return false
            end
        else
            if !GetConVar("gwz_hud_server_realism_mode"):GetBool() then
                return true
            else
                return false
            end
        end
    end

    -- Bullet missed you
    hook.Add("EntityFireBullets","GWZ_ShotMissed", function(attacker, inflictor)
        if AllowIndicator() then
            for i,victim in pairs(player.GetAll()) do
                if (AllowIndicator(victim) and !attacker == victim and IsValid(attacker) and IsValid(victim)) then
                    local vOrigin = victim:GetPos()
                    local vEyes = vOrigin + ((victim:EyePos() - vOrigin) / 2)

                    local distToSqr = vEyes:DistToSqr(inflictor.Src)
                    local vAim = vEyes - inflictor.Src

                    if (distToSqr < (inflictor.Distance + 256)^2) or ( distToSqr > 90000 and ( missToSqr <= 8100/(distToSqr/5625) )) then
                        local angAim = vAim:Angle()
                        local angFire = inflictor.Dir:Angle()
                        local angMiss = angAim - angFire
                        angMiss:Normalize()
                    
                        local missToSqr = (angMiss.p^2) + (angMiss.y^2)
                        if ( missToSqr <= 2025 and distToSqr <= 90000 ) then
                            local trdata = {}
                            trdata.start 	= attacker:EyePos()
                            trdata.endpos 	= victim:EyePos()
                            local trace = util.TraceLine( trdata )

                            trdata.filter 	= {attacker,victim}
                            trdata.mask 	= MASK_SHOT

                            if trace.Hit then
                                if (IsValid(victim) and victim:IsPlayer()) then 
                                    net.Start("GWZ_CreateIndicator")
                                    net.WriteEntity( attacker )
                                    net.Send( victim )
                                end
                            end
                        end
                    end
                end
            end
        end
    end)

    -- Bullet got you
    hook.Add("EntityTakeDamage","GWZ_Shot", function(victim, dmginfo)
        local attacker = dmginfo:GetAttacker()
        if AllowIndicator(victim) and IsValid(attacker) and IsValid(victim) and victim:IsPlayer() then 
            net.Start("GWZ_CreateIndicator")
            net.WriteEntity( attacker )
            net.Send( victim )
        end
    end)
end

if CLIENT then
    local enable = CreateClientConVar("gwz_hud_enable_attackindicator", "1", true, false, "Enable draw of attack indiactor")
    local indicator_Damage = Material( "hud/indicator_damage.png", "smooth" )
    local indicator_Miss = Material( "hud/indicator_miss.png", "smooth" )

    curAttackers = {}

    net.Receive( "GWZ_CreateIndicator", function( len )
        local attacker = net.ReadEntity()
        ShotIndicatorStart(attacker)
    end )

    function ShotIndicatorStart(attacker)
        if !GetConVar("gwz_hud_server_realism_mode"):GetBool() and IsValid(attacker) then
            curAttackers[attacker] = { UnPredictedCurTime() + 3, attacker:GetPos() }
        end
    end

    hook.Add("HUDPaint","GWZ_ShowIndicator", function()
        if !GetConVar("gwz_hud_enable"):GetBool() or !GetConVar("gwz_hud_enable_attackindicator"):GetBool() or !GetConVar("cl_drawhud"):GetBool() then return end
        surface.SetMaterial( indicator_Damage )

        for ent,data in pairs( curAttackers ) do
            if data then
                local fade = ( ( data[1] - UnPredictedCurTime() ) * 60 )
                if fade > 180 then fade = 180 end
                local rot = ((EyePos() - data[2]):Angle().y - EyeAngles().y) + 180
                
                surface.SetDrawColor( 255, 255, 255, fade )
                surface.DrawTexturedRectRotated( ScrW()/2, ScrH()/2, 512, 768, rot )
            end
        end
    end)

    local hide = {
        ["CHudDamageIndicator"] = true,
    }

    hook.Add( "HUDShouldDraw", "GWZ_HideDamage", function( name )
        if ( hide[name] and GetConVar("gwz_hud_enable"):GetBool() and GetConVar("cl_drawhud"):GetBool()) then return false end
    end )
end

