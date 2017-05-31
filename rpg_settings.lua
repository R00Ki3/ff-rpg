<
-------------------------------------------------------------------------------
-- Global Settings -- Ver. 0.6.1
-------------------------------------------------------------------------------
-- Mod Info
	MOD_NAME = "FFrpg"
	VERSION_NUM = "0.6.1"

-- Leveling up
	FIRST_ULT_LEVEL = 6
	SECOND_ULT_LEVEL = 11
	THIRD_ULT_LEVEL = 0 --Disabled
	FOURTH_ULT_LEVEL = 0 --Disabled
	XP_MULTIPLIER = 1.15
	XP_TO_NEXT_LEVEL = 98
	MAX_LEVEL = 17

-- Gaining XP
	XP_PER_CONC = 10
	XP_DAMAGE_MULTIPLIER = 0.30
	XP_PER_MULTI_KILL = 10
	XP_PER_KILL = 20
	XP_PER_CAP = 80
	XP_PER_TOUCH = 20

-- Basic Skills

-- Resistance skill SKILL_1
	DEFENSE_PER_LVL = 0.05

-- Speed skill SKILL_2
	SPEED_PER_LVL = 0.05

-- Life Regen SKILL_3
	REGEN_COUNTER = 0
	REGEN_TIME = 7
	REGEN_LIFE_PER_LVL = 0.05
	REGEN_ARMOR_PER_LVL = 0.05

-- Damage skill SKILL_D
	DAMAGE_PER_LVL = 0.05

-- Flag throwing power SKILL_O
	FLAG_POWER = 0.15

-- Basic Menu
SKILL_NAME =
{
	SKILL_1 = "5% Increased Resistance",
	SKILL_2 = "5% Increased Speed",
	SKILL_3 = "5% Health and Armor Regeneration",
	SKILL_O = "15% Increased Flag Throwing",
	SKILL_D = "5% Increased Damage",
}
-------------------Scout-------------------------------

-- Concussion Supply
	CONC_COUNTER = 0
	CONC_TIME = 6

-- Explosive Armor
	EXPLOSIVE_ARMOR = 0.75 -- 25%

--Ballistic Armor
	BALLISTIC_ARMOR = 0.75 -- 25%

-- Reflect Damage
	REFLECT_AMOUNT = 0.10 -- 10%

-- Scout Menu
SKILL_NAME[1] =
{
	ULT_1 = "Concussion Supply",
	ULT_2 = "Explosive Armor",
	ULT_3 = "Ballistic Armor",
	ULT_4 = "Reflect Damage",

	INFO_1 = "1 Conc Every ".. CONC_TIME.." Seconds",
	INFO_2 = (-100 * EXPLOSIVE_ARMOR + 100).."% Reduced Damage from Explosions",
	INFO_3 = (-100 * BALLISTIC_ARMOR + 100).."% Reduced Damage from Bullets",
	INFO_4 = "Reflects 10% Damage Back at the Attacker"
}
-------------------Sniper------------------------------
-- Critical Hit
	SNIPER_CRIT = 2.0

-- Sniper Menu
SKILL_NAME[2] =
{
	ULT_1 = "Critical Hit",
	ULT_2 = "Null", -- Festering Wounds
	ULT_3 = "Null",
	ULT_4 = "Null",

	INFO_1 = "20% Chance to do "..SNIPER_CRIT.."x Damage",
	INFO_2 = "",
	INFO_3 = "",
	INFO_4 = ""
}
-------------------Soldier-----------------------------
-- Self Resistance
	SELF_RESISTANCE = 0.10 --90%

-- Rocket Snare
	ROCKET_SNARE_TIME = 0.3

-- Soldier Menu
SKILL_NAME[3] =
{
	ULT_1 = "Self Resistance",
	ULT_2 = "Rocket Science",
	ULT_3 = "Rocket Snare",
	ULT_4 = "Null",

	INFO_1 = (-100 * SELF_RESISTANCE + 100).."% Reduced Self Damage",
	INFO_2 = "Fully Reload Weapons On Kill",
	INFO_3 = ROCKET_SNARE_TIME.." Second Snare On Hit",
	INFO_4 = ""
}
------------------Demoman-----------------------------
-- Medicated Detpack
	MEDI_DET_HEALTH = 100
	MEDI_DET_ARMOR = 300

-- Heavy Explosive Supply
	EXPLOSIVE_COUNTER = 0
	EXPLOSIVE_SUPPLY = 25
	ADD_MIRV = 1
	ADD_DETPACK = 1
	ADD_PIPES = 10

-- Demoman Menu
SKILL_NAME[4] =
{
	ULT_1 = "Medicated Detpack", -- Time Bomb
	ULT_2 = "Heavy Explosive Supply",
	ULT_3 = "Null", -- Demoman Funk
	ULT_4 = "Implosive Weapons",

	INFO_1 = "No Self Damage and Max Heal On Explode",
	INFO_2 = "Resuppy Mirvs, Detpacks, and Pipes Every "..EXPLOSIVE_SUPPLY.." Seconds",
	INFO_3 = "",
	INFO_4 = "Explosives Pull Instead of Push Enemies"
}

-------------------Medic-------------------------------

-- Brutal Concussions damage
	CONC_DAMAGE = -25

-- Poisoned Ammo
	POISONED_TIME = 3

