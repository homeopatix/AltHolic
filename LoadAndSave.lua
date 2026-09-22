------------------------------------------------------------------------------------------
-- LoadAndSave file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create or load the settings
------------------------------------------------------------------------------------------
function LoadSettings()
    local savedSettings = PatchDataLoad(dataScope, settingsFileName, nil);

    if type(savedSettings) ~= "table" then
        savedSettings = {};
    end

    -- Merge missing defaults recursively. This replaces the old migration block that
    -- rebuilt the entire settings table whenever one historical key was absent, which
    -- could silently discard newer preferences. Unknown saved keys are preserved for
    -- backwards compatibility.
    settings = AltHolicUtil.DeepMergeDefaults(savedSettings, DefaultSettings or settings);
    settings.schemaVersion = SettingsSchemaVersion or 4;

    -- Session-only values are always reset on load.
    if settings.sessionCash ~= nil then
        settings.sessionCash.cashSession = 0;
        settings.sessionCash.cashSpent = 0;
    end
end
------------------------------------------------------------------------------------------
-- save settings
------------------------------------------------------------------------------------------
function SaveSettings()
    if settings == nil then return; end

    -- Only values that genuinely need to be refreshed/coerced belong here. The old
    -- implementation contained dozens of x = x assignments that did no work and made
    -- adding a setting unnecessarily error-prone.
    if AltHolicWindow ~= nil and settings.windowPosition ~= nil then
        settings.windowPosition.xPos = tostring(AltHolicWindow:GetLeft());
        settings.windowPosition.yPos = tostring(AltHolicWindow:GetTop());
    end
    if settings.iconSize ~= nil then
        settings.iconSize.value = tonumber(settings.iconSize.value) or 64;
    end
    if settings.sharedStorageCash ~= nil then
        settings.sharedStorageCash.value = tonumber(settings.sharedStorageCash.value) or 0;
    end
    settings.schemaVersion = SettingsSchemaVersion or settings.schemaVersion;

    PatchDataSave(dataScope, settingsFileName, settings);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player datas
------------------------------------------------------------------------------------------
function LoadPlayerDatas()
    PlayerDatas = PatchDataLoad(dataScope, settingsDatasFileName, PlayerDatas);

    if (PlayerDatas == nil)then 
        PlayerDatas = {}; 
    end

    if (PlayerDatas[PlayerName] == nil)then 
        PlayerDatas[PlayerName] = {}; 
    end
end

------------------------------------------------------------------------------------------
-- Legacy vocation getter removed; crafting is read from PlayerProfessions.
------------------------------------------------------------------------------------------
function SavePlayerDatas()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    PlayerDatas[PlayerName] = PlayerDatas[PlayerName] or {};
    local playerData = PlayerDatas[PlayerName];

    playerData.cla = PlayerClass;
    playerData.lvl = Player:GetLevel();
    -- Legacy playerData.voc is intentionally left untouched for old display/filter data.
    playerData.rac = PlayerRace;
    playerData.cash = PlayerAttr:GetMoney();
    playerData.bagCash = tonumber(CalculateBagCoinValue());
    playerData.vaultCash = tonumber(CalculateVaultCoinValue());
    playerData.align = PlayerAlignement;
    playerData.sexe = PlayerSexe[PlayerName];
    playerData.xp = tonumber(PlayerXp[PlayerName]);

    -- statistical part
    playerData.moral = tonumber(Player:GetMorale());
    playerData.maxMoral = tonumber(Player:GetMaxMorale());
    playerData.power = tonumber(Player:GetPower());
    playerData.maxPower = tonumber(Player:GetMaxPower());

    -- server part
    playerData.serverName = PlayerServer[PlayerName];

    -- do not save for monsterplay
    if(playerData.align == 1)then
        playerData.armure = tonumber(PlayerAttr:GetArmor());
        playerData.agility = tonumber(PlayerAttr:GetAgility());
        playerData.fate = tonumber(PlayerAttr:GetFate());
        playerData.might = tonumber(PlayerAttr:GetMight());
        playerData.vitality = tonumber(PlayerAttr:GetVitality());
        playerData.will = tonumber(PlayerAttr:GetWill());

        -- large stats
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
        -- new stats
        playerData.orc = tonumber(PlayerAttr:GetPhysicalMitigation());
        playerData.range = tonumber(PlayerAttr:GetRangeDamage());
    end

    PatchDataSave( dataScope, settingsDatasFileName, PlayerDatas);
