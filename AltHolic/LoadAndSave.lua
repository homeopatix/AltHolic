------------------------------------------------------------------------------------------
-- LoadAndSave file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create or load the settings
------------------------------------------------------------------------------------------
function LoadSettings()
	local _settings = PatchDataLoad(dataScope, settingsFileName, settings);
    if (_settings ~= nil) then 
		settings = _settings; 
	end
------------------------------------------------------------------------------------------
--- adding new vars in the settings file ---
------------------------------------------------------------------------------------------
    if ( not settings.OptionsWindowVoc) then		
		settings = {
            windowPosition = { 
                xPos = settings["windowPosition"]["xPos"], 
                yPos = settings["windowPosition"]["yPos"] 
            },
            IconPosition = { 
                xPosIcon = settings["IconPosition"]["xPosIcon"], 
                yPosIcon = settings["IconPosition"]["yPosIcon"] 
            },
            isMinimizeEnabled = { 
                isMinimizeEnabled = settings["isMinimizeEnabled"]["isMinimizeEnabled"] 
            },
            isWindowVisible = { 
                isWindowVisible = settings["isWindowVisible"]["isWindowVisible"] 
            },
            isShowBagVisible = { 
                isShowBagVisible = false   
            },
            isShowVaultVisible = { 
                isShowVaultVisible = false   
            },
            displayTokensIcon = { 
                value = false 
            },
            isShowWalletVisible = { 
                isShowWalletVisible = false   
            },
            isServerWindowVisible = { 
                value = false   
            },
            isShowSharedStorageVisible = { 
                isShowSharedStorageVisible = false   
            },
            isOptionsWindowVisible = { 
                isOptionsWindowVisible = false 
            },
            isOptionsWindowBarVisible = { 
                isOptionsWindowBarVisible = false 
            },
            isSearchWindowVisible = { 
                isSearchWindowVisible = false 
            },
            isShowStatsVisible = { 
                isShowStatsVisible = false   
            },
            isLvlEquipWindowVisible = { 
                isLvlEquipWindowVisible = false 
            },
            isShowEquipmentVisible = { 
                isShowEquipmentVisible = false   
            },
            isEpiqueWindowVisible = { 
                isEpiqueWindowVisible = false 
            },
            isReputWindowVisible = { 
                isReputWindowVisible = false 
            },
            isXPWindowVisible = { 
                value = false 
            },
            -- new from here
            isGendreWindowVisible = { 
                value = false 
            },
            OptionsWindowVoc = { 
                value = false 
            },
            isHelpWindowVisible = { 
                value = false 
            },
            isInfoWindowVisible = { 
                value = false 
            },
            isFestivalWindowVisible = { 
                value = false 
            },
            isLotroWindowVisible = { 
                value = false 
            },
            isToBeSurWindowVisible = { 
                value = false 
            },
            wasAltHolicBarVisible = { 
                value = false 
            },
            wasAltHolicWindowVisible = { 
                value = false 
            },
            -- end new from here
            ShowHideReput = { 
                value = false 
            },
            displaySpentCash = { 
                value = false 
            },
            displayTotalCash = { 
                value = false 
            },
            displayClassBags = { 
                value = false 
            },
            verbose = { 
                value = false
            },
            displayBarWindow = { 
                value = false 
            },
            displayDurabilityColor = { 
                value = false 
            },
            displayLvlMax = { 
                value = false 
            },
            showProgressReput = { 
                value = true 
            },
            showProgressLotro = { 
                value = true 
            },
            displayIcon = { 
                value = false 
            },
            displayServers = { 
                value = false 
            },
            displayDeleteIcon = { 
                value = false 
            },
            displayBarIcon2 = { 
                value = false 
            },
            displayBarIcon3 = { 
                value = false 
            },
            displayBarIcon4 = { 
                value = false 
            },
            displayBarIcon5 = { 
                value = false 
            },
            displayBarIcon6 = { 
                value = false 
            },
            displayBarIcon7 = { 
                value = false 
            },
            displayBarIcon8 = { 
                value = false 
            },
            displayBarIcon9 = { 
                value = false 
            },
            displayBarIcon10 = { 
                value = false 
            },
            displayBarIcon11 = { 
                value = false 
            },
            displayBarIcon12 = { 
                value = false 
            },
            displayBarIcon13 = { 
                value = false 
            },
            displayBarIcon14 = { 
                value = false 
            },
            displayBarIcon15 = { 
                value = false 
            },
            displayBarIcon16 = { 
                value = false 
            },
            displayBarBagSize = { 
                value = false 
            },
            serversToDisplay = { 
                value = "" 
            },
            iconSize = { 
                value = 32 
            },
            escEnable = { 
                escEnable = settings["escEnable"]["escEnable"] 
            },
            altEnable = { 
                altEnable = true 
            },
            lotroCoins = { 
                value = 0 
            },
            sessionCash = { 
                cashSession = 0,
                cashSpent = 0
            },
            sharedStorageCash = { 
                value = 0,
            },
            dailyCash = { 
                jour = 0,
                mois = 0,
                annee = 0,
                cashDaily = 0,
                cashSpent = 0
            },
            nameAccount = { 
                account1 = { name = settings["nameAccount"]["account1"]["name"], 
                             nbrAlt = settings["nameAccount"]["account1"]["nbrAlt"], 
                             isVisible = settings["nameAccount"]["account1"]["isVisible"]}
            }
        };
	end
