------------------------------------------------------------------------------------------
-- FCT file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Initialize datas
------------------------------------------------------------------------------------------
ButtonEquipItem = {};
centerEquipItem = {};
centerEquipItem2a = {};
centerEquipItem2 = {};
centerEquipItem3 = {};
centerEquipItem4 = {};
centerEquipItem5 = {};
centerEquipItem6 = {};
centerEquipItem2a = {};
centerEquipItem2ab = {};
ButtonPlusSexe = {};
centerLabelSexe = {};
centerEquipItem9 = {};
centerEquipItem19 = {};
centerLabelProf1 = {};
centerLabelProfIcon = {};
centerLabelTier1 = {};
centerLabelTier2 = {};
ButtonPlusLab = {};
ButtonPlusStats = {};
ButtonPlusServer = {};
centerLabelStats = {};
centerLabelServer = {};
centerLabelStats2 = {};
ButtonPlusInfosNotBar = {};
textBoxLinesPopUp = {};
currentLevel = {};
ProfessionName = {};
currentLevelMastery = {};
ButtonPlusDelete = {};
centerLabelDelete = {};
ButtonPlusLabEpique = {};
------------------------------------------------------------------------------------------
-- Set the stratinf datas of the windows to false
------------------------------------------------------------------------------------------
function InitWindowsDatas()
	AltHolicInfosWindow:SetVisible(false);

	settings["sessionCash"]["cashSession"] = 0;
	settings["sessionCash"]["cashSpent"] = 0;

	settings["isWindowVisible"]["isWindowVisible"] = false;
	settings["isShowBagVisible"]["isShowBagVisible"] = false;
	settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
	settings["isShowVaultVisible"]["isShowVaultVisible"] = false;
	settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = false;
	settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = false;
	settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
	settings["nameAccount"]["account1"]["isVisible"] = false;
	settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"] = false;
	settings["isServerWindowVisible"]["value"] = false;
end
------------------------------------------------------------------------------------------
-- Create and handle the minimized icons
------------------------------------------------------------------------------------------
function MiniMizedIconHandler()
	local iconSize = 32;
	
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, iconSize, iconSize, AltHolicWindow:SetVisible(false));
	MainTinyIcon = MinimizedIcon(Images.TinyIcon, 32, 32, AltHolicWindow:SetVisible(false));
	MainTinyIcon24 = MinimizedIcon(Images.TinyIcon24, 24, 24, AltHolicWindow:SetVisible(false));
	MainTinyIcon16 = MinimizedIcon(Images.TinyIcon16, 16, 16, AltHolicWindow:SetVisible(false));

	MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainMinimizedIcon:SetZOrder(0);

	MainTinyIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainTinyIcon:SetZOrder(0);

	MainTinyIcon24:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainTinyIcon24:SetZOrder(0);

	MainTinyIcon16:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainTinyIcon16:SetZOrder(0);

	MainMinimizedIcon.PositionChanged = function()
		settings["IconPosition"]["xPosIcon"] = MainMinimizedIcon:GetLeft();
		settings["IconPosition"]["yPosIcon"] = MainMinimizedIcon:GetTop();
		SaveSettings();
	end

	MainTinyIcon.PositionChanged = function()
		settings["IconPosition"]["xPosIcon"] = MainTinyIcon:GetLeft();
		settings["IconPosition"]["yPosIcon"] = MainTinyIcon:GetTop();
		SaveSettings();
	end

	MainTinyIcon24.PositionChanged = function()
		settings["IconPosition"]["xPosIcon"] = MainTinyIcon24:GetLeft();
		settings["IconPosition"]["yPosIcon"] = MainTinyIcon24:GetTop();
		SaveSettings();
	end

	MainTinyIcon16.PositionChanged = function()
		settings["IconPosition"]["xPosIcon"] = MainTinyIcon16:GetLeft();
		settings["IconPosition"]["yPosIcon"] = MainTinyIcon16:GetTop();
		SaveSettings();
	end

	if(settings["iconSize"]["value"] == 64)then
		MainMinimizedIcon:SetVisible(true);
		MainTinyIcon:SetVisible(false);
		MainTinyIcon24:SetVisible(false);
		MainTinyIcon16:SetVisible(false);
		MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	elseif(settings["iconSize"]["value"] == 32)then
		MainMinimizedIcon:SetVisible(false);
		MainTinyIcon:SetVisible(true);
		MainTinyIcon24:SetVisible(false);
		MainTinyIcon16:SetVisible(false);
		MainTinyIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	elseif(settings["iconSize"]["value"] == 24)then
		MainMinimizedIcon:SetVisible(false);
		MainTinyIcon:SetVisible(false);
		MainTinyIcon24:SetVisible(true);
		MainTinyIcon16:SetVisible(false);
		MainTinyIcon24:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	elseif(settings["iconSize"]["value"] == 16)then
		MainMinimizedIcon:SetVisible(false);
		MainTinyIcon:SetVisible(false);
		MainTinyIcon24:SetVisible(false);
		MainTinyIcon16:SetVisible(true);
		MainTinyIcon16:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	end
