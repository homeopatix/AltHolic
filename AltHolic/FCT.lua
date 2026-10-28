------------------------------------------------------------------------------------------
-- FCT file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Initialize datas
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Set the stratinf datas of the windows to false
------------------------------------------------------------------------------------------
function InitWindowsDatas()
	local function ResetVisibilityFlag(group, field)
		if settings[group] ~= nil then
			settings[group][field] = false;
		end
	end

	AltHolicInfosWindow:SetVisible(false);

	settings["sessionCash"]["cashSession"] = 0;
	settings["sessionCash"]["cashSpent"] = 0;

	-- Windows are recreated lazily after login, so persisted visibility from the
	-- previous session must not imply that a not-yet-created control is visible.
	ResetVisibilityFlag("isWindowVisible", "isWindowVisible");
	ResetVisibilityFlag("isShowBagVisible", "isShowBagVisible");
	ResetVisibilityFlag("isShowVaultVisible", "isShowVaultVisible");
	ResetVisibilityFlag("isShowSharedStorageVisible", "isShowSharedStorageVisible");
	ResetVisibilityFlag("isShowEquipmentVisible", "isShowEquipmentVisible");
	ResetVisibilityFlag("isShowWalletVisible", "isShowWalletVisible");
	ResetVisibilityFlag("isShowStatsVisible", "isShowStatsVisible");
	ResetVisibilityFlag("isSearchWindowVisible", "isSearchWindowVisible");
	ResetVisibilityFlag("isLvlEquipWindowVisible", "isLvlEquipWindowVisible");
	ResetVisibilityFlag("isEpiqueWindowVisible", "isEpiqueWindowVisible");
	ResetVisibilityFlag("isReputWindowVisible", "isReputWindowVisible");
	ResetVisibilityFlag("isOptionsWindowVisible", "isOptionsWindowVisible");
	ResetVisibilityFlag("isOptionsWindowBarVisible", "isOptionsWindowBarVisible");
	ResetVisibilityFlag("isServerWindowVisible", "value");
	ResetVisibilityFlag("isXPWindowVisible", "value");
	ResetVisibilityFlag("isGenderWindowVisible", "value");
	ResetVisibilityFlag("isHelpWindowVisible", "value");
	ResetVisibilityFlag("isInfoWindowVisible", "value");
	ResetVisibilityFlag("isLotroWindowVisible", "value");
	ResetVisibilityFlag("isToBeSurWindowVisible", "value");

	settings["nameAccount"]["account1"]["isVisible"] = false;
	-- "/alt icon" hides the launcher for the current session only.
	settings["isLauncherVisible"]["value"] = true;
end
------------------------------------------------------------------------------------------
-- Create and handle the minimized icons
------------------------------------------------------------------------------------------
-- Texture and pixel size for the launcher. The legacy setting value 64 means "standard
-- icon", which is a 32x32 control (a 64x64 control tiles the 32x32 artwork 2x2).
local LAUNCHER_TINY_IMAGES = { [32] = "TinyIcon", [24] = "TinyIcon24", [16] = "TinyIcon16" };

function ResolveLauncherIcon()
	if settings["isMinimizeEnabled"]["isMinimizeEnabled"] == true then
		local size = tonumber(settings["iconSize"]["value"]);
		local imageKey = LAUNCHER_TINY_IMAGES[size];
		if imageKey ~= nil then return Images[imageKey], size; end
	end
	return Images.MinimizedIcon, 32;
end

function MiniMizedIconHandler()
	-- AltHolic has ONE floating launcher; changing the icon size reconfigures it in place.
	local image, size = ResolveLauncherIcon();
	MainMinimizedIcon = MinimizedIcon(image, size, size, nil);
	MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainMinimizedIcon:SetVisible(true);

	MainMinimizedIcon.PositionChanged = function(sender, args)
		settings["IconPosition"]["xPosIcon"] = sender:GetLeft();
		settings["IconPosition"]["yPosIcon"] = sender:GetTop();
		-- Do not write settings on every drag pixel.  Normal plugin/options save
		-- persists the final location.
	end
