-- This is the primary barebones gamemode script and should be used to assist in initializing your game mode
BAREBONES_VERSION = "1.00"

-- Set this to true if you want to see a complete debug output of all events/processes done by barebones
-- You can also change the cvar 'barebones_spew' at any time to 1 or 0 for output/no output
BAREBONES_DEBUG_SPEW = false
zombie_counter = 1
unit_hp = 10
unit_damageMin = 20
unit_damageMax = 25
unit_goldMin = 25
unit_goldMax = 35

flying_unit_hp = 10
flying_unit_damageMin = 10
flying_unit_damageMax = 10
flying_unit_goldMin = 65
flying_unit_goldMax = 55

boss_unit_hp = 10
boss_unit_damageMin = 10
boss_unit_damageMax = 10
boss_unit_goldMin = 250
boss_unit_goldMax = 300


if GameMode == nil then
    DebugPrint( '[BAREBONES] creating barebones game mode' )
    _G.GameMode = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')
-- This library can be used to synchronize client-server data via player/client-specific nettables
require('libraries/playertables')
-- This library can be used to create container inventories or container shops
require('libraries/containers')
-- This library provides a searchable, automatically updating lua API in the tools-mode via "modmaker_api" console command
require('libraries/modmaker')
-- This library provides an automatic graph construction of path_corner entities within the map
require('libraries/pathgraph')
-- This library (by Noya) provides player selection inspection and management from server lua
require('libraries/selection')

-- These internal libraries set up barebones's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/gamemode')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core barebones files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core barebones files.
require('events')


-- This is a detailed example of many of the containers.lua possibilities, but only activates if you use the provided "playground" map
if GetMapName() == "playground" then
  require("examples/playground")
end

