if SERVER then
	util.AddNetworkString( "DrawHitMarker" )
	util.AddNetworkString( "DrawHitMarker_Armor" )
	util.AddNetworkString( "DrawDeathHitMarker" )
	util.AddNetworkString( "ArmorIsZero" )

	util.AddNetworkString( "HitgroupHead" )
	util.AddNetworkString( "HitgroupOther" )
	
	hook.Add("EntityTakeDamage","HitmarkerDetector", function( ply, dmginfo )
		local att = dmginfo:GetAttacker()
		local dmg = dmginfo:GetDamage()
		
		if (IsValid(att) and att:IsPlayer() and att ~= ply) then
			if (ply:IsPlayer() or ply:IsNPC() or ply:IsNextBot()) then
                if (ply:IsPlayer() and ply:Armor() > 0) then
				    net.Start("DrawHitMarker_Armor")
					net.Send(att)
                else
					net.Start("DrawHitMarker")
					net.Send(att)
                end
			end
		end
	end)

	hook.Add("PostEntityTakeDamage", "HitmarkArmorBrokeDetector", function( ply, dmginfo )
		local att = dmginfo:GetAttacker()
		local dmg = dmginfo:GetDamage()
		
		if (IsValid(att) and att:IsPlayer() and att ~= ply) then
			if ply:IsPlayer() then				
				net.Start("ArmorIsZero")
				net.WriteInt(ply:Armor(), 32)
				net.Send(att)
			end
		end						
	end)

	gameevent.Listen( "entity_killed" )
	hook.Add( "entity_killed", "HitmarkerKillDetector", function( data ) 
		local att = Entity(data.entindex_attacker)
		local dmgbits = data.damagebits
		local ply = Entity(data.entindex_killed)
	
		// Called when a Player or Entity is killed
		if (IsValid(att) and att:IsPlayer() and att ~= ply) then
			net.Start("DrawDeathHitMarker")
			net.Send(att) -- Send the message to the attacker
			if (ply:IsPlayer() or ply:IsNPC()) then
				if (ply:IsPlayer() and ply:LastHitGroup() == HITGROUP_HEAD) then
					net.Start("HitgroupHead")
					net.Send(att) -- Send the message to the attacker
				else
					net.Start("HitgroupOther")
					net.Send(att) -- Send the message to the attacker
				end
			end
		end
	end )
end