end
------------------------------------------------------------------------------------------
-- create or load the settings for player professions
------------------------------------------------------------------------------------------
local ProfessionIconFiles = {
	forester      = "Prof_Forester.tga",
	woodsman      = "Prof_Forester.tga",
	prospector    = "Prof_Prospector.tga",
	weaponsmith   = "Prof_Armorer.tga",
	weaponcrafter = "Prof_Armorer.tga",
	armourer      = "Prof_Armorer.tga",
	armorer       = "Prof_Armorer.tga",
	cook          = "Prof_Cook.tga",
	farmer        = "Prof_Farmer.tga",
	scholar       = "Prof_Historian.tga",
	historian     = "Prof_Historian.tga",
	jeweller      = "Prof_Jeweller.tga",
	jeweler       = "Prof_Jeweller.tga",
	metalsmith    = "Prof_MetalSmith.tga",
	tailor        = "Prof_Taillor.tga",
	taillor       = "Prof_Taillor.tga",
	woodworker    = "Prof_Woodsman.tga",
	carpenter     = "Prof_Woodsman.tga"
};

local function NormalizeProfessionToken(value)
	if value == nil then return "" end
	local token = string.lower(tostring(value));
	token = string.gsub(token, "%s+", "");
	token = string.gsub(token, "%-", "");
	token = string.gsub(token, "_", "");
	return token;
end

------------------------------------------------------------------------------------------
-- The live character's profession data used to be rescanned and written to disk
-- once per character row AND once per crafting popup, i.e. ~20 disk writes every
-- time the main window was built. Scan once per window build instead.
------------------------------------------------------------------------------------------
local CurrentProfessionsAreFresh = false;

function InvalidateCurrentPlayerProfessions()
	CurrentProfessionsAreFresh = false;
end

function RefreshCurrentPlayerProfessions(playerName, force)
	if playerName ~= nil and playerName ~= PlayerName then return; end
	if CurrentProfessionsAreFresh == true and force ~= true then return; end
	if PlayerAttr == nil then return; end

	local professions = GetDataForProfessions();
	SavePlayerProfessions(professions);
	CurrentProfessionsAreFresh = true;
end

------------------------------------------------------------------------------------------
-- Return the best matching icon for a profession.
-- AltHolic stores individual professions instead of deriving them from a vocation.
-- professionKey is preferred because GetName() is localized by the game client.
------------------------------------------------------------------------------------------
function GetProfessionIconFile(professionKey, professionName)
	local token = NormalizeProfessionToken(professionKey);
	if token == "" then token = NormalizeProfessionToken(professionName); end

	-- Keyed on the Turbine.Gameplay.Profession enum names, plus the localized
	-- GetName() spellings and the common alternates, so an unexpected spelling
	-- still lands on the right artwork instead of an empty slot.

	local iconFile = ProfessionIconFiles[token];
	if iconFile ~= nil then return iconFile; end

	-- Last resort: substring match, so e.g. a suffixed or prefixed enum name
	-- ("ProfessionCook") still resolves rather than vanishing from the row.
	if token ~= "" then
		for key, file in pairs(ProfessionIconFiles) do
			if string.find(token, key, 1, true) ~= nil then return file; end
		end
	end

	return nil;
end

------------------------------------------------------------------------------------------
-- Return the proven full-size profession artwork for compact displays.
-- The row renderer applies StretchMode(1), which is required for these file textures
-- inside the scrolling character-list viewport.
------------------------------------------------------------------------------------------
function GetProfessionSmallIconFile(professionKey, professionName)
	-- Return the 32x32 artwork. The only background configuration that renders
	-- reliably in this plugin is a control whose size EQUALS the texture's size:
	-- the crafting popup draws these same files in 32x32 labels, and Help.tga is
	-- 20x20 in a 20x20 label. A texture larger than its control is not drawn, and
	-- forcing it with a stretch mode draws it at native size, overflowing.
	return GetProfessionIconFile(professionKey, professionName);
end

