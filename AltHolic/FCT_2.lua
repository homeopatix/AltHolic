------------------------------------------------------------------------------------------
-- FCT_2 file
-- Written by Homeopatix
-- 8 decembre 2021
------------------------------------------------------------------------------------------
local posx = 0;
local posy = 0;
------------------------------------------------------------------------------------------
-- Functions of the bars
------------------------------------------------------------------------------------------
function DisplayNamePlayer_Bar()
	posx = 0;
	posy = 5;
------------------------------------------------------------------------------------------
	LabelNameBar = Turbine.UI.Label();
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
	ButtonPlusInfosBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusInfosBar:SetParent( AltHolicBar );
	ButtonPlusInfosBar:SetPosition(screenWidth/2 - 190 , screenHeight/2 - 180);
	ButtonPlusInfosBar:SetSize( 380, 360 );
	ButtonPlusInfosBar:SetVisible(false);
	ButtonPlusInfosBar:SetZOrder(20);

	textBoxLinesPopUpBar = Turbine.UI.Lotro.TextBox();
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
		GenerateInfosWindow(PlayerName);
		if(settings["isInfoWindowVisible"]["isInfoWindowVisible"] == false)then
			InfoWindow:SetVisible(true);
		else
			InfoWindow:SetVisible(false);
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

	if(posx == 0 or posx == nil)then
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
	LabelPlayerLVL = Turbine.UI.Label();
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
	ButtonPlusStatsBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusStatsBar:SetParent( AltHolicBar );
	ButtonPlusStatsBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusStatsBar:SetSize( 180, 30 );
	ButtonPlusStatsBar:SetVisible(false);
	ButtonPlusStatsBar:SetZOrder(40);
	ButtonPlusStatsBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelStatsBar = Turbine.UI.Label();
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

	buttonDefineXPTotalBar = Turbine.UI.Label();
	buttonDefineXPTotalBar:SetParent( AltHolicBar );
	buttonDefineXPTotalBar:SetPosition( posx, posy );
	buttonDefineXPTotalBar:SetSize( 32, 32  );
	buttonDefineXPTotalBar:SetBackground(0x411A3870);
	buttonDefineXPTotalBar:SetVisible(true);
	--buttonDefineXPTotalBar:SetBackColor(Turbine.UI.Color.Red);
	buttonDefineXPTotalBar:SetZOrder(30);
	buttonDefineXPTotalBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	buttonDefineXPTotalBar:SetMouseVisible(true);


	ButtonPlusXPBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusXPBar:SetParent( AltHolicBar );
	ButtonPlusXPBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusXPBar:SetSize( 180, 30 );
	ButtonPlusXPBar:SetVisible(false);
	ButtonPlusXPBar:SetZOrder(20);
	ButtonPlusXPBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabXPBar = Turbine.UI.Label();
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
	centerLabelB5Bar = Turbine.UI.Label();
	centerLabelB5Bar:SetParent(AltHolicBar);
	centerLabelB5Bar:SetPosition( posx, posy );
	centerLabelB5Bar:SetSize( 32, 32  );
	centerLabelB5Bar:SetZOrder(2);
	centerLabelB5Bar:SetMouseVisible(true);
	centerLabelB5Bar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		if(PlayerDatas[PlayerName].rac == 81)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x4110894A);
			else
				centerLabelB5Bar:SetBackground(0x41108949);
			end
		end
		if(PlayerDatas[PlayerName].rac == 23)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x41108945);
			else
				centerLabelB5Bar:SetBackground(0x4110894B);
			end
		end
		if(PlayerDatas[PlayerName].rac == 65)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x41108947);
			else
				centerLabelB5Bar:SetBackground(0x41108948);
			end
		end
		if(PlayerDatas[PlayerName].rac == 114)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x4115920D);
			else
				centerLabelB5Bar:SetBackground(0x4115920A);
			end
		end
		if(PlayerDatas[PlayerName].rac == 120)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x411DAE7E);
			else
				centerLabelB5Bar:SetBackground(0x411DAE7E);
			end
		end
		if(PlayerDatas[PlayerName].rac == 73)then
			centerLabelB5Bar:SetBackground(0x41108946);
		end
		if(PlayerDatas[PlayerName].rac == 117)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x411C8D6B);
			else
				centerLabelB5Bar:SetBackground(0x411C8D6A);
			end
		end
		if(PlayerDatas[PlayerName].rac == 125)then
			if(PlayerDatas[PlayerName].sexe == "male")then
				centerLabelB5Bar:SetBackground(0x4110894A);
			else
				centerLabelB5Bar:SetBackground(0x41108949);
			end
		end

		if(i == PlayerName)then
			------------------------------------------------------------------------------------------
			-- debut race monster play
			------------------------------------------------------------------------------------------
			if(PlayerDatas[PlayerName].rac == 7)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor_red.tga");
			end
			if(PlayerDatas[PlayerName].rac == 12)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor_red.tga");
			end
			if(PlayerDatas[PlayerName].rac == 6)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor_red.tga");
			end
			if(PlayerDatas[PlayerName].rac == 66)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor_red.tga");
			end
		else
			-----------------------------------------------------------------------------------------
			-- debut race monster play
			------------------------------------------------------------------------------------------
			if(PlayerDatas[PlayerName].rac == 7)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor.tga");
			end
			if(PlayerDatas[PlayerName].rac == 12)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor.tga");
			end
			if(PlayerDatas[PlayerName].rac == 6)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor.tga");
			end
			if(PlayerDatas[PlayerName].rac == 66)then
				centerLabelB5Bar:SetBackground(ResourcePath .. "Mordor.tga");
			end
		end
	end
	------------------------------------------------------------------------------------------
	--- define race label
	------------------------------------------------------------------------------------------
	ButtonPlusSexeBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusSexeBar:SetParent( AltHolicBar );
	ButtonPlusSexeBar:SetPosition(posx + 20 , posy + 40);
	ButtonPlusSexeBar:SetSize( 180, 30 );
	ButtonPlusSexeBar:SetVisible(false);
	ButtonPlusSexeBar:SetZOrder(20);
	ButtonPlusSexeBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelSexe = Turbine.UI.Label();
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
	LabelClasseBar = Turbine.UI.Control();
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
		if(PlayerDatas[PlayerName].cla == 162)then
			LabelClasseBar:SetBackground(0x410095C2);
		end
		if(PlayerDatas[PlayerName].cla == 31)then
			LabelClasseBar:SetBackground(0x4110867A);
		end
		if(PlayerDatas[PlayerName].cla == 214)then
			LabelClasseBar:SetBackground(0x41153604);
		end
		if(PlayerDatas[PlayerName].cla == 24)then
			LabelClasseBar:SetBackground(0x410095C5);
		end
		if(PlayerDatas[PlayerName].cla == 193)then
			LabelClasseBar:SetBackground(0x4110867B);
		end
		if(PlayerDatas[PlayerName].cla == 40)then
			LabelClasseBar:SetBackground(0x410095BB);
		end
		if(PlayerDatas[PlayerName].cla == 185)then
			LabelClasseBar:SetBackground(0x410095BF);
		end
		if(PlayerDatas[PlayerName].cla == 23)then
			LabelClasseBar:SetBackground(0x410095B8);
		end
		if(PlayerDatas[PlayerName].cla == 172)then
			LabelClasseBar:SetBackground(0x410095B5);
		end
		if(PlayerDatas[PlayerName].cla == 194)then
			LabelClasseBar:SetBackground(0x41108673);
		end
		if(PlayerDatas[PlayerName].cla == 215)then -- new class brawler
			LabelClasseBar:SetBackground(0x4120fcd9);
		end
		if(PlayerDatas[PlayerName].cla == 216)then -- new class mariner
			LabelClasseBar:SetBackground(0x4122f860);
		end
		------------------------------------------------------------------------------------------
		-- debut class pour monster play
		------------------------------------------------------------------------------------------
		if(PlayerDatas[PlayerName].cla == 71)then
			LabelClasseBar:SetBackground(ResourcePath .. "Faucheur.tga");
		end
		if(PlayerDatas[PlayerName].cla == 128)then
			LabelClasseBar:SetBackground(ResourcePath .. "Profanateur.tga");
		end
		if(PlayerDatas[PlayerName].cla == 127)then
			LabelClasseBar:SetBackground(ResourcePath .. "Araignee.tga");
		end
		if(PlayerDatas[PlayerName].cla == 179)then
			LabelClasseBar:SetBackground(ResourcePath .. "FlecheNoire.tga");
		end
		if(PlayerDatas[PlayerName].cla == 52)then
			LabelClasseBar:SetBackground(ResourcePath .. "ChefDeGuerre.tga");
		end
		if(PlayerDatas[PlayerName].cla == 126)then
			LabelClasseBar:SetBackground(ResourcePath .. "Ouargue.tga");
		end
	end
	-----------------------------------------------------------------------------------------
	-- display the label of equipement
	------------------------------------------------------------------------------------------
	local equipMent = Turbine.Gameplay.LocalPlayer:GetInstance():GetEquipment();
	local equip = { };
	local nbrItems = 0;
	for j=1, 20 do
		equip[j] = equipMent:GetItem(j);
	end

	ButtonEquipment = Turbine.UI.Extensions.SimpleWindow();
	ButtonEquipment:SetParent( AltHolicBar );
	ButtonEquipment:SetPosition(posx + 10 , posy + 40);
	ButtonEquipment:SetSize( 180, 30 );
	ButtonEquipment:SetVisible(false);
	ButtonEquipment:SetZOrder(20);
	ButtonEquipment:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	LabelEquipment = Turbine.UI.Label();
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
			LabelServerBar=Turbine.UI.Label(); 
			LabelServerBar:SetParent(AltHolicBar); 
			LabelServerBar:SetSize(32,32); 
			LabelServerBar:SetPosition(posx, posy); 
			LabelServerBar:SetBackground(ResourcePath .. "Server_Icon.tga");
			LabelServerBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);
			LabelServerBar:SetZOrder(3);
			LabelServerBar:SetMouseVisible(true);

			if(ReturnValueServer(PlayerName) > 0)then
				LabelServerNbrBar=Turbine.UI.Label(); 
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
	ButtonPlusServerBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusServerBar:SetParent( AltHolicBar );
	ButtonPlusServerBar:SetPosition(posx , posy);
	ButtonPlusServerBar:SetSize( 180, 30 );
	ButtonPlusServerBar:SetVisible(false);
	ButtonPlusServerBar:SetZOrder(20);
	ButtonPlusServerBar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelServerBar = Turbine.UI.Label();
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
		GenerateServerNameWindow(PlayerName);
		if(settings["isServerWindowVisible"]["value"] == false)then
			settings["isServerWindowVisible"]["value"] = true;
			ServerNameWindow:SetVisible(true);
		else
			settings["isServerWindowVisible"]["value"] = false;
			ServerNameWindow:SetVisible(false);
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
						if(PlayerDatas.bagCash ~= nil)then
							totalCash = totalCash +  PlayerDatas[i].bagCash ;
						end
						if(PlayerDatas.vaultCash ~= nil)then
							totalCash = totalCash +  PlayerDatas[i].vaultCash ;
						end
			end
		end
		
		DisplayCashForBar(PlayerDatas[PlayerName].cash, posx, posy - 10);

		totalCash = totalCash + tonumber(settings["sharedStorageCash"]["value"]);

		DisplayCashForBar(totalCash, posx, posy + 10);
	end
