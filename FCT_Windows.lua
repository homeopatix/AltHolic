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
	local winHeight;
	local heightScreen;

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
local function AttachVisibilityClosingHandler(window, settingGroup, settingField)
    if window == nil then return end
    window.Closing = function(sender, args)
        settings[settingGroup][settingField] = false;
    end
end

function ClosingTheWindow()
    AttachVisibilityClosingHandler(AltHolicWindow, "isWindowVisible", "isWindowVisible");
end
function ClosingTheWindowBag()
    AttachVisibilityClosingHandler(UIShowBag, "isShowBagVisible", "isShowBagVisible");
end
function ClosingTheWindowVault()
    AttachVisibilityClosingHandler(UIShowVault, "isShowVaultVisible", "isShowVaultVisible");
end
function ClosingTheWindowSharedStorage()
    AttachVisibilityClosingHandler(UIShowSharedStorage, "isShowSharedStorageVisible", "isShowSharedStorageVisible");
end
function ClosingTheWindowEquipment()
    AttachVisibilityClosingHandler(UIShowEquip, "isShowEquipmentVisible", "isShowEquipmentVisible");
end
function ClosingTheWindowSearch()
    AttachVisibilityClosingHandler(UIShowSearch, "isSearchWindowVisible", "isSearchWindowVisible");
end
function ClosingTheWindowOptions()
    AttachVisibilityClosingHandler(OptionsWindow, "isOptionsWindowVisible", "isOptionsWindowVisible");
end
function ClosingTheWindowOptionsBar()
    AttachVisibilityClosingHandler(OptionsWindowBar, "isOptionsWindowBarVisible", "isOptionsWindowBarVisible");
end
function ClosingTheWindowWallet()
    AttachVisibilityClosingHandler(UIShowWallet, "isShowWalletVisible", "isShowWalletVisible");
end
function ClosingTheWindowStats()
    AttachVisibilityClosingHandler(UIShowStats, "isShowStatsVisible", "isShowStatsVisible");
end
function ClosingTheWindowEpique()
    AttachVisibilityClosingHandler(UIShowEpique, "isEpiqueWindowVisible", "isEpiqueWindowVisible");
end
function ClosingTheWindowReput()
    AttachVisibilityClosingHandler(UIShowReput, "isReputWindowVisible", "isReputWindowVisible");
end
function ClosingTheInfoWindow()
    if InfoWindow == nil then return end
    InfoWindow.Closing = function(sender, args)
        InfoWindow:SetVisible(false);
        settings["isInfoWindowVisible"]["value"] = false;
    end
end
------------------------------------------------------------------------------------------
-- function to handle the size of the minimized icon --
------------------------------------------------------------------------------------------
function UpdateMinimizedIcon()
    if MainMinimizedIcon == nil then return; end

    local size = 32;
    local image = Images.MinimizedIcon;

    if settings["isMinimizeEnabled"]["isMinimizeEnabled"] == true then
        size = tonumber(settings["iconSize"]["value"]) or 32;
        if size == 16 then
            image = Images.TinyIcon16;
        elseif size == 24 then
            image = Images.TinyIcon24;
        elseif size == 32 then
            image = Images.TinyIcon;
        else
            size = 32;
            image = Images.MinimizedIcon;
        end
    end

    MainMinimizedIcon:SetImage(image);
    MainMinimizedIcon:SetSize(size, size);
    MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
    MainMinimizedIcon:SetVisible(true);
end