------------------------------------------------------------------------------------------
-- Convert old or new saved profession data to one predictable list.
-- This keeps existing AltHolic saves usable while the new format is populated naturally.
------------------------------------------------------------------------------------------
function GetSavedProfessions(playerName)
	local result = {};
	if PlayerProfessions == nil or PlayerProfessions[playerName] == nil then
		return result;
	end

	local saved = PlayerProfessions[playerName];

	if saved.Professions ~= nil and #saved.Professions > 0 then
		for _, profession in ipairs(saved.Professions) do
			table.insert(result, profession);
		end
		return result;
	end

	-- Legacy v4.52 format.
	if saved.Name ~= nil then
		for index, name in ipairs(saved.Name) do
			table.insert(result, {
					Name = name,
					CurrentLvl = saved.CurrentLvl and saved.CurrentLvl[index] or nil,
					CurrentMastery = saved.currentMastery and saved.currentMastery[index] or nil
				});
		end
	end

	return result;
end

------------------------------------------------------------------------------------------
-- Read the currently logged-in character's individual crafting professions.
-- We deliberately do not infer these from the vocation: the profession API is the
-- authoritative source and also supports characters whose profession set changes.
------------------------------------------------------------------------------------------
local professionTierNames = nil;

local function GetProfessionTierNames()
	if professionTierNames == nil then
		professionTierNames = {};
		for index = 1, TierMax do
			professionTierNames[index] = T["PluginProfTier" .. index];
		end
	end
	return professionTierNames;
end

function GetDataForProfessions()
	local tier = GetProfessionTierNames();

	local discovered = {};
	for professionKey, professionEnum in pairs(Turbine.Gameplay.Profession) do
		local professionInfo = PlayerAttr:GetProfessionInfo(professionEnum);
		if professionInfo ~= nil then
			discovered[#discovered + 1] = {
				Key = tostring(professionKey),
				Name = tostring(professionInfo:GetName()),
				ProficiencyLevel = professionInfo:GetProficiencyLevel(),
				MasteryLevel = professionInfo:GetMasteryLevel(),
				ProficiencyExp = professionInfo:GetProficiencyExperience(),
				ProficiencyExpTarget = professionInfo:GetProficiencyExperienceTarget(),
				MasteryExp = professionInfo:GetMasteryExperience(),
				MasteryExpTarget = professionInfo:GetMasteryExperienceTarget()
			};
		end
	end

	-- pairs() does not guarantee order. A stable order prevents icons from jumping around.
	table.sort(discovered, function(a, b)
			return string.lower(a.Name) < string.lower(b.Name);
		end);

	local function BuildProgressText(level, exp, expTarget)
		level = tonumber(level) or 0;
		exp = tonumber(exp) or 0;
		expTarget = tonumber(expTarget) or 0;

		if level < #tier then
			local nextTier = level + 1;
			return "T" .. tostring(nextTier) .. " - " .. tostring(tier[nextTier] or "") .. " : " ..
			tostring(exp) .. " / " .. tostring(expTarget);
		end

		local tierName = tier[level] or "";
		local separator = tierName ~= "" and " - " or "";
		return "T" .. tostring(level) .. separator .. tostring(tierName) ..
		"\n        " .. T[ "PluginProfTier21" ];
	end

	for _, profession in ipairs(discovered) do
		profession.CurrentLvl = BuildProgressText(
			profession.ProficiencyLevel,
			profession.ProficiencyExp,
			profession.ProficiencyExpTarget
		);
		profession.CurrentMastery = BuildProgressText(
			profession.MasteryLevel,
			profession.MasteryExp,
			profession.MasteryExpTarget
		);
		profession.Icon = GetProfessionIconFile(profession.Key, profession.Name);
	end

	return discovered;
end
------------------------------------------------------------------------------------------
-- Birthday easter egg: Tolkien (22 September) and the original author (23 May).
------------------------------------------------------------------------------------------
local BIRTHDAYS = { [5] = 23, [9] = 22 };

function Birthday()
	local date = Turbine.Engine.GetDate();
	if BIRTHDAYS[date.Month] == date.Day then
		DisplayBirthday(date.Day, date.Month, date.Year);
	end
end
------------------------------------------------------------------------------------------
-- Text colour for a rating that is capped (1), or still capped after T1/T2/T3 penetration.
------------------------------------------------------------------------------------------
local CAPPED_COLORS = {
	[1] = Turbine.UI.Color(1, 1, 0),   -- yellow
	[2] = Turbine.UI.Color(1, 0.7, 0), -- orange
	[3] = Turbine.UI.Color.Red,
	[4] = Turbine.UI.Color(1, 0, 1),   -- purple
};

