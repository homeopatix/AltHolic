------------------------------------------------------------------------------------------
-- UI file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Initialize datas
------------------------------------------------------------------------------------------
buttonPlus = {};
centerLabelB = {};
ButtonPlusLabel = {};
centerLabelBLabel = {};
ButtonPlusLab = {};
centerLabelBLab = {};
ButtonPlusVoc = {};
centerLabelBVoc = {};
ButtonPlusCash = {};
centerLabelCash = {};
------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
function CreateMainWindow(widthWind, heightWind)
	
	local valToAdd = 0;

	if(settings["displayServers"]["value"] == true)then
		valToAdd = 30;
	else
		valToAdd = 0;
	end

	if(settings["displayDeleteIcon"]["value"] == true)then
		widthWind = widthWind + 80 + valToAdd;
		valToAdd = valToAdd + 30;
	else
		widthWind = widthWind + 40 + valToAdd;
	end

	if(Turbine.UI.Display:GetHeight() < heightWind)then
		heightWind = Turbine.UI.Display:GetHeight() - 150;
	end

	AltHolicWindow=Turbine.UI.Lotro.GoldWindow(); 
	AltHolicWindow:SetSize(widthWind, heightWind); 
	AltHolicWindow:SetText( T[ "PluginName" ] ); 
	AltHolicWindow.Message11=Turbine.UI.Label(); 
	AltHolicWindow.Message11:SetParent(AltHolicWindow); 
	AltHolicWindow.Message11:SetSize(150,10); 
	AltHolicWindow.Message11:SetPosition(AltHolicWindow:GetWidth()/2 - 75, AltHolicWindow:GetHeight() - 18); 
	AltHolicWindow.Message11:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicWindow.Message11:SetText( T[ "PluginText" ] ); 
	
	DisplayInfosWindow(AltHolicWindow:GetWidth()/2 - 75, AltHolicWindow:GetHeight() - 18);

	AltHolicWindow:SetZOrder(1);
	AltHolicWindow:SetWantsKeyEvents(true);
	AltHolicWindow:SetWantsUpdates(true);

	AltHolicWindow:SetPosition(settings["windowPosition"]["xPos"], settings["windowPosition"]["yPos"]);
	------------------------------------------------------------------------------------------
	-- birthday button displayer and handler
	------------------------------------------------------------------------------------------
	Birthday();
	------------------------------------------------------------------------------------------
	-- updater for lotro coins and reputations
	------------------------------------------------------------------------------------------
	UpdaterFromChat();
	------------------------------------------------------------------------------------------
	-- to test and to fill up the datas
	------------------------------------------------------------------------------------------
	--UpdateXPFromChat();
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------
	positionLabelVert = 20;
	positionLabelHori = 40;

	if(settings["nameAccount"]["account1"]["name"] == "")then
		DisplayLabel(1, positionLabelVert, positionLabelHori, T[ "PluginAddNew" ], "AddNew.tga"); 
	end

	a = {};
    for i in pairs(PlayerDatas) do 
		table.insert(a, i);
	end
    table.sort(a);

	local NbPeople = tablelength(PlayerDatas);
	--Write("NbPeople : " .. NbPeople);
	-- HeightSizeOfMap = settings["nameAccount"]["account1"]["nbrAlt"] * 46;
	HeightSizeOfMap = NbPeople * 46;

	if(settings["displayServers"]["value"])then
		local toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
		valHeightSizeMap = toSearch * 46;

		HeightSizeOfMap = valHeightSizeMap;
	end
	--Write("HeightSizeOfMap : " .. HeightSizeOfMap);

	-- create the viewport control all it needs is size and position as it is simply used to create viewable bounds for our map
	viewport1=Turbine.UI.Control();
	viewport1:SetParent(AltHolicWindow);
	if(settings["displaySpentCash"]["value"] == true)then
		viewport1:SetSize(widthWind - 45, heightWind - 210);
	else
		viewport1:SetSize(widthWind - 45, heightWind - 150);
	end

	local totest = 15;
	local totest2 = 75;

	--viewport1:SetPosition(23, 75);
	viewport1:SetPosition(totest, totest2);
	-- debug purpose
	--viewport1:SetBackColor(Turbine.UI.Color.Red);

	-- create the map content for our viewport, again, it only needs size and position as it is just a container for the grid of images
	viewport1.map=Turbine.UI.Control();
	viewport1.map:SetParent(viewport1); -- set the map as a child of the viewport so that it will be bounded by it for drawing purposes
	viewport1.map:SetSize(widthWind - 45, HeightSizeOfMap); -- we'll use a 5x4 grid but this obviously could be expanded, or even set up as a recycled array of controls
	viewport1.map:SetPosition(0,0); -- we'll start off in the upper left

	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		PopulateWindow(valToAdd); 
	end

	if(HeightSizeOfMap > viewport1:GetHeight())then 
		vscroll1=Turbine.UI.Lotro.ScrollBar();
		vscroll1:SetParent(AltHolicWindow);
		vscroll1:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscroll1:SetPosition(widthWind-20, 70);
		vscroll1:SetSize(12,viewport1:GetHeight()); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscroll1:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscroll1:SetMinimum(0);
		vscroll1:SetMaximum(viewport1.map:GetHeight()-viewport1:GetHeight()); -- we will allow scrolling the height of the map-the viewport height
		vscroll1:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscroll1.ValueChanged=function()
			viewport1.map:SetTop(0-vscroll1:GetValue());
		end
	end

	------------------------------------------------------------------------------------------
	-- cash displayer
	------------------------------------------------------------------------------------------
	local totalCash = 0;

	if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
		for i in pairs(PlayerDatas) do
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then
						if(PlayerDatas[i].cash ~= nil)then
							totalCash = totalCash + PlayerDatas[i].cash ;
						end
						if(PlayerDatas[i].bagCash ~= nil)then
							totalCash = totalCash +  PlayerDatas[i].bagCash ;
						end
						if(PlayerDatas[i].vaultCash ~= nil)then
							totalCash = totalCash +  PlayerDatas[i].vaultCash ;
						end
			end
		end

		totalCash = totalCash + tonumber(settings["sharedStorageCash"]["value"]);

		DisplayCash(PlayerDatas[PlayerName].cash, AltHolicWindow, PlayerName);
		if(settings["displayTotalCash"]["value"] == true)then
			DisplayCash(totalCash, AltHolicWindow);
		end
		------------------------------------------------------------------------------------------
		-- cash session displayer
		------------------------------------------------------------------------------------------
		if(settings["displaySpentCash"]["value"] == true)then
			DisplaySessionCash();
			DisplaySpentCash();
		end
	end
	------------------------------------------------------------------------------------------
	-- cash button for cash window
	------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		buttonDefineForCashWindow = Turbine.UI.Extensions.SimpleWindow();
		buttonDefineForCashWindow:SetParent( AltHolicWindow );
		buttonDefineForCashWindow:SetPosition(AltHolicWindow:GetWidth() - 50, AltHolicWindow:GetHeight() - 50 );
		buttonDefineForCashWindow:SetSize( 32, 32 );
		buttonDefineForCashWindow:SetVisible(true);

		centerLabelForCashWindow = Turbine.UI.Label();
		centerLabelForCashWindow:SetParent(buttonDefineForCashWindow);
		centerLabelForCashWindow:SetPosition( 0, 0 );
		centerLabelForCashWindow:SetSize( 32, 32  );
		centerLabelForCashWindow:SetZOrder(-1);
		centerLabelForCashWindow:SetBackground(0x41004641); --0x41005E9E -- 32x32 = 0x41004641
	
		DisplayCashWindow(AltHolicWindow:GetWidth() - 50, AltHolicWindow:GetHeight() - 50);
	end

	EscapeKeyHandler();
	PositionChangedWindow();
	ClosingTheWindow();

	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		UpdateChecker(); 
	end
