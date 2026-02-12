------------------------------------------------------------------------------------------
-- UIShowSearch file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the bag window
------------------------------------------------------------------------------------------
function CreateUiSearch(textToSearch, where, howToDisplay)

	local nbrItemInBag = 0;
	local windowHeightSize = 0;
	local windowWidth = 0;

	windowWidth = 400;
	if(textToSearch == nil or textToSearch == "")then
		textToSearch = "**";
		where = "all";
	end

	if(howToDisplay == nil or howToDisplay == "")then
		howToDisplay = "lines";
	end

	nbrItemInBag = ReturnNbrItemsInBag(textToSearch);
	nbrItemInVault = ReturnNbrItemsInVault(textToSearch);
	nbrItemInWallet = ReturnNbrItemsInWallet(textToSearch);
	nbrItemInShared = ReturnNbrItemsInSharedStorage(textToSearch);

	if(where == "all") then
		nbrItemInBag = nbrItemInBag + nbrItemInVault + nbrItemInWallet + nbrItemInShared;
	end
	if(where == "bag") then
		nbrItemInBag = nbrItemInBag;
	end
	if(where == "vault") then
		nbrItemInBag = nbrItemInVault;
	end
	if(where == "wallet") then
		nbrItemInBag = nbrItemInWallet;
	end
	if(where == "shared") then
		nbrItemInBag = nbrItemInShared;
	end
	if(where == "") then
		nbrItemInBag = nbrItemInBag + nbrItemInVault + nbrItemInWallet + nbrItemInShared;
	end


	local heightWind = 650 + 70;

	if(Turbine.UI.Display:GetHeight() < heightWind)then
		heightWind = Turbine.UI.Display:GetHeight() - 150;
	end

	UIShowSearch=Turbine.UI.Lotro.GoldWindow(); 
	UIShowSearch:SetSize(windowWidth, heightWind); 
	UIShowSearch:SetText( T[ "PluginSearch" ] ); 
	UIShowSearch:SetPosition((Turbine.UI.Display:GetWidth()-UIShowSearch:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowSearch:GetHeight())/2); 

	UIShowSearch.Message=Turbine.UI.Label(); 
	UIShowSearch.Message:SetParent(UIShowSearch); 
	UIShowSearch.Message:SetSize(150,10); 
	UIShowSearch.Message:SetPosition(UIShowSearch:GetWidth()/2 - 75, UIShowSearch:GetHeight() - 20); 
	UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowSearch.Message:SetText(T[ "PluginText" ]); 
	UIShowSearch:SetZOrder(10);
	UIShowSearch:SetWantsKeyEvents(true);
	UIShowSearch:SetVisible(false);

	textBoxLines = Turbine.UI.Lotro.TextBox();
	textBoxLines:SetParent( UIShowSearch );
	textBoxLines:SetSize(300, 30); 
	textBoxLines:SetText( string.lower(textToSearch) ); 
	textBoxLines:SetPosition(UIShowSearch:GetWidth()/2 - 150, 50);
	textBoxLines:SetVisible(true);
	textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLines:SetForeColor( Turbine.UI.Color.Gold);
	textBoxLines:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));
	textBoxLines:SetMouseVisible(true);

	textBoxLines.FocusGained = function(sender, args)
		textBoxLines:SetText( "" );
		--Write("Click");
	end
	------------------------------------------------------------------------------------------
	-- positionnement 
	------------------------------------------------------------------------------------------
	MessageBtLines=Turbine.UI.Label(); 
	MessageBtLines:SetParent(UIShowSearch); 
	MessageBtLines:SetSize(21,21); 
	MessageBtLines:SetPosition(windowWidth - 40, 110);
	MessageBtLines:SetText(""); 
	if(howToDisplay == "lines")then
		MessageBtLines:SetBackground(0x4110C76D); 
	else
		MessageBtLines:SetBackground(0x4110C76F); 
	end
	MessageBtLines:SetMouseVisible(true);
	MessageBtLines:SetBlendMode(Turbine.UI.BlendMode.Overlay); 

	UIShowSearchBtNoLines=Turbine.UI.Label(); 
	UIShowSearchBtNoLines:SetParent(UIShowSearch); 
	UIShowSearchBtNoLines:SetSize(21,21); 
	UIShowSearchBtNoLines:SetPosition(windowWidth - 40, 141);
	UIShowSearchBtNoLines:SetText(""); 
	if(howToDisplay == "lines")then
		UIShowSearchBtNoLines:SetBackground(0x4110C76C); 
	else
		UIShowSearchBtNoLines:SetBackground(0x4110C76A); 
	end
	UIShowSearchBtNoLines:SetMouseVisible(true);
	UIShowSearchBtNoLines:SetBlendMode(Turbine.UI.BlendMode.Overlay); 

	MessageBtLines.MouseClick = function(sender, args)
		UIShowSearch:SetVisible(false);
		CreateUiSearch(textToSearch, where, "lines");
		UIShowSearch:SetVisible(true);
	end

	UIShowSearchBtNoLines.MouseClick = function(sender, args)
		UIShowSearch:SetVisible(false);
		CreateUiSearch(textToSearch, where, "icones");
		UIShowSearch:SetVisible(true);
	end
	------------------------------------------------------------------------------------------
	-- buttons de recherche
	------------------------------------------------------------------------------------------
	UIShowSearch.Message=Turbine.UI.Label(); 
	UIShowSearch.Message:SetParent(UIShowSearch); 
	UIShowSearch.Message:SetSize(380,20); 
	UIShowSearch.Message:SetPosition(UIShowSearch:GetWidth()/2 - 190, 90);
	UIShowSearch.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowSearch.Message:SetText(T[ "PluginSearch9" ]); 
	
	buttonSearch = Turbine.UI.Lotro.GoldButton();
	buttonSearch:SetParent( UIShowSearch );
	buttonSearch:SetPosition(UIShowSearch:GetWidth()/2 - 125, 160);
	buttonSearch:SetSize( 300, 20 );
	buttonSearch:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonSearch:SetText( T[ "PluginSearch8" ] );
	buttonSearch:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonSearch:SetVisible(true);
	buttonSearch:SetMouseVisible(true);

	buttonSearchBag = Turbine.UI.Lotro.GoldButton();
	buttonSearchBag:SetParent( UIShowSearch );
	buttonSearchBag:SetPosition(UIShowSearch:GetWidth() - UIShowSearch:GetWidth() + 50, 110);
	buttonSearchBag:SetSize( 150, 20 );
	buttonSearchBag:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonSearchBag:SetText( T[ "PluginSearch3" ] );
	buttonSearchBag:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonSearchBag:SetVisible(true);
	buttonSearchBag:SetMouseVisible(true);

	buttonSearchVault = Turbine.UI.Lotro.GoldButton();
	buttonSearchVault:SetParent( UIShowSearch );
	buttonSearchVault:SetPosition(UIShowSearch:GetWidth() - 200, 110);
	buttonSearchVault:SetSize( 150, 20 );
	buttonSearchVault:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonSearchVault:SetText( T[ "PluginSearch4" ] );
	buttonSearchVault:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonSearchVault:SetVisible(true);
	buttonSearchVault:SetMouseVisible(true);

	buttonSearchWallet = Turbine.UI.Lotro.GoldButton();
	buttonSearchWallet:SetParent( UIShowSearch );
	buttonSearchWallet:SetPosition(UIShowSearch:GetWidth() - UIShowSearch:GetWidth() + 50, 135);
	buttonSearchWallet:SetSize( 150, 20 );
	buttonSearchWallet:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonSearchWallet:SetText( T[ "PluginSearch7" ] );
	buttonSearchWallet:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonSearchWallet:SetVisible(true);
	buttonSearchWallet:SetMouseVisible(true);

	buttonSearchShared = Turbine.UI.Lotro.GoldButton();
	buttonSearchShared:SetParent( UIShowSearch );
	buttonSearchShared:SetPosition(UIShowSearch:GetWidth() - 200, 135);
	buttonSearchShared:SetSize( 150, 20 );
	buttonSearchShared:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonSearchShared:SetText( T[ "PluginSearch5" ] );
	buttonSearchShared:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonSearchShared:SetVisible(true);
	buttonSearchShared:SetMouseVisible(true);

	------------------------------------------------------------------------------------------
	-- mouse click handler for search button
	------------------------------------------------------------------------------------------
	buttonSearch.MouseClick = function(sender, args)
		local textToSearchClick = textBoxLines:GetText();

		ToggleWindow(false);

		if(string.len(textToSearchClick) >= 2)then
			CreateUiSearch(textToSearchClick, "all", howToDisplay);
		else
			CreateUiSearch("**", "all", howToDisplay);
		end

		ToggleWindow(true);
	end

	buttonSearchBag.MouseClick = function(sender, args)
		local textToSearchClick = textBoxLines:GetText();

		ToggleWindow(false);

		if(string.len(textToSearchClick) >= 2)then
			CreateUiSearch(textToSearchClick, "bag", howToDisplay);
		else
			CreateUiSearch("**", "bag", howToDisplay);
		end

		ToggleWindow(true);
	end

	buttonSearchVault.MouseClick = function(sender, args)
		local textToSearchClick = textBoxLines:GetText();

		ToggleWindow(false);

		if(string.len(textToSearchClick) >= 2)then
			CreateUiSearch(textToSearchClick, "vault", howToDisplay);
		else
			CreateUiSearch("**", "vault", howToDisplay);
		end

		ToggleWindow(true);
	end

	buttonSearchWallet.MouseClick = function(sender, args)
		local textToSearchClick = textBoxLines:GetText();

		ToggleWindow(false);

		if(string.len(textToSearchClick) >= 2)then
			CreateUiSearch(textToSearchClick, "wallet", howToDisplay);
		else
			CreateUiSearch("**", "wallet", howToDisplay);
		end

		ToggleWindow(true);
	end

	buttonSearchShared.MouseClick = function(sender, args)
		local textToSearchClick = textBoxLines:GetText();

		ToggleWindow(false);

		if(string.len(textToSearchClick) >= 2)then
			CreateUiSearch(textToSearchClick, "shared", howToDisplay);
		else
			CreateUiSearch("**", "shared", howToDisplay);
		end

		ToggleWindow(true);
	end
	
	DisplayHelpButton(UIShowSearch, windowWidth, 1, settings["isSearchWindowVisible"]["isSearchWindowVisible"]);

	buttonClose = Turbine.UI.Lotro.GoldButton();
	buttonClose:SetParent( UIShowSearch );
	buttonClose:SetPosition(UIShowSearch:GetWidth()/2 - 125, UIShowSearch:GetHeight() - 50);
	buttonClose:SetSize( 300, 20 );
	buttonClose:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonClose:SetText( T[ "PluginCloseButton" ] );
	buttonClose:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonClose:SetVisible(true);
	buttonClose:SetMouseVisible(true);

	buttonClose.MouseClick = function(sender, args)
		settings["isSearchWindowVisible"]["isSearchWindowVisible"] = false;
		UIShowSearch:SetVisible(false);
	end

	centerWindow = {};
	centerWindowName = {};
	------------------------------------------------------------------------------------------
	-- create the viewport control all it needs is size and position as it is simply used to create viewable bounds for our map
	------------------------------------------------------------------------------------------
	viewport1=Turbine.UI.Control();
	viewport1:SetParent(UIShowSearch);
	viewport1:SetSize(windowWidth-35, 450);
	viewport1:SetPosition(10, 190);
	------------------------------------------------------------------------------------------
	-- create the map content for our viewport, again, it only needs size and position as it is just a container for the grid of images
	------------------------------------------------------------------------------------------
	viewport1.map=Turbine.UI.Control();
	------------------------------------------------------------------------------------------
	viewport1.map:SetParent(viewport1); -- set the map as a child of the viewport so that it will be bounded by it for drawing purposes
	-- we'll use a 5x4 grid but this obviously could be expanded, or even set up as a recycled array of controls
	------------------------------------------------------------------------------------------
	heightSizeOfMap = 0;
	tmpItemsCount = 0;
	datasFromSearch = {};
	local nbrLinesOficones = 0;
	local tmpSearchGlobal = 0;
	local valtmp = 0;
	local newLinesToAdd = 0;

	-- define the height size map
	if(where == "bag" or where == "all")then
		datasFromSearch[1], datasFromSearch[2], datasFromSearch[3] = ReturnNbrItemsInBag(textToSearch);
		if(howToDisplay == "lines")then
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[1] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		else
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[3] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		end
	end
	if(where == "vault" or where == "all")then
		datasFromSearch[1], datasFromSearch[2], datasFromSearch[3] = ReturnNbrItemsInVault(textToSearch);
		if(howToDisplay == "lines")then
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[1] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		else
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[3] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		end
	end
	if(where == "wallet" or where == "all")then
		datasFromSearch[1], datasFromSearch[2], datasFromSearch[3] = ReturnNbrItemsInWallet(textToSearch);
		if(howToDisplay == "lines")then
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[1] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		else
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[3] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		end
	end
	if(where == "shared" or where == "all")then
		datasFromSearch[1], datasFromSearch[2], datasFromSearch[3] = ReturnNbrItemsInSharedStorage(textToSearch);
		if(howToDisplay == "lines")then
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[1] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		else
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[3] * 38);
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[2] * 40);
			heightSizeOfMap = heightSizeOfMap + 20;
			tmpItemsCount = tmpItemsCount + datasFromSearch[1];
			tmpSearchGlobal = tmpSearchGlobal + 1;
		end
	end

	if(tmpSearchGlobal == 4)then
		heightSizeOfMap = heightSizeOfMap + 10;
	end

	if(where == "bag" and nbrItemInBag <= 0)then
		LabelName=Turbine.UI.Label(); 
		LabelName:SetParent(viewport1.map); 
		LabelName:SetSize(windowWidth - 50, 449); 
		LabelName:SetPosition(25, 0); 
		LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
		LabelName:SetForeColor(Turbine.UI.Color.White);
		LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelName:SetText( T[ "PluginSearch10" ] .. "\n".. T[ "PluginSearch3" ] .. "\n".. T[ "PluginSearch11" ] .. "\n".. textToSearch); 
		LabelName:SetVisible(true);
		heightSizeOfMap = 449;
	end
	if(where == "vault" and nbrItemInVault <= 0)then
		LabelName=Turbine.UI.Label(); 
		LabelName:SetParent(viewport1.map); 
		LabelName:SetSize(windowWidth - 50, 449); 
		LabelName:SetPosition(25, 0); 
		LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
		LabelName:SetForeColor(Turbine.UI.Color.White);
		LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelName:SetText( T[ "PluginSearch10" ] .. "\n".. T[ "PluginSearch4" ] .. "\n".. T[ "PluginSearch11" ] .. "\n".. textToSearch); 
		LabelName:SetVisible(true);
		heightSizeOfMap = 449;
	end
	if(where == "wallet" and nbrItemInWallet <= 0)then
		LabelName=Turbine.UI.Label(); 
		LabelName:SetParent(viewport1.map); 
		LabelName:SetSize(windowWidth - 50, 449); 
		LabelName:SetPosition(25, 0); 
		LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
		LabelName:SetForeColor(Turbine.UI.Color.White);
		LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelName:SetText( T[ "PluginSearch10" ] .. "\n".. T[ "PluginSearch7" ] .. "\n".. T[ "PluginSearch11" ] .. "\n".. textToSearch); 
		LabelName:SetVisible(true);
		heightSizeOfMap = 449;
	end
	if(where == "shared" and nbrItemInShared <= 0)then
		LabelName=Turbine.UI.Label(); 
		LabelName:SetParent(viewport1.map); 
		LabelName:SetSize(windowWidth - 50, 449); 
		LabelName:SetPosition(25, 0); 
		LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
		LabelName:SetForeColor(Turbine.UI.Color.White);
		LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelName:SetText( T[ "PluginSearch10" ] .. "\n".. T[ "PluginSearch5" ] .. "\n".. T[ "PluginSearch11" ] .. "\n".. textToSearch);  
		LabelName:SetVisible(true);
		heightSizeOfMap = 449;
	end
	if(where == "all" and nbrItemInBag <= 0 and nbrItemInVault <= 0 and nbrItemInWallet <= 0 and nbrItemInShared <= 0)then
		LabelName=Turbine.UI.Label(); 
		LabelName:SetParent(viewport1.map); 
		LabelName:SetSize(windowWidth - 50, 449); 
		LabelName:SetPosition(25, 0); 
		LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
		LabelName:SetForeColor(Turbine.UI.Color.White);
		LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelName:SetText( T[ "PluginSearch10" ] .. "\n".. T[ "PluginSearch3" ] .. "\n".. T[ "PluginSearch4" ] .. "\n".. T[ "PluginSearch7" ] .. "\n".. T[ "PluginSearch5" ] .. "\n".. T[ "PluginSearch11" ] .. "\n".. textToSearch);  
		LabelName:SetVisible(true);
		heightSizeOfMap = 449;
	end

	viewport1.map:SetSize(windowWidth-55, heightSizeOfMap); 
	------------------------------------------------------------------------------------------
	viewport1.map:SetPosition(0,0); -- we'll start off in the upper left
	------------------------------------------------------------------------------------------

	local posx = 10;
	local posy = 20;
	local nameDisplayed = false;
	local nbrIcones = 0;

	if(where == "bag" or where == "all")then
			------------------------------------------------------------------------------------------
			-- search bag
			------------------------------------------------------------------------------------------
			posy = posy - 10;

			if(textToSearch == nil or nbrItemInBag <= 0)then
				-- do nothing
			else
				LabelName=Turbine.UI.Label(); 
				LabelName:SetParent(viewport1.map); 
				LabelName:SetSize(windowWidth - 35, 20); 
				LabelName:SetPosition(10, 0); 
				LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				LabelName:SetForeColor(Turbine.UI.Color.White);
				LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
				LabelName:SetText( T[ "PluginSearch3" ] ); 
				LabelName:SetVisible(true);
				LabelName:SetBackColor(Turbine.UI.Color( .8, .5, .6, .5)); -- just to give it a little style
			end

			posy = posy + 10;

			if(textToSearch == nil)then
				-- do nothing
			else
				for namePlayerToshow in pairs(PlayerBags) do
					for i in pairs(PlayerBags[namePlayerToshow]) do
						if(string.find(string.lower(PlayerBags[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
							--Write("bag of : " .. namePlayerToshow .. " : " .. textToSearch .. " Trouver dans le slot : " .. slot);

							if(nameDisplayed == false)then
								LabelName=Turbine.UI.Label(); 
								LabelName:SetParent(viewport1.map); 
								LabelName:SetSize(350,40); 
								LabelName:SetPosition(posx, posy); 
								LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
								LabelName:SetForeColor(Turbine.UI.Color.Gold);
								LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
								LabelName:SetText( namePlayerToshow ); 
								LabelName:SetVisible(true);
								--LabelName:SetBackColor(Turbine.UI.Color.Red); -- just to give it a little style

								nameDisplayed = true;
								posy = posy + 40;
							end

							centerWindow[i] = Turbine.UI.Control();
							centerWindow[i]:SetSize( 32 , 32 );
							centerWindow[i]:SetParent( viewport1.map );
							centerWindow[i]:SetPosition( posx, posy);
							centerWindow[i]:SetVisible( true );
							centerWindow[i]:SetBackground(0x41000001); -- fond grey
							--centerWindow[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5) );

							itemTmp = Turbine.UI.Control();
							centerWindow[i].itemTmp = itemTmp;
							itemTmp:SetParent( centerWindow[i] );
							itemTmp:SetSize( 32, 32 );
							itemTmp:SetPosition( 1, 1 );
							itemTmp:SetZOrder(centerWindow[i]:GetZOrder() + 1);
							itemTmp:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(i)].Q));
							itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
							itemTmp:SetVisible( true );
							itemTmp:SetMouseVisible( true );

							itemTmp1 = Turbine.UI.Control();
							itemTmp1:SetParent( centerWindow[i] );
							itemTmp1:SetSize( 32, 32 );
							itemTmp1:SetPosition( 1, 1 );
							itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
							itemTmp1:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(i)].B));
							itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
							itemTmp1:SetVisible( true );

							itemTmp3 = Turbine.UI.Control();
							itemTmp3:SetParent( centerWindow[i] );
							itemTmp3:SetSize( 32, 32 );
							itemTmp3:SetPosition( 1, 1 );
							itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
							if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].S) == 0)then
								if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].QA) == 1)then
									itemTmp3:SetBackground(0x410030C4);
								end
								if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].QA) == 2)then
									itemTmp3:SetBackground(0x410030C4);
								end
								if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].QA) == 3)then
									itemTmp3:SetBackground(0x410030C4);
								end
								if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].QA) == 4)then
									itemTmp3:SetBackground(0x410030C4);
								end
								if(tonumber(PlayerBags[namePlayerToshow][tostring(i)].QA) == 5)then
									itemTmp3:SetBackground(0x410030C4);
								end
							else
								itemTmp3:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(i)].S));
							end
							itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
							itemTmp3:SetVisible( true );

							itemTmp4 = Turbine.UI.Control();
							itemTmp4:SetParent( centerWindow[i] );
							itemTmp4:SetSize( 32, 32 );
							itemTmp4:SetPosition( 1, 1 );
							itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
							itemTmp4:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(i)].I));
							itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
							itemTmp4:SetVisible( true );
							itemTmp4:SetMouseVisible( true );
							itemTmp4:SetZOrder( 100 );

							if(howToDisplay == "lines")then
								centerWindowName[i] = Turbine.UI.Control();
								centerWindowName[i]:SetSize( 300 , 32 );
								centerWindowName[i]:SetParent( viewport1.map );
								centerWindowName[i]:SetPosition( posx + 45, posy);
								centerWindowName[i]:SetVisible( true );
								centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

								UIShowSearch.Message=Turbine.UI.Label(); 
								UIShowSearch.Message:SetParent(centerWindowName[i]); 
								UIShowSearch.Message:SetSize(300, 32); 
								UIShowSearch.Message:SetPosition( 1, 1); 
								UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
								UIShowSearch.Message:SetText(rgb["gold"] .. PlayerBags[namePlayerToshow][tostring(i)].QUA .. rgb["clear"] .. " " .. PlayerBags[namePlayerToshow][tostring(i)].N); 
								UIShowSearch.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
								UIShowSearch.Message:SetMarkupEnabled(true);	
							else
								DisplayLabelForIcons(i, posx, posy, UIShowSearch, itemTmp4, PlayerBags[namePlayerToshow][tostring(i)].QUA, PlayerBags[namePlayerToshow][tostring(i)].N);
							end

							if(howToDisplay == "icones")then
								posx = posx + 38;
								nbrIcones = nbrIcones + 1;
							else
								posy = posy + 38;
							end

							if(nbrIcones == 9)then
								nbrIcones = 0;
								posx = 10;
								posy = posy + 38;
							end
							
						end
					end
					if(howToDisplay == "icones")then
						if(nbrIcones > 0)then
							posy = posy + 38;
						end
						posx = 10;
						nbrIcones = 0;
					end
					nameDisplayed = false;
				end
			end
			posy = posy + 20;	
	end

	if(where == "vault" or where == "all")then
		------------------------------------------------------------------------------------------
		-- search vault
		------------------------------------------------------------------------------------------
		posy = posy - 10;

		if(textToSearch == nil or nbrItemInVault <= 0)then
			-- do nothing
		else
			LabelName=Turbine.UI.Label(); 
			LabelName:SetParent(viewport1.map); 
			LabelName:SetSize(windowWidth - 35, 20); 
			LabelName:SetPosition(posx, posy - 10); 
			LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			LabelName:SetForeColor(Turbine.UI.Color.White);
			LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			LabelName:SetText( T[ "PluginSearch4" ] ); 
			LabelName:SetVisible(true);
			LabelName:SetBackColor(Turbine.UI.Color( .8, .5, .6, .5)); -- just to give it a little style
		end
		posy = posy + 10;

		if(textToSearch == nil)then
			-- do nothing
		else
			for namePlayerToshow in pairs(PlayerVault) do
				for i in pairs(PlayerVault[namePlayerToshow]) do
					if(string.find(string.lower(PlayerVault[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
						--Write("bag of : " .. namePlayerToshow .. " : " .. textToSearch .. " Trouver dans le slot : " .. slot);

						if(nameDisplayed == false)then
							LabelName=Turbine.UI.Label(); 
							LabelName:SetParent(viewport1.map); 
							LabelName:SetSize(350,40); 
							LabelName:SetPosition(posx, posy); 
							LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
							LabelName:SetForeColor(Turbine.UI.Color.Gold);
							LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
							LabelName:SetText( namePlayerToshow ); 
							LabelName:SetVisible(true);
							--LabelName:SetBackColor(Turbine.UI.Color.Red); -- just to give it a little style

							nameDisplayed = true;
							posy = posy + 40;
						end

						centerWindow[i] = Turbine.UI.Control();
						centerWindow[i]:SetSize( 32 , 32 );
						centerWindow[i]:SetParent( viewport1.map );
						centerWindow[i]:SetPosition( posx, posy);
						centerWindow[i]:SetVisible( true );
						centerWindow[i]:SetBackground(0x41000001); -- fond grey
						--centerWindow[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5) );

						itemTmp = Turbine.UI.Control();
						centerWindow[i].itemTmp = itemTmp;
						itemTmp:SetParent( centerWindow[i] );
						itemTmp:SetSize( 32, 32 );
						itemTmp:SetPosition( 1, 1 );
						itemTmp:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp:SetBackground(tonumber(PlayerVault[namePlayerToshow][tostring(i)].Q));
						itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp:SetVisible( true );
						itemTmp:SetMouseVisible( true );

						itemTmp1 = Turbine.UI.Control();
						itemTmp1:SetParent( centerWindow[i] );
						itemTmp1:SetSize( 32, 32 );
						itemTmp1:SetPosition( 1, 1 );
						itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp1:SetBackground(tonumber(PlayerVault[namePlayerToshow][tostring(i)].B));
						itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp1:SetVisible( true );

						itemTmp3 = Turbine.UI.Control();
						itemTmp3:SetParent( centerWindow[i] );
						itemTmp3:SetSize( 32, 32 );
						itemTmp3:SetPosition( 1, 1 );
						itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].S) == 0)then
							if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].QA) == 1)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].QA) == 2)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].QA) == 3)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].QA) == 4)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerVault[namePlayerToshow][tostring(i)].QA) == 5)then
								itemTmp3:SetBackground(0x410030C4);
							end
						else
							itemTmp3:SetBackground(tonumber(PlayerVault[namePlayerToshow][tostring(i)].S));
						end
						itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp3:SetVisible( true );

						itemTmp4 = Turbine.UI.Control();
						itemTmp4:SetParent( centerWindow[i] );
						itemTmp4:SetSize( 32, 32 );
						itemTmp4:SetPosition( 1, 1 );
						itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp4:SetBackground(tonumber(PlayerVault[namePlayerToshow][tostring(i)].I));
						itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp4:SetVisible( true );
						itemTmp4:SetMouseVisible( true );
						itemTmp4:SetZOrder( 100 );

						if(howToDisplay == "lines")then
							centerWindowName[i] = Turbine.UI.Control();
							centerWindowName[i]:SetSize( 300 , 32 );
							centerWindowName[i]:SetParent( viewport1.map );
							centerWindowName[i]:SetPosition( posx + 45, posy);
							centerWindowName[i]:SetVisible( true );
							centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

							UIShowSearch.Message=Turbine.UI.Label(); 
							UIShowSearch.Message:SetParent(centerWindowName[i]); 
							UIShowSearch.Message:SetSize(300, 32); 
							UIShowSearch.Message:SetPosition( 1, 1); 
							UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
							UIShowSearch.Message:SetText(rgb["gold"] .. PlayerVault[namePlayerToshow][tostring(i)].QUA .. rgb["clear"] .. " " .. PlayerVault[namePlayerToshow][tostring(i)].N); 
							UIShowSearch.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
							UIShowSearch.Message:SetMarkupEnabled(true);	
						else
							DisplayLabelForIcons(i, posx, posy, UIShowSearch, itemTmp4, PlayerVault[namePlayerToshow][tostring(i)].QUA, PlayerVault[namePlayerToshow][tostring(i)].N);
						end

						if(howToDisplay == "icones")then
								posx = posx + 38;
								nbrIcones = nbrIcones + 1;
							else
								posy = posy + 38;
							end

							if(nbrIcones == 9)then
								nbrIcones = 0;
								posx = 10;
								posy = posy + 38;
							end
					end
				end
				if(howToDisplay == "icones")then
						if(nbrIcones > 0)then
							posy = posy + 38;
						end
						posx = 10;
						nbrIcones = 0;
					end
					nameDisplayed = false;
			end
		end
		posy = posy + 20;
	end

	if(where == "wallet" or where == "all")then
		------------------------------------------------------------------------------------------
		-- search wallet 
		------------------------------------------------------------------------------------------
		posy = posy - 10;

		if(textToSearch == nil or nbrItemInWallet <= 0)then
			-- do nothing
		else
			LabelName=Turbine.UI.Label(); 
			LabelName:SetParent(viewport1.map); 
			LabelName:SetSize(windowWidth - 35, 20); 
			LabelName:SetPosition(posx, posy - 10); 
			LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			LabelName:SetForeColor(Turbine.UI.Color.White);
			LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			LabelName:SetText( T[ "PluginSearch7" ] ); 
			LabelName:SetVisible(true);
			LabelName:SetBackColor(Turbine.UI.Color( .8, .5, .6, .5)); -- just to give it a little style
		end
		posy = posy + 10;

		if(textToSearch == nil)then
			-- do nothing
		else
			for namePlayerToshow in pairs(PlayerWallet) do
				for i in pairs(PlayerWallet[namePlayerToshow]) do
					if(string.find(string.lower(PlayerWallet[namePlayerToshow][i].N), string.lower(textToSearch)) ~= nil)then
						--Write("bag of : " .. namePlayerToshow .. " : " .. textToSearch .. " Trouver dans le slot : " .. slot);

						if(nameDisplayed == false)then
							LabelName=Turbine.UI.Label(); 
							LabelName:SetParent(viewport1.map); 
							LabelName:SetSize(350,40); 
							LabelName:SetPosition(posx, posy); 
							LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
							LabelName:SetForeColor(Turbine.UI.Color.Gold);
							LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
							LabelName:SetText( namePlayerToshow ); 
							LabelName:SetVisible(true);
							--LabelName:SetBackColor(Turbine.UI.Color.Red); -- just to give it a little style

							nameDisplayed = true;
							posy = posy + 40;
						end

						centerWindow[i] = Turbine.UI.Control();
						centerWindow[i]:SetSize( 32 , 32 );
						centerWindow[i]:SetParent( viewport1.map );
						centerWindow[i]:SetPosition( posx, posy);
						centerWindow[i]:SetVisible( true );
						centerWindow[i]:SetBackground(0x41000001); -- fond grey
						--centerWindow[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5) );

						itemTmp = Turbine.UI.Control();
						centerWindow[i].itemTmp = itemTmp;
						itemTmp:SetParent( centerWindow[i] );
						itemTmp:SetSize( 32, 32 );
						itemTmp:SetPosition( 1, 1 );
						itemTmp:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].Q));
						itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp:SetVisible( true );
						itemTmp:SetMouseVisible( true );

						itemTmp1 = Turbine.UI.Control();
						itemTmp1:SetParent( centerWindow[i] );
						itemTmp1:SetSize( 32, 32 );
						itemTmp1:SetPosition( 1, 1 );
						itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp1:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].B));
						itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp1:SetVisible( true );

						itemTmp3 = Turbine.UI.Control();
						itemTmp3:SetParent( centerWindow[i] );
						itemTmp3:SetSize( 32, 32 );
						itemTmp3:SetPosition( 1, 1 );
						itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].S) == 0)then
							if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].QA) == 1)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].QA) == 2)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].QA) == 3)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].QA) == 4)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].QA) == 5)then
								itemTmp3:SetBackground(0x410030C4);
							end
						else
							itemTmp3:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].S));
						end
						itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp3:SetVisible( true );

						itemTmp4 = Turbine.UI.Control();
						itemTmp4:SetParent( centerWindow[i] );
						itemTmp4:SetSize( 32, 32 );
						itemTmp4:SetPosition( 1, 1 );
						itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp4:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(i)].I));
						itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp4:SetVisible( true );
						itemTmp4:SetMouseVisible( true );
						itemTmp4:SetZOrder( 100 );

						if(howToDisplay == "lines")then
							centerWindowName[i] = Turbine.UI.Control();
							centerWindowName[i]:SetSize( 300 , 32 );
							centerWindowName[i]:SetParent( viewport1.map );
							centerWindowName[i]:SetPosition( posx + 45, posy);
							centerWindowName[i]:SetVisible( true );
							centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

							UIShowSearch.Message=Turbine.UI.Label(); 
							UIShowSearch.Message:SetParent(centerWindowName[i]); 
							UIShowSearch.Message:SetSize(300, 32); 
							UIShowSearch.Message:SetPosition( 1, 1); 
							UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
							UIShowSearch.Message:SetText(rgb["gold"] .. PlayerWallet[namePlayerToshow][tostring(i)].QUA .. rgb["clear"] .. " " .. PlayerWallet[namePlayerToshow][tostring(i)].N); 
							UIShowSearch.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
							UIShowSearch.Message:SetMarkupEnabled(true);	
						else
							DisplayLabelForIcons(i, posx, posy, UIShowSearch, itemTmp4, PlayerWallet[namePlayerToshow][tostring(i)].QUA, PlayerWallet[namePlayerToshow][tostring(i)].N);
						end

						if(howToDisplay == "icones")then
								posx = posx + 38;
								nbrIcones = nbrIcones + 1;
							else
								posy = posy + 38;
							end

							if(nbrIcones == 9)then
								nbrIcones = 0;
								posx = 10;
								posy = posy + 38;
							end
					end
				end
				if(howToDisplay == "icones")then
						if(nbrIcones > 0)then
							posy = posy + 38;
						end
						posx = 10;
						nbrIcones = 0;
					end
					nameDisplayed = false;
			end
			nameDisplayed = false;
		end

		posy = posy + 20;
	end

	if(where == "shared" or where == "all")then
		------------------------------------------------------------------------------------------
		-- search shared storage
		------------------------------------------------------------------------------------------
		posy = posy - 10;

		if(textToSearch == nil or nbrItemInShared <= 0)then
			-- do nothing
		else
			LabelName=Turbine.UI.Label(); 
			LabelName:SetParent(viewport1.map); 
			LabelName:SetSize(windowWidth - 35, 20); 
			LabelName:SetPosition(posx, posy - 10); 
			LabelName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			LabelName:SetForeColor(Turbine.UI.Color.White);
			LabelName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			LabelName:SetText( T[ "PluginSearch5" ] ); 
			LabelName:SetVisible(true);
			LabelName:SetBackColor(Turbine.UI.Color( .8, .5, .6, .5)); -- just to give it a little style
		end

		posy = posy + 10;

		nbrItemInSharedSrorage = 0;

		for i in pairs(SharedStorageVault) do
			nbrItemInSharedSrorage = nbrItemInSharedSrorage + 1 ;
		end
		posy = posy + 10;

		if(textToSearch == nil)then
			-- do nothing
		else
				for i=1, nbrItemInSharedSrorage do  
					if(string.find(string.lower(SharedStorageVault[tostring(i)].N), string.lower(textToSearch)) ~= nil)then
						--Write("bag of : " .. namePlayerToshow .. " : " .. textToSearch .. " Trouver dans le slot : " .. slot);

						centerWindow[i] = Turbine.UI.Control();
						centerWindow[i]:SetSize( 32 , 32 );
						centerWindow[i]:SetParent( viewport1.map );
						centerWindow[i]:SetPosition( posx, posy);
						centerWindow[i]:SetVisible( true );
						centerWindow[i]:SetBackground(0x41000001); -- fond grey
						--centerWindow[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5) );

						itemTmp = Turbine.UI.Control();
						centerWindow[i].itemTmp = itemTmp;
						itemTmp:SetParent( centerWindow[i] );
						itemTmp:SetSize( 32, 32 );
						itemTmp:SetPosition( 1, 1 );
						itemTmp:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp:SetBackground(tonumber(SharedStorageVault[tostring(i)].Q));
						itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp:SetVisible( true );
						itemTmp:SetMouseVisible( true );

						itemTmp1 = Turbine.UI.Control();
						itemTmp1:SetParent( centerWindow[i] );
						itemTmp1:SetSize( 32, 32 );
						itemTmp1:SetPosition( 1, 1 );
						itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp1:SetBackground(tonumber(SharedStorageVault[tostring(i)].B));
						itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp1:SetVisible( true );

						itemTmp3 = Turbine.UI.Control();
						itemTmp3:SetParent( centerWindow[i] );
						itemTmp3:SetSize( 32, 32 );
						itemTmp3:SetPosition( 1, 1 );
						itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						if(tonumber(SharedStorageVault[tostring(i)].S) == 0)then
							if(tonumber(SharedStorageVault[tostring(i)].QA) == 1)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(SharedStorageVault[tostring(i)].QA) == 2)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(SharedStorageVault[tostring(i)].QA) == 3)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(SharedStorageVault[tostring(i)].QA) == 4)then
								itemTmp3:SetBackground(0x410030C4);
							end
							if(tonumber(SharedStorageVault[tostring(i)].QA) == 5)then
								itemTmp3:SetBackground(0x410030C4);
							end
						else
							itemTmp3:SetBackground(tonumber(SharedStorageVault[tostring(i)].S));
						end
						itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp3:SetVisible( true );

						itemTmp4 = Turbine.UI.Control();
						itemTmp4:SetParent( centerWindow[i] );
						itemTmp4:SetSize( 32, 32 );
						itemTmp4:SetPosition( 1, 1 );
						itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
						itemTmp4:SetBackground(tonumber(SharedStorageVault[tostring(i)].I));
						itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
						itemTmp4:SetVisible( true );
						itemTmp4:SetMouseVisible( true );
						itemTmp4:SetZOrder( 100 );

						if(howToDisplay == "lines")then
							centerWindowName[i] = Turbine.UI.Control();
							centerWindowName[i]:SetSize( 300 , 32 );
							centerWindowName[i]:SetParent( viewport1.map );
							centerWindowName[i]:SetPosition( posx + 45, posy);
							centerWindowName[i]:SetVisible( true );
							centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

							UIShowSearch.Message=Turbine.UI.Label(); 
							UIShowSearch.Message:SetParent(centerWindowName[i]); 
							UIShowSearch.Message:SetSize(300, 32); 
							UIShowSearch.Message:SetPosition( 1, 1); 
							UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
							UIShowSearch.Message:SetText(rgb["gold"] .. SharedStorageVault[tostring(i)].QUA .. rgb["clear"] .. " " .. SharedStorageVault[tostring(i)].N); 
							UIShowSearch.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
							UIShowSearch.Message:SetMarkupEnabled(true);	
						else
							DisplayLabelForIcons(i, posx, posy, UIShowSearch, itemTmp4, SharedStorageVault[tostring(i)].QUA, SharedStorageVault[tostring(i)].N);
						end

						if(howToDisplay == "icones")then
								posx = posx + 38;
								nbrIcones = nbrIcones + 1;
							else
								posy = posy + 38;
							end

							if(nbrIcones == 9)then
								nbrIcones = 0;
								posx = 10;
								posy = posy + 38;
							end
					end
				end
			if(howToDisplay == "icones")then
				if(nbrIcones > 0)then
					posy = posy + 38;
				end
				posx = 10;
				nbrIcones = 0;
			end
			nameDisplayed = false;
		end
	end

	if(heightSizeOfMap >= 450)then
		------------------------------------------------------------------------------------------
		-- create the vertical scrollbar for our viewport
		------------------------------------------------------------------------------------------
		vscroll1=Turbine.UI.Lotro.ScrollBar();
		vscroll1:SetParent(UIShowSearch);
		vscroll1:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscroll1:SetPosition(windowWidth-20, 170);
		vscroll1:SetSize(12,viewport1:GetHeight()); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscroll1:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscroll1:SetMinimum(0);
		vscroll1:SetMaximum(viewport1.map:GetHeight()-viewport1:GetHeight()); -- we will allow scrolling the height of the map-the viewport height
		vscroll1:SetValue(0); -- set the initial value
		------------------------------------------------------------------------------------------
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		------------------------------------------------------------------------------------------
		vscroll1.ValueChanged=function()
			viewport1.map:SetTop(0-vscroll1:GetValue());
		end
	end

	UIShowSearch.Message=Turbine.UI.Label(); 
	UIShowSearch.Message:SetParent(UIShowSearch); 
	UIShowSearch.Message:SetSize(200,40); 
	UIShowSearch.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	UIShowSearch.Message:SetPosition(UIShowSearch:GetWidth()/2 - 100, UIShowSearch:GetHeight() - 85); 
	UIShowSearch.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	if(textToSearch ~= nil)then
		UIShowSearch.Message:SetText(T[ "PluginSearch1" ] .. tostring(tmpItemsCount) .. " " .. T[ "PluginSearch6" ]); 
	end
	UIShowSearch:SetZOrder(10);
	UIShowSearch:SetWantsKeyEvents(true);
	UIShowSearch:SetVisible(false);

	ClosingTheWindowSearch();

	EscapeKeyHandlerForWindows(UIShowSearch, settings["isSearchWindowVisible"]["isSearchWindowVisible"]);
end

function ToggleWindow(toggleValue)
	UIShowSearch:SetVisible(toggleValue);
	settings["isSearchWindowVisible"]["isSearchWindowVisible"] = toggleValue;
end