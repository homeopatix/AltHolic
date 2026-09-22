------------------------------------------------------------------------------------------
-- FCT_Display file
-- Written by Homeopatix
-- 19 march 2022
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Display functions
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Module-private UI control collections. These used to be predeclared globally in FCT.lua
-- (and in two cases UI.lua), making unrelated modules able to overwrite display state.
------------------------------------------------------------------------------------------
local ButtonEquipItem = {};
local centerEquipItem = {};
local centerEquipItem2a = {};
local centerEquipItem2 = {};
local centerEquipItem3 = {};
local centerEquipItem4 = {};
local centerEquipItem5 = {};
local centerEquipItem2ab = {};
local ButtonPlusSexe = {};
local centerLabelSexe = {};
local centerEquipItem9 = {};
local centerEquipItem19 = {};
local centerLabelProf1 = {};
local centerLabelProfIcon = {};
local centerLabelTier1 = {};
local centerLabelTier2 = {};
local ButtonPlusStats = {};
local ButtonPlusServer = {};
local centerLabelStats = {};
local centerLabelServer = {};
local centerLabelStats2 = {};
local ButtonPlusInfosNotBar = {};
local textBoxLinesPopUp = {};
local ButtonPlusDelete = {};
local centerLabelDelete = {};
local ButtonPlusLabEpique = {};
local centerLabelBLab = {};

