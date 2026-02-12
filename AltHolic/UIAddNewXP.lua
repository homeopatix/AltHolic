------------------------------------------------------------------------------------------
-- UIAddNewXP file
-- Written by Homeopatix
-- 17 Decembre 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIAddNewXP(namePlayerToshow)	
	UIAddNewXP=Turbine.UI.Lotro.GoldWindow(); 
	UIAddNewXP:SetSize(300, 120); 
	UIAddNewXP:SetText(T[ "PluginXPWindow2" ] .. " " .. namePlayerToshow); 
	UIAddNewXP:SetPosition((Turbine.UI.Display:GetWidth()-UIAddNewXP:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIAddNewXP:GetHeight())/2); 
	UIAddNewXP:SetZOrder(100); 
	UIAddNewXP:SetWantsKeyEvents(true); 

	UIAddNewXP.Message=Turbine.UI.Label(); 
	UIAddNewXP.Message:SetParent(UIAddNewXP); 
	UIAddNewXP.Message:SetSize(300, 20); 
	UIAddNewXP.Message:SetPosition(UIAddNewXP:GetWidth()/2 - 150, UIAddNewXP:GetHeight()/2 - 25 ); 
	UIAddNewXP.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIAddNewXP.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	UIAddNewXP.Message:SetForeColor(Turbine.UI.Color.Gold);
	UIAddNewXP.Message:SetText(T[ "PluginXPWindow3" ]); 

	LabelLotroCoins=Turbine.UI.Label(); 
	LabelLotroCoins:SetParent(UIAddNewXP); 
	LabelLotroCoins:SetSize(32, 32); 
	LabelLotroCoins:SetPosition(230, UIAddNewXP:GetHeight()/2 - 27 ); 
	LabelLotroCoins:SetBackground(0x411A3870);
	LabelLotroCoins:SetZOrder(10);
	LabelLotroCoins:SetBlendMode( Turbine.UI.BlendMode.Overlay );
  
	textBoxLines = Turbine.UI.Lotro.TextBox();
	textBoxLines:SetParent( UIAddNewXP );
	textBoxLines:SetSize(150, 30); 
	textBoxLines:SetText( "" ); 
	textBoxLines:SetPosition(UIAddNewXP:GetWidth()/2 - 75, UIAddNewXP:GetHeight()/2 - 5);
	textBoxLines:SetVisible(true);
	textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLines:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxLines:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));


	buttonValider = Turbine.UI.Lotro.GoldButton();
	buttonValider:SetParent( UIAddNewXP );
	buttonValider:SetPosition(UIAddNewXP:GetWidth()/2 - 100, UIAddNewXP:GetHeight()/2 + 30);
	buttonValider:SetSize( 200, 20 );
	buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonValider:SetText( T[ "PluginWalletWindow7" ] );
	buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValider:SetVisible(true);
	buttonValider:SetMouseVisible(true);

	ValidateNewPlayerXP(namePlayerToshow);

	UIAddNewXP.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			UIAddNewXP:SetVisible(false);
		end
	end
end

function ValidateNewPlayerXP(namePlayerToshow)
	buttonValider.MouseClick = function(sender, args)
		PlayerXp[namePlayerToshow] = textBoxLines:GetText();
		UIAddNewXP:SetVisible(false);
		SavePlayerDatas();
		settings["isXPWindowVisible"]["value"] = true;
		CreateUIShowXP(namePlayerToshow);
		UIShowXP:SetVisible(true);
	end
end