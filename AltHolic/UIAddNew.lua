------------------------------------------------------------------------------------------
-- UIAddNew file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the add new account window
------------------------------------------------------------------------------------------
function CreateAddNewWindow()
	AltHolicAddnewWindow=Turbine.UI.Lotro.GoldWindow(); 
	AltHolicAddnewWindow:SetSize(300,150); 
	AltHolicAddnewWindow:SetText(T[ "PluginAddNew" ]); 
	AltHolicAddnewWindow.Message=Turbine.UI.Label(); 
	AltHolicAddnewWindow.Message:SetParent(AltHolicWindow); 
	AltHolicAddnewWindow.Message:SetSize(150,10); 
	AltHolicAddnewWindow.Message:SetPosition(AltHolicWindow:GetWidth()/2 - 75, AltHolicWindow:GetHeight() - 20); 
	AltHolicAddnewWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	AltHolicAddnewWindow.Message:SetText(T[ "PluginText" ]); 
	AltHolicAddnewWindow:SetZOrder(1);
	AltHolicAddnewWindow:SetWantsKeyEvents(true);
	AltHolicAddnewWindow:SetVisible(false);

	AltHolicAddnewWindow:SetPosition((Turbine.UI.Display:GetWidth()-AltHolicAddnewWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-AltHolicAddnewWindow:GetHeight())/2);
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------
	textBoxSlots = Turbine.UI.Lotro.TextBox();
	textBoxSlots:SetParent( AltHolicAddnewWindow );
	textBoxSlots:SetSize(200, 40); 
	textBoxSlots:SetPosition(50, 50);
	textBoxSlots:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxSlots:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxSlots:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));	
	textBoxSlots:SetVisible(true);

	buttonValider = Turbine.UI.Lotro.GoldButton();
	buttonValider:SetParent( AltHolicAddnewWindow );
	buttonValider:SetPosition(AltHolicAddnewWindow:GetWidth()/2 - 100, AltHolicAddnewWindow:GetHeight() - 40);
	buttonValider:SetSize( 200, 20 );
	buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonValider:SetText( T[ "PluginAddNew2" ] );
	buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValider:SetVisible(true);
	buttonValider:SetMouseVisible(true);

	ValidateChangesAddNew();
end
------------------------------------------------------------------------------------------
-- function for the button
------------------------------------------------------------------------------------------
function ValidateChangesAddNew()
	buttonValider.MouseClick = function(sender, args)
		settings["nameAccount"]["account1"] = { 
				name = textBoxSlots:GetText(), 
				nbrAlt = 0;
				};

		AltHolicAddnewWindow:SetVisible(false);

		if(settings["nameAccount"]["account1"]["name"] ~= "")then
			settings["nameAccount"]["account1"]["nbrAlt"] = settings["nameAccount"]["account1"]["nbrAlt"] + 1;

			settings["nameAccount"]["account1"]["isVisible"] = true;
		end

		AltHolicAddnewWindow:SetVisible(false);
		
		SavePlayerDatas();
		SavePlayerEquipment();
		SavePlayerBags();
		SavePlayerVault();

		UpdateMainWindow();

		AltHolicWindow:SetVisible(true);
	end
end