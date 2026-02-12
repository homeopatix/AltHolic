------------------------------------------------------------------------------------------
-- FCT_Windows file
-- Written by Homeopatix
-- 10 march 2022
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Position changed window
------------------------------------------------------------------------------------------
function PositionChangedWindow()
	------------------------------------------------------------------------------------------
	-- if the position changes, save the new window location
	------------------------------------------------------------------------------------------
	AltHolicWindow.PositionChanged = function( sender, args )
    	local x,y = AltHolicWindow:GetPosition();
    	settings["windowPosition"]["xPos"] = x;
    	settings["windowPosition"]["yPos"] = y;
	end
end
------------------------------------------------------------------------------------------
-- Updating the main windows --
------------------------------------------------------------------------------------------
function UpdateMainWindow()
	
	AltHolicWindow:SetVisible(false);
	if(settings["nameAccount"]["account1"]["nbrAlt"] == 0 or settings["nameAccount"]["account1"]["isVisible"] == false)then
		if(settings["displaySpentCash"]["value"] == true)then
			CreateMainWindow(400, 210);
		else
			CreateMainWindow(400, 150);
		end
		AltHolicWindow:SetVisible(settings["isWindowVisible"]["isWindowVisible"]);
	else
		if(settings["displaySpentCash"]["value"] == true)then
			if(settings["displayServers"]["value"])then
				local toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
				winHeight = (toSearch * 46) + 210;
			else
				winHeight = (settings["nameAccount"]["account1"]["nbrAlt"] * 46) + 210;
			end
			if(winHeight < 210)then
				winHeight = 200;
			end
		else
			if(settings["displayServers"]["value"])then
				local toSearch = ReturnNBCharactersOnServer(settings["serversToDisplay"]["value"]);
				winHeight = (toSearch * 46) + 150;
			else
				winHeight = (settings["nameAccount"]["account1"]["nbrAlt"] * 46) + 150;
			end
			if(winHeight < 150)then
				winHeight = 200;
			end
		end

		--Write("Windows height : " .. winHeight);

		heightScreen = Turbine.UI.Display:GetHeight();

		if(winHeight > (heightScreen - 100))then
			winHeight = (heightScreen - 100);
		end

		CreateMainWindow(400, winHeight);
		--Write("Windows height : " .. winHeight);
		AltHolicWindow:SetVisible(settings["isWindowVisible"]["isWindowVisible"]);
	end
end
------------------------------------------------------------------------------------------
-- Closing window handler --
------------------------------------------------------------------------------------------
function ClosingTheWindow()
	function AltHolicWindow:Closing(sender, args)
		settings["isWindowVisible"]["isWindowVisible"] = false;
	end
end
function ClosingTheWindowBag()
	function UIShowBag:Closing(sender, args)
		settings["isShowBagVisible"]["isShowBagVisible"] = false;
	end
end
function ClosingTheWindowVault()
	function UIShowVault:Closing(sender, args)
		settings["isShowVaultVisible"]["isShowVaultVisible"] = false;
	end
end
function ClosingTheWindowSharedStorage()
	function UIShowSharedStorage:Closing(sender, args)
		settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = false;
	end
end
function ClosingTheWindowEquipment()
	function UIShowEquip:Closing(sender, args)
		settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = false;
	end
end
function ClosingTheWindowSearch()
	function UIShowSearch:Closing(sender, args)
		settings["isSearchWindowVisible"]["isSearchWindowVisible"] = false;
	end
end
function ClosingTheWindowOptions()
	function OptionsWindow:Closing(sender, args)
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
	end
end 
function ClosingTheWindowOptionsBar()
	function OptionsWindowBar:Closing(sender, args)
		settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = false;
	end
end 
function ClosingTheWindowWallet()
	function UIShowWallet:Closing(sender, args)
		settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
	end
end 
function ClosingTheWindowStats()
	function UIShowStats:Closing(sender, args)
		settings["isShowStatsVisible"]["isShowStatsVisible"] = false;
	end
end
function ClosingTheWindowEpique()
	function UIShowEpique:Closing(sender, args)
		settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = false;
	end
end
function ClosingTheWindowReput()
	function UIShowReput:Closing(sender, args)
		settings["isReputWindowVisible"]["isReputWindowVisible"] = false;
	end
end
function ClosingTheInfoWindow()
	function InfoWindow:Closing(sender, args)
		InfoWindow:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
-- function to handle the size of the minimized icon --
------------------------------------------------------------------------------------------
function UpdateMinimizedIcon()
	if(settings["isMinimizeEnabled"]["isMinimizeEnabled"] == false)then
		MainMinimizedIcon:SetVisible(true);
		MainTinyIcon:SetVisible(false);
		MainTinyIcon24:SetVisible(false);
		MainTinyIcon16:SetVisible(false);
		MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	else
		if(settings["iconSize"]["value"] == 32)then
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
end