function SetTheTextColorForCapped(capped, whichOne)
	if CAPPED_COLORS[capped] ~= nil then whichOne:SetForeColor(CAPPED_COLORS[capped]); end
end
------------------------------------------------------------------------------------------
-- Position (1-based) of the character's server in ServerNames, or 0.
------------------------------------------------------------------------------------------
function ReturnValueServer(playerToSearch)
	local serverName = PlayerDatas[playerToSearch] and PlayerDatas[playerToSearch].serverName;
	for index, name in ipairs(ServerNames) do
		if name == serverName then return index; end
	end
	return 0;
end
------------------------------------------------------------------------------------------
-- display the list of command
------------------------------------------------------------------------------------------
function commandsHelp()
	notification(
		rgb["start"] ..
		T[ "PluginHelp1" ] ..
		rgb["clear"] ..
		T[ "PluginHelp2" ] ..
		T[ "PluginHelp3" ] ..
		T[ "PluginHelp4" ] ..
		T[ "PluginHelp5" ] ..
		T[ "PluginHelp6" ] ..
		T[ "PluginHelp7" ] ..
		T[ "PluginHelp8" ] ..
		T[ "PluginHelp9" ] ..
		T[ "PluginHelp10" ] ..
		T[ "PluginHelp11" ] ..
		T[ "PluginHelp12" ]
	);
end
------------------------------------------------------------------------------------------
-- function to update the lvl of the player --
------------------------------------------------------------------------------------------
function UpdateLvl()
	local playerData = PlayerDatas[PlayerName];
	local currentLevel = tonumber(Player:GetLevel()) or 1;
	local savedLevel = tonumber(playerData.lvl) or 0;

	if settings["nameAccount"]["account1"]["nbrAlt"] >= 1 and savedLevel < currentLevel then
		-- (This used to also collapse the character list on every level-up.)
		SavePlayerDatas();
		UpdateMainWindow();
		UpdateBar();
	end
end
------------------------------------------------------------------------------------------
-- Coin-bag valuation helpers
------------------------------------------------------------------------------------------
local COIN_BAG_VALUES = {
	[Turbine.Language.English] = {
		["Bag of Gold Coins"] = 1000000,
		["Bag of Silver Coins"] = 100000,
		["Bag of Copper Coins"] = 10000,
	},
	[Turbine.Language.French] = {
		["Sac de pi\195\168ces d'or"] = 1000000,
		["Sac de pi\195\168ces d'argent"] = 100000,
		["Sac de pi\195\168ces de cuivre"] = 10000,
	},
	[Turbine.Language.German] = {
		["Beutel mit Goldm\195\188nzen"] = 1000000,
		["Beutel mit Silberm\195\188nzen"] = 100000,
		["Beutel mit Kupferm\195\188nzen"] = 10000,
	},
};

local function GetCoinBagUnitValue(itemName)
	local languageValues = COIN_BAG_VALUES[Turbine.Engine.GetLanguage()] or COIN_BAG_VALUES[Turbine.Language.English];
	return languageValues[itemName] or 0;
end

local function SumCoinBagContainer(itemCount, getItem)
	local total = 0;
	for index = 1, itemCount do
		local item = getItem(index);
		if item ~= nil then
			total = total + (GetCoinBagUnitValue(item:GetName()) * (item:GetQuantity() or 0));
		end
	end
	return total;
end

function CalculateSharedStorageCoinValue()
	return SumCoinBagContainer(sspack:GetCount(), function(index)
			return sspack:GetItem(index);
		end);
end

function CalculateBagCoinValue()
	return SumCoinBagContainer(backpack:GetSize(), function(index)
			return backpack:GetItem(index);
		end);
end

function CalculateVaultCoinValue()
	return SumCoinBagContainer(vaultpack:GetCount(), function(index)
			return vaultpack:GetItem(index);
		end);
