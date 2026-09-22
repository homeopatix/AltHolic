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
	if AltHolicBar ~= nil then
		pcall(function() AltHolicBar:SetVisible(false); end);
		pcall(function() AltHolicBar:SetParent(nil); end);
	end

	AltHolicBar=Turbine.UI.Extensions.SimpleWindow(); 
	AltHolicBar:SetSize(screenWidth, 50); 
	AltHolicBar:SetBackColor(Turbine.UI.Color.Black);
	AltHolicBar:SetPosition(0, 0);
	AltHolicBar:SetVisible(settings["displayBarWindow"]["value"]);
	AltHolicBar:SetZOrder(1);
	AltHolicBar:SetOpacity(0.75);
	AltHolicBar:SetWantsKeyEvents(true);
	AltHolicBar:SetMouseVisible(true);


	DisplayNamePlayer_Bar();

	if(settings["displayBarIcon2"]["value"] == true)then
		DisplayLvlPlayer_Bar();
	end
	if(settings["displayBarIcon16"]["value"] == true)then
		DisplayXPWindow_Bar();
	end
	if(settings["displayBarIcon4"]["value"] == true)then
		DisplayClassPlayer_Bar();
	end
	if(settings["displayBarIcon3"]["value"] == true)then
		DisplayRacePlayer_Bar();
	end
	if(settings["displayBarIcon5"]["value"] == true)then
		DisplayServerPlayer_Bar();
	end
	if(settings["displayBarIcon6"]["value"] == true)then
		DisplayCashOfPlayer_Bar();
	end
	if(settings["displayBarIcon7"]["value"] == true)then
		DisplayWalletButton_Bar();
	end
	if(settings["displayBarIcon8"]["value"] == true)then
		DisplayVaultButton_Bar();
	end
	if(settings["displayBarIcon9"]["value"] == true)then
		DisplayBagButton_Bar();
	end
	if(settings["displayBarIcon10"]["value"] == true)then
		DisplayProfessions_Bar();
	end
	if(settings["displayBarIcon11"]["value"] == true)then
		DisplaySharedStorage_Bar();
	end
	if(settings["displayBarIcon12"]["value"] == true)then
		DisplayEpiqueBook_Bar();
	end
	if(settings["displayBarIcon13"]["value"] == true)then
		DisplayLoupe_Bar();
	end
	if(settings["displayBarIcon14"]["value"] == true)then
		DisplayTotalCash_Bar();
	end
	if(settings["displayBarIcon15"]["value"] == true)then
		DisplaySessionCash_Bar();
	end
	if(settings["displayTokensIcon"]["value"] == true)then
		DisplayTokensIcon_Bar();
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

	EscapeKeyHandlerForWindows(AltHolicBar, settings["displayBarWindow"]["value"]);

	AltHolicBar.KeyDown=function(sender, args)
		if ( args.Action == 268435635 ) then
			if(settings["displayBarWindow"]["value"] == true)then
				AltHolicBar:SetVisible(false);
				settings["displayBarWindow"]["value"] = false;
			else
				if(settings["wasAltHolicBarVisible"]["value"] == true)then
					AltHolicBar:SetVisible(true);
					settings["displayBarWindow"]["value"] = true;
				end
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- function to update the bar --
------------------------------------------------------------------------------------------
function UpdateBar()
	if(settings["displayBarWindow"]["value"] == true)then
		AltHolicBar:SetVisible(false);
		CreateBarWindow();
		AltHolicBar:SetVisible(true);
	else
		AltHolicBar:SetVisible(false);
	end
end