------------------------------------------------------------------------------------------
-- display the birthday window
------------------------------------------------------------------------------------------
function DisplayBirthday(cDay, cMonth, cYear)
	
	local birthdayTrigger = Turbine.UI.Extensions.SimpleWindow();
	birthdayTrigger:SetParent( AltHolicWindow );
	birthdayTrigger:SetPosition(305, 40);
	birthdayTrigger:SetSize( 32, 32 );
	birthdayTrigger:SetVisible(true);
	birthdayTrigger:SetZOrder(2000);
	birthdayTrigger:SetBackground( 0x410DBA89 ); -- round de fleurs 0x411F2959 -- heart 0x410DBA89


	local birthdayBackgrounds = {0x410096C9,
			0x411023FF,
			0x41108565,
			0x4110DC08,
			0x41134C68,
			0x411C5268,
			0x41008203,
			0x410096A8,
			0x410096CA,
			0x4101DBD4};

	local birthdayWindow = Turbine.UI.Extensions.SimpleWindow();
	birthdayWindow:SetParent( AltHolicWindow );
	birthdayWindow:SetSize( 1024, 512 );
	birthdayWindow:SetPosition((Turbine.UI.Display:GetWidth()-birthdayWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-birthdayWindow:GetHeight())/2);
	birthdayWindow:SetVisible(false);
	birthdayWindow:SetZOrder(100);
	birthdayWindow:SetBackground(birthdayBackgrounds[Random(1, 10)]);

	local birthdayBorder = Turbine.UI.Extensions.SimpleWindow();
	birthdayBorder:SetParent( AltHolicWindow );
	birthdayBorder:SetSize( 1030, 518 );
	birthdayBorder:SetPosition(((Turbine.UI.Display:GetWidth()-birthdayWindow:GetWidth())/2) - 3,((Turbine.UI.Display:GetHeight()-birthdayWindow:GetHeight())/2) - 3);
	birthdayBorder:SetVisible(false);
	birthdayBorder:SetZOrder(99);
	birthdayBorder:SetBackColor(Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ));



	local birthdayLabel = Turbine.UI.Label();
	birthdayLabel:SetParent(birthdayWindow);
	birthdayLabel:SetPosition( birthdayWindow:GetWidth()/2 - 200, 50 );
	birthdayLabel:SetSize( 390, 30  );
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		birthdayLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
		birthdayLabel:SetText( "Alles Gute zum Geburtstag" );
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		birthdayLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
		birthdayLabel:SetText( "Bon anniversaire" );
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		birthdayLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
		birthdayLabel:SetText( "Happy Birthday" );
	end
	birthdayLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	birthdayLabel:SetZOrder(102);
	birthdayLabel:SetForeColor(Turbine.UI.Color.Gold);
	birthdayLabel:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	birthdayLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	birthdayLabel = Turbine.UI.Label();
	birthdayLabel:SetParent(birthdayWindow);
	birthdayLabel:SetPosition( birthdayWindow:GetWidth()/2 - 202, 48 );
	birthdayLabel:SetSize( 394, 34  );
	birthdayLabel:SetZOrder(101);
	birthdayLabel:SetBackColor(Turbine.UI.Color(.1, .3, .3, .3));

	local birthdayDecorations = {0x410E04BB,
			0x410E04BE,
			0x410E04C4,
			0x410E04CA,
			0x410E04CD,
			0x410DCFBE,
			0x410DCFBF,
			0x410DCFC2,
			0x411130D8,
			0x4116D9C6,
			0x411C4113,
			0x411EC9F9,
			0x41104C79};
	local birthdayFlags = {0x410040AB,
			0x4110E90B,
			0x4110E90C,
			0x4110E90D,
			0x4110E90E,
			0x4110E90F,
			0x4110E910};

	local posx = 1;
	local posy = 0;
	for i=1, 32 do
		birthdayLabel = Turbine.UI.Label();
		birthdayLabel:SetParent(birthdayWindow);
		birthdayLabel:SetPosition( posx, posy );
		birthdayLabel:SetSize( 32, 32  );
		birthdayLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
		birthdayLabel:SetText("");
		birthdayLabel:SetZOrder(101);
		birthdayLabel:SetBackground(birthdayFlags[Random(1, 7)]);
		birthdayLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		posx = posx + 32;
	end

	local monthNames = {};
	local dayMessages = {};

	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		monthNames = {"", "", "", "", "Mai", "", "", "", "September", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		monthNames = {"", "", "", "", "Mai", "", "", "", "Septembre", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		monthNames = {"", "", "", "", "May", "", "", "", "September", "", "", ""};
	end

	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		dayMessages = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"Ist der Geburtstag von Bilbo und Frodo Beutlin\n\nDanke an J. R. R. Tolkien", 
			"\nEs ist der Geburtstag Ihres Lieblingsentwicklers. Senden Sie ihm eine kleine mail, die ihn glücklich machen wird\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		dayMessages = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"C'est l'anniversaire de Bilbo et de Frodon Sacquet\n\nMerci à J. R. R. Tolkien", 
			"\nC'est l'anniversaire de votre développeur préféré, envoyez lui un petit courrier cela lui fera plaisir\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		dayMessages = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"Is the birthday of Bilbo and Frodo Baggins\n\nThanks to J. R. R. Tolkien", 
			"\nIt's the birthday of your favorite developer, send him a little mail it will make him happy\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	end

	birthdayLabel = Turbine.UI.Label();
	birthdayLabel:SetParent(birthdayWindow);
	birthdayLabel:SetPosition( birthdayWindow:GetWidth()/2 - 150, 150 );
	birthdayLabel:SetSize( 300, 30  );
	birthdayLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
	birthdayLabel:SetText( cDay .. "  " .. monthNames[cMonth] .. "  " .. cYear );
	birthdayLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	birthdayLabel:SetZOrder(102);
	birthdayLabel:SetForeColor(Turbine.UI.Color.Gold);
	birthdayLabel:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	birthdayLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	birthdayLabel = Turbine.UI.Label();
	birthdayLabel:SetParent(birthdayWindow);
	birthdayLabel:SetPosition( birthdayWindow:GetWidth()/2 - 150, 180 );
	birthdayLabel:SetSize( 300, 200  );
	birthdayLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	birthdayLabel:SetText( dayMessages[cDay] );
	birthdayLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	birthdayLabel:SetZOrder(102);
	birthdayLabel:SetForeColor(Turbine.UI.Color.White);
	birthdayLabel:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	birthdayLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	birthdayLabel = Turbine.UI.Label();
	birthdayLabel:SetParent(birthdayWindow);
	birthdayLabel:SetPosition( birthdayWindow:GetWidth()/2 - 152, 148 );
	birthdayLabel:SetSize( 304, 234  );
	birthdayLabel:SetZOrder(101);
	birthdayLabel:SetBackColor(Turbine.UI.Color(1, .3, .3, .3));

	posx = 1;
	posy = 418;

	for i=1, 96 do
		birthdayLabel = Turbine.UI.Label();
		birthdayLabel:SetParent(birthdayWindow);
		birthdayLabel:SetPosition( posx, posy );
		birthdayLabel:SetSize( 32, 32  );
		birthdayLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
		birthdayLabel:SetText("");
		birthdayLabel:SetZOrder(101);
		birthdayLabel:SetBackground(birthdayDecorations[Random(1, 13)]);
		birthdayLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		posx = posx + 32;
		if(i%32 == 0)then
			posx = 1;
			posy = posy + 32;
		end
	end

	birthdayTrigger.MouseEnter = function()
		birthdayWindow:SetVisible(true);
		birthdayBorder:SetVisible(true);
		settings["isFestivalWindowVisible"]["value"] = true;
	end

	birthdayTrigger.MouseLeave = function()
		birthdayWindow:SetVisible(false);
		birthdayBorder:SetVisible(false);
		settings["isFestivalWindowVisible"]["value"] = false;
	end
end
------------------------------------------------------------------------------------------
--function to display the backpack window --
------------------------------------------------------------------------------------------
function DisplayBag(i, posx, posy)
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then
		local BagsIcons = {0x410FC45F, --  ecplorateur 
						0x410F467E, --  joaillier
						0x410F4682, --  franc-tenancier
						0x410F4684, --  historien 
						0x410F4688, --  armurier
						0x410F4686, --  bucheron 
						0x410F4680}; --  feronnier

			local bagStyleIndex = 1;
			if settings["displayClassBags"]["value"] == true then
				bagStyleIndex = Random(1, 6);
			end
			
			local buttonBag = Turbine.UI.Control();
			buttonBag:SetParent( viewport1.map );
			buttonBag:SetPosition(posx + 248, posy + 30);
			buttonBag:SetSize( 32, 32 );
			if(PlayerDatas[i].align == 1)then
				if(settings["displayClassBags"]["value"] == true)then
					if(bagStyleIndex == 0)then
						buttonBag:SetBackground(0x41105F73); -- no vocation bag
					else
						buttonBag:SetBackground(BagsIcons[bagStyleIndex]);
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

			buttonBag.MouseClick = function()
				if(settings["isShowBagVisible"]["isShowBagVisible"] == true )then
					settings["isShowBagVisible"]["isShowBagVisible"] = false;
					UIShowBag:SetVisible(false);
				else
					SavePlayerBags();
					CreateUIShowBag(i, "lines");
					settings["isShowBagVisible"]["isShowBagVisible"] = true;
					UIShowBag:SetVisible(true);
				end
			end
	end
end
------------------------------------------------------------------------------------------
--function to display the vault window --
------------------------------------------------------------------------------------------
function DisplayVault(i, posx, posy)
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then
			local buttonVault = Turbine.UI.Control();
			buttonVault:SetParent( viewport1.map );
			buttonVault:SetPosition(posx + 220, posy + 30);
			buttonVault:SetSize( 32, 32 );
			if(PlayerDatas[i].align == 1)then
				buttonVault:SetBackground(0x410E76AE);
			end
			buttonVault:SetMouseVisible(true);
			buttonVault:SetVisible(true);
			buttonVault:SetZOrder(10);
			buttonVault:SetBlendMode(Turbine.UI.BlendMode.Overlay);

			buttonVault.MouseClick = function()
				if(settings["isShowVaultVisible"]["isShowVaultVisible"] == true )then
					settings["isShowVaultVisible"]["isShowVaultVisible"] = false;
					UIShowVault:SetVisible(false);
				else
					CreateUIShowVault(i, "lines");
					settings["isShowVaultVisible"]["isShowVaultVisible"] = true;
					UIShowVault:SetVisible(true);
				end
			end
	end
end
------------------------------------------------------------------------------------------
--function to display the cash window --
------------------------------------------------------------------------------------------
function DisplayCashWindow(posx, posy)
	local buttonDefineCashTotal = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineCashTotal:SetParent(AltHolicWindow);
	buttonDefineCashTotal:SetPosition(posx, posy);
	buttonDefineCashTotal:SetSize(32, 32);
	buttonDefineCashTotal:SetVisible(true);
	buttonDefineCashTotal:SetZOrder(30);
	buttonDefineCashTotal:SetMouseVisible(true);

	local cashTooltip = Turbine.UI.Window();
	cashTooltip:SetSize(190, 28);
	cashTooltip:SetBackColor(Turbine.UI.Color(0.92, 0.03, 0.03, 0.03));
	cashTooltip:SetZOrder(10001);
	cashTooltip:SetMouseVisible(false);
	cashTooltip:SetVisible(false);

	local cashTooltipLabel = Turbine.UI.Label();
	cashTooltipLabel:SetParent(cashTooltip);
	cashTooltipLabel:SetPosition(6, 2);
	cashTooltipLabel:SetSize(178, 24);
	cashTooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	cashTooltipLabel:SetForeColor(Turbine.UI.Color(1, 0.92, 0.78));
	cashTooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	cashTooltipLabel:SetText("Left-click: Open Gold Tally");
	cashTooltipLabel:SetMouseVisible(false);

	local function PositionCashTooltip()
		local x = AltHolicWindow:GetLeft() + posx - cashTooltip:GetWidth() + 32;
		local y = AltHolicWindow:GetTop() + posy - cashTooltip:GetHeight() - 4;
		local screenWidth = Turbine.UI.Display:GetWidth();
		if x < 0 then x = 2 end
		if x + cashTooltip:GetWidth() > screenWidth then
			x = screenWidth - cashTooltip:GetWidth() - 2;
		end
		if y < 0 then
			y = AltHolicWindow:GetTop() + posy + 34;
		end
		cashTooltip:SetPosition(x, y);
	end

	buttonDefineCashTotal.MouseEnter = function()
		PositionCashTooltip();
		cashTooltip:SetVisible(true);
	end

	buttonDefineCashTotal.MouseLeave = function()
		cashTooltip:SetVisible(false);
	end

	buttonDefineCashTotal.MouseClick = function(sender, args)
		cashTooltip:SetVisible(false);
		ToggleUIShowCash();
	end
end
------------------------------------------------------------------------------------------
--function to display the XP window --
------------------------------------------------------------------------------------------
function DisplayXPWindow(posx, posy)
	local buttonDefineXPTotal = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineXPTotal:SetParent( AltHolicWindow );
	buttonDefineXPTotal:SetPosition(posx, posy);
	buttonDefineXPTotal:SetSize( 32, 32 );
	buttonDefineXPTotal:SetVisible(true);
	buttonDefineXPTotal:SetZOrder(30);
	buttonDefineXPTotal:SetMouseVisible(true);
	--buttonDefineXPTotal:SetBackColor(Turbine.UI.Color.Red);

	local ButtonPlusXP = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusXP:SetParent( AltHolicWindow );
	ButtonPlusXP:SetPosition(posx + 40 , posy - 5);
	ButtonPlusXP:SetSize( 180, 30 );
	ButtonPlusXP:SetVisible(false);
	ButtonPlusXP:SetZOrder(20);
	ButtonPlusXP:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLabXP = Turbine.UI.Label();
	centerLabelBLabXP:SetParent(ButtonPlusXP);
	centerLabelBLabXP:SetPosition( 2, 2 );
	centerLabelBLabXP:SetSize( 176, 26  );
	centerLabelBLabXP:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLabXP:SetText( T[ "PluginXPWindow1" ] );
	centerLabelBLabXP:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabXP:SetZOrder(21);
	centerLabelBLabXP:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	buttonDefineXPTotal.MouseEnter = function()
		ButtonPlusXP:SetVisible(true);
	end

	buttonDefineXPTotal.MouseLeave = function()
		ButtonPlusXP:SetVisible(false);
	end

	buttonDefineXPTotal.MouseClick = function()
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
------------------------------------------------------------------------------------------
--function to display the epique window --
------------------------------------------------------------------------------------------
function DisplayEpiqueWindow(i, posx, posy)
	local buttonDefineEpique = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineEpique:SetParent( AltHolicWindow );
	buttonDefineEpique:SetPosition(posx, posy);
	buttonDefineEpique:SetSize( 32, 32 );
	buttonDefineEpique:SetVisible(true);
	buttonDefineEpique:SetZOrder(30);

	ButtonPlusLabEpique[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLabEpique[i]:SetParent( AltHolicWindow );
	ButtonPlusLabEpique[i]:SetPosition(posx + 40 , posy - 5);
	ButtonPlusLabEpique[i]:SetSize( 180, 30 );
	ButtonPlusLabEpique[i]:SetVisible(false);
	ButtonPlusLabEpique[i]:SetZOrder(20);
	ButtonPlusLabEpique[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLab[i] = Turbine.UI.Label();
	centerLabelBLab[i]:SetParent(ButtonPlusLabEpique[i]);
	centerLabelBLab[i]:SetPosition( 2, 2 );
	centerLabelBLab[i]:SetSize( 176, 26  );
	centerLabelBLab[i]:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLab[i]:SetText( T[ "PluginEpiqueWindow1" ] );
	centerLabelBLab[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLab[i]:SetZOrder(21);
	centerLabelBLab[i]:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	buttonDefineEpique.MouseEnter = function()
		ButtonPlusLabEpique[i]:SetVisible(true);
	end

	buttonDefineEpique.MouseLeave = function()
		ButtonPlusLabEpique[i]:SetVisible(false);
	end

	buttonDefineEpique.MouseClick = function()
		if(settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] == true )then
			settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = false;
			UIShowEpique:SetVisible(false);
		else
			CreateUIShowEpique();
			settings["isEpiqueWindowVisible"]["isEpiqueWindowVisible"] = true;
			UIShowEpique:SetVisible(true);
		end
	end
end
------------------------------------------------------------------------------------------
--function to display the wallet window --
------------------------------------------------------------------------------------------
function DisplayWallet(i, posx, posy)
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then

			local buttonWallet = Turbine.UI.Control();
			buttonWallet:SetParent( viewport1.map );
			buttonWallet:SetPosition(posx + 190, posy + 30);
			buttonWallet:SetSize( 32, 32 );
			buttonWallet:SetBackground(0x411D028B);
			buttonWallet:SetMouseVisible(true);
			buttonWallet:SetVisible(true);
			buttonWallet:SetZOrder(10);
			buttonWallet:SetBlendMode(Turbine.UI.BlendMode.Overlay);

			buttonWallet.MouseClick = function()
				if(settings["isShowWalletVisible"]["isShowWalletVisible"] == true )then
					settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
					UIShowWallet:SetVisible(false);
				else
					CreateUIShowWallet(i, "lines");
					settings["isShowWalletVisible"]["isShowWalletVisible"] = true;
					UIShowWallet:SetVisible(true);
				end
			end
	end
end
------------------------------------------------------------------------------------------
--function to display the equipment window --
------------------------------------------------------------------------------------------
function DisplayEquipment(posx, posy, nameToShow, alignement)
	
	local equipMent = Turbine.Gameplay.LocalPlayer:GetInstance():GetEquipment();
	local equip = { };
	local nbrItems = 0;
	for j=1, 20 do
		equip[j] = equipMent:GetItem(j);
	end

	local buttonDefineHouseLocationPersonalFaux2 = Turbine.UI.Control();
	buttonDefineHouseLocationPersonalFaux2:SetParent( viewport1.map );
	buttonDefineHouseLocationPersonalFaux2:SetPosition(posx - 3, posy);
	buttonDefineHouseLocationPersonalFaux2:SetSize( 32, 32 );
	buttonDefineHouseLocationPersonalFaux2:SetVisible(true);
	buttonDefineHouseLocationPersonalFaux2:SetZOrder(30);

	buttonDefineHouseLocationPersonalFaux2.MouseClick = function()	
		if(settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] == true )then
			settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = false;
			UIShowEquip:SetVisible(false);
		else
			SavePlayerEquipment();
			settings["isShowEquipmentVisible"]["isShowEquipmentVisible"] = true;
			CreateUIShowEquip(nameToShow, alignement);
			UIShowEquip:SetVisible(true);
		end
	end
end 
------------------------------------------------------------------------------------------
-- Display label functions
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
--function to display the cash in wallet --
------------------------------------------------------------------------------------------
local MONEY_ROW_PARTS = {
	{ texture = 0x41007e7b, color = Turbine.UI.Color.Gold, iconOffset = -70, textOffset = -119 },
	{ texture = 0x41007e7c, color = Turbine.UI.Color.Silver, iconOffset = 7, textOffset = -43 },
	{ texture = 0x41007e7d, color = Turbine.UI.Color(0.8, 0.4, 0.2), iconOffset = 84, textOffset = 34 },
};

local function CreateMoneyRow(parent, value, iconY, textY)
	local gold, silver, copper = AltHolicUtil.MoneyParts(value);
	local values = { gold, silver, copper };
	local centerX = parent:GetWidth() / 2;

	for index, part in ipairs(MONEY_ROW_PARTS) do
		local icon = Turbine.UI.Label();
		icon:SetParent(parent);
		icon:SetPosition(centerX + part.iconOffset, iconY);
		icon:SetSize(27, 21);
		icon:SetVisible(true);
		icon:SetBackground(part.texture);
		icon:SetZOrder(-1);
		icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		local amount = Turbine.UI.Label();
		amount:SetParent(parent);
		amount:SetSize(50, 30);
		amount:SetPosition(centerX + part.textOffset, textY);
		amount:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		amount:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		amount:SetText(string.format("%.0f", values[index]));
		amount:SetForeColor(part.color);
	end
end

local function CreateMoneySectionTitle(parent, text, titleY, lineY, color)
	local title = Turbine.UI.Label();
	title:SetParent(parent);
	title:SetSize(200, 30);
	title:SetPosition(parent:GetWidth() / 2 - 100, titleY);
	title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	title:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
	title:SetText(text or "");
	title:SetForeColor(color);

	local line = Turbine.UI.Label();
	line:SetParent(parent);
	line:SetSize(250, 30);
	line:SetPosition(parent:GetWidth() / 2 - 125, lineY);
	line:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	line:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	line:SetText("___________________________________________________________________________________");
	line:SetForeColor(color);
end

local function CreateMoneyCaption(parent, text, y)
	local label = Turbine.UI.Label();
	label:SetParent(parent);
	label:SetSize(100, 30);
	label:SetPosition(parent:GetWidth() / 2 - 195, y);
	label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
	label:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	label:SetText(text or "");
end

function DisplayCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = (namePlayerToshow == PlayerName) and 20 or 0;
	if totalCash == nil then totalCash = PlayerAttr:GetMoney(); end
	if namePlayerToshow == nil or namePlayerToshow == "" then namePlayerToshow = PlayerName; end

	if settings["displaySpentCash"]["value"] == true then
		valToAdd = valToAdd + 45;
	else
		valToAdd = valToAdd - 10;
	end
	if settings["displayTotalCash"]["value"] == false then valToAdd = valToAdd - 20; end

	if windowToDisplay == UIShowWallet then
		local data = PlayerDatas[namePlayerToshow] or {};
		if (tonumber(data.bagCash) or 0) > 0 and (tonumber(data.vaultCash) or 0) > 0 then
			valToAdd = 570;
		else
			valToAdd = 490;
		end

		if (tonumber(data.bagCash) or 0) > 0 or (tonumber(data.vaultCash) or 0) > 0 then
			CreateMoneySectionTitle(
				windowToDisplay,
				T["PluginSearch7"],
				windowToDisplay:GetHeight() - (88 + valToAdd),
				windowToDisplay:GetHeight() - (84 + valToAdd),
				Turbine.UI.Color.Green
			);
		end
	end

	CreateMoneyRow(
		windowToDisplay,
		totalCash,
		windowToDisplay:GetHeight() - (64 + valToAdd),
		windowToDisplay:GetHeight() - (70 + valToAdd)
	);
end
------------------------------------------------------------------------------------------
--function to display the cash in bag --
------------------------------------------------------------------------------------------

function DisplayBagCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = settings["displaySpentCash"]["value"] == true and 50 or -10;
	if windowToDisplay == UIShowWallet then valToAdd = 502; end

	CreateMoneySectionTitle(
		windowToDisplay,
		T["PluginSearch3"],
		windowToDisplay:GetHeight() - (114 + valToAdd),
		windowToDisplay:GetHeight() - (110 + valToAdd),
		Turbine.UI.Color.Red
	);
	CreateMoneyRow(
		windowToDisplay,
		totalCash,
		windowToDisplay:GetHeight() - (90 + valToAdd),
		windowToDisplay:GetHeight() - (96 + valToAdd)
	);
end
------------------------------------------------------------------------------------------
--function to display the cash in vault --
------------------------------------------------------------------------------------------

function DisplayVaultCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = settings["displaySpentCash"]["value"] == true and 50 or -10;
	if windowToDisplay == UIShowWallet then valToAdd = 440; end
	local data = PlayerDatas[namePlayerToshow] or {};
	if (tonumber(data.bagCash) or 0) <= 0 then valToAdd = 480; end

	CreateMoneySectionTitle(
		windowToDisplay,
		T["PluginSearch4"],
		windowToDisplay:GetHeight() - (134 + valToAdd),
		windowToDisplay:GetHeight() - (130 + valToAdd),
		Turbine.UI.Color.Blue
	);
	CreateMoneyRow(
		windowToDisplay,
		totalCash,
		windowToDisplay:GetHeight() - (110 + valToAdd),
		windowToDisplay:GetHeight() - (116 + valToAdd)
	);
end
------------------------------------------------------------------------------------------
-- function to display destiny points --
------------------------------------------------------------------------------------------

function DisplayDestinyPoints(windowToDisplay)
	local valToAdd = (windowToDisplay == UIShowWallet) and 450 or 0;

	local LabelDestinyPoints = Turbine.UI.Label(); 
	LabelDestinyPoints:SetParent( windowToDisplay );
	LabelDestinyPoints:SetPosition(windowToDisplay:GetWidth()/2 - 102, windowToDisplay:GetHeight() - (70 + valToAdd));
	LabelDestinyPoints:SetSize( 25, 25 );
	LabelDestinyPoints:SetVisible(true);
	LabelDestinyPoints:SetBackground(0x411020E9);
	LabelDestinyPoints:SetZOrder(-1);
	LabelDestinyPoints:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.MessagePoints=Turbine.UI.Label(); 
	windowToDisplay.MessagePoints:SetParent(windowToDisplay); 
	windowToDisplay.MessagePoints:SetSize(200, 30); 
	windowToDisplay.MessagePoints:SetPosition(windowToDisplay:GetWidth()/2 - 72, windowToDisplay:GetHeight() - (72 + valToAdd)); 
	windowToDisplay.MessagePoints:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	windowToDisplay.MessagePoints:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.MessagePoints:SetText(comma_value(PlayerAttr:GetDestinyPoints())); 
	windowToDisplay.MessagePoints:SetForeColor(Turbine.UI.Color.Gold);
	--windowToDisplay.MessageP:SetBackColor(Turbine.UI.Color.Lime);
end
------------------------------------------------------------------------------------------
-- function to display lotro coins --
------------------------------------------------------------------------------------------
function DisplayLotroCoins(windowToDisplay, namePlayerToshow)
	local valToAdd = (windowToDisplay == UIShowWallet) and 450 or 0;

	local LabelLotroCoins = Turbine.UI.Label(); 
	LabelLotroCoins:SetParent( windowToDisplay );
	LabelLotroCoins:SetPosition(windowToDisplay:GetWidth()/2 + 40, windowToDisplay:GetHeight() - (70 + valToAdd));
	LabelLotroCoins:SetSize( 25, 25 );
	LabelLotroCoins:SetVisible(true);
	LabelLotroCoins:SetBackground(0x411045ED);
	LabelLotroCoins:SetZOrder(10);
	LabelLotroCoins:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	LabelLotroCoins:SetMouseVisible( true );

	windowToDisplay.MessageP=Turbine.UI.Label(); 
	windowToDisplay.MessageP:SetParent(windowToDisplay); 
	windowToDisplay.MessageP:SetSize(200, 30); 
	windowToDisplay.MessageP:SetPosition(windowToDisplay:GetWidth()/2 + 75, windowToDisplay:GetHeight() - (72 + valToAdd)); 
	windowToDisplay.MessageP:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	windowToDisplay.MessageP:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.MessageP:SetText(comma_value(settings["lotroCoins"]["value"])); 
	windowToDisplay.MessageP:SetForeColor(Turbine.UI.Color.Gold);
	
	-- show the label to update coins
	local ButtonPlusCash = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusCash:SetParent( windowToDisplay );
	ButtonPlusCash:SetPosition(windowToDisplay:GetWidth()/2 + 70, windowToDisplay:GetHeight() - (90 + valToAdd));
	ButtonPlusCash:SetSize( 180, 30 );
	ButtonPlusCash:SetVisible(false);
	ButtonPlusCash:SetZOrder(20);
	ButtonPlusCash:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelCash = Turbine.UI.Label();
	centerLabelCash:SetParent(ButtonPlusCash);
	centerLabelCash:SetPosition( 2, 2 );
	centerLabelCash:SetSize( 176, 26  );
	centerLabelCash:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	centerLabelCash:SetText( T[ "PluginWalletWindow8" ] );

	centerLabelCash:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelCash:SetZOrder(21);
	centerLabelCash:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	LabelLotroCoins.MouseEnter = function()
		ButtonPlusCash:SetVisible(true);
	end

	LabelLotroCoins.MouseLeave = function()
		ButtonPlusCash:SetVisible(false);
	end

	LabelLotroCoins.MouseClick = function()
		UIShowWallet:SetVisible(false);
		settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
		CreateUIShowLotro(namePlayerToshow);
		settings["isLotroWindowVisible"]["value"] = true;
		UIShowLotro:SetVisible(true);
	end
end
------------------------------------------------------------------------------------------
--function to display the session cash --
------------------------------------------------------------------------------------------
function DisplaySessionCash()
	local currentCash = math.max(0, tonumber(settings["sessionCash"]["cashSession"]) or 0);
	local valToAdd = 0;

	if settings["displaySpentCash"]["value"] == true then
		valToAdd = 10;
		CreateMoneySectionTitle(
			AltHolicWindow,
			T["PluginCashWindow3"],
			AltHolicWindow:GetHeight() - (85 + valToAdd),
			AltHolicWindow:GetHeight() - (78 + valToAdd),
			Turbine.UI.Color.Blue
		);
	end

	CreateMoneyRow(
		AltHolicWindow,
		currentCash,
		AltHolicWindow:GetHeight() - (55 + valToAdd),
		AltHolicWindow:GetHeight() - (61 + valToAdd)
	);
	CreateMoneyCaption(AltHolicWindow, T["PluginCashWindow4"], AltHolicWindow:GetHeight() - (61 + valToAdd));
end
------------------------------------------------------------------------------------------
--function to display the session spent cash --
------------------------------------------------------------------------------------------

function DisplaySpentCash()
	local spentCash = math.max(0, tonumber(settings["sessionCash"]["cashSpent"]) or 0);
	CreateMoneyRow(AltHolicWindow, spentCash, AltHolicWindow:GetHeight() - 45, AltHolicWindow:GetHeight() - 51);
	CreateMoneyCaption(AltHolicWindow, T["PluginCashWindow5"], AltHolicWindow:GetHeight() - 51);
end
------------------------------------------------------------------------------------------
--function to display the cash for the cash window --
------------------------------------------------------------------------------------------

function DisplayGenderLabel(i, posx, posy, buttonToDisplay)
	ButtonPlusSexe[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusSexe[i]:SetParent( AltHolicWindow );
	--ButtonPlusSexe[i]:SetPosition(posx + 55 , posy + 105);
	if(settings["displayServers"]["value"] == true)then
		ButtonPlusSexe[i]:SetPosition(150 , 40);
	else
		ButtonPlusSexe[i]:SetPosition(120 , 40);
	end
	ButtonPlusSexe[i]:SetSize( 180, 30 );
	ButtonPlusSexe[i]:SetVisible(false);
	ButtonPlusSexe[i]:SetZOrder(20);
	ButtonPlusSexe[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelSexe[i] = Turbine.UI.Label();
	centerLabelSexe[i]:SetParent(ButtonPlusSexe[i]);
	centerLabelSexe[i]:SetPosition( 2, 2 );
	centerLabelSexe[i]:SetSize( 176, 26  );
	centerLabelSexe[i]:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelSexe[i]:SetText( T[ "reputposition100" ] ); -- reputations
	centerLabelSexe[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelSexe[i]:SetZOrder(21);
	centerLabelSexe[i]:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	if(PlayerDatas[i].align == 1)then
		buttonToDisplay.MouseEnter = function()
			ButtonPlusSexe[i]:SetVisible(true);
		end

		buttonToDisplay.MouseLeave = function()
			ButtonPlusSexe[i]:SetVisible(false);
		end
	end

	if(PlayerDatas[i].align == 1)then
		buttonToDisplay.MouseClick = function()
			if(settings["isReputWindowVisible"]["isReputWindowVisible"] == false)then
				CreateUIShowReput(i);
				settings["isReputWindowVisible"]["isReputWindowVisible"] = true;
				UIShowReput:SetVisible(true);
			else
				settings["isReputWindowVisible"]["isReputWindowVisible"] = false;
				UIShowReput:SetVisible(false);
			end
		end
	end
end
------------------------------------------------------------------------------------------
--function to display the delete icons --
------------------------------------------------------------------------------------------
function DisplayLabelDelete(i, posx, posy, buttonToDisplay)
	ButtonPlusDelete[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusDelete[i]:SetParent( AltHolicWindow );
	--ButtonPlusServer[i]:SetPosition(posx + 55 , posy + 105);
	if(settings["displayServers"]["value"] == true)then
		ButtonPlusDelete[i]:SetPosition(150 , 40);
	else
		ButtonPlusDelete[i]:SetPosition(120 , 40);
	end
	ButtonPlusDelete[i]:SetSize( 180, 30 );
	ButtonPlusDelete[i]:SetVisible(false);
	ButtonPlusDelete[i]:SetZOrder(20);
	ButtonPlusDelete[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelDelete[i] = Turbine.UI.Label();
	centerLabelDelete[i]:SetParent(ButtonPlusDelete[i]);
	centerLabelDelete[i]:SetPosition( 2, 2 );
	centerLabelDelete[i]:SetSize( 176, 26  );
	
	local longueurName = string.len(i);
	if(longueurName > 9)then
		if(longueurName > 13)then
			centerLabelDelete[i]:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		else
			centerLabelDelete[i]:SetFont(Turbine.UI.Lotro.Font.Verdana18);
		end
	else
		centerLabelDelete[i]:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	end
	centerLabelDelete[i]:SetText( T[ "PluginDelete" ] .. " " .. tostring(i) );
	centerLabelDelete[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelDelete[i]:SetZOrder(21);
	centerLabelDelete[i]:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	buttonToDisplay.MouseEnter = function()
		ButtonPlusDelete[i]:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusDelete[i]:SetVisible(false);
	end

	buttonToDisplay.MouseClick = function()
		CreateToBeSurWindow(i, 1);
		ToBeSurWindow:SetVisible(true);
		settings["isToBeSurWindowVisible"]["value"] = true;
	end
end
------------------------------------------------------------------------------------------
--function to display the serverName of the player in a small label --
------------------------------------------------------------------------------------------
function DisplayLabelServerName(i, posx, posy, buttonToDisplay)
	ButtonPlusServer[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusServer[i]:SetParent( AltHolicWindow );
	--ButtonPlusServer[i]:SetPosition(posx + 55 , posy + 105);
	if(settings["displayServers"]["value"] == true)then
		ButtonPlusServer[i]:SetPosition(150 , 40);
	else
		ButtonPlusServer[i]:SetPosition(120 , 40);
	end
	ButtonPlusServer[i]:SetSize( 180, 30 );
	ButtonPlusServer[i]:SetVisible(false);
	ButtonPlusServer[i]:SetZOrder(20);
	ButtonPlusServer[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelServer[i] = Turbine.UI.Label();
	centerLabelServer[i]:SetParent(ButtonPlusServer[i]);
	centerLabelServer[i]:SetPosition( 2, 2 );
	centerLabelServer[i]:SetSize( 176, 26  );
	centerLabelServer[i]:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelServer[i]:SetText( PlayerDatas[i].serverName );
	centerLabelServer[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelServer[i]:SetZOrder(21);
	centerLabelServer[i]:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	buttonToDisplay.MouseEnter = function()
		ButtonPlusServer[i]:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusServer[i]:SetVisible(false);
	end

	buttonToDisplay.MouseClick = function()
		if ServerNameWindow ~= nil and ServerNameWindow:IsVisible() then
			ServerNameWindow:SetVisible(false);
			settings["isServerWindowVisible"]["value"] = false;
		else
			GenerateServerNameWindow(i);
			settings["isServerWindowVisible"]["value"] = true;
			ServerNameWindow:SetVisible(true);
		end
	end
end
------------------------------------------------------------------------------------------
--function to display the cash of the player in a small label --
------------------------------------------------------------------------------------------
function DisplayLabelStats(i, posx, posy, buttonToDisplay)
	ButtonPlusStats[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusStats[i]:SetParent( AltHolicWindow );
	--ButtonPlusStats[i]:SetPosition(posx + 55 , posy + 105);
	if(settings["displayServers"]["value"] == true)then
		ButtonPlusStats[i]:SetPosition(150 , 40);
	else
		ButtonPlusStats[i]:SetPosition(120 , 40);
	end
	ButtonPlusStats[i]:SetSize( 180, 30 );
	ButtonPlusStats[i]:SetVisible(false);
	ButtonPlusStats[i]:SetZOrder(40);
	ButtonPlusStats[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelStats[i] = Turbine.UI.Label();
	centerLabelStats[i]:SetParent(ButtonPlusStats[i]);
	centerLabelStats[i]:SetPosition( 2, 2 );
	centerLabelStats[i]:SetSize( 176, 26  );
	centerLabelStats[i]:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelStats[i]:SetText( T[ "PluginStats11" ] );
	centerLabelStats[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelStats[i]:SetZOrder(41);
	centerLabelStats[i]:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );

	if(PlayerDatas[i].align == 1)then
		buttonToDisplay.MouseEnter = function()
			ButtonPlusStats[i]:SetVisible(true);
		end

		buttonToDisplay.MouseLeave = function()
			ButtonPlusStats[i]:SetVisible(false);
		end
	end

	buttonToDisplay.MouseClick = function()
		if(settings["isShowStatsVisible"]["isShowStatsVisible"] == false)then
			CreateUIShowStats(i);
			settings["isShowStatsVisible"]["isShowStatsVisible"] = true;
			UIShowStats:SetVisible(true);
		else
			settings["isShowStatsVisible"]["isShowStatsVisible"] = false;
			UIShowStats:SetVisible(false);
		end
	end
end
------------------------------------------------------------------------------------------
--function to display the infos window --
------------------------------------------------------------------------------------------
function DisplayInfosWindow(posx, posy)
	local ButtonInfos = Turbine.UI.Extensions.SimpleWindow();
	ButtonInfos:SetParent( AltHolicWindow );
	ButtonInfos:SetPosition(posx, posy);
	ButtonInfos:SetSize( 150, 20 );
	ButtonInfos:SetVisible(true);
	ButtonInfos:SetZOrder(20);
	--ButtonInfos:SetBackColor(Turbine.UI.Color.Lime);

	ButtonInfos.MouseEnter = function()
		AltHolicInfosWindow:SetVisible(true);
	end

	ButtonInfos.MouseLeave = function()
		AltHolicInfosWindow:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
-- function to display the text of the object when showing by icones --
------------------------------------------------------------------------------------------
function DisplayLabelForIcons(i, posx, posy, windowToDisplay, buttonToDisplay, texteNbr, texte)
	local size = string.len(texte);

	if((size * 8) < 150)then
		size = 150;
	else
		size = size * 8;
	end

	ButtonPlusStats[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusStats[i]:SetParent( windowToDisplay );
	ButtonPlusStats[i]:SetPosition(posx + 55 , posy + 105);
	ButtonPlusStats[i]:SetSize( size, 40 );
	ButtonPlusStats[i]:SetVisible(false);
	ButtonPlusStats[i]:SetZOrder(20);
	ButtonPlusStats[i]:SetBackColor( Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ) );

	centerLabelStats[i] = Turbine.UI.Label();
	centerLabelStats[i]:SetParent(ButtonPlusStats[i]);
	centerLabelStats[i]:SetPosition( 2, 2 );
	centerLabelStats[i]:SetSize( size - 4, 36  );
	centerLabelStats[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
	centerLabelStats[i]:SetText( "  " .. texteNbr );
	centerLabelStats[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	centerLabelStats[i]:SetZOrder(21);
	centerLabelStats[i]:SetForeColor(Turbine.UI.Color.Gold);
	centerLabelStats[i]:SetBackColor( Turbine.UI.Color( 0.95, 0.3, 0.3, 0.3 ) );

	centerLabelStats2[i] = Turbine.UI.Label();
	centerLabelStats2[i]:SetParent(ButtonPlusStats[i]);
	centerLabelStats2[i]:SetPosition( 30, 2 );
	centerLabelStats2[i]:SetSize( size - 34, 36  );
	centerLabelStats2[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua16);
	centerLabelStats2[i]:SetText( texte );
	centerLabelStats2[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelStats2[i]:SetZOrder(22);
	centerLabelStats2[i]:SetBackColor( Turbine.UI.Color( 0.95, 0.3, 0.3, 0.3 ) );

	--buttonToDisplay:SetBackColor(Turbine.UI.Color.Lime);


	buttonToDisplay.MouseEnter = function()
		ButtonPlusStats[i]:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusStats[i]:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
--function to display button for add new --
------------------------------------------------------------------------------------------
function DisplayLabel(val, positionLabelVert, positionLabelHori, textLabel, imageButton)
	buttonPlus[val] = Turbine.UI.Extensions.SimpleWindow();
	buttonPlus[val]:SetParent( AltHolicWindow );
	buttonPlus[val]:SetPosition(positionLabelVert, positionLabelHori);
	buttonPlus[val]:SetSize( 15, 15 );
	buttonPlus[val]:SetVisible(true);

	centerLabelB[val] = Turbine.UI.Label();
	centerLabelB[val]:SetParent(buttonPlus[val]);
	centerLabelB[val]:SetPosition( 0, 0 );
	centerLabelB[val]:SetSize( 20, 20  );
	centerLabelB[val]:SetBackground(ResourcePath .. imageButton);
	centerLabelB[val]:SetZOrder(-1);
	centerLabelB[val]:SetMouseVisible(false);

	ButtonPlusLabel[val] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLabel[val]:SetParent( AltHolicWindow );
	ButtonPlusLabel[val]:SetPosition(positionLabelVert + 25 , positionLabelHori - 5);
	ButtonPlusLabel[val]:SetSize( 180, 30 );
	ButtonPlusLabel[val]:SetZOrder(10000);
	ButtonPlusLabel[val]:SetVisible(false);
	ButtonPlusLabel[val]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabel[val] = Turbine.UI.Label();
	centerLabelBLabel[val]:SetParent(ButtonPlusLabel[val]);
	centerLabelBLabel[val]:SetPosition( 2, 2 );
	centerLabelBLabel[val]:SetSize( 176, 26  );
	centerLabelBLabel[val]:SetText( textLabel );
	centerLabelBLabel[val]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabel[val]:SetZOrder(-1);
	centerLabelBLabel[val]:SetBackColor( Turbine.UI.Color( .6, .1, .4, .9) );

	buttonPlus[val].MouseEnter = function()
		ButtonPlusLabel[val]:SetVisible(true);
	end

	buttonPlus[val].MouseLeave = function()
		ButtonPlusLabel[val]:SetVisible(false);
	end

	if(val == 1)then
		buttonPlus[val].MouseClick = function()
			CreateAddNewWindow();
			AltHolicWindow:SetVisible(false);
			AltHolicAddnewWindow:SetVisible(true);
		end
	end
end
------------------------------------------------------------------------------------------
--function to display button for add new --
------------------------------------------------------------------------------------------
function DisplayLabelEpique(val, positionLabelVert, positionLabelHori, textLabel, imageButton, whereToShow)
	centerLabelB[val] = Turbine.UI.Control();
	centerLabelB[val]:SetParent(whereToShow);
	centerLabelB[val]:SetPosition( positionLabelVert, positionLabelHori );
	centerLabelB[val]:SetSize( 15, 15  );
	centerLabelB[val]:SetBackground(ResourcePath .. imageButton);
	centerLabelB[val]:SetZOrder(-1);
	centerLabelB[val]:SetMouseVisible(true);
	centerLabelB[val]:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	ButtonPlusLabel[val] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLabel[val]:SetParent( whereToShow );
	ButtonPlusLabel[val]:SetPosition(positionLabelVert + 20 , positionLabelHori - 25);
	ButtonPlusLabel[val]:SetSize( 180, 30 );
	ButtonPlusLabel[val]:SetZOrder(10000);
	ButtonPlusLabel[val]:SetVisible(false);
	ButtonPlusLabel[val]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabel[val] = Turbine.UI.Label();
	centerLabelBLabel[val]:SetParent(ButtonPlusLabel[val]);
	centerLabelBLabel[val]:SetPosition( 2, 2 );
	centerLabelBLabel[val]:SetSize( 176, 26  );
	centerLabelBLabel[val]:SetText( textLabel );
	centerLabelBLabel[val]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabel[val]:SetZOrder(-1);
	centerLabelBLabel[val]:SetBackColor( Turbine.UI.Color( .6, .1, .4, .9) );

	centerLabelB[val].MouseEnter = function()
		ButtonPlusLabel[val]:SetVisible(true);
	end

	centerLabelB[val].MouseLeave = function()
		ButtonPlusLabel[val]:SetVisible(false);
	end

	centerLabelB[val].MouseClick = function()
		CreateAddNewWindowEpique(nil);
		AltHolicAddnewWindowEpique:SetVisible(true);
	end
end
------------------------------------------------------------------------------------------
--function to display the small label for professions --
------------------------------------------------------------------------------------------
function DisplayProfessionIconsOnRow(playerName, posx, posy)
    RefreshCurrentPlayerProfessions(playerName);

    local professions = GetSavedProfessions(playerName);
    local slotSize    = 32;
    local slotCount   = 4;

    local drawable = {};
    if professions ~= nil then
        for index = 1, #professions do
            -- Resolve the icon exactly the way the crafting popup does, which is the
            -- path known to succeed: prefer the Icon saved alongside the profession
            -- and only fall back to looking it up from the key/name.
            local profession = professions[index];
            local iconFile = profession.Icon;
            if iconFile == nil then
                iconFile = GetProfessionSmallIconFile(profession.Key, profession.Name);
            end
            if iconFile ~= nil then table.insert(drawable, iconFile); end
            if #drawable >= slotCount then break; end
        end
    end

    -- One-off diagnostics: prints what each row actually resolved, so a blank strip
    -- can be told apart from a lookup that returned nothing. Turn off by setting
    -- AltHolicIconDebug = false (or /altholic is unaffected).
    if AltHolicIconDebug == true and Turbine ~= nil and Turbine.Shell ~= nil then
        local count = 0;
        if professions ~= nil then count = #professions; end
        local first = "-";
        if professions ~= nil and professions[1] ~= nil then
            first = tostring(professions[1].Key) .. "/" .. tostring(professions[1].Name) ..
                    "/" .. tostring(professions[1].Icon) ..
                    "/" .. tostring(GetProfessionSmallIconFile(professions[1].Key, professions[1].Name));
        end
        Turbine.Shell.WriteLine("AltHolic dbg " .. tostring(playerName) ..
            ": profs=" .. tostring(count) ..
            " drawable=" .. tostring(#drawable) ..
            " [" .. first .. "]");
    end

    if CraftingRowControls == nil then CraftingRowControls = {}; end
    CraftingRowControls[playerName] = {};

    -- A black tile under every slot, so the strip reads as a solid black block that
    -- matches the window interior and an unused slot is black rather than a gap.
    -- This is a real texture drawn the same way as the icons; SetBackColor on a bare
    -- Control paints a washed-out grey panel instead of the colour asked for.
    for index = 1, slotCount do
        local tile = Turbine.UI.Label();
        tile:SetParent(viewport1.map);
        tile:SetPosition(posx + ((index - 1) * slotSize), posy);
        tile:SetSize(slotSize, slotSize);
        tile:SetZOrder(18);
        tile:SetMouseVisible(false);
        tile:SetVisible(true);
        tile:SetBackground(ResourcePath .. "Prof_Slot.tga");
        tile:SetStretchMode(1);
        CraftingRowControls[playerName]["tile" .. index] = tile;
    end

    -- The icons are round with transparent corners and sit on top of those tiles.
    for index = 1, #drawable do
        local iconFile = drawable[index];

        local icon = Turbine.UI.Label();
        icon:SetParent(viewport1.map);
        icon:SetPosition(posx + ((index - 1) * slotSize), posy);
        icon:SetSize(slotSize, slotSize);
        icon:SetZOrder(19);
        icon:SetMouseVisible(false);
        icon:SetVisible(true);
        icon:SetBackground(ResourcePath .. iconFile);
        -- Required: inside viewport1.map a file-path .tga is not drawn without a
        -- stretch mode. Every icon that renders in these rows natively (bag, vault,
        -- wallet, class, race) uses a numeric texture ID instead, and 4.62 -- the one
        -- build that ever drew artwork here -- was the one that set a stretch mode.
        -- With the control and the texture both 32x32 it draws 1:1, no overflow.
        icon:SetStretchMode(1);
        CraftingRowControls[playerName][index] = icon;
    end

    DisplaySmallLabel(playerName, posx, posy, T[ "PluginCrafting" ] or "Crafting",
                      slotSize * slotCount, slotSize);
end

------------------------------------------------------------------------------------------
-- Display modern profession details. This replaces the old vocation-driven implementation.
------------------------------------------------------------------------------------------
function DisplaySmallLabel(i, posx, posy, texte, triggerWidth, triggerHeight)
    if i == nil then i = PlayerName; end

    RefreshCurrentPlayerProfessions(i);

    local professions = GetSavedProfessions(i);
    triggerWidth = triggerWidth or 45;
    triggerHeight = triggerHeight or 45;

    -- Detach the previous popup window for this character before creating a new one.
    -- ButtonPlusVoc[i] is parented to AltHolicWindow; without explicit detach the old
    -- SimpleWindow stays alive as a child and accumulates across repeated window rebuilds.
    if ButtonPlusVoc[i] ~= nil then
        pcall(function() ButtonPlusVoc[i]:SetParent(nil); end);
        ButtonPlusVoc[i] = nil;
    end

    local hoverControl = Turbine.UI.Control();
    hoverControl:SetParent(viewport1.map);
    hoverControl:SetPosition(posx, posy);
    hoverControl:SetSize(triggerWidth, triggerHeight);
    hoverControl:SetVisible(true);
    hoverControl:SetZOrder(20);
    hoverControl:SetMouseVisible(true);
    -- No SetBackColor here. A Control given a back colour renders a washed-out grey
    -- panel over whatever is behind it, even with the alpha set to zero -- that is
    -- the "see-through square" that sat in this cell. With no back colour at all the
    -- control is invisible and still receives MouseEnter/MouseLeave.

    -- Track this hover control so PopulateWindow can detach it on the next rebuild.
    if CraftingHoverControls == nil then CraftingHoverControls = {}; end
    CraftingHoverControls[i] = hoverControl;

    ButtonPlusVoc[i] = Turbine.UI.Extensions.SimpleWindow();
    ButtonPlusVoc[i]:SetParent(AltHolicWindow);
    ButtonPlusVoc[i]:SetSize(380, 420);

    if (Turbine.UI.Display:GetWidth() / 2) < tonumber(settings["windowPosition"]["xPos"]) then
        ButtonPlusVoc[i]:SetPosition(posx - 900, (Turbine.UI.Display:GetHeight() - ButtonPlusVoc[i]:GetHeight()) / 2);
    else
        ButtonPlusVoc[i]:SetPosition(posx + 242, (Turbine.UI.Display:GetHeight() - ButtonPlusVoc[i]:GetHeight()) / 2);
    end

    ButtonPlusVoc[i]:SetVisible(false);
    ButtonPlusVoc[i]:SetZOrder(100);
    ButtonPlusVoc[i]:SetBackground(ResourcePath .. "/Cadre_380_420.tga");

    centerLabelBVoc[i] = Turbine.UI.Label();
    centerLabelBVoc[i]:SetParent(ButtonPlusVoc[i]);
    centerLabelBVoc[i]:SetPosition(40, 5);
    centerLabelBVoc[i]:SetSize(300, 30);
    centerLabelBVoc[i]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
    centerLabelBVoc[i]:SetText(texte or "Crafting");
    centerLabelBVoc[i]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    centerLabelBVoc[i]:SetZOrder(101);
    centerLabelBVoc[i]:SetForeColor(Turbine.UI.Color.Gold);

    -- Each character gets its own arrays of child controls. The old code reused [i]
    -- for every profession and continually lost references to previously-created controls.
    centerLabelProf1[i] = {};
    centerLabelProfIcon[i] = {};
    centerLabelTier1[i] = {};
    centerLabelTier2[i] = {};

    if professions ~= nil and #professions > 0 then
        local rowHeight = 88;
        local startY = 48;
        local visibleCount = math.min(#professions, 4);

        for x = 1, visibleCount do
            local profession = professions[x];
            local rowY = startY + ((x - 1) * rowHeight);

            centerLabelProf1[i][x] = Turbine.UI.Label();
            centerLabelProf1[i][x]:SetParent(ButtonPlusVoc[i]);
            centerLabelProf1[i][x]:SetPosition(65, rowY);
            centerLabelProf1[i][x]:SetSize(280, 24);
            centerLabelProf1[i][x]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
            centerLabelProf1[i][x]:SetText(profession.Name or "Unknown profession");
            centerLabelProf1[i][x]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            centerLabelProf1[i][x]:SetZOrder(102);

            centerLabelProfIcon[i][x] = Turbine.UI.Label();
            centerLabelProfIcon[i][x]:SetParent(ButtonPlusVoc[i]);
            centerLabelProfIcon[i][x]:SetPosition(25, rowY);
            centerLabelProfIcon[i][x]:SetSize(32, 32);
            centerLabelProfIcon[i][x]:SetZOrder(102);
            local iconFile = profession.Icon or GetProfessionIconFile(profession.Key, profession.Name);
            if iconFile ~= nil then
                centerLabelProfIcon[i][x]:SetBackground(ResourcePath .. iconFile);
            end

            local proficiencyText = profession.CurrentLvl or "";

            centerLabelTier1[i][x] = Turbine.UI.Label();
            centerLabelTier1[i][x]:SetParent(ButtonPlusVoc[i]);
            centerLabelTier1[i][x]:SetPosition(65, rowY + 23);
            centerLabelTier1[i][x]:SetSize(285, 30);
            centerLabelTier1[i][x]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            centerLabelTier1[i][x]:SetText(proficiencyText);
            centerLabelTier1[i][x]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            centerLabelTier1[i][x]:SetZOrder(102);
            centerLabelTier1[i][x]:SetForeColor(Turbine.UI.Color(0.8, 0.4, 0.2));

            local masteryText = profession.CurrentMastery or "";

            centerLabelTier2[i][x] = Turbine.UI.Label();
            centerLabelTier2[i][x]:SetParent(ButtonPlusVoc[i]);
            centerLabelTier2[i][x]:SetPosition(65, rowY + 50);
            centerLabelTier2[i][x]:SetSize(285, 30);
            centerLabelTier2[i][x]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold16);
            centerLabelTier2[i][x]:SetText(masteryText);
            centerLabelTier2[i][x]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
            centerLabelTier2[i][x]:SetZOrder(102);
            centerLabelTier2[i][x]:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));
        end
    else
        centerLabelProf1[i][1] = Turbine.UI.Label();
        centerLabelProf1[i][1]:SetParent(ButtonPlusVoc[i]);
        centerLabelProf1[i][1]:SetPosition(40, 100);
        centerLabelProf1[i][1]:SetSize(300, 100);
        centerLabelProf1[i][1]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
        centerLabelProf1[i][1]:SetText(T[ "PluginStats10" ] or "No crafting data saved.");
        centerLabelProf1[i][1]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
        centerLabelProf1[i][1]:SetZOrder(102);
    end

    -- Optional integration retained from the original plugin. Plugin discovery is
    -- centralized/cached instead of scanning the complete plugin list for every row.
    local recipeTrackerIsInstalled = AltHolicUtil.IsPluginAvailable("RecipeTracker v2");

    if recipeTrackerIsInstalled == true then
        local releaseWindow = Turbine.UI.Extensions.SimpleWindow();
        releaseWindow:SetSize(triggerWidth, triggerHeight);
        releaseWindow:SetParent(hoverControl);
        releaseWindow:SetPosition(0, 0);
        releaseWindow:SetOpacity(0);
        releaseWindow:SetVisible(true);

        local releaseQSBack = Turbine.UI.Control();
        releaseQSBack:SetParent(releaseWindow);
        releaseQSBack:SetZOrder(-1);
        releaseQSBack:SetSize(triggerWidth, triggerHeight);

        local releaseQS = Turbine.UI.Lotro.Quickslot();
        releaseQS:SetParent(releaseQSBack);
        releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "/recipetracker show"));
        releaseQS:SetSize(triggerWidth, triggerHeight);
        releaseQS:SetPosition(0, 0);
        releaseQS:SetAllowDrop(false);
        releaseQS:SetOpacity(0);
        releaseQS:SetZOrder(-1);
    end

    hoverControl.MouseEnter = function()
        ButtonPlusVoc[i]:SetVisible(true);
    end

    hoverControl.MouseLeave = function()
        ButtonPlusVoc[i]:SetVisible(false);
    end
end
------------------------------------------------------------------------------------------
--function to display the small label for sharedStorage --
------------------------------------------------------------------------------------------
function DisplayLabelCadreForSharedStorage(posx, posy, texte, buttonToDisplay)
	local ButtonPlusLab22 = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab22:SetParent( AltHolicWindow );
	ButtonPlusLab22:SetPosition(posx + 40 , posy - 5);
	ButtonPlusLab22:SetSize( 180, 30 );
	ButtonPlusLab22:SetVisible(false);
	ButtonPlusLab22:SetZOrder(20);
	ButtonPlusLab22:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLab22 = Turbine.UI.Label();
	centerLabelBLab22:SetParent(ButtonPlusLab22);
	centerLabelBLab22:SetPosition( 2, 2 );
	centerLabelBLab22:SetSize( 176, 26  );
	centerLabelBLab22:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLab22:SetText( texte );
	centerLabelBLab22:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLab22:SetZOrder(21);
	centerLabelBLab22:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	buttonToDisplay.MouseEnter = function()
		ButtonPlusLab22:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusLab22:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
--function to display the small label for search --
------------------------------------------------------------------------------------------
function DisplayLabelCadreForSearch(posx, posy, buttonToDisplay, iconControl)

	local ButtonPlusLab2 = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab2:SetParent( AltHolicWindow );
	ButtonPlusLab2:SetPosition(posx + 40 , posy - 5);
	ButtonPlusLab2:SetSize( 180, 30 );
	ButtonPlusLab2:SetVisible(false);
	ButtonPlusLab2:SetZOrder(20);
	ButtonPlusLab2:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	local centerLabelBLab2 = Turbine.UI.Label();
	centerLabelBLab2:SetParent(ButtonPlusLab2);
	centerLabelBLab2:SetPosition( 2, 2 );
	centerLabelBLab2:SetSize( 176, 26  );
	centerLabelBLab2:SetFont(Turbine.UI.Lotro.Font.Verdana20);
	centerLabelBLab2:SetText( T[ "PluginSearch2" ] );
	centerLabelBLab2:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLab2:SetZOrder(21);
	centerLabelBLab2:SetBackColor( Turbine.UI.Color( .8, .1, .4, .9) );

	buttonToDisplay.MouseEnter = function()
		ButtonPlusLab2:SetVisible(true);
		if iconControl ~= nil then iconControl:SetBackground(0x410D6DC3); end
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusLab2:SetVisible(false);
		if iconControl ~= nil then iconControl:SetBackground(0x410D6DC2); end
	end
end
------------------------------------------------------------------------------------------
--function to display the small label for equipment --
------------------------------------------------------------------------------------------
function DisplayLabelEquipment(i,  posx, posy, namePlayerToshow, buttonToDisplay)
	-- display small label with description
	
	ButtonEquipItem[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonEquipItem[i]:SetParent( UIShowEquip );
	ButtonEquipItem[i]:SetPosition(posx + 120 , UIShowEquip:GetHeight() - 450);
	ButtonEquipItem[i]:SetSize( 300, 300 );
	ButtonEquipItem[i]:SetVisible(false);
	ButtonEquipItem[i]:SetZOrder(20);
	ButtonEquipItem[i]:SetBackground(ResourcePath .. "/Cadre_300_300.tga");

	centerEquipItem[i] = Turbine.UI.Label();
	centerEquipItem[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem[i]:SetPosition( 10, 50 );
	centerEquipItem[i]:SetSize( 280, 180 );
	centerEquipItem[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	local tmpDesc = string.find(tostring(PlayerEquipement[namePlayerToshow][i].D), "error");
	if(tmpDesc == nil)then
		if(PlayerEquipement[namePlayerToshow][i].D ~= nil)then
			centerEquipItem[i]:SetText(T[ "PluginDescription" ] .. " : \n" .. tostring(PlayerEquipement[namePlayerToshow][i].D) );
		else
			centerEquipItem[i]:SetText(T[ "PluginDescription" ] .. " : \n" );
		end
	else
		centerEquipItem[i]:SetText(T[ "PluginDescription" ] .. " : \n" );
	end
	centerEquipItem[i]:SetTextAlignment( Turbine.UI.ContentAlignment.TopLeft );
	centerEquipItem[i]:SetZOrder(21);

	centerEquipItem2ab[i] = Turbine.UI.Label();
	centerEquipItem2ab[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem2ab[i]:SetPosition( 5, 5 );
	centerEquipItem2ab[i]:SetSize( 40, 40  );
	centerEquipItem2ab[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	centerEquipItem2ab[i]:SetBackground(0x410e8680);
	--centerEquipItem2[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	centerEquipItem2ab[i]:SetZOrder(20);

	centerEquipItem2a[i] = Turbine.UI.Label();
	centerEquipItem2a[i]:SetParent(centerEquipItem2ab[i]);
	centerEquipItem2a[i]:SetPosition( 5, 5 );
	centerEquipItem2a[i]:SetSize( 32, 32  );
	centerEquipItem2a[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	centerEquipItem2a[i]:SetBackground(tonumber(PlayerEquipement[namePlayerToshow][i].B));
	--centerEquipItem2[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	centerEquipItem2a[i]:SetZOrder(20);

	centerEquipItem2[i] = Turbine.UI.Label();
	centerEquipItem2[i]:SetParent(centerEquipItem2ab[i]);
	centerEquipItem2[i]:SetPosition( 5, 5 );
	centerEquipItem2[i]:SetSize( 32, 32  );
	centerEquipItem2[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	centerEquipItem2[i]:SetText( "" );
	centerEquipItem2[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	centerEquipItem2[i]:SetBackground(tonumber(PlayerEquipement[namePlayerToshow][i].I));
	centerEquipItem2[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	centerEquipItem2[i]:SetZOrder(21);

	centerEquipItem3[i] = Turbine.UI.Label();
	centerEquipItem3[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem3[i]:SetPosition( 55, 5 );
	centerEquipItem3[i]:SetSize( 245, 32  );
	centerEquipItem3[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	centerEquipItem3[i]:SetText(PlayerEquipement[namePlayerToshow][i].N );
	centerEquipItem3[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	centerEquipItem3[i]:SetZOrder(21);

	centerEquipItem9[i] = Turbine.UI.Label();
	centerEquipItem9[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem9[i]:SetPosition( 5, 230 );
	centerEquipItem9[i]:SetSize( 245, 32  );
	centerEquipItem9[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	if(PlayerEquipement[namePlayerToshow][i].lvl ~= nil and PlayerEquipement[namePlayerToshow][i].lvl ~= 0)then
		centerEquipItem9[i]:SetText( T[ "PluginEquipement3" ] .. " : " .. tostring(PlayerEquipement[namePlayerToshow][i].lvl));
	else
		centerEquipItem9[i]:SetText("");
	end
	centerEquipItem9[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	centerEquipItem9[i]:SetZOrder(22);

	centerEquipItem19[i] = Turbine.UI.Label();
	centerEquipItem19[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem19[i]:SetPosition( 5, 210 );
	centerEquipItem19[i]:SetSize( 245, 32  );
	centerEquipItem19[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	if(PlayerEquipement[namePlayerToshow][i].armor ~= nil and PlayerEquipement[namePlayerToshow][i].armor ~= 0 and PlayerEquipement[namePlayerToshow][i].armor ~= "")then
		if(i == "PrimaryWeapon" or
			i == "RangedWeapon")then
			centerEquipItem19[i]:SetText( "DPS : " .. tostring(PlayerEquipement[namePlayerToshow][i].armor));
		elseif(i == "Shield")then
			if(PlayerEquipement[namePlayerToshow][i].CAT == 33)then
				centerEquipItem19[i]:SetText( T[ "PluginEquipement4" ] .. " : " .. comma_value(tostring(PlayerEquipement[namePlayerToshow][i].armor)));
			else
				centerEquipItem19[i]:SetText( "DPS : " .. comma_value(tostring(PlayerEquipement[namePlayerToshow][i].armor)));
			end
		elseif(i == "Bracelet1" or
			i == "Bracelet2" or
			i == "Earring1" or
			i == "Earring2" or
			i == "Ring1" or
			i == "Ring2" or
			i == "Necklace" or
			i == "CraftTool" or
			i == "ClassE" or
			i == "Pocket")then
			centerEquipItem19[i]:SetText("");
		else
			centerEquipItem19[i]:SetText(T[ "PluginEquipement4" ] .. " : " .. comma_value(tostring(PlayerEquipement[namePlayerToshow][i].armor)));
		end
	end

	centerEquipItem19[i]:SetForeColor( Turbine.UI.Color(1, 0.9, 0.5) );
	centerEquipItem19[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	centerEquipItem19[i]:SetZOrder(22);

	centerEquipItem4[i] = Turbine.UI.Label();
	centerEquipItem4[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem4[i]:SetPosition( 5, 250 );
	centerEquipItem4[i]:SetSize( 180, 32  );
	centerEquipItem4[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	--centerEquipItem4[i]:SetText("Quality : " .. PlayerEquipement[namePlayerToshow][i].QA);
	if(PlayerEquipement[namePlayerToshow][i].QA == 0)then
		centerEquipItem4[i]:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 )); -- grey
		centerEquipItem3[i]:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 )); -- grey
		centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality6" ]);
	elseif(PlayerEquipement[namePlayerToshow][i].QA == 1)then
		centerEquipItem4[i]:SetForeColor(Turbine.UI.Color.Gold); 
		centerEquipItem3[i]:SetForeColor(Turbine.UI.Color.Gold); 
		centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality3" ]);
	elseif(PlayerEquipement[namePlayerToshow][i].QA == 2)then
		if(PlayerEquipement[namePlayerToshow][i].U == 0)then
			centerEquipItem4[i]:SetForeColor(Turbine.UI.Color.Gold); 
			centerEquipItem3[i]:SetForeColor(Turbine.UI.Color.Gold); 
			centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality3" ]);
		else
			centerEquipItem4[i]:SetForeColor(Turbine.UI.Color( 1, 0, 1 )); -- purple
			centerEquipItem3[i]:SetForeColor(Turbine.UI.Color( 1, 0, 1 )); -- purple
			centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality2" ]);
		end
	elseif(PlayerEquipement[namePlayerToshow][i].QA == 3)then
		centerEquipItem4[i]:SetForeColor(Turbine.UI.Color( 0, 0.66, 0.75)); -- blue
		centerEquipItem3[i]:SetForeColor(Turbine.UI.Color( 0, 0.66, 0.75)); -- blue
		centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality4" ]);
	elseif(PlayerEquipement[namePlayerToshow][i].QA == 4)then
		centerEquipItem4[i]:SetForeColor(Turbine.UI.Color( 0.33, 0.66, 0.33 )); -- green
		centerEquipItem3[i]:SetForeColor(Turbine.UI.Color( 0.33, 0.66, 0.33 )); -- green
		centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality5" ]);
	elseif(PlayerEquipement[namePlayerToshow][i].QA == 5)then
		centerEquipItem4[i]:SetForeColor(Turbine.UI.Color( 0.5, 0.5, 0.5 )); -- grey
		centerEquipItem3[i]:SetForeColor(Turbine.UI.Color( 0.5, 0.5, 0.5 )); -- grey
		centerEquipItem4[i]:SetText(T[ "PluginQuality" ] .. " : " .. T[ "PluginQuality1" ]);
	end
	centerEquipItem4[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--centerEquipItem4[i]:SetForeColor( Turbine.UI.Color.Lime );
	centerEquipItem4[i]:SetZOrder(21);

	local wareS = PlayerEquipement[namePlayerToshow][i].WS;
	local wareSPoints = 0;

	if wareS == 0 then
		wareSPoints = -1; -- undefined
	elseif wareS == 3 then
		wareSPoints = 0; -- Broken / cassé
	elseif wareS == 1 then
		wareSPoints = 20; -- Damaged / endommagé
	elseif wareS == 4 then
		wareSPoints = 99; -- Worn / usé
	elseif wareS == 2 then
		wareSPoints = 100;
	end -- Pristine / parfait

	centerEquipItem5[i] = Turbine.UI.Label();
	centerEquipItem5[i]:SetParent(ButtonEquipItem[i]);
	centerEquipItem5[i]:SetPosition( 5, 270 );
	centerEquipItem5[i]:SetSize( 180, 32  );
	centerEquipItem5[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
	--centerEquipItem5[i]:SetText("Durability : " .. PlayerEquipement[namePlayerToshow][i].DU);
	centerEquipItem5[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );

	if(wareSPoints == 0)then 
		centerEquipItem5[i]:SetForeColor(Turbine.UI.Color.Red);
		centerEquipItem5[i]:SetText(T[ "PluginDurability" ] .. " : " .. tostring(wareSPoints) .. "%");
	elseif(wareSPoints == 20)then
		centerEquipItem5[i]:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 ));
		centerEquipItem5[i]:SetText(T[ "PluginDurability" ] .. " : " .. tostring(wareSPoints) .. "%");
	elseif(wareSPoints == 99)then 
		centerEquipItem5[i]:SetForeColor(Turbine.UI.Color.Gold);
		centerEquipItem5[i]:SetText(T[ "PluginDurability" ] .. " : " .. tostring(wareSPoints) .. "%");
	elseif(wareSPoints == 100)then 
		centerEquipItem5[i]:SetForeColor(Turbine.UI.Color.White);
		centerEquipItem5[i]:SetText(T[ "PluginDurability" ] .. " : " .. tostring(wareSPoints) .. "%");
	elseif(wareSPoints == -1)then 
		centerEquipItem5[i]:SetForeColor(Turbine.UI.Color( 0.4, 0.4, 0.4)); -- light grey
		centerEquipItem5[i]:SetText(PluginNoDurability);
	end
	--centerEquipItem4[i]:SetForeColor( Turbine.UI.Color.Lime );
	centerEquipItem5[i]:SetZOrder(21);


	buttonToDisplay.MouseEnter = function()
		ButtonEquipItem[i]:SetVisible(true);
	end

	buttonToDisplay.MouseLeave = function()
		ButtonEquipItem[i]:SetVisible(false);
	end
	--- end label description
end
------------------------------------------------------------------------------------------
-- little title with line displayer --
------------------------------------------------------------------------------------------
function TitleDisplayer(windowToDisplay, posx, posy, textToDisplay, textColor, LineColor)
	windowToDisplay.Message=Turbine.UI.Label(); 
	windowToDisplay.Message:SetParent(windowToDisplay); 
	windowToDisplay.Message:SetSize(300, 30); 
	windowToDisplay.Message:SetPosition(posx, posy - 15); 
	windowToDisplay.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	windowToDisplay.Message:SetText( textToDisplay ); 
	windowToDisplay.Message:SetForeColor(textColor);

	windowToDisplay.Message=Turbine.UI.Label(); 
	windowToDisplay.Message:SetParent(windowToDisplay); 
	windowToDisplay.Message:SetSize(300, 30); 
	windowToDisplay.Message:SetPosition(posx, posy - 10); 
	windowToDisplay.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message:SetText("___________________________________________________________________________________"); 
	windowToDisplay.Message:SetForeColor(LineColor);
end
------------------------------------------------------------------------------------------
-- function to display info about the selected player --
------------------------------------------------------------------------------------------
function DefineLabelInfo(i, posx, posy, buttonToDisplay)
	ButtonPlusInfosNotBar[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusInfosNotBar[i]:SetParent( AltHolicWindow );
	ButtonPlusInfosNotBar[i]:SetPosition(posx , posy);
	ButtonPlusInfosNotBar[i]:SetSize( 380, 360 );
	ButtonPlusInfosNotBar[i]:SetVisible(false);
	ButtonPlusInfosNotBar[i]:SetZOrder(20);
	--ButtonPlusInfosNotBar[i]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	textBoxLinesPopUp[i] = Turbine.UI.Lotro.TextBox();
	textBoxLinesPopUp[i]:SetParent( ButtonPlusInfosNotBar[i] );
	textBoxLinesPopUp[i]:SetSize(380, 360); 
	if(PlayerInfos[i] == nil or PlayerInfos[i].info == "")then
		textBoxLinesPopUp[i]:SetText( "" );
	else
		textBoxLinesPopUp[i]:SetText( PlayerInfos[i].info );
	end
	textBoxLinesPopUp[i]:SetPosition(0, 0);
	textBoxLinesPopUp[i]:SetVisible(true);
	textBoxLinesPopUp[i]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	textBoxLinesPopUp[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
	textBoxLinesPopUp[i]:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

	if(PlayerDatas[i].align == 1)then
		buttonToDisplay.MouseEnter = function()
			if(PlayerInfos[i] ~= nil and PlayerInfos[i].info ~= "")then
				ButtonPlusInfosNotBar[i]:SetVisible(true);
			end
		end

		buttonToDisplay.MouseLeave = function()
			ButtonPlusInfosNotBar[i]:SetVisible(false);
		end
	end

	buttonToDisplay.MouseClick = function()
		if InfoWindow ~= nil and InfoWindow:IsVisible() then
			InfoWindow:SetVisible(false);
			settings["isInfoWindowVisible"]["value"] = false;
		else
			GenerateInfosWindow(i);
			settings["isInfoWindowVisible"]["value"] = true;
			InfoWindow:SetVisible(true);
		end
	end
end
------------------------------------------------------------------------------------------
--- button help ---
------------------------------------------------------------------------------------------
local function CreateHelpButton(window, buttonX, buttonY, tooltipX, tooltipY, helpTopic)
    local helpButton = Turbine.UI.Extensions.SimpleWindow();
    helpButton:SetParent(window);
    helpButton:SetPosition(buttonX, buttonY);
    helpButton:SetSize(20, 20);
    helpButton:SetVisible(true);
    helpButton:SetMouseVisible(true);

    local helpIcon = Turbine.UI.Label();
    helpIcon:SetParent(helpButton);
    helpIcon:SetPosition(0, 0);
    helpIcon:SetSize(20, 20);
    helpIcon:SetBackground(ResourcePath .. "Help.tga");
    helpIcon:SetZOrder(-1);
    helpIcon:SetMouseVisible(false);

    local tooltip = Turbine.UI.Extensions.SimpleWindow();
    tooltip:SetParent(window);
    tooltip:SetPosition(tooltipX, tooltipY);
    tooltip:SetSize(180, 30);
    tooltip:SetZOrder(10000);
    tooltip:SetVisible(false);
    tooltip:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

    local tooltipLabel = Turbine.UI.Label();
    tooltipLabel:SetParent(tooltip);
    tooltipLabel:SetPosition(2, 2);
    tooltipLabel:SetSize(176, 26);
    tooltipLabel:SetText(T["PluginLabelHelp"]);
    tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    tooltipLabel:SetBackColor(Turbine.UI.Color(.9, .1, .4, .9));
    tooltipLabel:SetZOrder(-1);

    helpButton.MouseEnter = function()
        tooltip:SetVisible(true);
    end

    helpButton.MouseLeave = function()
        tooltip:SetVisible(false);
    end

    helpButton.MouseClick = function()
        GenerateHelpWindow(helpTopic);
        HelpWindow:SetVisible(true);
    end

    return helpButton;
end

function DisplayHelpButton(window, windowWidth, helpTopic)
    return CreateHelpButton(window, windowWidth - 40, 55, windowWidth - 20, 25, helpTopic);
end

function DisplayHelpButtonV2(window, windowWidth, windowHeight, helpTopic)
    return CreateHelpButton(window, windowWidth - 40, windowHeight, windowWidth - 20, windowHeight - 25, helpTopic);
end