end

function DisplayCashForBar(totalCash, posx, posy)
	------------------------------------------------------------------------------------------
	-- cash displayer
	------------------------------------------------------------------------------------------
	if(totalCash == 0 or totalCash == nil)then
		totalCash = PlayerAttr:GetMoney();
	end
	
	gold = math.floor( totalCash / 100000);
	silver = math.floor( totalCash / 100) - gold * 1000;
	copper = totalCash - gold * 100000 - silver * 100;

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( AltHolicBar );
	LabelGold:SetPosition(posx, posy + 5);
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7b);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	AltHolicBar.Message1=Turbine.UI.Label(); 
	AltHolicBar.Message1:SetParent(AltHolicBar); 
	AltHolicBar.Message1:SetSize(50, 30); 
	AltHolicBar.Message1:SetPosition(posx + 30, posy); 
	AltHolicBar.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	AltHolicBar.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicBar.Message1:SetText(string.format( "%.0f", gold)); 
	AltHolicBar.Message1:SetForeColor(Turbine.UI.Color.Gold);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( AltHolicBar );
	LabelGold:SetPosition(posx + 70, posy + 5);
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7c);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	AltHolicBar.Message2=Turbine.UI.Label();  
	AltHolicBar.Message2:SetParent(AltHolicBar); 
	AltHolicBar.Message2:SetSize(50, 30); 
	AltHolicBar.Message2:SetPosition(posx + 100, posy); 
	AltHolicBar.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	AltHolicBar.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicBar.Message2:SetText(string.format( "%.0f", silver));
	AltHolicBar.Message2:SetForeColor(Turbine.UI.Color.Silver);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( AltHolicBar );
	LabelGold:SetPosition(posx + 140, posy + 5);
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7d);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	AltHolicBar.Message3=Turbine.UI.Label(); 
	AltHolicBar.Message3:SetParent(AltHolicBar); 
	AltHolicBar.Message3:SetSize(50, 30); 
	AltHolicBar.Message3:SetPosition(posx + 170, posy); 
	AltHolicBar.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	AltHolicBar.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	AltHolicBar.Message3:SetText(string.format( "%.0f", copper));
	AltHolicBar.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
	--- end of cash displayer
