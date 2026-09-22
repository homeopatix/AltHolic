------------------------------------------------------------------------------------------
-- FCT_2 file
-- Written by Homeopatix
-- 8 decembre 2021
------------------------------------------------------------------------------------------
local posx = 0;
local posy = 0;
local alreadyDisplayed = 0;
------------------------------------------------------------------------------------------
-- Functions of the bars
------------------------------------------------------------------------------------------

local BAR_RACE_ICONS = {
    [81]  = { male = 0x4110894A, female = 0x41108949 },
    [23]  = { male = 0x41108945, female = 0x4110894B },
    [65]  = { male = 0x41108947, female = 0x41108948 },
    [114] = { male = 0x4115920D, female = 0x4115920A },
    [120] = { male = 0x411DAE7E, female = 0x411DAE7E },
    [73]  = { male = 0x41108946, female = 0x41108946 },
    [117] = { male = 0x411C8D6B, female = 0x411C8D6A },
    [125] = { male = 0x4110894A, female = 0x41108949 },
};

local BAR_MONSTER_RACES = { [7] = true, [12] = true, [6] = true, [66] = true };

local BAR_CLASS_ICONS = {
    [162] = 0x410095C2, [31] = 0x4110867A, [214] = 0x41153604,
    [24] = 0x410095C5, [193] = 0x4110867B, [40] = 0x410095BB,
    [185] = 0x410095BF, [23] = 0x410095B8, [172] = 0x410095B5,
    [194] = 0x41108673, [215] = 0x4120fcd9, [216] = 0x4122f860,
    [71] = "Faucheur.tga", [128] = "Profanateur.tga", [127] = "Araignee.tga",
    [179] = "FlecheNoire.tga", [52] = "ChefDeGuerre.tga", [126] = "Ouargue.tga",
};

local function SetBarTexture(control, texture)
    if texture == nil then return; end
    if type(texture) == "string" then
        control:SetBackground(ResourcePath .. texture);
    else
        control:SetBackground(texture);
    end
end

function DisplayNamePlayer_Bar()
	posx = 0;
	posy = 5;
------------------------------------------------------------------------------------------
	local LabelNameBar = Turbine.UI.Label();
	LabelNameBar:SetParent(AltHolicBar);
	LabelNameBar:SetPosition( posx, posy );
	LabelNameBar:SetSize( 150, 40 );
	LabelNameBar:SetText( PlayerName );
	LabelNameBar:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	LabelNameBar:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	LabelNameBar:SetForeColor(Turbine.UI.Color.Gold);
	--LabelNameBar:SetBackColor(Turbine.UI.Color.Red);
	LabelNameBar:SetZOrder(2);
	LabelNameBar:SetMouseVisible(true);
------------------------------------------------------------------------------------------
-- Display the label info
------------------------------------------------------------------------------------------
	local ButtonPlusInfosBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusInfosBar:SetParent( AltHolicBar );
	ButtonPlusInfosBar:SetPosition(screenWidth/2 - 190 , screenHeight/2 - 180);
	ButtonPlusInfosBar:SetSize( 380, 360 );
	ButtonPlusInfosBar:SetVisible(false);
	ButtonPlusInfosBar:SetZOrder(20);

	local textBoxLinesPopUpBar = Turbine.UI.Lotro.TextBox();
	textBoxLinesPopUpBar:SetParent( ButtonPlusInfosBar );
	textBoxLinesPopUpBar:SetSize(380, 360); 
	if(PlayerInfos[PlayerName] == nil or PlayerInfos[PlayerName].info == "")then
		textBoxLinesPopUpBar:SetText( "" );
	else
		textBoxLinesPopUpBar:SetText( PlayerInfos[PlayerName].info );
	end
	textBoxLinesPopUpBar:SetPosition(0, 0);
	textBoxLinesPopUpBar:SetVisible(true);
	textBoxLinesPopUpBar:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLinesPopUpBar:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxLinesPopUpBar:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

	LabelNameBar.MouseClick = function()
		if InfoWindow ~= nil and InfoWindow:IsVisible() then
			InfoWindow:SetVisible(false);
			settings["isInfoWindowVisible"]["value"] = false;
		else
			GenerateInfosWindow(PlayerName);
			settings["isInfoWindowVisible"]["value"] = true;
			InfoWindow:SetVisible(true);
		end
	end

	if(PlayerDatas[PlayerName].align == 1)then
		LabelNameBar.MouseEnter = function()
			if(PlayerInfos[PlayerName] ~= nil and PlayerInfos[PlayerName].info ~= "")then
				ButtonPlusInfosBar:SetVisible(true);
			end
		end

		LabelNameBar.MouseLeave = function()
			ButtonPlusInfosBar:SetVisible(false);
		end
	end
------------------------------------------------------------------------------------------
end

function SetPosX(posXPassed)
	local posxToReturn = posXPassed;

	--Write("PosX : " .. posx);

	if(posXPassed == 0 or posXPassed == nil)then
		posxToReturn = posxToReturn + 220;
	else
		if(settings["displayLvlMax"]["value"] == true)then
			posxToReturn = posxToReturn + 40;
		end
	end
	

	return posxToReturn;
end

function DisplayLvlPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
	local LabelPlayerLVL = Turbine.UI.Label();
	LabelPlayerLVL:SetParent(AltHolicBar);
	LabelPlayerLVL:SetPosition( posx, posy );
	LabelPlayerLVL:SetSize( 32, 32 );
	LabelPlayerLVL:SetText( tostring(PlayerDatas[PlayerName].lvl) );
	LabelPlayerLVL:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	LabelPlayerLVL:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	if(settings["displayLvlMax"]["value"] == true)then
		if(PlayerDatas[PlayerName].lvl == LevelMax)then
			LabelPlayerLVL:SetForeColor(Turbine.UI.Color.Red);
			LabelPlayerLVL:SetBackground(0x4111219A);
		else
			LabelPlayerLVL:SetForeColor(Turbine.UI.Color.Lime);
			LabelPlayerLVL:SetBackground(0x4111219B);
		end
	else
		LabelPlayerLVL:SetForeColor(Turbine.UI.Color.Lime);
		LabelPlayerLVL:SetBackground(0x4111219B);
	end
	--LabelPlayerLVL:SetBackColor(Turbine.UI.Color.Green);
	LabelPlayerLVL:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	LabelPlayerLVL:SetZOrder(2);
	LabelPlayerLVL:SetMouseVisible(true);
	------------------------------------------------------------------------------------------
	-- Functions to display the small label
	------------------------------------------------------------------------------------------
	local ButtonPlusStatsBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusStatsBar:SetParent( AltHolicBar );
	ButtonPlusStatsBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusStatsBar:SetSize( 180, 30 );
	ButtonPlusStatsBar:SetVisible(false);
	ButtonPlusStatsBar:SetZOrder(40);
	ButtonPlusStatsBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelStatsBar = Turbine.UI.Label();
	centerLabelStatsBar:SetParent(ButtonPlusStatsBar);
	centerLabelStatsBar:SetPosition( 2, 2 );
	centerLabelStatsBar:SetSize( 176, 26  );
	centerLabelStatsBar:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelStatsBar:SetText( T[ "PluginStats11" ] );
	centerLabelStatsBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelStatsBar:SetZOrder(41);
	centerLabelStatsBar:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	if(PlayerDatas[PlayerName].align == 1)then
		LabelPlayerLVL.MouseEnter = function()
			ButtonPlusStatsBar:SetVisible(true);
		end

		LabelPlayerLVL.MouseLeave = function()
			ButtonPlusStatsBar:SetVisible(false);
		end
	end

	LabelPlayerLVL.MouseClick = function()
		CreateUIShowStats(PlayerName);
		if(settings["isShowStatsVisible"]["isShowStatsVisible"] == false)then
			settings["isShowStatsVisible"]["isShowStatsVisible"] = true;
			UIShowStats:SetVisible(true);
		else
			settings["isShowStatsVisible"]["isShowStatsVisible"] = false;
			UIShowStats:SetVisible(false);
		end
	end
	------------------------------------------------------------------------------------------
end
function DisplayXPWindow_Bar()
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
	--function to display the XP window --
	------------------------------------------------------------------------------------------

	local buttonDefineXPTotalBar = Turbine.UI.Label();
	buttonDefineXPTotalBar:SetParent( AltHolicBar );
	buttonDefineXPTotalBar:SetPosition( posx, posy );
	buttonDefineXPTotalBar:SetSize( 32, 32  );
	buttonDefineXPTotalBar:SetBackground(0x411A3870);
	buttonDefineXPTotalBar:SetVisible(true);
	--buttonDefineXPTotalBar:SetBackColor(Turbine.UI.Color.Red);
	buttonDefineXPTotalBar:SetZOrder(30);
	buttonDefineXPTotalBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	buttonDefineXPTotalBar:SetMouseVisible(true);


	local ButtonPlusXPBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusXPBar:SetParent( AltHolicBar );
	ButtonPlusXPBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusXPBar:SetSize( 180, 30 );
	ButtonPlusXPBar:SetVisible(false);
	ButtonPlusXPBar:SetZOrder(20);
	ButtonPlusXPBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLabXPBar = Turbine.UI.Label();
	centerLabelBLabXPBar:SetParent(ButtonPlusXPBar);
	centerLabelBLabXPBar:SetPosition( 2, 2 );
	centerLabelBLabXPBar:SetSize( 176, 26  );
	centerLabelBLabXPBar:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLabXPBar:SetText( T[ "PluginXPWindow1" ] );
	centerLabelBLabXPBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabXPBar:SetZOrder(21);
	centerLabelBLabXPBar:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	buttonDefineXPTotalBar.MouseEnter = function()
		ButtonPlusXPBar:SetVisible(true);
	end

	buttonDefineXPTotalBar.MouseLeave = function()
		ButtonPlusXPBar:SetVisible(false);
	end

	buttonDefineXPTotalBar.MouseClick = function()
		CreateUIShowXP();
		if(settings["isXPWindowVisible"]["value"] == false)then
			settings["isXPWindowVisible"]["value"] = true;
			UIShowXP:SetVisible(true);
		else
			settings["isXPWindowVisible"]["value"] = false;
			UIShowXP:SetVisible(false);
		end
	end
end

function DisplayClassPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
	--- define race
	------------------------------------------------------------------------------------------
	local centerLabelB5Bar = Turbine.UI.Label();
	centerLabelB5Bar:SetParent(AltHolicBar);
	centerLabelB5Bar:SetPosition( posx, posy );
	centerLabelB5Bar:SetSize( 32, 32  );
	centerLabelB5Bar:SetZOrder(2);
	centerLabelB5Bar:SetMouseVisible(true);
	centerLabelB5Bar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		local playerData = PlayerDatas[PlayerName];
		local raceId = playerData.rac;
		if BAR_MONSTER_RACES[raceId] then
			centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor_red.tga");
		else
			local raceIcons = BAR_RACE_ICONS[raceId];
			if raceIcons ~= nil then
				centerLabelB5Bar:SetBackground(raceIcons[playerData.sexe] or raceIcons.male or raceIcons.female);
			end
		end
	end
	------------------------------------------------------------------------------------------
	--- define race label
	------------------------------------------------------------------------------------------
	local ButtonPlusSexeBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusSexeBar:SetParent( AltHolicBar );
	ButtonPlusSexeBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusSexeBar:SetSize( 180, 30 );
	ButtonPlusSexeBar:SetVisible(false);
	ButtonPlusSexeBar:SetZOrder(20);
	ButtonPlusSexeBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelSexe = Turbine.UI.Label();
	centerLabelSexe:SetParent(ButtonPlusSexeBar);
	centerLabelSexe:SetPosition( 2, 2 );
	centerLabelSexe:SetSize( 176, 26  );
	centerLabelSexe:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelSexe:SetText( T[ "reputposition100" ] ); -- reputations
	centerLabelSexe:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelSexe:SetZOrder(21);
	centerLabelSexe:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	if(PlayerDatas[PlayerName].align == 1)then
		centerLabelB5Bar.MouseEnter = function()
			ButtonPlusSexeBar:SetVisible(true);
		end

		centerLabelB5Bar.MouseLeave = function()
			ButtonPlusSexeBar:SetVisible(false);
		end
	end

	if(PlayerDatas[PlayerName].align == 1)then
		centerLabelB5Bar.MouseClick = function()
			CreateUIShowReput(PlayerName);
			if(settings["isReputWindowVisible"]["isReputWindowVisible"] == false)then
				settings["isReputWindowVisible"]["isReputWindowVisible"] = true;
				UIShowReput:SetVisible(true);
			else
				settings["isReputWindowVisible"]["isReputWindowVisible"] = false;
				UIShowReput:SetVisible(false);
			end
		end
	end
 ------------------------------------------------------------------------------------------