end
------------------------------------------------------------------------------------------
-- create the save settings for the server of the player
------------------------------------------------------------------------------------------
function SavePlayerServerName(playerToSave)

    PlayerDatas[playerToSave].serverName = PlayerServer[playerToSave];

    PatchDataSave( dataScope, settingsDatasFileName, PlayerDatas);
end
------------------------------------------------------------------------------------------
-- create the save settings for a special player named
------------------------------------------------------------------------------------------
function SavePlayerSexForSpecialCharacters(namePlayerToSave)

    PlayerDatas[namePlayerToSave].sexe = PlayerSexe[namePlayerToSave];

    PatchDataSave( dataScope, settingsDatasFileName, PlayerDatas);
end
------------------------------------------------------------------------------------------
-- create the save settings for a special player named
------------------------------------------------------------------------------------------
function SavePlayerLvlEquipment(i)

    PlayerEquipement[PlayerName][i].lvl = PlayerEquipItems[PlayerName][i];
    PlayerEquipement[PlayerName][i].armor = PlayerEquipArmor[PlayerName][i];

    PatchDataSave( dataScope, settingsEquipmentFileName, PlayerEquipement);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player bag
------------------------------------------------------------------------------------------
function LoadPlayerBags()
    PlayerBags = PatchDataLoad(dataScope, settingsBagFileName, PlayerBags);
    if (PlayerBags == nil)then 
        PlayerBags = {}; 
    end
    if (PlayerBags[PlayerName] == nil)then 
        PlayerBags[PlayerName] = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settingsfor player bag
------------------------------------------------------------------------------------------
function SavePlayerBags()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local backpackSize = backpack:GetSize();

    PlayerBags[PlayerName] = {};

    local slot = 1;
    for i = 1, backpackSize do

        local items = backpack:GetItem( i );
        if (items ~= nil) then
            local ind = tostring(slot);
            PlayerBags[PlayerName][ind] = items;
            local iteminfo = PlayerBags[PlayerName][ind]:GetItemInfo();

            PlayerBags[PlayerName][ind].Q = tostring(iteminfo:GetQualityImageID());
            PlayerBags[PlayerName][ind].B = tostring(iteminfo:GetBackgroundImageID());
            PlayerBags[PlayerName][ind].U = tostring(iteminfo:GetUnderlayImageID());
            PlayerBags[PlayerName][ind].S = tostring(iteminfo:GetShadowImageID());
            PlayerBags[PlayerName][ind].I = tostring(iteminfo:GetIconImageID());
            PlayerBags[PlayerName][ind].N = tostring(iteminfo:GetName());
            PlayerBags[PlayerName][ind].BS = tostring(backpackSize);

            local tq = tostring(PlayerBags[PlayerName][ind]:GetQuantity());

           -- if (tq == "1")then 
            --    tq = ""; 
           -- end

            PlayerBags[PlayerName][ind].QUA = tq;
            PlayerBags[PlayerName][ind].BSIZE = tostring(backpackSize);

            slot = slot +  1;
        end
    end
    settings["nameAccount"]["account1"]["isVisible"] = false;
    PatchDataSave( dataScope, settingsBagFileName, PlayerBags);
end
------------------------------------------------------------------------------------------
-- create or load the settings for vault
------------------------------------------------------------------------------------------
function LoadPlayerVault()
    PlayerVault = PatchDataLoad(dataScope, settingsVaultsFileName, PlayerVault);
    if (PlayerVault == nil)then 
        PlayerVault = {}; 
    end
    if (PlayerVault[PlayerName] == nil)then 
        PlayerVault[PlayerName] = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for vault
