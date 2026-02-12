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

windowWidth = 800;
windowHeight = 720;
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateOptionsWindow()
		OptionsWindow=Turbine.UI.Lotro.GoldWindow(); 
		OptionsWindow:SetSize(windowWidth, windowHeight); 
		OptionsWindow:SetText(T[ "PluginOptionsText" ]); 

		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(150,10); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetText(T[ "PluginText" ]); 
		
		OptionsWindow:SetZOrder(0);
		OptionsWindow:SetWantsKeyEvents(true);

		OptionsWindow:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindow:GetHeight())/2);

		OptionsWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option center panel --
		------------------------------------------------------------------------------------------
		posx = 50;
		posy = 60;

		colorUsedFortexte = Turbine.UI.Color.Lime;
		colorUsedForLines = Turbine.UI.Color.Blue;

		TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption11" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 10;

		OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption1" ]); 

			posy = posy + 25;

			checkBoxKeep = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep:SetParent( OptionsWindow );
			checkBoxKeep:SetSize(250, 40); 
			checkBoxKeep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep:SetText(T[ "PluginOption2" ]);
			checkBoxKeep:SetPosition(posx + 50, posy);
			checkBoxKeep:SetVisible(true);
			if(settings["verbose"]["value"] == true)then
				checkBoxKeep:SetChecked(true);
			else
				checkBoxKeep:SetChecked(false);
			end
			checkBoxKeep:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 50;
			------------------------------------------------------------------------------------------
			-- spentcash
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption16" ], colorUsedFortexte, colorUsedForLines);

			posy = posy + 10;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption17" ]); 

			posy = posy + 25;

			checkBoxNormalIcon = Turbine.UI.Lotro.CheckBox();
			checkBoxNormalIcon:SetParent( OptionsWindow );
			checkBoxNormalIcon:SetSize(250, 40); 
			checkBoxNormalIcon:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxNormalIcon:SetText(T[ "PluginOption21" ]);
			checkBoxNormalIcon:SetPosition(posx + 50, posy);
			checkBoxNormalIcon:SetVisible(true);
			if(settings["iconSize"]["value"] == 64)then
				checkBoxNormalIcon:SetChecked(true);
			else
				checkBoxNormalIcon:SetChecked(false);
			end
			checkBoxNormalIcon:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxTinyIcon = Turbine.UI.Lotro.CheckBox();
			checkBoxTinyIcon:SetParent( OptionsWindow );
			checkBoxTinyIcon:SetSize(250, 40); 
			checkBoxTinyIcon:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxTinyIcon:SetText(T[ "PluginOption18" ]);
			checkBoxTinyIcon:SetPosition(posx + 50, posy);
			checkBoxTinyIcon:SetVisible(true);
			if(settings["iconSize"]["value"] == 32)then
				checkBoxTinyIcon:SetChecked(true);
			else
				checkBoxTinyIcon:SetChecked(false);
			end
			checkBoxTinyIcon:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxTinyIcon24 = Turbine.UI.Lotro.CheckBox();
			checkBoxTinyIcon24:SetParent( OptionsWindow );
			checkBoxTinyIcon24:SetSize(250, 40); 
			checkBoxTinyIcon24:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxTinyIcon24:SetText(T[ "PluginOption19" ]);
			checkBoxTinyIcon24:SetPosition(posx + 50, posy);
			checkBoxTinyIcon24:SetVisible(true);
			if(settings["iconSize"]["value"] == 24)then
				checkBoxTinyIcon24:SetChecked(true);
			else
				checkBoxTinyIcon24:SetChecked(false);
			end
			checkBoxTinyIcon24:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 25;

			checkBoxTinyIcon16 = Turbine.UI.Lotro.CheckBox();
			checkBoxTinyIcon16:SetParent( OptionsWindow );
			checkBoxTinyIcon16:SetSize(250, 40); 
			checkBoxTinyIcon16:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxTinyIcon16:SetText(T[ "PluginOption20" ]);
			checkBoxTinyIcon16:SetPosition(posx + 50, posy);
			checkBoxTinyIcon16:SetVisible(true);
			if(settings["iconSize"]["value"] == 16)then
				checkBoxTinyIcon16:SetChecked(true);
			else
				checkBoxTinyIcon16:SetChecked(false);
			end
			checkBoxTinyIcon16:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 50;

			function checkBoxNormalIcon:CheckedChanged()
				if(checkBoxNormalIcon:IsChecked(true))then
					checkBoxTinyIcon24:SetChecked(false);
					checkBoxTinyIcon16:SetChecked(false);
					checkBoxTinyIcon:SetChecked(false);
				end
			end

			function checkBoxTinyIcon:CheckedChanged()
				if(checkBoxTinyIcon:IsChecked(true))then
					checkBoxTinyIcon24:SetChecked(false);
					checkBoxTinyIcon16:SetChecked(false);
					checkBoxNormalIcon:SetChecked(false);
				end
			end

			function checkBoxTinyIcon24:CheckedChanged()
				if(checkBoxTinyIcon24:IsChecked(true))then
					checkBoxTinyIcon:SetChecked(false);
					checkBoxTinyIcon16:SetChecked(false);
					checkBoxNormalIcon:SetChecked(false);
				end
			end

			function checkBoxTinyIcon16:CheckedChanged()
				if(checkBoxTinyIcon16:IsChecked(true))then
					checkBoxTinyIcon24:SetChecked(false);
					checkBoxTinyIcon:SetChecked(false);
					checkBoxNormalIcon:SetChecked(false);
				end
			end

			------------------------------------------------------------------------------------------
			-- spentcash
			------------------------------------------------------------------------------------------

		TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption12" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption3" ]); 

			posy = posy + 25;

			checkBoxSpent = Turbine.UI.Lotro.CheckBox();
			checkBoxSpent:SetParent( OptionsWindow );
			checkBoxSpent:SetSize(250, 40); 
			checkBoxSpent:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxSpent:SetText(T[ "PluginOption4" ]);
			checkBoxSpent:SetPosition(posx + 100, posy);
			checkBoxSpent:SetVisible(true);
			if(settings["displaySpentCash"]["value"] == true)then
				checkBoxSpent:SetChecked(true);
			else
				checkBoxSpent:SetChecked(false);
			end
			checkBoxSpent:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 30;
			------------------------------------------------------------------------------------------
			-- total cash
			------------------------------------------------------------------------------------------
			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption8" ]); 

			posy = posy + 25;

			checkBoxCashTotal = Turbine.UI.Lotro.CheckBox();
			checkBoxCashTotal:SetParent( OptionsWindow );
			checkBoxCashTotal:SetSize(250, 40); 
			checkBoxCashTotal:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxCashTotal:SetText(T[ "PluginOption4" ]);
			checkBoxCashTotal:SetPosition(posx + 100, posy);
			checkBoxCashTotal:SetVisible(true);
			if(settings["displayTotalCash"]["value"] == true)then
				checkBoxCashTotal:SetChecked(true);
			else
				checkBoxCashTotal:SetChecked(false);
			end
			checkBoxCashTotal:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 50;

			------------------------------------------------------------------------------------------
			-- class bags
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption13" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption5" ]); 

			posy = posy + 25;

			checkBoxClassBag = Turbine.UI.Lotro.CheckBox();
			checkBoxClassBag:SetParent( OptionsWindow );
			checkBoxClassBag:SetSize(250, 40); 
			checkBoxClassBag:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxClassBag:SetText(T[ "PluginOption4" ]);
			checkBoxClassBag:SetPosition(posx + 100, posy );
			checkBoxClassBag:SetVisible(true);
			if(settings["displayClassBags"]["value"] == true)then
				checkBoxClassBag:SetChecked(true);
			else
				checkBoxClassBag:SetChecked(false);
			end
			checkBoxClassBag:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 50;

			------------------------------------------------------------------------------------------
			-- display the bar
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption25" ], colorUsedFortexte, colorUsedForLines);

			posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption26" ]); 

			posy = posy + 25;

			checkBoxDisplayBar = Turbine.UI.Lotro.CheckBox();
			checkBoxDisplayBar:SetParent( OptionsWindow );
			checkBoxDisplayBar:SetSize(250, 40); 
			checkBoxDisplayBar:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxDisplayBar:SetText(T[ "PluginOption4" ]);
			checkBoxDisplayBar:SetPosition(posx + 100, posy );
			checkBoxDisplayBar:SetVisible(true);
			if(settings["displayBarWindow"]["value"] == true)then
				checkBoxDisplayBar:SetChecked(true);
			else
				checkBoxDisplayBar:SetChecked(false);
			end
			checkBoxDisplayBar:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			--posy = posy + 50;
			-- new colonne from here
			posx = 450;
			posy = 60;

			------------------------------------------------------------------------------------------
			-- lvl max color
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption22" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption23" ]); 

			posy = posy + 25;

			checkBoxLvlMax = Turbine.UI.Lotro.CheckBox();
			checkBoxLvlMax:SetParent( OptionsWindow );
			checkBoxLvlMax:SetSize(250, 40); 
			checkBoxLvlMax:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxLvlMax:SetText(T[ "PluginOption4" ]);
			checkBoxLvlMax:SetPosition(posx + 100, posy );
			checkBoxLvlMax:SetVisible(true);
			if(settings["displayLvlMax"]["value"] == true)then
				checkBoxLvlMax:SetChecked(true);
			else
				checkBoxLvlMax:SetChecked(false);
			end
			checkBoxLvlMax:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 30;

			------------------------------------------------------------------------------------------
			-- display serverName
			------------------------------------------------------------------------------------------
			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption24" ]); 

			posy = posy + 25;

			checkBoxDisplayServeur = Turbine.UI.Lotro.CheckBox();
			checkBoxDisplayServeur:SetParent( OptionsWindow );
			checkBoxDisplayServeur:SetSize(250, 40); 
			checkBoxDisplayServeur:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxDisplayServeur:SetText(T[ "PluginOption4" ]);
			checkBoxDisplayServeur:SetPosition(posx + 100, posy );
			checkBoxDisplayServeur:SetVisible(true);
			if(settings["displayServers"]["value"] == true)then
				checkBoxDisplayServeur:SetChecked(true);
			else
				checkBoxDisplayServeur:SetChecked(false);
			end
			checkBoxDisplayServeur:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 50;

		------------------------------------------------------------------------------------------
		-- wich server to display
		------------------------------------------------------------------------------------------
		-- populate the drop down list with servers name
		ServerNames_2 = {};
		table.insert(ServerNames_2, T[ "ServerNamesAll" ]);
		for i=1, nbrServers do
			table.insert(ServerNames_2, ServerNames[i]);
		end

		for i in pairs(ServerNames_2) do
			if(ServerNames_2[i] == settings["serversToDisplay"]["value"])then
				currentServer = i;
			end
		end

		local serverDropDown = DropDown.Create(ServerNames_2, ServerNames_2[currentServer]);
		serverDropDown:SetParent(OptionsWindow);
		serverDropDown:SetPosition(posx + 100, posy);
	
		serverDropDown.ItemChanged = function()
			local name = serverDropDown:GetText();
			settings["serversToDisplay"]["value"] = tostring(name);
		end


		posy = posy + 50;

			------------------------------------------------------------------------------------------
			-- durability color
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption14" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 10;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption7" ]); 

			posy = posy + 25;

			checkBoxClassDUColor = Turbine.UI.Lotro.CheckBox();
			checkBoxClassDUColor:SetParent( OptionsWindow );
			checkBoxClassDUColor:SetSize(250, 40); 
			checkBoxClassDUColor:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxClassDUColor:SetText(T[ "PluginOption4" ]);
			checkBoxClassDUColor:SetPosition(posx + 100, posy + 10);
			checkBoxClassDUColor:SetVisible(true);
			if(settings["displayDurabilityColor"]["value"] == true)then
				checkBoxClassDUColor:SetChecked(true);
			else
				checkBoxClassDUColor:SetChecked(false);
			end
			checkBoxClassDUColor:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 60;
			------------------------------------------------------------------------------------------
			-- display reput points
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, T[ "PluginOption15" ], colorUsedFortexte, colorUsedForLines);

		posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption9" ]); 

			posy = posy + 25;

			checkBoxDisplayReput = Turbine.UI.Lotro.CheckBox();
			checkBoxDisplayReput:SetParent( OptionsWindow );
			checkBoxDisplayReput:SetSize(250, 40); 
			checkBoxDisplayReput:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxDisplayReput:SetText(T[ "PluginOption4" ]);
			checkBoxDisplayReput:SetPosition(posx + 100, posy );
			checkBoxDisplayReput:SetVisible(true);
			if(settings["showProgressReput"]["value"] == true)then
				checkBoxDisplayReput:SetChecked(true);
			else
				checkBoxDisplayReput:SetChecked(false);
			end
			checkBoxDisplayReput:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 30;

			------------------------------------------------------------------------------------------
			-- display lotro points
			------------------------------------------------------------------------------------------
			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(T[ "PluginOption10" ]); 

			posy = posy + 25;

			checkBoxDisplayLotro = Turbine.UI.Lotro.CheckBox();
			checkBoxDisplayLotro:SetParent( OptionsWindow );
			checkBoxDisplayLotro:SetSize(250, 40); 
			checkBoxDisplayLotro:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxDisplayLotro:SetText(T[ "PluginOption4" ]);
			checkBoxDisplayLotro:SetPosition(posx + 100, posy );
			checkBoxDisplayLotro:SetVisible(true);
			if(settings["showProgressLotro"]["value"] == true)then
				checkBoxDisplayLotro:SetChecked(true);
			else
				checkBoxDisplayLotro:SetChecked(false);
			end
			checkBoxDisplayLotro:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			posy = posy + 60;

			------------------------------------------------------------------------------------------
			-- display the delete icons
			------------------------------------------------------------------------------------------
			TitleDisplayer(OptionsWindow, posx, posy, "Display the delete icon", colorUsedFortexte, colorUsedForLines);

			posy = posy + 5;

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 40); 
			OptionsWindow.Message:SetPosition(posx, posy); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText("Display Icon"); 

			posy = posy + 25;

			checkBoxDisplayDelete = Turbine.UI.Lotro.CheckBox();
			checkBoxDisplayDelete:SetParent( OptionsWindow );
			checkBoxDisplayDelete:SetSize(250, 40); 
			checkBoxDisplayDelete:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxDisplayDelete:SetText(T[ "PluginOption4" ]);
			checkBoxDisplayDelete:SetPosition(posx + 100, posy );
			checkBoxDisplayDelete:SetVisible(true);
			if(settings["displayDeleteIcon"]["value"] == true)then
				checkBoxDisplayDelete:SetChecked(true);
			else
				checkBoxDisplayDelete:SetChecked(false);
			end
			checkBoxDisplayDelete:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));




			if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
				buttonDefineGendre = Turbine.UI.Lotro.GoldButton();
				buttonDefineGendre:SetParent( OptionsWindow );
				buttonDefineGendre:SetPosition(windowWidth/2 - 125,  windowHeight - 120);
				buttonDefineGendre:SetSize( 300, 20 );
				buttonDefineGendre:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				buttonDefineGendre:SetText( T[ "PluginOption6" ] );
				buttonDefineGendre:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
				buttonDefineGendre:SetVisible(true);
				buttonDefineGendre:SetMouseVisible(true);

				DisplayHelpButtonV2(OptionsWindow, windowWidth/2 + 170, windowHeight -120, 5, settings["isOptionsWindowVisible"]["isOptionsWindowVisible"]);

				buttonDefineVocation = Turbine.UI.Lotro.GoldButton();
				buttonDefineVocation:SetParent( OptionsWindow );
				buttonDefineVocation:SetPosition(windowWidth/2 - 125,  windowHeight - 90);
				buttonDefineVocation:SetSize( 300, 20 );
				buttonDefineVocation:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				buttonDefineVocation:SetText( T[ "PluginOption27" ] );
				buttonDefineVocation:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
				buttonDefineVocation:SetVisible(true);
				buttonDefineVocation:SetMouseVisible(true);

				DisplayHelpButtonV2(OptionsWindow, windowWidth/2 + 170,  windowHeight - 90, 6, settings["isOptionsWindowVisible"]["isOptionsWindowVisible"]);
			end

			buttonValider = Turbine.UI.Lotro.GoldButton();
			buttonValider:SetParent( OptionsWindow );
			buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
			buttonValider:SetSize( 300, 20 );
			buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			buttonValider:SetText( T[ "PluginOptionValidate" ] );
			buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			buttonValider:SetVisible(true);
			buttonValider:SetMouseVisible(true);


		ValidateChangesOptions();
		if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
			OpenChangesGendre();
			OpenChangesVocation();
		end
		ClosingTheWindowOptions();

		EscapeKeyHandlerForWindows(OptionsWindow, settings["isOptionsWindowVisible"]["isOptionsWindowVisible"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function ValidateChangesOptions()
	buttonValider.MouseClick = function(sender, args)
			if (checkBoxKeep:IsChecked()) then
				settings["verbose"]["value"] = true;
			else
				settings["verbose"]["value"] = false;
			end

			if (checkBoxNormalIcon:IsChecked()) then
				settings["iconSize"]["value"] = 64;
			end

			if (checkBoxTinyIcon:IsChecked()) then
				settings["iconSize"]["value"] = 32;
			end
			
			if (checkBoxTinyIcon24:IsChecked()) then
				settings["iconSize"]["value"] = 24;
			end

			if (checkBoxTinyIcon16:IsChecked()) then
				settings["iconSize"]["value"] = 16;
			end

			if (checkBoxSpent:IsChecked()) then
				settings["displaySpentCash"]["value"] = true;
			else
				settings["displaySpentCash"]["value"] = false;
			end

			if (checkBoxClassBag:IsChecked()) then
				settings["displayClassBags"]["value"] = true;
			else
				settings["displayClassBags"]["value"] = false;
			end

			if (checkBoxLvlMax:IsChecked()) then
				settings["displayLvlMax"]["value"] = true;
			else
				settings["displayLvlMax"]["value"] = false;
			end

			if (checkBoxClassDUColor:IsChecked()) then
				settings["displayDurabilityColor"]["value"] = true;
			else
				settings["displayDurabilityColor"]["value"] = false;
			end

			if (checkBoxDisplayReput:IsChecked()) then
				settings["showProgressReput"]["value"] = true;
			else
				settings["showProgressReput"]["value"] = false;
			end

			if (checkBoxDisplayLotro:IsChecked()) then
				settings["showProgressLotro"]["value"] = true;
			else
				settings["showProgressLotro"]["value"] = false;
			end

			if (checkBoxCashTotal:IsChecked()) then
				settings["displayTotalCash"]["value"] = true;
			else
				settings["displayTotalCash"]["value"] = false;
			end

			if (checkBoxDisplayServeur:IsChecked()) then
				settings["displayServers"]["value"] = true;
			else
				settings["displayServers"]["value"] = false;
				settings["serversToDisplay"]["value"] = T[ "ServerNamesAll" ];
			end

			if (checkBoxDisplayDelete:IsChecked()) then
				settings["displayDeleteIcon"]["value"] = true;
			else
				settings["displayDeleteIcon"]["value"] = false;
			end

			if (checkBoxDisplayBar:IsChecked()) then
				settings["displayBarWindow"]["value"] = true;
				settings["wasAltHolicBarVisible"]["value"] = true;
			else
				settings["displayBarWindow"]["value"] = false;
				settings["wasAltHolicBarVisible"]["value"] = false;
			end

			if(settings["verbose"]["value"] == true)then
				Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionNotificationsActivated" ]);
				if(settings["displaySpentCash"]["value"] == true)then
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionSpentCashActivated" ]);
				else
					Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionSpentCashDeactivated" ]);
				end
			else
				Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginOptionNotificationsDeactivated" ]);
			end

			OptionsWindow:SetVisible(false);
			settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
			SavePlayerDatas();
			UpdateMainWindow();
			UpdateMinimizedIcon();
			settings["isWindowVisible"]["isWindowVisible"] = true;
			AltHolicWindow:SetVisible(true);
			if(settings["displayBarWindow"]["value"] == true)then
				AltHolicBar:SetVisible(true);
			else
				AltHolicBar:SetVisible(false);
			end
		end
end

function OpenChangesGendre()
	buttonDefineGendre.MouseClick = function(sender, args)
		GenerateGendreWindow();
		GendreWindow:SetVisible(true);
		settings["isGendreWindowVisible"]["value"] = true;
	end
end

function OpenChangesVocation()
	buttonDefineVocation.MouseClick = function(sender, args)
		GenerateOptionsWindowVocation();
		OptionsWindowVoc:SetVisible(true);
		settings["OptionsWindowVoc"]["value"] = true;
	end
end