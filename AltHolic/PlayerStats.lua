------------------------------------------------------------------------------------------
-- PlayerStats file: live-game handles, static game data and the startup data load
-- Written by Homeopatix, 26 january 2021 (updated 03.11.2023, reworked for 5.06)
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- Live game objects for the logged-in character
------------------------------------------------------------------------------------------
Player = Turbine.Gameplay.LocalPlayer.GetInstance();
vaultpack = Player:GetVault();
sspack = Player:GetSharedStorage();
walletpack = Player:GetWallet();
backpack = Player:GetBackpack();
PlayerName = Player:GetName();
PlayerAttr = Player:GetAttributes();
PlayerAlignement = Player:GetAlignment(); -- 1: Free Peoples / 2: Monster Play
PlayerEquip = Player:GetEquipment();
PlayerClass = Player:GetClass();
PlayerRace = Player:GetRace();

-- Per-character values edited at runtime (keyed by character name).
PlayerSexe = {};
PlayerXp = {};
PlayerServer = {};

-- Reputation values changed this session (keyed by faction index).
Reputations = {};
RepuPosition = {};
RepuName = {};

vaultHasBeenUpdated = false;
sharedStorageHasBeenUpdated = false;

Write = Turbine.Shell.WriteLine;
screenWidth, screenHeight = Turbine.UI.Display.GetSize();

------------------------------------------------------------------------------------------
-- Game data
------------------------------------------------------------------------------------------
LevelMax = 160;
TierMax = 16;
nbrFactions = 112;

-- Total experience needed to reach the next level (index = current level).
PlayerLevelXP = {
    [1]=100, [2]=275, [3]=550, [4]=950, [5]=1543, [6]=2395, [7]=3575, [8]=5150, [9]=7188, [10]=9798,
    [11]=13090, [12]=17175, [13]=22163, [14]=28163, [15]=35328, [16]=43810, [17]=53763, [18]=65338, [19]=78688, [20]=94008,
    [21]=111493, [22]=131338, [23]=153738, [24]=178888, [25]=207025, [26]=238388, [27]=273213, [28]=311738, [29]=354200, [30]=400880,
    [31]=452058, [32]=508013, [33]=569025, [34]=635375, [35]=707385, [36]=785378, [37]=869675, [38]=960600, [39]=1058475, [40]=1163665,
    [41]=1276535, [42]=1397450, [43]=1526775, [44]=1664875, [45]=1812158, [46]=1969030, [47]=2135900, [48]=2313175, [49]=2501263, [50]=2700613,
    [51]=2911675, [52]=3134900, [53]=3370738, [54]=3619638, [55]=3882093, [56]=4158595, [57]=4449638, [58]=4755713, [59]=5077313, [60]=5415226,
    [61]=5770277, [62]=6143336, [63]=6535316, [64]=6947176, [65]=7379926, [66]=7834624, [67]=8312383, [68]=8814374, [69]=9341823, [70]=9896024,
    [71]=10478333, [72]=11090176, [73]=11733051, [74]=12408532, [75]=13117787, [76]=13862504, [77]=14644456, [78]=15465505, [79]=16327606, [80]=17232812,
    [81]=18183278, [82]=19181267, [83]=20229155, [84]=21329437, [85]=22484733, [86]=23697793, [87]=24971506, [88]=26308904, [89]=27713171, [90]=29187651,
    [91]=30735855, [92]=32361469, [93]=34068363, [94]=35860601, [95]=37742450, [96]=39718391, [97]=41793129, [98]=43971603, [99]=46259000, [100]=48660766,
    [101]=51182620, [102]=53830566, [103]=56610909, [104]=59530269, [105]=62595597, [106]=65814191, [107]=69193714, [108]=72742213, [109]=76468136, [110]=80380355,
    [111]=84488184, [112]=88801404, [113]=93330285, [114]=98085610, [115]=103078701, [116]=108321446, [117]=113826328, [118]=119606454, [119]=125675586, [120]=132048174,
    [121]=138739391, [122]=145765168, [123]=153142233, [124]=160888151, [125]=169021364, [126]=177561237, [127]=186528103, [128]=195943312, [129]=205829281, [130]=216209548,
    [131]=227108828, [132]=238553072, [133]=250569528, [134]=263186806, [135]=276434947, [136]=290345495, [137]=304951570, [138]=320287948, [139]=336391144, [140]=353299499,
    [141]=371053271, [142]=389694731, [143]=409268264, [144]=429820473, [145]=451400292, [146]=474059101, [147]=497850850, [148]=522832186, [149]=549062588, [150]=576604510,
    [151]=605523528, [152]=635888496, [153]=667771712, [154]=701249088, [155]=736400332, [156]=773309138, [157]=812063384, [158]=852755342, [159]=895481897, [160]=0,
};

