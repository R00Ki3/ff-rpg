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
    local BALLISTIC_ARMOR = 0.75 --25%
    local EXPLOSIVE_ARMOR = 0.75
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Ballistic Armor", "25% Reduced Damage from Bullets",
            "Explosive Armor", "25% Reduced Damage from Explosions",
            "Reflect Damage", "Reflects 10% Damage Back at the Attacker",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.BallisticArmor(player, damageinfo)
        if player.GetClassID() == 1 and player.GetUlt(1) then
            if damageinfo:GetDamageType() == 4098 then
                damageinfo:ScaleDamage(BALLISTIC_ARMOR)
            end
        end
    end

    function self.ExplosiveArmor(player, damageinfo)
        if player.GetClassID() == 1 and player.GetUlt(2) then
            if damageinfo:GetDamageType() == 64 or damageinfo:GetDamageType() == 8 then
                damageinfo:ScaleDamage(EXPLOSIVE_ARMOR)
            end
        end
    end

    function self.Reflect(player, attacker, damageinfo)
        local REFLECT_AMOUNT = 0.10
        if player.GetClassID() == 1 and player.GetUlt(3) then
            if damageinfo:GetDamageType() == 268435456 then
				return false -- Ignore fall damage?
			else
                local playerID = attacker.GetPlayer()
                playerID:AddHealth(-damageinfo:GetDamage() * REFLECT_AMOUNT)
            end
        end
    end

    return self
end

function skills_module.Sniper()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Critical Hit", "20% chance to do 2x Damage",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.CriticalHit(player, damageinfo)
        if player.GetClassID() == 2 and player.GetUlt(1) then
            if RandomInt(1,5) == 3 then
                damageinfo.ScaleDamage(2)
            end
        end
    end

    return self
end

function skills_module.Soldier()
    local ROCKET_SNARE_TIME = 0.3
    local SELF_RESISTANCE = 0.20
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Rocket Snare", "Snares a player for 0.3 seconds",
            "Self Resistance", "90% Reduced Self Damage",
            "Rocket Science", "Fully Reload Weapons On Kill",
            "Empty", "Empty"
            )

    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.RocketSnare(player, attacker, damageinfo) -- ult 1

        if attacker.GetClassID() == 3 and attacker.GetUlt(1) then
            local weapon = damageinfo:GetInflictor():GetClassName()
            if weapon == "ff_projectile_rocket" then
                local playerID = player.GetPlayer()
                local steam_id = player.GetSteamID()

                local function StopSnare()
                    playerID:LockInPlace(false)
                end
                playerID:LockInPlace(true)
                AddSchedule("snare_"..steam_id, ROCKET_SNARE_TIME, StopSnare)
            end
        end
    end

    function self.SelfResistance(player, damageinfo)
        if player.GetClassID() == 3 and player.GetUlt(2) then
            damageinfo:ScaleDamage(SELF_RESISTANCE)
        end
    end

    function self.RocketScience(player)
        if player.GetClassID() == 3 and player.GetUlt(3) then
            local playerID = player.GetPlayer()
            playerID:ReloadClips()
        end
    end
    return self
end

function skills_module.Demoman()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Heavy Explosive Supply", "Resuppy Mirvs, Detpacks, and Pipes Every 25 seconds",
            "Medicated Detpack", "Max Heal to Teammates On Explode",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.ExplosiveSupply(player)
        if player.GetClassID() == 4 and player.GetUlt(1) then
            local playerID = player.GetPlayer()
            playerID:AddAmmo(Ammo.kDetpack, 1)
            playerID:AddAmmo(Ammo.kRockets, 10)
            playerID:AddAmmo(Ammo.kGren2, 1)
        end
    end

    function self.DetpackMedic(player, attacker, damageinfo)
        if attacker.GetClassID() == 4 and attacker.GetUlt(2) then
            if damageinfo:GetDamageType() == 320 then
                local playerID = player.GetPlayer()
                damageinfo:ScaleDamage(0)
                playerID:AddHealth(100)
                playerID:AddArmor(300)
            end
        end
    end
    return self
end

