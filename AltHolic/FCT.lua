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
end
------------------------------------------------------------------------------------------
-- Create and handle the minimized icons
------------------------------------------------------------------------------------------
function MiniMizedIconHandler()
    -- AltHolic has ONE floating launcher icon.  Older code kept four separate
    -- windows around only to represent the four selectable icon sizes; the 4.69
    -- refactor accidentally instantiated all four at once.  Keep a single window
    -- and reconfigure it when the user changes icon size.
    local size = 32;
    local image = Images.MinimizedIcon;

    if settings["isMinimizeEnabled"]["isMinimizeEnabled"] == true then
        size = tonumber(settings["iconSize"]["value"]) or 32;
        if size == 16 then
            image = Images.TinyIcon16;
        elseif size == 24 then
            image = Images.TinyIcon24;
        elseif size == 32 then
            image = Images.TinyIcon;
        else
            -- Unsupported/stale values fall back to the normal launcher.
            size = 32;
            image = Images.MinimizedIcon;
        end
    end

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
function GetDataForProfessions()
    local tier = {
        T[ "PluginProfTier1" ], T[ "PluginProfTier2" ], T[ "PluginProfTier3" ],
        T[ "PluginProfTier4" ], T[ "PluginProfTier5" ], T[ "PluginProfTier6" ],
        T[ "PluginProfTier7" ], T[ "PluginProfTier8" ], T[ "PluginProfTier9" ],
        T[ "PluginProfTier10" ], T[ "PluginProfTier11" ], T[ "PluginProfTier12" ],
        T[ "PluginProfTier13" ], T[ "PluginProfTier14" ], T[ "PluginProfTier15" ]
    };

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
-- set the burthday button
------------------------------------------------------------------------------------------
function Birthday()
	local cDate = Turbine.Engine.GetDate();
	local cDay = cDate.Day;
	local cMonth = cDate.Month;
	local cYear = cDate.Year;

	-- debug
	--cDay = 23;
	--cMonth = 5;
	-----------

	if(cDay == 23 and cMonth == 5)then
		DisplayBirthday(cDay, cMonth, cYear);
	elseif(cDay == 22 and cMonth == 9)then
		DisplayBirthday(cDay, cMonth, cYear);
	end
end
------------------------------------------------------------------------------------------
-- set the text color for capped
------------------------------------------------------------------------------------------
function SetTheTextColorForCapped(capped, whichOne)
	if capped == 1 then
		whichOne:SetForeColor(Turbine.UI.Color( 1, 1, 0 )); -- yellow
	elseif capped == 2 then
		whichOne:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 )); -- orange
	elseif capped == 3 then
		whichOne:SetForeColor(Turbine.UI.Color.Red);
	elseif capped == 4 then
		whichOne:SetForeColor(Turbine.UI.Color( 1, 0, 1 )); -- purple
	end
end
------------------------------------------------------------------------------------------
--function that resize the main window depending on how many charcater are saved --
------------------------------------------------------------------------------------------
function ReturnNBCharactersOnServer(serverToLookFor)
	local nbChars = 0;
	for i in pairs(PlayerDatas) do
		if(PlayerDatas[i].serverName == serverToLookFor or serverToLookFor == T[ "ServerNamesAll" ])then
			nbChars = nbChars + 1;
		end
	end
	return nbChars;
end
------------------------------------------------------------------------------------------
-- Return the value of the servers --
------------------------------------------------------------------------------------------
function ReturnValueServer(playerToSearch)
	local serverValue = 0;

	for i in pairs(ServerNames) do
		if(ServerNames[i] == PlayerDatas[playerToSearch].serverName)then
			serverValue = i;
		end
	end
	return serverValue;
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
	local curentLvl = Player:GetLevel();
	
	if(PlayerDatas[PlayerName].lvl == nil or PlayerDatas[PlayerName].lvl == "")then
		PlayerDatas[PlayerName].lvl = 0;
	end
	if(curentLvl == nil or curentLvl == "")then
		curentLvl = 1;
	end
	
	if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
		if(PlayerDatas[PlayerName].lvl < curentLvl)then
			PlayerDatas[PlayerName].lvl = curentLvl;
			settings["nameAccount"]["account1"]["isVisible"] = false;
			UpdateMainWindow();
			UpdateBar();
			SavePlayerDatas();
		end
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
    return SumCoinBagContainer(vaultpack:GetCapacity(), function(index)
        return vaultpack:GetItem(index);
    end);