-- Current 64-bit game worlds (regular + Legendary).
ServerNames = {
    "Grond [EU]",
    "Sting",
    "Peregrin [RP]",
    "Meriadoc [EU-RP]",
    "Glamdring",
    "Orcrist [EU]",
    "Angmar",
    "Mordor [EU]",
};
nbrServers = #ServerNames;

------------------------------------------------------------------------------------------
-- Load all saved data (settings were already loaded by Init.lua)
------------------------------------------------------------------------------------------
LoadPlayerDatas();
LoadPlayerEquipment();
LoadPlayerVault();
LoadPlayerBags();
LoadSharedStorage();
LoadPlayerWallet();
LoadPlayerEpique();
LoadPlayerReputations();
LoadPlayerInfos();
LoadPlayerProfessions();

local currentData = PlayerDatas[PlayerName];
PlayerSexe[PlayerName] = currentData.sexe;
PlayerServer[PlayerName] = currentData.serverName;

if currentData.cash == nil or currentData.cash == "" or currentData.cash == 0 then
    currentData.cash = PlayerAttr:GetMoney();
end

-- Saved XP progress for every known character.
for name, data in pairs(PlayerDatas) do
    local xp = tonumber(data.xp) or 0;
    PlayerXp[name] = (xp > 0) and xp or 0;
end

-- The tiny launcher sizes only apply when the minimized launcher mode is enabled.
if settings["isMinimizeEnabled"]["isMinimizeEnabled"] == false then
    settings["iconSize"]["value"] = 64;
end

-- Snapshot the logged-in character right away.
SavePlayerBags();
SavePlayerDatas();
SavePlayerWallet();
RefreshCurrentPlayerProfessions(PlayerName, true);

------------------------------------------------------------------------------------------
-- Session / daily money tracking
------------------------------------------------------------------------------------------
settings["sessionCash"]["cashSpent"] = 0;
settings["sessionCash"]["cashSession"] = 0;
settings["sessionCash"]["cashStart"] = 0;

local today = Turbine.Engine.GetDate();
local dailyCash = settings["dailyCash"];
if dailyCash["jour"] ~= today.Day or dailyCash["mois"] ~= today.Month or dailyCash["annee"] ~= today.Year then
    dailyCash["cashDaily"] = 0;
    dailyCash["cashSpent"] = 0;
    dailyCash["jour"] = today.Day;
    dailyCash["mois"] = today.Month;
    dailyCash["annee"] = today.Year;
end

------------------------------------------------------------------------------------------
-- Equipment level/armour caches, seeded from the saved equipment records.
------------------------------------------------------------------------------------------
PlayerEquipItems = { [PlayerName] = {} };
PlayerEquipArmor = { [PlayerName] = {} };

local playerEquipment = PlayerEquipement[PlayerName] or {};
local itemCache = PlayerEquipItems[PlayerName];
local armorCache = PlayerEquipArmor[PlayerName];

for _, slotDef in ipairs(AltHolicUtil.EquipmentSlots) do
    local slotName = slotDef.key;
    local slotData = playerEquipment[slotName] or {};
    local level = tonumber(slotData.lvl) or 0;

    itemCache[slotName] = level;
    armorCache[slotName] = tonumber(slotData.armor) or 0;
    if level ~= 0 and slotData.N ~= nil then
        itemCache[slotName .. "N"] = slotData.N;
    end
end

-- Equipment is only saved for Free Peoples characters.
if PlayerAlignement == 1 then
    SavePlayerEquipment();
end