------------------------------------------------------------------------------------------
function SavePlayerVault()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local vaultpackSize = vaultpack:GetCapacity();
    local vaultpackCount = vaultpack:GetCount();

    PlayerVault[PlayerName] = {};

    for slot = 1, vaultpackCount do
        local ind = tostring(slot);
        PlayerVault[PlayerName][ind] = vaultpack:GetItem(slot);
        local iteminfo = PlayerVault[PlayerName][ind]:GetItemInfo();

        PlayerVault[PlayerName][ind].Q = tostring(iteminfo:GetQualityImageID());
        PlayerVault[PlayerName][ind].B = tostring(iteminfo:GetBackgroundImageID());
        PlayerVault[PlayerName][ind].U = tostring(iteminfo:GetUnderlayImageID());
        PlayerVault[PlayerName][ind].S = tostring(iteminfo:GetShadowImageID());
        PlayerVault[PlayerName][ind].I = tostring(iteminfo:GetIconImageID());
        PlayerVault[PlayerName][ind].N = tostring(iteminfo:GetName());

        local tq = tostring(PlayerVault[PlayerName][ind]:GetQuantity());
        --if (tq == "1" )then 
         --   tq = ""; 
       -- end

        PlayerVault[PlayerName][ind].QUA = tq;
        PlayerVault[PlayerName][ind].VSIZE = tostring(vaultpackSize);
    end

    PatchDataSave( dataScope, settingsVaultsFileName, PlayerVault);
end
------------------------------------------------------------------------------------------
-- create or load the settings for equipment
------------------------------------------------------------------------------------------
function LoadPlayerEquipment()
    PlayerEquipement = PatchDataLoad(dataScope, settingsEquipmentFileName, PlayerEquipement);
    if type(PlayerEquipement) ~= "table" then PlayerEquipement = {}; end

    local playerEquipment = AltHolicUtil.EnsureTable(PlayerEquipement, PlayerName);
    for _, slotDef in ipairs(AltHolicUtil.EquipmentSlots) do
        local slotData = AltHolicUtil.EnsureTable(playerEquipment, slotDef.key);
        -- Normalise optional legacy fields so downstream code can safely compare them.
        if slotData.lvl == nil then slotData.lvl = 0; end
        if slotData.armor == nil then slotData.armor = 0; end
    end
end

------------------------------------------------------------------------------------------
-- Save all equipped items using the shared equipment-slot schema.
------------------------------------------------------------------------------------------
local function SaveEquipmentSlot(playerEquipment, slotDef)
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

    local itemCache = PlayerEquipItems[PlayerName];
    local armorCache = PlayerEquipArmor[PlayerName];
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
    if string.sub(PlayerName, 1, 1) == "~" then return; end -- Ignore session play

    PlayerEquipement[PlayerName] = PlayerEquipement[PlayerName] or {};
    local playerEquipment = PlayerEquipement[PlayerName];
    local itemCache = PlayerEquipItems[PlayerName] or {};
    local armorCache = PlayerEquipArmor[PlayerName] or {};
    PlayerEquipItems[PlayerName] = itemCache;
    PlayerEquipArmor[PlayerName] = armorCache;

    for _, slotDef in ipairs(AltHolicUtil.EquipmentSlots) do
        SaveEquipmentSlot(playerEquipment, slotDef);
    end

    PatchDataSave(dataScope, settingsEquipmentFileName, PlayerEquipement);
end
------------------------------------------------------------------------------------------
-- create or load the settings for vault
------------------------------------------------------------------------------------------
function LoadSharedStorage()
    SharedStorageVault = PatchDataLoad(dataScope, settingsSharedStorageFileName, SharedStorageVault);
    if (SharedStorageVault == nil)then 
        SharedStorageVault = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for vault
