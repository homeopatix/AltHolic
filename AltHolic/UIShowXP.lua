------------------------------------------------------------------------------------------
-- UIshowXP file
-- Written by Homeopatix
-- 17 Decembre 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the Players XP window
------------------------------------------------------------------------------------------
function CreateUIShowXP()	
	local windowWidth = 420;
	local windowHeight = 0;
	local toSearch = 0;
	if(settings["displayServers"]["value"])then
		toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
	end

	UIShowXP=Turbine.UI.Lotro.GoldWindow(); 
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		if(settings["displayServers"]["value"])then
			toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
			UIShowXP:SetSize(windowWidth, (toSearch * 20) + 340);
			windowHeight = (toSearch * 20) + 340;
		else
			UIShowXP:SetSize(windowWidth, (settings["nameAccount"]["account1"]["nbrAlt"] * 20) + 340); 
			windowHeight = (settings["nameAccount"]["account1"]["nbrAlt"] * 20) + 340;
		end
	else
		UIShowXP:SetSize(windowWidth, 440); 
		windowHeight = 440;
	end
	UIShowXP:SetText( T[ "PluginXPWindow" ] ); 
	UIShowXP:SetPosition((Turbine.UI.Display:GetWidth()-UIShowXP:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowXP:GetHeight())/2); 

	UIShowXP.Message=Turbine.UI.Label(); 
	UIShowXP.Message:SetParent(UIShowXP); 
	UIShowXP.Message:SetSize(150,10); 
	UIShowXP.Message:SetPosition(UIShowXP:GetWidth()/2 - 75, UIShowXP:GetHeight() - 20); 
	UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowXP.Message:SetText(T[ "PluginText" ]); 
	UIShowXP:SetZOrder(10);
	UIShowXP:SetWantsKeyEvents(true);
	UIShowXP:SetVisible(false);


	DisplayHelpButton(UIShowXP, windowWidth, 4, settings["isXPWindowVisible"]["value"]);


	listbox = Turbine.UI.ListBox();
    listbox:SetParent( UIShowXP );
    --listbox:SetBackColor( Turbine.UI.Color.Red );
	listbox:SetSize(windowWidth - 45, windowHeight - 140);
	listbox:SetPosition(20, 70);
	listbox:IsMouseVisible(true);
	listbox:SetZOrder(20);

	------------------------------------------------------------------------------------------
	-- sort player name by alphabetical order
	------------------------------------------------------------------------------------------
	a = {};
    for i in pairs(PlayerDatas) do 
		table.insert(a, i);
	end
    table.sort(a);

	--posx = 280;
	--posy = 110;
	posx = 10;
	posy = 5;

	for n, i in ipairs(a) do 
		if(settings["displayServers"]["value"])then
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then

				listItem = Turbine.UI.Control();
				listItem:SetSize( 720, 50 );
				listItem:SetMouseVisible(true);

				UIShowXPName=Turbine.UI.Label(); 
				UIShowXPName:SetParent(listItem); 
				UIShowXPName:SetSize(400, 30); 
				UIShowXPName:SetPosition(posx, posy); 
				UIShowXPName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXPName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				if(i == PlayerName)then
					UIShowXPName:SetForeColor(Turbine.UI.Color.Lime);
				else
					UIShowXPName:SetForeColor(Turbine.UI.Color.White);
				end
				UIShowXPName:SetText(i); 
				UIShowXPName:SetMouseVisible(true);


				UIShowXPName.MouseClick = function()
					UIShowXP:SetVisible(false);
					settings["isXPWindowVisible"]["value"] = false;
					CreateUIAddNewXP(i);
					UIAddNewXP:SetVisible(true);
				end

				--posy = posy + 25;

				--colorReput = ResourcePath .. "RedBars.tga";
				--colorReput = ResourcePath .. "PurpleBars.tga";
				--colorReput = ResourcePath .. "GreenBars.tga";

				local colorReput = "";
				local currentLvl = PlayerDatas[i].xp;
				local percentage = 50;
				local sizeOfFilling = 0;

				if(currentLvl == nil)then
					currentLvl = 0;
				end

				if(PlayerDatas[i].lvl == LevelMax)then
					colorReput = ResourcePath .. "GreenBars.tga";
					percentage = 100;
				else
					colorReput = ResourcePath .. "BlueBars.tga";

					if(PlayerDatas[i].lvl > 1)then
						percentage = currentLvl * 100 / (PlayerLevelXP[PlayerDatas[i].lvl] - PlayerLevelXP[PlayerDatas[i].lvl -1]);
					else
						percentage = currentLvl * 100 / PlayerLevelXP[PlayerDatas[i].lvl];
					end
				end

				sizeOfFilling = (percentage * 350) / 100;

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(350, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				--UIShowXP.Message:SetBackColor(colorReput);
				UIShowXP.Message:SetBackground(colorReput);
				UIShowXP.Message:SetZOrder(10);

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(350, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetBackColor(Turbine.UI.Color.Black);
				UIShowXP.Message:SetZOrder(10);

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(354, 19); 
				UIShowXP.Message:SetPosition(posx - 2, posy + 23); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetBackColor(Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ));



				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(sizeOfFilling, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				--UIShowXP.Message:SetBackColor(colorReput);
				UIShowXP.Message:SetBackground(colorReput);
				UIShowXP.Message:SetZOrder(11);
				------------------------------------------------------------------------------------------
				-- display the level of the player in the bar
				------------------------------------------------------------------------------------------
				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(100, 25); 
				UIShowXP.Message:SetPosition(posx, posy + 27); 
				UIShowXP.Message:SetText(" " .. PlayerDatas[i].lvl); 
				if(currentLvl == 0 and PlayerDatas[i].lvl < 140)then
					UIShowXP.Message:SetForeColor(Turbine.UI.Color.White);
				else
					UIShowXP.Message:SetForeColor(Turbine.UI.Color.Black);
				end
				UIShowXP.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetZOrder(12);

				------------------------------------------------------------------------------------------
				-- display the xp of the player in the bar
				------------------------------------------------------------------------------------------
				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(windowWidth - 50, 25); 
				UIShowXP.Message:SetPosition(10, posy + 27); 
				if(PlayerDatas[i].lvl == LevelMax)then
					UIShowXP.Message:SetText( "" ); 
				else
					if(PlayerDatas[i].lvl > 1)then
						UIShowXP.Message:SetText( comma_value(Round(currentLvl)) .. " / " .. comma_value(Round(PlayerLevelXP[PlayerDatas[i].lvl] - PlayerLevelXP[PlayerDatas[i].lvl -1])) );
					else
						UIShowXP.Message:SetText( comma_value(Round(currentLvl)) .. " / " .. comma_value(Round(PlayerLevelXP[PlayerDatas[i].lvl])) );
					end
				end
				UIShowXP.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
				UIShowXP.Message:SetZOrder(12);


				--posy = posy + 20;
				listbox:AddItem( listItem );
			end
		else
			listItem = Turbine.UI.Control();
				listItem:SetSize( 720, 50 );
				listItem:SetMouseVisible(true);

				UIShowXPName=Turbine.UI.Label(); 
				UIShowXPName:SetParent(listItem); 
				UIShowXPName:SetSize(400, 30); 
				UIShowXPName:SetPosition(posx, posy); 
				UIShowXPName:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXPName:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				if(i == PlayerName)then
					UIShowXPName:SetForeColor(Turbine.UI.Color.Lime);
				else
					UIShowXPName:SetForeColor(Turbine.UI.Color.White);
				end
				UIShowXPName:SetText(i); 
				UIShowXPName:SetMouseVisible(true);


				UIShowXPName.MouseClick = function()
					UIShowXP:SetVisible(false);
					settings["isXPWindowVisible"]["value"] = false;
					CreateUIAddNewXP(i);
					UIAddNewXP:SetVisible(true);
				end

				--posy = posy + 25;

				--colorReput = ResourcePath .. "RedBars.tga";
				--colorReput = ResourcePath .. "PurpleBars.tga";
				--colorReput = ResourcePath .. "GreenBars.tga";

				local colorReput = "";
				local currentLvl = PlayerDatas[i].xp;
				local percentage = 50;
				local sizeOfFilling = 0;

				if(currentLvl == nil)then
					currentLvl = 0;
				end

				if(PlayerDatas[i].lvl == LevelMax)then
					colorReput = ResourcePath .. "GreenBars.tga";
					percentage = 100;
				else
					colorReput = ResourcePath .. "BlueBars.tga";

					if(PlayerDatas[i].lvl > 1)then
						percentage = currentLvl * 100 / (PlayerLevelXP[PlayerDatas[i].lvl] - PlayerLevelXP[PlayerDatas[i].lvl -1]);
					else
						percentage = currentLvl * 100 / PlayerLevelXP[PlayerDatas[i].lvl];
					end
				end

				sizeOfFilling = (percentage * 350) / 100;

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(350, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				--UIShowXP.Message:SetBackColor(colorReput);
				UIShowXP.Message:SetBackground(colorReput);
				UIShowXP.Message:SetZOrder(10);

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(350, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetBackColor(Turbine.UI.Color.Black);
				UIShowXP.Message:SetZOrder(10);

				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(354, 19); 
				UIShowXP.Message:SetPosition(posx - 2, posy + 23); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetBackColor(Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ));



				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(sizeOfFilling, 15); 
				UIShowXP.Message:SetPosition(posx, posy + 25); 
				UIShowXP.Message:SetText(""); 
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				--UIShowXP.Message:SetBackColor(colorReput);
				UIShowXP.Message:SetBackground(colorReput);
				UIShowXP.Message:SetZOrder(11);
				------------------------------------------------------------------------------------------
				-- display the level of the player in the bar
				------------------------------------------------------------------------------------------
				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(100, 25); 
				UIShowXP.Message:SetPosition(posx, posy + 27); 
				UIShowXP.Message:SetText(PlayerDatas[i].lvl); 
				UIShowXP.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowXP.Message:SetZOrder(12);

				------------------------------------------------------------------------------------------
				-- display the xp of the player in the bar
				------------------------------------------------------------------------------------------
				UIShowXP.Message=Turbine.UI.Label(); 
				UIShowXP.Message:SetParent(listItem); 
				UIShowXP.Message:SetSize(windowWidth, 25); 
				UIShowXP.Message:SetPosition(10, posy + 27); 
				if(PlayerDatas[i].lvl == LevelMax)then
					UIShowXP.Message:SetText( "" ); 
				else
					if(PlayerDatas[i].lvl > 1)then
						UIShowXP.Message:SetText( comma_value(Round(currentLvl)) .. " / " .. comma_value(Round(PlayerLevelXP[PlayerDatas[i].lvl] - PlayerLevelXP[PlayerDatas[i].lvl -1])) );
					else
						UIShowXP.Message:SetText( comma_value(Round(currentLvl)) .. " / " .. comma_value(Round(PlayerLevelXP[PlayerDatas[i].lvl])) );
					end
				end
				UIShowXP.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
				UIShowXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
				UIShowXP.Message:SetZOrder(12);


				--posy = posy + 20;
				listbox:AddItem( listItem );
		end
	end

	------------------------------------------------------------------------------------------
	--- scrollbar handler
	------------------------------------------------------------------------------------------
	vscrollListBox=Turbine.UI.Lotro.ScrollBar();
	vscrollListBox:SetParent(UIShowXP);
	vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
	vscrollListBox:SetPosition(windowWidth-20, 70);
	vscrollListBox:SetSize(10, windowHeight - 140); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
	vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
	vscrollListBox:SetMinimum(0);
	vscrollListBox:SetMaximum( (113 * 25) - 400); -- we will allow scrolling the height of the map-the viewport height
	vscrollListBox:SetValue(0); -- set the initial value
	-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
	vscrollListBox.ValueChanged=function()
		listbox:SetTop(0-vscrollListBox:GetValue());
	end

	listbox:SetVerticalScrollBar(vscrollListBox);

	EscapeKeyHandlerForWindows(UIShowXP, settings["isXPWindowVisible"]["value"]);
end