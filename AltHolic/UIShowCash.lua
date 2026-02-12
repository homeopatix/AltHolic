------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowCash()	
	local toSearch = 0;
	if(settings["displayServers"]["value"])then
		toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
	end

	UIShowCash=Turbine.UI.Lotro.GoldWindow(); 
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		if(settings["displayServers"]["value"])then
			toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
			UIShowCash:SetSize(420, (toSearch * 20) + 340);
		else
			UIShowCash:SetSize(420, (settings["nameAccount"]["account1"]["nbrAlt"] * 20) + 340); 
		end
	else
		UIShowCash:SetSize(420, 440); 
	end
	UIShowCash:SetText( T[ "PluginCashWindow1" ] ); 
	UIShowCash:SetPosition((Turbine.UI.Display:GetWidth()-UIShowCash:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowCash:GetHeight())/2); 

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(150,10); 
	UIShowCash.Message:SetPosition(UIShowCash:GetWidth()/2 - 75, UIShowCash:GetHeight() - 20); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowCash.Message:SetText(T[ "PluginText" ]); 
	UIShowCash:SetZOrder(10);
	UIShowCash:SetWantsKeyEvents(true);
	UIShowCash:SetVisible(false);

	------------------------------------------------------------------------------------------
	-- sort player name by alphabetical order
	------------------------------------------------------------------------------------------
	a = {};
    for i in pairs(PlayerDatas) do 
		table.insert(a, i);
	end
    table.sort(a);

	posx = 280;
	posy = 110;

	for n, i in ipairs(a) do 
		if(settings["displayServers"]["value"])then
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then

				UIShowCash.Message=Turbine.UI.Label(); 
				UIShowCash.Message:SetParent(UIShowCash); 
				UIShowCash.Message:SetSize(120, 30); 
				UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
				UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				if(i == PlayerName)then
					UIShowCash.Message:SetForeColor(Turbine.UI.Color.Lime);
				else
					UIShowCash.Message:SetForeColor(Turbine.UI.Color.White);
				end
				------------------------------------------------------------------------------------------
				--- cut off the name if too long
				------------------------------------------------------------------------------------------
				longueurName = string.len(i);
				if(longueurName > 13)then
					UIShowCash.Message:SetText(string.sub(i, 1, 12) .. "...");
				else
					UIShowCash.Message:SetText(i); 
				end

				if(PlayerDatas[i].cash == nil)then
					PlayerDatas[i].cash = PlayerAttr:GetMoney();
				end

				if(PlayerDatas[i].bagCash == nil)then
					PlayerDatas[i].bagCash = CompteBagGold();
				end

				if(PlayerDatas[i].vaultCash == nil)then
					PlayerDatas[i].vaultCash = CompteVaultGold();
				end

				DisplayCashForCashWindow(posx, posy, (PlayerDatas[i].cash + PlayerDatas[i].bagCash + PlayerDatas[i].vaultCash), i);
				posy = posy + 20;
			end
		end
	end

	------------------------------------------------------------------------------------------
	--- handle shared storage cash
	------------------------------------------------------------------------------------------
	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetForeColor(Turbine.UI.Color.White);
	UIShowCash.Message:SetText( T[ "PluginSearch5" ] ); 

	DisplayCashForCashWindow(posx, posy, tonumber(settings["sharedStorageCash"]["value"]), "SharedStorage");

	posy = posy - 10;
	posy = posy + 20;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(360, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText("___________________________________________________________________________________"); 
	UIShowCash.Message:SetForeColor(Turbine.UI.Color.Blue);
	------------------------------------------------------------------------------------------
	--- display total cash
	------------------------------------------------------------------------------------------
	posy = posy + 20;

	local totalCash = 0;

	for i in pairs(PlayerDatas) do
		if(settings["displayServers"]["value"])then
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then
					totalCash = totalCash + PlayerDatas[i].cash ;
					if(PlayerDatas[i].bagCash ~= nil)then
						totalCash = totalCash +  PlayerDatas[i].bagCash ;
					end
					if(PlayerDatas[i].vaultCash ~= nil)then
						totalCash = totalCash +  PlayerDatas[i].vaultCash ;
					end
			end
		end
	end
	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow2" ]); 

	totalCash = totalCash + tonumber(settings["sharedStorageCash"]["value"]);
	DisplayCashForCashWindow(posx, posy, totalCash, i);

	posy = posy + 40;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(360, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow3" ]); 

	posy = posy + 10;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(360, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText("___________________________________________________________________________________"); 
	UIShowCash.Message:SetForeColor(Turbine.UI.Color.Blue);
	
	posy = posy + 20;

	------------------------------------------------------------------------------------------
	-- session cash gagné
	------------------------------------------------------------------------------------------
	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow4" ]); 

	DisplayCashForCashWindow(posx, posy, settings["sessionCash"]["cashSession"], i);
	------------------------------------------------------------------------------------------
	-- session cash depense
	------------------------------------------------------------------------------------------
	posy = posy + 20;

	local totalCash = settings["sessionCash"]["cashSpent"];

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow5" ]); 

	DisplayCashForCashWindow(posx, posy, settings["sessionCash"]["cashSpent"], i);
	------------------------------------------------------------------------------------------
	-- session cash total
	------------------------------------------------------------------------------------------
	posy = posy + 20;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow6" ]); 

	local totCashForSession = settings["sessionCash"]["cashSession"] - settings["sessionCash"]["cashSpent"];

	DisplayCashForCashWindow(posx, posy, totCashForSession, i);

	------------------------------------------------------------------------------------------
	--- daily cash
	------------------------------------------------------------------------------------------
	posy = posy + 40;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(360, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow7" ]); 

	posy = posy + 10;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(360, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText("___________________________________________________________________________________"); 
	UIShowCash.Message:SetForeColor(Turbine.UI.Color.Blue);
	
	posy = posy + 20;
	------------------------------------------------------------------------------------------
	-- session cash gagné
	------------------------------------------------------------------------------------------
	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow4" ]); 

	DisplayDailyCashForCashWindow(posx, posy, settings["dailyCash"]["cashDaily"]);
	------------------------------------------------------------------------------------------
	-- session cash depense
	------------------------------------------------------------------------------------------
	posy = posy + 20;

	local totalCash = settings["dailyCash"]["cashSpent"];

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow5" ]); 

	DisplayDailyCashForCashWindow(posx, posy, settings["dailyCash"]["cashSpent"]);
	------------------------------------------------------------------------------------------
	-- session cash total
	------------------------------------------------------------------------------------------
	posy = posy + 20;

	UIShowCash.Message=Turbine.UI.Label(); 
	UIShowCash.Message:SetParent(UIShowCash); 
	UIShowCash.Message:SetSize(120, 30); 
	UIShowCash.Message:SetPosition(posx - 250, posy - 76); 
	UIShowCash.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	UIShowCash.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowCash.Message:SetText(T[ "PluginCashWindow6" ]); 

	local totCashForSession = settings["dailyCash"]["cashDaily"] - settings["dailyCash"]["cashSpent"];

	DisplayDailyCashForCashWindow(posx, posy, totCashForSession);
end