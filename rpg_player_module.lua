local player_module = {}
local utilModule = require "globalscripts.rpg_util_module"
local hudModule = require "globalscripts.rpg_hud_module"
local xpModule = require "globalscripts.rpg_xp_module"
local skillsModule = require "globalscripts.rpg_skills_module"

function player_module.getPlayer(playerID)
    local player = CastToPlayer(playerID)
    local steam_id = player:GetSteamID()
    return steam_id
end

function player_module.NewPlayer(playerID)
    local self = {}
    local classLine = {}
    local currentLine = nil
    local currentUlt = nil

    local player = CastToPlayer(playerID)
    function self.GetPlayer() return player end

    function self.GetClassLine() return currentLine end
    function self.SetClassLine()
        for i=1,10 do
            classLine[i] = xpModule.NewExperienceLine(self)
        end
    end

    function self.UpdateCurrentLine(int) currentLine = classLine[int] end
    function self.UpdateCurrentUlt(int)
        local skill_table = {
            skillsModule.Scout(),
            skillsModule.Sniper(),
            skillsModule.Soldier(),
            skillsModule.Demoman(),
            skillsModule.Medic(),
            skillsModule.HwGuy(),
            skillsModule.Pyro(),
            skillsModule.Spy(),
            skillsModule.Engineer(),
            skillsModule.Civilian()
        }
        currentUlt = skill_table[int]
    end
    function self.GetXp() return currentLine.GetXp() end
    function self.SetXp(int) currentLine.SetXp(int) end
    function self.GainXp(amount)
        currentLine.GainXp(amount)
        hudModule.UpdateXpBar(self)
        --Check XP needed for next level
        if self.GetXp() >= self.GetXpToNext() then self.LevelUp() end
    end

    function self.GetLevel() return currentLine.GetLevel() end
    function self.SetLevel(int) currentLine.SetLevel(int)  end
    function self.LevelUp()
        currentLine.LevelUp()
        hudModule.UpdateAll(self)
     end

    local auto_level = false
    function self.GetAutoLevel() return auto_level end
    function self.ToggleAutoLevel() auto_level = not auto_level end

    function self.GetXpToNext() return currentLine.GetXpToNext() end
    function self.SetXpToNext(int)  currentLine.SetXpToNext(int) end

    local allow_ult = false
    function self.IsAllowUlt() return allow_ult end
    function self.SetAllowUlt(boolean) allow_ult = boolean end

    local flag_touched = false
    function self.IsFlagTouched() return flag_touched end
    function self.SetFlagTouched(boolean) flag_touched = boolean end

    local player_name = player:GetName()
    function self.GetPlayerName() return player_name end

    local steam_id = player:GetSteamID()
    function self.GetSteamID() return steam_id end

    local class_id = player:GetClass()
    function self.GetClassID() return class_id end
    function self.SetClassID(int) class_id = int end

    local class_name = "R00Kie"
    function self.GetClassName() return class_name end
    function self.SetClassName(string) class_name = string end

    local team_id = player:GetTeamId()
    function self.GetTeamID() return team_id end
    function self.SetTeamID(int) team_id = int end

    --Basic Skills
    function self.GetRegenLevel() return currentLine.GetRegenLevel() end
    function self.LevelUpRegen()
        currentLine.LevelUpRegen()
        LogLuaEvent(player:GetId(), 0, "add_skill", "skill_name", "regeneration", "level", ""..self.GetLevel())
        ChatToPlayer(player, "^5You Selected^2 5% Health and Armor Regeneration")
        hudModule.UpdateRegen(self)
    end

    function self.GetResistLevel() return currentLine.GetResistLevel() end
    function self.LevelUpResist()
         currentLine.LevelUpResist()
         LogLuaEvent(player:GetId(), 0, "add_skill", "skill_name", "resistance", "level", ""..self.GetLevel())
         ChatToPlayer(player, "^5You Selected^8 5% Increased Resistance")
         hudModule.UpdateResist(self)
    end

    function self.GetSpeedLevel() return currentLine.GetSpeedLevel() end
    function self.LevelUpSpeed()
        currentLine.LevelUpSpeed()
        LogLuaEvent(player:GetId(), 0, "add_skill", "skill_name", "speed", "level", ""..self.GetLevel())
        ChatToPlayer(player, "^5You Selected^4 5% Increased Speed")
        hudModule.UpdateSpeed(self)
        skillsModule.Speed(self)
    end

    -- Offensive Basic Skill
    function self.GetFlagThrowLevel() return currentLine.GetFlagThrowLevel() end
    function self.LevelUpFlagThrow()
        currentLine.LevelUpFlagThrow()
        LogLuaEvent(player:GetId(), 0, "add_skill", "skill_name", "throwing", "level", ""..self.GetLevel())
        ChatToPlayer(player, "^5You Selected^9 15% Increased Flag Throwing")
        hudModule.UpdateThrow(self)
    end

    -- Defensive Basic Skill
    local damage_level = 0
    function self.GetDamageLevel() return currentLine.GetDamageLevel() end
    function self.LevelUpDamage()
        currentLine.LevelUpDamage()
        LogLuaEvent(player:GetId(), 0, "add_skill", "skill_name", "damage", "level", ""..self.GetLevel())
        ChatToPlayer(player, "^5You Selected^2 5% Increased Damage")
        hudModule.UpdateDamage(self)
    end
    function self.LevelUpRoleSkill()
        -- Class is offensive scout(1), medic(5) or spy(8)
        if class_id == 1 or class_id == 5 or class_id == 8 then
            self.LevelUpFlagThrow()
        else -- Class is defensive
            self.LevelUpDamage()
        end
    end
    -- Ultimate Skills
    function self.GetUltName(int) return currentUlt.GetUltName(int) end
    function self.GetUltDesc(int) return currentUlt.GetUltDesc(int) end
    function self.GetUlt(int) return currentLine.GetUlt(int) end
    function self.LevelUlt(int)
        local msg = currentUlt.GetUltName(int)
        currentLine.LevelUlt(int)
        LogLuaEvent(player:GetId(), 0, "add_skill", "ult_name", msg, "level", ""..self.GetLevel())
        ChatToPlayer(player, "^5You Selected^2 "..msg)
        --TODO: change update all to only update current skill
        hudModule.UpdateAll(self)
    end

    local kill_count = 0
    function self.GetKillCount() return kill_count end
    function self.SetKillCount(int) kill_count = int end
    function self.AddToKillCount() kill_count = kill_count + 1 end

    function self.UpdateSpawn()
        self.SetKillCount(0)
        self.SetFlagTouched(false)
        team_id = player:GetTeamId() -- TODO: not required every spawn
        class_id = player:GetClass() -- TODO: not required every spawn
        class_name = utilModule.GetClassName(class_id) -- TODO: not required every spawn
        self.UpdateCurrentLine(class_id) -- TODO: not required every spawn
        self.UpdateCurrentUlt(class_id) -- TODO: not required every spawn
        hudModule.UpdateAll(self)
    end

    return self
end

return player_module