end

function DisplayWalletButton_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- display wallet button
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then

		buttonWalletBar = Turbine.UI.Control();
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
		btnewlabel = Turbine.UI.Extensions.SimpleWindow();
		btnewlabel:SetParent( AltHolicBar );
		btnewlabel:SetPosition(posx + 20 , posy + 40);
		btnewlabel:SetSize( 180, 30 );
		btnewlabel:SetVisible(false);
		btnewlabel:SetZOrder(20);
		btnewlabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

		btnewlabelText = Turbine.UI.Label();
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
	local nbrItemInVault = 0;
------------------------------------------------------------------------------------------
-- display vault button
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then

		VaultIcons = {0x4110149D, --  ecplorateur 
						0x41101482, --  joaillier
						0x4110147B, --  franc-tenancier
						0x41101481, --  historien 
						0x4110148B, --  armurier
						0x4110149C, --  bucheron 
						0x41101480}; --  feronnier


			buttonVaultBar = Turbine.UI.Control();
			buttonVaultBar:SetParent( AltHolicBar );
			buttonVaultBar:SetPosition(posx, posy);
			buttonVaultBar:SetSize( 32, 32 );
			if(PlayerDatas[PlayerName].align == 1)then
				--buttonVaultBar:SetBackground(VaultIcons[vocationToShow]);
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
			btnewlabelvault = Turbine.UI.Extensions.SimpleWindow();
			btnewlabelvault:SetParent( AltHolicBar );
			btnewlabelvault:SetPosition(posx + 20 , posy + 40);
			btnewlabelvault:SetSize( 180, 30 );
			btnewlabelvault:SetVisible(false);
			btnewlabelvault:SetZOrder(20);
			btnewlabelvault:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			btnewlabelText = Turbine.UI.Label();
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
		
		BagsIcons = {0x410FC45F, --  ecplorateur 
						0x410F467E, --  joaillier
						0x410F4682, --  franc-tenancier
						0x410F4684, --  historien 
						0x410F4688, --  armurier
						0x410F4686, --  bucheron 
						0x410F4680}; --  feronnier

			buttonBag = Turbine.UI.Control();
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
				buttonBagText = Turbine.UI.Label();
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

				buttonBagText2 = Turbine.UI.Label();
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
			btnewlabelbag = Turbine.UI.Extensions.SimpleWindow();
			btnewlabelbag:SetParent( AltHolicBar );
			btnewlabelbag:SetPosition(posx + 20 , posy + 40);
			btnewlabelbag:SetSize( 180, 30 );
			btnewlabelbag:SetVisible(false);
			btnewlabelbag:SetZOrder(20);
			btnewlabelbag:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			btnewlabelText = Turbine.UI.Label();
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

