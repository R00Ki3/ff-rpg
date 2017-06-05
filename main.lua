local playerModule = require "globalscripts.rpg_player_module"
local hudModule = require "globalscripts.rpg_hud_module"
local skillsModule = require "globalscripts.rpg_skills_module"

local ID = playerModule.getPlayer
local playerList = {}
local functionList = {
	startup = startup,
	player_spawn = player_spawn,
	player_onchat = player_onchat,
	player_ondamage = player_ondamage,
	player_killed = player_killed
 }
functionList.baseflag = {
	touch = baseflag.touch ,
	dropitemcmd = baseflag.dropitemcmd
}

PrecacheSound("Misc.Unagi")

function player_tick()
    for _, player in pairs(playerList) do
        skillsModule.Regeneration(player)
    end
end

function startup()
	if type(functionList.startup) == "function" then
		functionList.startup()
	end

	AddScheduleRepeating("health_regen", 7, player_tick)
end

function player_connected(playerID)
	local player = playerModule.NewPlayer(playerID)
	playerList[ID(playerID)] = player
	player.SetClassLine()
end

function player_switchteam(playerID, old, new )
    hudModule.HideAll(playerID)

	CreateMenu( "CLEAR", "Clear Menu", 1 )
	ShowMenuToPlayer(player, "CLEAR")
	DestroyMenu( "CLEAR" )

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
	if type(functionList.player_spawn) == "function" then
		functionList.player_spawn(playerID)
	end
    local player = playerList[ID(playerID)]
    player.UpdateSpawn()
	skillsModule.Speed(player)
end

function player_ondamage(playerID, damageinfo)
    if not damageinfo then return end
    local player = damageinfo:GetAttacker()
    if not IsPlayer(player) then return end
    local attacker = playerList[ID(player)]
    local victim = playerList[ID(playerID)]

	--Trigger on enemy
    if not (victim.GetTeamID() == attacker.GetTeamID()) then
        -- don't allow DETPACKS to gain this bonus
        if damageinfo:GetDamageType() ~= 320 then
            local xp_amount = damageinfo:GetDamage() * 0.30
            attacker.GainXp(xp_amount)
        end
		skillsModule.Soldier().RocketSnare(victim, damageinfo)

    end
	--Trigger on team mate
    if victim.GetTeamID() == attacker.GetTeamID() then
		skillsModule.Soldier().SelfResistance(victim, damageinfo)
		skillsModule.Medic().NaturalHealer(attacker, victim, damageinfo)
	end

    --Triggers everyone
    skillsModule.Resistance(victim, damageinfo)
    skillsModule.IncreaseDamage(attacker, damageinfo)
	skillsModule.Scout().BallisticArmor(victim, damageinfo)
	skillsModule.Scout().ExplosiveArmor(victim, damageinfo)
	skillsModule.HwGuy().Enrage(attacker, damageinfo)
end

function player_killed(playerID, damageinfo)
	--[[if type(function_table.player_killed) == "function" then
		function_table.player_killed(playerID, damageinfo)
	end]]--
	--Hide information bar when someone dies
	hudModule.HideAll(playerID)

    if not damageinfo then return end
    local player = damageinfo:GetAttacker()
    if not IsPlayer(player) then return end
    local attacker = playerList[ID(player)]
    local victim = playerList[ID(playerID)]

    if not (victim.GetTeamID() == attacker.GetTeamID()) then
        local kill_count = attacker.GetKillCount()
		--local victim = GetPlayer(player_id)
		if kill_count >= 3 then
            local xp_amount = 20 + 10 * 3
			attacker.GainXp(xp_amount)
		else
            local xp_amount = 20 + 10 * kill_count
			attacker.GainXp(xp_amount)
		end
        attacker.AddToKillCount()
	end
end

function player_onconc(player, playerID)
	local attacker = playerList[ID(playerID)]
	local victim = playerList[ID(player)]

	--Trigger on enemy
	if not (victim.GetTeamID() == attacker.GetTeamID()) then
		attacker.GainXp(10)
	end

	--Trigger on teammate
	if victim.GetTeamID() == attacker.GetTeamID() then
		skillsModule.Medic().NaturalHealerConc(victim, attacker)
	end

	return true
end

function baseflag:touch(playerID)
	if type(functionList.baseflag.touch) == "function" then
		functionList.baseflag.touch (self, playerID)
	end

	local player = playerList[ID(playerID)]
	if not player.IsFlagTouched() then
		player.GainXp(20)
		player.SetFlagTouched(true)
	end
end

function baseflag:dropitemcmd(playerID)
	if type(functionList.baseflag.dropitemcmd) == "function" then
		functionList.baseflag.dropitemcmd (self, playerID)
	end

	local player = playerList[ID(playerID)]
	skillsModule.FlagThrow(player)
end

function basecap:ontouch(playerID)
	local player = playerList[ID(playerID)]
	player.GainXp(80)
	player.SetFlagTouched(false) -- resets flag touch
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
	elseif menu_name =="LEVEL_UP_ULT" then
		if selection == 6 then
			player.LevelUlt(1)
		elseif selection == 7 then
			player.LevelUlt(2)
		elseif selection == 8 then
			player.LevelUlt(3)
		elseif selection == 9 then
			player.LevelUlt(4)
		end
	end
end

function player_onchat(playerID, chatstring)
	--[[if type(function_table.player_onchat) == "function" then
		function_table.player_onchat(player, chatstring)
	end
    ]]

	local player = playerList[ID(playerID)]

	-- string.gsub call removes all control characters (newlines, return carriages, etc)
	-- string.sub call removes the playername: part of the string, leaving just the message
	local message = string.sub( string.gsub( chatstring, "%c", "" ), string.len(player.GetPlayer():GetName())+3 )
	if message == "!lvlup" then
		player.LevelUp()
		return false
	end
    if message == "!xp" then
        player.GainXp(50)
        return false
    end
	if message == "!auto" then
        player.ToggleAutoLevel()
        return false
    end

	if message == "!lvlult" then
        player.SetAllowUlt(true)
		player.LevelUp()
        return false
    end
	return true -- Allow other chatter
end
