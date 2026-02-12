------------------------------------------------------------------------------------------
-- PlayerStats file
-- Written by Homeopatix
-- 26 january 2021
-- updated on 03.11.2023
------------------------------------------------------------------------------------------
-- define player stats
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Define vars --
------------------------------------------------------------------------------------------
    Player = Turbine.Gameplay.LocalPlayer.GetInstance();
    vaultpack = Player:GetVault();
    sspack = Player:GetSharedStorage();
    walletpack = Player:GetWallet();
    backpack = Player:GetBackpack();
    PlayerName = Player:GetName();
    PlayerAlign = Player:GetAlignment(); --1: Free People / 2: Monster Play
    PlayerLvl = Player:GetLevel();
    PlayerAttr = Player:GetAttributes();
    PlayerAlignement = Player:GetAlignment();
    PlayerEquip = Player:GetEquipment();
    PlayerDestinyP = PlayerAttr:GetDestinyPoints();
    PlayerSexe = {};
    PlayerXp = {};
    EpiqueVolume = {};
    EpiqueLivre = {};
    EpiqueChapitre = {};
    Reputations = {};
    RepuPosition = {};
    RepuName = {};
    PlayerVoc = ReturnPlayerVocation();

    -- datas to use through the game
    valCheck = 200;
    --LevelMax = 140;
    LevelMax = 150;
    TierMax = 15;
    -- added 6 new factions, why there is only 93
    nbrFactions = 107; 

    -- variable global
    alreadyDisplayed = 0;

    -- ready fot the level 150
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
        [91]=30735855, [92]=32361469, [93]=34068363, [94]=35860601, [95]=37742450, [96]=39718391, [97]=41793129 , [98]=43971603 , [99]=46259000, [100]=48660766,
        [101]=51182620, [102] =53830566, [103] =56610909, [104] =59530269, [105] =62595597, [106]=65814191, [107]=69193714, [108]=72742213, [109]=76468136, [110]=80380355,
        [111]=84488184, [112]=88801404, [113]=93330285, [114]=98085610, [115]=103078701, [116]=108321446, [117]=113826328, [118]=119606454, [119]=125675586, [120]=132048174,
        [121]=138739391, [122]=145765168, [123]=153142233, [124]=160888151, [125]=169021364, [126]=177561237, [127]=186528103, [128]=195943312, [129]=205829281, [130]=216209548,
	    [131]=227108828, [132]=238553072, [133]=250569528, [134]=263186806, [135]=276434947, [136]=290345495, [137]=304951570, [138]=320287948, [139]=336391144, [140]=353299499,
        [141]=371053271, [142]=389694731, [143]=409268264, [144]=429820473, [145]=451400292, [146]=474059101, [147]=497850850, [148]=522832186, [149]=549062588, [150]=0,
    };

    nbrServers = 18;
    ServerNames = {"Sirannon [FR]",
                    "Grond [EU]",
                    "Peregrin [RP]",
                    "Meriadoc [EU-RP]",
                    "Glamdring",
                    "Orcrist [EU]",
                    "Angmar",
                    "Mordor [EU]",
                    "Belegaer [EU-DE-RP]",
                    "Gladden [US]",
                    "Landroval [US-RE]",
                    "Gwaihir [EU-DE]",
                    "Arkenstone [US]",
                    "Evernight [EU]",
                    "CrickHollow [US]",
                    "Laurelin [EU-EN-RP]",
                    "Treebeard",
                    "Brandywine [US]"
				};

    Write = Turbine.Shell.WriteLine;
    screenWidth, screenHeight = Turbine.UI.Display.GetSize();
    ------------------------------------------------------------------------------------------
    -- define player datas for stats
    ------------------------------------------------------------------------------------------
    if(PlayerAlignement == 1)then
        PlayerAgility = tonumber(PlayerAttr:GetAgility());
        PlayerFate = tonumber(PlayerAttr:GetFate());
        PlayerMight = tonumber(PlayerAttr:GetMight());
        PlayerVitality = tonumber(PlayerAttr:GetVitality());
        PlayerWill = tonumber(PlayerAttr:GetWill());
        PlayerArmure = tonumber(PlayerAttr:GetArmor());
        PlayerMoral = tonumber(Player:GetMorale());
        PlayerMaxMoral = tonumber(Player:GetMaxMorale());
        PlayerPower = tonumber(Player:GetPower());
        PlayerMaxPower = tonumber(Player:GetMaxPower());
	    --PlayerVoc = PlayerAttr:GetVocation();
        --PlayerVoc = PlayerDatas[PlayerName].voc;  

        -- new large stats
        PlayerCritAttack = tonumber(PlayerAttr:GetBaseCriticalHitChance());
        PlayerFinesse = tonumber(PlayerAttr:GetFinesse());
        PlayerMeleeDamage = tonumber(PlayerAttr:GetMeleeDamage());
        PlayerTacticalDamage = tonumber(PlayerAttr:GetTacticalDamage());
        PlayerDegatPhysique = tonumber(PlayerAttr:GetCommonMitigation());
        PlayerDegatTactique = tonumber(PlayerAttr:GetTacticalMitigation());
        PlayerDefenseCritique = tonumber(PlayerAttr:GetBaseCriticalHitAvoidance());
        PlayerResistance = tonumber(PlayerAttr:GetBaseResistance());
        PlayerBloquage = tonumber(PlayerAttr:GetBlock());
        PlayerParade = tonumber(PlayerAttr:GetParry());
        PlayerEsquive = tonumber(PlayerAttr:GetEvade());
        PlayerHealDone = tonumber(PlayerAttr:GetOutgoingHealing());
        PlayerHealRecieved = tonumber(PlayerAttr:GetIncomingHealing());
        PlayerOrc = tonumber(PlayerAttr:GetPhysicalMitigation());
        PlayerRange = tonumber(PlayerAttr:GetRangeDamage());
    else
        PlayerMoral = tonumber(Player:GetMorale());
        PlayerMaxMoral = tonumber(Player:GetMaxMorale());
        PlayerPower = tonumber(Player:GetPower());
        PlayerMaxPower = tonumber(Player:GetMaxPower());
    end

    PlayerClass = Player:GetClass();
    PlayerRace = Player:GetRace();
    PlayerCash = PlayerAttr:GetMoney();

    PlayerServer = {};