function DisplayButtonVocation_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx-5));
	posy = 2;
------------------------------------------------------------------------------------------
--- display vocation
------------------------------------------------------------------------------------------
	buttonDefineHouseLocationPersonal2Bar = Turbine.UI.Control();
	buttonDefineHouseLocationPersonal2Bar:SetParent( AltHolicBar );
	buttonDefineHouseLocationPersonal2Bar:SetPosition(posx, posy);
	buttonDefineHouseLocationPersonal2Bar:SetSize( 45, 45 );
	buttonDefineHouseLocationPersonal2Bar:SetVisible(true);
			
	centerLabelB21Bar = Turbine.UI.Label();
	centerLabelB21Bar:SetParent(buttonDefineHouseLocationPersonal2Bar);
	centerLabelB21Bar:SetPosition( 0, 0 );
	centerLabelB21Bar:SetSize( 45, 45  );
	centerLabelB21Bar:SetZOrder(5);
	centerLabelB21Bar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	if(settings["nameAccount"]["account1"]["name"] ~= "")then  
		if(PlayerDatas[PlayerName].voc == 1)then
			centerLabelB21Bar:SetBackground(0x4110DB16);
			DisplaySmallLabelForBar(T[ "PluginVocation1" ]);
		end
		if(PlayerDatas[PlayerName].voc == 2)then
			centerLabelB21Bar:SetBackground(0x4110DB18);
			DisplaySmallLabelForBar(T[ "PluginVocation2" ]);
		end
		if(PlayerDatas[PlayerName].voc == 3)then
			centerLabelB21Bar:SetBackground(0x4110DB13);
			DisplaySmallLabelForBar(T[ "PluginVocation3" ]);
		end
		if(PlayerDatas[PlayerName].voc == 4)then
			centerLabelB21Bar:SetBackground(0x4110DB19);
			DisplaySmallLabelForBar(T[ "PluginVocation4" ]);
		end
		if(PlayerDatas[PlayerName].voc == 5)then
			centerLabelB21Bar:SetBackground(0x4110DB17);
			DisplaySmallLabelForBar(T[ "PluginVocation5" ]);
		end
		if(PlayerDatas[PlayerName].voc == 6)then
			centerLabelB21Bar:SetBackground(0x4110DB14);
			DisplaySmallLabelForBar(T[ "PluginVocation6" ]);
		end
		if(PlayerDatas[PlayerName].voc == 7)then
			centerLabelB21Bar:SetBackground(0x4110DB15);
			DisplaySmallLabelForBar(T[ "PluginVocation7" ]);
		end
		centerLabelB21Bar:SetMouseVisible(true);
	end
end
function DisplaySmallLabelForBar(texte)
	posy = 9;
