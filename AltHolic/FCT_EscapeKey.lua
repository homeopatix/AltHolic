------------------------------------------------------------------------------------------
-- Keyboard handling: Escape closes AltHolic windows, the HUD toggle (F12 by default)
-- hides and restores everything AltHolic shows on screen.
-- Written by Homeopatix, 26 january 2021; reworked for AltHolic 5.06.
------------------------------------------------------------------------------------------

-- The HUD toggle action is not part of the Turbine.UI.Lotro.Action enumeration.
local HUD_TOGGLE_ACTION = 268435635;
local hudHidden = false;
local hudKeyListener = nil;

function IsAltHolicHudHidden()
	return hudHidden;
end

local function SetHudHidden(hidden)
	hudHidden = hidden;
	if hidden then
		-- Only hide; the saved visibility settings are left alone so they can be restored.
		if AltHolicWindow ~= nil then AltHolicWindow:SetVisible(false); end
		if AltHolicBar ~= nil then AltHolicBar:SetVisible(false); end
		if MainMinimizedIcon ~= nil then MainMinimizedIcon:SetVisible(false); end
	else
		if settings["isWindowVisible"]["isWindowVisible"] == true then ShowMainWindow(); end
		if AltHolicBar ~= nil then AltHolicBar:SetVisible(settings["displayBarWindow"]["value"] == true); end
		UpdateMinimizedIcon();
	end
end

-- A single hidden listener receives the HUD toggle, so it is processed exactly once no
-- matter which AltHolic windows exist (the main window and the toolbar used to both
-- react to it, with conflicting logic).
function InstallHudKeyListener()
	if hudKeyListener ~= nil then return; end
	hudKeyListener = Turbine.UI.Window();
	hudKeyListener:SetSize(1, 1);
	hudKeyListener:SetVisible(false);
	hudKeyListener:SetWantsKeyEvents(true);
	hudKeyListener.KeyDown = function(sender, args)
		if args.Action == HUD_TOGGLE_ACTION then
			SetHudHidden(not hudHidden);
		end
	end
end

------------------------------------------------------------------------------------------
-- Escape key handler for the main window
------------------------------------------------------------------------------------------
function EscapeKeyHandler()
	AltHolicWindow.KeyDown = function(sender, args)
		if args.Action == Turbine.UI.Lotro.Action.Escape and settings["escEnable"]["escEnable"] == true then
			HideMainWindow();
		end
	end
end

------------------------------------------------------------------------------------------
-- Escape / HUD key handler for secondary windows.
-- settingGroup/settingField name the saved visibility flag to clear (field defaults to
-- "value"). The old version received the flag's *value* and assigned to its own parameter,
-- so the flag was never cleared and the next icon click only "closed" an already hidden
-- window.
------------------------------------------------------------------------------------------
function EscapeKeyHandlerForWindows(window, settingGroup, settingField)
	if window == nil then return; end
	window.KeyDown = function(sender, args)
		if args.Action == Turbine.UI.Lotro.Action.Escape or args.Action == HUD_TOGGLE_ACTION then
			window:SetVisible(false);
			if type(settingGroup) == "string" and settings[settingGroup] ~= nil then
				settings[settingGroup][settingField or "value"] = false;
			end
		end
	end
end
