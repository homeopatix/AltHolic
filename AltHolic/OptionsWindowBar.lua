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
windowHeight = 680;
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateOptionsWindowBar()
		OptionsWindowBar=Turbine.UI.Lotro.GoldWindow(); 
		OptionsWindowBar:SetSize(windowWidth, windowHeight); 
		OptionsWindowBar:SetText(T[ "PluginOptionsBarText" ]); 

		OptionsWindowBar.Message=Turbine.UI.Label(); 
		OptionsWindowBar.Message:SetParent(OptionsWindowBar); 
		OptionsWindowBar.Message:SetSize(150,10); 
		OptionsWindowBar.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		OptionsWindowBar.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindowBar.Message:SetText(T[ "PluginText" ]); 
		
		OptionsWindowBar:SetZOrder(0);
		OptionsWindowBar:SetWantsKeyEvents(true);

		OptionsWindowBar:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindowBar:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindowBar:GetHeight())/2);

		OptionsWindowBar:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option center panel --
		------------------------------------------------------------------------------------------
		posx = 50;
		posy = 60;

		colorUsedFortexte = Turbine.UI.Color.Lime;
		colorUsedForLines = Turbine.UI.Color.Blue;

		TitleDisplayer(OptionsWindowBar, posx, posy, T[ "PluginOptionBar1" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 5;

		OptionsWindowBar.Message=Turbine.UI.Label(); 
			OptionsWindowBar.Message:SetParent(OptionsWindowBar); 
			OptionsWindowBar.Message:SetSize(300, 40); 
			OptionsWindowBar.Message:SetPosition(posx, posy ); 
			OptionsWindowBar.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindowBar.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindowBar.Message:SetText(T[ "PluginOptionBar0" ]); 

			posy = posy + 25;

			checkBoxKeep2 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep2:SetParent( OptionsWindowBar );
			checkBoxKeep2:SetSize(300, 40); 
			checkBoxKeep2:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep2:SetText(T[ "PluginOptionBar2" ]);
			checkBoxKeep2:SetPosition(posx + 50, posy);
			checkBoxKeep2:SetVisible(true);
			if(settings["displayBarIcon2"]["value"] == true)then
				checkBoxKeep2:SetChecked(true);
			else
				checkBoxKeep2:SetChecked(false);
			end
			checkBoxKeep2:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep21 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep21:SetParent( OptionsWindowBar );
			checkBoxKeep21:SetSize(300, 40); 
			checkBoxKeep21:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep21:SetText(T[ "PluginOptionBar16" ]);
			checkBoxKeep21:SetPosition(posx + 50, posy);
			checkBoxKeep21:SetVisible(true);
			if(settings["displayBarIcon16"]["value"] == true)then
				checkBoxKeep21:SetChecked(true);
			else
				checkBoxKeep21:SetChecked(false);
			end
			checkBoxKeep21:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep3 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep3:SetParent( OptionsWindowBar );
			checkBoxKeep3:SetSize(300, 40); 
			checkBoxKeep3:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep3:SetText(T[ "PluginOptionBar3" ]);
			checkBoxKeep3:SetPosition(posx + 50, posy);
			checkBoxKeep3:SetVisible(true);
			if(settings["displayBarIcon3"]["value"] == true)then
				checkBoxKeep3:SetChecked(true);
			else
				checkBoxKeep3:SetChecked(false);
			end
			checkBoxKeep3:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep4 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep4:SetParent( OptionsWindowBar );
			checkBoxKeep4:SetSize(300, 40); 
			checkBoxKeep4:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep4:SetText(T[ "PluginOptionBar4" ]);
			checkBoxKeep4:SetPosition(posx + 50, posy);
			checkBoxKeep4:SetVisible(true);
			if(settings["displayBarIcon4"]["value"] == true)then
				checkBoxKeep4:SetChecked(true);
			else
				checkBoxKeep4:SetChecked(false);
			end
			checkBoxKeep4:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep5 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep5:SetParent( OptionsWindowBar );
			checkBoxKeep5:SetSize(300, 40); 
			checkBoxKeep5:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep5:SetText(T[ "PluginOptionBar5" ]);
			checkBoxKeep5:SetPosition(posx + 50, posy);
			checkBoxKeep5:SetVisible(true);
			if(settings["displayBarIcon5"]["value"] == true)then
				checkBoxKeep5:SetChecked(true);
			else
				checkBoxKeep5:SetChecked(false);
			end
			checkBoxKeep5:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep6 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep6:SetParent( OptionsWindowBar );
			checkBoxKeep6:SetSize(300, 40); 
			checkBoxKeep6:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep6:SetText(T[ "PluginOptionBar6" ]);
			checkBoxKeep6:SetPosition(posx + 50, posy);
			checkBoxKeep6:SetVisible(true);
			if(settings["displayBarIcon6"]["value"] == true)then
				checkBoxKeep6:SetChecked(true);
			else
				checkBoxKeep6:SetChecked(false);
			end
			checkBoxKeep6:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep7 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep7:SetParent( OptionsWindowBar );
			checkBoxKeep7:SetSize(300, 40); 
			checkBoxKeep7:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep7:SetText(T[ "PluginOptionBar7" ]);
			checkBoxKeep7:SetPosition(posx + 50, posy);
			checkBoxKeep7:SetVisible(true);
			if(settings["displayBarIcon7"]["value"] == true)then
				checkBoxKeep7:SetChecked(true);
			else
				checkBoxKeep7:SetChecked(false);
			end
			checkBoxKeep7:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep8 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep8:SetParent( OptionsWindowBar );
			checkBoxKeep8:SetSize(300, 40); 
			checkBoxKeep8:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep8:SetText(T[ "PluginOptionBar8" ]);
			checkBoxKeep8:SetPosition(posx + 50, posy);
			checkBoxKeep8:SetVisible(true);
			if(settings["displayBarIcon8"]["value"] == true)then
				checkBoxKeep8:SetChecked(true);
			else
				checkBoxKeep8:SetChecked(false);
			end
			checkBoxKeep8:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep9 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep9:SetParent( OptionsWindowBar );
			checkBoxKeep9:SetSize(300, 40); 
			checkBoxKeep9:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep9:SetText(T[ "PluginOptionBar9" ]);
			checkBoxKeep9:SetPosition(posx + 50, posy);
			checkBoxKeep9:SetVisible(true);
			if(settings["displayBarIcon9"]["value"] == true)then
				checkBoxKeep9:SetChecked(true);
			else
				checkBoxKeep9:SetChecked(false);
			end
			checkBoxKeep9:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep10 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep10:SetParent( OptionsWindowBar );
			checkBoxKeep10:SetSize(300, 40); 
			checkBoxKeep10:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep10:SetText(T[ "PluginOptionBar10" ]);
			checkBoxKeep10:SetPosition(posx + 50, posy);
			checkBoxKeep10:SetVisible(true);
			if(settings["displayBarIcon10"]["value"] == true)then
				checkBoxKeep10:SetChecked(true);
			else
				checkBoxKeep10:SetChecked(false);
			end
			checkBoxKeep10:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep11 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep11:SetParent( OptionsWindowBar );
			checkBoxKeep11:SetSize(300, 40); 
			checkBoxKeep11:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep11:SetText(T[ "PluginOptionBar11" ]);
			checkBoxKeep11:SetPosition(posx + 50, posy);
			checkBoxKeep11:SetVisible(true);
			if(settings["displayBarIcon11"]["value"] == true)then
				checkBoxKeep11:SetChecked(true);
			else
				checkBoxKeep11:SetChecked(false);
			end
			checkBoxKeep11:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep12 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep12:SetParent( OptionsWindowBar );
			checkBoxKeep12:SetSize(300, 40); 
			checkBoxKeep12:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep12:SetText(T[ "PluginOptionBar12" ]);
			checkBoxKeep12:SetPosition(posx + 50, posy);
			checkBoxKeep12:SetVisible(true);
			if(settings["displayBarIcon12"]["value"] == true)then
				checkBoxKeep12:SetChecked(true);
			else
				checkBoxKeep12:SetChecked(false);
			end
			checkBoxKeep12:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep13 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep13:SetParent( OptionsWindowBar );
			checkBoxKeep13:SetSize(300, 40); 
			checkBoxKeep13:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep13:SetText(T[ "PluginOptionBar13" ]);
			checkBoxKeep13:SetPosition(posx + 50, posy);
			checkBoxKeep13:SetVisible(true);
			if(settings["displayBarIcon13"]["value"] == true)then
				checkBoxKeep13:SetChecked(true);
			else
				checkBoxKeep13:SetChecked(false);
			end
			checkBoxKeep13:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep14 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep14:SetParent( OptionsWindowBar );
			checkBoxKeep14:SetSize(300, 40); 
			checkBoxKeep14:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep14:SetText(T[ "PluginOptionBar14" ]);
			checkBoxKeep14:SetPosition(posx + 50, posy);
			checkBoxKeep14:SetVisible(true);
			if(settings["displayBarIcon14"]["value"] == true)then
				checkBoxKeep14:SetChecked(true);
			else
				checkBoxKeep14:SetChecked(false);
			end
			checkBoxKeep14:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeep15 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep15:SetParent( OptionsWindowBar );
			checkBoxKeep15:SetSize(300, 40); 
			checkBoxKeep15:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep15:SetText(T[ "PluginOptionBar15" ]);
			checkBoxKeep15:SetPosition(posx + 50, posy);
			checkBoxKeep15:SetVisible(true);
			if(settings["displayBarIcon15"]["value"] == true)then
				checkBoxKeep15:SetChecked(true);
			else
				checkBoxKeep15:SetChecked(false);
			end
			checkBoxKeep15:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxKeepTokens = Turbine.UI.Lotro.CheckBox();
			checkBoxKeepTokens:SetParent( OptionsWindowBar );
			checkBoxKeepTokens:SetSize(300, 40); 
			checkBoxKeepTokens:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeepTokens:SetText(T[ "PluginOptionBarTokens" ]);
			checkBoxKeepTokens:SetPosition(posx + 50, posy);
			checkBoxKeepTokens:SetVisible(true);
			if(settings["displayTokensIcon"]["value"] == true)then
				checkBoxKeepTokens:SetChecked(true);
			else
				checkBoxKeepTokens:SetChecked(false);
			end
			checkBoxKeepTokens:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 65;
			

			--------------- T[ "PluginOptionBar1" ]
			TitleDisplayer(OptionsWindowBar, posx, posy, T[ "PluginOptionBar20" ], colorUsedFortexte, colorUsedForLines);

			posy = posy + 5;

			checkBoxKeep20 = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep20:SetParent( OptionsWindowBar );
			checkBoxKeep20:SetSize(300, 40); 
			checkBoxKeep20:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep20:SetText(T[ "PluginOptionBar21" ]);
			checkBoxKeep20:SetPosition(posx + 50, posy);
			checkBoxKeep20:SetVisible(true);

			if(settings["displayBarBagSize"]["value"] == true)then
				checkBoxKeep20:SetChecked(true);
			else
				checkBoxKeep20:SetChecked(false);
			end
			checkBoxKeep20:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;


			buttonValider = Turbine.UI.Lotro.GoldButton();
			buttonValider:SetParent( OptionsWindowBar );
			buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
			buttonValider:SetSize( 300, 20 );
			buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			buttonValider:SetText( T[ "PluginOptionValidate" ] );
			buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			buttonValider:SetVisible(true);
			buttonValider:SetMouseVisible(true);


		ValidateChangesOptionsBar();
		ClosingTheWindowOptionsBar();

		EscapeKeyHandlerForWindows(OptionsWindowBar, settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function ValidateChangesOptionsBar()
	buttonValider.MouseClick = function(sender, args)
			if (checkBoxKeep2:IsChecked()) then
				settings["displayBarIcon2"]["value"] = true;
			else
				settings["displayBarIcon2"]["value"] = false;
			end

			if (checkBoxKeep21:IsChecked()) then
				settings["displayBarIcon16"]["value"] = true;
			else
				settings["displayBarIcon16"]["value"] = false;
			end

			if (checkBoxKeep3:IsChecked()) then
				settings["displayBarIcon3"]["value"] = true;
			else
				settings["displayBarIcon3"]["value"] = false;
			end

			if (checkBoxKeep4:IsChecked()) then
				settings["displayBarIcon4"]["value"] = true;
			else
				settings["displayBarIcon4"]["value"] = false;
			end

			if (checkBoxKeep5:IsChecked()) then
				settings["displayBarIcon5"]["value"] = true;
			else
				settings["displayBarIcon5"]["value"] = false;
			end

			if (checkBoxKeep6:IsChecked()) then
				settings["displayBarIcon6"]["value"] = true;
			else
				settings["displayBarIcon6"]["value"] = false;
			end

			if (checkBoxKeep7:IsChecked()) then
				settings["displayBarIcon7"]["value"] = true;
			else
				settings["displayBarIcon7"]["value"] = false;
			end

			if (checkBoxKeep8:IsChecked()) then
				settings["displayBarIcon8"]["value"] = true;
			else
				settings["displayBarIcon8"]["value"] = false;
			end

			if (checkBoxKeep9:IsChecked()) then
				settings["displayBarIcon9"]["value"] = true;
			else
				settings["displayBarIcon9"]["value"] = false;
			end

			if (checkBoxKeep10:IsChecked()) then
				settings["displayBarIcon10"]["value"] = true;
			else
				settings["displayBarIcon10"]["value"] = false;
			end

			if (checkBoxKeep11:IsChecked()) then
				settings["displayBarIcon11"]["value"] = true;
			else
				settings["displayBarIcon11"]["value"] = false;
			end

			if (checkBoxKeep12:IsChecked()) then
				settings["displayBarIcon12"]["value"] = true;
			else
				settings["displayBarIcon12"]["value"] = false;
			end

			if (checkBoxKeep13:IsChecked()) then
				settings["displayBarIcon13"]["value"] = true;
			else
				settings["displayBarIcon13"]["value"] = false;
			end

			if (checkBoxKeep14:IsChecked()) then
				settings["displayBarIcon14"]["value"] = true;
			else
				settings["displayBarIcon14"]["value"] = false;
			end

			if (checkBoxKeep15:IsChecked()) then
				settings["displayBarIcon15"]["value"] = true;
			else
				settings["displayBarIcon15"]["value"] = false;
			end

			if (checkBoxKeepTokens:IsChecked()) then
				settings["displayTokensIcon"]["value"] = true;
			else
				settings["displayTokensIcon"]["value"] = false;
			end

			if (checkBoxKeep20:IsChecked()) then
				settings["displayBarBagSize"]["value"] = true;
			else
				settings["displayBarBagSize"]["value"] = false;
			end

			OptionsWindowBar:SetVisible(false);
			settings["isOptionsWindowBarVisible"]["isOptionsWindowBarVisible"] = false;
			if(settings["displayBarWindow"]["value"] == true)then
				AltHolicBar:SetVisible(true);
			end

			SaveSettings();
			UpdateBar();
		end
end
