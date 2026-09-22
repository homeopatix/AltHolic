------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 800;
local windowHeight = 720;

-- Controls used by the validation handler are module-local rather than globals.
local checkBoxKeep, checkBoxNormalIcon, checkBoxTinyIcon, checkBoxTinyIcon24, checkBoxTinyIcon16;
local checkBoxSpent, checkBoxCashTotal, checkBoxClassBag, checkBoxDisplayBar;
local checkBoxLvlMax, checkBoxDisplayServeur, checkBoxClassDUColor;
local checkBoxDisplayReput, checkBoxDisplayLotro, checkBoxDisplayDelete;
local buttonValider;

local function CreateOptionCheckBox(parent, text, x, y, checked)
	local box = Turbine.UI.Lotro.CheckBox();
	box:SetParent(parent);
	box:SetSize(250, 40);
	box:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	box:SetText(text);
	box:SetPosition(x, y);
	box:SetVisible(true);
	box:SetChecked(checked == true);
	box:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
	return box;
end

local function MakeExclusive(group)
	for _, selected in ipairs(group) do
		selected.CheckedChanged = function(sender)
			if not sender:IsChecked() then return; end
			for _, other in ipairs(group) do
				if other ~= sender then other:SetChecked(false); end
			end
		end
	end
end
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
		local posx = 50;
		local posy = 60;

		local colorUsedFortexte = Turbine.UI.Color.Lime;
		local colorUsedForLines = Turbine.UI.Color.Blue;

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

			checkBoxKeep = CreateOptionCheckBox(OptionsWindow, T["PluginOption2"], posx + 50, posy, settings["verbose"]["value"]);

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

			local iconOptions = {
				{ size = 64, text = T["PluginOption21"] },
				{ size = 32, text = T["PluginOption18"] },
				{ size = 24, text = T["PluginOption19"] },
				{ size = 16, text = T["PluginOption20"] },
			};
			local iconBoxes = {};
			for _, option in ipairs(iconOptions) do
				local box = CreateOptionCheckBox(OptionsWindow, option.text, posx + 50, posy, settings["iconSize"]["value"] == option.size);
				iconBoxes[#iconBoxes + 1] = box;
				if option.size == 64 then checkBoxNormalIcon = box;
				elseif option.size == 32 then checkBoxTinyIcon = box;
				elseif option.size == 24 then checkBoxTinyIcon24 = box;
				else checkBoxTinyIcon16 = box; end
				posy = posy + 25;
			end
			MakeExclusive(iconBoxes);
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

			checkBoxSpent = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displaySpentCash"]["value"]);

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

			checkBoxCashTotal = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayTotalCash"]["value"]);

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

			checkBoxClassBag = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayClassBags"]["value"]);

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

			checkBoxDisplayBar = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayBarWindow"]["value"]);

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

			checkBoxLvlMax = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayLvlMax"]["value"]);

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

			checkBoxDisplayServeur = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayServers"]["value"]);

			posy = posy + 50;

		------------------------------------------------------------------------------------------
		-- wich server to display
		------------------------------------------------------------------------------------------
		-- populate the drop down list with servers name
		local ServerNames_2 = {};
		table.insert(ServerNames_2, T[ "ServerNamesAll" ]);
		for i=1, nbrServers do
			table.insert(ServerNames_2, ServerNames[i]);
		end

		local currentServer = 1;
		for i in pairs(ServerNames_2) do
			if ServerNames_2[i] == settings["serversToDisplay"]["value"] then
				currentServer = i;
				break;
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

			checkBoxClassDUColor = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy + 10, settings["displayDurabilityColor"]["value"]);

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

			checkBoxDisplayReput = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["showProgressReput"]["value"]);

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

			checkBoxDisplayLotro = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["showProgressLotro"]["value"]);

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

			checkBoxDisplayDelete = CreateOptionCheckBox(OptionsWindow, T["PluginOption4"], posx + 100, posy, settings["displayDeleteIcon"]["value"]);




			if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
				buttonDefineGender = Turbine.UI.Lotro.GoldButton();
				buttonDefineGender:SetParent( OptionsWindow );
				buttonDefineGender:SetPosition(windowWidth/2 - 125,  windowHeight - 120);
				buttonDefineGender:SetSize( 300, 20 );
				buttonDefineGender:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				buttonDefineGender:SetText( T[ "PluginOption6" ] );
				buttonDefineGender:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
				buttonDefineGender:SetVisible(true);
				buttonDefineGender:SetMouseVisible(true);

				DisplayHelpButtonV2(OptionsWindow, windowWidth/2 + 170, windowHeight -120, 5);
				-- Manual vocation selector/help removed: AltHolic now tracks individual professions directly.
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
			OpenChangesGender();
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

function OpenChangesGender()
	if buttonDefineGender == nil then return; end
	buttonDefineGender.MouseClick = function(sender, args)
		GenerateGenderWindow();
		GenderWindow:SetVisible(true);
		settings["isGenderWindowVisible"]["value"] = true;
	end
end
