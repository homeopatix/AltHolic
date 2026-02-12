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
windowHeight = 800;

checkBoxMale = {};
checkBoxFemale = {};
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateGendreWindow()
		local nbrPlayerCanChangeSexe = 0;

		for i in pairs(PlayerDatas) do 
			if(PlayerDatas[i].rac == 81 or
				PlayerDatas[i].rac == 23 or
				PlayerDatas[i].rac == 65 or 
				PlayerDatas[i].rac == 114 or
				PlayerDatas[i].rac == 120 or 
				PlayerDatas[i].rac == 73 or
				PlayerDatas[i].rac == 117 or
				PlayerDatas[i].rac == 125)then
			nbrPlayerCanChangeSexe = nbrPlayerCanChangeSexe + 1;
			end
		end

		if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
			windowHeight = 200 + (nbrPlayerCanChangeSexe * 32);
		else
			windowHeight = 200;
		end

		if(Turbine.UI.Display:GetHeight() < windowHeight)then
			windowHeight = Turbine.UI.Display:GetHeight() - 150;
		end
		
		GendreWindow=Turbine.UI.Lotro.GoldWindow(); 
		GendreWindow:SetSize(windowWidth, windowHeight); 
		GendreWindow:SetText(T[ "PluginGendreText" ]); 

		GendreWindow.Message=Turbine.UI.Label(); 
		GendreWindow.Message:SetParent(GendreWindow); 
		GendreWindow.Message:SetSize(150,10); 
		GendreWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		GendreWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		GendreWindow.Message:SetText(T[ "PluginText" ]); 

		GendreWindow.Message=Turbine.UI.Label(); 
		GendreWindow.Message:SetParent(GendreWindow); 
		GendreWindow.Message:SetSize(150,20); 
		GendreWindow.Message:SetPosition(125, 55 ); 
		GendreWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		GendreWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
		GendreWindow.Message:SetText(T[ "PluginGendreText1" ]); 

		GendreWindow.Message=Turbine.UI.Label(); 
		GendreWindow.Message:SetParent(GendreWindow); 
		GendreWindow.Message:SetSize(150,20); 
		GendreWindow.Message:SetPosition(230, 55 ); 
		GendreWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		GendreWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
		GendreWindow.Message:SetText(T[ "PluginGendreText2" ]); 

		GendreWindow:SetZOrder(100);
		GendreWindow:SetWantsKeyEvents(true);
		GendreWindow:SetWantsUpdates(true);

		GendreWindow:SetPosition((Turbine.UI.Display:GetWidth()-GendreWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-GendreWindow:GetHeight())/2);

		GendreWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option panel --
		------------------------------------------------------------------------------------------
		-- sort player name by alphabetical order
		a = {};
		local count = 0;
		for i in pairs(PlayerDatas) do 
			table.insert(a, i);
			count = count + 1;
		end
		table.sort(a);

		posx = 5;
		posy = 20;

		listbox = Turbine.UI.ListBox();
		listbox:SetParent( GendreWindow );
		--listbox:SetBackColor( Turbine.UI.Color.Red );
		listbox:SetSize(windowWidth - 45, windowHeight - 140);
		listbox:SetPosition(20, 70);
		listbox:IsMouseVisible(true);
		listbox:SetZOrder(20);


		for n, i in ipairs(a) do 
			if(PlayerDatas[i].rac == 81 or
				PlayerDatas[i].rac == 23 or
				PlayerDatas[i].rac == 65 or 
				PlayerDatas[i].rac == 114 or
				PlayerDatas[i].rac == 120 or 
				PlayerDatas[i].rac == 73 or
				PlayerDatas[i].rac == 117 or
				PlayerDatas[i].rac == 125)then

				listItem = Turbine.UI.Control();
				listItem:SetSize( windowWidth - 45, 50 );
				listItem:SetMouseVisible(true);


					GendreWindow.Message=Turbine.UI.Label(); 
					GendreWindow.Message:SetParent(listItem); 
					GendreWindow.Message:SetSize(120, 30); 
					GendreWindow.Message:SetPosition(posx, posy); 
					GendreWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
					GendreWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
					GendreWindow.Message:SetText(i); 

				---define race male
				buttonDefineHouseLocationPersonal = Turbine.UI.Extensions.SimpleWindow();
				buttonDefineHouseLocationPersonal:SetParent( listItem );
				buttonDefineHouseLocationPersonal:SetPosition(posx + 155, posy);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(listItem);
				centerLabelB5:SetPosition(posx + 155, posy );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);
				centerLabelB5:SetBlendMode(Turbine.UI.BlendMode.Overlay);

				if(settings["nameAccount"]["account1"]["name"] ~= "")then
						--centerLabelB:SetBackground(ResourcePath .. tostring(PlayerDatas[i].cla));
						if(PlayerDatas[i].rac == 81)then
							centerLabelB5:SetBackground(0x4110894A); -- male
						end
						if(PlayerDatas[i].rac == 23)then
							centerLabelB5:SetBackground(0x41108945); -- male
						end
						if(PlayerDatas[i].rac == 65)then
							centerLabelB5:SetBackground(0x41108947); -- male
						end
						if(PlayerDatas[i].rac == 114)then
							centerLabelB5:SetBackground(0x4115920D); -- male
						end
						if(PlayerDatas[i].rac == 120)then
							centerLabelB5:SetBackground(0x411DAE7E); -- male
						end
						if(PlayerDatas[i].rac == 73)then
							centerLabelB5:SetBackground(0x41108946); -- male
						end
						if(PlayerDatas[i].rac == 117)then
							centerLabelB5:SetBackground(0x411C8D6B); -- male
						end
						if(PlayerDatas[i].rac == 125)then
							centerLabelB5:SetBackground(0x4110894A); -- male
						end
				end

				checkBoxMale[i] = Turbine.UI.Lotro.CheckBox();
				checkBoxMale[i]:SetParent( listItem );
				checkBoxMale[i]:SetSize(40, 40); 
				checkBoxMale[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				checkBoxMale[i]:SetText("");
				checkBoxMale[i]:SetPosition(posx + 197, posy);
				checkBoxMale[i]:SetVisible(true);
				checkBoxMale[i]:SetMouseVisible(true);
				if(PlayerDatas[i].sexe == "male")then
					checkBoxMale[i]:SetChecked(true);
				else
					checkBoxMale[i]:SetChecked(false);
				end
				checkBoxMale[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

				---define race female
				buttonDefineHouseLocationPersonal2 = Turbine.UI.Extensions.SimpleWindow();
				buttonDefineHouseLocationPersonal2:SetParent( listItem );
				buttonDefineHouseLocationPersonal2:SetPosition(posx + 260, posy);
				buttonDefineHouseLocationPersonal2:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal2:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(listItem);
				centerLabelB5:SetPosition( posx + 260, posy );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);
				centerLabelB5:SetBlendMode(Turbine.UI.BlendMode.Overlay);

				if(settings["nameAccount"]["account1"]["name"] ~= "")then
						--centerLabelB:SetBackground(ResourcePath .. tostring(PlayerDatas[i].cla));
						if(PlayerDatas[i].rac == 81)then
							centerLabelB5:SetBackground(0x41108949); -- female
						end
						if(PlayerDatas[i].rac == 23)then
							centerLabelB5:SetBackground(0x4110894B); -- female
						end
						if(PlayerDatas[i].rac == 65)then
							centerLabelB5:SetBackground(0x41108948); -- female
						end
						if(PlayerDatas[i].rac == 114)then
							centerLabelB5:SetBackground(0x4115920A); -- female
						end
						if(PlayerDatas[i].rac == 120)then
							centerLabelB5:SetBackground(0x411DAE7E); -- female
						end
						--if(PlayerDatas[i].rac == 73)then
							--centerLabelB5:SetBackground(0x411C2BD8); -- female
						--end
						if(PlayerDatas[i].rac == 117)then
							centerLabelB5:SetBackground(0x411C8D6A); -- female
						end
						if(PlayerDatas[i].rac == 125)then
							centerLabelB5:SetBackground(0x41108949); -- female
						end
				end

				if(PlayerDatas[i].rac ~= 73)then
					checkBoxFemale[i] = Turbine.UI.Lotro.CheckBox();
					checkBoxFemale[i]:SetParent( listItem );
					checkBoxFemale[i]:SetSize(40, 40); 
					checkBoxFemale[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
					checkBoxFemale[i]:SetText("");
					checkBoxFemale[i]:SetPosition(posx + 302, posy);
					checkBoxFemale[i]:SetVisible(true);
					checkBoxFemale[i]:SetMouseVisible(true);
					if(PlayerDatas[i].sexe == "female")then
						checkBoxFemale[i]:SetChecked(true);
					else
						checkBoxFemale[i]:SetChecked(false);
					end
					checkBoxFemale[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));


					checkBoxMale[i].CheckedChanged = function()
						if(checkBoxMale[i]:IsChecked())then
							checkBoxFemale[i]:SetChecked(false);
							PlayerSexe[i] = "male";
							SavePlayerSexeForSpecialCharacters(i);
						end
					end
					checkBoxFemale[i].CheckedChanged = function()
						if(checkBoxFemale[i]:IsChecked())then
							checkBoxMale[i]:SetChecked(false);
							PlayerSexe[i] = "female";
							SavePlayerSexeForSpecialCharacters(i);
						end
					end
				else
					PlayerSexe[i] = "male";
					SavePlayerSexeForSpecialCharacters(i);
				end
				--posy = posy + 35;	
				listbox:AddItem( listItem );
			end
		end
		------------------------------------------------------------------------------------------
		--- scrollbar handler
		------------------------------------------------------------------------------------------
		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(GendreWindow);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth-20, 70);
		vscrollListBox:SetSize(10, windowHeight - 140); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum( (count * 50)); -- we will allow scrolling the height of the map-the viewport height
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

		listbox:SetVerticalScrollBar(vscrollListBox);


		buttonValider = Turbine.UI.Lotro.GoldButton();
		buttonValider:SetParent( GendreWindow );
		buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
		buttonValider:SetSize( 300, 20 );
		buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValider:SetText( T[ "PluginCloseButton" ] );
		buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValider:SetVisible(true);
		buttonValider:SetMouseVisible(true);

		CloseGendreWindow();
		EscapeKeyHandlerForWindows(GendreWindow, settings["isGendreWindowVisible"]["value"]);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------

function CloseGendreWindow()
	buttonValider.MouseClick = function(sender, args)
		GendreWindow:SetVisible(false);
		settings["isGendreWindowVisible"]["value"] = false;
	end
end