end
------------------------------------------------------------------------------------------
-- function to display the cash of the player --
------------------------------------------------------------------------------------------
function UpdateCash()
	local currentCash = PlayerAttr:GetMoney();
	local currentCashBag = tonumber(CalculateBagCoinValue());
	local currentCashVault = tonumber(CalculateVaultCoinValue());

	local sharedStorageCash = CalculateSharedStorageCoinValue();
	if(settings["sharedStorageCash"]["value"] ~= sharedStorageCash)then
		settings["sharedStorageCash"]["value"] = sharedStorageCash;
		UpdateMainWindow();
		UpdateBar();
	end

	--[[
	if(PlayerDatas[PlayerName].cash ~= currentCash)then
		PlayerDatas[PlayerName].cash = currentCash;
		UpdateMainWindow();
		UpdateBar();
	end

	if(PlayerDatas[PlayerName].bagCash ~= currentCashBag)then
		PlayerDatas[PlayerName].bagCash = currentCashBag;
		UpdateMainWindow();
		UpdateBar();
	end

	if(PlayerDatas[PlayerName].vaultCash ~= currentCashVault)then
		PlayerDatas[PlayerName].vaultCash = currentCashVault;
		UpdateMainWindow();
		UpdateBar();
	end
	]]--

	if (PlayerDatas[PlayerName].cash == nil) then
		PlayerDatas[PlayerName].cash = PlayerAttr:GetMoney();
	end

	if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
		if(PlayerDatas[PlayerName].cash < currentCash)then
			settings["sessionCash"]["cashSession"] = settings["sessionCash"]["cashSession"] + (currentCash - PlayerDatas[PlayerName].cash);
			settings["dailyCash"]["cashDaily"] = settings["dailyCash"]["cashDaily"] + (currentCash - PlayerDatas[PlayerName].cash);
			PlayerDatas[PlayerName].cash = currentCash;

			UpdateMainWindow();
			UpdateBar();
			SavePlayerDatas();
		elseif(PlayerDatas[PlayerName].cash > currentCash)then
			settings["sessionCash"]["cashSpent"] = settings["sessionCash"]["cashSpent"] + (PlayerDatas[PlayerName].cash - currentCash);
			settings["dailyCash"]["cashSpent"] = settings["dailyCash"]["cashSpent"] + (PlayerDatas[PlayerName].cash - currentCash);
			PlayerDatas[PlayerName].cash = currentCash;

			UpdateMainWindow();
			UpdateBar();
			SavePlayerDatas();
		end
	end
	--[[
	Write("----------------------------------------------");
	Write("curent cash : " .. tostring(currentCash));
	Write("bag cash : " .. tostring(CalculateBagCoinValue()));
	Write("vault cash : " .. tostring(CalculateVaultCoinValue()));
	Write("sharedstorage cash : " .. tostring(CalculateSharedStorageCoinValue()));
	Write("current cash total : " .. tostring((currentCash + currentCashBag + currentCashVault)));
	Write("Session cash : " .. tostring(settings["sessionCash"]["cashSession"]));
	Write("Spent cash : " .. tostring(settings["sessionCash"]["cashSpent"]));
	Write("player data cash : " .. tostring(PlayerDatas[PlayerName].cash));
	Write("current cash : " .. tostring(currentCash));
	]]--
end
------------------------------------------------------------------------------------------
-- function to delete all datas --
------------------------------------------------------------------------------------------
function ClearAllPlayer()
	for i in pairs(PlayerDatas) do
		if(i ~= PlayerName)then
			PlayerDatas[i] = nil;
			PlayerVault[i] = nil;
			PlayerBags[i] = nil;
			PlayerWallet[i] = nil;
			PlayerEquipement[i] = nil;
			settings["nameAccount"]["account1"]["nbrAlt"] = settings["nameAccount"]["account1"]["nbrAlt"] - 1;
		end
	end
	SavePlayerDatas();
	SavePlayerVault();
	SavePlayerBags();
	SavePlayerWallet();
	SavePlayerEquipment();
	SharedStorageVault = nil;
	SaveSharedStorage();
	settings["nameAccount"]["account1"]["nbrAlt"] = 0;
	settings["nameAccount"]["account1"]["name"] = "";
	settings["nameAccount"]["account1"]["isVisible"] = true;
	UpdateMainWindow();