function skills_module.Medic()
    local HEALER_MULTIPLIER = 0.40
	local ARMORER_MULTIPLIER = 0.40
	local CONC_HEAL = 50

    local MOMENTUM_MULTIPLIER = 0.32
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Natural Healer", "Heal Teammates On Hit and On Concussion",
            "Momentum", "Increased Damage at Increased Speeds",
            "Poisoned Ammunition", "3 Second Gas Effect On Hit",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.NaturalHealer(player, healer, damageinfo)
        if healer.GetClassID() == 5 and healer.GetUlt(1) then
            if damageinfo:GetDamageType() ~= 64 then
                local playerID = player.GetPlayer()
                playerID:AddHealth(damageinfo:GetDamage() * HEALER_MULTIPLIER)
                playerID:AddArmor(damageinfo:GetDamage() * ARMORER_MULTIPLIER)
            end
        end
    end

    function self.NaturalHealerConc(player, healer)
        if healer.GetClassID() == 5 and healer.GetUlt(1) then
            local playerID = player.GetPlayer()
            playerID:AddHealth(CONC_HEAL)
        end
    end

    function self.Momentum(player, damageinfo)
        if player.GetClassID() == 5 and player.GetUlt(2) then
            local playerID = player.GetPlayer()
            local speed = playerID:GetSpeed()
            if speed >= 320 then
                damageinfo:ScaleDamage((speed * MOMENTUM_MULTIPLIER) / 100)
            end
        end
    end

    function self.PoisonAmmo(player, attacker, damageinfo)
        if attacker.GetClassID() == 5 and attacker.GetUlt(3) then
            if damageinfo:GetDamageType() ~= 64 then
                local playerID = player.GetPlayer()
                playerID:AddEffect(EF.kGas, 2, 2, 2)

                local function StopPoison()
                    playerID:RemoveEffect(EF.kGas)
                end
                AddSchedule("Poison_"..player.GetSteamID(), 3, StopPoison)
            end
        end
    end
    return self
end

function skills_module.HwGuy()
    local ENRAGE_MAX_MULTIPLIER = 2.5
    local ENRAGE_LIFE_ACTIVE = 0.8 -- 80 life
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Enrage", "Damage Increases as Health Decreases to a Max of 2.5X",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.Enrage(player, damageinfo)
        if player.GetClassID() == 6 and player.GetUlt(1) then
            local enrage_range = (100 / attacker:GetHealth() * ENRAGE_LIFE_ACTIVE)
            if enrage_range >= ENRAGE_MAX_MULTIPLIER then
                damageinfo:ScaleDamage(ENRAGE_MAX_MULTIPLIER)
            elseif(enrage_range <= 1) then
                damageinfo:ScaleDamage(1)
            else
                damageinfo:ScaleDamage(enrage_range)
            end
        end
    end

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
            "Teleport Tranq", "Teleport to Enemy On Hit",
            "Backstab Berserker", "50/50 Resupply and 5 Second Speed Boost on Backstab",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.Teleport(player, attacker, damageinfo)
        if attacker.GetClassID() == 8 and attacker.GetUlt(1) then
            local weapon = damageinfo:GetInflictor():GetClassName()
            if weapon == "ff_projectile_dart" then
                local playerID = player.GetPlayer()
                local attackerID = attacker.GetPlayer()
                local origin = {
                    playerID:GetOrigin().x,
                    playerID:GetOrigin().y,
                    playerID:GetOrigin().z
                }
                attackerID:SetOrigin( Vector( origin[1], origin[2], origin[3] + 96 ))
            end
        end
    end

    function self.BackstabBerserker(player, damageinfo)
        if player.GetClass == 8 and player.GetUlt() then
            -- Damage type for backstab
    		if damageinfo:GetDamageType() == 268435456 then
                local playerID  = player.GetPlayer()
    			playerID:AddHealth(50)
    			playerID:AddArmor(50)
                -- 5 second boost at 1.5x speed
    			playerID:AddEffect(EF.kSpeedlua2, 5, 5, 1.5)
    		end
    	end


    end
    return self
end

function skills_module.Engineer()
    local self = {}
    local thisUlt = utilModule.NewUlt(
            "Matter Generator", "Generates Cells Every Second",
            "Empty", "Empty",
            "Empty", "Empty",
            "Empty", "Empty"
            )
    function self.GetUltName(int) return thisUlt.GetUltName(int) end
    function self.GetUltDesc(int) return thisUlt.GetUltDesc(int) end

    function self.MatterGenerator(player)
        if player.GetClassID() == 9 and player.GetUlt(1) then
            local playerID = player.GetPlayer()
            local cells = playerID:GetAmmoCount(Ammo.kCells) + 20
            local give_cells =  200 / cells + 3
            playerID:AddAmmo(Ammo.kCells, give_cells)
        end
    end

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