end
------------------------------------------------------------------------------------------
-- Track wallet changes (session / daily won and spent) and shared-storage coin bags.
------------------------------------------------------------------------------------------
function UpdateCash()
	local playerData = PlayerDatas[PlayerName];
	local currentCash = PlayerAttr:GetMoney();
	local changed = false;

	local sharedStorageCash = CalculateSharedStorageCoinValue();
	if settings["sharedStorageCash"]["value"] ~= sharedStorageCash then
		settings["sharedStorageCash"]["value"] = sharedStorageCash;
		changed = true;
	end

	if playerData.cash == nil then playerData.cash = currentCash; end

	if settings["nameAccount"]["account1"]["nbrAlt"] >= 1 and playerData.cash ~= currentCash then
		local difference = currentCash - playerData.cash;
		if difference > 0 then
			settings["sessionCash"]["cashSession"] = settings["sessionCash"]["cashSession"] + difference;
			settings["dailyCash"]["cashDaily"] = settings["dailyCash"]["cashDaily"] + difference;
		else
			settings["sessionCash"]["cashSpent"] = settings["sessionCash"]["cashSpent"] - difference;
			settings["dailyCash"]["cashSpent"] = settings["dailyCash"]["cashSpent"] - difference;
		end
		playerData.cash = currentCash;
		SavePlayerDatas();
		changed = true;
	end

	if changed then
		UpdateMainWindow();
		UpdateBar();
	end
end
------------------------------------------------------------------------------------------
-- Delete characters. Only the deleted characters' records are removed; nothing is
-- re-scanned from the live game, so the logged-in character's saved vault and shared
-- storage can no longer be wiped as a side effect.
------------------------------------------------------------------------------------------
local function RecountCharacters()
	settings["nameAccount"]["account1"]["nbrAlt"] = tablelength(PlayerDatas);
end

