
local skills_module = {}

-- Basic Skills

-- Adds x percentage life and armor on each tick (7 sec)
function skills_module.Regeneration(player)
    local lvl = player.GetRegenLevel()
    if lvl >=  1 then
        local playerID = player.GetPlayer()
        local health_amount = playerID:GetMaxHealth() * ( 0.05 * lvl )
        local armor_amount = playerID:GetMaxArmor() * ( 0.05 * lvl )
        playerID:AddHealth(health_amount)
        playerID:AddArmor(armor_amount)
    end
end

-- Increases base movement speed by a percentage
-- Max base movement is 600 (hard cap?)
function skills_module.Speed(player)
    local lvl = player.GetSpeedLevel()
	if lvl >= 1 then
        local playerID = player.GetPlayer()
		playerID:RemoveEffect( EF.kSpeedlua1 )
		playerID:AddEffect( EF.kSpeedlua1, -1, 0, 0.05 * lvl + 1  )
	end
end

--Reduces damage taken from all sources by a percentage
function skills_module.Resistance(player, damageinfo)
    local lvl = player.GetResistLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(1 - 0.05 * lvl) end
end

--Increases damage delt with all weapons by a percentage
function skills_module.IncreaseDamage(player, damageinfo)
    local lvl = player.GetDamageLevel()
    if lvl >= 1 then damageinfo:ScaleDamage(0.05 * lvl + 1) end
end

--Increases flag throwing distance
function skills_module.FlagThrow(player)
    local lvl = player.GetFlagThrowLevel()
    if lvl >= 1 then
        local throw_power =  0.15 * lvl + 1
        FLAG_THROW_SPEED = 330 * throw_power
    else
        FLAG_THROW_SPEED = 330 -- base throw speed for unleveled skill
    end
end
-- Class Skills


return skills_module
