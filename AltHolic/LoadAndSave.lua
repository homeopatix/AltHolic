------------------------------------------------------------------------------------------
-- LoadAndSave file
-- Written by Homeopatix
-- 26 january 2021
-- Refactored for AltHolic 5.06: plain-table snapshots, persist-only helpers and
-- a single place for each file's load/save logic.
-- 5.07 cleanup: hardened nil guards for per-character state and save paths.
------------------------------------------------------------------------------------------

local function IsSessionPlay()
    return string.sub(PlayerName, 1, 1) == "~";
end

-- Write a whole data file without re-scanning any live game container. Deleting an alt or
-- editing offline data must never re-read the logged-in character's vault/bags, because
-- those containers are empty until they are actually opened this session.
local function Persist(fileName, data)
    PatchDataSave(dataScope, fileName, data);
end

-- Load a per-character file and make sure the logged-in character has a record.
local function LoadCharacterFile(fileName, current)
    local data = PatchDataLoad(dataScope, fileName, current);
    if type(data) ~= "table" then data = {}; end
    if type(data[PlayerName]) ~= "table" then data[PlayerName] = {}; end
    return data;
end

-- Copy the fields AltHolic displays out of a live inventory Item. Saving plain tables (rather
-- than decorating the live Item objects) keeps engine objects out of the save files.
local function SnapshotItem(item, sizeField, size)
    local info = item:GetItemInfo();
    local snapshot = {
        Q = tostring(info:GetQualityImageID()),
        B = tostring(info:GetBackgroundImageID()),
        U = tostring(info:GetUnderlayImageID()),
        S = tostring(info:GetShadowImageID()),
        I = tostring(info:GetIconImageID()),
        N = tostring(info:GetName()),
        QUA = tostring(item:GetQuantity()),
    };
    snapshot[sizeField] = tostring(size);
    return snapshot;
end

------------------------------------------------------------------------------------------
-- Settings
------------------------------------------------------------------------------------------
function LoadSettings()
    local savedSettings = PatchDataLoad(dataScope, settingsFileName, nil);
    if type(savedSettings) ~= "table" then savedSettings = {}; end

    -- Merge missing defaults recursively; unknown saved keys are preserved.
    settings = AltHolicUtil.DeepMergeDefaults(savedSettings, DefaultSettings);
    settings.schemaVersion = SettingsSchemaVersion;

    -- Session-only values are always reset on load.
    settings.sessionCash.cashSession = 0;
    settings.sessionCash.cashSpent = 0;
end

function SaveSettings()
    if settings == nil then return; end

    if AltHolicWindow ~= nil then
        settings.windowPosition.xPos = tostring(AltHolicWindow:GetLeft());
        settings.windowPosition.yPos = tostring(AltHolicWindow:GetTop());
    end
    settings.iconSize.value = tonumber(settings.iconSize.value) or 64;
    settings.sharedStorageCash.value = tonumber(settings.sharedStorageCash.value) or 0;
    settings.lotroCoins.value = tonumber(settings.lotroCoins.value) or 0;
    settings.schemaVersion = SettingsSchemaVersion;

    Persist(settingsFileName, settings);
end

------------------------------------------------------------------------------------------
-- Character data (level, class, money, stats)
------------------------------------------------------------------------------------------
function LoadPlayerDatas()
    PlayerDatas = LoadCharacterFile(settingsDatasFileName, PlayerDatas);
end

-- Write PlayerDatas as it is in memory (used for offline edits: XP, server, gender, delete).
function PersistPlayerDatas()
    Persist(settingsDatasFileName, PlayerDatas);
end

-- XP chat messages arrive on every kill. They only mark the data dirty; the 30-second
-- maintenance tick and plugin unload write it, instead of a full save per kill.
local playerDatasDirty = false;

function MarkPlayerDatasDirty()
    playerDatasDirty = true;
end

function FlushPlayerDatas()
    if playerDatasDirty then SavePlayerDatas(); end
end