end
------------------------------------------------------------------------------------------
-- function to delete a player datas --
------------------------------------------------------------------------------------------
function ClearPlayer(NamePlayerToDelete)
	PlayerDatas[NamePlayerToDelete] = nil;
	SavePlayerDatas();
	settings["nameAccount"]["account1"]["nbrAlt"] = settings["nameAccount"]["account1"]["nbrAlt"] - 1;
	ClearPlayerVault(NamePlayerToDelete);
	ClearPlayerBag(NamePlayerToDelete);
	ClearPlayerWallet(NamePlayerToDelete);
	ClearPlayerEquipment(NamePlayerToDelete);
	UpdateMainWindow();
end
------------------------------------------------------------------------------------------
-- function to delete a player vault --
------------------------------------------------------------------------------------------
function ClearPlayerVault(NamePlayerToDelete)
	PlayerVault[NamePlayerToDelete] = nil;
	SavePlayerVault();
end
------------------------------------------------------------------------------------------
-- function to delete a player bag --
------------------------------------------------------------------------------------------
function ClearPlayerBag(NamePlayerToDelete)
	PlayerBags[NamePlayerToDelete] = nil;
	SavePlayerBags();
end
------------------------------------------------------------------------------------------
-- function to delete a player wallet --
------------------------------------------------------------------------------------------
function ClearPlayerWallet(NamePlayerToDelete)
	PlayerWallet[NamePlayerToDelete] = nil;
	SavePlayerWallet();
end
------------------------------------------------------------------------------------------
-- function to delete a player equipment --
------------------------------------------------------------------------------------------
function ClearPlayerEquipment(NamePlayerToDelete)
	PlayerEquipement[NamePlayerToDelete] = nil;
	SavePlayerEquipment();
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
-- function reputations checker --
------------------------------------------------------------------------------------------

-- Legacy reputation-only chat parser removed; the active combined updater is below.

------------------------------------------------------------------------------------------
-- function decrese reputations updater --
------------------------------------------------------------------------------------------
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

function DecreaseReput(i, rpPTS)
	local reputationValueLevel = GetReputationLevelTable(i);

	local playerRepPosition = tonumber(PlayerReput[PlayerName]["Reput" .. i].position);
	local playerRepValue = PlayerReput[PlayerName]["Reput" .. i].value;
	local playerRepName = PlayerReput[PlayerName]["Reput" .. i].name;
	local playerRepGenre = PlayerReput[PlayerName]["Reput" .. i].genre;

	playerRepValue = playerRepValue - rpPTS;

	-- A few factions store their saved rank using a historical offset.
	if(i == 70)then
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 3;
		end
	elseif(i == 102)then
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 1;
		end
	end

	-- debug for starting the reputations
	if(i == 77 or i == 9 or i == 91)then
		if(playerRepPosition == 0)then 
			playerRepPosition = 1;
		end
	elseif(i == 70)then
		if(playerRepPosition == 0)then 
			playerRepPosition = 3;
		end
	else
		if(i == 79 or i == 64 or i == 71)then
			if(playerRepPosition == 0)then 
				playerRepPosition = 0;
			end
		else
			if(playerRepPosition == 0)then 
				playerRepPosition = 2;
			end
		end
	end

	local lvlValue = tonumber(playerRepPosition);
	local lvlNextRepPos = tonumber(playerRepPosition) - 1;

	if(playerRepValue < 0)then
		playerRepValue = reputationValueLevel[lvlNextRepPos];
		playerRepPosition = playerRepPosition - 1;
	end

	RepuPosition[i] = playerRepPosition;
	RepuName[i] = playerRepName;
	Reputations[i] = playerRepValue;

	SavePlayerReputations(i);
