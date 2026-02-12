------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowEpique()	
	local windowWidth = 420;
	local windowHeight = 0;

	UIShowEpique=Turbine.UI.Lotro.GoldWindow(); 
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		if(settings["displayServers"]["value"])then
			toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
			windowHeight = (toSearch * 20) + 340;
		else
			windowHeight = (settings["nameAccount"]["account1"]["nbrAlt"] * 20) + 340;
		end
	else
		windowHeight = 440;
	end

	if(Turbine.UI.Display:GetHeight() < windowHeight)then
		windowHeight = Turbine.UI.Display:GetHeight() - 150;
	end

	--Write("windowHeight : " .. windowHeight);

	UIShowEpique:SetSize(windowWidth, windowHeight); 
	UIShowEpique:SetText( T[ "PluginEpiqueWindow1" ] ); 
	UIShowEpique:SetPosition((Turbine.UI.Display:GetWidth()-UIShowEpique:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowEpique:GetHeight())/2); 

	UIShowEpique.Message=Turbine.UI.Label(); 
	UIShowEpique.Message:SetParent(UIShowEpique); 
	UIShowEpique.Message:SetSize(150,10); 
	UIShowEpique.Message:SetPosition(UIShowEpique:GetWidth()/2 - 75, UIShowEpique:GetHeight() - 20); 
	UIShowEpique.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowEpique.Message:SetText(T[ "PluginText" ]); 
	UIShowEpique:SetZOrder(10);
	UIShowEpique:SetWantsKeyEvents(true);
	UIShowEpique:SetVisible(false);


	DisplayHelpButton(UIShowEpique, windowWidth, 2, settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"]);

	------------------------------------------------------------------------------------------
	-- sort player name by alphabetical order
	------------------------------------------------------------------------------------------
	a = {};
    for i in pairs(PlayerDatas) do 
		table.insert(a, i);
	end
    table.sort(a);

	posx = 260;
	posy = 100;

	listbox = Turbine.UI.ListBox();
	listbox:SetParent( UIShowEpique );
	--listbox:SetBackColor( Turbine.UI.Color.Red );
	listbox:SetSize(windowWidth - 40, windowHeight - 150);
	listbox:SetPosition(10, 80);
	listbox:IsMouseVisible(true);
	listbox:SetZOrder(20);

	textBoxBook = {};

	for n, i in ipairs(a) do 
		if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then
				if(PlayerDatas[i].align == 1)then
			listItem = Turbine.UI.Control();
			if(PlayerEpique[i] ~= nil)then
				tabelSize = tablelength(PlayerEpique[i].volume);
			else
				tabelSize = 0;
			end
			listItem:SetSize( windowWidth - 45, (tabelSize * 32) + 30);
			listItem:SetMouseVisible(true);


			UIShowEpique.Message=Turbine.UI.Label(); 
			UIShowEpique.Message:SetParent(listItem); 
			UIShowEpique.Message:SetSize(120, 30); 
			UIShowEpique.Message:SetPosition(posx - 220, posy - 96); 
			UIShowEpique.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowEpique.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			if(i == PlayerName)then
				UIShowEpique.Message:SetForeColor(Turbine.UI.Color.Lime);
				DisplayLabelEpique(i, posx - 250, posy - 88, T[ "PluginAddNewEpique" ], "AddNew.tga", listItem);
			else
				UIShowEpique.Message:SetForeColor(Turbine.UI.Color.White);
			end
			------------------------------------------------------------------------------------------
			--- cut off the name if too long
			------------------------------------------------------------------------------------------
			longueurName = string.len(i);
			if(longueurName > 13)then
				UIShowEpique.Message:SetText(string.sub(i, 1, 12) .. "...");
			else
				UIShowEpique.Message:SetText(i); 
			end

			for name in pairs(PlayerEpique) do
				if(i == name)then
					--Write(name);
					for book in pairs(PlayerEpique[name]) do
						--Write(book);
						if(book == "volume")then
							for xy = 1, tablelength(PlayerEpique[name].volume) do
								textBoxBook[i] = Turbine.UI.Label();
								textBoxBook[i]:SetParent( listItem );
								textBoxBook[i]:SetSize(300, 40); 
								textBoxBook[i]:SetPosition(posx - 170, posy - 77);
								textBoxBook[i]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
								textBoxBook[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
								if(PlayerEpique[name].volume[xy] ~= nil or PlayerEpique[name].volume[xy] ~= "")then
									textBoxBook[i]:SetText(PlayerEpique[name].volume[xy] .. "  " .. PlayerEpique[name].livre[xy] .. "  " .. PlayerEpique[name].chapitre[xy]);

									text = {};
									text = Split(PlayerEpique[name].volume[xy], " ");

									BookIcon = Turbine.UI.Label();
									BookIcon:SetParent( listItem );
									BookIcon:SetSize(32, 32); 
									BookIcon:SetPosition(posx - 205, posy - 71);
									if(text[2] == "I" or text[2] == "1")then
										BookIcon:SetBackground( 0x41101698 );
									end
									if(text[2] == "II" or text[2] == "2")then
										BookIcon:SetBackground( 0x41101680 );
									end
									if(text[2] == "III" or text[2] == "3")then
										BookIcon:SetBackground( 0x4111F7BA );
									end
									if(text[2] == "IV" or text[2] == "4")then
										BookIcon:SetBackground( 0x4111F7BC );
									end
									if(text[2] == "V" or text[2] == "5")then
										BookIcon:SetBackground( 0x4113B2E7 );
									end
									BookIcon:SetVisible(true);
									BookIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
								end
								textBoxBook[i]:SetForeColor( Turbine.UI.Color.Gold);
								textBoxBook[i]:SetVisible(true);
								textBoxBook[i]:SetMouseVisible(true);


								if(i == PlayerName)then
									textBoxBook[i].MouseClick = function()
										CreateAddNewWindowEpique(xy);
										AltHolicAddnewWindowEpique:SetVisible(true);
									end
								end

								posy = posy + 30;
							end
						end
					end
				end
			end
			listbox:AddItem( listItem );
			posy = 100;
		end
		end
	end

	if(windowHeight > 440)then
		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(UIShowEpique);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth - 20,  80);
		vscrollListBox:SetSize(10, windowHeight - 110); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (113 * 25) - 400); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

		listbox:SetVerticalScrollBar(vscrollListBox);
	end
		

	EpiqueWindowButton = Turbine.UI.Lotro.GoldButton();
	EpiqueWindowButton:SetParent( UIShowEpique );
	EpiqueWindowButton:SetPosition(windowWidth/2 - 125, windowHeight - 50);
	EpiqueWindowButton:SetSize( 300, 20 );
	EpiqueWindowButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	EpiqueWindowButton:SetText( T[ "PluginCloseButton" ] );
	EpiqueWindowButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	EpiqueWindowButton:SetVisible(true);
	EpiqueWindowButton:SetMouseVisible(true);

	EpiqueWindowButton.MouseClick = function(sender, args)
		settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = false;
		UIShowEpique:SetVisible(false);
	end


	ClosingTheWindowEpique();

	EscapeKeyHandlerForWindows(UIShowEpique, settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"]);

end

function ReturnNumberBooks(name)
	local nbrBook = 0;
	for book in pairs(PlayerEpique[name]) do
		nbrBook = nbrBook + 1;
	end
	return nbrBook;
end