end

function DisplayRacePlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
	--- define classe
	------------------------------------------------------------------------------------------
	local LabelClasseBar = Turbine.UI.Control();
	LabelClasseBar:SetParent(AltHolicBar);
	LabelClasseBar:SetPosition( posx, posy );
	LabelClasseBar:SetSize( 32, 32  );
	LabelClasseBar:SetZOrder(2);
	LabelClasseBar:SetMouseVisible(true);
	LabelClasseBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	------------------------------------------------------------------------------------------
	-- display the class of the players
	------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		SetBarTexture(LabelClasseBar, BAR_CLASS_ICONS[PlayerDatas[PlayerName].cla]);
	end
	-----------------------------------------------------------------------------------------
	-- display the label of equipement
	------------------------------------------------------------------------------------------
	local ButtonEquipment = Turbine.UI.Extensions.SimpleWindow();
	ButtonEquipment:SetParent( AltHolicBar );
	ButtonEquipment:SetPosition(posx + 10 , posy + 40);
	ButtonEquipment:SetSize( 180, 30 );
	ButtonEquipment:SetVisible(false);
	ButtonEquipment:SetZOrder(20);
	ButtonEquipment:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local LabelEquipment = Turbine.UI.Label();
	LabelEquipment:SetParent(ButtonEquipment);
	LabelEquipment:SetPosition( 2, 2 );
	LabelEquipment:SetSize( 176, 26  );
	LabelEquipment:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	LabelEquipment:SetText( "Equipment" ); -- reputations
	LabelEquipment:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	LabelEquipment:SetZOrder(21);
	LabelEquipment:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	if(PlayerDatas[PlayerName].align == 1)then
		LabelClasseBar.MouseEnter = function()
			ButtonEquipment:SetVisible(true);
		end

		LabelClasseBar.MouseLeave = function()
			ButtonEquipment:SetVisible(false);
		end
	end

	LabelClasseBar.MouseClick = function()	
		SavePlayerEquipment();
		CreateUIShowEquip(PlayerName, PlayerDatas[PlayerName].align);
		if(settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] == true )then
			settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = false;
			UIShowEquip:SetVisible(false);
		else
			settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = true;
			UIShowEquip:SetVisible(true);
		end
	end
end

function DisplayServerPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
		--- display serverName
	------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["name"] ~= "")then 
		if(settings["displayServers"]["value"] == true)then
			local LabelServerBar=Turbine.UI.Label(); 
			LabelServerBar:SetParent(AltHolicBar); 
			LabelServerBar:SetSize(32,32); 
			LabelServerBar:SetPosition(posx, posy); 
			LabelServerBar:SetBackground(ResourcePath .. "Server_Icon.tga");
			LabelServerBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);
			LabelServerBar:SetZOrder(3);
			LabelServerBar:SetMouseVisible(true);

			if(ReturnValueServer(PlayerName) > 0)then
				local LabelServerNbrBar=Turbine.UI.Label(); 
				LabelServerNbrBar:SetParent(AltHolicBar); 
				LabelServerNbrBar:SetSize(25,20); 
				LabelServerNbrBar:SetPosition(posx, posy + 10); 
				LabelServerNbrBar:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
				LabelServerNbrBar:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
				LabelServerNbrBar:SetForeColor(Turbine.UI.Color.Red);
				LabelServerNbrBar:SetText(tostring(ReturnValueServer(PlayerName)));
				LabelServerNbrBar:SetZOrder(4);
				LabelServerNbrBar:SetMouseVisible(true);

				DisplayLabelServerNameForBar(posx + 10, posy + 40, LabelServerNbrBar);
			end
				
			DisplayLabelServerNameForBar(posx + 10, posy + 40, LabelServerBar);
		end
	end
end

function DisplayLabelServerNameForBar(posx, posy, buttonToDisplay)
	posx = SetPosX(posx);
	------------------------------------------------------------------------------------------
	-- display label server name
	------------------------------------------------------------------------------------------
	local ButtonPlusServerBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusServerBar:SetParent( AltHolicBar );
	ButtonPlusServerBar:SetPosition(posx , posy);
	ButtonPlusServerBar:SetSize( 180, 30 );
	ButtonPlusServerBar:SetVisible(false);
	ButtonPlusServerBar:SetZOrder(20);
	ButtonPlusServerBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelServerBar = Turbine.UI.Label();
	centerLabelServerBar:SetParent(ButtonPlusServerBar);
	centerLabelServerBar:SetPosition( 2, 2 );
	centerLabelServerBar:SetSize( 176, 26  );
	centerLabelServerBar:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelServerBar:SetText( PlayerDatas[PlayerName].serverName );
	centerLabelServerBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelServerBar:SetZOrder(21);
	centerLabelServerBar:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	buttonToDisplay.MouseEnter = function()
		ButtonPlusServerBar:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusServerBar:SetVisible(false);
	end

	buttonToDisplay.MouseClick = function()
		if ServerNameWindow ~= nil and ServerNameWindow:IsVisible() then
			ServerNameWindow:SetVisible(false);
			settings["isServerWindowVisible"]["value"] = false;
		else
			GenerateServerNameWindow(PlayerName);
			settings["isServerWindowVisible"]["value"] = true;
			ServerNameWindow:SetVisible(true);
		end
	end
end

