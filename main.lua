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
    if not damageinfo then return end
    local player = damageinfo:GetAttacker()
    if not player then return end
    local attacker = playerList[ID(player)]
    if not attacker then return end
    local victim = playerList[ID(playerID)]

    if not victim.GetTeamID() == attacker.GetTeamID() then
        -- don't allow DETPACKS to gain this bonus
        if damageinfo:GetDamageType() ~= 320 then
            local xp_amount = damageinfo:GetDamage() * 0.30
            attacker.GainXp(xp_amount)
        end
    end

    --Basic Skill Calls
    skillsModule.Resistance(victim, damageinfo)
    skillsModule.IncreaseDamage(attacker, damageinfo)
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

	-- Select Basic Skill
	if menu_name == "LEVEL_UP" then
		if selection == 6 then
            player.LevelUpResist()
		elseif selection == 7 then
            player.LevelUpSpeed()
		elseif selection == 8 then
            player.LevelUpRegen()
		elseif selection == 9 then
            player.LevelUpRoleSkill()
		end
	end

end