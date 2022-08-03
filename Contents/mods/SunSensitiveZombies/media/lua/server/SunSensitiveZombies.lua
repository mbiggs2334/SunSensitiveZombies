--Makes the zombie update every 3 second (if needed)
local updateInterval = 300;

local currentSandboxSettings = {};

local alteringLoreEnabled;

local function grabCurrentSandboxOptions()
	currentSandboxSettings["speed"] = getSandboxOptions():getOptionByName("ZombieLore.Speed"):getValue();
	if alteringLoreEnabled then
		currentSandboxSettings["toughness"] = getSandboxOptions():getOptionByName("ZombieLore.Toughness"):getValue();
		currentSandboxSettings["strength"] = getSandboxOptions():getOptionByName("ZombieLore.Strength"):getValue();
		currentSandboxSettings["hearing"] = getSandboxOptions():getOptionByName("ZombieLore.Hearing"):getValue();
		currentSandboxSettings["sight"] = getSandboxOptions():getOptionByName("ZombieLore.Sight"):getValue();
		currentSandboxSettings["memory"] = getSandboxOptions():getOptionByName("ZombieLore.Memory"):getValue();
		currentSandboxSettings["cognition"] = getSandboxOptions():getOptionByName("ZombieLore.Cognition"):getValue();
	end
	
end

local function compareZombieLoreSettings(zombie)
	local zombieIsUpToDate = true;
	
	if zombie.Speed ~= currentSandboxSettings.speed
	then
		zombieIsUpToDate = false;
	end

	if alteringLoreEnabled and zombie.Toughness ~= currentSandboxSettings.toughness
	or zombie.Strength ~= currentSandboxSettings.strength or zombie.Hearing ~= currentSandboxSettings.hearing
	or zombie.Sight ~= currentSandboxSettings.sight or zombie.Memory ~= currentSandboxSettings.memory
	or zombie.Cognition ~= currentSandboxSettings.cognition
	then
		zombieIsUpToDate = false;
	end

	return zombieIsUpToDate;
end

local function changeZombieLoreSettings(zombie)
	zombie.Speed = currentSandboxSettings.speed;
	if alteringLoreEnabled then
		zombie.Toughness = currentSandboxSettings.toughness;
		zombie.Strength = currentSandboxSettings.strength;
		zombie.Hearing = currentSandboxSettings.hearing;
		zombie.Sight = currentSandboxSettings.sight;
		zombie.Memory = currentSandboxSettings.memory;
		zombie.Cognition = currentSandboxSettings.cognition;
	end
end

--Changes the zombie's speed based off it's current speed and the speed lore value in the sandbox
local function ZombieChange(zombie)
	local zMod = zombie:getModData();
	zMod.Ticks = zMod.Ticks or 0;
	zMod.Speed = zMod.Speed or -1;
	local zombieLoreAccurate = compareZombieLoreSettings(zombie);
	-- is update needed?             if so is it single player?             -- or maybe it's a client with zombie ownership within range
	if not zombieLoreAccurate and zMod.Ticks >= updateInterval
	and ((not isClient() and not isServer()) or (isClient() and not zombie:isRemoteZombie())) then
		zombie:makeInactive(true);
		zombie:makeInactive(false);
		changeZombieLoreSettings(zMod);
		zMod.Ticks = 0;
	else
		zMod.Ticks = zMod.Ticks + 1;
	end
end

-- function NSdisable()
-- 	Events.OnZombieUpdate.Remove(ZombieChange);
-- end

-- function NSenable()
-- 	Events.OnZombieUpdate.Add(ZombieChange);
-- end

local function gameStart()
	-- if not BLTRandomZombies then
		alteringLoreEnabled = getSandboxOptions():getOptionByName("SunSensitiveZombies.enhancedZombies"):getValue();
		grabCurrentSandboxOptions();
		Events.OnZombieUpdate.Add(ZombieChange);
		Events.EveryTenMinutes.Add(grabCurrentSandboxOptions);
	-- end
end

Events.OnGameStart.Add(gameStart);