vaultHasBeenUpdated = false;
sharedStorageHasBeenUpdated = false;
------------------------------------------------------------------------------------------
-- load all the dats needed
------------------------------------------------------------------------------------------
LoadSettings();
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

PlayerSexe[PlayerName] = PlayerDatas[PlayerName].sexe;
PlayerServer[PlayerName] = PlayerDatas[PlayerName].serverName;
PlayerXp[PlayerName] = PlayerDatas[PlayerName].xp;

if(PlayerDatas[PlayerName].cash == "" or PlayerDatas[PlayerName].cash == nil or PlayerDatas[PlayerName].cash == 0)then
    PlayerDatas[PlayerName].cash = PlayerAttr:GetMoney();
end

-- initialize the xp datas
for i in pairs(PlayerDatas) do
    if(PlayerXp[i] == nil or PlayerXp[i] <= 0)then
        PlayerXp[i] = 0;
    end
end

-- if the icon size is not define set it to 64
if(settings["isMinimizeEnabled"]["isMinimizeEnabled"] == false)then
    settings["iconSize"]["value"] = 64;
end

-- pre-save the player data
SavePlayerBags();
SavePlayerDatas();
SavePlayerWallet();
SavePlayerProfessions();

local Today = Turbine.Engine.GetDate();
local TodayDay = Today.Day;
local TodayMonth = Today.Month;
local TodayYear = Today.Year;
------------------------------------------------------------------------------------------
-- define the vocation value (does not exist anymore)
------------------------------------------------------------------------------------------
PlayerDatas[PlayerName].voc = 0;
------------------------------------------------------------------------------------------
-- define the session starting cash value
------------------------------------------------------------------------------------------
settings["sessionCash"]["cashSpent"] = 0;
settings["sessionCash"]["cashSession"] = 0;
settings["sessionCash"]["cashStart"] = 0;
------------------------------------------------------------------------------------------
-- define daily cash value
------------------------------------------------------------------------------------------
if(settings["dailyCash"]["jour"] ~= TodayDay or settings["dailyCash"]["mois"] ~= TodayMonth or settings["dailyCash"]["annee"] ~= TodayYear)then
    settings["dailyCash"]["cashDaily"] = 0;
    settings["dailyCash"]["cashSpent"] = 0;
    settings["dailyCash"]["jour"] = TodayDay;
    settings["dailyCash"]["mois"] = TodayMonth;
    settings["dailyCash"]["annee"] = TodayYear;