--require("examples/worldpanelsExample")

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function GameMode:PostLoadPrecache()
  DebugPrint("[BAREBONES] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end
--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  DebugPrint("[BAREBONES] First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  DebugPrint("[BAREBONES] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  DebugPrint("[BAREBONES] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  --hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  
  --[[
  local item = CreateItem("item_example_item", hero, hero)
  hero:AddItem(item)
	]]
	
  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability

  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")]]
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function GameMode:OnGameInProgress()
  DebugPrint("[BAREBONES] The game has officially begun")
  	local repeat_interval = 5 -- Rerun this timer every *repeat_interval* game-time seconds
    local start_after = 5 -- Start this timer *start_after* game-time seconds later
    local start_after_boss = 300
    local repeat_boss_interval = 300
    Timers:CreateTimer(start_after, function()
	        SpawnCreeps("spawnerino", 4,"survival_zombie")
	        SpawnCreeps("test_1", 3,"survival_zombie")
	        SpawnCreeps("test_2", 1,"survival_familiar")
	        SpawnCreeps("test_2", 3,"survival_zombie")
	        SpawnCreeps("test_2", 1,"survival_familiar")
	        SpawnCreeps("test_3", 3,"survival_zombie")
	        SpawnCreeps("test_4", 1,"survival_familiar")
	        SpawnCreeps("test_4", 3,"survival_zombie")
	        SpawnCreeps("test_4", 1,"survival_familiar")
	        IncreaseStrengh()


        return repeat_interval
    end)
    Timers:CreateTimer(start_after_boss, function()
	        SpawnBoss("test_3", "survival_boss")
        return repeat_boss_interval
    end)
end
function SpawnBoss(location, unittospawn)
	local point = Entities:FindByName(nil, location):GetAbsOrigin()
	unit_boss = CreateUnitByName("survival_boss", point, true, nil, nil, DOTA_TEAM_NEUTRALS)
    unit_boss:SetMaxHealth(boss_unit_hp)
    unit_boss:SetHealth(boss_unit_hp)
	unit_boss:SetBaseMaxHealth(boss_unit_hp)
	unit_boss:SetBaseDamageMax(boss_unit_damageMax)
	unit_boss:SetBaseDamageMin(boss_unit_damageMin)
end
function SpawnCreeps(location, howmany, unittospawn)
    local point = Entities:FindByName( nil, location):GetAbsOrigin()
    for i = 1, howmany do
    	if zombie_counter < 120 then
    		unit = CreateUnitByName(unittospawn, point, true, nil, nil, DOTA_TEAM_NEUTRALS)
    		if unittospawn == "survival_zombie" then
		      unit:SetMaxHealth(unit_hp)
		      unit:SetHealth(unit_hp)
		      unit:SetBaseMaxHealth(unit_hp)
		      unit:SetBaseDamageMax(unit_damageMax)
		      unit:SetBaseDamageMin(unit_damageMin)
		      unit:SetMaximumGoldBounty(unit_goldMax)
		      unit:SetMinimumGoldBounty(unit_goldMin)
		      zombie_counter = zombie_counter + 1
		      print(zombie_counter)
		  	elseif unittospawn == "survival_familiar" then
		  	  unit:SetMaxHealth(flying_unit_hp)
		      unit:SetHealth(flying_unit_hp)
		      unit:SetBaseMaxHealth(flying_unit_hp)
		      unit:SetBaseDamageMax(flying_unit_damageMax)
		      unit:SetBaseDamageMin(flying_unit_damageMin)
		      unit:SetMaximumGoldBounty(flying_unit_goldMax)
		      unit:SetMinimumGoldBounty(flying_unit_damageMin)
		      zombie_counter = zombie_counter + 1
		      print(zombie_counter)
		  	else
		  		print("unit cant be spawned")
		  	end
		end
    end
  end
function IncreaseStrengh()
  unit_hp = unit_hp + ((unit_hp^1.02-unit_hp)*0.1) + 3
  unit_damageMin = unit_damageMin + ((unit_damageMin^1.01 - unit_damageMin) * 0.1) + 2
  unit_damageMax = unit_damageMax + ((unit_damageMax^1.01 - unit_damageMax)* 0.1) + 2
  unit_goldMin = unit_goldMin + unit_goldMin/10
  unit_goldMax = unit_goldMax + unit_goldMax/10

  flying_unit_hp = flying_unit_hp + ((flying_unit_hp^1.02-flying_unit_hp)*0.1) + 2
  flying_unit_damageMin = flying_unit_damageMin + ((flying_unit_damageMin^1.01 - flying_unit_damageMin) * 0.1) + 2
  flying_unit_damageMax = flying_unit_damageMax + ((flying_unit_damageMax^1.01 - flying_unit_damageMax)* 0.1) + 2
  flying_unit_goldMin = flying_unit_goldMin + flying_unit_goldMin/10
  flying_unit_damageMax = flying_unit_damageMax + flying_unit_goldMax/10

  boss_unit_hp = ((unit_hp+flying_unit_hp)/2*10)
  boss_unit_damageMin = ((unit_damageMin + flying_unit_damageMin)/2*3)
  boss_unit_damageMax = ((unit_damageMax + flying_unit_damageMax)/2 *3)
end

function GameMode:OnEntityKilled(keys)
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	if killedUnit:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		zombie_counter = zombie_counter - 1
  	-- body
  	end
  	DebugPrint( '[BAREBONES] OnEntityKilled Called' )
  DebugPrintTable( keys )
  

  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil

  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  -- Put code here to handle when an entity gets killed
  local bAnyHeroesAlive = false
  local Heroes = HeroList:GetAllHeroes()
	for _,Hero in pairs ( Heroes ) do
		if Hero ~= nil and Hero:HasOwnerAbandoned() == false and Hero:IsRealHero() and Hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS and Hero:IsAlive() then
			bAnyHeroesAlive = true
		end
	end

	if bAnyHeroesAlive == false then
		GameRules:MakeTeamLose( DOTA_TEAM_GOODGUYS )
	end


  local attackerUnit = EntIndexToHScript( keys.entindex_attacker or -1 )
  local killedUnit = EntIndexToHScript( keys.entindex_killed )

  if killedUnit and killedUnit:IsRealHero() and ( killedUnit:GetTeamNumber() == DOTA_TEAM_GOODGUYS ) then
      self:OnEntityKilled_PlayerHero( keys )
    return
  end
end

function GameMode:OnEntityKilled_PlayerHero( keys )
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  local attackerUnit = EntIndexToHScript( keys.entindex_attacker )

  local newItem = CreateItem( "item_tombstone", killedUnit, killedUnit )
  newItem:SetPurchaseTime( 0 )
  newItem:SetPurchaser( killedUnit )
  local tombstone = SpawnEntityFromTableSynchronous( "dota_item_tombstone_drop", {} )
  tombstone:SetContainedItem( newItem )
  tombstone:SetAngles( 0, RandomFloat( 0, 360 ), 0 )
  FindClearSpaceForUnit( tombstone, killedUnit:GetAbsOrigin(), true ) 
end
-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  DebugPrint('[BAREBONES] Starting to load Barebones gamemode...')
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  DebugPrint('[BAREBONES] Done loading Barebones gamemode!\n\n')
end