function AddIfCashDisplayed(valor)
	if(alreadyDisplayed == 1)then
		if(settings["displayBarIcon6"]["value"] == true)then
			valor = valor + 160;
			alreadyDisplayed = 0;
		end
	end
	if(alreadyDisplayed == 2)then
		if(settings["displayBarIcon15"]["value"] == true)then
			valor = valor + 160;
			alreadyDisplayed = 0;
		end
	end
	--Write("alreadyDisplayed : " .. alreadyDisplayed);
	return valor;
end

local BAR_MONEY_PARTS = {
	{ texture = 0x41007e7b, color = Turbine.UI.Color.Gold, iconX = 0, textX = 30 },
	{ texture = 0x41007e7c, color = Turbine.UI.Color.Silver, iconX = 70, textX = 100 },
	{ texture = 0x41007e7d, color = Turbine.UI.Color(0.8, 0.4, 0.2), iconX = 140, textX = 170 },
};

local function DisplayMoneyOnBar(value, x, y)
	local gold, silver, copper = AltHolicUtil.MoneyParts(value);
	local values = { gold, silver, copper };

	for index, part in ipairs(BAR_MONEY_PARTS) do
		local icon = Turbine.UI.Label();
		icon:SetParent(AltHolicBar);
		icon:SetPosition(x + part.iconX, y + 5);
		icon:SetSize(27, 21);
		icon:SetVisible(true);
		icon:SetBackground(part.texture);
		icon:SetZOrder(-1);
		icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		local amount = Turbine.UI.Label();
		amount:SetParent(AltHolicBar);
		amount:SetSize(50, 30);
		amount:SetPosition(x + part.textX, y);
		amount:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		amount:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		amount:SetText(string.format("%.0f", values[index]));
		amount:SetForeColor(part.color);
	end
end

function DisplayCashOfPlayer_Bar()
	
	posx = SetPosX(posx);
	posy = 9;
	------------------------------------------------------------------------------------------
	-- cash displayer
	------------------------------------------------------------------------------------------
	local totalCash = 0;

	if(settings["nameAccount"]["account1"]["nbrAlt"] >= 1)then
		for i in pairs(PlayerDatas) do
			if(settings["serversToDisplay"]["value"] == PlayerDatas[i].serverName or 
				settings["serversToDisplay"]["value"] == T[ "ServerNamesAll" ] or 
				settings["serversToDisplay"]["value"] == "")then
						if(PlayerDatas[i].cash ~= nil)then
							totalCash = totalCash + PlayerDatas[i].cash ;
						end
						if(PlayerDatas[i].bagCash ~= nil)then
							totalCash = totalCash + PlayerDatas[i].bagCash;
						end
						if(PlayerDatas[i].vaultCash ~= nil)then
							totalCash = totalCash + PlayerDatas[i].vaultCash;
						end
			end
		end
		
		DisplayCashForBar(PlayerDatas[PlayerName].cash, posx, posy - 10);

		totalCash = totalCash + tonumber(settings["sharedStorageCash"]["value"]);

		DisplayCashForBar(totalCash, posx, posy + 10);
		alreadyDisplayed = 1;
	end
end

function DisplayCashForBar(totalCash, x, y)
	if totalCash == nil or totalCash == 0 then
		totalCash = PlayerAttr:GetMoney();
	end
	DisplayMoneyOnBar(totalCash, x, y);
end

function DisplayWalletButton_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- display wallet button
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then

		local buttonWalletBar = Turbine.UI.Control();
		buttonWalletBar:SetParent( AltHolicBar );
		buttonWalletBar:SetPosition(posx, posy);
		buttonWalletBar:SetSize( 32, 32 );
		buttonWalletBar:SetBackground(0x411D028B);
		buttonWalletBar:SetMouseVisible(true);
		buttonWalletBar:SetVisible(true);
		buttonWalletBar:SetZOrder(10);
		buttonWalletBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		buttonWalletBar.MouseClick = function()
			CreateUIShowWallet(PlayerName, "lines");
			if(settings["isShowWalletVisible"]["isShowWalletVisible"] == true )then
				settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
				UIShowWallet:SetVisible(false);
			else
				settings["isShowWalletVisible"]["isShowWalletVisible"] = true;
				UIShowWallet:SetVisible(true);
			end
		end
		local btnewlabel = Turbine.UI.Extensions.SimpleWindow();
		btnewlabel:SetParent( AltHolicBar );
		btnewlabel:SetPosition(posx + 20 , posy + 40);
		btnewlabel:SetSize( 180, 30 );
		btnewlabel:SetVisible(false);
		btnewlabel:SetZOrder(20);
		btnewlabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

		local btnewlabelText = Turbine.UI.Label();
		btnewlabelText:SetParent(btnewlabel);
		btnewlabelText:SetPosition( 2, 2 );
		btnewlabelText:SetSize( 176, 26  );
		btnewlabelText:SetFont(Turbine.UI.Lotro.Font.Verdana20);
		btnewlabelText:SetText( T[ "PluginSearch7" ] ); -- reputations
		btnewlabelText:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		btnewlabelText:SetZOrder(21);
		btnewlabelText:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

		buttonWalletBar.MouseEnter = function()
			btnewlabel:SetVisible(true);
		end

		buttonWalletBar.MouseLeave = function()
			btnewlabel:SetVisible(false);
		end
	end

end

