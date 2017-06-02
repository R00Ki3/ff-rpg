local xp_module = {}
local LevelUpDelay

function xp_module.NewExperienceLine(playerID)
    local self = {}

    local xp = 0
    local xp_to_next = 98
    function self.GetXp() return xp end
    function self.SetXp(int) xp = int end
    function self.GainXp(amount)
        xp = xp + amount
        --Check XP needed for next level
        if self.GetXp() >= self.GetXpToNext() then self.LevelUp() end
    end

    function self.GetXpToNext() return xp_to_next end
    function self.SetXpToNext(int)  xp_to_next = int end

    local level = 1
    function self.GetLevel() return level end
    function self.SetLevel(int) level = int end
    function self.LevelUp()
        level = level + 1
        xp =  xp % xp_to_next -- Keep leftover xp on lvel
        local toFloor = math.floor
        xp_to_next = toFloor(xp_to_next * 1.15)
        xp_module.LevelUp(playerID)
    end

    --Basic Skills
    local regen_level = 0
    function self.GetRegenLevel() return regen_level end
    function self.LevelUpRegen()
        regen_level = regen_level + 1
    end

    local resistance_level = 0
    function self.GetResistLevel() return resistance_level end
    function self.LevelUpResist()
         resistance_level = resistance_level + 1
    end

    local speed_level = 0
    function self.GetSpeedLevel() return speed_level end
    function self.LevelUpSpeed()
        speed_level = speed_level + 1
    end

    -- Offensive Basic Skill
    local throw_level = 0
    function self.GetFlagThrowLevel() return throw_level end
    function self.LevelUpFlagThrow()
        throw_level = throw_level + 1
    end

    -- Defensive Basic Skill
    local damage_level = 0
    function self.GetDamageLevel() return damage_level end
    function self.LevelUpDamage()
        damage_level = damage_level + 1
    end

    return self
end

function xp_module.LevelUp(playerID)
    local player = playerID.GetPlayer()
    local level = playerID.GetLevel()

	ObjectiveNotice(player, "Level "..level.."!" )
	BroadCastMessageToPlayer(player, "LEVEL "..level.."!", 6, Color.kWhite)
	ChatToPlayer(player,"^5You are now level ^4"..level)

	AddSchedule("level_up", 2, LevelUpDelay, playerID)
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
            local class_id = playerID.GetClassID()
			--Create a menu with some level up choices and label them!
			CreateMenu( "LEVEL_UP", "Choose a skill", -1 )
			AddMenuOption( "LEVEL_UP", 6 , "5% Increased Resistance")
			AddMenuOption( "LEVEL_UP", 7 , "5% Increased Speed")
			AddMenuOption( "LEVEL_UP", 8 , "5% Health and Armor Regeneration")

			-- Add Offensive skills to Offensive classes
			if class_id == 1 or class_id == 5 or class_id == 8 then
				AddMenuOption( "LEVEL_UP", 9 , "15% Increased Flag Throwing")
			else
				AddMenuOption( "LEVEL_UP", 9 , "5% Increased Damage")
			end

			ShowMenuToPlayer(player, "LEVEL_UP")

		else
			local auto_choice = RandomInt(1, 4)

			if auto_choice == 1 then
				playerID.LevelUpResist()
			elseif auto_choice == 2 then
				playerID.LevelUpSpeed()
			elseif auto_choice == 3 then
				playerID.LevelUpRegen()
			elseif auto_choice == 4 then
				if class_id == 1 or class_id == 5 or class_id == 8 then
					playerID.LevelUpFlagThrow()
				else
					playerID.LevelUpDamage()
				end
			end -- auto choice
		end -- auto level
		BroadCastSoundToPlayer(player, "Misc.Unagi")
	end -- under lvl 17
end

return xp_module