function ClearAllPlayer()
	local names = {};
	for name in pairs(PlayerDatas) do
		if name ~= PlayerName then names[#names + 1] = name; end
	end
	DeleteCharacterData(names);

	-- "Delete all" also resets the shared storage snapshot and the account name.
	SharedStorageVault = {};
	PatchDataSave(dataScope, settingsSharedStorageFileName, SharedStorageVault);

	settings["nameAccount"]["account1"]["nbrAlt"] = 0;
	settings["nameAccount"]["account1"]["name"] = "";
	settings["nameAccount"]["account1"]["isVisible"] = true;
	UpdateMainWindow();
end

function ClearPlayer(NamePlayerToDelete)
	if NamePlayerToDelete == nil or PlayerDatas[NamePlayerToDelete] == nil then return; end
	DeleteCharacterData({ NamePlayerToDelete });

	-- Deleting the logged-in character simply re-creates its record from live data.
	if NamePlayerToDelete == PlayerName then
		LoadPlayerEquipment();
		LoadPlayerEpique();
		LoadPlayerReputations();
		LoadPlayerInfos();
		LoadPlayerProfessions();
		SavePlayerDatas();
		SavePlayerBags();
		SavePlayerWallet();
		if Player:GetAlignment() == 1 then SavePlayerEquipment(); end
		if vaultHasBeenUpdated == true then SavePlayerVault(); end
		RefreshCurrentPlayerProfessions(PlayerName, true);
	end

	RecountCharacters();
	UpdateMainWindow();
end
------------------------------------------------------------------------------------------
-- function to return nbrItems, nbrplayer, nbrlines for bag --
------------------------------------------------------------------------------------------
local function CountCharacterStorageMatches(storage, textToSearch)
	local totalItems = 0;
	local totalCharacters = 0;
	local totalIconRows = 0;

	if storage == nil then return 0, 0, 0; end

	for _, items in pairs(storage) do
		local characterItems = 0;
		if type(items) == "table" then
			for _, item in pairs(items) do
				if item ~= nil and AltHolicUtil.MatchesSearch(item.N, textToSearch) then
					totalItems = totalItems + 1;
					characterItems = characterItems + 1;
				end
			end
		end

		if characterItems > 0 then
			totalCharacters = totalCharacters + 1;
			totalIconRows = totalIconRows + math.ceil(characterItems / 9);
		end
	end

	return totalItems, totalCharacters, totalIconRows;
end

local function CountSharedStorageMatches(textToSearch)
	local totalItems = 0;
	if SharedStorageVault == nil then return 0, 0, 0; end

	for _, item in pairs(SharedStorageVault) do
		if item ~= nil and AltHolicUtil.MatchesSearch(item.N, textToSearch) then
			totalItems = totalItems + 1;
		end
	end

	return totalItems, 0, math.ceil(totalItems / 9);
end

------------------------------------------------------------------------------------------
-- Search result counters. Bag, vault and wallet share the same character->item schema.
------------------------------------------------------------------------------------------
function ReturnNbrItemsInBag(textToSearch)
	return CountCharacterStorageMatches(PlayerBags, textToSearch);
end

function ReturnNbrItemsInVault(textToSearch)
	return CountCharacterStorageMatches(PlayerVault, textToSearch);
end

function ReturnNbrItemsInWallet(textToSearch)
	return CountCharacterStorageMatches(PlayerWallet, textToSearch);
end

function ReturnNbrItemsInSharedStorage(textToSearch)
	return CountSharedStorageMatches(textToSearch);
end

------------------------------------------------------------------------------------------
-- Reputation tracking from chat
------------------------------------------------------------------------------------------
-- Reputation needed per rank. The reputation window reads the same tables.
local REPUTATION_VALUE_MAX = {20000,10000,0,10000,30000,55000,85000,130000,190000,280000,480000};
local REPUTATION_VALUE_DEFAULT = {10000,10000,0,10000,20000,25000,30000,45000,60000,90000,200000};
local REPUTATION_VALUE_LEVELS = {
	[64] = {10000,20000,25000,30000},
	[69] = {10000,20000,20000,1},
	[70] = {10000,15000,20000,20000,20000,20000,30000,1},
	[71] = {4000,6000,8000,10000,12000,14000,16000,18000,20000,1},
	[79] = {0,10000,20000,25000,30000,45000},
	[100] = {1500,4500,9000,13500,18000},
	[102] = {15000,20000,20000,20000,20000,30000,1},
	[106] = {0,2500,5000,7500,10000,15000}
};

local function GetReputationLevelTable(index)
	if(index >= 21 and index <= 27)then return REPUTATION_VALUE_MAX; end
	return REPUTATION_VALUE_LEVELS[index] or REPUTATION_VALUE_DEFAULT;
end

-- Thresholds used by the reputation window's progress bars. Note: the window has always
-- used the standard table for the crafting guilds (21-27), unlike the chat updater.
function GetReputationDisplayThresholds(index)
	return REPUTATION_VALUE_LEVELS[index] or REPUTATION_VALUE_DEFAULT;
end

-- Starting rank assumed for a faction the player has not set up yet (saved position 0).
local function StartingReputationPosition(index, position)
	if position ~= 0 then return position; end
	if index == 77 or index == 9 or index == 91 then return 1; end
	if index == 70 then return 3; end
	if index == 79 or index == 64 or index == 71 then return 0; end
	return 2;
end

local function ReadReputation(index)
	local record = PlayerReput[PlayerName]["Reput" .. index];
	local position = StartingReputationPosition(index, tonumber(record.position) or 0);
	return record, position, tonumber(record.value) or 0;
end

local function StoreReputation(index, record, position, value)
	RepuPosition[index] = position;
	RepuName[index] = record.name;
	Reputations[index] = value;
	SavePlayerReputations(index);
end

function DecreaseReput(i, rpPTS)
	local thresholds = GetReputationLevelTable(i);
	local record, position, value = ReadReputation(i);

	value = value - rpPTS;
	if value < 0 then
		-- Dropped below the current rank: move down one rank (value = that rank's threshold).
		value = thresholds[position - 1] or 0;
		position = position - 1;
	end

	StoreReputation(i, record, position, value);
end
------------------------------------------------------------------------------------------
-- function reputations updater --
------------------------------------------------------------------------------------------
function UpdateReput(i, rpPTS, rpBonus)
	local thresholds = GetReputationLevelTable(i);
	local record, position, value = ReadReputation(i);
	local genre = GetReputationGenre(i);

	value = value + rpPTS;

	-- Lossoth (9) and Kharum-ubnar (91) only auto-advance from their starting rank.
	local nextThreshold;
	if i ~= 9 and i ~= 91 then
		nextThreshold = thresholds[position + 1];
	elseif position == 2 then
			nextThreshold = thresholds[position];
		end

		-- nextThreshold is nil at the top rank (or for a faction not set up in the window).
		if nextThreshold ~= nil and value >= nextThreshold then
			if position <= 1 then
				value = 0;
			else
				value = value - (thresholds[position + genre] or 0);
			end
			position = position + 1;
		end

		StoreReputation(i, record, position, value);
	end
	------------------------------------------------------------------------------------------
	-- function xp checker --
	------------------------------------------------------------------------------------------
	local CHAT_PATTERNS = {
		en = {
			xp = "You've earned ([%d%p]*)% XP for a total of",
			reputation = {
				normal = {
					name = "reputation with ([%a%p%u%l%s]*) has increased by",
					points = "has increased by ([%d%p]*)%.",
				},
				bonus = {
					name = "reputation with ([%a%p%u%l%s]*) has increased by",
					points = "has increased by ([%d%p]*) %(",
					amount = "%(([%d%p]*) from bonus",
					token = "bonus",
					suffix = "from bonus",
				},
				decrease = {
					name = "reputation with ([%a%p%u%l%s]*) has decreased by",
					points = "has decreased by ([%d%p]*)%.",
				},
			},
			lotroPoints = "You've earned ([%d%p]*)% LOTRO Points",
		},
		fr = {
			xp = "Vous avez gagn\195\169 ([%d%p]*)% points d'exp\195\169rience, soit un total de ",
			reputation = {
				normal = {
					name = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de",
					points = "a augment\195\169 de ([%d%p]*)%.",
				},
				bonus = {
					name = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de",
					points = "a augment\195\169 de ([%d%p]*) %(",
					amount = "%(([%d%p]*) du bonus",
					token = "bonus",
					suffix = "du bonus",
				},
				decrease = {
					name = "de la faction ([%a%p%u%l%s]*) a diminu\195\169 de",
					points = "a diminu\195\169 de ([%d%p]*)%.",
				},
			},
			lotroPoints = "Vous avez gagn\195\169 ([%d%p]*)% points SdAO.",
		},
		de = {
			xp = "Ihr habt ([%d%p]*) EP erhalten und verf\195\188gt jetzt insgesamt \195\188ber",
			reputation = {
				normal = {
					name = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um",
					points = "hat sich um ([%d%p]*) verbessert",
				},
				bonus = {
					name = "Euer Ruf bei der Gruppe \"([%a%p%u%l%s]*)\" wurde um",
					points = "wurde um ([%d%p]*) erh\195\182ht",
					amount = "%(([%d%p]*) durch Bonus",
					token = "Bonus",
					suffix = "von Bonus",
				},
				decrease = {
					name = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um",
					points = "hat sich um ([%d%p]*) verschlechtert",
				},
			},
			lotroPoints = "Ihr habt ([%d%p]*) Punkte erhalten.",
		},
	};

	local function ParseChatNumber(value)
		if value == nil then return nil; end
		value = string.gsub(tostring(value), ",", "");
		return tonumber(value);
	end

	local function FindFactionInMessage(message)
		if message == nil then return nil, nil; end
		for index = 1, nbrFactions do
			local name = T["reputname" .. index];
			if name ~= nil and name ~= "" and string.find(message, name, 1, true) ~= nil then
				return index, name;
			end
		end
		return nil, nil;
	end

	local function ParseReputationChange(message, isDecrease)
		local localePatterns = CHAT_PATTERNS[GLocale];
		if message == nil or localePatterns == nil then return nil; end

		local reputationPatterns = localePatterns.reputation;
		local pattern = nil;
		local bonus = nil;

		if isDecrease then
			pattern = reputationPatterns.decrease;
		else
			local bonusPattern = reputationPatterns.bonus;
			if bonusPattern ~= nil and string.find(message, bonusPattern.token, 1, true) ~= nil then
				pattern = bonusPattern;
				bonus = ParseChatNumber(string.match(message, bonusPattern.amount));
			else
				pattern = reputationPatterns.normal;
			end
		end

		if pattern == nil then return nil; end

		-- Cheap pattern check first: this runs for every chat line, and the 112-faction name
		-- scan below only needs to happen for actual reputation messages.
		local points = ParseChatNumber(string.match(message, pattern.points));
		if points == nil then return nil; end

		local factionIndex, knownName = FindFactionInMessage(message);
		if factionIndex == nil then return nil; end
		local name = knownName or string.match(message, pattern.name);

		return {
			index = factionIndex,
			name = name,
			points = points,
			bonus = bonus,
			bonusSuffix = reputationPatterns.bonus and reputationPatterns.bonus.suffix or nil,
		};
	end

	local function ShowReputationProgress(change, isDecrease)
		if settings["showProgressReput"]["value"] ~= true then return; end

		local sign = isDecrease and " - " or " + ";
		local amountColor = isDecrease and rgb["red"] or rgb["gold"];
		local message = rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " : " ..
		rgb["green"] .. tostring(change.name) .. rgb["clear"] .. sign ..
		amountColor .. tostring(string.format("%.0f", change.points)) .. rgb["clear"] .. " " .. T["reputText1"];

		if not isDecrease and change.bonus ~= nil then
			message = message .. " (" .. rgb["gold"] .. tostring(string.format("%.0f", change.bonus)) ..
			rgb["clear"] .. " " .. tostring(change.bonusSuffix or "bonus") .. ")";
		end

		Write(message);
	end

	local function HandleXPMessage(message)
		local localePatterns = CHAT_PATTERNS[GLocale];
		if message == nil or localePatterns == nil then return; end

		local points = ParseChatNumber(string.match(message, localePatterns.xp));
		if points == nil then return; end

		local playerData = PlayerDatas[PlayerName];
		local requirement = AltHolicUtil.GetLevelXPRequirement(playerData and playerData.lvl);
		if requirement == nil then return; end -- level cap: nothing to track

		local xp = (tonumber(PlayerXp[PlayerName]) or 0) + points;
		if xp >= requirement then xp = xp - requirement; end
		PlayerXp[PlayerName] = xp;
		playerData.xp = xp;

		-- Written by the 30-second maintenance tick / unload instead of once per kill.
		MarkPlayerDatasDirty();
	end

	local function HandleReputationMessage(message)
		local increase = ParseReputationChange(message, false);
		if increase ~= nil then
			ShowReputationProgress(increase, false);
			UpdateReput(increase.index, increase.points, increase.bonus);
		end

		local decrease = ParseReputationChange(message, true);
		if decrease ~= nil then
			ShowReputationProgress(decrease, true);
			DecreaseReput(decrease.index, decrease.points);
		end
	end

	local function HandleLotroPointsMessage(message)
		local localePatterns = CHAT_PATTERNS[GLocale];
		if message == nil or localePatterns == nil then return; end

		local points = ParseChatNumber(string.match(message, localePatterns.lotroPoints));
		if points == nil then return; end

		settings["lotroCoins"]["value"] = (tonumber(settings["lotroCoins"]["value"]) or 0) + points;
		if settings["showProgressLotro"]["value"] ~= true then return; end

		local suffix = (GLocale == "fr") and (" " .. T["reputText1"]) or "";
		Write(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " : " ..
			rgb["green"] .. T["reputText2"] .. " " .. rgb["clear"] ..
			rgb["gold"] .. tostring(points) .. rgb["clear"] .. suffix);
	end

	------------------------------------------------------------------------------------------
	-- Chat-driven XP, reputation and LOTRO Point updates.
	-- Parsing is centralized by locale instead of rebuilding the same pattern logic inline.
	------------------------------------------------------------------------------------------
	local chatHandlerInstalled = false;

	function UpdaterFromChat()
		if chatHandlerInstalled then return; end
		chatHandlerInstalled = true;

		Turbine.Chat.Received = function(sender, args)
			local message = args and args.Message or nil;
			if message == nil then return; end

			HandleXPMessage(message);
			HandleReputationMessage(message);
			HandleLotroPointsMessage(message);
		end
	end
