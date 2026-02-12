------------------------------------------------------------------------------------------
-- UIAddNew file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the add new account window
------------------------------------------------------------------------------------------
function CreateToBeSurWindow(nameToDelete, valueToDelete)
	ToBeSurWindow=Turbine.UI.Lotro.GoldWindow(); 
	ToBeSurWindow:SetSize(400,200); 
	ToBeSurWindow:SetText(T[ "DeleteWindowName" ]); 
	ToBeSurWindow.Message=Turbine.UI.Label(); 
	ToBeSurWindow.Message:SetParent(ToBeSurWindow); 
	ToBeSurWindow.Message:SetSize(150,10); 
	ToBeSurWindow.Message:SetPosition(ToBeSurWindow:GetWidth()/2 - 75, ToBeSurWindow:GetHeight() - 20); 
	ToBeSurWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	ToBeSurWindow.Message:SetText(T[ "PluginText" ]); 
	ToBeSurWindow:SetZOrder(1);
	ToBeSurWindow:SetWantsKeyEvents(true);
	ToBeSurWindow:SetVisible(false);

	ToBeSurWindow:SetPosition((Turbine.UI.Display:GetWidth()-ToBeSurWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-ToBeSurWindow:GetHeight())/2);
	------------------------------------------------------------------------------------------
	-- center window
	------------------------------------------------------------------------------------------
	Texte1 = Turbine.UI.Label();
	Texte1:SetParent(ToBeSurWindow); 
	Texte1:SetSize(250, 50); 
	Texte1:SetPosition(ToBeSurWindow:GetWidth()/2 - 125, 45); 
	Texte1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);  
	Texte1:SetForeColor(Turbine.UI.Color.Gold); 
	Texte1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	if(valueToDelete == 1)then
		Texte1:SetText(T[ "DeleteTextAndName" ] .. tostring(nameToDelete) .. " ?");
	elseif(valueToDelete == 2)then
		Texte1:SetText(T[ "DeleteTextAll" ] .. " ?");
	end
	Texte1:SetZOrder(1);

	buttonValiderYes = Turbine.UI.Lotro.GoldButton();
	buttonValiderYes:SetParent( ToBeSurWindow );
	buttonValiderYes:SetPosition(ToBeSurWindow:GetWidth()/2 - 150, ToBeSurWindow:GetHeight() - 70);
	buttonValiderYes:SetSize( 100, 40 );
	buttonValiderYes:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	buttonValiderYes:SetForeColor(Turbine.UI.Color.Green);
	buttonValiderYes:SetText( T[ "DeleteYes" ] );
	buttonValiderYes:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValiderYes:SetVisible(true);
	buttonValiderYes:SetMouseVisible(true);

	buttonValiderNo = Turbine.UI.Lotro.GoldButton();
	buttonValiderNo:SetParent( ToBeSurWindow );
	buttonValiderNo:SetPosition(ToBeSurWindow:GetWidth()/2 + 50, ToBeSurWindow:GetHeight() - 70);
	buttonValiderNo:SetSize( 100, 40 );
	buttonValiderNo:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	buttonValiderNo:SetForeColor(Turbine.UI.Color.Red);
	buttonValiderNo:SetText( T[ "DeleteNo" ] );
	buttonValiderNo:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValiderNo:SetVisible(true);
	buttonValiderNo:SetMouseVisible(true);

	ValidateChangesToBeSur(nameToDelete, valueToDelete);

	EscapeKeyHandlerForWindows(ToBeSurWindow, settings["isToBeSurWindowVisible"]["value"]);
end
------------------------------------------------------------------------------------------
-- function for the button
------------------------------------------------------------------------------------------
function ValidateChangesToBeSur(nameToDelete, valueToDelete)
	buttonValiderYes.MouseClick = function(sender, args)
		if(valueToDelete == 1)then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginClear" ] .. nameToDelete);
			ClearPlayer(nameToDelete);
			ToBeSurWindow:SetVisible(false);
		elseif(valueToDelete == 2)then
			Write(rgb["start"] .. T[ "PluginName" ] .. rgb["clear"] .. " - " .. T[ "PluginClearAll" ]);
			ClearAllPlayer();
			ToBeSurWindow:SetVisible(false);
		end
	end

	buttonValiderNo.MouseClick = function(sender, args)
		ToBeSurWindow:SetVisible(false);
		settings["isToBeSurWindowVisible"]["value"] = false;
	end
end