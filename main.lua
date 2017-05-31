local playerModule = require "globalscripts.rpg_player_module"
local hudModule = require "globalscripts.rpg_hud_module"
local skillsModule = require "globalscripts.rpg_skills_module" -- soon to remove
local ID = playerModule.getPlayer
local playerList = {}

function player_connected(playerID)
    playerList[ID(playerID)] = playerModule.NewPlayer(playerID)
end

function player_switchteam(playerID, old, new )
    hudModule.HideAll(playerID)


--[[ From old version
	CreateMenu( "CLEAR", "Clear Menu", 1 )
	ShowMenuToPlayer(player, "CLEAR")
	DestroyMenu( "CLEAR" )
--]]
    return true -- true allows switch, false denies player
end

function player_switchclass(playerID, old, new )
	hudModule.HideAll(playerID)

	CreateMenu( "CLEAR", "Clear Menu", 1 )
	ShowMenuToPlayer(playerID, "CLEAR")
	DestroyMenu( "CLEAR" )
	return true
end


function player_spawn(playerID)
    local player = playerList[ID(playerID)]
    player.UpdateSpawn()
end

function player_ondamage(playerID, damageinfo)
    local player = playerList[ID(playerID)]
    ChatToAll(" "..player.GetClassName()) --Debug test
    --player.LevelUp()
    player.GainXp(60)
    skillsModule.Resistance(player, damageinfo)
end

function player_killed(playerID, damageinfo)
	--[[if type(function_table.player_killed) == "function" then
		function_table.player_killed(playerID, damageinfo)
	end]]--
	--Hide information bar when someone dies
	hudModule.HideAll(playerID)

	-- suicides have no damageinfo
	if not killer then return end
	if damageinfo ~= nil then
		local player = CastToPlayer( player_entity )
		local killer = damageinfo:GetAttacker()
		local weapon = damageinfo:GetInflictor():GetClassName()
		local killer = CastToPlayer(killer)

		local AttackerSteamID = killer:GetSteamID()
		local AttackerClass = killer:GetClass()

		if IsPlayer(killer) then

		if not (player:GetTeamId() == killer:GetTeamId()) then
			-- Pyro Maniac
			pyro_maniac(player, killer, 7, player_table[AttackerSteamID][AttackerClass].skill_ult_1, damageinfo)

			-- Soldier Rocket Science
			rocket_science(player, killer, 3, player_table[AttackerSteamID][AttackerClass].skill_ult_2, damageinfo)

			local killersTeam = killer:GetTeam()
			--local victim = GetPlayer(player_id)
			if player_table[AttackerSteamID].multi_kill >= 3 then
				gain_xp(killer, XP_PER_KILL + XP_PER_MULTI_KILL * 3)
			else
				gain_xp(killer, XP_PER_KILL + XP_PER_MULTI_KILL * player_table[AttackerSteamID].multi_kill)
			end
				player_table[AttackerSteamID].multi_kill = player_table[AttackerSteamID].multi_kill + 1

			end
		end
	end
end

--So, you made a selection.. Lets save that information
function player_onmenuselect(playerID, menu_name, selection)
    local player = playerList[ID(playerID)]

	-- For basic skills
	if menu_name == "LEVEL_UP" then
		if selection == 6 then
	           player.LevelUpResist()
		elseif selection == 7 then
			ChatToPlayer(player, "^5You Selected ^4"..SKILL_NAME.SKILL_2)
			player_table[SteamID][PlayerClass].skill_2 = player_table[SteamID][PlayerClass].skill_2 + 1
			speed_skill(player)
			LogLuaEvent(PlayerID, 0, "LEVEL_UP_MENU", SKILL_NAME.SKILL_2, "Rank: "..tostring(player_table[SteamID][PlayerClass].skill_2) )
		elseif selection == 8 then
			ChatToPlayer(player, "^5You Selected ^2"..SKILL_NAME.SKILL_3)
			player_table[SteamID][PlayerClass].skill_3 = player_table[SteamID][PlayerClass].skill_3 + 1
			LogLuaEvent(PlayerID, 0, "LEVEL_UP_MENU", SKILL_NAME.SKILL_3, "Rank: "..tostring(player_table[SteamID][PlayerClass].skill_3) )
		elseif selection == 9 then
			if PlayerClass == 1 or PlayerClass == 5 or PlayerClass == 8 then
				ChatToPlayer(player, "^5You Selected ^9"..SKILL_NAME.SKILL_O)
				player_table[SteamID][PlayerClass].skill_O = player_table[SteamID][PlayerClass].skill_O + 1
				LogLuaEvent(PlayerID, 0, "LEVEL_UP_MENU", SKILL_NAME.SKILL_O, "Rank: "..tostring(player_table[SteamID][PlayerClass].skill_O) )
			else
				ChatToPlayer(player, "^5You Selected ^2"..SKILL_NAME.SKILL_D)
				player_table[SteamID][PlayerClass].skill_D = player_table[SteamID][PlayerClass].skill_D + 1
				LogLuaEvent(PlayerID, 0, "LEVEL_UP_MENU", SKILL_NAME.SKILL_D,"Rank: "..tostring(player_table[SteamID][PlayerClass].skill_D) )
			end
		end
	end

end