------------------------------------------------------------------------------------------
--- display vocation label
------------------------------------------------------------------------------------------
	recipeTrackerIsInstalled = false;

	GetDataForProfessions();
	SavePlayerProfessions();

	buttonDefineHouseLocationPersonalFauxBar = Turbine.UI.Control();
	buttonDefineHouseLocationPersonalFauxBar:SetParent( AltHolicBar );
	buttonDefineHouseLocationPersonalFauxBar:SetPosition(posx, posy);
	buttonDefineHouseLocationPersonalFauxBar:SetSize( 45, 45 );
	buttonDefineHouseLocationPersonalFauxBar:SetVisible(true);
	buttonDefineHouseLocationPersonalFauxBar:SetZOrder(19);
	buttonDefineHouseLocationPersonalFauxBar:SetMouseVisible(true);

	ButtonPlusVocationBar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusVocationBar:SetParent( AltHolicBar );
	ButtonPlusVocationBar:SetSize( 380, 420 );
	--ButtonPlusVocationBar:SetPosition(posx - 342 , posy - 5);
	ButtonPlusVocationBar:SetPosition((Turbine.UI.Display:GetWidth()-ButtonPlusVocationBar:GetWidth())/2,(Turbine.UI.Display:GetHeight()-ButtonPlusVocationBar:GetHeight())/2);
	ButtonPlusVocationBar:SetVisible(false);
	ButtonPlusVocationBar:SetZOrder(100);
	ButtonPlusVocationBar:SetBackground(ResourcePath .. "/Cadre_380_420.tga");

	centerLabelBVocBar = Turbine.UI.Label();
	centerLabelBVocBar:SetParent(ButtonPlusVocationBar);
	centerLabelBVocBar:SetPosition( ButtonPlusVocationBar:GetWidth()/2 - 150, 5 );
	centerLabelBVocBar:SetSize( 300, 30  );
	centerLabelBVocBar:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
	centerLabelBVocBar:SetText( texte );
	centerLabelBVocBar:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBVocBar:SetZOrder(101);
	centerLabelBVocBar:SetForeColor(Turbine.UI.Color.Gold);

	local posyStart = 60;
	local posxStart = 80;

	if(PlayerProfessions ~= nil)then
		for x=1, 3 do
			centerLabelProf1 = Turbine.UI.Label();
			centerLabelProf1:SetParent(ButtonPlusVocationBar);
			centerLabelProf1:SetPosition( posxStart - 30, posyStart );
			centerLabelProf1:SetSize( 200, 30  );
			centerLabelProf1:SetFont(Turbine.UI.Lotro.Font.TrajanProBold24);
			centerLabelProf1:SetText( PlayerProfessions[PlayerName].Name[x] );
			centerLabelProf1:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelProf1:SetZOrder(21);
			--centerLabelProf1:SetForeColor(Turbine.UI.Color.Gold);

			centerLabelProfIcon = Turbine.UI.Label();
			centerLabelProfIcon:SetParent(ButtonPlusVocationBar);
			centerLabelProfIcon:SetPosition( posxStart - 70, posyStart );
			centerLabelProfIcon:SetSize( 32, 32  );
			centerLabelProfIcon:SetZOrder(21);

			iconsProf = {"Prof_Forester.tga",
							"Prof_Prospector.tga",
							"Prof_Armorer.tga",
							"Prof_Cook.tga",
							"Prof_Farmer.tga",
							"Prof_Historian.tga",
							"Prof_Jeweller.tga",
							"Prof_MetalSmith.tga",
							"Prof_Taillor.tga",
							"Prof_Woodsman.tga",};

			if(PlayerDatas[PlayerName].voc == 1)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[1] ); -- explorateur
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[9] ); -- explorateur
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[2] ); -- explorateur
				end
			end
			if(PlayerDatas[PlayerName].voc == 2)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[4] ); -- joaillier
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[2] ); -- joaillier
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[7] ); -- joaillier
				end
			end
			if(PlayerDatas[PlayerName].voc == 3)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[4] ); -- franc-tenancier
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[9] ); -- franc-tenancier
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[5] ); -- franc-tenancier
				end
			end
			if(PlayerDatas[PlayerName].voc == 4)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[6] ); -- historien
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[5] ); -- historien
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[3] ); -- historien
				end
			end
			if(PlayerDatas[PlayerName].voc == 5)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[1] ); -- armurier
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[10] ); -- armurier
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[3] ); -- armurier
				end
			end
			if(PlayerDatas[PlayerName].voc == 6)then
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[1] ); -- bucheron
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[10] ); -- bucheron
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[5] ); -- bucheron
				end
			end
			if(PlayerDatas[PlayerName].voc == 7)then
				centerLabelB21Bar:SetBackground(0x4110DB15); -- ferronier
				if(x == 1)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[8] ); -- ferronier
				elseif(x == 2)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[9] ); -- ferronier
				elseif(x == 3)then
					centerLabelProfIcon:SetBackground( ResourcePath .. iconsProf[2] ); -- ferronier
				end
			end


			-- current lvl profession
			split_string = Split(PlayerProfessions[PlayerName].CurrentLvl[x], "\n");

			centerLabelTier1 = Turbine.UI.Label();
			centerLabelTier1:SetParent(ButtonPlusVocationBar);
			centerLabelTier1:SetPosition( posxStart - 5, posyStart + 27 );
			centerLabelTier1:SetSize( 280, 30  );
			centerLabelTier1:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
			centerLabelTier1:SetText( split_string[1] );
			centerLabelTier1:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier1:SetZOrder(21);
			centerLabelTier1:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

			centerLabelTier1 = Turbine.UI.Label();
			centerLabelTier1:SetParent(ButtonPlusVocationBar);
			centerLabelTier1:SetPosition( posxStart - 5, posyStart + 42 );
			centerLabelTier1:SetSize( 280, 30  );
			centerLabelTier1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			centerLabelTier1:SetText( split_string[2] );
			centerLabelTier1:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier1:SetZOrder(21);
			centerLabelTier1:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

			centerLabelTier1 = Turbine.UI.Label();
			centerLabelTier1:SetParent(ButtonPlusVocationBar);
			centerLabelTier1:SetPosition( posxStart - 40, posyStart + 32 );
			centerLabelTier1:SetSize( 27, 17  );
			centerLabelTier1:SetZOrder(21);
			centerLabelTier1:SetBackground( ResourcePath .. "icon_craft_proficient.tga" );
			centerLabelTier1:SetBlendMode( Turbine.UI.BlendMode.Overlay );


			-- current mastery profession
			split_string = Split(PlayerProfessions[PlayerName].currentMastery[x], "\n");

			centerLabelTier2 = Turbine.UI.Label();
			centerLabelTier2:SetParent(ButtonPlusVocationBar);
			centerLabelTier2:SetPosition( posxStart - 5, posyStart + 67 );
			centerLabelTier2:SetSize( 280, 30  );
			centerLabelTier2:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
			centerLabelTier2:SetText( split_string[1] );
			centerLabelTier2:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier2:SetZOrder(21);
			centerLabelTier2:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

			centerLabelTier2 = Turbine.UI.Label();
			centerLabelTier2:SetParent(ButtonPlusVocationBar);
			centerLabelTier2:SetPosition( posxStart - 5, posyStart + 82 );
			centerLabelTier2:SetSize( 280, 30  );
			centerLabelTier2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			centerLabelTier2:SetText( split_string[2] );
			centerLabelTier2:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier2:SetZOrder(21);
			centerLabelTier2:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

			centerLabelTier2 = Turbine.UI.Label();
			centerLabelTier2:SetParent(ButtonPlusVocationBar);
			centerLabelTier2:SetPosition( posxStart - 40, posyStart + 72 );
			centerLabelTier2:SetSize( 27, 17  );
			centerLabelTier2:SetZOrder(21);
			centerLabelTier2:SetBackground( ResourcePath .. "icon_craft_master.tga" );
			centerLabelTier2:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			posyStart = posyStart + 120;
		end
	else
		centerLabelProf1 = Turbine.UI.Label();
		centerLabelProf1:SetParent(ButtonPlusVocationBar);
		centerLabelProf1:SetPosition( 25, 100 );
		centerLabelProf1:SetSize( 250, 100  );
		centerLabelProf1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		centerLabelProf1:SetText( T[ "PluginStats10" ] );
		centerLabelProf1:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelProf1:SetZOrder(21);
	end


	local tmpPlugins=Turbine.PluginManager.GetAvailablePlugins();
	local pluginIndex;
	RecipeTracker=0
	for pluginIndex=1,#tmpPlugins do
		if tmpPlugins[pluginIndex].Name=="RecipeTracker v2" then
			recipeTrackerIsInstalled = true;
			break;
		end
	end

	if(recipeTrackerIsInstalled == true)then
		releaseWindow = Turbine.UI.Extensions.SimpleWindow();
		releaseWindow:SetSize( 45, 45 );
		releaseWindow:SetParent( buttonDefineHouseLocationPersonalFauxBar );
		releaseWindow:SetPosition(4, 2);
		releaseWindow:SetOpacity( 0 );
		releaseWindow:SetFadeSpeed( 0.5 );
		releaseWindow:SetVisible( true );

		releaseQSBack = Turbine.UI.Control();
		releaseQSBack:SetParent( releaseWindow );
		releaseQSBack:SetZOrder(-1);
		releaseQSBack:SetSize( 45, 45 );

		releaseQS = Turbine.UI.Lotro.Quickslot();
		releaseQS:SetParent(  releaseQSBack );
		releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "/recipetracker show"));
		releaseQS:SetSize( 45, 45 );
		releaseQS:SetPosition( 4, 2 );
		releaseQS:SetAllowDrop(false);
		releaseQS:SetOpacity( 0 );
		releaseQS:SetZOrder(-1);
	end

	buttonDefineHouseLocationPersonalFauxBar.MouseEnter = function()
		ButtonPlusVocationBar:SetVisible(true);
	end

	buttonDefineHouseLocationPersonalFauxBar.MouseLeave = function()
		ButtonPlusVocationBar:SetVisible(false);
	end
