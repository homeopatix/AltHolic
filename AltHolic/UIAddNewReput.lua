------------------------------------------------------------------------------------------
-- UIAddNew file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the add new Reput book window
------------------------------------------------------------------------------------------
function CreateAddNewWindowReput(ValToUpdate, NamePlayerToShow, i)

	text = {};

	AltHolicAddnewWindowReput=Turbine.UI.Lotro.GoldWindow(); 
	AltHolicAddnewWindowReput:SetSize(400,280); 
	AltHolicAddnewWindowReput:SetText("Updating reputation"); 
	AltHolicAddnewWindowReput.Message=Turbine.UI.Label(); 
	AltHolicAddnewWindowReput.Message:SetParent(AltHolicAddnewWindowReput); 
	AltHolicAddnewWindowReput.Message:SetSize(150,10); 
	AltHolicAddnewWindowReput.Message:SetPosition(AltHolicAddnewWindowReput:GetWidth()/2 - 75, AltHolicAddnewWindowReput:GetHeight() - 20); 
	AltHolicAddnewWindowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicAddnewWindowReput.Message:SetText(T[ "PluginText" ]); 
	AltHolicAddnewWindowReput:SetZOrder(100);
	AltHolicAddnewWindowReput:SetWantsKeyEvents(true);
	AltHolicAddnewWindowReput:SetVisible(false);

	AltHolicAddnewWindowReput:SetPosition((Turbine.UI.Display:GetWidth()-AltHolicAddnewWindowReput:GetWidth())/2,((Turbine.UI.Display:GetHeight()-AltHolicAddnewWindowReput:GetHeight())/2) - 400);
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------

	textBoxlabel1 = Turbine.UI.Label();
	textBoxlabel1:SetParent( AltHolicAddnewWindowReput );
	textBoxlabel1:SetSize(350, 40); 
	textBoxlabel1:SetPosition(25, 30);
	textBoxlabel1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel1:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	textBoxlabel1:SetText(ValToUpdate);
	textBoxlabel1:SetForeColor( Turbine.UI.Color.Gold);
	textBoxlabel1:SetVisible(true);

	textBoxlabel1 = Turbine.UI.Label();
	textBoxlabel1:SetParent( AltHolicAddnewWindowReput );
	textBoxlabel1:SetSize(350, 40); 
	textBoxlabel1:SetPosition(25, 45);
	textBoxlabel1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel1:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	textBoxlabel1:SetText("Value");
	textBoxlabel1:SetForeColor( Turbine.UI.Color.White);
	textBoxlabel1:SetVisible(true);

	textBoxSlots1 = Turbine.UI.Lotro.TextBox();
	textBoxSlots1:SetParent( AltHolicAddnewWindowReput );
	textBoxSlots1:SetSize(120, 40); 
	textBoxSlots1:SetPosition(140, 70);
	textBoxSlots1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxSlots1:SetText("");
	textBoxSlots1:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxSlots1:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));	
	textBoxSlots1:SetVisible(true);


	textBoxlabel2 = Turbine.UI.Label();
	textBoxlabel2:SetParent( AltHolicAddnewWindowReput );
	textBoxlabel2:SetSize(350, 40); 
	textBoxlabel2:SetPosition(25, 130);
	textBoxlabel2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel2:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
	textBoxlabel2:SetText("Reputations");
	textBoxlabel2:SetForeColor( Turbine.UI.Color.Gold);
	textBoxlabel2:SetVisible(true);

	textBoxlabel2 = Turbine.UI.Label();
	textBoxlabel2:SetParent( AltHolicAddnewWindowReput );
	textBoxlabel2:SetSize(350, 40); 
	textBoxlabel2:SetPosition(25, 145);
	textBoxlabel2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel2:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	textBoxlabel2:SetText("Value");
	textBoxlabel2:SetForeColor( Turbine.UI.Color.White);
	textBoxlabel2:SetVisible(true);

	myTable = {};

	if(PlayerDatas[NamePlayerToShow].sexe == "male")then
		myTable = {T[ "reputposition0" ],
					T[ "reputposition1" ],
					T[ "reputposition2" ],
					T[ "reputposition3" ],
					T[ "reputposition4" ],
					T[ "reputposition5" ],
					T[ "reputposition6" ],
					T[ "reputposition7" ],
					T[ "reputposition8" ],
					T[ "reputposition9" ],
					T[ "reputposition10" ],
					T[ "reputposition11" ],
					T[ "reputposition12" ],
					T[ "reputposition13" ],
					T[ "reputposition14" ],
					T[ "reputposition15" ],
					T[ "reputposition16" ],
					T[ "reputposition17" ],
					T[ "reputposition18" ],
					T[ "reputposition19" ],
					T[ "reputposition20" ],
					T[ "reputposition21" ],
					T[ "reputposition22" ],
					T[ "reputposition23" ],
					T[ "reputposition24" ],
					T[ "reputposition25" ],
					T[ "reputposition26" ],
					T[ "reputposition27" ],
					T[ "reputposition28" ],
					T[ "reputposition29" ],
					T[ "reputposition30" ],
					T[ "reputposition31" ],
					T[ "reputposition32" ],
					T[ "reputposition33" ],
					T[ "reputposition34" ],
					T[ "reputposition35" ],
					T[ "reputposition36" ],
					T[ "reputposition37" ],
					T[ "reputposition38" ],
					T[ "reputposition39" ],
					T[ "reputposition40" ],
					T[ "reputposition41" ],
					T[ "reputposition42" ],
					T[ "reputposition43" ],
					T[ "reputposition44" ],
					T[ "reputposition45" ],
					T[ "reputposition46" ]
					}; -- etc.. -- male
	else
		myTable = {
					T[ "reputposition0" ],
					T[ "reputpositionFemale1" ],
					T[ "reputpositionFemale2" ],
					T[ "reputpositionFemale3" ],
					T[ "reputpositionFemale4" ],
					T[ "reputpositionFemale5" ],
					T[ "reputpositionFemale6" ],
					T[ "reputpositionFemale7" ],
					T[ "reputpositionFemale8" ],
					T[ "reputpositionFemale9" ],
					T[ "reputpositionFemale10" ],
					T[ "reputposition11" ],
					T[ "reputposition12" ],
					T[ "reputposition13" ],
					T[ "reputposition14" ],
					T[ "reputposition15" ],
					T[ "reputposition16" ],
					T[ "reputposition17" ],
					T[ "reputposition18" ],
					T[ "reputposition19" ],
					T[ "reputposition20" ],
					T[ "reputposition21" ],
					T[ "reputposition22" ],
					T[ "reputposition23" ],
					T[ "reputposition24" ],
					T[ "reputposition25" ],
					T[ "reputposition26" ],
					T[ "reputposition27" ],
					T[ "reputposition28" ],
					T[ "reputposition29" ],
					T[ "reputposition30" ],
					T[ "reputposition31" ],
					T[ "reputposition32" ],
					T[ "reputposition33" ],
					T[ "reputposition34" ],
					T[ "reputposition35" ],
					T[ "reputposition36" ],
					T[ "reputposition37" ],
					T[ "reputposition38" ],
					T[ "reputposition39" ],
					T[ "reputposition40" ],
					T[ "reputposition41" ],
					T[ "reputposition42" ],
					T[ "reputposition43" ],
					T[ "reputposition44" ],
					T[ "reputposition45" ],
					T[ "reputposition46" ]
					}; --female
	end
	
	myDropDown = DropDown.Create(myTable, myTable[1]); -- table that contains the list, default selected value for the list
	myDropDown:SetParent(AltHolicAddnewWindowReput);
	myDropDown:ApplyWidth(300); -- set the width of the menu, this is not essential to include as the default is a good size.
	myDropDown:SetMaxItems(48); -- Number of items to display in the drop down before a scrollbar is needed.. default value is 7 where this is excluded.
	myDropDown:SetPosition(50, 172);
	myDropDown:SetVisible(true);

	myDropDown.ItemChanged = function () -- The event that's executed when a menu item is clicked.
		selectedItem = myDropDown:GetText();
		--Write("Selected item " .. selectedItem);
	end

	buttonValider = Turbine.UI.Lotro.GoldButton();
	buttonValider:SetParent( AltHolicAddnewWindowReput );
	buttonValider:SetPosition(AltHolicAddnewWindowReput:GetWidth()/2 - 100, AltHolicAddnewWindowReput:GetHeight() - 50);
	buttonValider:SetSize( 200, 20 );
	buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonValider:SetText( T[ "PluginAddNew2" ] );
	buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValider:SetVisible(true);
	buttonValider:SetMouseVisible(true);

	ValidateChangesForReput(i, NamePlayerToShow);

	AltHolicAddnewWindowReput.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			AltHolicAddnewWindowReput:SetVisible(false);
		end
	
		-- https://www.lotro.com/forums/showthread.php?493466-How-to-hide-a-window-on-F12&p=6581962#post6581962
		if ( args.Action == 268435635 ) then
			hudVisible=not hudVisible;
			if hudVisible then
				AltHolicAddnewWindowReput:SetVisible(false);
				MainMinimizedIcon:SetVisible(false);
				MainTinyIcon:SetVisible(false);
			else
				AltHolicAddnewWindowReput:SetVisible(settings.isReputWindowVisible);
				UpdateMinimizedIcon();
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- function for the button
------------------------------------------------------------------------------------------
function ValidateChangesForReput(i, NamePlayerToShow)
	buttonValider.MouseClick = function(sender, args)
		myTable = {};

		if(PlayerDatas[NamePlayerToShow].sexe == "male")then
			myTable = {
						T[ "reputposition1" ],
						T[ "reputposition2" ],
						T[ "reputposition3" ],
						T[ "reputposition4" ],
						T[ "reputposition5" ],
						T[ "reputposition6" ],
						T[ "reputposition7" ],
						T[ "reputposition8" ],
						T[ "reputposition9" ],
						T[ "reputposition10" ],
						T[ "reputposition11" ],
						T[ "reputposition12" ],
						T[ "reputposition13" ],
						T[ "reputposition14" ],
						T[ "reputposition15" ],
						T[ "reputposition16" ],
						T[ "reputposition17" ],
						T[ "reputposition18" ],
						T[ "reputposition19" ],
						T[ "reputposition20" ],
						T[ "reputposition21" ],
						T[ "reputposition22" ],
						T[ "reputposition23" ],
						T[ "reputposition24" ],
						T[ "reputposition25" ],
						T[ "reputposition26" ],
						T[ "reputposition27" ],
						T[ "reputposition28" ],
						T[ "reputposition29" ],
						T[ "reputposition30" ],
						T[ "reputposition31" ],
						T[ "reputposition32" ],
						T[ "reputposition33" ],
						T[ "reputposition34" ],
						T[ "reputposition35" ],
						T[ "reputposition36" ],
						T[ "reputposition37" ],
						T[ "reputposition38" ],
						T[ "reputposition39" ],
						T[ "reputposition40" ],
						T[ "reputposition41" ],
						T[ "reputposition42" ],
						T[ "reputposition43" ],
						T[ "reputposition44" ],
						T[ "reputposition45" ],
						T[ "reputposition46" ]
						}; -- etc..
		else
			myTable = {
						T[ "reputpositionFemale1" ], -- ennemi
						T[ "reputpositionFemale2" ], -- etranger
						T[ "reputpositionFemale3" ], -- neutre
						T[ "reputpositionFemale4" ], -- connaissance
						T[ "reputpositionFemale5" ], -- amie
						T[ "reputpositionFemale6" ], -- allié
						T[ "reputpositionFemale7" ], -- frére
						T[ "reputpositionFemale8" ], -- respecté
						T[ "reputpositionFemale9" ], -- honoré
						T[ "reputpositionFemale10" ], -- acclamé
						T[ "reputposition11" ], -- initier
						T[ "reputposition12" ], -- aprenti
						T[ "reputposition13" ], -- Compagnon
						T[ "reputposition14" ], -- expert 
						T[ "reputposition15" ], -- artisan
						T[ "reputposition16" ], -- maitre
						T[ "reputposition17" ], -- maitre estmet
						T[ "reputposition18" ], -- maitre ouestmet
						T[ "reputposition19" ], -- grand maitre
						T[ "reputposition20" ], -- rookie
						T[ "reputposition21" ], -- minor
						T[ "reputposition22" ], -- major
						T[ "reputposition23" ], -- all-star
						T[ "reputposition24" ], -- hall of farmer
						T[ "reputposition25" ],
						T[ "reputposition26" ],
						T[ "reputposition27" ],
						T[ "reputposition28" ],
						T[ "reputposition29" ],
						T[ "reputposition30" ],
						T[ "reputposition31" ],
						T[ "reputposition32" ],
						T[ "reputposition33" ],
						T[ "reputposition34" ],
						T[ "reputposition35" ],
						T[ "reputposition36" ],
						T[ "reputposition37" ],
						T[ "reputposition38" ],
						T[ "reputposition39" ],
						T[ "reputposition40" ],
						T[ "reputposition41" ],
						T[ "reputposition42" ],
						T[ "reputposition43" ],
						T[ "reputposition44" ],
						T[ "reputposition45" ],
						T[ "reputposition46" ]
						};
		end

		for j=1, 46 do
			if(selectedItem == myTable[j])then
				if(j > 1 and j <= 10)then
					RepuPosition[i] = j ;
					break;
				elseif(j > 10 and j <= 19)then
					RepuPosition[i] = j - 10;
					break;
				elseif(j > 19 and j <= 24)then
					RepuPosition[i] = j - 19;
					break;
				elseif(j > 24 and j <= 34)then
					RepuPosition[i] = j - 24;
					break;
				elseif(j > 34 and j <= 40)then
					RepuPosition[i] = j - 35;
					break;
				elseif(j > 40  and j <= 46)then
					RepuPosition[i] = j - 40;
					break;
				else
					RepuPosition[i] = j - 46;
					break;
				end
			end
		end

		--Write("RepuPosition[i] : " .. RepuPosition[i] .. " " .. T["reputname" .. i]);
		--Write("i : " .. i);



		RepuName[i] = T["reputname" .. i];
		Reputations[i] = tonumber(textBoxSlots1:GetText());

		SavePlayerReputations();
		AltHolicAddnewWindowReput:SetVisible(false);

		UIShowReput:SetVisible(false);
		CreateUIShowReput(NamePlayerToShow);
		UIShowReput:SetVisible(true);
	end
end