------------------------------------------------------------------------------------------
function SaveSharedStorage()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local sharedStorageSize = sspack:GetCapacity();
    local sharedStorageCount = sspack:GetCount();

    SharedStorageVault = {};

    for slot = 1, sharedStorageCount do
        local ind = tostring(slot);
        SharedStorageVault[ind] = sspack:GetItem(slot);
        local iteminfo = SharedStorageVault[ind]:GetItemInfo();

        SharedStorageVault[ind].D = tostring(iteminfo:GetDescription());
        SharedStorageVault[ind].Q = tostring(iteminfo:GetQualityImageID());
        SharedStorageVault[ind].B = tostring(iteminfo:GetBackgroundImageID());
        SharedStorageVault[ind].U = tostring(iteminfo:GetUnderlayImageID());
        SharedStorageVault[ind].S = tostring(iteminfo:GetShadowImageID());
        SharedStorageVault[ind].I = tostring(iteminfo:GetIconImageID());
        SharedStorageVault[ind].N = tostring(iteminfo:GetName());

        local tq = tostring(SharedStorageVault[ind]:GetQuantity());
        --if (tq == "1" )then 
           -- tq = ""; 
        --end

        SharedStorageVault[ind].QUA = tq;
        SharedStorageVault[ind].VSIZE = tostring(sharedStorageSize);
    end

    PatchDataSave( dataScope, settingsSharedStorageFileName, SharedStorageVault);
end
------------------------------------------------------------------------------------------
-- create or load the settings for vault
------------------------------------------------------------------------------------------
function LoadPlayerWallet()
    PlayerWallet = PatchDataLoad(dataScope, settingsWalletFileName, PlayerWallet);
    if (PlayerWallet == nil)then 
        PlayerWallet = {}; 
    end
    if (PlayerWallet[PlayerName] == nil)then 
        PlayerWallet[PlayerName] = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for vault
------------------------------------------------------------------------------------------
function SavePlayerWallet()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local walletpackSize = walletpack:GetSize();

    PlayerWallet[PlayerName] = {};

    for slot = 1, walletpackSize do
        local ind = tostring(slot);
        PlayerWallet[PlayerName][ind] = walletpack:GetItem(slot);

        PlayerWallet[PlayerName][ind].D = tostring(PlayerWallet[PlayerName][ind]:GetDescription());
        PlayerWallet[PlayerName][ind].I = tostring(PlayerWallet[PlayerName][ind]:GetImage());
        PlayerWallet[PlayerName][ind].MQUA = tostring(PlayerWallet[PlayerName][ind]:GetMaxQuantity());
        PlayerWallet[PlayerName][ind].S = tostring(PlayerWallet[PlayerName][ind]:GetSmallImage());
        PlayerWallet[PlayerName][ind].A = tostring(PlayerWallet[PlayerName][ind]:IsAccountItem());
        PlayerWallet[PlayerName][ind].N = tostring(PlayerWallet[PlayerName][ind]:GetName());

        local tq = tostring(PlayerWallet[PlayerName][ind]:GetQuantity());
        --if (tq == "1" )then 
         --   tq = ""; 
       -- end

        PlayerWallet[PlayerName][ind].QUA = tq;
        PlayerWallet[PlayerName][ind].WSIZE = tostring(walletpackSize);
    end

    PatchDataSave( dataScope, settingsWalletFileName, PlayerWallet);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player professions
------------------------------------------------------------------------------------------
function LoadPlayerEpique()
    PlayerEpique = PatchDataLoad(dataScope, settingsEpiqueFileName, PlayerEpique);

    if (PlayerEpique == nil)then 
        PlayerEpique = {}; 
    end

    if (PlayerEpique[PlayerName] == nil)then 
        PlayerEpique[PlayerName] = {}; 
    end

    if (PlayerEpique[PlayerName].volume == nil)then 
        PlayerEpique[PlayerName].volume = {}; 
    end

    if (PlayerEpique[PlayerName].livre == nil)then 
        PlayerEpique[PlayerName].livre = {}; 
    end

    if (PlayerEpique[PlayerName].chapitre == nil)then 
        PlayerEpique[PlayerName].chapitre = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for player Epique