end

function DisplaySharedStorage_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------------------------
-- sharedstorage
------------------------------------------------------------------------------------------
	centerLabelIsVisibleSS = Turbine.UI.Label();
	centerLabelIsVisibleSS:SetParent(AltHolicBar);
	centerLabelIsVisibleSS:SetPosition( posx, posy );
	centerLabelIsVisibleSS:SetSize( 32, 32  );
	centerLabelIsVisibleSS:SetBackground(0x4111BE35); -- sharedstorage
	centerLabelIsVisibleSS:SetZOrder(2);
	centerLabelIsVisibleSS:SetMouseVisible(true);
	centerLabelIsVisibleSS:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	ButtonPlusLab = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab:SetParent( AltHolicBar );
	ButtonPlusLab:SetPosition(posx + 10 , posy + 40);
	ButtonPlusLab:SetSize( 180, 30 );
	ButtonPlusLab:SetVisible(false);
	ButtonPlusLab:SetZOrder(20);
	ButtonPlusLab:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLab = Turbine.UI.Label();
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

		centerLabelForEpiqueWindow = Turbine.UI.Label();
		centerLabelForEpiqueWindow:SetParent(AltHolicBar);
		centerLabelForEpiqueWindow:SetPosition( posx, posy );
		centerLabelForEpiqueWindow:SetSize( 32, 32  );
		centerLabelForEpiqueWindow:SetBackground(0x41139D6B); -- nice epique book
		centerLabelForEpiqueWindow:SetZOrder(2);
		centerLabelForEpiqueWindow:SetMouseVisible(true);
		centerLabelForEpiqueWindow:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		ButtonPlusLab28 = Turbine.UI.Extensions.SimpleWindow();
		ButtonPlusLab28:SetParent( AltHolicBar );
		ButtonPlusLab28:SetPosition(posx + 10 , posy + 40);
		ButtonPlusLab28:SetSize( 180, 30 );
		ButtonPlusLab28:SetVisible(false);
		ButtonPlusLab28:SetZOrder(20);
		ButtonPlusLab28:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

		centerLabelBLab = Turbine.UI.Label();
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
	centerLabelIsVisibleSearchBar = Turbine.UI.Label();
	centerLabelIsVisibleSearchBar:SetParent(AltHolicBar);
	centerLabelIsVisibleSearchBar:SetPosition( posx, posy );
	centerLabelIsVisibleSearchBar:SetSize( 32, 32  );
	centerLabelIsVisibleSearchBar:SetBackground(0x410D6DC2); 
	centerLabelIsVisibleSearchBar:SetZOrder(2);
	centerLabelIsVisibleSearchBar:SetMouseVisible(true);
	centerLabelIsVisibleSearchBar:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	ButtonPlusLab3Bar = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab3Bar:SetParent( AltHolicBar );
	ButtonPlusLab3Bar:SetPosition(posx + 10 , posy + 40);
	ButtonPlusLab3Bar:SetSize( 180, 30 );
	ButtonPlusLab3Bar:SetVisible(false);
	ButtonPlusLab3Bar:SetZOrder(20);
	ButtonPlusLab3Bar:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabBar = Turbine.UI.Label();
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
		CreateUiSearch("**", "all", "lines");
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
------------------------------------------------------------------------------------------
-- cash button for cash window
------------------------------------------------------------------------------------------
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		centerLabelForCashWindow = Turbine.UI.Label();
		centerLabelForCashWindow:SetParent(AltHolicBar);
		centerLabelForCashWindow:SetPosition( posx, posy );
		centerLabelForCashWindow:SetSize( 32, 32  );
		centerLabelForCashWindow:SetZOrder(2);
		centerLabelForCashWindow:SetBackground(0x41004641); --0x41005E9E -- 32x32 = 0x41004641
		centerLabelForCashWindow:SetMouseVisible(true);
		centerLabelForCashWindow:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		CreateUIShowCash();

		centerLabelForCashWindow.MouseEnter = function()
			UIShowCash:SetVisible(true);
		end

		centerLabelForCashWindow.MouseLeave = function()
			UIShowCash:SetVisible(false);
		end
	end
