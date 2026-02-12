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

windowWidth = 600;
windowHeight = 800;

checkBoxVoc1 = {};
checkBoxVoc2 = {};
checkBoxVoc3 = {};
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateProfessionWindow()
		local nbrPlayerCanChangeProf = 0;

		for i in pairs(PlayerDatas) do 
			if(PlayerDatas[i].rac == 81 or
				PlayerDatas[i].rac == 23 or
				PlayerDatas[i].rac == 65 or 
				PlayerDatas[i].rac == 114 or
				PlayerDatas[i].rac == 120 or 
				PlayerDatas[i].rac == 73 or
				PlayerDatas[i].rac == 117)then
			nbrPlayerCanChangeProf = nbrPlayerCanChangeProf + 1;
			end
		end

		if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
			windowHeight = 200 + (nbrPlayerCanChangeProf * 32);
		else
			windowHeight = 200;
		end
		
		ProfessionWindow=Turbine.UI.Lotro.GoldWindow(); 
		ProfessionWindow:SetSize(windowWidth, windowHeight); 
		ProfessionWindow:SetText("Définition des professions utilisées"); 

		ProfessionWindow.Message=Turbine.UI.Label(); 
		ProfessionWindow.Message:SetParent(ProfessionWindow); 
		ProfessionWindow.Message:SetSize(150,10); 
		ProfessionWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		ProfessionWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		ProfessionWindow.Message:SetText(Strings.PluginText); 

		ProfessionWindow:SetZOrder(100);
		ProfessionWindow:SetWantsKeyEvents(true);
		ProfessionWindow:SetWantsUpdates(true);

		ProfessionWindow:SetPosition((Turbine.UI.Display:GetWidth()-ProfessionWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-ProfessionWindow:GetHeight())/2);

		ProfessionWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- option panel --
		------------------------------------------------------------------------------------------
		-- sort player name by alphabetical order
		a = {};
		for i in pairs(PlayerDatas) do 
			table.insert(a, i);
		end
		table.sort(a);

		posx = 280;
		posy = 150;

		for n, i in ipairs(a) do 
			if(PlayerDatas[i].align == 1)then
				ProfessionWindow.Message=Turbine.UI.Label(); 
				ProfessionWindow.Message:SetParent(ProfessionWindow); 
				ProfessionWindow.Message:SetSize(120, 30); 
				ProfessionWindow.Message:SetPosition(posx - 250, posy - 76); 
				ProfessionWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				ProfessionWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				ProfessionWindow.Message:SetText(i); 
				ProfessionWindow.Message:SetForeColor(Turbine.UI.Color.Gold); 

			---define  voc 1
				buttonDefineHouseLocationPersonal = Turbine.UI.Extensions.SimpleWindow();
				buttonDefineHouseLocationPersonal:SetParent( ProfessionWindow );
				buttonDefineHouseLocationPersonal:SetPosition(posx - 100, posy - 76);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(buttonDefineHouseLocationPersonal);
				centerLabelB5:SetPosition( 0, 0 );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);


				checkBoxVoc1[i] = Turbine.UI.Lotro.CheckBox();
				checkBoxVoc1[i]:SetParent( ProfessionWindow );
				checkBoxVoc1[i]:SetSize(100, 40); 
				checkBoxVoc1[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
				checkBoxVoc1[i]:SetText("");
				checkBoxVoc1[i]:SetPosition(posx - 60, posy - 80);
				checkBoxVoc1[i]:SetVisible(true);
				checkBoxVoc1[i]:SetMouseVisible(true);
				if(PlayerDatas[i].prof1 == "Checked")then
					checkBoxVoc1[i]:SetChecked(true);
				else
					checkBoxVoc1[i]:SetChecked(false);
				end
				checkBoxVoc1[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

				if(settings["nameAccount"]["account1"]["name"] ~= "")then  -- vocation
					if(PlayerDatas[i].voc == 1)then
						centerLabelB5:SetBackground(ResourcePath .. "Tailleur.tga"); -- tailleur
						checkBoxVoc1[i]:SetText(Strings.PluginVocation7);
					end
					if(PlayerDatas[i].voc == 2)then
						centerLabelB5:SetBackground(ResourcePath .. "Bijoutier.tga"); -- joaillier
						checkBoxVoc1[i]:SetText(Strings.PluginVocation8);
					end
					if(PlayerDatas[i].voc == 3)then
						centerLabelB5:SetBackground(ResourcePath .. "Tailleur.tga"); -- tailleur
						checkBoxVoc1[i]:SetText(Strings.PluginVocation7);
					end
					if(PlayerDatas[i].voc == 4)then
						centerLabelB5:SetBackground(ResourcePath .. "Herudit.tga"); -- historien
						checkBoxVoc1[i]:SetText(Strings.PluginVocation9);
					end
					if(PlayerDatas[i].voc == 5)then
						centerLabelB5:SetBackground(ResourcePath .. "Menuisier.tga"); -- menuisier
						checkBoxVoc1[i]:SetText(Strings.PluginVocation10);
					end
					if(PlayerDatas[i].voc == 6)then
						centerLabelB5:SetBackground(ResourcePath .. "Menuisier.tga"); -- menuisier
						checkBoxVoc1[i]:SetText(Strings.PluginVocation10);
					end
					if(PlayerDatas[i].voc == 7)then
						centerLabelB5:SetBackground(ResourcePath .. "Feronnier.tga"); -- ferroneir
						checkBoxVoc1[i]:SetText(Strings.PluginVocation14);
					end
				end

				---define voc 2
				buttonDefineHouseLocationPersonal = Turbine.UI.Extensions.SimpleWindow();
				buttonDefineHouseLocationPersonal:SetParent( ProfessionWindow );
				buttonDefineHouseLocationPersonal:SetPosition(posx + 40, posy - 76);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(buttonDefineHouseLocationPersonal);
				centerLabelB5:SetPosition( 0, 0 );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);

				checkBoxVoc2[i] = Turbine.UI.Lotro.CheckBox();

				if(PlayerDatas[i].voc ~= 1)then
					
					checkBoxVoc2[i]:SetParent( ProfessionWindow );
					checkBoxVoc2[i]:SetSize(100, 40); 
					checkBoxVoc2[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
					checkBoxVoc2[i]:SetText("");
					checkBoxVoc2[i]:SetPosition(posx + 80, posy - 80);
					checkBoxVoc2[i]:SetVisible(true);
					checkBoxVoc2[i]:SetMouseVisible(true);
					if(PlayerDatas[i].prof2 == "Checked")then
						checkBoxVoc2[i]:SetChecked(true);
					else
						checkBoxVoc2[i]:SetChecked(false);
					end
					checkBoxVoc2[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
				end

				if(settings["nameAccount"]["account1"]["name"] ~= "")then  -- vocation
					if(PlayerDatas[i].voc == 2)then
						centerLabelB5:SetBackground(ResourcePath .. "Cuisine.tga"); -- cuisine
						checkBoxVoc2[i]:SetText(Strings.PluginVocation11);
					end
					if(PlayerDatas[i].voc == 3)then
						centerLabelB5:SetBackground(ResourcePath .. "Cuisine.tga"); -- cuisine
						checkBoxVoc2[i]:SetText(Strings.PluginVocation11);
					end
					if(PlayerDatas[i].voc == 4)then
						centerLabelB5:SetBackground(ResourcePath .. "Armes.tga"); -- arme
						checkBoxVoc2[i]:SetText(Strings.PluginVocation12);
					end
					if(PlayerDatas[i].voc == 5)then
						centerLabelB5:SetBackground(ResourcePath .. "Armes.tga"); -- armurier
						checkBoxVoc2[i]:SetText(Strings.PluginVocation12);
					end
					if(PlayerDatas[i].voc == 6)then
						centerLabelB5:SetBackground(ResourcePath .. "Fermier.tga"); -- fermier
						checkBoxVoc2[i]:SetText(Strings.PluginVocation13);
					end
					if(PlayerDatas[i].voc == 7)then
						centerLabelB5:SetBackground(ResourcePath .. "Tailleur.tga"); -- tailleur
						checkBoxVoc2[i]:SetText(Strings.PluginVocation7);
					end
				end

				---define  voc 3
				buttonDefineHouseLocationPersonal = Turbine.UI.Extensions.SimpleWindow();
				buttonDefineHouseLocationPersonal:SetParent( ProfessionWindow );
				buttonDefineHouseLocationPersonal:SetPosition(posx + 180, posy - 76);
				buttonDefineHouseLocationPersonal:SetSize( 32, 32 );
				buttonDefineHouseLocationPersonal:SetVisible(true);

				centerLabelB5 = Turbine.UI.Label();
				centerLabelB5:SetParent(buttonDefineHouseLocationPersonal);
				centerLabelB5:SetPosition( 0, 0 );
				centerLabelB5:SetSize( 32, 32  );
				centerLabelB5:SetZOrder(-1);
				centerLabelB5:SetMouseVisible(false);

				checkBoxVoc3[i] = Turbine.UI.Lotro.CheckBox();

				if(PlayerDatas[i].voc == 3 or PlayerDatas[i].voc == 4)then
					
					checkBoxVoc3[i]:SetParent( ProfessionWindow );
					checkBoxVoc3[i]:SetSize(100, 40); 
					checkBoxVoc3[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
					checkBoxVoc3[i]:SetText("");
					checkBoxVoc3[i]:SetPosition(posx + 220, posy - 80);
					checkBoxVoc3[i]:SetVisible(true);
					checkBoxVoc3[i]:SetMouseVisible(true);
					if(PlayerDatas[i].prof3 == "Checked")then
						checkBoxVoc3[i]:SetChecked(true);					
					else
						checkBoxVoc3[i]:SetChecked(false);
					end
					checkBoxVoc3[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
				end

				if(settings["nameAccount"]["account1"]["name"] ~= "")then  -- vocation
					if(PlayerDatas[i].voc == 3)then
						centerLabelB5:SetBackground(ResourcePath .. "Fermier.tga"); -- tailleur
						checkBoxVoc3[i]:SetText(Strings.PluginVocation13);
					end
					if(PlayerDatas[i].voc == 4)then
						centerLabelB5:SetBackground(ResourcePath .. "Fermier.tga"); -- historien
						checkBoxVoc3[i]:SetText(Strings.PluginVocation13);
					end
				end

				PlayerProf1[i] = "Not Checked";
				PlayerProf2[i] = "Not Checked";
				PlayerProf3[i] = "Not Checked";

				checkBoxVoc1[i].CheckedChanged = function()
					if(checkBoxVoc1[i]:IsChecked())then
						PlayerProf1[i] = "Checked";
						SavePlayerProf1ForSpecialCharacters(i);
					end
				end
				checkBoxVoc2[i].CheckedChanged = function()
					if(checkBoxVoc2[i]:IsChecked())then
						PlayerProf2[i] = "Checked";
						SavePlayerProf2ForSpecialCharacters(i);
					end
				end
				checkBoxVoc3[i].CheckedChanged = function()
					if(checkBoxVoc3[i]:IsChecked())then
						PlayerProf3[i] = "Checked";
						SavePlayerProf3ForSpecialCharacters(i);
					end
				end
				posy = posy + 35;
			end
		end

		buttonValider = Turbine.UI.Lotro.GoldButton();
		buttonValider:SetParent( ProfessionWindow );
		buttonValider:SetPosition(windowWidth/2 - 125,  windowHeight - 50);
		buttonValider:SetSize( 300, 20 );
		buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValider:SetText( Strings.PluginCloseButton );
		buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValider:SetVisible(true);
		buttonValider:SetMouseVisible(true);

		CloseProfessionWindow();
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------

function CloseProfessionWindow()
	buttonValider.MouseClick = function(sender, args)
		ProfessionWindow:SetVisible(false);
	end
end