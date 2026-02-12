------------------------------------------------------------------------------------------
-- Init file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Plugin's name --
------------------------------------------------------------------------------------------
pluginName = "AltHolic";
------------------------------------------------------------------------------------------
-- datascope for account save --
------------------------------------------------------------------------------------------
dataScope = Turbine.DataScope.Account;
------------------------------------------------------------------------------------------
-- datascope for server save --
------------------------------------------------------------------------------------------
-- dataScope = Turbine.DataScope.Server;

-- (Français)
-- décommentez la ligne datascope au dessus  en enlevant le 2 -- au début pour stocker les données uniquement par serveur
-- et n'oubliez pas de commenter... en ajoutant 2 -- au début de la ligne du datascope
-- pour le compte, enregistrez puis déchargez et rechargez le plugin pour que le changement prenne effet

-- (English)
-- uncomment the line datascope upper from here by removing the 2 -- at the beggining to store the datas only by server
-- and do not forget to comment... adding 2 -- at the begginings of the line of the datascope
-- for account save then unload and reload the plugin for the change to take effect

-- (German)
-- Entkommentieren Sie die Datascope-Zeile oben, indem Sie die 2 entfernen -- am Anfang, um die Daten nur vom Server zu speichern
-- und vergessen Sie nicht zu kommentieren ... fügen Sie 2 hinzu -- am Anfang der Zeile des Datascope
-- für das Konto speichern, dann entladen und das Plugin neu laden, damit die Änderung wirksam wird
------------------------------------------------------------------------------------------
-- File names --
------------------------------------------------------------------------------------------
settingsFileName = "AltHolic_Settings";
settingsBagFileName = "AltHolic_Bags";
settingsEpiqueFileName = "AltHolic_EpiqueQuests";
settingsDatasFileName = "AltHolic_PlayerDatas";
settingsEquipmentFileName = "AltHolic_PlayerEquipement";
settingsInfosFileName = "AltHolic_PlayerInfos";
settingsProfessionsFileName = "AltHolic_PlayerProfessions";
settingsReputationsFileName = "AltHolic_Reputations";
settingsSharedStorageFileName = "AltHolic_SharedStorage";
settingsVaultsFileName = "AltHolic_Vaults";
settingsWalletFileName = "AltHolic_Wallet";
------------------------------------------------------------------------------------------
-- Default settings --
------------------------------------------------------------------------------------------
settings = {
    windowPosition = { 
        xPos = 500, 
        yPos = 500 
    },
    IconPosition = { 
        xPosIcon = 500, 
        yPosIcon = 500 
    },
    isMinimizeEnabled = { 
        isMinimizeEnabled = false 
    },
    isWindowVisible = { 
        isWindowVisible = true 
    },
    isShowBagVisible = { 
        isShowBagVisible = false   
    },
    isShowVaultVisible = { 
        isShowVaultVisible = false   
    },
    isShowWalletVisible = { 
        isShowWalletVisible = false   
    },
    isShowEquipmentVisible = { 
        isShowEquipmentVisible = false   
    },
    isShowSharedStorageVisible = { 
        isShowSharedStorageVisible = false   
    },
    isShowStatsVisible = { 
        isShowStatsVisible = false   
    },
    isServerWindowVisible = { 
        value = false   
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
    isLvlEquipWindowVisible = { 
        isLvlEquipWindowVisible = false 
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
    verbose = { 
        value = false 
    },
    lotroCoins = { 
        value = 0 
    },
    displayDurabilityColor = { 
        value = false 
    },
    displayLvlMax = { 
        value = false 
    },
    escEnable = { 
        escEnable = true 
    },
    altEnable = { 
        altEnable = true 
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
    displayBarWindow = { 
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
    displayTokensIcon = { 
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
        account1 = { name = "", nbrAlt = 0, isVisible = true}
    }
};
------------------------------------------------------------------------------------------
-- Resources settings --
------------------------------------------------------------------------------------------
ResourcePath = "Homeopatix/AltHolic/Resources/";

Images = {
	MinimizedIcon = ResourcePath .. "AltHolic.tga",
    TinyIcon = ResourcePath .. "AltHolicTiny.tga",
    TinyIcon24 = ResourcePath .. "AltHolicTiny24.tga",
    TinyIcon16 = ResourcePath .. "AltHolicTiny16.tga"
};
------------------------------------------------------------------------------------------
-- RGB color codes --
------------------------------------------------------------------------------------------
rgb = {
    start = "<rgb=#DAA520>",
    gold = "<rgb=#FFD700>",
    orange = "<rgb=#EE8F12>",
    white = "<rgb=#FFFFFF>",
    green = "<rgb=#1FE126>",
    blue = "<rgb=#1FCDE1>",
    purple = "<rgb=#9B41CE>",
    yellow = "<rgb=#FFFF00>",
    grey = "<rgb=#C7C7BE>",
    red = "<rgb=#FF0000>",
    error = "<rgb=#FF0000>",
    clear = "</rgb>"
};
------------------------------------------------------------------------------------------
-- Load settings --
------------------------------------------------------------------------------------------
LoadSettings();