end
------------------------------------------------------------------------------------------
-- create the save settings
------------------------------------------------------------------------------------------
function SaveSettings()
	settings["windowPosition"]["xPos"] = tostring(AltHolicWindow:GetLeft());
    settings["windowPosition"]["yPos"] = tostring(AltHolicWindow:GetTop());
    settings["IconPosition"]["xPosIcon"] = settings["IconPosition"]["xPosIcon"];
   	settings["IconPosition"]["yPosIcon"] = settings["IconPosition"]["yPosIcon"];
	settings["isMinimizeEnabled"]["isMinimizeEnabled"] = settings["isMinimizeEnabled"]["isMinimizeEnabled"];
	settings["isWindowVisible"]["isWindowVisible"] = settings["isWindowVisible"]["isWindowVisible"];
    settings["isShowBagVisible"]["isShowBagVisible"] = settings["isShowBagVisible"]["isShowBagVisible"];
    settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"];
    settings["isSearchWindowVisible"]["isSearchWindowVisible"] = settings["isSearchWindowVisible"]["isSearchWindowVisible"];
    settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = settings["isShowEquipmentVisible"]["isShowEquipmentVisible"];
    settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"];
    settings["isReputWindowVisible"]["isReputWindowVisible"] = settings["isReputWindowVisible"]["isReputWindowVisible"];
    settings["isXPWindowVisible"]["value"] = settings["isXPWindowVisible"]["value"];
    settings["isServerWindowVisible"]["value"] = settings["isServerWindowVisible"]["value"];
    
    -- new from here
    settings["isGendreWindowVisible"]["value"] = settings["isGendreWindowVisible"]["value"];
    settings["isHelpWindowVisible"]["value"] = settings["isHelpWindowVisible"]["value"];
    settings["isInfoWindowVisible"]["value"] = settings["isInfoWindowVisible"]["value"];
    settings["isFestivalWindowVisible"]["value"] = settings["isFestivalWindowVisible"]["value"];
    settings["isLotroWindowVisible"]["value"] = settings["isLotroWindowVisible"]["value"];
    settings["isToBeSurWindowVisible"]["value"] = settings["isToBeSurWindowVisible"]["value"];

    settings["wasAltHolicBarVisible"]["value"] = settings["wasAltHolicBarVisible"]["value"];
    settings["wasAltHolicWindowVisible"]["value"] = settings["wasAltHolicWindowVisible"]["value"];
    -- end new from here
    settings["ShowHideReput"]["value"] = settings["ShowHideReput"]["value"];
    settings["iconSize"]["value"] = tonumber(settings["iconSize"]["value"]);
    settings["displayIcon"]["value"] = settings["displayIcon"]["value"];

    settings["isShowVaultVisible"]["isShowVaultVisible"] = settings["isShowVaultVisible"]["isShowVaultVisible"];
    settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = settings["isOptionsWindowVisible"]["isOptionsWindowVisible"];
    settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"];
    settings["OptionsWindowVoc"]["value"] = settings["OptionsWindowVoc"]["value"];
    settings["isShowWalletVisible"]["isShowWalletVisible"] = settings["isShowWalletVisible"]["isShowWalletVisible"];
	settings["escEnable"]["escEnable"] = settings["escEnable"]["escEnable"];
    settings["altEnable"]["altEnable"] = settings["altEnable"]["altEnable"];
    settings["isShowStatsVisible"]["isShowStatsVisible"] = settings["isShowStatsVisible"]["isShowStatsVisible"];
    settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"] = settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"];
    
    settings["nameAccount"]["account1"] = settings["nameAccount"]["account1"];
    settings["sessionCash"]["cashStart"] = settings["sessionCash"]["cashStart"];
    settings["sessionCash"]["cashSession"] = settings["sessionCash"]["cashSession"];
    settings["sessionCash"]["cashSpent"] = settings["sessionCash"]["cashSpent"];
    settings["verbose"]["value"] = settings["verbose"]["value"];
    settings["displaySpentCash"]["value"] = settings["displaySpentCash"]["value"];
    settings["displayLvlMax"]["value"] = settings["displayLvlMax"]["value"];
    settings["displayTotalCash"]["value"] = settings["displayTotalCash"]["value"];
    settings["showProgressReput"]["value"] = settings["showProgressReput"]["value"]

    settings["dailyCash"]["cashDaily"] = settings["dailyCash"]["cashDaily"];
    settings["dailyCash"]["cashSpent"] = settings["dailyCash"]["cashSpent"];
    settings["dailyCash"]["jour"] = settings["dailyCash"]["jour"];
    settings["dailyCash"]["mois"] = settings["dailyCash"]["mois"];
    settings["dailyCash"]["annee"] = settings["dailyCash"]["annee"];

    settings["lotroCoins"]["value"] = settings["lotroCoins"]["value"];
    settings["sharedStorageCash"]["value"] = tonumber(settings["sharedStorageCash"]["value"]);

    settings["displayServers"]["value"] = settings["displayServers"]["value"];
    settings["serversToDisplay"]["value"] = settings["serversToDisplay"]["value"];
    settings["displayDeleteIcon"]["value"] = settings["displayDeleteIcon"]["value"];
    settings["displayBarWindow"]["value"] = settings["displayBarWindow"]["value"];

    settings["displayTokensIcon"]["value"] = settings["displayTokensIcon"]["value"];
    settings["displayBarIcon2"]["value"] = settings["displayBarIcon2"]["value"];
    settings["displayBarIcon3"]["value"] = settings["displayBarIcon3"]["value"];
    settings["displayBarIcon4"]["value"] = settings["displayBarIcon4"]["value"];
    settings["displayBarIcon5"]["value"] = settings["displayBarIcon5"]["value"];
    settings["displayBarIcon6"]["value"] = settings["displayBarIcon6"]["value"];
    settings["displayBarIcon7"]["value"] = settings["displayBarIcon7"]["value"];
    settings["displayBarIcon8"]["value"] = settings["displayBarIcon8"]["value"];
    settings["displayBarIcon9"]["value"] = settings["displayBarIcon9"]["value"];
    settings["displayBarIcon10"]["value"] = settings["displayBarIcon10"]["value"];
    settings["displayBarIcon11"]["value"] = settings["displayBarIcon11"]["value"];
    settings["displayBarIcon12"]["value"] = settings["displayBarIcon12"]["value"];
    settings["displayBarIcon13"]["value"] = settings["displayBarIcon13"]["value"];
    settings["displayBarIcon14"]["value"] = settings["displayBarIcon14"]["value"];
    settings["displayBarIcon15"]["value"] = settings["displayBarIcon15"]["value"];
    settings["displayBarIcon16"]["value"] = settings["displayBarIcon16"]["value"];

    settings["displayBarBagSize"]["value"] = settings["displayBarBagSize"]["value"];

	PatchDataSave( dataScope, settingsFileName, settings);
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
-- create or load the settings for player vocation
------------------------------------------------------------------------------------------
function ReturnPlayerVocation()
    PlayerDatas = PatchDataLoad(dataScope, settingsDatasFileName, PlayerDatas);

    if (PlayerDatas == nil)then 
        PlayerDatas = {}; 
    end

    if (PlayerDatas[PlayerName] == nil)then 
        PlayerDatas[PlayerName] = {}; 
    end

    return PlayerDatas[PlayerName].voc;
end

