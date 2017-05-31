local xp_module = {}
local LevelUpDelay

function xp_module.LevelUp(playerID)
    local player = playerID.GetPlayer()
    local level = playerID.GetLevel()

	ObjectiveNotice(player, "Level "..level.."!" )
	BroadCastMessageToPlayer(player, "LEVEL "..level.."!", 6, Color.kWhite)
	ChatToPlayer(player,"^5You are now level ^4"..level)

	--AddSchedule("level_up", 2, LevelUpDelay, playerID)
	LevelUpDelay(playerID)
end

function LevelUpDelay(playerID)
    local player = playerID.GetPlayer()
    local level = playerID.GetLevel()
		--Because everyone loves points, right?
	player:AddFortPoints(100 * level, "Leveling up!")

	DestroyMenu( "LEVEL_UP" )
	--DestroyMenu( "LEVEL_UP_ULT" )

--[[	if playerID.AllowUlt() then
		CreateMenu( "LEVEL_UP_ULT", "Select an Ultimate", -1 )

		if player_table[SteamID][PlayerClass].skill_ult_1 < 1 and SKILL_NAME[PlayerClass].ULT_1 ~= "Null" then
			AddMenuOption( "LEVEL_UP_ULT", 6 , SKILL_NAME[PlayerClass].ULT_1.." ("..SKILL_NAME[PlayerClass].INFO_1..")")
		end
		if player_table[SteamID][PlayerClass].skill_ult_2 < 1 and SKILL_NAME[PlayerClass].ULT_2 ~= "Null" then
			AddMenuOption( "LEVEL_UP_ULT", 7 , SKILL_NAME[PlayerClass].ULT_2.." ("..SKILL_NAME[PlayerClass].INFO_2..")")
		end
		if player_table[SteamID][PlayerClass].skill_ult_3 < 1 and SKILL_NAME[PlayerClass].ULT_3 ~= "Null" then
			AddMenuOption( "LEVEL_UP_ULT", 8 , SKILL_NAME[PlayerClass].ULT_3.." ("..SKILL_NAME[PlayerClass].INFO_3..")")
		end
		if player_table[SteamID][PlayerClass].skill_ult_4 < 1 and SKILL_NAME[PlayerClass].ULT_4 ~= "Null" then
			AddMenuOption( "LEVEL_UP_ULT", 9 , SKILL_NAME[PlayerClass].ULT_4.." ("..SKILL_NAME[PlayerClass].INFO_4..")")
		end

		ShowMenuToPlayer(player, "LEVEL_UP_ULT")

		BroadCastSoundToPlayer( player, "Misc.Unagi" )
	end --]]
	if level <= 17 then
		-- Check to see if player selected auto leveling
		if not playerID.GetAutoLevel() then

			--Create a menu with some level up choices and label them!
			CreateMenu( "LEVEL_UP", "Choose a skill", -1 )
			AddMenuOption( "LEVEL_UP", 6 , "5% Increased Resistance")
			AddMenuOption( "LEVEL_UP", 7 , "5% Increased Speed")
			AddMenuOption( "LEVEL_UP", 8 , "5% Health and Armor Regeneration")

			-- Add Offensive skills to Offensive classes
			if PlayerClass == 1 or PlayerClass == 5 or PlayerClass == 8 then
				AddMenuOption( "LEVEL_UP", 9 , "15% Increased Flag Throwing")
			else
				AddMenuOption( "LEVEL_UP", 9 , "5% Increased Damage")
			end

			ShowMenuToPlayer(player, "LEVEL_UP")

		else
			local auto_choice = RandomInt(1, 4)

			if auto_choice == 1 then
				ChatToPlayer(player, "^5Auto-Selected^8 5% Increased Resistance")
				player_table[SteamID][PlayerClass].skill_1 = player_table[SteamID][PlayerClass].skill_1 + 1
			elseif auto_choice == 2 then
				ChatToPlayer(player, "^5Auto-Selected^4 5% Increased Speed")
				player_table[SteamID][PlayerClass].skill_2 = player_table[SteamID][PlayerClass].skill_2 + 1
				speed_skill(player)
			elseif auto_choice == 3 then
				ChatToPlayer(player, "^5Auto-Selected^2 5% Health and Armor Regeneration")
				player_table[SteamID][PlayerClass].skill_3 = player_table[SteamID][PlayerClass].skill_3 + 1
			elseif auto_choice == 4 then
				if PlayerClass == 1 or PlayerClass == 5 or PlayerClass == 8 then
					ChatToPlayer(player, "^5Auto-Selected^9 15% Increased Flag Throwing")
					player_table[SteamID][PlayerClass].skill_O = player_table[SteamID][PlayerClass].skill_O + 1
				else
					ChatToPlayer(player, "^5Auto-Selected^2 5% Increased Damage")
					player_table[SteamID][PlayerClass].skill_D = player_table[SteamID][PlayerClass].skill_D + 1
				end
			end -- auto choice
		end -- auto level
		BroadCastSoundToPlayer( player, "Misc.Unagi" )
	end -- uner lvl 17
end

return xp_module
