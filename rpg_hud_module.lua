local hud_module = {}

function hud_module.UpdateAll(player)
    local playerID = player.GetPlayer()
	local class = player.GetClassName()
    local current_level = player.GetXp()
    local next_level = player.GetXpToNext()

	if player.GetPlayer():IsAlive() then
        hud_module.HideAll(playerID)

		local max_width = 124
		local bar_width = current_level	* max_width / next_level
		-- Hide if at zero XP
		if current_level ~= 0 then
			AddHudIcon(playerID, "hud_statusbar_purple.vtf", "Progress_bar", 166, 462, bar_width, 16, 0 )
		end
		--Level bar
		AddHudIcon(playerID, "hud_statusbar_256.vtf", "Progress_BG", 164, 462, 128, 16, 0 )
		AddHudText(playerID, "Progress_text", tostring(math.floor(current_level)).."/"..next_level, 166, 462, 0 )
		AddHudText(playerID, "Progress_level","Level: "..player.GetLevel().." | Class: ".. class, 166, 450, 0 )

		--Skill information
		AddHudText(playerID, "Progress_regen","+"..tostring(5 * player.GetRegenLevel()).."% Regeneration", 293, 469, 0 )
		AddHudText(playerID, "Progress_resist","+"..tostring(5 * player.GetResistLevel()).."% Resistance", 293, 461, 0 )
		AddHudText(playerID, "Progress_speed","+"..tostring(5 * player.GetSpeedLevel()).."% Speed", 370, 461, 0 )

		if class == 1 or class == 5 or class == 8 then
			AddHudText(playerID, "Progress_o_or_d","+"..tostring(15 * player.GetThrowLevel()).."% Throw Power", 370, 469, 0 )
		else
			AddHudText(playerID, "Progress_o_or_d","+"..tostring(5 * player.GetDamageLevel()).."% Damage", 370, 469, 0 )
		end

		--[[ WIP old rpg methods
        --Skill ult information
		if player_table[SteamID][PlayerClass].skill_ult_1 >= 1 then
			AddHudText( player, "Progress_ult_1","["..SKILL_NAME[PlayerClass].ULT_1.."]", 455, 469, 0 )
		end
		if player_table[SteamID][PlayerClass].skill_ult_2 >= 1 then
			AddHudText( player, "Progress_ult_2","["..SKILL_NAME[PlayerClass].ULT_2.."]", 550, 469, 0 )
		end
		if player_table[SteamID][PlayerClass].skill_ult_3 >= 1 then
			AddHudText( player, "Progress_ult_3","["..SKILL_NAME[PlayerClass].ULT_3.."]", 550, 461, 0 )
		end
		if player_table[SteamID][PlayerClass].skill_ult_4 >= 1 then
			AddHudText( player, "Progress_ult_4","["..SKILL_NAME[PlayerClass].ULT_4.."]", 455, 461, 0 )
		end
        --]]
	end --  is alive
end

--Update only xp bar and text
function hud_module.UpdateXpBar(player)
        local playerID = player.GetPlayer()
        local current_level = player.GetXp()
        local next_level = player.GetXpToNext()
        local level_xp = tostring(math.floor(current_level))

        local max_width = 124
		local bar_width = current_level	* max_width / next_level

        hud_module.HideXpBar(playerID)
        AddHudIcon(playerID, "hud_statusbar_purple.vtf", "Progress_bar", 166, 462, bar_width, 16, 0 )
        AddHudText(playerID, "Progress_text", level_xp .."/"..next_level, 166, 462, 0 )
end

--remove only xp bar and text
function hud_module.HideXpBar(playerID)
	RemoveHudItem(playerID, "Progress_text")
    RemoveHudItem(playerID, "Progress_bar")
end

function hud_module.HideAll(playerID)
	RemoveHudItem(playerID, "Progress_BG")
	RemoveHudItem(playerID, "Progress_bar")
	RemoveHudItem(playerID, "Progress_text")
	RemoveHudItem(playerID, "Progress_level")
	RemoveHudItem(playerID, "Progress_regen")
	RemoveHudItem(playerID, "Progress_resist")
	RemoveHudItem(playerID, "Progress_speed")
	RemoveHudItem(playerID, "Progress_o_or_d")
	RemoveHudItem(playerID, "Progress_ult_1")
	RemoveHudItem(playerID, "Progress_ult_2")
	RemoveHudItem(playerID, "Progress_ult_3")
	RemoveHudItem(playerID, "Progress_ult_4")
end


return hud_module