function DisplayVaultButton_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- display vault button
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then


			local buttonVaultBar = Turbine.UI.Control();
			buttonVaultBar:SetParent( AltHolicBar );
			buttonVaultBar:SetPosition(posx, posy);
			buttonVaultBar:SetSize( 32, 32 );
			if(PlayerDatas[PlayerName].align == 1)then
				buttonVaultBar:SetBackground(0x410E76AE);
			end
			buttonVaultBar:SetMouseVisible(true);
			buttonVaultBar:SetVisible(true);
			buttonVaultBar:SetZOrder(10);
			buttonVaultBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

			buttonVaultBar.MouseClick = function()
				CreateUIShowVault(PlayerName, "lines");
				if(settings["isShowVaultVisible"]["isShowVaultVisible"] == true )then
					settings["isShowVaultVisible"]["isShowVaultVisible"] = false;
					UIShowVault:SetVisible(false);
				else
					settings["isShowVaultVisible"]["isShowVaultVisible"] = true;
					UIShowVault:SetVisible(true);
				end
			end
			local btnewlabelvault = Turbine.UI.Extensions.SimpleWindow();
			btnewlabelvault:SetParent( AltHolicBar );
			btnewlabelvault:SetPosition(posx + 20 , posy + 40);
			btnewlabelvault:SetSize( 180, 30 );
			btnewlabelvault:SetVisible(false);
			btnewlabelvault:SetZOrder(20);
			btnewlabelvault:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			local btnewlabelText = Turbine.UI.Label();
			btnewlabelText:SetParent(btnewlabelvault);
			btnewlabelText:SetPosition( 2, 2 );
			btnewlabelText:SetSize( 176, 26  );
			btnewlabelText:SetFont(Turbine.UI.Lotro.Font.Verdana20);
			btnewlabelText:SetText( T[ "PluginSearch4" ] ); -- reputations
			btnewlabelText:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			btnewlabelText:SetZOrder(21);
			btnewlabelText:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

			buttonVaultBar.MouseEnter = function()
				btnewlabelvault:SetVisible(true);
			end

			buttonVaultBar.MouseLeave = function()
				btnewlabelvault:SetVisible(false);
			end
	end

end

function DisplayBagButton_Bar()
	if(settings["displayBarBagSize"]["value"] == true)then
		posx = SetPosX(AddIfCashDisplayed(posx+40));
	else
		posx = SetPosX(AddIfCashDisplayed(posx));
	end
	posy = 9;
------------------------------------------------------------------------------------------
-- display bag button
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then
		
		local nbrItemsInBag = 0;
		for i in pairs(PlayerBags[PlayerName]) do
			nbrItemsInBag = nbrItemsInBag + 1 ;
		end
		local bagSize = backpack:GetSize();
		
		local BagsIcons = {0x410FC45F, --  ecplorateur 
						0x410F467E, --  joaillier
						0x410F4682, --  franc-tenancier
						0x410F4684, --  historien 
						0x410F4688, --  armurier
						0x410F4686, --  bucheron 
						0x410F4680}; --  feronnier

			local buttonBag = Turbine.UI.Control();
			buttonBag:SetParent( AltHolicBar );
			buttonBag:SetPosition(posx, posy);
			buttonBag:SetSize( 32, 32 );
			if(PlayerDatas[PlayerName].align == 1)then
				if(settings["displayClassBags"]["value"] == true)then
					if(PlayerDatas[PlayerName].voc == 0)then
						buttonBag:SetBackground(0x41105F73); -- no vocation bag
					else
						buttonBag:SetBackground(BagsIcons[PlayerDatas[PlayerName].voc]);
					end
				else
					buttonBag:SetBackground(0x410FC45F);
				end
			else
				buttonBag:SetBackground(0x410F4B84);  -- 0x410F2D43   ---   0x410F4B84 --- 0x4100E9EE
			end
			buttonBag:SetMouseVisible(true);
			buttonBag:SetVisible(true);
			buttonBag:SetZOrder(10);
			buttonBag:SetBlendMode(Turbine.UI.BlendMode.Overlay);

			if(settings["displayBarBagSize"]["value"] == true)then
				local buttonBagText = Turbine.UI.Label();
				buttonBagText:SetParent( AltHolicBar );
				buttonBagText:SetPosition(posx - 47, posy);
				buttonBagText:SetSize( 20, 40 );
				buttonBagText:SetText( nbrItemsInBag );
				buttonBagText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);  
				if((bagSize - nbrItemsInBag) <= 10)then
					buttonBagText:SetForeColor(Turbine.UI.Color.Red); 
				else
					buttonBagText:SetForeColor(Turbine.UI.Color.White); 
				end
				buttonBagText:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold14);
				--buttonBagText:SetBackColor(Turbine.UI.Color.Red);

				local buttonBagText2 = Turbine.UI.Label();
				buttonBagText2:SetParent( AltHolicBar );
				buttonBagText2:SetPosition(posx - 50, posy);
				buttonBagText2:SetSize( 50, 40 );
				buttonBagText2:SetText( "/" .. bagSize );
				buttonBagText2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);  
				buttonBagText2:SetForeColor(Turbine.UI.Color.White); 
				buttonBagText2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold14);
			end

			buttonBag.MouseClick = function()
				SavePlayerBags();
				CreateUIShowBag(PlayerName, "lines");
				if(settings["isShowBagVisible"]["isShowBagVisible"] == true )then
					settings["isShowBagVisible"]["isShowBagVisible"] = false;
					UIShowBag:SetVisible(false);
				else
					settings["isShowBagVisible"]["isShowBagVisible"] = true;
					UIShowBag:SetVisible(true);
				end
			end
			local btnewlabelbag = Turbine.UI.Extensions.SimpleWindow();
			btnewlabelbag:SetParent( AltHolicBar );
			btnewlabelbag:SetPosition(posx + 20 , posy + 40);
			btnewlabelbag:SetSize( 180, 30 );
			btnewlabelbag:SetVisible(false);
			btnewlabelbag:SetZOrder(20);
			btnewlabelbag:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			local btnewlabelText = Turbine.UI.Label();
			btnewlabelText:SetParent(btnewlabelbag);
			btnewlabelText:SetPosition( 2, 2 );
			btnewlabelText:SetSize( 176, 26  );
			btnewlabelText:SetFont(Turbine.UI.Lotro.Font.Verdana20);
			btnewlabelText:SetText( T[ "PluginSearch3" ] ); -- reputations
			btnewlabelText:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			btnewlabelText:SetZOrder(21);
			btnewlabelText:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

			buttonBag.MouseEnter = function()
				btnewlabelbag:SetVisible(true);
			end

			buttonBag.MouseLeave = function()
				btnewlabelbag:SetVisible(false);
			end
	end

end