end
------------------------------------------------------------------------------------------
-- create or load the settings for player professions
------------------------------------------------------------------------------------------
function GetDataForProfessions()
	------------------------------------------------------------------------------------------
	-- Import Globals --
	------------------------------------------------------------------------------------------
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		import "Homeopatix.AltHolic.Localization.GlobalsDE";
		GLocale = "de";
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		import "Homeopatix.AltHolic.Localization.GlobalsFR";
		GLocale = "fr";
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		import "Homeopatix.AltHolic.Localization.GlobalsEN";
		GLocale = "en";
	end

    character = {};

    tier = {T[ "PluginProfTier1" ],
            T[ "PluginProfTier2" ],
            T[ "PluginProfTier3" ],
            T[ "PluginProfTier4" ],
            T[ "PluginProfTier5" ],
            T[ "PluginProfTier6" ],
            T[ "PluginProfTier7" ],
            T[ "PluginProfTier8" ],
            T[ "PluginProfTier9" ],
            T[ "PluginProfTier10" ],
            T[ "PluginProfTier11" ],
            T[ "PluginProfTier12" ],
            T[ "PluginProfTier13" ],
			T[ "PluginProfTier14" ],
			T[ "PluginProfTier15" ]};


	--Write("vocation : " .. PlayerVoc);

    if PlayerVoc then
	    character.professions = {};

        local profNbr = 1;

	    for k,v in pairs(Turbine.Gameplay.Profession) do
		    local professionInfo = PlayerAttr:GetProfessionInfo(v);

		    if professionInfo then
			    local professionData = {};
			
			    professionData.proficiencyLevel = professionInfo:GetProficiencyLevel();
			    professionData.masteryLevel = professionInfo:GetMasteryLevel();
			    professionData.proficiencyExp = professionInfo:GetProficiencyExperience();
			    professionData.proficiencyExpTarget = professionInfo:GetProficiencyExperienceTarget();
			    professionData.masteryExp = professionInfo:GetMasteryExperience();
			    professionData.masteryExpTarget = professionInfo:GetMasteryExperienceTarget();
                professionData.name = professionInfo:GetName();

                local valForNextLvlProficiency = Round((professionData.proficiencyExpTarget - professionData.proficiencyExp) / 8);
                local valForNextLvlMastery = Round((professionData.masteryExpTarget - professionData.masteryExp) / 8);

                -- debug
                --professionData.proficiencyLevel = 13;
                --professionData.masteryLevel = 13;
                -- end debug

                if(professionData.proficiencyLevel < TierMax)then
                    currentLevel[profNbr] = tostring("T" .. professionData.proficiencyLevel+1) .. " - " .. 
                    tostring(tier[professionData.proficiencyLevel+1]) .. " : " .. 
                    tostring(professionData.proficiencyExp) .. " / " .. tostring(professionData.proficiencyExpTarget .. "\n" .. "      ~ " .. valForNextLvlProficiency .. " " .. T[ "PluginProfTier20" ]);
                else
                    currentLevel[profNbr] = tostring("T" .. professionData.proficiencyLevel) .. " - " .. 
                    tostring(tier[professionData.proficiencyLevel]) .. 
                    tostring("\n" .. "        " .. T[ "PluginProfTier21" ]);
                end
                if(professionData.masteryLevel < TierMax)then
                    currentLevelMastery[profNbr] = tostring("T" .. professionData.masteryLevel+1) .. " - " .. 
                    tostring(tier[professionData.masteryLevel+1]) .. " : " .. 
                    tostring(professionData.masteryExp) .. " / " .. tostring(professionData.masteryExpTarget .. "\n" .. "      ~ " .. valForNextLvlMastery .. " " .. T[ "PluginProfTier20" ]);
                else
                    currentLevelMastery[profNbr] = tostring("T" .. professionData.masteryLevel) .. " - " .. 
                    tostring(tier[professionData.masteryLevel]) .. 
                    tostring("\n" .. "        " .. T[ "PluginProfTier21" ]);
                end
                
                ProfessionName[profNbr] = tostring(professionData.name);

                profNbr = profNbr + 1;
            end
        end
    end
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
-- function to compte the bags of cash in sharedstorage --
------------------------------------------------------------------------------------------
function CompteSharedStorageGold()
    local storagesize = sspack:GetCount();
    local sharedmoney = 0;
    local i;
    for i = 1, storagesize do
        local item = sspack:GetItem(i);
        if (item ~= nil) then
            local name = item:GetName();
            local count = item:GetQuantity();

			if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				if (name == "Beutel mit Goldm\195\188nzen" )then -- Gold Bag
					sharedmoney = sharedmoney + ( count * 1000000 )
				elseif (name == "Beutel mit Silberm\195\188nzen" )then -- Silver Bag
					sharedmoney = sharedmoney + ( count * 100000 )
				elseif (name == "Beutel mit Kupferm\195\188nzen" )then -- Copper Bag
					sharedmoney = sharedmoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				if (name == "Sac de pi\195\168ces d'or" )then -- Gold Bag
					sharedmoney = sharedmoney + ( count * 1000000 )
				elseif (name == "Sac de pi\195\168ces d'argent" )then -- Silver Bag
					sharedmoney = sharedmoney + ( count * 100000 )
				elseif (name == "Sac de pi\195\168ces de cuivre" )then -- Copper Bag
					sharedmoney = sharedmoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				if (name == "Bag of Gold Coins" )then -- Gold Bag
					sharedmoney = sharedmoney + ( count * 1000000 )
				elseif (name == "Bag of Silver Coins" )then -- Silver Bag
					sharedmoney = sharedmoney + ( count * 100000 )
				elseif (name == "Bag of Copper Coins" )then -- Copper Bag
					sharedmoney = sharedmoney + ( count * 10000 )
				end
			end
        end
    end

    return sharedmoney;