------------------------------------------------------------------------------------------
-- create the save settings for player datas
------------------------------------------------------------------------------------------
function SavePlayerDatas()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    PlayerDatas[PlayerName] = {};

    PlayerDatas[PlayerName].cla = PlayerClass;
    PlayerDatas[PlayerName].lvl = Player:GetLevel();
    PlayerDatas[PlayerName].voc = PlayerVoc;
    PlayerDatas[PlayerName].rac = PlayerRace;
    PlayerDatas[PlayerName].cash = PlayerAttr:GetMoney();
    PlayerDatas[PlayerName].bagCash = tonumber(CompteBagGold());
    PlayerDatas[PlayerName].vaultCash = tonumber(CompteVaultGold());
    PlayerDatas[PlayerName].align = PlayerAlignement;
    PlayerDatas[PlayerName].sexe = PlayerSexe[PlayerName];
    PlayerDatas[PlayerName].xp = tonumber(PlayerXp[PlayerName]);

    -- statistical part
    PlayerDatas[PlayerName].moral = tonumber(Player:GetMorale());
    PlayerDatas[PlayerName].maxMoral = tonumber(Player:GetMaxMorale());
    PlayerDatas[PlayerName].power = tonumber(Player:GetPower());
    PlayerDatas[PlayerName].maxPower = tonumber(Player:GetMaxPower());

    -- server part
    PlayerDatas[PlayerName].serverName = PlayerServer[PlayerName];

    -- do not save for monsterplay
    if(PlayerDatas[PlayerName].align == 1)then
        PlayerDatas[PlayerName].armure = tonumber(PlayerAttr:GetArmor());
        PlayerDatas[PlayerName].agility = tonumber(PlayerAttr:GetAgility());
        PlayerDatas[PlayerName].fate = tonumber(PlayerAttr:GetFate());
        PlayerDatas[PlayerName].might = tonumber(PlayerAttr:GetMight());
        PlayerDatas[PlayerName].vitality = tonumber(PlayerAttr:GetVitality());
        PlayerDatas[PlayerName].will = tonumber(PlayerAttr:GetWill());

        -- large stats
        PlayerDatas[PlayerName].critA = tonumber(PlayerAttr:GetBaseCriticalHitChance());
        PlayerDatas[PlayerName].fines = tonumber(PlayerAttr:GetFinesse());
        PlayerDatas[PlayerName].meleD = tonumber(PlayerAttr:GetMeleeDamage());
        PlayerDatas[PlayerName].tactD = tonumber(PlayerAttr:GetTacticalDamage());
        PlayerDatas[PlayerName].degaP = tonumber(PlayerAttr:GetCommonMitigation());
        PlayerDatas[PlayerName].degaT = tonumber(PlayerAttr:GetTacticalMitigation());
        PlayerDatas[PlayerName].defeC = tonumber(PlayerAttr:GetBaseCriticalHitAvoidance());
        PlayerDatas[PlayerName].resis = tonumber(PlayerAttr:GetBaseResistance());
        PlayerDatas[PlayerName].bloqu = tonumber(PlayerAttr:GetBlock());
        PlayerDatas[PlayerName].parad = tonumber(PlayerAttr:GetParry());
        PlayerDatas[PlayerName].esqui = tonumber(PlayerAttr:GetEvade());
        PlayerDatas[PlayerName].healD = tonumber(PlayerAttr:GetOutgoingHealing());
        PlayerDatas[PlayerName].healR = tonumber(PlayerAttr:GetIncomingHealing());
        -- new stats
        PlayerDatas[PlayerName].orc = tonumber(PlayerAttr:GetPhysicalMitigation());
        PlayerDatas[PlayerName].range = tonumber(PlayerAttr:GetRangeDamage());
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
function SavePlayerSexeForSpecialCharacters(namePlayerToSave)

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

    backpackSize = backpack:GetSize();

    PlayerBags[PlayerName] = {};

    slot = 1;
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
            PlayerBags[PlayerName][ind].BS = tostring(backpack:GetSize());

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

    vaultpackSize = vaultpack:GetCapacity();
    vaultpackCount = vaultpack:GetCount();

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

    if (PlayerEquipement == nil)then 
        PlayerEquipement = {}; 
    end
    if (PlayerEquipement[PlayerName] == nil)then 
        PlayerEquipement[PlayerName] = {};         
    end

    if (PlayerEquipement[PlayerName].Back == nil)then 
        PlayerEquipement[PlayerName].Back = {};   
    end
    if (PlayerEquipement[PlayerName].Boots == nil)then 
        PlayerEquipement[PlayerName].Boots = {};   
    end
    if (PlayerEquipement[PlayerName].Bracelet1 == nil)then 
        PlayerEquipement[PlayerName].Bracelet1 = {};  
    end
    if (PlayerEquipement[PlayerName].Bracelet2 == nil)then 
        PlayerEquipement[PlayerName].Bracelet2 = {};    
    end
    if (PlayerEquipement[PlayerName].Chest == nil)then 
        PlayerEquipement[PlayerName].Chest = {};   
    end
    if (PlayerEquipement[PlayerName].ClassE == nil)then 
        PlayerEquipement[PlayerName].ClassE = {};  
    end
    if (PlayerEquipement[PlayerName].CraftTool == nil)then 
        PlayerEquipement[PlayerName].CraftTool = {};     
    end
    if (PlayerEquipement[PlayerName].Earring1 == nil)then 
        PlayerEquipement[PlayerName].Earring1 = {};    
    end
    if (PlayerEquipement[PlayerName].Earring2 == nil)then 
        PlayerEquipement[PlayerName].Earring2 = {};   
    end
    if (PlayerEquipement[PlayerName].Gloves == nil)then 
        PlayerEquipement[PlayerName].Gloves = {};    
    end
    if (PlayerEquipement[PlayerName].Head == nil)then 
        PlayerEquipement[PlayerName].Head = {};  
    end
    if (PlayerEquipement[PlayerName].Legs == nil)then 
        PlayerEquipement[PlayerName].Legs = {};     
    end
    if (PlayerEquipement[PlayerName].Necklace == nil)then 
        PlayerEquipement[PlayerName].Necklace = {}; 
    end
    if (PlayerEquipement[PlayerName].Pocket == nil)then 
        PlayerEquipement[PlayerName].Pocket = {};   
    end
    if (PlayerEquipement[PlayerName].PrimaryWeapon == nil)then 
        PlayerEquipement[PlayerName].PrimaryWeapon = {};   
    end
    if (PlayerEquipement[PlayerName].RangedWeapon == nil)then 
        PlayerEquipement[PlayerName].RangedWeapon = {};   
    end
    if (PlayerEquipement[PlayerName].Ring1 == nil)then 
        PlayerEquipement[PlayerName].Ring1 = {};    
    end
    if (PlayerEquipement[PlayerName].Ring2 == nil)then 
        PlayerEquipement[PlayerName].Ring2 = {};    
    end
    if (PlayerEquipement[PlayerName].Shield == nil)then 
        PlayerEquipement[PlayerName].Shield = {};    
    end
    if (PlayerEquipement[PlayerName].Shoulder == nil)then 
        PlayerEquipement[PlayerName].Shoulder = {};  
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for equipment
------------------------------------------------------------------------------------------
function SavePlayerEquipment()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    PlayerEquipement[PlayerName].Back = {};
    PlayerEquipement[PlayerName].Boots = {};
    PlayerEquipement[PlayerName].Bracelet1 = {};
    PlayerEquipement[PlayerName].Bracelet2 = {};
    PlayerEquipement[PlayerName].Chest = {};
    PlayerEquipement[PlayerName].ClassE = {};
    PlayerEquipement[PlayerName].CraftTool = {};
    PlayerEquipement[PlayerName].Earring1 = {};
    PlayerEquipement[PlayerName].Earring2 = {};
    PlayerEquipement[PlayerName].Gloves = {};
    PlayerEquipement[PlayerName].Head = {};
    PlayerEquipement[PlayerName].Legs = {};
    PlayerEquipement[PlayerName].Necklace = {};
    PlayerEquipement[PlayerName].Pocket = {};
    PlayerEquipement[PlayerName].PrimaryWeapon = {};
    PlayerEquipement[PlayerName].RangedWeapon = {};
    PlayerEquipement[PlayerName].Ring1 = {};
    PlayerEquipement[PlayerName].Ring2 = {};
    PlayerEquipement[PlayerName].Shield = {};
    PlayerEquipement[PlayerName].Shoulder = {};

    if(PlayerEquip:GetItem(1) ~= nil)then
        PlayerEquipement[PlayerName].Head.D = PlayerEquip:GetItem(1):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Head.Q = PlayerEquip:GetItem(1):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Head.B = PlayerEquip:GetItem(1):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Head.U = PlayerEquip:GetItem(1):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Head.S = PlayerEquip:GetItem(1):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Head.I = PlayerEquip:GetItem(1):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Head.N = PlayerEquip:GetItem(1):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Head.QA = PlayerEquip:GetItem(1):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Head.DU = PlayerEquip:GetItem(1):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Head.CAT = PlayerEquip:GetItem(1):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Head.WS = PlayerEquip:GetItem(1):GetWearState();

        if(PlayerEquipItems[PlayerName].HeadN ~= PlayerEquip:GetItem(1):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Head = 0;
            PlayerEquipArmor[PlayerName].Head = 0;
            PlayerEquipItems[PlayerName].HeadN = PlayerEquip:GetItem(1):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Head ~= 0)then
            PlayerEquipement[PlayerName].Head.lvl = PlayerEquipItems[PlayerName].Head;
        end
        if(PlayerEquipArmor[PlayerName].Head ~= 0)then
            PlayerEquipement[PlayerName].Head.armor = PlayerEquipArmor[PlayerName].Head;
        end
    end
    if(PlayerEquip:GetItem(2) ~= nil)then
        PlayerEquipement[PlayerName].Chest.D = PlayerEquip:GetItem(2):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Chest.Q = PlayerEquip:GetItem(2):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Chest.B = PlayerEquip:GetItem(2):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Chest.U = PlayerEquip:GetItem(2):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Chest.S = PlayerEquip:GetItem(2):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Chest.I = PlayerEquip:GetItem(2):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Chest.N = PlayerEquip:GetItem(2):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Chest.QA = PlayerEquip:GetItem(2):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Chest.DU = PlayerEquip:GetItem(2):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Chest.CAT = PlayerEquip:GetItem(2):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Chest.WS = PlayerEquip:GetItem(2):GetWearState();

        if(PlayerEquipItems[PlayerName].ChestN ~= PlayerEquip:GetItem(2):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Chest = 0;
            PlayerEquipArmor[PlayerName].Chest = 0;
            PlayerEquipItems[PlayerName].ChestN = PlayerEquip:GetItem(2):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Chest ~= 0)then
            PlayerEquipement[PlayerName].Chest.lvl = PlayerEquipItems[PlayerName].Chest;
        end
        if(PlayerEquipArmor[PlayerName].Chest ~= 0)then
            PlayerEquipement[PlayerName].Chest.armor = PlayerEquipArmor[PlayerName].Chest;
        end
    end
    if(PlayerEquip:GetItem(3) ~= nil)then
        PlayerEquipement[PlayerName].Legs.D = PlayerEquip:GetItem(3):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Legs.Q = PlayerEquip:GetItem(3):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Legs.B = PlayerEquip:GetItem(3):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Legs.U = PlayerEquip:GetItem(3):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Legs.S = PlayerEquip:GetItem(3):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Legs.I = PlayerEquip:GetItem(3):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Legs.N = PlayerEquip:GetItem(3):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Legs.QA = PlayerEquip:GetItem(3):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Legs.DU = PlayerEquip:GetItem(3):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Legs.CAT = PlayerEquip:GetItem(3):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Legs.WS = PlayerEquip:GetItem(3):GetWearState();
  
        if(PlayerEquipItems[PlayerName].LegsN ~= PlayerEquip:GetItem(3):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Legs = 0;
            PlayerEquipArmor[PlayerName].Legs = 0;
            PlayerEquipItems[PlayerName].LegsN = PlayerEquip:GetItem(3):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Legs ~= 0)then
            PlayerEquipement[PlayerName].Legs.lvl = PlayerEquipItems[PlayerName].Legs;
        end
        if(PlayerEquipArmor[PlayerName].Legs ~= 0)then
            PlayerEquipement[PlayerName].Legs.armor = PlayerEquipArmor[PlayerName].Legs;
        end
    end
    if(PlayerEquip:GetItem(4) ~= nil)then
        PlayerEquipement[PlayerName].Gloves.D = PlayerEquip:GetItem(4):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Gloves.Q = PlayerEquip:GetItem(4):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Gloves.B = PlayerEquip:GetItem(4):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Gloves.U = PlayerEquip:GetItem(4):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Gloves.S = PlayerEquip:GetItem(4):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Gloves.I = PlayerEquip:GetItem(4):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Gloves.N = PlayerEquip:GetItem(4):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Gloves.QA = PlayerEquip:GetItem(4):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Gloves.DU = PlayerEquip:GetItem(4):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Gloves.CAT = PlayerEquip:GetItem(4):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Gloves.WS = PlayerEquip:GetItem(4):GetWearState();

        if(PlayerEquipItems[PlayerName].GlovesN ~= PlayerEquip:GetItem(4):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Gloves = 0;
            PlayerEquipArmor[PlayerName].Gloves = 0;
            PlayerEquipItems[PlayerName].GlovesN = PlayerEquip:GetItem(4):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Gloves ~= 0)then
            PlayerEquipement[PlayerName].Gloves.lvl = PlayerEquipItems[PlayerName].Gloves;
        end
        if(PlayerEquipArmor[PlayerName].Gloves ~= 0)then
            PlayerEquipement[PlayerName].Gloves.armor = PlayerEquipArmor[PlayerName].Gloves;
        end
    end
    if(PlayerEquip:GetItem(5) ~= nil)then
        PlayerEquipement[PlayerName].Boots.D = PlayerEquip:GetItem(5):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Boots.Q = PlayerEquip:GetItem(5):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Boots.B = PlayerEquip:GetItem(5):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Boots.U = PlayerEquip:GetItem(5):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Boots.S = PlayerEquip:GetItem(5):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Boots.I = PlayerEquip:GetItem(5):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Boots.N = PlayerEquip:GetItem(5):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Boots.QA = PlayerEquip:GetItem(5):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Boots.DU = PlayerEquip:GetItem(5):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Boots.CAT = PlayerEquip:GetItem(5):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Boots.WS = PlayerEquip:GetItem(5):GetWearState();

        if(PlayerEquipItems[PlayerName].BootsN ~= PlayerEquip:GetItem(5):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Boots = 0;
            PlayerEquipArmor[PlayerName].Boots = 0;
            PlayerEquipItems[PlayerName].BootsN = PlayerEquip:GetItem(5):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Boots ~= 0)then
            PlayerEquipement[PlayerName].Boots.lvl = PlayerEquipItems[PlayerName].Boots;
        end
        if(PlayerEquipArmor[PlayerName].Boots ~= 0)then
            PlayerEquipement[PlayerName].Boots.armor = PlayerEquipArmor[PlayerName].Boots;
        end
    end
    if(PlayerEquip:GetItem(6) ~= nil)then
        PlayerEquipement[PlayerName].Shoulder.D = PlayerEquip:GetItem(6):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Shoulder.Q = PlayerEquip:GetItem(6):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Shoulder.B = PlayerEquip:GetItem(6):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Shoulder.U = PlayerEquip:GetItem(6):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Shoulder.S = PlayerEquip:GetItem(6):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Shoulder.I = PlayerEquip:GetItem(6):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Shoulder.N = PlayerEquip:GetItem(6):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Shoulder.QA = PlayerEquip:GetItem(6):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Shoulder.DU = PlayerEquip:GetItem(6):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Shoulder.CAT = PlayerEquip:GetItem(6):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Shoulder.WS = PlayerEquip:GetItem(6):GetWearState();

        if(PlayerEquipItems[PlayerName].ShoulderN ~= PlayerEquip:GetItem(6):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Shoulder = 0;
            PlayerEquipArmor[PlayerName].Shoulder = 0;
            PlayerEquipItems[PlayerName].ShoulderN = PlayerEquip:GetItem(6):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Shoulder ~= 0)then
            PlayerEquipement[PlayerName].Shoulder.lvl = PlayerEquipItems[PlayerName].Shoulder;
        end
        if(PlayerEquipArmor[PlayerName].Shoulder ~= 0)then
            PlayerEquipement[PlayerName].Shoulder.armor = PlayerEquipArmor[PlayerName].Shoulder;
        end
    end
    if(PlayerEquip:GetItem(7) ~= nil)then
        PlayerEquipement[PlayerName].Back.D = PlayerEquip:GetItem(7):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Back.Q = PlayerEquip:GetItem(7):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Back.B = PlayerEquip:GetItem(7):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Back.U = PlayerEquip:GetItem(7):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Back.S = PlayerEquip:GetItem(7):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Back.I = PlayerEquip:GetItem(7):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Back.N = PlayerEquip:GetItem(7):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Back.QA = PlayerEquip:GetItem(7):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Back.DU = PlayerEquip:GetItem(7):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Back.CAT = PlayerEquip:GetItem(7):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Back.WS = PlayerEquip:GetItem(7):GetWearState();

        if(PlayerEquipItems[PlayerName].BackN ~= PlayerEquip:GetItem(7):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Back = 0;
            PlayerEquipArmor[PlayerName].Back = 0;
            PlayerEquipItems[PlayerName].BackN = PlayerEquip:GetItem(7):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Back ~= 0)then
            PlayerEquipement[PlayerName].Back.lvl = PlayerEquipItems[PlayerName].Back;
        end
        if(PlayerEquipArmor[PlayerName].Back ~= 0)then
            PlayerEquipement[PlayerName].Back.armor = PlayerEquipArmor[PlayerName].Back;
        end
    end
    if(PlayerEquip:GetItem(8) ~= nil)then
        PlayerEquipement[PlayerName].Bracelet1.D = PlayerEquip:GetItem(8):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Bracelet1.Q = PlayerEquip:GetItem(8):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Bracelet1.B = PlayerEquip:GetItem(8):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Bracelet1.U = PlayerEquip:GetItem(8):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Bracelet1.S = PlayerEquip:GetItem(8):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Bracelet1.I = PlayerEquip:GetItem(8):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Bracelet1.N = PlayerEquip:GetItem(8):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Bracelet1.QA = PlayerEquip:GetItem(8):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Bracelet1.DU = PlayerEquip:GetItem(8):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Bracelet1.CAT = PlayerEquip:GetItem(8):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Bracelet1.WS = PlayerEquip:GetItem(8):GetWearState();

        if(PlayerEquipItems[PlayerName].Bracelet1N ~= PlayerEquip:GetItem(8):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Bracelet1 = 0;
            PlayerEquipArmor[PlayerName].Bracelet1 = 0;
            PlayerEquipItems[PlayerName].Bracelet1N = PlayerEquip:GetItem(8):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Bracelet1 ~= 0)then
            PlayerEquipement[PlayerName].Bracelet1.lvl = PlayerEquipItems[PlayerName].Bracelet1;
        end
        if(PlayerEquipArmor[PlayerName].Bracelet1 ~= 0)then
            PlayerEquipement[PlayerName].Bracelet1.armor = PlayerEquipArmor[PlayerName].Bracelet1;
        end
    end
    if(PlayerEquip:GetItem(9) ~= nil)then
        PlayerEquipement[PlayerName].Bracelet2.D = PlayerEquip:GetItem(9):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Bracelet2.Q = PlayerEquip:GetItem(9):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Bracelet2.B = PlayerEquip:GetItem(9):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Bracelet2.U = PlayerEquip:GetItem(9):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Bracelet2.S = PlayerEquip:GetItem(9):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Bracelet2.I = PlayerEquip:GetItem(9):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Bracelet2.N = PlayerEquip:GetItem(9):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Bracelet2.QA = PlayerEquip:GetItem(9):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Bracelet2.DU = PlayerEquip:GetItem(9):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Bracelet2.CAT = PlayerEquip:GetItem(9):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Bracelet2.WS = PlayerEquip:GetItem(9):GetWearState();

        if(PlayerEquipItems[PlayerName].Bracelet2N ~= PlayerEquip:GetItem(9):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Bracelet2 = 0;
            PlayerEquipArmor[PlayerName].Bracelet2 = 0;
            PlayerEquipItems[PlayerName].Bracelet2N = PlayerEquip:GetItem(9):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Bracelet2 ~= 0)then
            PlayerEquipement[PlayerName].Bracelet2.lvl = PlayerEquipItems[PlayerName].Bracelet2;
        end
        if(PlayerEquipArmor[PlayerName].Bracelet2 ~= 0)then
            PlayerEquipement[PlayerName].Bracelet2.armor = PlayerEquipArmor[PlayerName].Bracelet2;
        end
    end
    if(PlayerEquip:GetItem(10) ~= nil)then
        PlayerEquipement[PlayerName].Necklace.D = PlayerEquip:GetItem(10):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Necklace.Q = PlayerEquip:GetItem(10):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Necklace.B = PlayerEquip:GetItem(10):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Necklace.U = PlayerEquip:GetItem(10):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Necklace.S = PlayerEquip:GetItem(10):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Necklace.I = PlayerEquip:GetItem(10):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Necklace.N = PlayerEquip:GetItem(10):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Necklace.QA = PlayerEquip:GetItem(10):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Necklace.DU = PlayerEquip:GetItem(10):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Necklace.CAT = PlayerEquip:GetItem(10):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Necklace.WS = PlayerEquip:GetItem(10):GetWearState();

        if(PlayerEquipItems[PlayerName].NecklaceN ~= PlayerEquip:GetItem(10):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Necklace = 0;
            PlayerEquipArmor[PlayerName].Necklace = 0;
            PlayerEquipItems[PlayerName].NecklaceN = PlayerEquip:GetItem(10):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Necklace ~= 0)then
            PlayerEquipement[PlayerName].Necklace.lvl = PlayerEquipItems[PlayerName].Necklace;
        end
        if(PlayerEquipArmor[PlayerName].Necklace ~= 0)then
            PlayerEquipement[PlayerName].Necklace.armor = PlayerEquipArmor[PlayerName].Necklace;
        end
    end
    if(PlayerEquip:GetItem(11) ~= nil)then
        PlayerEquipement[PlayerName].Ring1.D = PlayerEquip:GetItem(11):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Ring1.Q = PlayerEquip:GetItem(11):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Ring1.B = PlayerEquip:GetItem(11):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Ring1.U = PlayerEquip:GetItem(11):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Ring1.S = PlayerEquip:GetItem(11):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Ring1.I = PlayerEquip:GetItem(11):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Ring1.N = PlayerEquip:GetItem(11):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Ring1.QA = PlayerEquip:GetItem(11):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Ring1.DU = PlayerEquip:GetItem(11):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Ring1.CAT = PlayerEquip:GetItem(11):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Ring1.WS = PlayerEquip:GetItem(11):GetWearState();

        if(PlayerEquipItems[PlayerName].Ring1N ~= PlayerEquip:GetItem(11):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Ring1 = 0;
            PlayerEquipArmor[PlayerName].Ring1 = 0;
            PlayerEquipItems[PlayerName].Ring1N = PlayerEquip:GetItem(11):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Ring1 ~= 0)then
            PlayerEquipement[PlayerName].Ring1.lvl = PlayerEquipItems[PlayerName].Ring1;
        end
        if(PlayerEquipArmor[PlayerName].Ring1 ~= 0)then
            PlayerEquipement[PlayerName].Ring1.armor = PlayerEquipArmor[PlayerName].Ring1;
        end
    end
    if(PlayerEquip:GetItem(12) ~= nil)then
        PlayerEquipement[PlayerName].Ring2.D = PlayerEquip:GetItem(12):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Ring2.Q = PlayerEquip:GetItem(12):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Ring2.B = PlayerEquip:GetItem(12):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Ring2.U = PlayerEquip:GetItem(12):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Ring2.S = PlayerEquip:GetItem(12):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Ring2.I = PlayerEquip:GetItem(12):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Ring2.N = PlayerEquip:GetItem(12):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Ring2.QA = PlayerEquip:GetItem(12):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Ring2.DU = PlayerEquip:GetItem(12):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Ring2.CAT = PlayerEquip:GetItem(12):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Ring2.WS = PlayerEquip:GetItem(12):GetWearState();

        if(PlayerEquipItems[PlayerName].Ring2N ~= PlayerEquip:GetItem(12):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Ring2 = 0;
            PlayerEquipArmor[PlayerName].Ring2 = 0;
            PlayerEquipItems[PlayerName].Ring2N = PlayerEquip:GetItem(12):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Ring2 ~= 0)then
            PlayerEquipement[PlayerName].Ring2.lvl = PlayerEquipItems[PlayerName].Ring2;
        end
        if(PlayerEquipArmor[PlayerName].Ring2 ~= 0)then
            PlayerEquipement[PlayerName].Ring2.armor = PlayerEquipArmor[PlayerName].Ring2;
        end
    end
    if(PlayerEquip:GetItem(13) ~= nil)then
        PlayerEquipement[PlayerName].Earring1.D = PlayerEquip:GetItem(13):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Earring1.Q = PlayerEquip:GetItem(13):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Earring1.B = PlayerEquip:GetItem(13):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Earring1.U = PlayerEquip:GetItem(13):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Earring1.S = PlayerEquip:GetItem(13):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Earring1.I = PlayerEquip:GetItem(13):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Earring1.N = PlayerEquip:GetItem(13):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Earring1.QA = PlayerEquip:GetItem(13):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Earring1.DU = PlayerEquip:GetItem(13):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Earring1.CAT = PlayerEquip:GetItem(13):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Earring1.WS = PlayerEquip:GetItem(13):GetWearState();

        if(PlayerEquipItems[PlayerName].Earring1N ~= PlayerEquip:GetItem(13):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Earring1 = 0;
            PlayerEquipArmor[PlayerName].Earring1 = 0;
            PlayerEquipItems[PlayerName].Earring1N = PlayerEquip:GetItem(13):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Earring1 ~= 0)then
            PlayerEquipement[PlayerName].Earring1.lvl = PlayerEquipItems[PlayerName].Earring1;
        end
        if(PlayerEquipArmor[PlayerName].Earring1 ~= 0)then
            PlayerEquipement[PlayerName].Earring1.armor = PlayerEquipArmor[PlayerName].Earring1;
        end
    end
    if(PlayerEquip:GetItem(14) ~= nil)then
        PlayerEquipement[PlayerName].Earring2.D = PlayerEquip:GetItem(14):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Earring2.Q = PlayerEquip:GetItem(14):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Earring2.B = PlayerEquip:GetItem(14):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Earring2.U = PlayerEquip:GetItem(14):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Earring2.S = PlayerEquip:GetItem(14):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Earring2.I = PlayerEquip:GetItem(14):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Earring2.N = PlayerEquip:GetItem(14):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Earring2.QA = PlayerEquip:GetItem(14):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Earring2.DU = PlayerEquip:GetItem(14):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Earring2.CAT = PlayerEquip:GetItem(14):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Earring2.WS = PlayerEquip:GetItem(14):GetWearState();

        if(PlayerEquipItems[PlayerName].Earring2N ~= PlayerEquip:GetItem(14):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Earring2 = 0;
            PlayerEquipArmor[PlayerName].Earring2 = 0;
            PlayerEquipItems[PlayerName].Earring2N = PlayerEquip:GetItem(14):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Earring2 ~= 0)then
            PlayerEquipement[PlayerName].Earring2.lvl = PlayerEquipItems[PlayerName].Earring2;
        end
        if(PlayerEquipArmor[PlayerName].Earring2 ~= 0)then
            PlayerEquipement[PlayerName].Earring2.armor = PlayerEquipArmor[PlayerName].Earring2;
        end
    end
    if(PlayerEquip:GetItem(15) ~= nil)then
        PlayerEquipement[PlayerName].Pocket.D = PlayerEquip:GetItem(15):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Pocket.Q = PlayerEquip:GetItem(15):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Pocket.B = PlayerEquip:GetItem(15):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Pocket.U = PlayerEquip:GetItem(15):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Pocket.S = PlayerEquip:GetItem(15):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Pocket.I = PlayerEquip:GetItem(15):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Pocket.N = PlayerEquip:GetItem(15):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Pocket.QA = PlayerEquip:GetItem(15):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Pocket.DU = PlayerEquip:GetItem(15):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Pocket.CAT = PlayerEquip:GetItem(15):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Pocket.WS = PlayerEquip:GetItem(15):GetWearState();

        if(PlayerEquipItems[PlayerName].PocketN ~= PlayerEquip:GetItem(15):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Pocket = 0;
            PlayerEquipArmor[PlayerName].Pocket = 0;
            PlayerEquipItems[PlayerName].PocketN = PlayerEquip:GetItem(15):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Pocket ~= 0)then
            PlayerEquipement[PlayerName].Pocket.lvl = PlayerEquipItems[PlayerName].Pocket;
        end
        if(PlayerEquipArmor[PlayerName].Pocket ~= 0)then
            PlayerEquipement[PlayerName].Pocket.armor = PlayerEquipArmor[PlayerName].Pocket;
        end
    end
    if(PlayerEquip:GetItem(16) ~= nil)then
        PlayerEquipement[PlayerName].PrimaryWeapon.D = PlayerEquip:GetItem(16):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].PrimaryWeapon.Q = PlayerEquip:GetItem(16):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].PrimaryWeapon.B = PlayerEquip:GetItem(16):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].PrimaryWeapon.U = PlayerEquip:GetItem(16):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].PrimaryWeapon.S = PlayerEquip:GetItem(16):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].PrimaryWeapon.I = PlayerEquip:GetItem(16):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].PrimaryWeapon.N = PlayerEquip:GetItem(16):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].PrimaryWeapon.QA = PlayerEquip:GetItem(16):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].PrimaryWeapon.DU = PlayerEquip:GetItem(16):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].PrimaryWeapon.CAT = PlayerEquip:GetItem(16):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].PrimaryWeapon.WS = PlayerEquip:GetItem(16):GetWearState();

        if(PlayerEquipItems[PlayerName].PrimaryWeaponN ~= PlayerEquip:GetItem(16):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].PrimaryWeapon = 0;
            PlayerEquipArmor[PlayerName].PrimaryWeapon = 0;
            PlayerEquipItems[PlayerName].PrimaryWeaponN = PlayerEquip:GetItem(16):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].PrimaryWeapon ~= 0)then
            PlayerEquipement[PlayerName].PrimaryWeapon.lvl = PlayerEquipItems[PlayerName].PrimaryWeapon;
        end
        if(PlayerEquipArmor[PlayerName].PrimaryWeapon ~= 0)then
            PlayerEquipement[PlayerName].PrimaryWeapon.armor = PlayerEquipArmor[PlayerName].PrimaryWeapon;
        end
    end
    if(PlayerEquip:GetItem(17) ~= nil)then
        PlayerEquipement[PlayerName].Shield.D = PlayerEquip:GetItem(17):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].Shield.Q = PlayerEquip:GetItem(17):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].Shield.B = PlayerEquip:GetItem(17):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].Shield.U = PlayerEquip:GetItem(17):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].Shield.S = PlayerEquip:GetItem(17):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].Shield.I = PlayerEquip:GetItem(17):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].Shield.N = PlayerEquip:GetItem(17):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].Shield.QA = PlayerEquip:GetItem(17):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].Shield.DU = PlayerEquip:GetItem(17):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].Shield.CAT = PlayerEquip:GetItem(17):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].Shield.WS = PlayerEquip:GetItem(17):GetWearState();

        if(PlayerEquipItems[PlayerName].ShieldN ~= PlayerEquip:GetItem(17):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].Shield = 0;
            PlayerEquipArmor[PlayerName].Shield = 0;
            PlayerEquipItems[PlayerName].ShieldN = PlayerEquip:GetItem(17):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].Shield ~= 0)then
            PlayerEquipement[PlayerName].Shield.lvl = PlayerEquipItems[PlayerName].Shield;
        end
        if(PlayerEquipArmor[PlayerName].Shield ~= 0)then
            PlayerEquipement[PlayerName].Shield.armor = PlayerEquipArmor[PlayerName].Shield;
        end
    end
    if(PlayerEquip:GetItem(18) ~= nil)then
        PlayerEquipement[PlayerName].RangedWeapon.D = PlayerEquip:GetItem(18):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].RangedWeapon.Q = PlayerEquip:GetItem(18):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].RangedWeapon.B = PlayerEquip:GetItem(18):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].RangedWeapon.U = PlayerEquip:GetItem(18):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].RangedWeapon.S = PlayerEquip:GetItem(18):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].RangedWeapon.I = PlayerEquip:GetItem(18):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].RangedWeapon.N = PlayerEquip:GetItem(18):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].RangedWeapon.QA = PlayerEquip:GetItem(18):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].RangedWeapon.DU = PlayerEquip:GetItem(18):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].RangedWeapon.CAT = PlayerEquip:GetItem(18):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].RangedWeapon.WS = PlayerEquip:GetItem(18):GetWearState();

        if(PlayerEquipItems[PlayerName].RangedWeaponN ~= PlayerEquip:GetItem(18):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].RangedWeapon = 0;
            PlayerEquipArmor[PlayerName].RangedWeapon = 0;
            PlayerEquipItems[PlayerName].RangedWeaponN = PlayerEquip:GetItem(18):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].RangedWeapon ~= 0)then
            PlayerEquipement[PlayerName].RangedWeapon.lvl = PlayerEquipItems[PlayerName].RangedWeapon;
        end
        if(PlayerEquipArmor[PlayerName].RangedWeapon ~= 0)then
            PlayerEquipement[PlayerName].RangedWeapon.armor = PlayerEquipArmor[PlayerName].RangedWeapon;
        end
    end
    if(PlayerEquip:GetItem(19) ~= nil)then
        PlayerEquipement[PlayerName].CraftTool.D = PlayerEquip:GetItem(19):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].CraftTool.Q = PlayerEquip:GetItem(19):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].CraftTool.B = PlayerEquip:GetItem(19):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].CraftTool.U = PlayerEquip:GetItem(19):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].CraftTool.S = PlayerEquip:GetItem(19):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].CraftTool.I = PlayerEquip:GetItem(19):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].CraftTool.N = PlayerEquip:GetItem(19):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].CraftTool.QA = PlayerEquip:GetItem(19):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].CraftTool.DU = PlayerEquip:GetItem(19):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].CraftTool.CAT = PlayerEquip:GetItem(19):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].CraftTool.WS = PlayerEquip:GetItem(19):GetWearState();

        if(PlayerEquipItems[PlayerName].CraftToolN ~= PlayerEquip:GetItem(19):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].CraftTool = 0;
            PlayerEquipArmor[PlayerName].CraftTool = 0;
            PlayerEquipItems[PlayerName].CraftToolN = PlayerEquip:GetItem(19):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].CraftTool ~= 0)then
            PlayerEquipement[PlayerName].CraftTool.lvl = PlayerEquipItems[PlayerName].CraftTool;
        end
        if(PlayerEquipArmor[PlayerName].CraftTool ~= 0)then
            PlayerEquipement[PlayerName].CraftTool.armor = PlayerEquipArmor[PlayerName].CraftTool;
        end
    end
    if(PlayerEquip:GetItem(20) ~= nil)then
        PlayerEquipement[PlayerName].ClassE.D = PlayerEquip:GetItem(20):GetItemInfo():GetDescription();
        PlayerEquipement[PlayerName].ClassE.Q = PlayerEquip:GetItem(20):GetItemInfo():GetQualityImageID();
        PlayerEquipement[PlayerName].ClassE.B = PlayerEquip:GetItem(20):GetItemInfo():GetBackgroundImageID();
        PlayerEquipement[PlayerName].ClassE.U = PlayerEquip:GetItem(20):GetItemInfo():GetUnderlayImageID();
        PlayerEquipement[PlayerName].ClassE.S = PlayerEquip:GetItem(20):GetItemInfo():GetShadowImageID();
        PlayerEquipement[PlayerName].ClassE.I = PlayerEquip:GetItem(20):GetItemInfo():GetIconImageID();
        PlayerEquipement[PlayerName].ClassE.N = PlayerEquip:GetItem(20):GetItemInfo():GetName();
        PlayerEquipement[PlayerName].ClassE.QA = PlayerEquip:GetItem(20):GetItemInfo():GetQuality();
        PlayerEquipement[PlayerName].ClassE.DU = PlayerEquip:GetItem(20):GetItemInfo():GetDurability();
        PlayerEquipement[PlayerName].ClassE.CAT = PlayerEquip:GetItem(20):GetItemInfo():GetCategory();
        PlayerEquipement[PlayerName].ClassE.WS = PlayerEquip:GetItem(20):GetWearState();

        if(PlayerEquipItems[PlayerName].ClassEN ~= PlayerEquip:GetItem(20):GetItemInfo():GetName())then
            PlayerEquipItems[PlayerName].ClassE = 0;
            PlayerEquipArmor[PlayerName].ClassE = 0;
            PlayerEquipItems[PlayerName].ClassEN = PlayerEquip:GetItem(20):GetItemInfo():GetName()
        end

        if(PlayerEquipItems[PlayerName].ClassE ~= 0)then
            PlayerEquipement[PlayerName].ClassE.lvl = PlayerEquipItems[PlayerName].ClassE;
        end
        if(PlayerEquipArmor[PlayerName].ClassE ~= 0)then
            PlayerEquipement[PlayerName].ClassE.armor = PlayerEquipArmor[PlayerName].ClassE;
        end
    end

    PatchDataSave( dataScope, settingsEquipmentFileName, PlayerEquipement);
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

    sharedStorageSize = sspack:GetCapacity();
    sharedStorageCount = sspack:GetCount();

    SharedStorageVault = {};

    for slot = 1, sharedStorageCount do
        local ind = tostring(slot);
        SharedStorageVault[ind] = sspack:GetItem(slot);
        local iteminfo = SharedStorageVault[ind]:GetItemInfo();

        SharedStorageVault[ind].iteminfo = iteminfo;
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

    walletpackSize = walletpack:GetSize();

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

    val = tablelength(EpiqueVolume);

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

    val = tablelength(EpiqueVolume);

    test1 = {}; 
    test2 = {}; 
    test3 = {}; 

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
            PlayerReput[PlayerName]["Reput" .. valueReput].genre = 5; -- The Gabil'akkâ
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
            else
                PlayerReput[PlayerName]["Reput" .. i].value = PlayerReput[PlayerName]["Reput" .. i].value;
                PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position;
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
                PlayerReput[PlayerName]["Reput" .. i].genre = 5; -- The Gabil'akkâ
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
function SavePlayerInfos(i)
    --if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    PlayerInfos[i] = {};

    PlayerInfos[i].info = PlayerInformations;



    PatchDataSave( dataScope, settingsInfosFileName, PlayerInfos);
