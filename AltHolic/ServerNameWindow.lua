------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 0;
local windowHeight = 0;

windowWidth = 400;
windowHeight = 800;

checkBoxServerName = {};
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateServerNameWindow(PlayerToSetServer)
		local nbrPlayerSaverName = 0;

		for i in pairs(ServerNames) do 
			nbrPlayerSaverName = nbrPlayerSaverName + 1;
		end

		if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
			windowHeight = 200 + (nbrPlayerSaverName * 32);
		else
			windowHeight = 200;
		end

		if(Turbine.UI.Display:GetHeight() < windowHeight)then
			windowHeight = Turbine.UI.Display:GetHeight() - 150;
		end
		
		ServerNameWindow=Turbine.UI.Lotro.GoldWindow(); 
		ServerNameWindow:SetSize(windowWidth, windowHeight); 
		ServerNameWindow:SetText(T[ "ServerNameWindow" ] .. " " .. PlayerToSetServer); 

		ServerNameWindow.Message=Turbine.UI.Label(); 
		ServerNameWindow.Message:SetParent(ServerNameWindow); 
		ServerNameWindow.Message:SetSize(150,10); 
		ServerNameWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		ServerNameWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		ServerNameWindow.Message:SetText(T[ "PluginText" ]); 

		ServerNameWindow:SetZOrder(100);
		ServerNameWindow:SetWantsKeyEvents(true);
		ServerNameWindow:SetWantsUpdates(true);

		ServerNameWindow:SetPosition((Turbine.UI.Display:GetWidth()-ServerNameWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-ServerNameWindow:GetHeight())/2);
		ServerNameWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option panel --
		------------------------------------------------------------------------------------------

		posx = 100;
		posy = 70;

		for i in pairs(ServerNames) do 
			AltHolicWindow.Message135=Turbine.UI.Label(); 
			AltHolicWindow.Message135:SetParent(ServerNameWindow); 
			AltHolicWindow.Message135:SetSize(32,32); 
			--AltHolicWindow.Message135:SetBackColor(Turbine.UI.Color.Red);
			AltHolicWindow.Message135:SetPosition(posx - 40, posy); 
			AltHolicWindow.Message135:SetBackground(ResourcePath .. "Server_Icon.tga");
			AltHolicWindow.Message135:SetBlendMode(Turbine.UI.BlendMode.Overlay);
			AltHolicWindow.Message135:SetZOrder(3);
			AltHolicWindow.Message135:SetMouseVisible(true);

			AltHolicWindow.Message136=Turbine.UI.Label(); 
			AltHolicWindow.Message136:SetParent(ServerNameWindow); 
			AltHolicWindow.Message136:SetSize(25,20); 
			AltHolicWindow.Message136:SetPosition(posx - 38, posy + 10); 
			AltHolicWindow.Message136:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			AltHolicWindow.Message136:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
			AltHolicWindow.Message136:SetForeColor(Turbine.UI.Color.Red);
			--AltHolicWindow.Message136:SetBackColor(Turbine.UI.Color.Red);
			AltHolicWindow.Message136:SetText(tostring(i));
			AltHolicWindow.Message136:SetZOrder(4);
			AltHolicWindow.Message136:SetMouseVisible(true);

			ServerNameWindow.Message=Turbine.UI.Label(); 
			ServerNameWindow.Message:SetParent(ServerNameWindow); 
			ServerNameWindow.Message:SetSize(300, 30); 
			ServerNameWindow.Message:SetPosition(posx, posy); 
			ServerNameWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			ServerNameWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			ServerNameWindow.Message:SetText(ServerNames[i]); 

			checkBoxServerName[i] = Turbine.UI.Lotro.CheckBox();
			checkBoxServerName[i]:SetParent( ServerNameWindow );
			checkBoxServerName[i]:SetSize(40, 40); 
			checkBoxServerName[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxServerName[i]:SetText("");
			checkBoxServerName[i]:SetPosition(posx + 200, posy - 5);
			checkBoxServerName[i]:SetVisible(true);
			checkBoxServerName[i]:SetMouseVisible(true);
			if(PlayerDatas[PlayerToSetServer].serverName == ServerNames[i])then
				checkBoxServerName[i]:SetChecked(true);
			else
				checkBoxServerName[i]:SetChecked(false);
			end
			checkBoxServerName[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			checkBoxServerName[i].CheckedChanged = function()
				if(checkBoxServerName[i]:IsChecked())then
					DeactivateAllButtons(i);
					PlayerServer[PlayerToSetServer] = ServerNames[i];
					SavePlayerServerName(PlayerToSetServer);
				end	
			end
			posy = posy + 35;
		end

		buttonValider = Turbine.UI.Lotro.GoldButton();
		buttonValider:SetParent( ServerNameWindow );
		buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
		buttonValider:SetSize( 300, 20 );
		buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValider:SetText( T[ "PluginCloseButton" ] );
		buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValider:SetVisible(true);
		buttonValider:SetMouseVisible(true);

		CloseServerNameWindow();
		EscapeKeyHandlerForWindows(ServerNameWindow, settings["isServerWindowVisible"]["value"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function DeactivateAllButtons(x)
	for i=1, nbrServers do
		if(i == x)then
			checkBoxServerName[i]:SetChecked(true);
		else
			checkBoxServerName[i]:SetChecked(false);
		end
	end
end
function CloseServerNameWindow()
	buttonValider.MouseClick = function(sender, args)
		ServerNameWindow:SetVisible(false);
		settings["isServerWindowVisible"]["value"] = false;
		UpdateMainWindow();
	end
end