end
------------------------------------------------------------------------------------------
-- define level equipment
------------------------------------------------------------------------------------------
    PlayerEquipItems = {};
    PlayerEquipItems[PlayerName] = {};
    if(PlayerEquipement[PlayerName].Back.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Back = PlayerEquipement[PlayerName].Back.lvl;
        PlayerEquipItems[PlayerName].BackN = PlayerEquipement[PlayerName].Back.N;
    else
        PlayerEquipItems[PlayerName].Back = 0;
    end
    if(PlayerEquipement[PlayerName].Boots.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Boots = PlayerEquipement[PlayerName].Boots.lvl;
        PlayerEquipItems[PlayerName].BootsN = PlayerEquipement[PlayerName].Boots.N;
    else
        PlayerEquipItems[PlayerName].Boots = 0;
    end
    if(PlayerEquipement[PlayerName].Bracelet1.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Bracelet1 = PlayerEquipement[PlayerName].Bracelet1.lvl;
        PlayerEquipItems[PlayerName].Bracelet1N = PlayerEquipement[PlayerName].Bracelet1.N;
    else
        PlayerEquipItems[PlayerName].Bracelet1 = 0;
    end
    if(PlayerEquipement[PlayerName].Bracelet2.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Bracelet2 = PlayerEquipement[PlayerName].Bracelet2.lvl;
        PlayerEquipItems[PlayerName].Bracelet2N = PlayerEquipement[PlayerName].Bracelet2.N;
    else
        PlayerEquipItems[PlayerName].Bracelet2 = 0;
    end
    if(PlayerEquipement[PlayerName].ClassE.lvl ~= 0)then
        PlayerEquipItems[PlayerName].ClassE = PlayerEquipement[PlayerName].ClassE.lvl;
        PlayerEquipItems[PlayerName].ClassEN = PlayerEquipement[PlayerName].ClassE.N;
    else
        PlayerEquipItems[PlayerName].ClassE = 0;
    end
    if(PlayerEquipement[PlayerName].CraftTool.lvl ~= 0)then
        PlayerEquipItems[PlayerName].CraftTool = PlayerEquipement[PlayerName].CraftTool.lvl;
        PlayerEquipItems[PlayerName].CraftToolN = PlayerEquipement[PlayerName].CraftTool.N;
    else
        PlayerEquipItems[PlayerName].CraftTool = 0;
    end
    if(PlayerEquipement[PlayerName].Earring1.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Earring1 = PlayerEquipement[PlayerName].Earring1.lvl;
        PlayerEquipItems[PlayerName].Earring1N = PlayerEquipement[PlayerName].Earring1.N;
    else
        PlayerEquipItems[PlayerName].Earring1 = 0;
    end
    if(PlayerEquipement[PlayerName].Earring2.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Earring2 = PlayerEquipement[PlayerName].Earring2.lvl;
        PlayerEquipItems[PlayerName].Earring2N = PlayerEquipement[PlayerName].Earring2.N;
    else
        PlayerEquipItems[PlayerName].Earring2 = 0;
    end
    if(PlayerEquipement[PlayerName].Gloves.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Gloves = PlayerEquipement[PlayerName].Gloves.lvl;
        PlayerEquipItems[PlayerName].GlovesN = PlayerEquipement[PlayerName].Gloves.N;
    else
        PlayerEquipItems[PlayerName].Gloves = 0;
    end
    if(PlayerEquipement[PlayerName].Head.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Head = PlayerEquipement[PlayerName].Head.lvl;
        PlayerEquipItems[PlayerName].HeadN = PlayerEquipement[PlayerName].Head.N;
    else
        PlayerEquipItems[PlayerName].Head = 0;
    end
    if(PlayerEquipement[PlayerName].Legs.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Legs = PlayerEquipement[PlayerName].Legs.lvl;
        PlayerEquipItems[PlayerName].LegsN = PlayerEquipement[PlayerName].Legs.N;
    else
        PlayerEquipItems[PlayerName].Legs = 0;
    end
    if(PlayerEquipement[PlayerName].Chest.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Chest = PlayerEquipement[PlayerName].Chest.lvl;
        PlayerEquipItems[PlayerName].ChestN = PlayerEquipement[PlayerName].Chest.N;
    else
        PlayerEquipItems[PlayerName].Chest = 0;
    end
    if(PlayerEquipement[PlayerName].Necklace.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Necklace = PlayerEquipement[PlayerName].Necklace.lvl;
        PlayerEquipItems[PlayerName].NecklaceN = PlayerEquipement[PlayerName].Necklace.N;
    else
        PlayerEquipItems[PlayerName].Necklace = 0;
    end
    if(PlayerEquipement[PlayerName].Pocket.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Pocket = PlayerEquipement[PlayerName].Pocket.lvl;
        PlayerEquipItems[PlayerName].PocketN = PlayerEquipement[PlayerName].Pocket.N;
    else
        PlayerEquipItems[PlayerName].Pocket = 0;
    end
    if(PlayerEquipement[PlayerName].PrimaryWeapon.lvl ~= 0)then
        PlayerEquipItems[PlayerName].PrimaryWeapon = PlayerEquipement[PlayerName].PrimaryWeapon.lvl;
        PlayerEquipItems[PlayerName].PrimaryWeaponN = PlayerEquipement[PlayerName].PrimaryWeapon.N;
    else
        PlayerEquipItems[PlayerName].PrimaryWeapon = 0;
    end
    if(PlayerEquipement[PlayerName].RangedWeapon.lvl ~= 0)then
        PlayerEquipItems[PlayerName].RangedWeapon = PlayerEquipement[PlayerName].RangedWeapon.lvl;
        PlayerEquipItems[PlayerName].RangedWeaponN = PlayerEquipement[PlayerName].RangedWeapon.N;
    else
        PlayerEquipItems[PlayerName].RangedWeapon = 0;
    end
    if(PlayerEquipement[PlayerName].Ring1.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Ring1 = PlayerEquipement[PlayerName].Ring1.lvl;
        PlayerEquipItems[PlayerName].Ring1N = PlayerEquipement[PlayerName].Ring1.N;
    else
        PlayerEquipItems[PlayerName].Ring1 = 0;
    end
    if(PlayerEquipement[PlayerName].Ring2.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Ring2 = PlayerEquipement[PlayerName].Ring2.lvl;
        PlayerEquipItems[PlayerName].Ring2N = PlayerEquipement[PlayerName].Ring2.N;
    else
        PlayerEquipItems[PlayerName].Ring2 = 0;
    end
    if(PlayerEquipement[PlayerName].Shield.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Shield = PlayerEquipement[PlayerName].Shield.lvl;
        PlayerEquipItems[PlayerName].ShieldN = PlayerEquipement[PlayerName].Shield.N;
    else
        PlayerEquipItems[PlayerName].Shield = 0;
    end
    if(PlayerEquipement[PlayerName].Shoulder.lvl ~= 0)then
        PlayerEquipItems[PlayerName].Shoulder = PlayerEquipement[PlayerName].Shoulder.lvl;
        PlayerEquipItems[PlayerName].ShoulderN = PlayerEquipement[PlayerName].Shoulder.N;
    else
        PlayerEquipItems[PlayerName].Shoulder = 0;
    end
------------------------------------------------------------------------------------------ 
-- define armor equipment
------------------------------------------------------------------------------------------
    PlayerEquipArmor = {};
    PlayerEquipArmor[PlayerName] = {};
    if(PlayerEquipement[PlayerName].Back.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Back = PlayerEquipement[PlayerName].Back.armor;
    else
        PlayerEquipArmor[PlayerName].Back = 0;
    end
    if(PlayerEquipement[PlayerName].Boots.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Boots = PlayerEquipement[PlayerName].Boots.armor;
    else
        PlayerEquipArmor[PlayerName].Boots = 0;
    end
    if(PlayerEquipement[PlayerName].Bracelet1.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Bracelet1 = PlayerEquipement[PlayerName].Bracelet1.armor;
    else
        PlayerEquipArmor[PlayerName].Bracelet1 = 0;
    end
    if(PlayerEquipement[PlayerName].Bracelet2.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Bracelet2 = PlayerEquipement[PlayerName].Bracelet2.armor;
    else
        PlayerEquipArmor[PlayerName].Bracelet2 = 0;
    end
    if(PlayerEquipement[PlayerName].ClassE.armor ~= 0)then
        PlayerEquipArmor[PlayerName].ClassE = PlayerEquipement[PlayerName].ClassE.armor;
    else
        PlayerEquipArmor[PlayerName].ClassE = 0;
    end
    if(PlayerEquipement[PlayerName].CraftTool.armor ~= 0)then
        PlayerEquipArmor[PlayerName].CraftTool = PlayerEquipement[PlayerName].CraftTool.armor;
    else
        PlayerEquipArmor[PlayerName].CraftTool = 0;
    end
    if(PlayerEquipement[PlayerName].Earring1.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Earring1 = PlayerEquipement[PlayerName].Earring1.armor;
    else
        PlayerEquipArmor[PlayerName].Earring1 = 0;
    end
    if(PlayerEquipement[PlayerName].Earring2.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Earring2 = PlayerEquipement[PlayerName].Earring2.armor;
    else
        PlayerEquipArmor[PlayerName].Earring2 = 0;
    end
    if(PlayerEquipement[PlayerName].Gloves.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Gloves = PlayerEquipement[PlayerName].Gloves.armor;
    else
        PlayerEquipArmor[PlayerName].Gloves = 0;
    end
    if(PlayerEquipement[PlayerName].Head.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Head = PlayerEquipement[PlayerName].Head.armor;
    else
        PlayerEquipArmor[PlayerName].Head = 0;
    end
    if(PlayerEquipement[PlayerName].Legs.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Legs = PlayerEquipement[PlayerName].Legs.armor;
    else
        PlayerEquipArmor[PlayerName].Legs = 0;
    end
    if(PlayerEquipement[PlayerName].Chest.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Chest = PlayerEquipement[PlayerName].Chest.armor;
    else
        PlayerEquipArmor[PlayerName].Chest = 0;
    end
    if(PlayerEquipement[PlayerName].Necklace.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Necklace = PlayerEquipement[PlayerName].Necklace.armor;
    else
        PlayerEquipArmor[PlayerName].Necklace = 0;
    end
    if(PlayerEquipement[PlayerName].Pocket.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Pocket = PlayerEquipement[PlayerName].Pocket.armor;
    else
        PlayerEquipArmor[PlayerName].Pocket = 0;
    end
    if(PlayerEquipement[PlayerName].PrimaryWeapon.armor ~= 0)then
        PlayerEquipArmor[PlayerName].PrimaryWeapon = PlayerEquipement[PlayerName].PrimaryWeapon.armor;
    else
        PlayerEquipArmor[PlayerName].PrimaryWeapon = 0;
    end
    if(PlayerEquipement[PlayerName].RangedWeapon.armor ~= 0)then
        PlayerEquipArmor[PlayerName].RangedWeapon = PlayerEquipement[PlayerName].RangedWeapon.armor;
    else
        PlayerEquipArmor[PlayerName].RangedWeapon = 0;
    end
    if(PlayerEquipement[PlayerName].Ring1.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Ring1 = PlayerEquipement[PlayerName].Ring1.armor;
    else
        PlayerEquipArmor[PlayerName].Ring1 = 0;
    end
    if(PlayerEquipement[PlayerName].Ring2.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Ring2 = PlayerEquipement[PlayerName].Ring2.armor;
    else
        PlayerEquipArmor[PlayerName].Ring2 = 0;
    end
    if(PlayerEquipement[PlayerName].Shield.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Shield = PlayerEquipement[PlayerName].Shield.armor;
    else
        PlayerEquipArmor[PlayerName].Shield = 0;
    end
    if(PlayerEquipement[PlayerName].Shoulder.armor ~= 0)then
        PlayerEquipArmor[PlayerName].Shoulder = PlayerEquipement[PlayerName].Shoulder.armor;
    else
        PlayerEquipArmor[PlayerName].Shoulder = 0;
    end
------------------------------------------------------------------------------------------
-- save equipment only for free people
------------------------------------------------------------------------------------------
if(Player:GetAlignment() == 1)then
	SavePlayerEquipment();
end