end
------------------------------------------------------------------------------------------
-- Update checker
------------------------------------------------------------------------------------------
function UpdateChecker()
	AltHolicWindow.Update = function()

	UpdaterFromChat();
	--UpdateXPFromChat();

	--Check timer set on 100 = environ 30sec
		if(valCheck <= 0 and Player:IsInCombat() == false)then
			valCheck = 100;
			UpdateLvl();
			UpdateCash();

			vaultpack.ItemsRefreshed = function()
				vaultHasBeenUpdated = true;
				SavePlayerVault();
				UpdateMainWindow();
				UpdateBar();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginVaultSaved" ]);
				end
			end
			vaultpack.ItemAdded = function()
				vaultHasBeenUpdated = true;
				SavePlayerVault();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginVaultSaved" ]);
				end
			end
			vaultpack.ItemRemoved = function()
				vaultHasBeenUpdated = true;
				SavePlayerVault();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginVaultSaved" ]);
				end
			end
			sspack.ItemsRefreshed = function()
				sharedStorageHasBeenUpdated = true;
				SaveSharedStorage();
				UpdateMainWindow();
				UpdateBar();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginSharedStorageSaved" ]);
				end
			end
			sspack.ItemAdded = function()
				sharedStorageHasBeenUpdated = true;
				SaveSharedStorage();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginSharedStorageSaved" ]);
				end
			end
			sspack.ItemRemoved = function()
				sharedStorageHasBeenUpdated = true;
				SaveSharedStorage();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginSharedStorageSaved" ]);
				end
			end
			backpack.ItemAdded = function()
				SavePlayerBags();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginBagSaved" ]);
				end
			end
			backpack.ItemRemoved = function()
				SavePlayerBags();
				if(settings["verbose"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginBagSaved" ]);
				end
			end
		else
			valCheck = valCheck - 1;
		end

		if(settings["nameAccount"]["account1"]["name"] ~= "")then
			CountPlayers = 0;
			for i in pairs(PlayerDatas) do 
				CountPlayers = CountPlayers + 1;
			end
			settings["nameAccount"]["account1"]["nbrAlt"] = CountPlayers;
		end
	end
end
------------------------------------------------------------------------------------------
-- populate window
------------------------------------------------------------------------------------------
function PopulateWindow(valToAdd)
	local posx = 40;
	local posy = 50;
	local longueurName = 0;
	------------------------------------------------------------------------------------------
	-- write the name of the account
	------------------------------------------------------------------------------------------
		if(settings["nameAccount"]["account1"]["name"] ~= "")then
			AltHolicWindow.Message4=Turbine.UI.Label(); 
			AltHolicWindow.Message4:SetParent(AltHolicWindow); 
			AltHolicWindow.Message4:SetSize(280,30); 
			AltHolicWindow.Message4:SetPosition(55 + valToAdd, 40); 

			longueurName = string.len(settings["nameAccount"]["account1"]["name"])
			if(longueurName > 10)then
				AltHolicWindow.Message4:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
			else
				AltHolicWindow.Message4:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
			end

			AltHolicWindow.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			AltHolicWindow.Message4:SetText(settings["nameAccount"]["account1"]["name"]);
			AltHolicWindow.Message4:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 ));
		end

		buttonIsVisible = Turbine.UI.Extensions.SimpleWindow();
		buttonIsVisible:SetParent( AltHolicWindow );
		buttonIsVisible:SetPosition(posx + 280 + valToAdd, posy - 3);
		buttonIsVisible:SetSize( 16, 16 );
		buttonIsVisible:SetVisible(true);

		centerLabelIsVisible = Turbine.UI.Label();
		centerLabelIsVisible:SetParent(buttonIsVisible);
		centerLabelIsVisible:SetPosition( 0, 0 );
		centerLabelIsVisible:SetSize( 16, 16  );
		centerLabelIsVisible:SetZOrder(-1);
		centerLabelIsVisible:SetMouseVisible(false);
	------------------------------------------------------------------------------------------
	-- button enroule et deroule
	------------------------------------------------------------------------------------------
		if(settings["nameAccount"]["account1"]["name"] ~= "")then
			if(settings["nameAccount"]["account1"]["isVisible"] == true)then
				centerLabelIsVisible:SetBackground(0x41007E26); --- - 0x41007E26 -- brown 0x41110B5E -- dor 0x41110B5D
			else
				centerLabelIsVisible:SetBackground(0x41007E27); -- + 0x41007E27   -- brown 0x41110B61 -- doré 0x41110B60
			end
		end

		buttonIsVisible.MouseClick = function()
			if(settings["nameAccount"]["account1"]["isVisible"] == true)then
				settings["nameAccount"]["account1"]["isVisible"] = false;
			else
				settings["nameAccount"]["account1"]["isVisible"] = true;	
			end
			UpdateMainWindow();
		end
	------------------------------------------------------------------------------------------
	-- sharedstorage
	------------------------------------------------------------------------------------------
		buttonIsVisibleSS = Turbine.UI.Extensions.SimpleWindow();
		buttonIsVisibleSS:SetParent( AltHolicWindow );
		buttonIsVisibleSS:SetPosition(20, posy - 10);
		buttonIsVisibleSS:SetSize( 32, 32 );
		buttonIsVisibleSS:SetVisible(true);

		centerLabelIsVisibleSS = Turbine.UI.Label();
		centerLabelIsVisibleSS:SetParent(buttonIsVisibleSS);
		centerLabelIsVisibleSS:SetPosition( 0, 0 );
		centerLabelIsVisibleSS:SetSize( 32, 32  );
		centerLabelIsVisibleSS:SetBackground(0x4111BE35); -- sharedstorage
		centerLabelIsVisibleSS:SetZOrder(-1);
		centerLabelIsVisibleSS:SetMouseVisible(false);

		buttonIsVisibleSS.MouseClick = function()
			if(settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] == true)then
				settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = false;
				UIShowSharedStorage:SetVisible(false);
			else
				CreateUIShowSharedStorage("lines");
				UIShowSharedStorage:SetVisible(true);
				settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = true;	
			end
		end
		DisplayLabelCadreForSharedStorage(20, posy -10, T[ "PluginSharedStorage1" ], buttonIsVisibleSS);

	------------------------------------------------------------------------------------------
	-- XP Player
	------------------------------------------------------------------------------------------
		buttonIsVisibleXP = Turbine.UI.Extensions.SimpleWindow();
		buttonIsVisibleXP:SetParent( AltHolicWindow );
		buttonIsVisibleXP:SetPosition(55, posy - 10);
		buttonIsVisibleXP:SetSize( 32, 32 );
		buttonIsVisibleXP:SetVisible(true);

		centerLabelIsVisibleXP = Turbine.UI.Label();
		centerLabelIsVisibleXP:SetParent(buttonIsVisibleXP);
		centerLabelIsVisibleXP:SetPosition( 0, 0 );
		centerLabelIsVisibleXP:SetSize( 32, 32  );
		centerLabelIsVisibleXP:SetBackground(0x411A3870); -- fleche vers le haut sur fond bleu 0x41108A95
		-- 0x411A3870
		centerLabelIsVisibleXP:SetZOrder(-1);
		centerLabelIsVisibleXP:SetMouseVisible(false);

		DisplayXPWindow(55, posy - 10);
	------------------------------------------------------------------------------------------
	-- book button for epique window
	------------------------------------------------------------------------------------------
		if(settings["nameAccount"]["account1"]["name"] ~= "")then
			buttonDefineForEpiqueWindow = Turbine.UI.Extensions.SimpleWindow();
			buttonDefineForEpiqueWindow:SetParent( AltHolicWindow );
			buttonDefineForEpiqueWindow:SetPosition(90 + valToAdd, posy - 12 );
			buttonDefineForEpiqueWindow:SetSize( 32, 32 );
			buttonDefineForEpiqueWindow:SetVisible(true);
			buttonDefineForEpiqueWindow:SetBackColor(Turbine.UI.Color.Red);

			centerLabelForEpiqueWindow = Turbine.UI.Label();
			centerLabelForEpiqueWindow:SetParent(buttonDefineForEpiqueWindow);
			centerLabelForEpiqueWindow:SetPosition( 0, 0 );
			centerLabelForEpiqueWindow:SetSize( 32, 32  );
			centerLabelForEpiqueWindow:SetBackground(0x41139D6B); -- nice epique book
			centerLabelForEpiqueWindow:SetZOrder(-1);
			centerLabelForEpiqueWindow:SetMouseVisible(false);
	
			DisplayEpiqueWindow(12, 90 + valToAdd, 40);
		end
	------------------------------------------------------------------------------------------
	-- search loupe -- search loupe not over = 0x410D6DC4
	------------------------------------------------------------------------------------------
		buttonIsVisibleSearchNew = Turbine.UI.Extensions.SimpleWindow();
		buttonIsVisibleSearchNew:SetParent( AltHolicWindow );
		buttonIsVisibleSearchNew:SetPosition(posx + 325 + valToAdd, posy - 10);
		buttonIsVisibleSearchNew:SetSize( 32, 32 );
		buttonIsVisibleSearchNew:SetVisible(true);

		centerLabelIsVisibleSearch = Turbine.UI.Label();
		centerLabelIsVisibleSearch:SetParent(buttonIsVisibleSearchNew);
		centerLabelIsVisibleSearch:SetPosition( 0, 0 );
		centerLabelIsVisibleSearch:SetSize( 32, 32  );
		centerLabelIsVisibleSearch:SetBackground(0x410D6DC2); 
		centerLabelIsVisibleSearch:SetZOrder(-1);
		centerLabelIsVisibleSearch:SetMouseVisible(false);

		buttonIsVisibleSearchNew.MouseClick = function()
			if(settings["isSearchWindowVisible"]["isSearchWindowVisible"] == true)then
				settings["isSearchWindowVisible"]["isSearchWindowVisible"] = false;
				UIShowSearch:SetVisible(false);
			else
				CreateUiSearch("**", "all", "lines");
				UIShowSearch:SetVisible(true);
				settings["isSearchWindowVisible"]["isSearchWindowVisible"] = true;	
			end
		end
		DisplayLabelCadreForSearch(posx + 325 + valToAdd, posy -10, buttonIsVisibleSearchNew);

	posy = -20;

	if(settings["nameAccount"]["account1"]["isVisible"] == true)then
		for n, i in ipairs(a) do 
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then
				------------------------------------------------------------------------------------------
				-- display the lvl of the players
				------------------------------------------------------------------------------------------
				if(settings["nameAccount"]["account1"]["name"] ~= "")then 
					AltHolicWindow.Message13=Turbine.UI.Label(); 
					AltHolicWindow.Message13:SetParent(viewport1.map); 
					AltHolicWindow.Message13:SetSize(32,32); 
					AltHolicWindow.Message13:SetPosition(posx -28 + valToAdd, posy + 30); 
					AltHolicWindow.Message13:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
					AltHolicWindow.Message13:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
					AltHolicWindow.Message13:SetText(tostring(PlayerDatas[i].lvl));
					--AltHolicWindow.Message13:SetBackColor(Turbine.UI.Color.Green);
					if(settings["displayLvlMax"]["value"] == true)then
						if(PlayerDatas[i].lvl == LevelMax)then
							AltHolicWindow.Message13:SetForeColor(Turbine.UI.Color.Red);
							AltHolicWindow.Message13:SetBackground(0x4111219A);
						else
							AltHolicWindow.Message13:SetForeColor(Turbine.UI.Color.Lime);
							AltHolicWindow.Message13:SetBackground(0x4111219B);
						end
					else
						AltHolicWindow.Message13:SetForeColor(Turbine.UI.Color.Lime);
						AltHolicWindow.Message13:SetBackground(0x4111219B);
					end
					AltHolicWindow.Message13:SetBlendMode(Turbine.UI.BlendMode.Overlay);
					AltHolicWindow.Message13:SetZOrder(10);
					AltHolicWindow.Message13:SetMouseVisible(true);

					DisplayLabelStats(i, posx - 30 + valToAdd, posy, AltHolicWindow.Message13);
				end
				------------------------------------------------------------------------------------------
				--- display serverName
				------------------------------------------------------------------------------------------
				if(settings["nameAccount"]["account1"]["name"] ~= "")then 
					if(settings["displayServers"]["value"] == true)then
						AltHolicWindow.Message135=Turbine.UI.Label(); 
						AltHolicWindow.Message135:SetParent(viewport1.map); 
						AltHolicWindow.Message135:SetSize(32,32); 
						--AltHolicWindow.Message135:SetBackColor(Turbine.UI.Color.Red);
						AltHolicWindow.Message135:SetPosition(posx - 64 + valToAdd, posy + 30); 
						--AltHolicWindow.Message135:SetBackground(0x4101DD0C);
						AltHolicWindow.Message135:SetBackground(ResourcePath .. "Server_Icon.tga");
						AltHolicWindow.Message135:SetBlendMode(Turbine.UI.BlendMode.Overlay);
						AltHolicWindow.Message135:SetZOrder(3);
						AltHolicWindow.Message135:SetMouseVisible(true);

						if(ReturnValueServer(i) > 0)then
							AltHolicWindow.Message136=Turbine.UI.Label(); 
							AltHolicWindow.Message136:SetParent(viewport1.map); 
							AltHolicWindow.Message136:SetSize(25,20); 
							AltHolicWindow.Message136:SetPosition(posx - 60 + valToAdd, posy + 40); 
							AltHolicWindow.Message136:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
							AltHolicWindow.Message136:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
							AltHolicWindow.Message136:SetForeColor(Turbine.UI.Color.Red);
							--AltHolicWindow.Message136:SetBackColor(Turbine.UI.Color.Red);
							AltHolicWindow.Message136:SetText(tostring(ReturnValueServer(i)));
							AltHolicWindow.Message136:SetZOrder(4);
							AltHolicWindow.Message136:SetMouseVisible(true);

							DisplayLabelServerName(i, posx - 22 + valToAdd, posy, AltHolicWindow.Message136);
						end
				
						DisplayLabelServerName(i, posx - 22 + valToAdd, posy, AltHolicWindow.Message135);
					end
				end
				------------------------------------------------------------------------------------------
				--- display deleteIcon
				------------------------------------------------------------------------------------------
				if(settings["nameAccount"]["account1"]["name"] ~= "")then 
					if(settings["displayDeleteIcon"]["value"] == true)then
						AltHolicWindow.Message1354=Turbine.UI.Label(); 
						AltHolicWindow.Message1354:SetParent(viewport1.map); 
						AltHolicWindow.Message1354:SetSize(32,32); 
						--AltHolicWindow.Message1354:SetBackColor(Turbine.UI.Color.Red);
						AltHolicWindow.Message1354:SetPosition(posx - 36, posy + 30); 
						AltHolicWindow.Message1354:SetBackground(0x4111D248);
						--AltHolicWindow.Message1354:SetBackground(ResourcePath .. "Server_Icon.tga");
						AltHolicWindow.Message1354:SetBlendMode(Turbine.UI.BlendMode.Overlay);
						AltHolicWindow.Message1354:SetZOrder(3);
						AltHolicWindow.Message1354:SetMouseVisible(true);
				
						DisplayLabelDelete(i, posx - 36, posy, AltHolicWindow.Message1354);
					end
				end
				------------------------------------------------------------------------------------------
				--- display vocation
				------------------------------------------------------------------------------------------
				--[[
				buttonDefineHouseLocationPersonal2 = Turbine.UI.Control();
				buttonDefineHouseLocationPersonal2:SetParent( viewport1.map );
				buttonDefineHouseLocationPersonal2:SetPosition(posx + 310 + valToAdd, posy + 23);
				buttonDefineHouseLocationPersonal2:SetSize( 45, 45 );
				buttonDefineHouseLocationPersonal2:SetVisible(true);
			
				centerLabelB21 = Turbine.UI.Label();
				centerLabelB21:SetParent(buttonDefineHouseLocationPersonal2);
				centerLabelB21:SetPosition( 0, 0 );
				centerLabelB21:SetSize( 45, 45  );
				centerLabelB21:SetZOrder(5);
				centerLabelB21:SetBlendMode(Turbine.UI.BlendMode.Overlay);

				if(settings["nameAccount"]["account1"]["name"] ~= "")then  
					if(PlayerDatas[i].voc == 1)then
						centerLabelB21:SetBackground(0x4110DB16);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation1" ]);
					end
					if(PlayerDatas[i].voc == 2)then
						centerLabelB21:SetBackground(0x4110DB18);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation2" ]);
					end
					if(PlayerDatas[i].voc == 3)then
						centerLabelB21:SetBackground(0x4110DB13);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation3" ]);
					end
					if(PlayerDatas[i].voc == 4)then
						centerLabelB21:SetBackground(0x4110DB19);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation4" ]);
					end
					if(PlayerDatas[i].voc == 5)then
						centerLabelB21:SetBackground(0x4110DB17);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation5" ]);
					end
					if(PlayerDatas[i].voc == 6)then
						centerLabelB21:SetBackground(0x4110DB14);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation6" ]);
					end
					if(PlayerDatas[i].voc == 7)then
						centerLabelB21:SetBackground(0x4110DB15);
						DisplaySmallLabel(i, posx + 310 + valToAdd, posy + 23, T[ "PluginVocation7" ]);
					end
					centerLabelB21:SetMouseVisible(true);
				end

				]]--


				if(settings["nameAccount"]["account1"]["name"] ~= "")then 
					------------------------------------------------------------------------------------------
					-- display bag button
					------------------------------------------------------------------------------------------
					DisplayBag(i, posx + 70 + valToAdd, posy, PlayerDatas[i].voc);

					local nbrItemInVault = 0;
					------------------------------------------------------------------------------------------
					-- display vault button
					------------------------------------------------------------------------------------------
					DisplayVault(i, posx + 65 + valToAdd, posy, PlayerDatas[i].voc);
					------------------------------------------------------------------------------------------
					-- display wallet button
					------------------------------------------------------------------------------------------
					DisplayWallet(i, posx + 60 + valToAdd, posy);
				end
				------------------------------------------------------------------------------------------
				--- define race
				------------------------------------------------------------------------------------------
				buttonDefineHouseLocationPersonal = Turbine.UI.Control();
				buttonDefineHouseLocationPersonal:SetParent( viewport1.map );
				buttonDefineHouseLocationPersonal:SetPosition(posx + 9 + valToAdd, posy + 30);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(buttonDefineHouseLocationPersonal);
				centerLabelB5:SetPosition( 0, 0 );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);
				centerLabelB5:SetBlendMode(Turbine.UI.BlendMode.Overlay);

				if(settings["nameAccount"]["account1"]["name"] ~= "")then
						--centerLabelB:SetBackground(ResourcePath .. tostring(PlayerDatas[i].cla));
						if(PlayerDatas[i].rac == 81)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x4110894A);
							else
								centerLabelB5:SetBackground(0x41108949);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 23)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x41108945);
							else
								centerLabelB5:SetBackground(0x4110894B);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 65)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x41108947);
							else
								centerLabelB5:SetBackground(0x41108948);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 114)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x4115920D);
							else
								centerLabelB5:SetBackground(0x4115920A);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 120)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x411DAE7E);
							else
								centerLabelB5:SetBackground(0x411DAE7E);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 73)then
							centerLabelB5:SetBackground(0x41108946);
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 117)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x411C8D6B);
							else
								centerLabelB5:SetBackground(0x411C8D6A);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end
						if(PlayerDatas[i].rac == 125)then
							if(PlayerDatas[i].sexe == "male")then
								centerLabelB5:SetBackground(0x4110894A);
							else
								centerLabelB5:SetBackground(0x41108949);
							end
							DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
						end

						if(i == PlayerName)then
							------------------------------------------------------------------------------------------
							-- debut race monster play
							------------------------------------------------------------------------------------------
							if(PlayerDatas[i].rac == 7)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor_red.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 12)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor_red.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 6)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor_red.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 66)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor_red.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
						else
							------------------------------------------------------------------------------------------
							-- debut race monster play
							------------------------------------------------------------------------------------------
							if(PlayerDatas[i].rac == 7)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 12)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 6)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
							if(PlayerDatas[i].rac == 66)then
								centerLabelB5:SetBackground(ResourcePath .. "Mordor.tga");
								DisplayLabelSexe(i, posx + valToAdd, posy, buttonDefineHouseLocationPersonal);
							end
						end
				end
				------------------------------------------------------------------------------------------
				--- define classe
				------------------------------------------------------------------------------------------
				buttonDefineHouseLocationPersonal = Turbine.UI.Control();
				buttonDefineHouseLocationPersonal:SetParent( viewport1.map );
				buttonDefineHouseLocationPersonal:SetPosition(posx + 47 + valToAdd, posy + 30);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);
			

				centerLabelB6 = Turbine.UI.Control();
				centerLabelB6:SetParent(buttonDefineHouseLocationPersonal);
				centerLabelB6:SetPosition( 0, 0 );
				centerLabelB6:SetSize( 32, 32  );
				centerLabelB6:SetZOrder(-1);
				centerLabelB6:SetMouseVisible(false);
				centerLabelB6:SetBlendMode(Turbine.UI.BlendMode.Overlay);
				------------------------------------------------------------------------------------------
				-- display the class of the players
				------------------------------------------------------------------------------------------
				if(settings["nameAccount"]["account1"]["name"] ~= "")then 
						--centerLabelB:SetBackground(ResourcePath .. tostring(PlayerDatas[i].cla));
						if(PlayerDatas[i].cla == 162)then
							centerLabelB6:SetBackground(0x410095C2);
						end
						if(PlayerDatas[i].cla == 31)then
							centerLabelB6:SetBackground(0x4110867A);
						end
						if(PlayerDatas[i].cla == 214)then
							centerLabelB6:SetBackground(0x41153604);
						end
						if(PlayerDatas[i].cla == 24)then
							centerLabelB6:SetBackground(0x410095C5);
						end
						if(PlayerDatas[i].cla == 193)then
							centerLabelB6:SetBackground(0x4110867B);
						end
						if(PlayerDatas[i].cla == 40)then
							centerLabelB6:SetBackground(0x410095BB);
						end
						if(PlayerDatas[i].cla == 185)then
							centerLabelB6:SetBackground(0x410095BF);
						end
						if(PlayerDatas[i].cla == 23)then
							centerLabelB6:SetBackground(0x410095B8);
						end
						if(PlayerDatas[i].cla == 172)then
							centerLabelB6:SetBackground(0x410095B5);
						end
						if(PlayerDatas[i].cla == 194)then
							centerLabelB6:SetBackground(0x41108673);
						end
						if(PlayerDatas[i].cla == 215)then -- new class brawler
							centerLabelB6:SetBackground(0x4120fcd9);
						end
						if(PlayerDatas[i].cla == 216)then -- new class mariner
							centerLabelB6:SetBackground(0x4122f860);
						end

						-- Write("New class for : " .. i .. " " .. PlayerDatas[i].cla);

						if(i == PlayerName)then
							------------------------------------------------------------------------------------------
							-- debut class pour monster play
							------------------------------------------------------------------------------------------
							if(PlayerDatas[i].cla == 71)then
								centerLabelB6:SetBackground(ResourcePath .. "Faucheur_red.tga");
							end
							if(PlayerDatas[i].cla == 128)then
								centerLabelB6:SetBackground(ResourcePath .. "Profanateur_red.tga");
							end
							if(PlayerDatas[i].cla == 127)then
								centerLabelB6:SetBackground(ResourcePath .. "Araignee_red.tga");
							end
							if(PlayerDatas[i].cla == 179)then
								centerLabelB6:SetBackground(ResourcePath .. "FlecheNoire_red.tga");
							end
							if(PlayerDatas[i].cla == 52)then
								centerLabelB6:SetBackground(ResourcePath .. "ChefDeGuerre_red.tga");
							end
							if(PlayerDatas[i].cla == 126)then
								centerLabelB6:SetBackground(ResourcePath .. "Ouargue_red.tga");
							end
						else
							------------------------------------------------------------------------------------------
							-- debut class pour monster play
							------------------------------------------------------------------------------------------
							if(PlayerDatas[i].cla == 71)then
								centerLabelB6:SetBackground(ResourcePath .. "Faucheur.tga");
							end
							if(PlayerDatas[i].cla == 128)then
								centerLabelB6:SetBackground(ResourcePath .. "Profanateur.tga");
							end
							if(PlayerDatas[i].cla == 127)then
								centerLabelB6:SetBackground(ResourcePath .. "Araignee.tga");
							end
							if(PlayerDatas[i].cla == 179)then
								centerLabelB6:SetBackground(ResourcePath .. "FlecheNoire.tga");
							end
							if(PlayerDatas[i].cla == 52)then
								centerLabelB6:SetBackground(ResourcePath .. "ChefDeGuerre.tga");
							end
							if(PlayerDatas[i].cla == 126)then
								centerLabelB6:SetBackground(ResourcePath .. "Ouargue.tga");
							end
						end
				end
				------------------------------------------------------------------------------------------
				-- fond for connected player
				------------------------------------------------------------------------------------------
			if(settings["nameAccount"]["account1"]["name"] ~= "")then  

					buttonDefineInfosPersonal = Turbine.UI.Control();
					buttonDefineInfosPersonal:SetParent( viewport1.map );
					buttonDefineInfosPersonal:SetPosition(127 + valToAdd , posy + 30);
					buttonDefineInfosPersonal:SetSize( 120, 32 );
					buttonDefineInfosPersonal:SetVisible(true);
					buttonDefineInfosPersonal:SetZOrder(100);
					--buttonDefineInfosPersonal:SetBackColor(Turbine.UI.Color.Red);
					--DefineLabelInfo(i, posx, posy + 30, buttonDefineInfosPersonal);
					DefineLabelInfo(i, (Turbine.UI.Display:GetWidth()-380)/2,(Turbine.UI.Display:GetHeight()-360)/2, buttonDefineInfosPersonal);

					AltHolicWindow.Message6=Turbine.UI.Label(); 
					AltHolicWindow.Message6:SetParent(viewport1.map); 
					AltHolicWindow.Message6:SetSize(275 + valToAdd,32); 
					AltHolicWindow.Message6:SetPosition(127 + valToAdd , posy + 30); 
					AltHolicWindow.Message6:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
					AltHolicWindow.Message6:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
					AltHolicWindow.Message6:SetZOrder(1);
					AltHolicWindow.Message6:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);

					------------------------------------------------------------------------------------------
					--- cut off the name if too long

					------------------------------------------------------------------------------------------
					longueurName = string.len(i);
					if(longueurName > 33)then
						AltHolicWindow.Message6:SetText(string.sub(i, 1, 12) .. "...");
					else
						AltHolicWindow.Message6:SetText(i); 
					end

						DisplayEquipment(posx + 50 + valToAdd, posy + 30, i, PlayerDatas[i].align);

						if(i == PlayerName)then
							if(PlayerDatas[i].rac == 7 or 
								PlayerDatas[i].rac == 12 or
								PlayerDatas[i].rac == 6 or
								PlayerDatas[i].rac == 66)then
								AltHolicWindow.Message6:SetForeColor(Turbine.UI.Color.Gold);
							else
								AltHolicWindow.Message6:SetForeColor(Turbine.UI.Color.Lime);
							end

							AltHolicWindow.Message21=Turbine.UI.Label(); 
							AltHolicWindow.Message21:SetParent(viewport1.map); 
							AltHolicWindow.Message21:SetZOrder(-1);


							if(PlayerDatas[i].rac == 7 or 
								PlayerDatas[i].rac == 12 or
								PlayerDatas[i].rac == 6 or
								PlayerDatas[i].rac == 66)then

								AltHolicWindow.Message21:SetSize(400,32); 
								AltHolicWindow.Message21:SetPosition(8 , posy + 30); 
								AltHolicWindow.Message21:SetBackColor(Turbine.UI.Color( 0.9, 1, 0.1, 0.1 ));
							else
								AltHolicWindow.Message21:SetSize(400,32); 
								AltHolicWindow.Message21:SetPosition(8 , posy + 30); 
								AltHolicWindow.Message21:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
							end

						else
							AltHolicWindow.Message6:SetForeColor(Turbine.UI.Color.White);
						end
				end
				posy = posy + 45;
			end
		end
	end
end