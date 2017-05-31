local player_module = {}
local utilModule = require "globalscripts.rpg_util_module"
local hudModule = require "globalscripts.rpg_hud_module"
local xpModule = require "globalscripts.rpg_xp_module"

function player_module.getPlayer(playerID)
    local player = CastToPlayer(playerID)
    local steam_id = player:GetSteamID()
    return steam_id
end

function player_module.NewPlayer(playerID)
    local self = {}
    local player = CastToPlayer(playerID)
    local level = 1
    local xp = 0
    local xp_to_next = 100
    local steam_id = player:GetSteamID()
    local class_id = player:GetClass()
    local allow_ult = false
    local auto_level = false
    local class_name = "R00Kie"
    local regen_level, resistance_level, speed_level, throw_level, damage_level = 0, 0, 0 ,0 ,0

    function self.GetLevel() return level end
    function self.SetLevel(number) level = number end
    function self.LevelUp()
        level = level + 1
        xp_to_next = xp_to_next * 1.15 + 100
        hudModule.UpdateAll(self)
        xpModule.LevelUp(self)

    end

    function self.AllowUlt() return allow_ult end

    function self.GetXp() return xp end
    function self.SetXp(number) xp = number end
    function self.GainXp(amount)
        xp = xp + amount
        hudModule.UpdateXpBar(self)
 		--Check XP needed for next level
 		if self.GetXp() >= self.GetXpToNext() then self.LevelUp() end

     end

    function self.GetAutoLevel() return auto_level end

    function self.GetXpToNext() return xp_to_next end
    function self.SetXpToNext(number)  xp_to_next = number end

    function self.GetPlayer() return player end

    function self.GetSteamID() return steam_id end

    function self.GetClassID() return class_id end
    function self.SetClassID(number) class_id = number end

    function self.GetClassName() return class_name end
    function self.SetClassName(string) class_name = string end

    function self.GetClassInfo() end

    function self.GetRegenLevel() return regen_level end
    function self.GetResistLevel() return resistance_level end
    function self.LevelUpResist()
         resistance_level = resistance_level + 1
         ChatToPlayer(player, "^5You Selected^8 5% Increased Resistance")
     end
    function self.GetSpeedLevel() return speed_level end
    function self.GetThrowLevel() return throw_level end
    function self.GetDamageLevel() return damage_level end

    function self.UpdateSpawn()
        class_id = player:GetClass()
        class_name = utilModule.GetClassName(class_id)
        hudModule.UpdateAll(self)
    end

    return self
end

return player_module