-- Refresh the logged-in character's record from the live game, then persist.
function SavePlayerDatas()
    if IsSessionPlay() then return; end
    playerDatasDirty = false;

    PlayerDatas[PlayerName] = PlayerDatas[PlayerName] or {};
    local playerData = PlayerDatas[PlayerName];

    playerData.cla = PlayerClass;
    playerData.lvl = Player:GetLevel();
    -- Legacy playerData.voc is intentionally left untouched for old saved data.
    playerData.rac = PlayerRace;
    playerData.cash = PlayerAttr:GetMoney();
    playerData.bagCash = tonumber(CalculateBagCoinValue());
    playerData.vaultCash = tonumber(CalculateVaultCoinValue());
    playerData.align = PlayerAlignement;
    playerData.sexe = PlayerSexe[PlayerName];
    playerData.xp = tonumber(PlayerXp[PlayerName]);

    playerData.moral = tonumber(Player:GetMorale());
    playerData.maxMoral = tonumber(Player:GetMaxMorale());
    playerData.power = tonumber(Player:GetPower());
    playerData.maxPower = tonumber(Player:GetMaxPower());

    playerData.serverName = PlayerServer[PlayerName];

    -- Detailed stats only exist for Free Peoples characters.
    if playerData.align == 1 then
        playerData.armure = tonumber(PlayerAttr:GetArmor());
        playerData.agility = tonumber(PlayerAttr:GetAgility());
        playerData.fate = tonumber(PlayerAttr:GetFate());
        playerData.might = tonumber(PlayerAttr:GetMight());
        playerData.vitality = tonumber(PlayerAttr:GetVitality());
        playerData.will = tonumber(PlayerAttr:GetWill());

        playerData.critA = tonumber(PlayerAttr:GetBaseCriticalHitChance());
        playerData.fines = tonumber(PlayerAttr:GetFinesse());
        playerData.meleD = tonumber(PlayerAttr:GetMeleeDamage());
        playerData.tactD = tonumber(PlayerAttr:GetTacticalDamage());
        playerData.degaP = tonumber(PlayerAttr:GetCommonMitigation());
        playerData.degaT = tonumber(PlayerAttr:GetTacticalMitigation());
        playerData.defeC = tonumber(PlayerAttr:GetBaseCriticalHitAvoidance());
        playerData.resis = tonumber(PlayerAttr:GetBaseResistance());
        playerData.bloqu = tonumber(PlayerAttr:GetBlock());
        playerData.parad = tonumber(PlayerAttr:GetParry());
        playerData.esqui = tonumber(PlayerAttr:GetEvade());
        playerData.healD = tonumber(PlayerAttr:GetOutgoingHealing());
        playerData.healR = tonumber(PlayerAttr:GetIncomingHealing());
        playerData.orc = tonumber(PlayerAttr:GetPhysicalMitigation());
        playerData.range = tonumber(PlayerAttr:GetRangeDamage());
    end

    PersistPlayerDatas();
end

function SavePlayerServerName(playerToSave)
    if PlayerDatas[playerToSave] == nil then return; end
    PlayerDatas[playerToSave].serverName = PlayerServer[playerToSave];
    PersistPlayerDatas();
end

function SavePlayerSexForSpecialCharacters(namePlayerToSave)
    if PlayerDatas[namePlayerToSave] == nil then return; end
    PlayerDatas[namePlayerToSave].sexe = PlayerSexe[namePlayerToSave];
    PersistPlayerDatas();
end

-- Saved XP for any character (the XP editor works on offline alts too).
function SavePlayerXP(playerName, xp)
    if PlayerDatas[playerName] == nil then return; end
    xp = math.max(0, tonumber(xp) or 0);
    PlayerXp[playerName] = xp;
    PlayerDatas[playerName].xp = xp;
    PersistPlayerDatas();
end

------------------------------------------------------------------------------------------
-- Backpack
------------------------------------------------------------------------------------------
function LoadPlayerBags()
    PlayerBags = LoadCharacterFile(settingsBagFileName, PlayerBags);
end

function SavePlayerBags()
    if IsSessionPlay() then return; end

    local backpackSize = backpack:GetSize();
    local bag = {};
    local slot = 1;
    for index = 1, backpackSize do
        local item = backpack:GetItem(index);
        if item ~= nil then
            bag[tostring(slot)] = SnapshotItem(item, "BSIZE", backpackSize);
            slot = slot + 1;
        end
    end

    PlayerBags[PlayerName] = bag;
    Persist(settingsBagFileName, PlayerBags);
end

------------------------------------------------------------------------------------------
-- Vault
------------------------------------------------------------------------------------------
function LoadPlayerVault()
    PlayerVault = LoadCharacterFile(settingsVaultsFileName, PlayerVault);
end

