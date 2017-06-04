local utilModule = require "globalscripts.rpg_util_module"
local skills_module = {}

-- Basic Skills
-- Adds x percentage life and armor on each tick (7 sec)
function skills_module.Regeneration(player)
    local REGEN_LIFE_PERCENT = 0.05
    local REGEN_ARMOR_PERCENT = 0.05
    local lvl = player.GetRegenLevel()
    if lvl >=  1 then
        local playerID = player.GetPlayer()
        local health_amount = playerID:GetMaxHealth() * ( REGEN_LIFE_PERCENT * lvl )
        local armor_amount = playerID:GetMaxArmor() * ( REGEN_ARMOR_PERCENT * lvl )
        playerID:AddHealth(health_amount)
        playerID:AddArmor(armor_amount)
    end
end

-- Increases base movement speed by a percentage
-- Max base movement is 600 (hard cap?)
function skills_module.Speed(player)
    local SPEED_INCREASE_PERCENT = 0.05
    local lvl = player.GetSpeedLevel()
	if lvl >= 1 then
        local playerID = player.GetPlayer()
		playerID:RemoveEffect( EF.kSpeedlua1 )
		playerID:AddEffect( EF.kSpeedlua1, -1, 0, SPEED_INCREASE_PERCENT * lvl + 1  )
	end
end

--Reduces damage taken from all sources by a percentage
function skills_module.Resistance(player, damageinfo)
    local RESISTANCE_PERCENT = 0.05
    local lvl = player.GetResistLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(1 - RESISTANCE_PERCENT * lvl) end
end

--Increases damage delt with all weapons by a percentage
function skills_module.IncreaseDamage(player, damageinfo)
    local DAMAGE_INCREASE_PERCENT = 0.05
    local lvl = player.GetDamageLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(1 + DAMAGE_INCREASE_PERCENT * lvl) end
end

--Increases flag throwing distance
function skills_module.FlagThrow(player)
    local THROW_DISTANCE_PERCENT = 0.15
    local lvl = player.GetFlagThrowLevel()
    if lvl >= 1 then
        local throw_power = 1 + THROW_DISTANCE_PERCENT * lvl
        FLAG_THROW_SPEED = 330 * throw_power
    else
        FLAG_THROW_SPEED = 330 -- base throw speed for unleveled skill
    end
end
-- Class Skills
function skills_module.Scout()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Sniper()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Soldier()
    local ROCKET_SNARE_TIME = 0.3
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Rocket Snare", "Snares a player for "..ROCKET_SNARE_TIME.." seconds",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )

    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.RocketSnare(player, damageinfo) -- ult 1
        local function StopSnare(playerID)
        	playerID:LockInPlace(false)
        end
        if player.GetClassID() == 3 and player.GetUlt(1) then
            local weapon = damageinfo:GetInflictor():GetClassName()
            if weapon == "ff_projectile_rocket" then
                local playerID = player.GetPlayer()
                local steam_id = player.GetSteamID()
                playerID:LockInPlace(true)
                AddSchedule("snare_"..steam_id, ROCKET_SNARE_TIME, StopSnare, playerID)
            end
        end
    end

    return self
end

function skills_module.Demoman()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Medic()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.HwGuy()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Pyro()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Spy()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Engineer()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end

function skills_module.Civilian()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    return self
end
return skills_module
