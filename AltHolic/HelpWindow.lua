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

if(playerAlignement == 1)then
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		windowWidth = 400;
		windowHeight = 780;
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		windowWidth = 400;
		windowHeight = 740;
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		windowWidth = 400;
		windowHeight = 670;
	end
else
	windowWidth = 400;
	windowHeight = 500;
end

if(Turbine.UI.Display:GetHeight() < windowHeight)then
	windowHeight = Turbine.UI.Display:GetHeight() - 150;
end
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateHelpWindow(value)
		HelpWindow=Turbine.UI.Lotro.GoldWindow(); 
		HelpWindow:SetSize(windowWidth, windowHeight); 
		if(value == 1)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow" ]); 
		elseif(value == 2)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow2" ]); 
		elseif(value == 3)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow3" ]); 
		elseif(value == 4)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow4" ]); 
		elseif(value == 5)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow5" ]);
		elseif(value == 6)then
			HelpWindow:SetText(T[ "PluginTitreHelpWindow6" ]);
		end
		HelpWindow:SetPosition(((Turbine.UI.Display:GetWidth()-HelpWindow:GetWidth())/2) + 410,((Turbine.UI.Display:GetHeight()-HelpWindow:GetHeight())/2) - 200);

		HelpWindow.Message=Turbine.UI.Label(); 
		HelpWindow.Message:SetParent(HelpWindow); 
		HelpWindow.Message:SetSize(150,10); 
		HelpWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		HelpWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		HelpWindow.Message:SetText(T[ "PluginText" ]); 

		HelpWindow:SetZOrder(1000);
		HelpWindow:SetWantsKeyEvents(true);
		HelpWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- center window
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- -- personal house location --
		------------------------------------------------------------------------------------------

			HelpWindow.Message=Turbine.UI.Label(); 
			HelpWindow.Message:SetParent(HelpWindow); 
			HelpWindow.Message:SetSize(370, 700); 
			if(value == 1)then
				HelpWindow.Message:SetPosition(15, 20 ); 
			elseif(value == 2)then
				HelpWindow.Message:SetPosition(15, 60 );
			elseif(value == 3)then
				HelpWindow.Message:SetPosition(25, 60 );
			elseif(value == 4)then
				HelpWindow.Message:SetPosition(35, 100 );
			elseif(value == 5)then
				HelpWindow.Message:SetPosition(35, 140 );
			elseif(value == 6)then
				HelpWindow.Message:SetPosition(35, 100 );
			end
			HelpWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft); 
			HelpWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			if(value == 1)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow1" ] ..
										T[ "PluginHelpWindow2" ] ..
										T[ "PluginHelpWindow3" ] ..
										T[ "PluginHelpWindow4" ] ..
										T[ "PluginHelpWindow5" ] ..
										T[ "PluginHelpWindow6" ] ..
										T[ "PluginHelpWindow7" ] ..
										T[ "PluginHelpWindow8" ] ..
										T[ "PluginHelpWindow9" ]
										);
			elseif(value == 2)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow10" ] ..
										T[ "PluginHelpWindow11" ] ..
										T[ "PluginHelpWindow12" ] ..
										T[ "PluginHelpWindow13" ] ..
										T[ "PluginHelpWindow14" ]
										);
			elseif(value == 3)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow15" ] ..
										T[ "PluginHelpWindow16" ] ..
										T[ "PluginHelpWindow17" ] ..
										T[ "PluginHelpWindow18" ] ..
										T[ "PluginHelpWindow19" ] ..
										T[ "PluginHelpWindow20" ] ..
										T[ "PluginHelpWindow21" ]
										);
			elseif(value == 4)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow22" ] ..
										T[ "PluginHelpWindow23" ] ..
										T[ "PluginHelpWindow24" ] ..
										T[ "PluginHelpWindow25" ] 
										);
			elseif(value == 5)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow26" ] ..
										T[ "PluginHelpWindow27" ] ..
										T[ "PluginHelpWindow28" ] ..
										T[ "PluginHelpWindow29" ] 
										);
			elseif(value == 6)then
				HelpWindow.Message:SetText( T[ "PluginHelpWindow30" ] ..
										T[ "PluginHelpWindow31" ] ..
										T[ "PluginHelpWindow32" ] ..
										T[ "PluginHelpWindow33" ] ..
										T[ "PluginHelpWindow34" ] ..
										T[ "PluginHelpWindow35" ] ..
										T[ "PluginHelpWindow36" ] 
										);
			end
			 
			HelpWindowButton = Turbine.UI.Lotro.GoldButton();
			HelpWindowButton:SetParent( HelpWindow );
			HelpWindowButton:SetPosition(windowWidth/2 - 125, windowHeight - 40);
			HelpWindowButton:SetSize( 300, 20 );
			HelpWindowButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			HelpWindowButton:SetText( T[ "PluginButtonHelpWindow" ] );
			HelpWindowButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			HelpWindowButton:SetVisible(true);
			HelpWindowButton:SetMouseVisible(true);

			CloseButtonHelp();
			ClosingTheHelpWindow();

	EscapeKeyHandlerForWindows(HelpWindow, settings["isHelpWindowVisible"]["value"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function CloseButtonHelp()
	HelpWindowButton.MouseClick = function(sender, args)
		HelpWindow:SetVisible(false);
		settings["isHelpWindowVisible"]["value"] = false;
	end
end

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheHelpWindow()
	function HelpWindow:Closing(sender, args)
		HelpWindow:SetVisible(false);
		settings["isHelpWindowVisible"]["value"] = false;
	end
end