	------------------------------------------------------------------------------------------
-- GloUIShowSharedStoragebalFR file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- create the vault window
------------------------------------------------------------------------------------------
function CreateUIShowSharedStorage()

	if(settings["displayIcon"]["value"] == true)then
		howToDisplay = "icones";
	else
		howToDisplay = "lines"; 
	end

	local player = Turbine.Gameplay.LocalPlayer.GetInstance();

	local nbrItemInSharedSrorage = 0;
	local windowHeightSize = 0;
	local windowWidth = 0;

	windowWidth = 400;

	for i in pairs(SharedStorageVault) do
			nbrItemInSharedSrorage = nbrItemInSharedSrorage + 1 ;
	end

	windowHeightSize = nbrItemInSharedSrorage * 38 + 80;


	-- sorting the table
	a = {};
    for i in pairs(SharedStorageVault) do
		table.insert(a, SharedStorageVault[tostring(i)].N);
	end
    table.sort(a)

	newtable = {};
	for j in pairs(a) do
		for i=1, nbrItemInSharedSrorage do
			if(a[j] == SharedStorageVault[tostring(i)].N)then
				newtable[j] = i;
				break;
			end
		end
	end
	-- end sorting the table

	UIShowSharedStorage=Turbine.UI.Lotro.GoldWindow(); 
	if(howToDisplay == "lines")then
		windowHeightSize = (nbrItemInSharedSrorage * 38) + 80;

		if(Turbine.UI.Display:GetHeight() < windowHeightSize)then
			windowHeightSize = Turbine.UI.Display:GetHeight() - 150;
		end

		if(windowHeightSize > 600)then
			windowHeightSize = 600;
		end

		UIShowSharedStorage:SetSize(windowWidth, windowHeightSize + 110);
	else
		windowHeightSize = ((nbrItemInSharedSrorage * 38) / 9) + 80;

		if(Turbine.UI.Display:GetHeight() < windowHeightSize)then
			windowHeightSize = Turbine.UI.Display:GetHeight() - 150;
		end

		UIShowSharedStorage:SetSize(windowWidth, windowHeightSize + 110);
	end

	UIShowSharedStorage:SetText(T[ "PluginSharedStorage1" ]); 
	UIShowSharedStorage:SetPosition((Turbine.UI.Display:GetWidth()-UIShowSharedStorage:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowSharedStorage:GetHeight())/2); 

	UIShowSharedStorage.Message=Turbine.UI.Label(); 
	UIShowSharedStorage.Message:SetParent(UIShowSharedStorage); 
	UIShowSharedStorage.Message:SetSize(150,10); 
	UIShowSharedStorage.Message:SetPosition(UIShowSharedStorage:GetWidth()/2 - 75, UIShowSharedStorage:GetHeight() - 20); 
	UIShowSharedStorage.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowSharedStorage.Message:SetText( T[ "PluginText" ] ); 
	UIShowSharedStorage:SetZOrder(10);
	UIShowSharedStorage:SetWantsKeyEvents(true);
	UIShowSharedStorage:SetVisible(false);

	------------------------------------------------------------------------------------------
	-- positionnement 
	------------------------------------------------------------------------------------------
	MessageBtLines=Turbine.UI.Label(); 
	MessageBtLines:SetParent(UIShowSharedStorage); 
	MessageBtLines:SetSize(21,21); 
	MessageBtLines:SetPosition(windowWidth /2 - 41, 40);
	MessageBtLines:SetText(""); 
	if(howToDisplay == "lines")then
		MessageBtLines:SetBackground(0x4110C76D); 
	else
		MessageBtLines:SetBackground(0x4110C76F); 
	end
	MessageBtLines:SetMouseVisible(true);
	MessageBtLines:SetBlendMode(Turbine.UI.BlendMode.Overlay); 

	UIShowSearchBtNoLines=Turbine.UI.Label(); 
	UIShowSearchBtNoLines:SetParent(UIShowSharedStorage); 
	UIShowSearchBtNoLines:SetSize(21,21); 
	UIShowSearchBtNoLines:SetPosition(windowWidth/2 + 20, 40);
	UIShowSearchBtNoLines:SetText(""); 
	if(howToDisplay == "lines")then
		UIShowSearchBtNoLines:SetBackground(0x4110C76C); 
	else
		UIShowSearchBtNoLines:SetBackground(0x4110C76A); 
	end
	UIShowSearchBtNoLines:SetMouseVisible(true);
	UIShowSearchBtNoLines:SetBlendMode(Turbine.UI.BlendMode.Overlay); 

	MessageBtLines.MouseClick = function(sender, args)
		UIShowSharedStorage:SetVisible(false);
		settings["displayIcon"]["value"] = false;
		CreateUIShowSharedStorage();
		UIShowSharedStorage:SetVisible(true);
	end

	UIShowSearchBtNoLines.MouseClick = function(sender, args)
		UIShowSharedStorage:SetVisible(false);
		settings["displayIcon"]["value"] = true;
		CreateUIShowSharedStorage();
		UIShowSharedStorage:SetVisible(true);
	end

	heightSizeOfMap = 0;
	tmpItemsCount = 0;
	datasFromSearch = {};

	datasFromSearch[1], datasFromSearch[2], datasFromSearch[3] = ReturnNbrItemsInSharedStorage(textToSearch);
	if(howToDisplay == "lines")then
		if(windowHeightSize > 600)then
			heightSizeOfMap = heightSizeOfMap + (datasFromSearch[1] * 38);
		else
			heightSizeOfMap = heightSizeOfMap + (windowHeightSize - 80);
		end
		tmpItemsCount = tmpItemsCount + datasFromSearch[1];
	else
		heightSizeOfMap = heightSizeOfMap + (datasFromSearch[3] * 38);
		tmpItemsCount = tmpItemsCount + datasFromSearch[1];
	end


	UIShowSharedStorage.Message=Turbine.UI.Label(); 
	UIShowSharedStorage.Message:SetParent(UIShowSharedStorage); 
	UIShowSharedStorage.Message:SetSize(300,40); 
	UIShowSharedStorage.Message:SetPosition(UIShowSharedStorage:GetWidth()/2 - 150, UIShowSharedStorage:GetHeight() - 90); 
	UIShowSharedStorage.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowSharedStorage.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);

	if(nbrItemInSharedSrorage >= 1)then
		UIShowSharedStorage.Message:SetText(T[ "PluginSharedStorage2" ] .. nbrItemInSharedSrorage .. " / " .. SharedStorageVault[tostring(nbrItemInSharedSrorage)].VSIZE);
	end
	UIShowSharedStorage:SetZOrder(10);
	UIShowSharedStorage:SetWantsKeyEvents(true);
	UIShowSharedStorage:SetVisible(false);

	if(nbrItemInSharedSrorage == 0)then
		UIShowSharedStorage.Message=Turbine.UI.Label(); 
		UIShowSharedStorage.Message:SetParent(UIShowSharedStorage); 
		UIShowSharedStorage.Message:SetSize(300,30); 
		UIShowSharedStorage.Message:SetPosition(UIShowSharedStorage:GetWidth()/2 - 150, UIShowSharedStorage:GetHeight() - 110); 
		UIShowSharedStorage.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		UIShowSharedStorage.Message:SetText(T[ "PluginSharedStorage3" ]); 
		UIShowSharedStorage:SetZOrder(10);
		UIShowSharedStorage:SetWantsKeyEvents(true);
		UIShowSharedStorage:SetVisible(false);
	end

	buttonClose = Turbine.UI.Lotro.GoldButton();
	buttonClose:SetParent( UIShowSharedStorage );
	buttonClose:SetPosition(UIShowSharedStorage:GetWidth()/2 - 125, UIShowSharedStorage:GetHeight() - 50);
	buttonClose:SetSize( 300, 20 );
	buttonClose:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonClose:SetText( T[ "PluginCloseButton" ] );
	buttonClose:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonClose:SetVisible(true);
	buttonClose:SetMouseVisible(true);

	buttonClose.MouseClick = function(sender, args)
		settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = false;
		UIShowSharedStorage:SetVisible(false);
	end

	centerWindow = {};
	centerWindowName = {};

	local sizeBoxHeight = 0;

	if(howToDisplay == "lines")then
		listbox = Turbine.UI.ListBox();
		listbox:SetParent( UIShowSharedStorage );
		--listbox:SetBackColor( Turbine.UI.Color.Red );
		if(((nbrItemInSharedSrorage * 38) + 10) < windowHeightSize)then
			sizeBoxHeight = windowHeightSize - 150;
		else
			sizeBoxHeight = 600;
		end
		listbox:SetSize(windowWidth - 45, windowHeightSize - 80);
		listbox:SetPosition(10, 80);
		listbox:IsMouseVisible(true);
		listbox:SetZOrder(20);
	else
		-- create the viewport control all it needs is size and position as it is simply used to create viewable bounds for our map
		viewport1=Turbine.UI.Control();
		viewport1:SetParent(UIShowSharedStorage);

		if(((nbrItemInSharedSrorage * 38) + 10) < windowHeightSize)then
			viewport1:SetSize(windowWidth - 25, ((nbrItemInSharedSrorage * 38) + 10) -80);
		else
			viewport1:SetSize(windowWidth - 45, windowHeightSize-80);
		end

		viewport1:SetPosition(10, 70);
		-- create the map content for our viewport, again, it only needs size and position as it is just a container for the grid of images
		viewport1.map=Turbine.UI.Control();
		viewport1.map:SetParent(viewport1); -- set the map as a child of the viewport so that it will be bounded by it for drawing purposes
		viewport1.map:SetSize(windowWidth - 45, heightSizeOfMap + 10); -- we'll use a 5x4 grid but this obviously could be expanded, or even set up as a recycled array of controls
		viewport1.map:SetPosition(0,0); -- we'll start off in the upper left
	end

	local posx = 20;
	local posy = 5;
	local nbrIcones = 0;

	if(namePlayerToshow ~= "")then
		for i=1, nbrItemInSharedSrorage do  
			
			listItem = Turbine.UI.Control();
			listItem:SetSize( windowWidth - 45, 38 );
			listItem:SetMouseVisible(true);

			centerWindow[i] = Turbine.UI.Control();
			centerWindow[i]:SetSize( 32 , 32 );
			if(howToDisplay == "lines")then
				centerWindow[i]:SetParent( listItem );
			else
				centerWindow[i]:SetParent( viewport1.map );
			end
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
			itemTmp:SetBackground(tonumber(SharedStorageVault[tostring(newtable[i])].Q));
			itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp:SetVisible( true );
			itemTmp:SetMouseVisible( true );

			itemTmp1 = Turbine.UI.Control();
			itemTmp1:SetParent( centerWindow[i] );
			itemTmp1:SetSize( 32, 32 );
			itemTmp1:SetPosition( 1, 1 );
			itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			itemTmp1:SetBackground(tonumber(SharedStorageVault[tostring(newtable[i])].B));
			itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp1:SetVisible( true );

			itemTmp3 = Turbine.UI.Control();
			itemTmp3:SetParent( centerWindow[i] );
			itemTmp3:SetSize( 32, 32 );
			itemTmp3:SetPosition( 1, 1 );
			itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			if(tonumber(SharedStorageVault[tostring(newtable[i])].S) == 0)then
				if(tonumber(SharedStorageVault[tostring(newtable[i])].QA) == 1)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(SharedStorageVault[tostring(newtable[i])].QA) == 2)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(SharedStorageVault[tostring(newtable[i])].QA) == 3)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(SharedStorageVault[tostring(newtable[i])].QA) == 4)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(SharedStorageVault[tostring(newtable[i])].QA) == 5)then
					itemTmp3:SetBackground(0x410030C4);
				end
			else
				itemTmp3:SetBackground(tonumber(SharedStorageVault[tostring(newtable[i])].S));
			end
			itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp3:SetVisible( true );

			itemTmp4 = Turbine.UI.Control();
			itemTmp4:SetParent( centerWindow[i] );
			itemTmp4:SetSize( 32, 32 );
			itemTmp4:SetPosition( 1, 1 );
			itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			itemTmp4:SetBackground(tonumber(SharedStorageVault[tostring(newtable[i])].I));
			itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp4:SetVisible( true );
			itemTmp4:SetMouseVisible( true );

			if(howToDisplay == "lines")then
				centerWindowName[i] = Turbine.UI.Control();
				centerWindowName[i]:SetSize( 300 , 32 );
				centerWindowName[i]:SetParent( listItem );
				centerWindowName[i]:SetPosition( posx + 45, posy);
				centerWindowName[i]:SetVisible( true );
				centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

				UIShowSharedStorage.Message=Turbine.UI.Label(); 
				UIShowSharedStorage.Message:SetParent(centerWindowName[i]); 
				UIShowSharedStorage.Message:SetSize(300, 32); 
				UIShowSharedStorage.Message:SetPosition( 1, 1); 
				UIShowSharedStorage.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowSharedStorage.Message:SetText(rgb["gold"] .. SharedStorageVault[tostring(newtable[i])].QUA .. rgb["clear"] .. " " .. SharedStorageVault[tostring(newtable[i])].N); 
				UIShowSharedStorage.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
				UIShowSharedStorage.Message:SetMarkupEnabled(true);	
			else
				DisplayLabelForIcons(i, posx, posy, UIShowSharedStorage, itemTmp4, SharedStorageVault[tostring(newtable[i])].QUA, SharedStorageVault[tostring(newtable[i])].N);
			end

			if(howToDisplay == "icones")then
				posx = posx + 38;
				nbrIcones = nbrIcones + 1;
			else
				listbox:AddItem( listItem );
				--posy = posy + 38;
			end

			if(nbrIcones == 9)then
				nbrIcones = 0;
				posx = 20;
				posy = posy + 38;
			end
		end
		if(howToDisplay == "icones")then
			if(nbrIcones > 0)then
				posy = posy + 38;
			end
			posx = 20;
			nbrIcones = 0;
		end
	end


	if(howToDisplay == "lines")then
		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(UIShowSharedStorage);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth - 20,  80);
		vscrollListBox:SetSize(10, sizeBoxHeight-80); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (113 * 25) - 400); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end
		if(((nbrItemInSharedSrorage * 38) + 10) >= 400)then
			listbox:SetVerticalScrollBar(vscrollListBox);			
		end
	else
		vscroll1=Turbine.UI.Lotro.ScrollBar();
		vscroll1:SetParent(UIShowSharedStorage);
		vscroll1:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscroll1:SetPosition(windowWidth-20, 70);
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

	ClosingTheWindowSharedStorage();

	EscapeKeyHandlerForWindows(UIShowSharedStorage, settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"]);
end