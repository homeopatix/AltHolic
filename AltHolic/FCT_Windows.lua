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
-- Main window: build, show and hide
------------------------------------------------------------------------------------------
-- UpdateMainWindow() is called on every coin, level, vault or shared-storage change. A full
-- rebuild creates hundreds of controls, so while the window is closed the rebuild is only
-- recorded and performed the next time the window is shown.
local mainWindowDirty = false;

local function MainWindowHeight()
	local account = settings["nameAccount"]["account1"];
	local baseHeight = (settings["displaySpentCash"]["value"] == true) and 210 or 150;

	if account["nbrAlt"] == 0 or account["isVisible"] == false then
		return baseHeight;
	end

	-- Same filter as the rows themselves (an empty server choice means "all servers").
	local characterCount = #AltHolicUtil.GetDisplayedCharacterNames();
	return math.min((characterCount * 46) + baseHeight, Turbine.UI.Display:GetHeight() - 100);
end

function UpdateMainWindow(force)
	if force ~= true and AltHolicWindow ~= nil and not AltHolicWindow:IsVisible() then
		mainWindowDirty = true;
		return;
	end
	mainWindowDirty = false;

	if AltHolicWindow ~= nil then AltHolicWindow:SetVisible(false); end
	CreateMainWindow(400, MainWindowHeight());
	AltHolicWindow:SetVisible(settings["isWindowVisible"]["isWindowVisible"] == true and not IsAltHolicHudHidden());
end

function ShowMainWindow()
	settings["isWindowVisible"]["isWindowVisible"] = true;
	if mainWindowDirty or AltHolicWindow == nil then
		UpdateMainWindow(true);
	else
		AltHolicWindow:SetVisible(not IsAltHolicHudHidden());
	end
end

function HideMainWindow()
	settings["isWindowVisible"]["isWindowVisible"] = false;
	if AltHolicWindow ~= nil then AltHolicWindow:SetVisible(false); end
end

function ToggleMainWindow()
	if AltHolicWindow ~= nil and AltHolicWindow:IsVisible() then
		HideMainWindow();
	else
		ShowMainWindow();
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
-- Apply the launcher icon size/visibility settings to the single launcher window.
------------------------------------------------------------------------------------------
function UpdateMinimizedIcon()
	if MainMinimizedIcon == nil then return; end

	local image, size = ResolveLauncherIcon();
	MainMinimizedIcon:SetImage(image);
	MainMinimizedIcon:SetSize(size, size);
	MainMinimizedIcon:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MainMinimizedIcon:SetVisible(settings["isLauncherVisible"]["value"] ~= false and not IsAltHolicHudHidden());
end