end

function DisplaySessionCash_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
------------------------------------------------------------------------
-- Display session cash --
------------------------------------------------------------------------
	currentCash = 0;
	currentCash = settings["sessionCash"]["cashSession"];

	if(currentCash < 0)then
		currentCash = 0;
	end

		gold = math.floor( currentCash / 100000);
		silver = math.floor( currentCash / 100) - gold * 1000;
		copper = currentCash - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx, posy - 5 );
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message1=Turbine.UI.Label(); 
		AltHolicBar.Message1:SetParent(AltHolicBar); 
		AltHolicBar.Message1:SetSize(50, 30); 
		AltHolicBar.Message1:SetPosition(posx + 30, posy - 10); 
		AltHolicBar.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message1:SetText(string.format( "%.0f", gold)); 
		AltHolicBar.Message1:SetForeColor(Turbine.UI.Color.Gold);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx + 70, posy - 5 );
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message2=Turbine.UI.Label();  
		AltHolicBar.Message2:SetParent(AltHolicBar); 
		AltHolicBar.Message2:SetSize(50, 30); 
		AltHolicBar.Message2:SetPosition(posx + 100, posy - 10 ); 
		AltHolicBar.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message2:SetText(string.format( "%.0f", silver));
		AltHolicBar.Message2:SetForeColor(Turbine.UI.Color.Silver);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx + 140, posy - 5 );
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message3=Turbine.UI.Label(); 
		AltHolicBar.Message3:SetParent(AltHolicBar); 
		AltHolicBar.Message3:SetSize(50, 30); 
		AltHolicBar.Message3:SetPosition(posx + 170, posy - 10); 
		AltHolicBar.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message3:SetText(string.format( "%.0f", copper));
		AltHolicBar.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