end
------------------------------------------------------------------------------------------
-- function to compte the bags of cash in bag --
------------------------------------------------------------------------------------------
function CompteBagGold()
    local backpackSize = backpack:GetSize();
    local bagMoney = 0;
    local i;
    for i = 1, backpackSize do
        local item = backpack:GetItem(i);
        if (item ~= nil) then
            local name = item:GetName();
            local count = item:GetQuantity();

            if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				if (name == "Beutel mit Goldm\195\188nzen" )then -- Gold Bag
					bagMoney = bagMoney + ( count * 1000000 )
				elseif (name == "Beutel mit Silberm\195\188nzen" )then -- Silver Bag
					bagMoney = bagMoney + ( count * 100000 )
				elseif (name == "Beutel mit Kupferm\195\188nzen" )then -- Copper Bag
					bagMoney = bagMoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				if (name == "Sac de pi\195\168ces d'or" )then -- Gold Bag
					bagMoney = bagMoney + ( count * 1000000 )
				elseif (name == "Sac de pi\195\168ces d'argent" )then -- Silver Bag
					bagMoney = bagMoney + ( count * 100000 )
				elseif (name == "Sac de pi\195\168ces de cuivre" )then -- Copper Bag
					bagMoney = bagMoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				if (name == "Bag of Gold Coins" )then -- Gold Bag
					bagMoney = bagMoney + ( count * 1000000 )
				elseif (name == "Bag of Silver Coins" )then -- Silver Bag
					bagMoney = bagMoney + ( count * 100000 )
				elseif (name == "Bag of Copper Coins" )then -- Copper Bag
					bagMoney = bagMoney + ( count * 10000 )
				end
			end
        end
    end

    return bagMoney;
end
------------------------------------------------------------------------------------------
-- function to compte the bags of cash in vault --
------------------------------------------------------------------------------------------
function CompteVaultGold()
    local vaultpackSize = vaultpack:GetCapacity();
    local vaultMoney = 0;
    local i;
    for i = 1, vaultpackSize do
        local item = vaultpack:GetItem(i);
        if (item ~= nil) then
            local name = item:GetName();
            local count = item:GetQuantity();

            if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				if (name == "Beutel mit Goldm\195\188nzen" )then -- Gold Bag
					vaultMoney = vaultMoney + ( count * 1000000 )
				elseif (name == "Beutel mit Silberm\195\188nzen" )then -- Silver Bag
					vaultMoney = vaultMoney + ( count * 100000 )
				elseif (name == "Beutel mit Kupferm\195\188nzen" )then -- Copper Bag
					vaultMoney = vaultMoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				if (name == "Sac de pi\195\168ces d'or" )then -- Gold Bag
					vaultMoney = vaultMoney + ( count * 1000000 )
				elseif (name == "Sac de pi\195\168ces d'argent" )then -- Silver Bag
					vaultMoney = vaultMoney + ( count * 100000 )
				elseif (name == "Sac de pi\195\168ces de cuivre" )then -- Copper Bag
					vaultMoney = vaultMoney + ( count * 10000 )
				end
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				if (name == "Bag of Gold Coins" )then -- Gold Bag
					vaultMoney = vaultMoney + ( count * 1000000 )
				elseif (name == "Bag of Silver Coins" )then -- Silver Bag
					vaultMoney = vaultMoney + ( count * 100000 )
				elseif (name == "Bag of Copper Coins" )then -- Copper Bag
					vaultMoney = vaultMoney + ( count * 10000 )
				end
			end
        end
    end

    return vaultMoney;