------------------------------------------------------------------------------------------
function SavePlayerEpique()
    --if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local val = tablelength(EpiqueVolume);

    if(val == 0)then
        val = 1;
    else
        val = val + 1;
    end

    for slot = 1, val do
        PlayerEpique[PlayerName].volume[slot] = EpiqueVolume[slot];
        PlayerEpique[PlayerName].livre[slot] = EpiqueLivre[slot];
        PlayerEpique[PlayerName].chapitre[slot] = EpiqueChapitre[slot];
    end

    PatchDataSave( dataScope, settingsEpiqueFileName, PlayerEpique);
end
------------------------------------------------------------------------------------------
-- create the save settings for player Epique delete
------------------------------------------------------------------------------------------
function SavePlayerEpiqueDelete()
    --if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    local val = tablelength(EpiqueVolume);

    local test1 = {}; 
    local test2 = {}; 
    local test3 = {}; 

    local valx = 1;
    for slot = 1, val+1 do
        if(PlayerEpique[PlayerName].volume[slot] ~= nil)then
            test1[valx] = PlayerEpique[PlayerName].volume[slot];
            test2[valx] = PlayerEpique[PlayerName].livre[slot];
            test3[valx] = PlayerEpique[PlayerName].chapitre[slot];
            valx = valx + 1;
        end
    end

    PlayerEpique[PlayerName].volume = test1;
    PlayerEpique[PlayerName].livre = test2;
    PlayerEpique[PlayerName].chapitre = test3;

    PatchDataSave( dataScope, settingsEpiqueFileName, PlayerEpique);
end
------------------------------------------------------------------------------------------
-- create or load the settings for equipment
------------------------------------------------------------------------------------------
function LoadPlayerReputations()
    PlayerReput = PatchDataLoad(dataScope, settingsReputationsFileName, PlayerReput);

    if (PlayerReput == nil)then 
        PlayerReput = {}; 
    end
    if (PlayerReput[PlayerName] == nil)then 
        PlayerReput[PlayerName] = {};         
    end

    for i = 1, nbrFactions do
        if (PlayerReput[PlayerName]["Reput" .. i] == nil)then 
            PlayerReput[PlayerName]["Reput" .. i] = {}; 
            PlayerReput[PlayerName]["Reput" .. i].name = "";
            PlayerReput[PlayerName]["Reput" .. i].value = 0;
            PlayerReput[PlayerName]["Reput" .. i].position = 0;
            PlayerReput[PlayerName]["Reput" .. i].genre = 0;
        end
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for equipment
------------------------------------------------------------------------------------------
function SavePlayerReputations(valueReput)
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    if(valueReput ~= nil)then
        PlayerReput[PlayerName]["Reput" .. valueReput].name = T["reputname" .. valueReput];
        PlayerReput[PlayerName]["Reput" .. valueReput].value = Reputations[valueReput];
        PlayerReput[PlayerName]["Reput" .. valueReput].position = RepuPosition[valueReput];

        if( valueReput ~= 21 and valueReput ~= 22 and valueReput ~= 23 and valueReput ~= 24 and valueReput ~= 25 and valueReput ~= 26 and 
        valueReput ~= 27 and valueReput ~= 64 and valueReput ~= 70 and valueReput ~= 71 and valueReput ~= 79 and valueReput ~= 100)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 1; -- toutes les autres
        elseif(i == 64)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 2; -- chasse-poulet
        elseif(i == 70)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 0; -- la companie blanche
        elseif(i == 71)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 4; -- Reclamation de minas ithil
        elseif(i == 79 or i == 104 or i == 105)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 5; -- The Gabil'akk�
        elseif(i == 100)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 6; -- The Path of Valor
        elseif(i == 106)then
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 7; -- Amelia's studies
        else
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 3; -- guilde des professions
        end
    else
        for i = 1, nbrFactions do
            PlayerReput[PlayerName]["Reput" .. i].name = T["reputname" .. i];

            if(PlayerReput[PlayerName]["Reput" .. i].name == RepuName[i])then
                PlayerReput[PlayerName]["Reput" .. i].value = Reputations[i];
                PlayerReput[PlayerName]["Reput" .. i].position = RepuPosition[i];
            end

            if( i ~= 21 and i ~= 22 and i ~= 23 and i ~= 24 and i ~= 25 and i ~= 26 and i ~= 27 and i ~= 64 and i ~= 70 and i ~= 71 and i ~= 79 and i ~= 100)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 1; -- toutes les autres
            elseif(i == 64)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 2; -- chasse-poulet
            elseif(i == 70)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 0; -- la companie blanche
            elseif(i == 71)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 4; -- Reclamation de minas ithil
            elseif(i == 79 or i == 104 or i == 105)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 5; -- The Gabil'akk�
            elseif(i == 100)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 6; -- The Path of Valor
            elseif(i == 106)then
                PlayerReput[PlayerName]["Reput" .. i].genre = 7; -- Amelia's studies
            else
                PlayerReput[PlayerName]["Reput" .. i].genre = 3; -- guilde des professions
            end

            --Write( i .. " : namereput to update : " .. tostring(RepuName[i]) .. " : " .. tostring(Reputations[i]));
            --Write(tostring(RepuPosition[i]) .. " : " .. PlayerReput[PlayerName]["Reput" .. i].genre);
        end
    end

    PatchDataSave( dataScope, settingsReputationsFileName, PlayerReput);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player infos
