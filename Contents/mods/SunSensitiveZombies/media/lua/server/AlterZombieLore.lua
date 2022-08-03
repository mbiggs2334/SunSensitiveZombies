--Booleans
local dayTime;
local alteringLoreEnabled;

--The sun strength cutoff for when the zombie state changes
local sunStrengthCutoff;

--Stores the settings from the sandbox selections
DayZombieSettingsCollection = {};
NightZombieSettingsCollection = {};

--Changes the settings when the state switches
local function switchSettings(settings)
	getSandboxOptions():set("ZombieLore.Speed", settings.speed);
	if alteringLoreEnabled then
		getSandboxOptions():set("ZombieLore.Strength", settings.strength);
		getSandboxOptions():set("ZombieLore.Toughness", settings.toughness);
		getSandboxOptions():set("ZombieLore.Sight", settings.sight);
		getSandboxOptions():set("ZombieLore.Hearing", settings.hearing);
		getSandboxOptions():set("ZombieLore.Cognition", settings.cognition);
		getSandboxOptions():set("ZombieLore.Memory", settings.memory);
	end
	getSandboxOptions():toLua();
end

--Handles any compatibility that needs to be added, at the moment, only RandomZombies is implemented
-- local function handleCompatibility(newState)
-- 	if BLTRandomZombies then
-- 		if newState and BLTRandomZombies.disable then
--   			BLTRandomZombies.disable();
-- 			NSenable();
-- 			print("RANDOM DISABLED - NS ENABLED")
-- 		elseif not newState and BLTRandomZombies.enable then
-- 			BLTRandomZombies.enable();
-- 			NSdisable();
-- 			print("RANDOM ENABLED - NS DISABLED")
-- 		end
-- 	end
-- end

--This method is crucial as it is in charge of changing the lore based on the sun strength cutoff
--Called on: Everything
local function changeLore()
	local sunStrength = getClimateManager():getDayLightStrength();
    if sunStrength <= sunStrengthCutoff and dayTime then
		--switches to night time settings
		dayTime = false
		switchSettings(NightZombieSettingsCollection);
    elseif sunStrength >= sunStrengthCutoff and not dayTime then
		--switches to day time settings
		dayTime = true;
		switchSettings(DayZombieSettingsCollection);
    end
end

--Grabs and stores the currently selected Sun Sensitive Zombies from sandbox settings
local function collectSettings()
	DayZombieSettingsCollection["speed"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombies"):getValue();
	NightZombieSettingsCollection["speed"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombies"):getValue();
	if alteringLoreEnabled then
		DayZombieSettingsCollection["strength"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesStrength"):getValue();
		DayZombieSettingsCollection["toughness"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesToughness"):getValue();
		DayZombieSettingsCollection["hearing"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesHearing"):getValue();
		DayZombieSettingsCollection["sight"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesSight"):getValue();
		DayZombieSettingsCollection["cognition"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesCognition"):getValue();
		DayZombieSettingsCollection["memory"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.dayZombiesMemory"):getValue();

		NightZombieSettingsCollection["strength"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesStrength"):getValue();
		NightZombieSettingsCollection["toughness"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesToughness"):getValue();
		NightZombieSettingsCollection["hearing"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesHearing"):getValue();
		NightZombieSettingsCollection["sight"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesSight"):getValue();
		NightZombieSettingsCollection["cognition"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesCognition"):getValue();
		NightZombieSettingsCollection["memory"] = getSandboxOptions():getOptionByName("SunSensitiveZombies.nightZombiesMemory"):getValue();
	end
end

local function handleEvents()
	sunStrengthCutoff = getSandboxOptions():getOptionByName("SunSensitiveZombies.sunStrengthCutoff"):getValue();
	alteringLoreEnabled = getSandboxOptions():getOptionByName("SunSensitiveZombies.enhancedZombies"):getValue();
	collectSettings();
	if getClimateManager():getDayLightStrength() >= sunStrengthCutoff then
        dayTime = true;
		switchSettings(DayZombieSettingsCollection);
    else
        dayTime = false;
		switchSettings(DayZombieSettingsCollection);
    end
    Events.EveryOneMinute.Add(changeLore);
	-- if BLTRandomZombies then
	-- 	BLTRandomZombies.disable();
	-- 	NSdisable();
	-- end
end


Events.OnGameStart.Add(handleEvents);
Events.OnServerStarted.Add(handleEvents);