function DisplayProfessions_Bar()
    posx = SetPosX(AddIfCashDisplayed(posx - 5));
    posy = 2;

    RefreshCurrentPlayerProfessions(PlayerName);
    local professions = GetSavedProfessions(PlayerName);

    -- Show up to four individual profession icons in a horizontal strip.
    -- The toolbar uses the same proven 32x32 profession textures as the popup,
    -- with stretch mode retained because LOTRO's file-path texture rendering is
    -- sensitive to this inside custom controls.
    local craftingBarIcons = {};
    local drawable = {};
    for index = 1, #professions do
        local iconFile = GetProfessionSmallIconFile(professions[index].Key, professions[index].Name);
        if iconFile ~= nil then table.insert(drawable, iconFile); end
        if #drawable >= 4 then break; end
    end

    -- Four 32px slots in a strip, filler tile for unused ones. 32x32 control with
    -- 32x32 texture: the only configuration that renders (see GetProfessionSmallIconFile).
    for index = 1, #drawable do
        local iconFile = drawable[index];

        local icon = Turbine.UI.Label();
        icon:SetParent(AltHolicBar);
        icon:SetPosition(posx + ((index - 1) * 32), posy + 6);
        icon:SetSize(32, 32);
        icon:SetZOrder(5);
        icon:SetMouseVisible(false);
        icon:SetVisible(true);
        icon:SetBackground(ResourcePath .. iconFile);
        icon:SetStretchMode(1);
        craftingBarIcons[index] = icon;
    end

    -- The strip is 128px wide but the bar's layout chain only advances 40px per
    -- element, so reserve the difference before the next icon is placed.
    posx = posx + 88;

    DisplayProfessionTooltipForBar(T[ "PluginCrafting" ] or "Crafting");
end

function DisplayProfessionTooltipForBar(texte)
    RefreshCurrentPlayerProfessions(PlayerName);
    local professions = GetSavedProfessions(PlayerName);

    local hoverControl = Turbine.UI.Control();
    hoverControl:SetParent(AltHolicBar);
    hoverControl:SetPosition(posx, 2);
    hoverControl:SetSize(45, 45);
    hoverControl:SetVisible(true);
    hoverControl:SetZOrder(19);
    hoverControl:SetMouseVisible(true);

    local popup = Turbine.UI.Extensions.SimpleWindow();
    popup:SetParent(AltHolicBar);
    popup:SetSize(380, 420);
    popup:SetPosition(
        (Turbine.UI.Display:GetWidth() - popup:GetWidth()) / 2,
        (Turbine.UI.Display:GetHeight() - popup:GetHeight()) / 2
    );
    popup:SetVisible(false);
    popup:SetZOrder(100);
    popup:SetBackground(ResourcePath .. "/Cadre_380_420.tga");

    local titleLabel = Turbine.UI.Label();
    titleLabel:SetParent(popup);
    titleLabel:SetPosition(40, 5);
    titleLabel:SetSize(300, 30);
    titleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
    titleLabel:SetText(texte or "Crafting");
    titleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    titleLabel:SetZOrder(101);
    titleLabel:SetForeColor(Turbine.UI.Color.Gold);

    local startY = 48;
    local rowHeight = 88;
    local visibleCount = math.min(#professions, 4);

    if visibleCount > 0 then
        for x = 1, visibleCount do
            local profession = professions[x];
            local rowY = startY + ((x - 1) * rowHeight);

            local nameLabel = Turbine.UI.Label();
            nameLabel:SetParent(popup);
            nameLabel:SetPosition(65, rowY);
            nameLabel:SetSize(280, 24);
            nameLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
            nameLabel:SetText(profession.Name or "Unknown profession");
            nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            nameLabel:SetZOrder(102);

            local icon = Turbine.UI.Label();
            icon:SetParent(popup);
            icon:SetPosition(25, rowY);
            icon:SetSize(32, 32);
            icon:SetZOrder(102);
            icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
            local iconFile = profession.Icon or GetProfessionIconFile(profession.Key, profession.Name);
            if iconFile ~= nil then
                icon:SetBackground(ResourcePath .. iconFile);
                icon:SetStretchMode(2);
            end

            local proficiency = Turbine.UI.Label();
            proficiency:SetParent(popup);
            proficiency:SetPosition(65, rowY + 23);
            proficiency:SetSize(285, 30);
            proficiency:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            proficiency:SetText(profession.CurrentLvl or "");
            proficiency:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            proficiency:SetZOrder(102);
            proficiency:SetForeColor(Turbine.UI.Color(0.8, 0.4, 0.2));

            local mastery = Turbine.UI.Label();
            mastery:SetParent(popup);
            mastery:SetPosition(65, rowY + 50);
            mastery:SetSize(285, 30);
            mastery:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            mastery:SetText(profession.CurrentMastery or "");
            mastery:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            mastery:SetZOrder(102);
            mastery:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));
        end
    else
        local noData = Turbine.UI.Label();
        noData:SetParent(popup);
        noData:SetPosition(40, 100);
        noData:SetSize(300, 100);
        noData:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        noData:SetText(T[ "PluginStats10" ] or "No crafting data saved.");
        noData:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        noData:SetZOrder(102);
    end

    local recipeTrackerIsInstalled = AltHolicUtil.IsPluginAvailable("RecipeTracker v2");

    if recipeTrackerIsInstalled == true then
        local releaseWindow = Turbine.UI.Extensions.SimpleWindow();
        releaseWindow:SetSize(45, 45);
        releaseWindow:SetParent(hoverControl);
        releaseWindow:SetPosition(0, 0);
        releaseWindow:SetOpacity(0);
        releaseWindow:SetVisible(true);

        local releaseQSBack = Turbine.UI.Control();
        releaseQSBack:SetParent(releaseWindow);
        releaseQSBack:SetZOrder(-1);
        releaseQSBack:SetSize(45, 45);

        local releaseQS = Turbine.UI.Lotro.Quickslot();
        releaseQS:SetParent(releaseQSBack);
        releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "/recipetracker show"));
        releaseQS:SetSize(45, 45);
        releaseQS:SetPosition(0, 0);
        releaseQS:SetAllowDrop(false);
        releaseQS:SetOpacity(0);
        releaseQS:SetZOrder(-1);
    end

    hoverControl.MouseEnter = function()
        popup:SetVisible(true);
    end

    hoverControl.MouseLeave = function()
        popup:SetVisible(false);
    end
end



