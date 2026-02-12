------------------------------------------------------------------------------------------
-- UIAddNew file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the add new epique book window
------------------------------------------------------------------------------------------
function CreateAddNewWindowEpique(ValToUpdate)

	text = {};

	AltHolicAddnewWindowEpique=Turbine.UI.Lotro.GoldWindow(); 
	AltHolicAddnewWindowEpique:SetSize(400,360); 
	if(ValToUpdate ~= nil)then
		AltHolicAddnewWindowEpique:SetText(T[ "PluginUpdateTitle" ] .. PlayerName); 
	else
		AltHolicAddnewWindowEpique:SetText(T[ "PluginAddNewBook" ] .. PlayerName); 
	end
	AltHolicAddnewWindowEpique.Message=Turbine.UI.Label(); 
	AltHolicAddnewWindowEpique.Message:SetParent(AltHolicAddnewWindowEpique); 
	AltHolicAddnewWindowEpique.Message:SetSize(150,10); 
	AltHolicAddnewWindowEpique.Message:SetPosition(AltHolicAddnewWindowEpique:GetWidth()/2 - 75, AltHolicAddnewWindowEpique:GetHeight() - 20); 
	AltHolicAddnewWindowEpique.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicAddnewWindowEpique.Message:SetText(T[ "PluginText" ]); 
	AltHolicAddnewWindowEpique:SetZOrder(100);
	AltHolicAddnewWindowEpique:SetWantsKeyEvents(true);
	AltHolicAddnewWindowEpique:SetVisible(false);

	AltHolicAddnewWindowEpique:SetPosition((Turbine.UI.Display:GetWidth()-AltHolicAddnewWindowEpique:GetWidth())/2,(Turbine.UI.Display:GetHeight()-AltHolicAddnewWindowEpique:GetHeight())/2);
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------

	textBoxlabel1 = Turbine.UI.Label();
	textBoxlabel1:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel1:SetSize(350, 40); 
	textBoxlabel1:SetPosition(25, 30);
	textBoxlabel1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel1:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
	textBoxlabel1:SetText(T[ "PluginAddNewBookVolume" ]);
	textBoxlabel1:SetForeColor( Turbine.UI.Color.Gold);
	textBoxlabel1:SetVisible(true);

	textBoxlabel1 = Turbine.UI.Label();
	textBoxlabel1:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel1:SetSize(350, 40); 
	textBoxlabel1:SetPosition(25, 45);
	textBoxlabel1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel1:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	textBoxlabel1:SetText(T[ "PluginExample1" ]);
	textBoxlabel1:SetForeColor( Turbine.UI.Color.White);
	textBoxlabel1:SetVisible(true);

	textBoxSlots1 = Turbine.UI.Lotro.TextBox();
	textBoxSlots1:SetParent( AltHolicAddnewWindowEpique );
	textBoxSlots1:SetSize(120, 40); 
	textBoxSlots1:SetPosition(140, 70);
	textBoxSlots1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	if(ValToUpdate ~= nil)then
		text = Split(PlayerEpique[PlayerName].volume[ValToUpdate], " ");
		textBoxSlots1:SetText(text[2]);
	else
		textBoxSlots1:SetText("");
	end
	textBoxSlots1:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxSlots1:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));	
	textBoxSlots1:SetVisible(true);

	textBoxlabel2 = Turbine.UI.Label();
	textBoxlabel2:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel2:SetSize(350, 40); 
	textBoxlabel2:SetPosition(25, 115);
	textBoxlabel2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel2:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
	textBoxlabel2:SetText(T[ "PluginAddNewBookLivre" ]);
	textBoxlabel2:SetForeColor( Turbine.UI.Color.Gold);
	textBoxlabel2:SetVisible(true);

	textBoxlabel2 = Turbine.UI.Label();
	textBoxlabel2:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel2:SetSize(350, 40); 
	textBoxlabel2:SetPosition(25, 130);
	textBoxlabel2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel2:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	textBoxlabel2:SetText(T[ "PluginExample2" ]);
	textBoxlabel2:SetForeColor( Turbine.UI.Color.White);
	textBoxlabel2:SetVisible(true);

	textBoxSlots2 = Turbine.UI.Lotro.TextBox();
	textBoxSlots2:SetParent( AltHolicAddnewWindowEpique );
	textBoxSlots2:SetSize(120, 40); 
	textBoxSlots2:SetPosition(140, 155);
	textBoxSlots2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	if(ValToUpdate ~= nil)then
		text = Split(PlayerEpique[PlayerName].livre[ValToUpdate], " ");
		if(string.len(PlayerEpique[PlayerName].livre[ValToUpdate]) > 3)then
			textBoxSlots2:SetText(text[1]);
		else
			textBoxSlots2:SetText(text[2]);
		end
	else
		textBoxSlots2:SetText("");
	end
	textBoxSlots2:SetText(text[2]);
	textBoxSlots2:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxSlots2:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));	
	textBoxSlots2:SetVisible(true);

	textBoxlabel3 = Turbine.UI.Label();
	textBoxlabel3:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel3:SetSize(350, 40); 
	textBoxlabel3:SetPosition(25, 200);
	textBoxlabel3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel3:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
	textBoxlabel3:SetText(T[ "PluginAddNewBookChapitre" ]);
	textBoxlabel3:SetForeColor( Turbine.UI.Color.Gold);
	textBoxlabel3:SetVisible(true);

	textBoxlabel3 = Turbine.UI.Label();
	textBoxlabel3:SetParent( AltHolicAddnewWindowEpique );
	textBoxlabel3:SetSize(350, 40); 
	textBoxlabel3:SetPosition(25, 215);
	textBoxlabel3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxlabel3:SetFont(Turbine.UI.Lotro.Font.Verdana12);
	textBoxlabel3:SetText(T[ "PluginExample3" ]);
	textBoxlabel3:SetForeColor( Turbine.UI.Color.White);
	textBoxlabel3:SetVisible(true);

	textBoxSlots3 = Turbine.UI.Lotro.TextBox();
	textBoxSlots3:SetParent( AltHolicAddnewWindowEpique );
	textBoxSlots3:SetSize(200, 40); 
	textBoxSlots3:SetPosition(100, 240);
	textBoxSlots3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	if(ValToUpdate ~= nil)then
		text = Split(PlayerEpique[PlayerName].chapitre[ValToUpdate], " ");
		textBoxSlots3:SetText(text[2]);
	else
		textBoxSlots3:SetText("");
	end
	textBoxSlots3:SetText(text[2]);
	textBoxSlots3:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxSlots3:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));	
	textBoxSlots3:SetVisible(true);

	if(ValToUpdate ~= nil)then
		buttonUpdate = Turbine.UI.Lotro.GoldButton();
		buttonUpdate:SetParent( AltHolicAddnewWindowEpique );
		buttonUpdate:SetPosition(AltHolicAddnewWindowEpique:GetWidth()/2 - 175, AltHolicAddnewWindowEpique:GetHeight() - 50);
		buttonUpdate:SetSize( 150, 20 );
		buttonUpdate:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonUpdate:SetText( T[ "PluginUpdate" ] );
		buttonUpdate:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonUpdate:SetVisible(true);
		buttonUpdate:SetMouseVisible(true);

		buttonDelete = Turbine.UI.Lotro.GoldButton();
		buttonDelete:SetParent( AltHolicAddnewWindowEpique );
		buttonDelete:SetPosition(AltHolicAddnewWindowEpique:GetWidth()/2 + 25, AltHolicAddnewWindowEpique:GetHeight() - 50);
		buttonDelete:SetSize( 150, 20 );
		buttonDelete:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonDelete:SetText( T[ "PluginDelete" ] );
		buttonDelete:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonDelete:SetVisible(true);
		buttonDelete:SetMouseVisible(true);

		UpdateChangesForEpique(ValToUpdate);
		DeleteForEpique(ValToUpdate);
	else
		buttonValider = Turbine.UI.Lotro.GoldButton();
		buttonValider:SetParent( AltHolicAddnewWindowEpique );
		buttonValider:SetPosition(AltHolicAddnewWindowEpique:GetWidth()/2 - 100, AltHolicAddnewWindowEpique:GetHeight() - 50);
		buttonValider:SetSize( 200, 20 );
		buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValider:SetText( T[ "PluginAddNew2" ] );
		buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValider:SetVisible(true);
		buttonValider:SetMouseVisible(true);

		ValidateChangesForEpique();
	end

	AltHolicAddnewWindowEpique.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			AltHolicAddnewWindowEpique:SetVisible(false);
		end
	
		-- https://www.lotro.com/forums/showthread.php?493466-How-to-hide-a-window-on-F12&p=6581962#post6581962
		if ( args.Action == 268435635 ) then
			hudVisible=not hudVisible;
			if hudVisible then
				AltHolicAddnewWindowEpique:SetVisible(false);
				MainMinimizedIcon:SetVisible(false);
				MainTinyIcon:SetVisible(false);
			else
				AltHolicAddnewWindowEpique:SetVisible(settings.isEpiqueWindowVisible);
				UpdateMinimizedIcon();
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- function for the button
------------------------------------------------------------------------------------------
function ValidateChangesForEpique()
	buttonValider.MouseClick = function(sender, args)

		EpiqueVolume = PlayerEpique[PlayerName].volume;
		EpiqueLivre = PlayerEpique[PlayerName].livre;
		EpiqueChapitre = PlayerEpique[PlayerName].chapitre;

		val = tablelength(PlayerEpique[PlayerName].volume);

		if(val == 0)then
			val = 1;
		else
			val = val + 1;
		end

		EpiqueVolume[val] = tostring(T[ "PluginAddNewBookVolume" ] .. " " .. textBoxSlots1:GetText());
		if(string.len(textBoxSlots2:GetText()) > 3 )then
			EpiqueLivre[val] = tostring(textBoxSlots2:GetText());
			EpiqueChapitre[val] = tostring(textBoxSlots3:GetText());
		else
			EpiqueLivre[val] = tostring(T[ "PluginAddNewBookLivre" ] .. " " .. textBoxSlots2:GetText());
			if(string.len(textBoxSlots3:GetText()) > 0 and string.len(textBoxSlots3:GetText()) < 4)then
				EpiqueChapitre[val] = tostring(T[ "PluginAddNewBookChapitre" ] .. " " .. textBoxSlots3:GetText());
			else
				EpiqueChapitre[val] = tostring(textBoxSlots3:GetText());
			end
		end

		AltHolicAddnewWindowEpique:SetVisible(false);

		SavePlayerEpique();

		UIShowEpique:SetVisible(false);
		CreateUIShowEpique();
		UIShowEpique:SetVisible(true);
	end
