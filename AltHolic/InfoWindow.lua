------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 0;
local windowHeight = 0;

windowWidth = 400;
windowHeight = 500;
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateInfosWindow(value)
		InfoWindow=Turbine.UI.Lotro.GoldWindow(); 
		InfoWindow:SetSize(windowWidth, windowHeight); 
		InfoWindow:SetText(T[ "PluginInfo1" ] .. value); 
		InfoWindow:SetPosition((Turbine.UI.Display:GetWidth()-InfoWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-InfoWindow:GetHeight())/2);

		InfoWindow.Message=Turbine.UI.Label(); 
		InfoWindow.Message:SetParent(InfoWindow); 
		InfoWindow.Message:SetSize(150,10); 
		InfoWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		InfoWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		InfoWindow.Message:SetText(T[ "PluginText" ]); 

		InfoWindow:SetZOrder(1000);
		InfoWindow:SetWantsKeyEvents(true);
		InfoWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- center window
		------------------------------------------------------------------------------------------

		textBoxLines = Turbine.UI.Lotro.TextBox();
		textBoxLines:SetParent( InfoWindow );
		textBoxLines:SetSize(380, 360); 
		if(PlayerInfos[value] == nil or PlayerInfos[value].info == "")then
			textBoxLines:SetText( "" ); 
		else
			textBoxLines:SetText( PlayerInfos[value].info ); 
		end
		textBoxLines:SetPosition(10, 40);
		textBoxLines:SetVisible(true);
		textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		textBoxLines:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		textBoxLines:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

		InfoWindowButtonValidate = Turbine.UI.Lotro.GoldButton();
		InfoWindowButtonValidate:SetParent( InfoWindow );
		InfoWindowButtonValidate:SetPosition(windowWidth/2 - 125, windowHeight - 90);
		InfoWindowButtonValidate:SetSize( 300, 20 );
		InfoWindowButtonValidate:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		InfoWindowButtonValidate:SetText( T[ "PluginInfo2" ] );
		InfoWindowButtonValidate:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		InfoWindowButtonValidate:SetVisible(true);
		InfoWindowButtonValidate:SetMouseVisible(true);

		InfoWindowButtonClear = Turbine.UI.Lotro.GoldButton();
		InfoWindowButtonClear:SetParent( InfoWindow );
		InfoWindowButtonClear:SetPosition(windowWidth/2 - 125, windowHeight - 65);
		InfoWindowButtonClear:SetSize( 300, 20 );
		InfoWindowButtonClear:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		InfoWindowButtonClear:SetText( T[ "PluginInfo3" ] );
		InfoWindowButtonClear:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		InfoWindowButtonClear:SetVisible(true);
		InfoWindowButtonClear:SetMouseVisible(true);

		InfoWindowButton = Turbine.UI.Lotro.GoldButton();
		InfoWindowButton:SetParent( InfoWindow );
		InfoWindowButton:SetPosition(windowWidth/2 - 125, windowHeight - 40);
		InfoWindowButton:SetSize( 300, 20 );
		InfoWindowButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		InfoWindowButton:SetText( T[ "PluginCloseButton" ] );
		InfoWindowButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		InfoWindowButton:SetVisible(true);
		InfoWindowButton:SetMouseVisible(true);

		CloseButtonInfos();
		CloseButtonInfosValidate(value);
		CloseButtonInfosClear(value);
		ClosingTheInfoWindow();

		EscapeKeyHandlerForWindows(InfoWindow, settings["isInfoWindowVisible"]["value"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function CloseButtonInfosValidate(value)
	InfoWindowButtonValidate.MouseClick = function(sender, args)
		PlayerInformations = textBoxLines:GetText();
		SavePlayerInfos(value);
		InfoWindow:SetVisible(false);
		settings["isInfoWindowVisible"]["value"] = false;
		UpdateMainWindow();
		UpdateBar();
	end
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function CloseButtonInfosClear(value)
	InfoWindowButtonClear.MouseClick = function(sender, args)
		PlayerInformations = "";
		SavePlayerInfos(value);
		InfoWindow:SetVisible(false);
		settings["isInfoWindowVisible"]["value"] = false;
		UpdateMainWindow();
		UpdateBar();
	end
end

function CloseButtonInfos()
	InfoWindowButton.MouseClick = function(sender, args)
		InfoWindow:SetVisible(false);
		settings["isInfoWindowVisible"]["value"] = false;
	end
end