function DisplaySharedStorage_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- sharedstorage
------------------------------------------------------------------------------------------
	local centerLabelIsVisibleSS = Turbine.UI.Label();
	centerLabelIsVisibleSS:SetParent(AltHolicBar);
	centerLabelIsVisibleSS:SetPosition( posx, posy );
	centerLabelIsVisibleSS:SetSize( 32, 32  );
	centerLabelIsVisibleSS:SetBackground(0x4111BE35); -- sharedstorage
	centerLabelIsVisibleSS:SetZOrder(2);
	centerLabelIsVisibleSS:SetMouseVisible(true);
	centerLabelIsVisibleSS:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	local ButtonPlusLab = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab:SetParent( AltHolicBar );
	ButtonPlusLab:SetPosition(posx + 10 , posy + 40);
	ButtonPlusLab:SetSize( 180, 30 );
	ButtonPlusLab:SetVisible(false);
	ButtonPlusLab:SetZOrder(20);
	ButtonPlusLab:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLab = Turbine.UI.Label();
	centerLabelBLab:SetParent(ButtonPlusLab);
	centerLabelBLab:SetPosition( 2, 2 );
	centerLabelBLab:SetSize( 176, 26  );
	centerLabelBLab:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLab:SetText( T[ "PluginSharedStorage1" ] );
	centerLabelBLab:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLab:SetZOrder(21);
	centerLabelBLab:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	centerLabelIsVisibleSS.MouseEnter = function()
		ButtonPlusLab:SetVisible(true);
	end

	centerLabelIsVisibleSS.MouseLeave = function()
		ButtonPlusLab:SetVisible(false);
	end

	centerLabelIsVisibleSS.MouseClick = function()
		CreateUIShowSharedStorage("lines");
		if(settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] == true)then
			settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = false;
			UIShowSharedStorage:SetVisible(false);
		else
			UIShowSharedStorage:SetVisible(true);
			settings["isShowSharedStorageVisible"]["isShowSharedStorageVisible"] = true;	
		end
	end
end

function DisplayEpiqueBook_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- book button for epique window
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["name"] ~= "")then

		local centerLabelForEpiqueWindow = Turbine.UI.Label();
		centerLabelForEpiqueWindow:SetParent(AltHolicBar);
		centerLabelForEpiqueWindow:SetPosition( posx, posy );
		centerLabelForEpiqueWindow:SetSize( 32, 32  );
		centerLabelForEpiqueWindow:SetBackground(0x41139D6B); -- nice epique book
		centerLabelForEpiqueWindow:SetZOrder(2);
		centerLabelForEpiqueWindow:SetMouseVisible(true);
		centerLabelForEpiqueWindow:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		local ButtonPlusLab28 = Turbine.UI.Extensions.SimpleWindow();
		ButtonPlusLab28:SetParent( AltHolicBar );
		ButtonPlusLab28:SetPosition(posx + 10 , posy + 40);
		ButtonPlusLab28:SetSize( 180, 30 );
		ButtonPlusLab28:SetVisible(false);
		ButtonPlusLab28:SetZOrder(20);
		ButtonPlusLab28:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

		local centerLabelBLab = Turbine.UI.Label();
		centerLabelBLab:SetParent(ButtonPlusLab28);
		centerLabelBLab:SetPosition( 2, 2 );
		centerLabelBLab:SetSize( 176, 26  );
		centerLabelBLab:SetFont(Turbine.UI.Lotro.Font.Verdana20);
		centerLabelBLab:SetText( T[ "PluginEpiqueWindow1" ] );
		centerLabelBLab:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelBLab:SetZOrder(21);
		centerLabelBLab:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

		centerLabelForEpiqueWindow.MouseEnter = function()
			ButtonPlusLab28:SetVisible(true);
		end

		centerLabelForEpiqueWindow.MouseLeave = function()
			ButtonPlusLab28:SetVisible(false);
		end

		centerLabelForEpiqueWindow.MouseClick = function()
			CreateUIShowEpique();
			if(settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] == true )then
				settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = false;
				UIShowEpique:SetVisible(false);
			else
				settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = true;
				UIShowEpique:SetVisible(true);
			end
		end
	end
end

function DisplayLoupe_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- search loupe -- search loupe not over = 0x410D6DC4
------------------------------------------------------------------------------------------
	local centerLabelIsVisibleSearchBar = Turbine.UI.Label();
	centerLabelIsVisibleSearchBar:SetParent(AltHolicBar);
	centerLabelIsVisibleSearchBar:SetPosition( posx, posy );
	centerLabelIsVisibleSearchBar:SetSize( 32, 32  );
	centerLabelIsVisibleSearchBar:SetBackground(0x410D6DC2); 
	centerLabelIsVisibleSearchBar:SetZOrder(2);
	centerLabelIsVisibleSearchBar:SetMouseVisible(true);
	centerLabelIsVisibleSearchBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	local ButtonPlusLab3Bar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab3Bar:SetParent( AltHolicBar );
	ButtonPlusLab3Bar:SetPosition(posx + 10 , posy + 40);
	ButtonPlusLab3Bar:SetSize( 180, 30 );
	ButtonPlusLab3Bar:SetVisible(false);
	ButtonPlusLab3Bar:SetZOrder(20);
	ButtonPlusLab3Bar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLabBar = Turbine.UI.Label();
	centerLabelBLabBar:SetParent(ButtonPlusLab3Bar);
	centerLabelBLabBar:SetPosition( 2, 2 );
	centerLabelBLabBar:SetSize( 176, 26  );
	centerLabelBLabBar:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLabBar:SetText( T[ "PluginSearch2" ] );
	centerLabelBLabBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabBar:SetZOrder(21);
	centerLabelBLabBar:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	centerLabelIsVisibleSearchBar.MouseEnter = function()
		ButtonPlusLab3Bar:SetVisible(true);
		centerLabelIsVisibleSearchBar:SetBackground(0x410D6DC3); -- search loupe -- serach loupe not over = 0x410D6DC4
	end

	centerLabelIsVisibleSearchBar.MouseLeave = function()
		ButtonPlusLab3Bar:SetVisible(false);
		centerLabelIsVisibleSearchBar:SetBackground(0x410D6DC2); -- search loupe -- serach loupe not over = 0x410D6DC4
	end

	centerLabelIsVisibleSearchBar.MouseClick = function()
		CreateUISearch("**", "all", "lines");
		if(settings["isSearchWindowVisible"]["isSearchWindowVisible"] == true)then
			settings["isSearchWindowVisible"]["isSearchWindowVisible"] = false;
			UIShowSearch:SetVisible(false);
		else
			UIShowSearch:SetVisible(true);
			settings["isSearchWindowVisible"]["isSearchWindowVisible"] = true;	
		end
	end