--Natural Healer
	HEALER_MULTIPLIER = 0.40
	ARMORER_MULTIPLIER = 0.40
	CONC_HEAL = 50

-- Momentum
	MOMENTUM_MULTIPLIER = 0.32

-- Medic Menu
SKILL_NAME[5] =
{
	ULT_1 = "Brutal Concussions",
	ULT_2 = "Poisoned Ammunition",
	ULT_3 = "Natural Healer",
	ULT_4 = "Momentum",

	INFO_1 = "Deal "..CONC_DAMAGE.." Damage to Enemies On Concussion",
	INFO_2 = POISONED_TIME.." Second Gas Effect On Hit",
	INFO_3 = "Heal Teammates On Hit and On Concussion",
	INFO_4 = "Increased Damage at Increased Speeds"
}

-------------------HWGuy-------------------------------
--Ammo & Slow Supply
	SLOW_COUNTER = 0
	SLOW_TIME = 7
	SHELLS_SUPPLY = 50
	SLOW_SUPPLY = 1

-- Enrage
	ENRAGE_MAX_MULTIPLIER = 2.5
	ENRAGE_LIFE_ACTIVE = 0.8 -- 80 life

-- HWGuy Menu
SKILL_NAME[6] =
{
	ULT_1 = "Null",
	ULT_2 = "Ammo & Slow Supply",
	ULT_3 = "Enrage",
	ULT_4 = "Null", --invulnerable fortress

	INFO_1 = "",
	INFO_2 = "Gives 1 Slowfield and ammo every 7 Seconds",
	INFO_3 = "Damage Increases as Health Decreases to a Max of "..ENRAGE_MAX_MULTIPLIER.."X",
	INFO_4 = ""
}

-------------------Pyro--------------------------------

-- Maniac
	MANIAC_LIFE = 20
	MANIAC_ARMOR = 25
	MANIAC_GREN2 = 1
	MANIAC_SPEED_TIME = 5
	MANIAC_SPEED_MULTIPLIER = 1.5

--  Immolation
	IMMOLATION_SACRIFICE = -1
	IMMOLATION_MULTIPLIER = 1.5

-- Pyro Menu
SKILL_NAME[7] =
{
	ULT_1 = "Maniac",
	ULT_2 = "Immolation",
	ULT_3 = "Null",
	ULT_4 = "Null",

	INFO_1 = MANIAC_LIFE.."/"..MANIAC_ARMOR.." Resupply, "..MANIAC_GREN2.." Napalm, and "..MANIAC_SPEED_TIME.." Second Speed Boost On Kill",
	INFO_2 = "High Increased Damage at the cost of life",
	INFO_3 = "",
	INFO_4 = ""
}

-------------------Spy---------------------------------

-- Backstab Berserker
	BACKSTAB_SPEED_MULTIPLIER = 1.5
	BACKSTAB_SPEED_TIME = 5
	BACKSTAB_LIFE = 50
	BACKSTAB_ARMOR = 50

-- Well Hidden
	CLOAKED_ARMOR = 0.65 --35%
	DISGUISED_ARMOR = 0.75 -- 25%

-- Teleport Tranq
	TELEPORT_X = 0
	TELEPORT_Y = 0
	TELEPORT_Z = 96

-- Unhindering Cloak

	CLOAK_TIME = 1.2
	UNHINDER_SPEED = 1.9

--Spy Menu
SKILL_NAME[8] =
{
	ULT_1 = "Backstab Berserker",
	ULT_2 = "Well Hidden",
	ULT_3 = "Teleport Tranq",
	ULT_4 = "Unhindering Cloak",

	INFO_1 = BACKSTAB_LIFE.."/"..BACKSTAB_ARMOR.." Resupply and  "..BACKSTAB_SPEED_TIME.." Second Speed Boost On Backstab",
	INFO_2 = (-100 * CLOAKED_ARMOR + 100).."% Reduced Damage While Cloaked, "..(-100 * DISGUISED_ARMOR + 100).."% While Disguised",
	INFO_3 = "Teleport to Enemy On Hit",
	INFO_4 = "Increased Cloaked Speed"
}

-------------------Engineer---------------------------------
--Matter Generator
	MATTER_AMOUNT = 3
	MATTER_TIME = 1
-- Nano Armor
	NANO_ADD_ARMOR = 50
	NANO_ARMOR = 0.75 --25%

--Neuro Link
	NEURO_BASE_ARMOR = 0.05
	NEURO_BASE_DAMAGE = 0.10

-- Engineer Menu
SKILL_NAME[9] =
{
	ULT_1 = "Null", -- Team Teleporter disp -> SG
	ULT_2 = "Matter Generator",
	ULT_3 = "Nano Armor",
	ULT_4 = "Neuro Link",

	INFO_1 = "",
	INFO_2 = "Generates Cells Every Second",
	INFO_3 = (-100 * NANO_ARMOR + 100).."% Reduced Damage and "..NANO_ADD_ARMOR.." Armor When Hit",
	INFO_4 = "Gain 10% Damage and 5% Resistance per Sentry level"
}

-------------------Civilian---------------------------------

-- Civilian Menu
SKILL_NAME[10] =
{
	ULT_1 = "Null",
	ULT_2 = "Null",
	ULT_3 = "Null",
	ULT_4 = "Null",

	INFO_1 = "",
	INFO_2 = "",
	INFO_3 = "",
	INFO_4 = ""
}
