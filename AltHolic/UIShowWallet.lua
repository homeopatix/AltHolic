------------------------------------------------------------------------------------------
-- UIShowWallet file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
centerLabelCash2 = {};
centerLabelCash3 = {};
centerLabelCash4 = {};
------------------------------------------------------------------------------------------
-- create the bag window
------------------------------------------------------------------------------------------
function CreateUIShowWallet(namePlayerToshow)

	local nbrItemInWallet = 0;
	local windowHeightSize = 610;
	local windowWidth = 0;

	windowWidth = 400;
	nbrItemInWallet = 0;

	local addBagOrVault = 0;

	if(PlayerDatas[namePlayerToshow].bagCash > 0)then
		addBagOrVault = addBagOrVault + 40;
	end
	if(PlayerDatas[namePlayerToshow].vaultCash > 0)then
		addBagOrVault = addBagOrVault + 40;
	end

	if(namePlayerToshow == PlayerName)then
		walletpack = Player:GetWallet();
		SavePlayerWallet();
	end

	if(PlayerWallet[namePlayerToshow] ~= nil)then
		for i in pairs(PlayerWallet[namePlayerToshow]) do
			nbrItemInWallet = nbrItemInWallet + 1 ;
		end
		------------------------------------------------------------------------------------------
		-- sorting the table by alphabetical order
		------------------------------------------------------------------------------------------
		a = {};
		for i in pairs(PlayerWallet[namePlayerToshow]) do
			table.insert(a, PlayerWallet[namePlayerToshow][tostring(i)].N);
		end
		table.sort(a)

		newtable = {};
		for j in pairs(a) do
			for i=1, nbrItemInWallet do
				if(a[j] == PlayerWallet[namePlayerToshow][tostring(i)].N)then
					newtable[j] = i;
					break;
				end
			end
		end
	end
	------------------------------------------------------------------------------------------
	-- end sorting the table
	------------------------------------------------------------------------------------------
	UIShowWallet=Turbine.UI.Lotro.GoldWindow(); 
	UIShowWallet:SetSize(windowWidth, windowHeightSize + addBagOrVault ); 
	UIShowWallet:SetText(T[ "PluginWalletWindow3" ] .. tostring(namePlayerToshow)); 
	UIShowWallet:SetPosition((Turbine.UI.Display:GetWidth()-UIShowWallet:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowWallet:GetHeight())/2); 


	listbox = Turbine.UI.ListBox();
    listbox:SetParent( UIShowWallet );
    --listbox:SetBackColor( Turbine.UI.Color.Red );
	listbox:SetSize(windowWidth - 45, 400);
	listbox:SetPosition(10, 120 + addBagOrVault);
	listbox:IsMouseVisible(true);
	listbox:SetZOrder(20);

	UIShowWallet.Message=Turbine.UI.Label(); 
	UIShowWallet.Message:SetParent(UIShowWallet); 
	UIShowWallet.Message:SetSize(150,10); 
	UIShowWallet.Message:SetPosition(UIShowWallet:GetWidth()/2 - 75, UIShowWallet:GetHeight() - 20); 
	UIShowWallet.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowWallet.Message:SetText(T[ "PluginText" ]); 
	UIShowWallet:SetZOrder(10);
	UIShowWallet:SetWantsKeyEvents(true);
	UIShowWallet:SetVisible(false);

	UIShowWallet.Message=Turbine.UI.Label(); 
	UIShowWallet.Message:SetParent(UIShowWallet); 
	UIShowWallet.Message:SetSize(400,40); 
	UIShowWallet.Message:SetPosition(UIShowWallet:GetWidth()/2 - 200, UIShowWallet:GetHeight() - 90); 
	UIShowWallet.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowWallet.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	if(nbrItemInWallet >= 1)then
		UIShowWallet.Message:SetText(T[ "PluginWalletWindow2" ] .. " : " .. nbrItemInWallet); 
	else
		UIShowWallet.Message:SetText(T[ "PluginWalletWindow4" ]); 
	end
	UIShowWallet:SetZOrder(10);
	UIShowWallet:SetWantsKeyEvents(true);
	UIShowWallet:SetVisible(false);

	buttonClose = Turbine.UI.Lotro.GoldButton();
	buttonClose:SetParent( UIShowWallet );
	buttonClose:SetPosition(UIShowWallet:GetWidth()/2 - 125, UIShowWallet:GetHeight() - 50);
	buttonClose:SetSize( 300, 20 );
	buttonClose:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonClose:SetText( T[ "PluginCloseButton" ] );
	buttonClose:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonClose:SetVisible(true);
	buttonClose:SetMouseVisible(true);

	buttonClose.MouseClick = function(sender, args)
		settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
		UIShowWallet:SetVisible(false);
	end
	------------------------------------------------------------------------------------------
	-- cash displayer
	------------------------------------------------------------------------------------------
	DisplayCash(PlayerDatas[namePlayerToshow].cash, UIShowWallet, namePlayerToshow);
	if(PlayerDatas[namePlayerToshow].bagCash > 0 )then
		DisplayBagCash(PlayerDatas[namePlayerToshow].bagCash, UIShowWallet, namePlayerToshow);
	end
	if(PlayerDatas[namePlayerToshow].vaultCash > 0 )then
		DisplayVaultCash(PlayerDatas[namePlayerToshow].vaultCash, UIShowWallet, namePlayerToshow);
	end
	DisplayDestinyPoints(UIShowWallet);
	DisplayLotroCoins(UIShowWallet, namePlayerToshow);

	centerWindow = {};
	centerWindowName = {};
