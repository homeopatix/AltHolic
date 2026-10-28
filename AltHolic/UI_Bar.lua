------------------------------------------------------------------------------------------
-- UI file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Initialize datas
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
function CreateBarWindow()
	-- The bar is rebuilt when several settings/data points change. Detach the previous
	-- window first so its entire child-control tree can be released by Turbine.
	AltHolicUtil.DetachControl(AltHolicBar);

	AltHolicBar=Turbine.UI.Extensions.SimpleWindow(); 
	AltHolicBar:SetSize(screenWidth, 50); 
	AltHolicBar:SetBackColor(Turbine.UI.Color.Black);
	AltHolicBar:SetPosition(0, 0);
	AltHolicBar:SetVisible(settings["displayBarWindow"]["value"] == true and not IsAltHolicHudHidden());
	AltHolicBar:SetZOrder(1);
	AltHolicBar:SetOpacity(0.75);
	AltHolicBar:SetMouseVisible(true);


	DisplayNamePlayer_Bar();

	-- Optional toolbar sections, in display order (setting -> builder).
	local sections = {
		{ "displayBarIcon2",   DisplayLvlPlayer_Bar },
		{ "displayBarIcon16",  DisplayXPWindow_Bar },
		{ "displayBarIcon3",   DisplayRacePlayer_Bar },  -- "Display the race"
		{ "displayBarIcon4",   DisplayClassPlayer_Bar }, -- "Display the class"
		{ "displayBarIcon5",   DisplayServerPlayer_Bar },
		{ "displayBarIcon6",   DisplayCashOfPlayer_Bar },
		{ "displayBarIcon7",   DisplayWalletButton_Bar },
		{ "displayBarIcon8",   DisplayVaultButton_Bar },
		{ "displayBarIcon9",   DisplayBagButton_Bar },
		{ "displayBarIcon10",  DisplayProfessions_Bar },
		{ "displayBarIcon11",  DisplaySharedStorage_Bar },
		{ "displayBarIcon12",  DisplayEpiqueBook_Bar },
		{ "displayBarIcon13",  DisplayLoupe_Bar },
		{ "displayBarIcon14",  DisplayTotalCash_Bar },
		{ "displayBarIcon15",  DisplaySessionCash_Bar },
		{ "displayTokensIcon", DisplayTokensIcon_Bar },
	};
	for _, section in ipairs(sections) do
		if settings[section[1]]["value"] == true then section[2](); end
	end

	DisplayAltHolicIcon_Bar();

	AltHolicBar.MouseClick = function()
		if OptionsWindowBar ~= nil and OptionsWindowBar:IsVisible() then
			OptionsWindowBar:SetVisible(false);
			settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = false;
		else
			GenerateOptionsWindowBar();
			settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = true;
			OptionsWindowBar:SetVisible(true);
		end
	end

	-- The HUD toggle is handled centrally (see InstallHudKeyListener). The bar used to flip
	-- the saved displayBarWindow option itself on F12, which could permanently disable it.
end
------------------------------------------------------------------------------------------
-- function to update the bar --
------------------------------------------------------------------------------------------
function UpdateBar()
	if settings["displayBarWindow"]["value"] == true then
		CreateBarWindow();
	elseif AltHolicBar ~= nil then
		AltHolicBar:SetVisible(false);
	end
end
