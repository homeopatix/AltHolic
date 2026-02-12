------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowLvlEquip(namePlayerToshow, itemName)	
	UIShowLvlEquip=Turbine.UI.Lotro.GoldWindow(); 
	UIShowLvlEquip:SetSize(350, 170); 
	if(itemName == "Head")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement5" ]);
	elseif(itemName == "Chest")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement6" ]);
	elseif(itemName == "Legs")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement7" ]);
	elseif(itemName == "Gloves")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement8" ]);
	elseif(itemName == "Boots")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement9" ]);
	elseif(itemName == "Shoulder")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement10" ]);
	elseif(itemName == "Back")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement11" ]);
	elseif(itemName == "Bracelet1")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement12" ]);
	elseif(itemName == "Bracelet2")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement13" ]);
	elseif(itemName == "Necklace")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement14" ]);
	elseif(itemName == "Ring1")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement15" ]);
	elseif(itemName == "Ring2")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement16" ]);
	elseif(itemName == "Earring1")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement17" ]);
	elseif(itemName == "Earring2")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement18" ]);
	elseif(itemName == "Pocket")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement19" ]);
	elseif(itemName == "PrimaryWeapon")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement20" ]);
	elseif(itemName == "Shield")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement21" ]);
	elseif(itemName == "RangedWeapon")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement22" ]);
	elseif(itemName == "CraftTool")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement23" ]);
	elseif(itemName == "ClassE")then
		UIShowLvlEquip:SetText(T[ "PluginEquipement24" ]);
	end
	UIShowLvlEquip:SetPosition((Turbine.UI.Display:GetWidth()-UIShowLvlEquip:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowLvlEquip:GetHeight())/2); 
	UIShowLvlEquip:SetZOrder(100);
	UIShowLvlEquip:SetWantsKeyEvents(true); 

	UIShowLvlEquip.Message=Turbine.UI.Label(); 
	UIShowLvlEquip.Message:SetParent(UIShowLvlEquip); 
	UIShowLvlEquip.Message:SetSize(300, 20); 
	UIShowLvlEquip.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowLvlEquip.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowLvlEquip.Message:SetForeColor(Turbine.UI.Color.Gold);
	UIShowLvlEquip.Message:SetText(T[ "PluginEquipement3" ]); 

	textBoxLines1 = Turbine.UI.Lotro.TextBox();
	textBoxLines1:SetParent( UIShowLvlEquip );
	textBoxLines1:SetSize(150, 30); 
	textBoxLines1:SetText(""); 
	textBoxLines1:SetVisible(true);
	textBoxLines1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLines1:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxLines1:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

	UIShowLvlEquip.MessageArmor=Turbine.UI.Label(); 
	UIShowLvlEquip.MessageArmor:SetParent(UIShowLvlEquip); 
	UIShowLvlEquip.MessageArmor:SetSize(300, 20); 
	UIShowLvlEquip.MessageArmor:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 ); 
	UIShowLvlEquip.MessageArmor:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowLvlEquip.MessageArmor:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	UIShowLvlEquip.MessageArmor:SetForeColor(Turbine.UI.Color.Gold);

	textBoxLines2 = Turbine.UI.Lotro.TextBox();
	textBoxLines2:SetParent( UIShowLvlEquip );
	textBoxLines2:SetSize(150, 30); 
	textBoxLines2:SetText(""); 
	textBoxLines2:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 + 20);
	textBoxLines2:SetVisible(true);
	textBoxLines2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLines2:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxLines2:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

	if(itemName == "PrimaryWeapon" or
		itemName == "RangedWeapon")then
		if(PlayerEquipement[namePlayerToshow][itemName].CAT == 19 or
		PlayerEquipement[namePlayerToshow][itemName].CAT == 11 or
		PlayerEquipement[namePlayerToshow][itemName].CAT == 48 or
		PlayerEquipement[namePlayerToshow][itemName].CAT == 13 or
		PlayerEquipement[namePlayerToshow][itemName].CAT == 106)then
			UIShowLvlEquip.Message:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 - 25 ); 
			textBoxLines1:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 + 5);
			UIShowLvlEquip.MessageArmor:SetText(""); 
			textBoxLines2:SetVisible(false);
		else
			UIShowLvlEquip.Message:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 - 55 ); 
			textBoxLines1:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 - 35);
			UIShowLvlEquip.MessageArmor:SetText(T[ "PluginEquipement25" ]);
			textBoxLines2:SetVisible(true);
		end
	elseif(itemName == "Shield")then
		UIShowLvlEquip.Message:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 - 55 ); 
		textBoxLines1:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 - 35);
		if(PlayerEquipement[namePlayerToshow][itemName].CAT == 33)then
			UIShowLvlEquip.MessageArmor:SetText(T[ "PluginEquipement4" ]); 
		else
			UIShowLvlEquip.MessageArmor:SetText(T[ "PluginEquipement25" ]); 
		end
		textBoxLines2:SetVisible(true);
	elseif(itemName == "Bracelet1" or
		itemName == "Bracelet2" or
		itemName == "Earring1" or
		itemName == "Earring2" or
		itemName == "Ring1" or
		itemName == "Ring2" or
		itemName == "Necklace" or
		itemName == "CraftTool" or
		itemName == "ClassE" or
		itemName == "Pocket")then
		UIShowLvlEquip.Message:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 - 25 ); 
		textBoxLines1:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 + 5);
		UIShowLvlEquip.MessageArmor:SetText(""); 
		textBoxLines2:SetVisible(false);
	else
		UIShowLvlEquip.Message:SetPosition(UIShowLvlEquip:GetWidth()/2 - 150, UIShowLvlEquip:GetHeight()/2 - 55 ); 
		textBoxLines1:SetPosition(UIShowLvlEquip:GetWidth()/2 - 75, UIShowLvlEquip:GetHeight()/2 - 35);
		UIShowLvlEquip.MessageArmor:SetText(T[ "PluginEquipement4" ]);
		textBoxLines2:SetVisible(true);
	end


	buttonValider = Turbine.UI.Lotro.GoldButton();
	buttonValider:SetParent( UIShowLvlEquip );
	buttonValider:SetPosition(UIShowLvlEquip:GetWidth()/2 - 100, UIShowLvlEquip:GetHeight() - 30);
	buttonValider:SetSize( 200, 20 );
	buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonValider:SetText( T[ "PluginWalletWindow7" ] );
	buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValider:SetVisible(true);
	buttonValider:SetMouseVisible(true);

	ValidateNewLvlEquip(itemName);

	EscapeKeyHandlerForWindows(UIShowLvlEquip, settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"]);
end

function ValidateNewLvlEquip(i)
	buttonValider.MouseClick = function(sender, args)
		PlayerEquipItems[PlayerName][i] = tostring(textBoxLines1:GetText());
		PlayerEquipArmor[PlayerName][i] = tostring(textBoxLines2:GetText());
		SavePlayerLvlEquipment(i);
		UIShowLvlEquip:SetVisible(false);
		settings["isLvlEquipWindowVisible"]["isLvlEquipWindowVisible"] = false;
		UIShowEquip:SetVisible(false);
		CreateUIShowEquip(PlayerName, 1)
		settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = true;
		UIShowEquip:SetVisible(true);
	end
end