--- end of session cash displayer
------------------------------------------------------------------------
-- Display spent cash --
------------------------------------------------------------------------
	spentCash = 0;
		spentCash = settings["sessionCash"]["cashSpent"];

		gold = math.floor( spentCash / 100000);
		silver = math.floor( spentCash / 100) - gold * 1000;
		copper = spentCash - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx, posy + 15);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message1=Turbine.UI.Label(); 
		AltHolicBar.Message1:SetParent(AltHolicBar); 
		AltHolicBar.Message1:SetSize(50, 30); 
		AltHolicBar.Message1:SetPosition(posx + 30, posy + 10); 
		AltHolicBar.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message1:SetText(string.format( "%.0f", gold)); 
		AltHolicBar.Message1:SetForeColor(Turbine.UI.Color.Gold);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx + 70, posy + 15);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message2=Turbine.UI.Label();  
		AltHolicBar.Message2:SetParent(AltHolicBar); 
		AltHolicBar.Message2:SetSize(50, 30); 
		AltHolicBar.Message2:SetPosition(posx + 100, posy + 10); 
		AltHolicBar.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message2:SetText(string.format( "%.0f", silver));
		AltHolicBar.Message2:SetForeColor(Turbine.UI.Color.Silver);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicBar );
		LabelGold:SetPosition(posx + 140, posy + 15);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicBar.Message3=Turbine.UI.Label(); 
		AltHolicBar.Message3:SetParent(AltHolicBar); 
		AltHolicBar.Message3:SetSize(50, 30); 
		AltHolicBar.Message3:SetPosition(posx + 170, posy + 10); 
		AltHolicBar.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
		AltHolicBar.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicBar.Message3:SetText(string.format( "%.0f", copper));
		AltHolicBar.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
--- end of spent cash displayer
end

function DisplayTokensIcon_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	------------------------------------------------------------------------
	-- open the fisherman PluginName --
	------------------------------------------------------------------------
	if(settings["displayTokensIcon"]["value"] == true)then
		local IsLoaded = false;
		local IsInstalled = false;

		local tmpPlugins=Turbine.PluginManager.GetAvailablePlugins();
		local pluginIndex;
		for pluginIndex=1,#tmpPlugins do
			if (tmpPlugins[pluginIndex].Name == "Tokens") then
				IsInstalled = true;
				break;
			end
		end

		local tmpPlugins=Turbine.PluginManager.GetLoadedPlugins();
		local pluginIndex;
		for pluginIndex=1,#tmpPlugins do
			if (tmpPlugins[pluginIndex].Name == "Tokens") then
				IsLoaded = true;
				break;
			end
		end

		if(IsInstalled == true and IsLoaded == true)then
			releaseWindow = Turbine.UI.Extensions.SimpleWindow();
			releaseWindow:SetSize( 40, 40 );
			releaseWindow:SetParent( AltHolicBar );
			releaseWindow:SetPosition(posx, posy);
			releaseWindow:SetOpacity( 0 );
			releaseWindow:SetFadeSpeed( 0.5 );
			releaseWindow:SetVisible( true );
			releaseWindow:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

			centerLabelIsVisibleSearch = Turbine.UI.Label();
			centerLabelIsVisibleSearch:SetParent(AltHolicBar);
			centerLabelIsVisibleSearch:SetPosition(posx, posy );
			centerLabelIsVisibleSearch:SetSize( 32, 32  );
			centerLabelIsVisibleSearch:SetMouseVisible(false);
			centerLabelIsVisibleSearch:SetBackground(ResourcePath .. "Tokens.tga");
			centerLabelIsVisibleSearch:SetZOrder(50);

			releaseQSBack = Turbine.UI.Control();
			releaseQSBack:SetParent( releaseWindow );
			releaseQSBack:SetZOrder(-1);
			releaseQSBack:SetSize( 40, 40 );

			releaseQS = Turbine.UI.Lotro.Quickslot();
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
	releaseWindow2 = Turbine.UI.Extensions.SimpleWindow();
	releaseWindow2:SetSize( 40, 40 );
	releaseWindow2:SetParent( AltHolicBar );
	releaseWindow2:SetPosition(posx, posy);
	releaseWindow2:SetOpacity( 0 );
	releaseWindow2:SetFadeSpeed( 0.5 );
	releaseWindow2:SetVisible( true );
	releaseWindow2:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );
	releaseWindow2:SetMouseVisible(true);

	centerLabelIsVisibleIcon = Turbine.UI.Label();
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