end

function UpdateChangesForEpique(ValToUpdate)
	buttonUpdate.MouseClick = function(sender, args)

		EpiqueVolume = PlayerEpique[PlayerName].volume;
		EpiqueLivre = PlayerEpique[PlayerName].livre;
		EpiqueChapitre = PlayerEpique[PlayerName].chapitre;

		EpiqueVolume[ValToUpdate] = tostring(T[ "PluginAddNewBookVolume" ] .. " " .. textBoxSlots1:GetText());
		if(string.len(textBoxSlots2:GetText()) > 3 )then
			EpiqueLivre[ValToUpdate] = tostring(textBoxSlots2:GetText());
			EpiqueChapitre[ValToUpdate] = tostring(textBoxSlots3:GetText());
		else
			EpiqueLivre[ValToUpdate] = tostring(T[ "PluginAddNewBookLivre" ] .. " " .. textBoxSlots2:GetText());
			if(string.len(textBoxSlots3:GetText()) > 0 and string.len(textBoxSlots3:GetText()) < 4)then
				EpiqueChapitre[ValToUpdate] = tostring(T[ "PluginAddNewBookChapitre" ] .. " " .. textBoxSlots3:GetText());
			else
				EpiqueChapitre[ValToUpdate] = tostring(textBoxSlots3:GetText());
			end
		end

		AltHolicAddnewWindowEpique:SetVisible(false);

		SavePlayerEpique();

		UIShowEpique:SetVisible(false);
		CreateUIShowEpique();
		UIShowEpique:SetVisible(true);
	end
end

function DeleteForEpique(ValToUpdate)
	buttonDelete.MouseClick = function(sender, args)

		PlayerEpique[PlayerName].volume[ValToUpdate] = nil;
		PlayerEpique[PlayerName].livre[ValToUpdate] = nil;
		PlayerEpique[PlayerName].chapitre[ValToUpdate] = nil;

		AltHolicAddnewWindowEpique:SetVisible(false);

		SavePlayerEpiqueDelete();

		UIShowEpique:SetVisible(false);
		CreateUIShowEpique();
		UIShowEpique:SetVisible(true);
	end
end