end
------------------------------------------------------------------------------------------
-- create or load the settings for player professions
------------------------------------------------------------------------------------------
function LoadPlayerProfessions()
    PlayerProfessions = PatchDataLoad(dataScope, settingsProfessionsFileName, PlayerProfessions);

    if (PlayerProfessions == nil)then 
        PlayerProfessions = {}; 
    end

    if (PlayerProfessions[PlayerName] == nil)then 
        PlayerProfessions[PlayerName] = {}; 
    end

    if (PlayerProfessions[PlayerName].name == nil)then 
        PlayerProfessions[PlayerName].name = {}; 
    end

    if (PlayerProfessions[PlayerName].CurrentLvl == nil)then 
        PlayerProfessions[PlayerName].CurrentLvl = {}; 
    end

    if (PlayerProfessions[PlayerName].currentMastery == nil)then 
        PlayerProfessions[PlayerName].currentMastery = {}; 
    end
end
------------------------------------------------------------------------------------------
-- create the save settings for player professions
------------------------------------------------------------------------------------------
function SavePlayerProfessions()
    if ( string.sub( PlayerName, 1, 1 ) == "~" )then return end; --Ignore session play

    PlayerProfessions[PlayerName] = {};
    PlayerProfessions[PlayerName].Name = {}; 
    PlayerProfessions[PlayerName].CurrentLvl = {}; 
    PlayerProfessions[PlayerName].currentMastery = {}; 

    PlayerProfessions[PlayerName].Name = ProfessionName;
    PlayerProfessions[PlayerName].CurrentLvl = currentLevel;
    PlayerProfessions[PlayerName].currentMastery = currentLevelMastery;

    PatchDataSave( dataScope, settingsProfessionsFileName, PlayerProfessions);
end