end
------------------------------------------------------------------------------------------
-- function to display the cash of the player --
------------------------------------------------------------------------------------------
function UpdateCash()
	local currentCash = PlayerAttr:GetMoney();
	local currentCashBag = tonumber(CompteBagGold());
	local currentCashVault = tonumber(CompteVaultGold());

	if(settings["sharedStorageCash"]["value"] ~= CompteSharedStorageGold())then
		settings["sharedStorageCash"]["value"] = CompteSharedStorageGold();
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
	Write("bag cash : " .. tostring(CompteBagGold()));
	Write("vault cash : " .. tostring(CompteVaultGold()));
	Write("sharedstorage cash : " .. tostring(CompteSharedStorageGold()));
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
function ReturnNbrItemsInBag(textToSearch)
	local nbrItems = 0;
	local nbrItemsDuPerso = 0;
	local nbrPlayer = 0;
	local playerCount = false;
	local nbrLines = 0;

		if(textToSearch == nil)then
		-- do nothing
		else
			for namePlayerToshow in pairs(PlayerBags) do
				for i in pairs(PlayerBags[namePlayerToshow]) do
					if(string.find(string.lower(PlayerBags[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
						nbrItems = nbrItems + 1;
						nbrItemsDuPerso = nbrItemsDuPerso + 1;
						if(playerCount == false)then
							nbrPlayer = nbrPlayer + 1;
							playerCount = true;
						end
					end
				end
				if((nbrItemsDuPerso % 9) > 0)then
					nbrLines = nbrLines + 1;
				end
				nbrLines = nbrLines + math.floor(nbrItemsDuPerso / 9);
				nbrItemsDuPerso = 0;
				playerCount = false;
			end
		end
	return nbrItems, nbrPlayer, nbrLines;
end
------------------------------------------------------------------------------------------
-- function to return nbrItems, nbrplayer, nbrlines for vault --
------------------------------------------------------------------------------------------
function ReturnNbrItemsInVault(textToSearch)
	local nbrItems = 0;
	local nbrPlayer = 0;
	local playerCount = false;
	local nbrLines = 0;
	local nbrItemsDuPerso = 0;
	
	if(textToSearch == nil)then
		-- do nothing
		else
			for namePlayerToshow in pairs(PlayerVault) do
				for i in pairs(PlayerVault[namePlayerToshow]) do
					if(string.find(string.lower(PlayerVault[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
						nbrItems = nbrItems + 1;
						nbrItemsDuPerso = nbrItemsDuPerso + 1;
						if(playerCount == false)then
							nbrPlayer = nbrPlayer + 1;
							playerCount = true;
						end
					end
				end
				if((nbrItemsDuPerso % 9) > 0)then
					nbrLines = nbrLines + 1;
				end
				nbrLines = nbrLines + math.floor(nbrItemsDuPerso / 9);
				nbrItemsDuPerso = 0;
				playerCount = false;
			end
		end
	return nbrItems, nbrPlayer, nbrLines;
end
------------------------------------------------------------------------------------------
-- function to return nbrItems, nbrplayer, nbrlines for wallet --
------------------------------------------------------------------------------------------
function ReturnNbrItemsInWallet(textToSearch)
	local nbrItems = 0;
	local nbrItemsDuPerso = 0;
	local nbrPlayer = 0;
	local playerCount = false;
	local nbrLines = 0;
	
	if(textToSearch == nil)then
		-- do nothing
		else
			for namePlayerToshow in pairs(PlayerWallet) do
				for i in pairs(PlayerWallet[namePlayerToshow]) do
					if(string.find(string.lower(PlayerWallet[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
						nbrItems = nbrItems + 1;
						nbrItemsDuPerso = nbrItemsDuPerso + 1;
						if(playerCount == false)then
							nbrPlayer = nbrPlayer + 1;
							playerCount = true;
						end
					end
				end
				if((nbrItemsDuPerso % 9) > 0)then
					nbrLines = nbrLines + 1;
				end
				nbrLines = nbrLines + math.floor(nbrItemsDuPerso / 9);
				nbrItemsDuPerso = 0;
				playerCount = false;
			end
		end
	return nbrItems, nbrPlayer, nbrLines;
end
------------------------------------------------------------------------------------------
-- function to return nbrItems, nbrplayer, nbrlines for sharedstorage --
------------------------------------------------------------------------------------------
function ReturnNbrItemsInSharedStorage(textToSearch)
	local nbrItems = 0;
	local nbrPlayer = 0;
	local nbrLines = 0;

		local nbrItemInSharedSrorage = 0;

		for i in pairs(SharedStorageVault) do
				nbrItemInSharedSrorage = nbrItemInSharedSrorage + 1 ;
		end

		if(textToSearch == nil)then
			nbrItems = nbrItemInSharedSrorage;
		else
			for i=1, nbrItemInSharedSrorage do  
				if(string.find(string.lower(SharedStorageVault[tostring(i)].N), string.lower(textToSearch)) ~= nil)then
					nbrItems = nbrItems + 1;
				end
			end
		end

	nbrLines = nbrLines + math.floor(nbrItemInSharedSrorage / 9);
	if((nbrItemInSharedSrorage % 9) > 0)then
		nbrLines = nbrLines + 1;
	end

	return nbrItems, nbrPlayer, nbrLines;
end
------------------------------------------------------------------------------------------
-- function to return nbrBooks --
------------------------------------------------------------------------------------------
function returnNombreBooks()
	local valToReturn = 0;
	for nam in pairs(PlayerEpique) do
		for pName in pairs(PlayerEpique[nam].volume) do
			valToReturn = valToReturn + 1;
		end
	end

	return valToReturn;
end
------------------------------------------------------------------------------------------
-- function reputations checker --
------------------------------------------------------------------------------------------

--[=====[
function UpdaterFromChat()
	Turbine.Chat.Received = function(sender, args)
		local reputMessage = args.Message;
		Write("msg : " .. reputMessage);
		local rpName = "";
		local rpPTSTodisplay = "";
		local cstr, paternName, paternPoints, paternBonus;

		if reputMessage ~= nil then
			-- Check string, Reputation Name and Reputation Point pattern
			if GLocale == "en" then
				paternName = "reputation with ([%a%p%u%l%s]*) has increased by";
				paternPoints = "has increased by ([%d%p]*)%.";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			elseif GLocale == "fr" then
				paternName = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de";
				paternPoints = "a augment\195\169 de ([%d%p]*)%.";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			elseif GLocale == "de" then
				paternName = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um";
				paternPoints = "hat sich um ([%d%p]*) verbessert";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			end

			for i=1, nbrFactions do
				if(string.match( reputMessage, T[ "reputname" .. i]))then
					rpName = T[ "reputname" .. i];
					rpPTS = string.match( reputMessage, paternPoints );
				end
			end

			-- check string if an accelerator was used
			if GLocale == "de" then
				cstr = string.match( reputMessage, "Bonus" );
			else cstr = string.match( reputMessage, "bonus" ); end
			-- Accelerator was used, end of string is different.
			-- Ex. (700 from bonus). instead of just a dot after the
			-- amount of points
			if cstr ~= nil then
				if GLocale == "en" then
					paternName = "reputation with ([%a%p%u%l%s]*) has increased by";
					paternPoints = "has increased by ([%d%p]*) %(";
					paternBonus = "%(([%d%p]*) from bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				elseif GLocale == "fr" then
					paternName = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de";
					paternPoints = "a augment\195\169 de ([%d%p]*) %(";
					paternBonus = "%(([%d%p]*) du bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				elseif GLocale == "de" then
					paternName = "Euer Ruf bei der Gruppe \"([%a%p%u%l%s]*)\" wurde um";
					paternPoints = "wurde um ([%d%p]*) erh\195\182ht";
					paternBonus = "%(([%d%p]*) durch Bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				end

				for i=1, nbrFactions do
					if(string.match( reputMessage, T[ "reputname" .. i]))then
						rpName = T[ "reputname" .. i];
						rpPTS = string.match( reputMessage, paternPoints );
						rpBonus = string.match( reputMessage, paternBonus );
					end
				end
			end

			if(rpPTS ~= nil)then
				local rpPTS = string.gsub( rpPTS, ",", "" );
				rpPTSTodisplay = string.format( "%.0f", rpPTS );
				for i=1, nbrFactions do
					if(rpName == T[ "reputname" .. i])then
						if(settings["showProgressReput"]["value"] == true)then
							if(rpBonus ~= nil)then
								rpBonus = string.gsub( rpBonus, ",", "" );
								rpBonusTodisplay = string.format( "%.0f", rpBonus );
								if GLocale == "en" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " + " .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " bonus" .. T[ "reputText1" ]);
								elseif GLocale == "fr" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " + " .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " " .. T[ "reputText1" ] .. " bonus");
								elseif GLocale == "de" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " + " .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " Bonus" .. T[ "reputText1" ]);
								end
							else
								Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
								rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
							end
						end
						UpdateReput(i, rpPTS, rpBonus);
					end
				end
			end
		end
		------------------------------------------------------------------------------------------
		-- checker to update lotro points --
		------------------------------------------------------------------------------------------
		local CoinsMessage = args.Message;
		local paternPointsSdao;
		local rpPTSSdao;
		if CoinsMessage ~= nil then
			if GLocale == "en" then
				paternPointsSdao = "You've earned ([%d%p]*)% LOTRO Points";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			elseif GLocale == "fr" then
				paternPointsSdao = "Vous avez gagn\195\169 ([%d%p]*)% points SdAO.";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			elseif GLocale == "de" then
				paternPointsSdao = "Ihr habt ([%d%p]*) Punkte erhalten.";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			end

			if(rpPTSSdao ~= nil)then
				local rpPTSSdao = string.gsub( rpPTSSdao, ",", "" );
				settings["lotroCoins"]["value"] = settings["lotroCoins"]["value"] + rpPTSSdao;
				if(settings["showProgressLotro"]["value"] == true)then
					if GLocale == "en" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"]);
					elseif GLocale == "fr" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
					elseif GLocale == "de" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"]);
					end
				end
			end
		end

		------------------------------------------------------------------------------------------
		-- checker to decrease reputations --
		------------------------------------------------------------------------------------------
		local decreaseMessage = args.Message;
		local rpNameDecrease = "";
		local rpPTSTodisplay = "";
		local paternNameDecrease, paternDecrease;

		if decreaseMessage ~= nil then
			-- Check string, Reputation Name and Reputation Point pattern
			-- Euer Ruf bei Galadhrim hat sich um 8 verschlechtert.
			if GLocale == "en" then
				paternNameDecrease = "reputation with ([%a%p%u%l%s]*) has decreased by";
				paternDecrease = "has decreased by ([%d%p]*)%.";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			elseif GLocale == "fr" then
				paternNameDecrease = "de la faction ([%a%p%u%l%s]*) a diminu\195\169 de";
				paternDecrease = "a diminu\195\169 de ([%d%p]*)%.";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			elseif GLocale == "de" then
				paternNameDecrease = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um";
				paternDecrease = "hat sich um ([%d%p]*) verschlechtert";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			end

			for i=1, nbrFactions do
				if(string.match( decreaseMessage, T[ "reputname" .. i]))then
					rpNameDecrease = T[ "reputname" .. i];
					rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
				end
			end

			if(rpPTSDecrease ~= nil)then
				local rpPTSDecrease = string.gsub( rpPTSDecrease, ",", "" );
				rpPTSTodisplay = string.format( "%.0f", rpPTSDecrease );
				for i=1, nbrFactions do
					if(rpNameDecrease == T["reputname" .. i])then
						if(settings["showProgressReput"]["value"] == true)then
								
							Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
							rgb["green"] .. tostring(rpNameDecrease) .. rgb["clear"] .. " - " .. 
								rgb["red"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
						end
						DecreaseReput(i, rpPTSDecrease);
					end
				end
			end
		end
	end
end
--]=====]
------------------------------------------------------------------------------------------
-- function decrese reputations updater --
------------------------------------------------------------------------------------------
function DecreaseReput(i, rpPTS)
	local reputationValueMax = {20000,10000,0,10000,30000,55000,85000,130000,190000,280000,480000};
	local reputationValueLevel = {10000,10000,0,10000,20000,25000,30000,45000,60000,90000,200000};
	local reputationValueLevel69 = {10000,20000,20000,1};
	local reputationValueLevel64 = {10000,20000,25000,30000};
	local reputationValueLevel70 = {10000, 15000, 20000, 20000, 20000, 20000, 30000, 1};
	local reputationValueLevel71 = {4000,6000,8000,10000,12000,14000,16000,18000,20000,1};
	local reputationValueLevel79 = {0,10000,20000,25000,30000,45000};
	local reputationValueLevel70 = {10000, 20000, 25000, 30000, 45000, 60000, 90000};
	local reputationValueLevel100 = {1500,4500,9000,13500,18000};
	local reputationValueLevel102 = {15000, 20000, 20000, 20000, 20000, 30000, 1};
	local reputationValueLevel106 = {0, 2500, 5000, 7500, 10000, 15000};

	local playerRepPosition = tonumber(PlayerReput[PlayerName]["Reput" .. i].position);
	local playerRepValue = PlayerReput[PlayerName]["Reput" .. i].value;
	local playerRepName = PlayerReput[PlayerName]["Reput" .. i].name;
	local playerRepGenre = PlayerReput[PlayerName]["Reput" .. i].genre;

	playerRepValue = playerRepValue - rpPTS;

	if(i == 69)then
		reputationValueLevel = reputationValueLevel69;
	elseif(i == 70)then
		reputationValueLevel = reputationValueLevel70;
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 3;
		end
	elseif(i == 102)then
		reputationValueLevel = reputationValueLevel102;
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 1;
		end

	elseif(i == 71)then
		reputationValueLevel = reputationValueLevel71;
	elseif(i == 100)then
		reputationValueLevel = reputationValueLevel100;
	elseif(i == 79)then
		reputationValueLevel = reputationValueLevel79;
	elseif(i == 64)then
		reputationValueLevel = reputationValueLevel64;
	elseif(i == 102)then
		reputationValueLevel = reputationValueLevel102;
	elseif(i == 106)then
		reputationValueLevel = reputationValueLevel106;
	elseif(i == 21 or i == 22 or i == 23 or i == 24 or i == 25 or i == 26 or i == 27)then
		reputationValueLevel = reputationValueMax;
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

	lvlValue = tonumber(playerRepPosition);
	lvlNextRepPos = tonumber(playerRepPosition) - 1;

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
	local reputationValueMax = {20000,10000,0,10000,30000,55000,85000,130000,190000,280000,480000};
	local reputationValueLevel = {10000,10000,0,10000,20000,25000,30000,45000,60000,90000,200000};
	local reputationValueLevel69 = {10000,20000,20000,1};
	local reputationValueLevel64 = {10000,20000,25000,30000};
	local reputationValueLevel70 = {10000, 15000, 20000, 20000, 20000, 20000, 30000, 1};
	local reputationValueLevel71 = {4000,6000,8000,10000,12000,14000,16000,18000,20000,1};
	local reputationValueLevel79 = {0,10000,20000,25000,30000,45000};
	local reputationValueLevel100 = {1500,4500,9000,13500,18000};
	local reputationValueLevel102 = {15000, 20000, 20000, 20000, 20000, 30000, 1};
	local reputationValueLevel106 = {0, 2500, 5000, 7500, 10000, 15000};

	local playerRepPosition = tonumber(PlayerReput[PlayerName]["Reput" .. i].position);
	local playerRepValue = PlayerReput[PlayerName]["Reput" .. i].value;
	local playerRepName = PlayerReput[PlayerName]["Reput" .. i].name;
	local playerRepGenre = PlayerReput[PlayerName]["Reput" .. i].genre;

	playerRepValue = playerRepValue + rpPTS;

	if(i == 69)then
		reputationValueLevel = reputationValueLevel69;
	elseif(i == 70)then
		reputationValueLevel = reputationValueLevel70;
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 3;
		end
	elseif(i == 102)then
		reputationValueLevel = reputationValueLevel102;
		if(PlayerReput[PlayerName]["Reput" .. i].position >= 7)then
			PlayerReput[PlayerName]["Reput" .. i].position = PlayerReput[PlayerName]["Reput" .. i].position - 1;
		end
	elseif(i == 71)then
		reputationValueLevel = reputationValueLevel71;
	elseif(i == 100)then
		reputationValueLevel = reputationValueLevel100;
	elseif(i == 79)then
		reputationValueLevel = reputationValueLevel79;
	elseif(i == 64)then
		reputationValueLevel = reputationValueLevel64;
	elseif(i == 102)then
		reputationValueLevel = reputationValueLevel102;
	elseif(i == 106)then
		reputationValueLevel = reputationValueLevel106;
	elseif(i == 21 or i == 22 or i == 23 or i == 24 or i == 25 or i == 26 or i == 27)then
		reputationValueLevel = reputationValueMax;
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

	lvlValue = tonumber(playerRepPosition) + tonumber(playerRepGenre);
	lvlNextRepPos = tonumber(playerRepPosition) + 1;

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
function UpdaterFromChat()
	Turbine.Chat.Received = function(sender, args)
		------------------------------------------------------------------------------------------
		-- checker to update xp points --
		------------------------------------------------------------------------------------------
		local ChatMessage = args.Message;
		local paternPointsXP;
		local XPPTS;
		if ChatMessage ~= nil then
			if GLocale == "en" then
				paternPointsXP = "You've earned ([%d%p]*)% XP for a total of";
				--You've earned 8 XP for a total of 444 XP.
				XPPTS = string.match( ChatMessage, paternPointsXP );
			elseif GLocale == "fr" then
				paternPointsXP = "Vous avez gagn\195\169 ([%d%p]*)% points d'exp\195\169rience, soit un total de ";
				XPPTS = string.match( ChatMessage, paternPointsXP );
				--Vous avez gagné 126 points d'expérience, soit un total de 32,991 points d'expérience
			elseif GLocale == "de" then
				paternPointsXP = "Ihr habt ([%d%p]*) EP erhalten und verf\195\188gt jetzt insgesamt \195\188ber";
				--Ihr habt 8 EP erhalten und verfügt jetzt insgesamt über 452 EP.
				XPPTS = string.match( ChatMessage, paternPointsXP );
			end

			if(XPPTS ~= nil)then
				--Write("J'update de : " .. tostring(XPPTS) );
				local XPPTS = string.gsub( XPPTS, ",", "" );
				PlayerXp[PlayerName] = PlayerXp[PlayerName] + XPPTS;

				if(PlayerXp[PlayerName] ~= nil and PlayerLevelXP[PlayerDatas[PlayerName].lvl] ~= nil)then
					if(PlayerXp[PlayerName] >= (PlayerLevelXP[PlayerDatas[PlayerName].lvl] - PlayerLevelXP[PlayerDatas[PlayerName].lvl -1]))then
						PlayerXp[PlayerName] = PlayerXp[PlayerName] - (PlayerLevelXP[PlayerDatas[PlayerName].lvl] - PlayerLevelXP[PlayerDatas[PlayerName].lvl -1]);
					end
				end

				SavePlayerDatas();
			end
		end


		--------------------- testage ---------------------------
		-- Updater of the reputation
		---------------------------------------------------------
		local reputMessage = args.Message;
		--Write("msg : " .. reputMessage);
		local rpName = "";
		local rpPTS = "";
		local rpPTSTodisplay = "";
		local rpBonus = nil;
		local cstr, paternName, paternPoints, paternBonus;

		if reputMessage ~= nil then
			-- Check string, Reputation Name and Reputation Point pattern
			if GLocale == "en" then
				paternName = "reputation with ([%a%p%u%l%s]*) has increased by";
				paternPoints = "has increased by ([%d%p]*)%.";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			elseif GLocale == "fr" then
				paternName = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de";
				paternPoints = "a augment\195\169 de ([%d%p]*)%.";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			elseif GLocale == "de" then
				paternName = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um";
				paternPoints = "hat sich um ([%d%p]*) verbessert";
				rpName = string.match( reputMessage, paternName );
				rpPTS = string.match( reputMessage, paternPoints );
			end
			
			for i=1, nbrFactions do
				if(string.match( reputMessage, T[ "reputname" .. i]))then
					rpName = T[ "reputname" .. i];
					rpPTS = string.match( reputMessage, paternPoints );
				end
			end

			-- check string if an accelerator was used
			if GLocale == "de" then
				cstr = string.match( reputMessage, "Bonus" );
			else 
				cstr = string.match( reputMessage, "bonus" ); 
			end
			-- Accelerator was used, end of string is different.
			-- Ex. (700 from bonus). instead of just a dot after the
			-- amount of points
			if cstr ~= nil then
				if GLocale == "en" then
					paternName = "reputation with ([%a%p%u%l%s]*) has increased by";
					paternPoints = "has increased by ([%d%p]*) %(";
					paternBonus = "%(([%d%p]*) from bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				elseif GLocale == "fr" then
					paternName = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de";
					paternPoints = "a augment\195\169 de ([%d%p]*) %(";
					paternBonus = "%(([%d%p]*) du bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				elseif GLocale == "de" then
					paternName = "Euer Ruf bei der Gruppe \"([%a%p%u%l%s]*)\" wurde um";
					paternPoints = "wurde um ([%d%p]*) erh\195\182ht";
					paternBonus = "%(([%d%p]*) durch Bonus";
					rpName = string.match( reputMessage, paternName );
					rpPTS = string.match( reputMessage, paternPoints );
					rpBonus = string.match( reputMessage, paternBonus );
				end

				for i=1, nbrFactions do
					if(string.match( reputMessage, T[ "reputname" .. i]))then
						rpName = T[ "reputname" .. i];
						rpPTS = string.match( reputMessage, paternPoints );
						rpBonus = string.match( reputMessage, paternBonus );
					end
				end
			end

			if(rpPTS ~= nil)then
				local rpPTS = string.gsub( rpPTS, ",", "" );
				rpPTSTodisplay = string.format( "%.0f", rpPTS );
				for i=1, nbrFactions do
					if(rpName == T[ "reputname" .. i])then
						if(settings["showProgressReput"]["value"] == true)then
							if(rpBonus ~= nil)then
								rpBonus = string.gsub( rpBonus, ",", "" );
								rpBonusTodisplay = string.format( "%.0f", rpBonus );
								if GLocale == "en" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " (" .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " from bonus)");
								elseif GLocale == "fr" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " (" .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " du bonus)");
								elseif GLocale == "de" then
									Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
									rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. 
									T[ "reputText1" ] .. " (" .. rgb["gold"] .. tostring(rpBonusTodisplay) .. rgb["clear"] .. " von Bonus)");
								end
							else
								Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
								rgb["green"] .. tostring(rpName) .. rgb["clear"] .. " + " .. 
									rgb["gold"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
							end
						end
						UpdateReput(i, rpPTS, rpBonus);
					end
				end
			end
		end
		------------------------------------------------------------------------------------------
		-- checker to update lotro points --
		------------------------------------------------------------------------------------------
		local CoinsMessage = args.Message;
		local paternPointsSdao;
		local rpPTSSdao;
		if CoinsMessage ~= nil then
			if GLocale == "en" then
				paternPointsSdao = "You've earned ([%d%p]*)% LOTRO Points";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			elseif GLocale == "fr" then
				paternPointsSdao = "Vous avez gagn\195\169 ([%d%p]*)% points SdAO.";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			elseif GLocale == "de" then
				paternPointsSdao = "Ihr habt ([%d%p]*) Punkte erhalten.";
				rpPTSSdao = string.match( CoinsMessage, paternPointsSdao );
			end

			if(rpPTSSdao ~= nil)then
				local rpPTSSdao = string.gsub( rpPTSSdao, ",", "" );
				settings["lotroCoins"]["value"] = settings["lotroCoins"]["value"] + rpPTSSdao;
				if(settings["showProgressLotro"]["value"] == true)then
					if GLocale == "en" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"]);
					elseif GLocale == "fr" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
					elseif GLocale == "de" then
						Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
						rgb["green"] .. T[ "reputText2" ] .. " " .. rgb["clear"] .. 
						rgb["gold"] .. tostring(rpPTSSdao) .. rgb["clear"]);
					end
				end
			end
		end

		------------------------------------------------------------------------------------------
		-- checker to decrease reputations --
		------------------------------------------------------------------------------------------
		local decreaseMessage = args.Message;
		local rpNameDecrease = "";
		local rpPTSTodisplay = "";
		local paternNameDecrease, paternDecrease;

		if decreaseMessage ~= nil then
			-- Check string, Reputation Name and Reputation Point pattern
			-- Euer Ruf bei Galadhrim hat sich um 8 verschlechtert.
			if GLocale == "en" then
				paternNameDecrease = "reputation with ([%a%p%u%l%s]*) has decreased by";
				paternDecrease = "has decreased by ([%d%p]*)%.";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			elseif GLocale == "fr" then
				paternNameDecrease = "de la faction ([%a%p%u%l%s]*) a diminu\195\169 de";
				paternDecrease = "a diminu\195\169 de ([%d%p]*)%.";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			elseif GLocale == "de" then
				paternNameDecrease = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um";
				paternDecrease = "hat sich um ([%d%p]*) verschlechtert";
				rpNameDecrease = string.match( decreaseMessage, paternNameDecrease );
				rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
			end

			for i=1, nbrFactions do
				if(string.match( decreaseMessage, T[ "reputname" .. i]))then
					rpNameDecrease = T[ "reputname" .. i];
					rpPTSDecrease = string.match( decreaseMessage, paternDecrease );
				end
			end

			if(rpPTSDecrease ~= nil)then
				local rpPTSDecrease = string.gsub( rpPTSDecrease, ",", "" );
				rpPTSTodisplay = string.format( "%.0f", rpPTSDecrease );
				for i=1, nbrFactions do
					if(rpNameDecrease == T["reputname" .. i])then
						if(settings["showProgressReput"]["value"] == true)then
								
							Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " : " .. 
							rgb["green"] .. tostring(rpNameDecrease) .. rgb["clear"] .. " - " .. 
								rgb["red"] .. tostring(rpPTSTodisplay) .. rgb["clear"] .. " " .. T[ "reputText1" ]);
						end
						DecreaseReput(i, rpPTSDecrease);
					end
				end
			end
		end
	end
end