--[[
	------------------------------------------------------------------------------------------
	-- create the viewport control all it needs is size and position as it is simply used to create viewable bounds for our map
	------------------------------------------------------------------------------------------
	viewport1=Turbine.UI.Control();
	viewport1:SetParent(UIShowWallet);
	viewport1:SetSize(windowWidth-55, 400);
	viewport1:SetPosition(10, 120 + addBagOrVault);
	--viewport1:SetBackColor(Turbine.UI.Color.Red);
	------------------------------------------------------------------------------------------
	-- create the map content for our viewport, again, it only needs size and position as it is just a container for the grid of images
	------------------------------------------------------------------------------------------
	viewport1.map=Turbine.UI.Control();
	viewport1.map:SetParent(viewport1); -- set the map as a child of the viewport so that it will be bounded by it for drawing purposes
	viewport1.map:SetSize(windowWidth-55, (nbrItemInWallet * 38) + 40); -- we'll use a 5x4 grid but this obviously could be expanded, or even set up as a recycled array of controls
	viewport1.map:SetPosition(0,0); -- we'll start off in the upper left
]]--

	local posx = 10;
	local posy = 5;
	if(namePlayerToshow ~= "")then
		for i=1, nbrItemInWallet do  

			listItem = Turbine.UI.Control();
			listItem:SetSize( windowWidth - 45, 38 );
			listItem:SetMouseVisible(true);


			centerWindow[i] = Turbine.UI.Control();
			centerWindow[i]:SetSize( 32 , 32 );
			centerWindow[i]:SetParent( listItem );
			centerWindow[i]:SetPosition( posx, posy);
			centerWindow[i]:SetVisible( true );
			--centerWindow[i]:SetBackground(0x41000001); -- fond grey
			--centerWindow[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5) );

			centerWindowName[i] = Turbine.UI.Control();
			centerWindowName[i]:SetSize( 300 , 32 );
			centerWindowName[i]:SetParent( listItem );
			centerWindowName[i]:SetPosition( posx + 45, posy);
			centerWindowName[i]:SetVisible( true );
			--centerWindowName[i]:SetBackColor( Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ) );

			itemTmp2 = Turbine.UI.Control();
			itemTmp2:SetParent( centerWindow[i] );
			itemTmp2:SetSize( 32, 32 );
			itemTmp2:SetPosition( 1, 1 );
			itemTmp2:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			--itemTmp2:SetBackground(0x41000001); -- fond grey
			itemTmp2:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp2:SetVisible( true );

			itemTmp4 = Turbine.UI.Control();
			itemTmp4:SetParent( centerWindow[i] );
			itemTmp4:SetSize( 32, 32 );
			itemTmp4:SetPosition( 1, 1 );
			itemTmp4:SetZOrder(centerWindow[i]:GetZOrder() + 1);
			itemTmp4:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(newtable[i])].I));
			itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			itemTmp4:SetVisible( true );


			-- display small label with description
			ButtonPlusCash[i] = Turbine.UI.Extensions.SimpleWindow();
			ButtonPlusCash[i]:SetParent( UIShowWallet );
			ButtonPlusCash[i]:SetPosition(posx + 120 , UIShowWallet:GetHeight() - 450);
			ButtonPlusCash[i]:SetSize( 300, 300 );
			ButtonPlusCash[i]:SetVisible(false);
			ButtonPlusCash[i]:SetZOrder(20);
			ButtonPlusCash[i]:SetBackground(ResourcePath .. "/Cadre_300_300.tga");

			centerLabelCash[i] = Turbine.UI.Label();
			centerLabelCash[i]:SetParent(ButtonPlusCash[i]);
			centerLabelCash[i]:SetPosition( 10, 50 );
			centerLabelCash[i]:SetSize( 280, 280 );
			centerLabelCash[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
			centerLabelCash[i]:SetText( PlayerWallet[namePlayerToshow][tostring(newtable[i])].D );
			centerLabelCash[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelCash[i]:SetZOrder(21);

			centerLabelCash2[i] = Turbine.UI.Label();
			centerLabelCash2[i]:SetParent(ButtonPlusCash[i]);
			centerLabelCash2[i]:SetPosition( 5, 5 );
			centerLabelCash2[i]:SetSize( 32, 32  );
			centerLabelCash2[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
			centerLabelCash2[i]:SetText( "" );
			centerLabelCash2[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelCash2[i]:SetBackground(tonumber(PlayerWallet[namePlayerToshow][tostring(newtable[i])].I));
			centerLabelCash2[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			centerLabelCash2[i]:SetZOrder(21);

			centerLabelCash3[i] = Turbine.UI.Label();
			centerLabelCash3[i]:SetParent(ButtonPlusCash[i]);
			centerLabelCash3[i]:SetPosition( 40, 5 );
			centerLabelCash3[i]:SetSize( 260, 32  );
			centerLabelCash3[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
			centerLabelCash3[i]:SetText(PlayerWallet[namePlayerToshow][tostring(newtable[i])].N );
			centerLabelCash3[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelCash3[i]:SetZOrder(21);

			centerLabelCash4[i] = Turbine.UI.Label();
			centerLabelCash4[i]:SetParent(ButtonPlusCash[i]);
			centerLabelCash4[i]:SetPosition( 5, 30 );
			centerLabelCash4[i]:SetSize( 180, 32  );
			centerLabelCash4[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
			if(PlayerWallet[namePlayerToshow][tostring(newtable[i])].A == "true")then
				centerLabelCash4[i]:SetText(T[ "PluginWalletWindow1" ]);
			end
			centerLabelCash4[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelCash4[i]:SetForeColor( Turbine.UI.Color.Lime );
			centerLabelCash4[i]:SetZOrder(21);

			centerWindow[i].MouseEnter = function()
				ButtonPlusCash[i]:SetVisible(true);
			end

			centerWindow[i].MouseLeave = function()
				ButtonPlusCash[i]:SetVisible(false);
			end
			--- end label description


			UIShowWallet.Message=Turbine.UI.Label(); 
			UIShowWallet.Message:SetParent(centerWindowName[i]); 
			UIShowWallet.Message:SetSize(300, 32); 
			UIShowWallet.Message:SetPosition( 1, 1); 
			UIShowWallet.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			if(tonumber(PlayerWallet[namePlayerToshow][tostring(newtable[i])].MQUA) >= 9999990 )then
				UIShowWallet.Message:SetText(rgb["gold"] .. PlayerWallet[namePlayerToshow][tostring(newtable[i])].QUA .. rgb["clear"] .. " " .. PlayerWallet[namePlayerToshow][tostring(newtable[i])].N); 
			else
				UIShowWallet.Message:SetText(rgb["gold"] .. PlayerWallet[namePlayerToshow][tostring(newtable[i])].QUA .. " / " .. PlayerWallet[namePlayerToshow][tostring(newtable[i])].MQUA .. rgb["clear"] .. " " .. PlayerWallet[namePlayerToshow][tostring(newtable[i])].N); 
			end
			UIShowWallet.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 ));
			UIShowWallet.Message:SetMarkupEnabled(true);

			--posy = posy + 38;
			listbox:AddItem( listItem );
		end
	end
	------------------------------------------------------------------------------------------
	-- create the vertical scrollbar for our viewport
	------------------------------------------------------------------------------------------
--[[
	if(((nbrItemInWallet * 38) + 40) < 400)then
		viewport1:SetSize(365, 400);
	else
		vscroll1=Turbine.UI.Lotro.ScrollBar();
		vscroll1:SetParent(UIShowWallet);
		vscroll1:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscroll1:SetPosition(windowWidth-20, 120 + addBagOrVault);
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
]]--

		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(UIShowWallet);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth-20, 120 + addBagOrVault);
		vscrollListBox:SetSize(10, 400); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (113 * 25) - 400); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

		if(((nbrItemInWallet * 38) + 40) >= 400)then
			listbox:SetVerticalScrollBar(vscrollListBox);
		end


	ClosingTheWindowWallet();

	EscapeKeyHandlerForWindows(UIShowWallet, settings["isShowWalletVisible"]["isShowWalletVisible"]);
end