end
------------------------------------------------------------------------------------------
-- function reputations updater --
------------------------------------------------------------------------------------------
function UpdateReput(i, rpPTS, rpBonus)
	local reputationValueLevel = GetReputationLevelTable(i);

	local playerRepPosition = tonumber(PlayerReput[PlayerName]["Reput" .. i].position);
	local playerRepValue = PlayerReput[PlayerName]["Reput" .. i].value;
	local playerRepName = PlayerReput[PlayerName]["Reput" .. i].name;
	local playerRepGenre = PlayerReput[PlayerName]["Reput" .. i].genre;

	playerRepValue = playerRepValue + rpPTS;

	-- A few factions store their saved rank using a historical offset.
	if(i == 70)then
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 3;
		end
	elseif(i == 102)then
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 1;
		end
	end

	-- debug for starting the reputations
	if(i == 77 or i == 9 or i == 91)then
		if(playerRepPosition == 0)then 
			playerRepPosition = 1;
		end
	elseif(i == 70)then
		if(playerRepPosition == 0)then 
			playerRepPosition = 3;
		end
	else
		if(i == 79 or i == 64 or i == 71)then
			if(playerRepPosition == 0)then 
				playerRepPosition = 0;
			end
		else
			if(playerRepPosition == 0)then 
				playerRepPosition = 2;
			end
		end
	end

	local lvlValue = tonumber(playerRepPosition) + tonumber(playerRepGenre);
	local lvlNextRepPos = tonumber(playerRepPosition) + 1;
	local nextVal = nil;

	if(i ~= 9 and i ~= 91)then
		if(playerRepValue > reputationValueLevel[lvlNextRepPos] or playerRepValue == reputationValueLevel[lvlNextRepPos])then
			if(playerRepPosition <= 1)then
				playerRepValue = 0;
			else
				playerRepValue = playerRepValue - reputationValueLevel[lvlValue];
			end
			playerRepPosition = playerRepPosition + 1;
		end
	else
		if(playerRepPosition == 2)then
			nextVal = reputationValueLevel[playerRepPosition];
		end

		--Write("nextVal : " .. tostring(nextVal));
		--Write("playerRepPosition : " .. tostring(playerRepPosition));
		--Write("i : " .. tostring(i));
		--Write("playerRepValue : " .. tostring(playerRepValue));

		if(nextVal ~= nil)then -- check if nil, that means the reputation is not set in the windows
			if(playerRepValue > nextVal or playerRepValue == nextVal)then
				if(playerRepPosition <= 1)then
					playerRepValue = 0;
				else
					playerRepValue = playerRepValue - reputationValueLevel[lvlValue];
				end
				playerRepPosition = playerRepPosition + 1;
			end
		end
	end

	RepuPosition[i] = playerRepPosition;
	RepuName[i] = playerRepName;
	Reputations[i] = playerRepValue;

	SavePlayerReputations(i);
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

    local name = string.match(message, pattern.name);
    local points = ParseChatNumber(string.match(message, pattern.points));
    local factionIndex, knownName = FindFactionInMessage(message);
    if knownName ~= nil then name = knownName; end

    if points == nil or factionIndex == nil then return nil; end

    return {
        index = factionIndex,
        name = name or knownName,
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

    PlayerXp[PlayerName] = (tonumber(PlayerXp[PlayerName]) or 0) + points;

    local level = PlayerDatas[PlayerName] and PlayerDatas[PlayerName].lvl;
    local currentThreshold = level and PlayerLevelXP[level] or nil;
    local previousThreshold = level and PlayerLevelXP[level - 1] or nil;
    if currentThreshold ~= nil and previousThreshold ~= nil then
        local levelRequirement = currentThreshold - previousThreshold;
        if PlayerXp[PlayerName] >= levelRequirement then
            PlayerXp[PlayerName] = PlayerXp[PlayerName] - levelRequirement;
        end
    end

    SavePlayerDatas();
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
function UpdaterFromChat()
    Turbine.Chat.Received = function(sender, args)
        local message = args and args.Message or nil;
        if message == nil then return; end

        HandleXPMessage(message);
        HandleReputationMessage(message);
        HandleLotroPointsMessage(message);
    end
end