if CLIENT then
	
	-- Declare our convars and variables
	local enable = CreateClientConVar("gwz_hud_enable", "1", true, true)
	local style = CreateClientConVar("gwz_hud_hitmark_snd_style", "0", true, true)

	local bg_hitmark = Material("hud/hitmark.png")

	local bg_armorfull = Material("hud/armor-full.png")	

    local DrawHitM = false
    local DrawRedHitM = false
	local CanPlayS = true
	local alpha = 0
	local alpha_armor = 0

	local w_origin = 32
	local h_origin = 32

	local w_armor_origin = 22
	local h_armor_origin = 32

	local size_random = 0
	local add_random = 0

	local start = 0
	local allowPlayBreak = false
	local isplayed = true

	sound.Add( {
        name = "headindictation",
        channel = CHAN_AUTO,
        volume = 1.0,
        level = 0,
        pitch = {90, 105},
        sound = "alert/mp_headshot_indication.wav"
    } )
	
	net.Receive( "DrawDeathHitMarker", function( len, ply )
		DrawRedHitM = true
		timer.Simple(0.65, function()
			DrawRedHitM = false
		end)
	end)

	net.Receive( "ArmorIsZero", function( len, ply )
		armor = net.ReadInt(32)

		if (armor <= 0) then
			allowPlayBreak = true
			timer.Simple(0.2, function()
				allowPlayBreak = false
			end)
		end

		if (armor > 0) then
			isplayed = false
			bg_armorfull = Material("hud/armor-full.png")
		end

		if (allowPlayBreak and !isplayed) then
			surface.PlaySound("alert/alert_armorbroken.wav")
			surface.PlaySound("alert/alert_armorbroken.wav")
			bg_armorfull = Material("hud/armor-broken.png")
			isplayed = true;
		end
	end)

	net.Receive( "HitgroupHead", function( len, ply )
		PlayDeathHitSound(true)
	end)

	net.Receive( "HitgroupOther", function( len, ply )
		PlayDeathHitSound(false)
	end)

	function PlayDeathHitSound(ishead)
		if !GetConVar("gwz_hud_enable"):GetBool() then return end
		
		if (ishead) then
			local random = math.random(1, 3)
			surface.PlaySound("alert/mp_headshot_indication_" .. random .. ".wav")
		else
			surface.PlaySound("alert/killsound_test_141.wav")
			surface.PlaySound("alert/killsound_test_141.wav")
		end
	end

	net.Receive( "DrawHitMarker", function( len, ply )
		DrawRedHitM  = false
		DrawHitM = true
		CanPlayS = true
		alpha = 255

		size_random = math.random( 16, 48 )
		add_random = 0
		w_origin = size_random
		h_origin = size_random	

		if !GetConVar("gwz_hud_enable"):GetBool() then return end
		
		if (DrawRedHitM) then return end
        if style:GetInt() == 0 then
            surface.PlaySound("impacts/mp_hit_indication_3d.wav")
        else
            surface.PlaySound("impacts/mp_hit_indication_3c.wav")
        end
	end)

    net.Receive( "DrawHitMarker_Armor", function( len, ply )
		DrawHitM = true
		CanPlayS = true
		alpha = 255
		alpha_armor = 255

		allowPlayBreak = false

		size_random = math.random( 16, 48 )
		w_origin = size_random
		h_origin = size_random

		w_armor_origin = 22 + size_random
		h_armor_origin = 32 + size_random

        if !GetConVar("gwz_hud_enable"):GetBool() then return end

        if style:GetInt() == 0 then
            surface.PlaySound("impacts/mp_hit_indictation_3d_armor.wav")
            surface.PlaySound("impacts/mp_hit_indictation_3d_armor.wav")
        else
            surface.PlaySound("impacts/mp_hit_indictation_3c_armor.wav")
            surface.PlaySound("impacts/mp_hit_indictation_3c_armor.wav")
        end
	end)
	
	hook.Add("HUDPaint", "HitmarkerDraw", function() 
		if !GetConVar("gwz_hud_enable"):GetBool() then return end
		
		start = SysTime()
		if enable:GetBool() == false then return end
		if alpha == 0 and alpha_armor == 0 then 
			DrawHitM = false 
			DrawRedHitM = false 
		end

		local realism = GetConVar("gwz_hud_server_realism_mode"):GetInt() 
		local materialname = bg_armorfull

		if (DrawHitM == true and realism ~= 1) then
			-- Default icon
			local w = (w_origin + hud_offset_h) * hud_scale
			local h = h_origin * hud_scale - (hud_offset_v / 2)

			local x = (ScrW() / 2 - (w / 2)) + add_random
			local y = (ScrH() / 2 - (h / 2)) + add_random

			-- Armor icon
			local w_armor = (w_armor_origin + hud_offset_h) * hud_scale
			local h_armor = h_armor_origin * hud_scale - (hud_offset_v / 2)		
			
			local x_armor = (ScrW() / 2 - (w_armor / 2)) + 75
			local y_armor = (ScrH() / 2 - (h_armor / 2)) + 56

			if (1 / RealFrameTime() > 15) then
				alpha = Lerp(10 * RealFrameTime(), alpha, 0)
				alpha_armor = Lerp(10 * RealFrameTime(), alpha_armor, 0)			

				w_origin = Lerp(6 * RealFrameTime(), w_origin, 54)
				h_origin = Lerp(6 * RealFrameTime(), h_origin, 54)

				w_armor_origin = Lerp(10 * RealFrameTime(), w_armor_origin, 22)
				h_armor_origin = Lerp(10 * RealFrameTime(), h_armor_origin, 32)
			else
				alpha = Lerp(5 * RealFrameTime(), alpha, 0)
				alpha_armor = Lerp(5 * RealFrameTime(), alpha_armor, 0)			

				w_origin = Lerp(6 * RealFrameTime(), w_origin, 54)
				h_origin = Lerp(6 * RealFrameTime(), h_origin, 54)

				w_armor_origin = Lerp(5 * RealFrameTime(), w_armor_origin, 22)
				h_armor_origin = Lerp(5 * RealFrameTime(), h_armor_origin, 32)
			end

			if DrawRedHitM == true then
				surface.SetDrawColor( 255, 0, 0, alpha )
			else
				surface.SetDrawColor( 255, 255, 255, alpha )
			end
			surface.SetMaterial( bg_hitmark )
			surface.DrawTexturedRect( x, y, w, h )

			materialname = string.Replace(tostring(materialname), "Material [", "")
			materialname = string.Replace(materialname, "]", "")

			if(materialname == "hud/armor-broken") then
				surface.SetDrawColor( 0, 155, 255, alpha_armor )
			else
				surface.SetDrawColor( 255, 255, 255, alpha_armor )
			end

			surface.SetMaterial( bg_armorfull )

			surface.DrawTexturedRect( x_armor, y_armor, 23, 27 )
		end
	end)
end