end

function DisplayTotalCash_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if settings["nameAccount"]["account1"]["name"] == "" then return; end

	local cashButton = Turbine.UI.Label();
	cashButton:SetParent(AltHolicBar);
	cashButton:SetPosition(posx, posy);
	cashButton:SetSize(32, 32);
	cashButton:SetZOrder(2);
	cashButton:SetBackground(0x41004641);
	cashButton:SetMouseVisible(true);
	cashButton:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	local tooltip = Turbine.UI.Extensions.SimpleWindow();
	tooltip:SetParent(AltHolicBar);
	tooltip:SetPosition(posx - 60, posy + 40);
	tooltip:SetSize(190, 30);
	tooltip:SetVisible(false);
	tooltip:SetZOrder(20);
	tooltip:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetPosition(2, 2);
	tooltipLabel:SetSize(186, 26);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	tooltipLabel:SetText("Left-click: Open Gold Tally");
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetZOrder(21);
	tooltipLabel:SetBackColor(Turbine.UI.Color(.9, .1, .4, .9));

	cashButton.MouseEnter = function() tooltip:SetVisible(true); end
	cashButton.MouseLeave = function() tooltip:SetVisible(false); end
	cashButton.MouseClick = function()
		tooltip:SetVisible(false);
		ToggleUIShowCash();
	end
end

function DisplaySessionCash_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;

	local currentCash = math.max(0, tonumber(settings["sessionCash"]["cashSession"]) or 0);
	local spentCash = math.max(0, tonumber(settings["sessionCash"]["cashSpent"]) or 0);

	DisplayMoneyOnBar(currentCash, posx, posy - 10);
	DisplayMoneyOnBar(spentCash, posx, posy + 10);
	alreadyDisplayed = 2;
end

function DisplayTokensIcon_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	------------------------------------------------------------------------
	-- open the fisherman PluginName --
	------------------------------------------------------------------------
	if(settings["displayTokensIcon"]["value"] == true)then
		local tokensReady = AltHolicUtil.IsPluginReady("Tokens", true);

		if(tokensReady == true)then
			local releaseWindow = Turbine.UI.Extensions.SimpleWindow();
			releaseWindow:SetSize( 40, 40 );
			releaseWindow:SetParent( AltHolicBar );
			releaseWindow:SetPosition(posx, posy);
			releaseWindow:SetOpacity( 0 );
			releaseWindow:SetFadeSpeed( 0.5 );
			releaseWindow:SetVisible( true );
			releaseWindow:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

			local centerLabelIsVisibleSearch = Turbine.UI.Label();
			centerLabelIsVisibleSearch:SetParent(AltHolicBar);
			centerLabelIsVisibleSearch:SetPosition(posx, posy );
			centerLabelIsVisibleSearch:SetSize( 32, 32  );
			centerLabelIsVisibleSearch:SetMouseVisible(false);
			centerLabelIsVisibleSearch:SetBackground(ResourcePath .. "Tokens.tga");
			centerLabelIsVisibleSearch:SetZOrder(50);

			local releaseQSBack = Turbine.UI.Control();
			releaseQSBack:SetParent( releaseWindow );
			releaseQSBack:SetZOrder(-1);
			releaseQSBack:SetSize( 40, 40 );

			local releaseQS = Turbine.UI.Lotro.Quickslot();
			releaseQS:SetParent(  releaseQSBack );
			releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, T[ "PluginReleaseAliasTokens" ]));
			releaseQS:SetSize( 40, 40 );
			releaseQS:SetPosition( 0, 0 );
			releaseQS:SetAllowDrop(false);
		end
	end

end
function DisplayAltHolicIcon_Bar()	
	posx = SetPosX(AddIfCashDisplayed(posx));
	--posx = posx + 40; --1200
	posy = 9;
------------------------------------------------------------------------
-- open the AltHolicv Plugin --
------------------------------------------------------------------------
	local releaseWindow2 = Turbine.UI.Extensions.SimpleWindow();
	releaseWindow2:SetSize( 40, 40 );
	releaseWindow2:SetParent( AltHolicBar );
	releaseWindow2:SetPosition(posx, posy);
	releaseWindow2:SetOpacity( 0 );
	releaseWindow2:SetFadeSpeed( 0.5 );
	releaseWindow2:SetVisible( true );
	releaseWindow2:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );
	releaseWindow2:SetMouseVisible(true);

	local centerLabelIsVisibleIcon = Turbine.UI.Label();
	centerLabelIsVisibleIcon:SetParent(AltHolicBar);
	centerLabelIsVisibleIcon:SetPosition(posx, posy );
	centerLabelIsVisibleIcon:SetSize( 32, 32  );
	centerLabelIsVisibleIcon:SetMouseVisible(false);
	centerLabelIsVisibleIcon:SetBackground(ResourcePath .. "AltHolic.tga");
	centerLabelIsVisibleIcon:SetZOrder(50);

	releaseWindow2.MouseClick = function()
		if(settings["isWindowVisible"]["isWindowVisible"] == false)then
			settings["nameAccount"]["account1"]["isVisible"] = true;
			AltHolicWindow:SetVisible(false);
			UpdateMainWindow();
			AltHolicWindow:SetVisible(true);
			settings["isWindowVisible"]["isWindowVisible"] = true;
		else
			settings["nameAccount"]["account1"]["isVisible"] = false;
			AltHolicWindow:SetVisible(false);
			settings["isWindowVisible"]["isWindowVisible"] = false;
		end
	end
end