------------------------------------------------------------------------------------------
function LoadPlayerInfos()
    PlayerInfos = PatchDataLoad(dataScope, settingsInfosFileName, PlayerInfos);

    if (PlayerInfos == nil)then 
        PlayerInfos = {}; 
    end

    if (PlayerInfos[PlayerName] == nil)then 
        PlayerInfos[PlayerName] = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for player datas
------------------------------------------------------------------------------------------
function SavePlayerInfos(playerName, infoText)
    PlayerInfos[playerName] = PlayerInfos[playerName] or {};
    PlayerInfos[playerName].info = infoText or "";
    PatchDataSave(dataScope, settingsInfosFileName, PlayerInfos);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player professions
------------------------------------------------------------------------------------------
function LoadPlayerProfessions()
    PlayerProfessions = PatchDataLoad(dataScope, settingsProfessionsFileName, PlayerProfessions);

    if PlayerProfessions == nil then PlayerProfessions = {}; end
    if PlayerProfessions[PlayerName] == nil then PlayerProfessions[PlayerName] = {}; end

    local player = PlayerProfessions[PlayerName];

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
------------------------------------------------------------------------------------------
-- create the save settings for player professions
------------------------------------------------------------------------------------------
function SavePlayerProfessions(professions)
    if string.sub(PlayerName, 1, 1) == "~" then return end; -- Ignore session play

    local saved = {
        Version = 3,
        Professions = {}
    };

    for index, profession in ipairs(professions or {}) do
        saved.Professions[index] = {
            Key = profession.Key,
            Name = profession.Name,
            Icon = profession.Icon,
            ProficiencyLevel = profession.ProficiencyLevel,
            MasteryLevel = profession.MasteryLevel,
            ProficiencyExp = profession.ProficiencyExp,
            ProficiencyExpTarget = profession.ProficiencyExpTarget,
            MasteryExp = profession.MasteryExp,
            MasteryExpTarget = profession.MasteryExpTarget,
            CurrentLvl = profession.CurrentLvl,
            CurrentMastery = profession.CurrentMastery
        };
    end

    PlayerProfessions[PlayerName] = saved;
    PatchDataSave(dataScope, settingsProfessionsFileName, PlayerProfessions);
end