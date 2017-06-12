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

local function regen_tick()
    for _, player in pairs(playerList) do
        skillsModule.Regeneration(player)
		skillsModule.Scout().ConcSupply(player)
		skillsModule.HwGuy().SlowSupply(player)
    end
end

local function matter_tick()
	for _, player in pairs(playerList) do
        skillsModule.Engineer().MatterGenerator(player)
    end
end

local function explosive_tick()
	for _, player in pairs(playerList) do
        skillsModule.Demoman().ExplosiveSupply(player)
    end
end

function startup()
	if type(functionList.startup) == "function" then
		functionList.startup()
	end
	AddScheduleRepeating("explosive_regen", 25, explosive_tick)
	AddScheduleRepeating("health_regen", 7, regen_tick)
	AddScheduleRepeating("matter_regen", 1, matter_tick)

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
	if not player then return end
	local victim = playerList[ID(playerID)]

	if IsSentrygun(player) then
		local sg_attacker = CastToSentrygun(player)
		local sg_owner = sg_attacker:GetOwner()
		local attacker = playerList[ID(sg_owner)]

		if not (victim.GetTeamID() ~= attacker.GetTeamID()) then
			local xp_amount = damageinfo:GetDamage() * 0.30
			attacker.GainXp(xp_amount)
	    end
	elseif IsPlayer(player) then
		local attacker = playerList[ID(player)]
		--Trigger on enemy
	    if not (victim.GetTeamID() == attacker.GetTeamID()) then
	        -- don't allow DETPACKS to gain this bonus
	        if damageinfo:GetDamageType() ~= 320 then
	            local xp_amount = damageinfo:GetDamage() * 0.30
	            attacker.GainXp(xp_amount)
	        end
			skillsModule.Soldier().RocketSnare(victim, attacker, damageinfo)
			skillsModule.Scout().Reflect(victim, attacker, damageinfo)
			skillsModule.Spy().Teleport(victim, attacker, damageinfo)
			skillsModule.Spy().BackstabBerserker(attacker, damageinfo)
			skillsModule.Medic().PoisonAmmo(victim, attacker, damageinfo)
			skillsModule.Sniper().CriticalHit(victim, attacker, damageinfo)

		end

		--Trigger on team mate
	    if victim.GetTeamID() == attacker.GetTeamID() then
			skillsModule.Soldier().SelfResistance(victim, damageinfo)
			skillsModule.Medic().NaturalHealer(victim, attacker, damageinfo)
		end

	    --Triggers everyone
	    skillsModule.Resistance(victim, damageinfo)
	    skillsModule.IncreaseDamage(attacker, damageinfo)
		skillsModule.Scout().BallisticArmor(victim, damageinfo)
		skillsModule.Scout().ExplosiveArmor(victim, damageinfo)
		skillsModule.HwGuy().Enrage(attacker, damageinfo)
		skillsModule.Medic().Momentum(attacker, damageinfo)
	end
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
		if kill_count >= 3 then
            local xp_amount = 20 + 10 * 3
			attacker.GainXp(xp_amount)
		else
            local xp_amount = 20 + 10 * kill_count
			attacker.GainXp(xp_amount)
		end
        attacker.AddToKillCount()
		skillsModule.Soldier().RocketScience(attacker)
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
		player.LevelUlt(selection - 5)
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
