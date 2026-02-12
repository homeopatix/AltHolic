------------------------------------------------------------------------------------------
-- UIshowBag file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the bag window
------------------------------------------------------------------------------------------
function CreateUIShowBag(namePlayerToshow)

	if(settings["displayIcon"]["value"] == true)then
		howToDisplay = "icones";
	else
		howToDisplay = "lines"; 
	end
	
	local player = Turbine.Gameplay.LocalPlayer.GetInstance();

	local nbrItemInBag = 0;
	local windowHeightSize = 0;
	local windowWidth = 0;

	windowWidth = 400;
	nbrItemInBag = 0;
	for i in pairs(PlayerBags[namePlayerToshow]) do
			nbrItemInBag = nbrItemInBag + 1 ;
	end

	-- sorting the table
	a = {};
    for i in pairs(PlayerBags[namePlayerToshow]) do
		table.insert(a, PlayerBags[namePlayerToshow][tostring(i)].N);
	end
    table.sort(a)

	newtable = {};
	for j in pairs(a) do
		for i=1, nbrItemInBag do
			if(a[j] == PlayerBags[namePlayerToshow][tostring(i)].N)then
				newtable[j] = i;
				break;
			end
		end
	end
	-- end sorting the table

	heightSizeOfMap = 0;
	datasFromSearch = {};
	local nbrLines = 0;

	nbrLines = nbrLines + math.floor(nbrItemInBag / 9);
	if((nbrItemInBag % 9) > 0)then
		nbrLines = nbrLines + 1;
	end
	if(howToDisplay == "lines")then
		heightSizeOfMap = heightSizeOfMap + (nbrItemInBag * 38);
		windowHeightSize = nbrItemInBag * 38 + 80;
	else
		heightSizeOfMap = heightSizeOfMap + (nbrLines * 38);
		windowHeightSize = nbrLines * 38 + 80;

	end

	UIShowBag=Turbine.UI.Lotro.GoldWindow(); 
	if(windowHeightSize < 600)then
		UIShowBag:SetSize(windowWidth, windowHeightSize + 110); 
	else
		UIShowBag:SetSize(windowWidth, 600 + 110); 
	end
	UIShowBag:SetText(T[ "PluginBag1" ] .. tostring(namePlayerToshow)); 
	UIShowBag:SetPosition((Turbine.UI.Display:GetWidth()-UIShowBag:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowBag:GetHeight())/2); 

	------------------------------------------------------------------------------------------
	-- positionnement 
	------------------------------------------------------------------------------------------
	MessageBtLines=Turbine.UI.Label(); 
	MessageBtLines:SetParent(UIShowBag); 
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
	UIShowSearchBtNoLines:SetParent(UIShowBag); 
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
		UIShowBag:SetVisible(false);
		settings["displayIcon"]["value"] = false;
		CreateUIShowBag(namePlayerToshow);
		UIShowBag:SetVisible(true);
	end

	UIShowSearchBtNoLines.MouseClick = function(sender, args)
		UIShowBag:SetVisible(false);
		settings["displayIcon"]["value"] = true;
		CreateUIShowBag(namePlayerToshow);
		UIShowBag:SetVisible(true);
	end



	UIShowBag.Message=Turbine.UI.Label(); 
	UIShowBag.Message:SetParent(UIShowBag); 
	UIShowBag.Message:SetSize(150,10); 
	UIShowBag.Message:SetPosition(UIShowBag:GetWidth()/2 - 75, UIShowBag:GetHeight() - 20); 
	UIShowBag.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowBag.Message:SetText(T[ "PluginText" ]); 
	UIShowBag:SetZOrder(10);
	UIShowBag:SetWantsKeyEvents(true);
	UIShowBag:SetVisible(false);

	UIShowBag.Message=Turbine.UI.Label(); 
	UIShowBag.Message:SetParent(UIShowBag); 
	UIShowBag.Message:SetSize(300,40); 
	UIShowBag.Message:SetPosition(UIShowBag:GetWidth()/2 - 150, UIShowBag:GetHeight() - 90); 
	UIShowBag.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowBag.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	if(nbrItemInBag >= 1)then
		UIShowBag.Message:SetText(T[ "PluginBag2" ] .. nbrItemInBag .. " / " .. PlayerBags[namePlayerToshow][tostring(nbrItemInBag)].BSIZE); 
	end
	UIShowBag:SetZOrder(10);
	UIShowBag:SetWantsKeyEvents(true);
	UIShowBag:SetVisible(false);

	buttonClose = Turbine.UI.Lotro.GoldButton();
	buttonClose:SetParent( UIShowBag );
	buttonClose:SetPosition(UIShowBag:GetWidth()/2 - 125, UIShowBag:GetHeight() - 50);
	buttonClose:SetSize( 300, 20 );
	buttonClose:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonClose:SetText( T[ "PluginCloseButton" ] );
	buttonClose:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonClose:SetVisible(true);
	buttonClose:SetMouseVisible(true);

	buttonClose.MouseClick = function(sender, args)
		settings["isShowBagVisible"]["isShowBagVisible"] = false;
		UIShowBag:SetVisible(false);
	end

	centerWindow = {};
	centerWindowName = {};

	local sizeBoxHeight = 0;

	if(howToDisplay == "lines")then
		listbox = Turbine.UI.ListBox();
		listbox:SetParent( UIShowBag );
		--listbox:SetBackColor( Turbine.UI.Color.Red );
		if(((nbrItemInBag * 38) + 10) < 535)then
			sizeBoxHeight = (nbrItemInBag * 38) + 10;
		else
			sizeBoxHeight = 535;
		end
		listbox:SetSize(windowWidth - 45, sizeBoxHeight);
		listbox:SetPosition(10, 80);
		listbox:IsMouseVisible(true);
		listbox:SetZOrder(20);
	else
		-- create the viewport control all it needs is size and position as it is simply used to create viewable bounds for our map
		viewport1=Turbine.UI.Control();
		viewport1:SetParent(UIShowBag);

		if(((nbrItemInBag * 38) + 10) < 535)then
			viewport1:SetSize(windowWidth - 25,(nbrItemInBag * 38) + 10);
		else
			viewport1:SetSize(windowWidth - 45, 535);
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
		for i=1, nbrItemInBag do  

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
			itemTmp:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].Q));
			itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp:SetVisible( true );
			itemTmp:SetMouseVisible( true );

			itemTmp1 = Turbine.UI.Control();
			itemTmp1:SetParent( centerWindow[i] );
			itemTmp1:SetSize( 32, 32 );
			itemTmp1:SetPosition( 1, 1 );
			itemTmp1:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			itemTmp1:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].B));
			itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp1:SetVisible( true );

			itemTmp3 = Turbine.UI.Control();
			itemTmp3:SetParent( centerWindow[i] );
			itemTmp3:SetSize( 32, 32 );
			itemTmp3:SetPosition( 1, 1 );
			itemTmp3:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].S) == 0)then
				if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].QA) == 1)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].QA) == 2)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].QA) == 3)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].QA) == 4)then
					itemTmp3:SetBackground(0x410030C4);
				end
				if(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].QA) == 5)then
					itemTmp3:SetBackground(0x410030C4);
				end
			else
				itemTmp3:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].S));
			end
			itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp3:SetVisible( true );

			itemTmp4 = Turbine.UI.Control();
			itemTmp4:SetParent( centerWindow[i] );
			itemTmp4:SetSize( 32, 32 );
			itemTmp4:SetPosition( 1, 1 );
			itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			itemTmp4:SetBackground(tonumber(PlayerBags[namePlayerToshow][tostring(newtable[i])].I));
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

				UIShowBag.Message=Turbine.UI.Label(); 
				UIShowBag.Message:SetParent(centerWindowName[i]); 
				UIShowBag.Message:SetSize(300, 32); 
				UIShowBag.Message:SetPosition( 1, 1); 
				UIShowBag.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowBag.Message:SetText(rgb["gold"] .. PlayerBags[namePlayerToshow][tostring(newtable[i])].QUA .. rgb["clear"] .. " " .. PlayerBags[namePlayerToshow][tostring(newtable[i])].N); 
				UIShowBag.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
				UIShowBag.Message:SetMarkupEnabled(true);
			else
				DisplayLabelForIcons(i, posx, posy, UIShowBag, itemTmp4, PlayerBags[namePlayerToshow][tostring(newtable[i])].QUA, PlayerBags[namePlayerToshow][tostring(newtable[i])].N);
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
		vscrollListBox:SetParent(UIShowBag);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth - 20,  80);
		vscrollListBox:SetSize(10, sizeBoxHeight); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (113 * 25) - 400); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

	if(((nbrItemInBag * 38) + 10) >= 535)then
		listbox:SetVerticalScrollBar(vscrollListBox);
	end
else
	viewport1:SetSize(365, heightSizeOfMap + 10);
end

	ClosingTheWindowBag();
	
	EscapeKeyHandlerForWindows(UIShowBag, settings["isShowBagVisible"]["isShowBagVisible"]);
end