function SavePlayerVault()
    if IsSessionPlay() then return; end

    local capacity = vaultpack:GetCapacity();
    local vault = {};
    local slot = 1;
    for index = 1, vaultpack:GetCount() do
        local item = vaultpack:GetItem(index);
        if item ~= nil then
            vault[tostring(slot)] = SnapshotItem(item, "VSIZE", capacity);
            slot = slot + 1;
        end
    end

    PlayerVault[PlayerName] = vault;
    Persist(settingsVaultsFileName, PlayerVault);
end

------------------------------------------------------------------------------------------
-- Equipment
------------------------------------------------------------------------------------------
function LoadPlayerEquipment()
    PlayerEquipement = LoadCharacterFile(settingsEquipmentFileName, PlayerEquipement);

    local playerEquipment = PlayerEquipement[PlayerName];
    for _, slotDef in ipairs(AltHolicUtil.EquipmentSlots) do
        local slotData = AltHolicUtil.EnsureTable(playerEquipment, slotDef.key);
        -- Normalise optional legacy fields so downstream code can safely compare them.
        if slotData.lvl == nil then slotData.lvl = 0; end
        if slotData.armor == nil then slotData.armor = 0; end
    end
end

function SavePlayerLvlEquipment(slotName, playerName)
    playerName = playerName or PlayerName;
    local equipment = PlayerEquipement[playerName];
    if equipment == nil or equipment[slotName] == nil then return; end
    equipment[slotName].lvl = PlayerEquipItems[playerName] and PlayerEquipItems[playerName][slotName] or nil;
    equipment[slotName].armor = PlayerEquipArmor[playerName] and PlayerEquipArmor[playerName][slotName] or nil;
    Persist(settingsEquipmentFileName, PlayerEquipement);
end

local function SaveEquipmentSlot(playerEquipment, slotDef, itemCache, armorCache)
    local slotName = slotDef.key;
    local slotData = {};
    playerEquipment[slotName] = slotData;

    local item = PlayerEquip:GetItem(slotDef.index);
    if item == nil then return; end

    local itemInfo = item:GetItemInfo();
    slotData.D = itemInfo:GetDescription();
    slotData.Q = itemInfo:GetQualityImageID();
    slotData.B = itemInfo:GetBackgroundImageID();
    slotData.U = itemInfo:GetUnderlayImageID();
    slotData.S = itemInfo:GetShadowImageID();
    slotData.I = itemInfo:GetIconImageID();
    slotData.N = itemInfo:GetName();
    slotData.QA = itemInfo:GetQuality();
    slotData.DU = itemInfo:GetDurability();
    slotData.CAT = itemInfo:GetCategory();
    slotData.WS = item:GetWearState();

    -- A different item in the slot invalidates the manually entered level/armour values.
    local nameKey = slotName .. "N";
    if itemCache[nameKey] ~= slotData.N then
        itemCache[slotName] = 0;
        armorCache[slotName] = 0;
        itemCache[nameKey] = slotData.N;
    end

    local savedLevel = tonumber(itemCache[slotName]) or 0;
    local savedArmor = tonumber(armorCache[slotName]) or 0;
    if savedLevel ~= 0 then slotData.lvl = savedLevel; end
    if savedArmor ~= 0 then slotData.armor = savedArmor; end
end

function SavePlayerEquipment()
    if IsSessionPlay() then return; end

    PlayerEquipement[PlayerName] = PlayerEquipement[PlayerName] or {};
    local playerEquipment = PlayerEquipement[PlayerName];
    local itemCache = PlayerEquipItems[PlayerName] or {};
    local armorCache = PlayerEquipArmor[PlayerName] or {};
    PlayerEquipItems[PlayerName] = itemCache;
    PlayerEquipArmor[PlayerName] = armorCache;

    for _, slotDef in ipairs(AltHolicUtil.EquipmentSlots) do
        SaveEquipmentSlot(playerEquipment, slotDef, itemCache, armorCache);
    end

    Persist(settingsEquipmentFileName, PlayerEquipement);
end

------------------------------------------------------------------------------------------
-- Shared storage (account-wide, not per character)
------------------------------------------------------------------------------------------
function LoadSharedStorage()
    SharedStorageVault = PatchDataLoad(dataScope, settingsSharedStorageFileName, SharedStorageVault);
    if type(SharedStorageVault) ~= "table" then SharedStorageVault = {}; end
end

function SaveSharedStorage()
    if IsSessionPlay() then return; end

    local capacity = sspack:GetCapacity();
    local storage = {};
    local slot = 1;
    for index = 1, sspack:GetCount() do
        local item = sspack:GetItem(index);
        if item ~= nil then
            storage[tostring(slot)] = SnapshotItem(item, "VSIZE", capacity);
            slot = slot + 1;
        end
    end

    SharedStorageVault = storage;
    Persist(settingsSharedStorageFileName, SharedStorageVault);
end

------------------------------------------------------------------------------------------
-- Wallet
------------------------------------------------------------------------------------------
function LoadPlayerWallet()
    PlayerWallet = LoadCharacterFile(settingsWalletFileName, PlayerWallet);
end

function SavePlayerWallet()
    if IsSessionPlay() then return; end

    local walletSize = walletpack:GetSize();
    local wallet = {};
    for index = 1, walletSize do
        local item = walletpack:GetItem(index);
        if item ~= nil then
            wallet[tostring(index)] = {
                D = tostring(item:GetDescription()),
                I = tostring(item:GetImage()),
                MQUA = tostring(item:GetMaxQuantity()),
                S = tostring(item:GetSmallImage()),
                A = tostring(item:IsAccountItem()),
                N = tostring(item:GetName()),
                QUA = tostring(item:GetQuantity()),
                WSIZE = tostring(walletSize),
            };
        end
    end

    PlayerWallet[PlayerName] = wallet;
    Persist(settingsWalletFileName, PlayerWallet);
end

------------------------------------------------------------------------------------------
-- Epic book tracker
------------------------------------------------------------------------------------------
function LoadPlayerEpique()
    PlayerEpique = LoadCharacterFile(settingsEpiqueFileName, PlayerEpique);
    local epic = PlayerEpique[PlayerName];
    if epic == nil then
        epic = {};
        PlayerEpique[PlayerName] = epic;
    end
    epic.volume = epic.volume or {};
    epic.livre = epic.livre or {};
    epic.chapitre = epic.chapitre or {};
end

-- The add/update window edits PlayerEpique directly; this only writes it. (The previous
-- implementation copied from three never-filled globals, which erased entry #1 on every
-- add or update.)
function SavePlayerEpique()
    Persist(settingsEpiqueFileName, PlayerEpique);
end

-- Re-number the current character's entries 1..n after a deletion, keeping their order.
-- (The previous implementation kept only entry #1 and silently dropped the rest.)
function SavePlayerEpiqueDelete()
    local epic = PlayerEpique[PlayerName];
    if epic == nil then return; end
    local indices = {};
    for key, value in pairs(epic.volume or {}) do
        local index = tonumber(key);
        if index ~= nil and value ~= nil then indices[#indices + 1] = index; end
    end
    table.sort(indices);

    local volume, livre, chapitre = {}, {}, {};
    for newIndex, oldIndex in ipairs(indices) do
        volume[newIndex] = epic.volume[oldIndex];
        livre[newIndex] = epic.livre[oldIndex];
        chapitre[newIndex] = epic.chapitre[oldIndex];
    end
    epic.volume, epic.livre, epic.chapitre = volume, livre, chapitre;

    SavePlayerEpique();
end

------------------------------------------------------------------------------------------
-- Reputations
------------------------------------------------------------------------------------------
function LoadPlayerReputations()
    PlayerReput = LoadCharacterFile(settingsReputationsFileName, PlayerReput);

    local reputations = PlayerReput[PlayerName];
    if reputations == nil then
        reputations = {};
        PlayerReput[PlayerName] = reputations;
    end
    for index = 1, nbrFactions do
        local key = "Reput" .. index;
        if reputations[key] == nil then
            reputations[key] = { name = "", value = 0, position = 0, genre = 0 };
        end
    end
end

-- Rank-ladder family of a faction ("genre"), used to pick the rank names and thresholds.
-- 21-27 are the crafting guilds. The old per-call chains also listed 104-106 here, but
-- those branches were unreachable; they have always used the standard ladder.
local REPUTATION_GENRES = { [64] = 2, [70] = 0, [71] = 4, [79] = 5, [100] = 6 };

function GetReputationGenre(index)
    if index >= 21 and index <= 27 then return 3; end
    return REPUTATION_GENRES[index] or 1;
end

-- Persist one faction (after a chat update) or, with no argument, every faction the
-- player edited this session.
function SavePlayerReputations(valueReput)
    if IsSessionPlay() then return; end

    local reputations = PlayerReput[PlayerName] or {};
    PlayerReput[PlayerName] = reputations;
    if valueReput ~= nil then
        local record = reputations["Reput" .. valueReput];
        if record ~= nil then
            record.name = T["reputname" .. valueReput];
            record.value = Reputations[valueReput];
            record.position = RepuPosition[valueReput];
            record.genre = GetReputationGenre(valueReput);
        end
    else
        for index = 1, nbrFactions do
            local record = reputations["Reput" .. index];
            if record ~= nil then
                record.name = T["reputname" .. index];
                if record.name == RepuName[index] then
                    record.value = Reputations[index];
                    record.position = RepuPosition[index];
                end
                record.genre = GetReputationGenre(index);
            end
        end
    end

    Persist(settingsReputationsFileName, PlayerReput);
end

------------------------------------------------------------------------------------------
-- Character notes
------------------------------------------------------------------------------------------
function LoadPlayerInfos()
    PlayerInfos = LoadCharacterFile(settingsInfosFileName, PlayerInfos);
end

function SavePlayerInfos(playerName, infoText)
    if PlayerInfos[playerName] == nil then
        PlayerInfos[playerName] = {};
    end
    PlayerInfos[playerName].info = infoText or "";
    Persist(settingsInfosFileName, PlayerInfos);
end

------------------------------------------------------------------------------------------
-- Professions
------------------------------------------------------------------------------------------
function LoadPlayerProfessions()
    PlayerProfessions = LoadCharacterFile(settingsProfessionsFileName, PlayerProfessions);

    local player = PlayerProfessions[PlayerName];
    if player == nil then
        player = {};
        PlayerProfessions[PlayerName] = player;
    end
    if player.Professions ~= nil and #player.Professions > 0 then
        -- Current format: discard duplicate legacy mirrors in memory.
        player.name = nil;
        player.Name = nil;
        player.CurrentLvl = nil;
        player.currentMastery = nil;
    else
        -- Legacy v4.52 data is kept readable until this character is logged in and
        -- naturally rewritten into the canonical Professions list.
        if player.Name == nil then player.Name = player.name or {}; end
        player.name = nil;
        if player.CurrentLvl == nil then player.CurrentLvl = {}; end
        if player.currentMastery == nil then player.currentMastery = {}; end
    end
end

local PROFESSION_FIELDS = {
    "Key", "Name", "Icon", "ProficiencyLevel", "MasteryLevel", "ProficiencyExp",
    "ProficiencyExpTarget", "MasteryExp", "MasteryExpTarget", "CurrentLvl", "CurrentMastery",
};

-- Returns true when something was written. Unchanged data is not re-saved, so rebuilding
-- the main window no longer rewrites the professions file every time.
local lastProfessionSignature = nil;

function SavePlayerProfessions(professions)
    if IsSessionPlay() then return false; end

    local saved = { Version = 3, Professions = {} };
    local signature = {};
    for index, profession in ipairs(professions or {}) do
        local copy = {};
        for _, field in ipairs(PROFESSION_FIELDS) do
            copy[field] = profession[field];
            signature[#signature + 1] = tostring(profession[field]);
        end
        saved.Professions[index] = copy;
    end
    signature = table.concat(signature, "\1");

    if signature == lastProfessionSignature then return false; end

    PlayerProfessions[PlayerName] = saved;
    Persist(settingsProfessionsFileName, PlayerProfessions);
    lastProfessionSignature = signature;
    return true;
end

------------------------------------------------------------------------------------------
-- Deleting characters
------------------------------------------------------------------------------------------
-- Every per-character store, with the file it is saved in.
local function CharacterStores()
    return {
        { PlayerDatas, settingsDatasFileName },
        { PlayerBags, settingsBagFileName },
        { PlayerVault, settingsVaultsFileName },
        { PlayerWallet, settingsWalletFileName },
        { PlayerEquipement, settingsEquipmentFileName },
        { PlayerReput, settingsReputationsFileName },
        { PlayerEpique, settingsEpiqueFileName },
        { PlayerInfos, settingsInfosFileName },
        { PlayerProfessions, settingsProfessionsFileName },
    };
end

-- Remove the given characters from every store and write each file once.
function DeleteCharacterData(names)
    for _, store in ipairs(CharacterStores()) do
        local data, fileName = store[1], store[2];
        if type(data) == "table" then
            local changed = false;
            for _, name in ipairs(names) do
                if data[name] ~= nil then
                    data[name] = nil;
                    changed = true;
                end
            end
            if changed then Persist(fileName, data); end
        end
    end
    for _, name in ipairs(names) do
        PlayerXp[name] = nil;
        PlayerSexe[name] = nil;
        PlayerServer[name] = nil;
        if name == PlayerName then lastProfessionSignature = nil; end
    end
end























































































































