------------------------------------------------------------------------------------------
-- FCT_Display file
-- Written by Homeopatix
-- 19 march 2022
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Display functions
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- display the birthday window
------------------------------------------------------------------------------------------
function DisplayBirthday(cDay, cMonth, cYear)
	
	buttonDefineHouseLocationPersonalFaux = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineHouseLocationPersonalFaux:SetParent( AltHolicWindow );
	buttonDefineHouseLocationPersonalFaux:SetPosition(305, 40);
	buttonDefineHouseLocationPersonalFaux:SetSize( 32, 32 );
	buttonDefineHouseLocationPersonalFaux:SetVisible(true);
	buttonDefineHouseLocationPersonalFaux:SetZOrder(2000);
	buttonDefineHouseLocationPersonalFaux:SetBackground( 0x410DBA89 ); -- round de fleurs 0x411F2959 -- heart 0x410DBA89


	fond = {0x410096C9,
			0x411023FF,
			0x41108565,
			0x4110DC08,
			0x41134C68,
			0x411C5268,
			0x41008203,
			0x410096A8,
			0x410096CA,
			0x4101DBD4};

	ButtonPlusVoc = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusVoc:SetParent( AltHolicWindow );
	ButtonPlusVoc:SetSize( 1024, 512 );
	ButtonPlusVoc:SetPosition((Turbine.UI.Display:GetWidth()-ButtonPlusVoc:GetWidth())/2,(Turbine.UI.Display:GetHeight()-ButtonPlusVoc:GetHeight())/2);
	ButtonPlusVoc:SetVisible(false);
	ButtonPlusVoc:SetZOrder(100);
	ButtonPlusVoc:SetBackground(fond[Random(1, 10)]);

	ButtonPlusVocFond = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusVocFond:SetParent( AltHolicWindow );
	ButtonPlusVocFond:SetSize( 1030, 518 );
	ButtonPlusVocFond:SetPosition(((Turbine.UI.Display:GetWidth()-ButtonPlusVoc:GetWidth())/2) - 3,((Turbine.UI.Display:GetHeight()-ButtonPlusVoc:GetHeight())/2) - 3);
	ButtonPlusVocFond:SetVisible(false);
	ButtonPlusVocFond:SetZOrder(99);
	ButtonPlusVocFond:SetBackColor(Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ));



	centerLabelBVoc = Turbine.UI.Label();
	centerLabelBVoc:SetParent(ButtonPlusVoc);
	centerLabelBVoc:SetPosition( ButtonPlusVoc:GetWidth()/2 - 200, 50 );
	centerLabelBVoc:SetSize( 390, 30  );
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.TrajanProBold22);
		centerLabelBVoc:SetText( "Alles Gute zum Geburtstag" );
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
		centerLabelBVoc:SetText( "Bon anniversaire" );
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
		centerLabelBVoc:SetText( "Happy Birthday" );
	end
	centerLabelBVoc:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBVoc:SetZOrder(102);
	centerLabelBVoc:SetForeColor(Turbine.UI.Color.Gold);
	centerLabelBVoc:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	centerLabelBVoc:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	centerLabelBVoc = Turbine.UI.Label();
	centerLabelBVoc:SetParent(ButtonPlusVoc);
	centerLabelBVoc:SetPosition( ButtonPlusVoc:GetWidth()/2 - 202, 48 );
	centerLabelBVoc:SetSize( 394, 34  );
	centerLabelBVoc:SetZOrder(101);
	centerLabelBVoc:SetBackColor(Turbine.UI.Color(.1, .3, .3, .3));

	kdo = {0x410E04BB,
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
	flags = {0x410040AB,
			0x4110E90B,
			0x4110E90C,
			0x4110E90D,
			0x4110E90E,
			0x4110E90F,
			0x4110E910};

	local posx = 1;
	local posy = 0;
	for i=1, 32 do
		centerLabelBVoc = Turbine.UI.Label();
		centerLabelBVoc:SetParent(ButtonPlusVoc);
		centerLabelBVoc:SetPosition( posx, posy );
		centerLabelBVoc:SetSize( 32, 32  );
		centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
		centerLabelBVoc:SetText("");
		centerLabelBVoc:SetZOrder(101);
		centerLabelBVoc:SetBackground(flags[Random(1, 7)]);
		centerLabelBVoc:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		posx = posx + 32;
	end

	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		MonthName = {"", "", "", "", "Mai", "", "", "", "September", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		MonthName = {"", "", "", "", "Mai", "", "", "", "Septembre", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		MonthName = {"", "", "", "", "May", "", "", "", "September", "", "", ""};
	end

	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		DayName = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"Ist der Geburtstag von Bilbo und Frodo Beutlin\n\nDanke an J. R. R. Tolkien", 
			"\nEs ist der Geburtstag Ihres Lieblingsentwicklers. Senden Sie ihm eine kleine mail, die ihn glücklich machen wird\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		DayName = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"C'est l'anniversaire de Bilbo et de Frodon Sacquet\n\nMerci à J. R. R. Tolkien", 
			"\nC'est l'anniversaire de votre développeur préféré, envoyez lui un petit courrier cela lui fera plaisir\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		DayName = {"", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", 
			"Is the birthday of Bilbo and Frodo Baggins\n\nThanks to J. R. R. Tolkien", 
			"\nIt's the birthday of your favorite developer, send him a little mail it will make him happy\n\n\n\nHomeopatix", 
			"", "", "", "", "", "", ""};
	end

	centerLabelBVoc = Turbine.UI.Label();
	centerLabelBVoc:SetParent(ButtonPlusVoc);
	centerLabelBVoc:SetPosition( ButtonPlusVoc:GetWidth()/2 - 150, 150 );
	centerLabelBVoc:SetSize( 300, 30  );
	centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
	centerLabelBVoc:SetText( cDay .. "  " .. MonthName[cMonth] .. "  " .. cYear );
	centerLabelBVoc:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBVoc:SetZOrder(102);
	centerLabelBVoc:SetForeColor(Turbine.UI.Color.Gold);
	centerLabelBVoc:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	centerLabelBVoc:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	centerLabelBVoc = Turbine.UI.Label();
	centerLabelBVoc:SetParent(ButtonPlusVoc);
	centerLabelBVoc:SetPosition( ButtonPlusVoc:GetWidth()/2 - 150, 180 );
	centerLabelBVoc:SetSize( 300, 200  );
	centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	centerLabelBVoc:SetText( DayName[cDay] );
	centerLabelBVoc:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBVoc:SetZOrder(102);
	centerLabelBVoc:SetForeColor(Turbine.UI.Color.White);
	centerLabelBVoc:SetBackColor(Turbine.UI.Color(.9, .4, .4, .4));
	centerLabelBVoc:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	centerLabelBVoc = Turbine.UI.Label();
	centerLabelBVoc:SetParent(ButtonPlusVoc);
	centerLabelBVoc:SetPosition( ButtonPlusVoc:GetWidth()/2 - 152, 148 );
	centerLabelBVoc:SetSize( 304, 234  );
	centerLabelBVoc:SetZOrder(101);
	centerLabelBVoc:SetBackColor(Turbine.UI.Color(1, .3, .3, .3));

	posx = 1;
	posy = 418;

	for i=1, 96 do
		centerLabelBVoc = Turbine.UI.Label();
		centerLabelBVoc:SetParent(ButtonPlusVoc);
		centerLabelBVoc:SetPosition( posx, posy );
		centerLabelBVoc:SetSize( 32, 32  );
		centerLabelBVoc:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
		centerLabelBVoc:SetText("");
		centerLabelBVoc:SetZOrder(101);
		centerLabelBVoc:SetBackground(kdo[Random(1, 13)]);
		centerLabelBVoc:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		posx = posx + 32;
		if(i%32 == 0)then
			posx = 1;
			posy = posy + 32;
		end
	end

	buttonDefineHouseLocationPersonalFaux.MouseEnter = function()
		ButtonPlusVoc:SetVisible(true);
		ButtonPlusVocFond:SetVisible(true);
		settings["isFestivalWindowVisible"]["value"] = true;
	end

	buttonDefineHouseLocationPersonalFaux.MouseLeave = function()
		ButtonPlusVoc:SetVisible(false);
		ButtonPlusVocFond:SetVisible(false);
		settings["isFestivalWindowVisible"]["value"] = false;
	end
end
------------------------------------------------------------------------------------------
--function to display the backpack window --
------------------------------------------------------------------------------------------
function DisplayBag(i, posx, posy, vocationToShow)
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then
		BagsIcons = {0x410FC45F, --  ecplorateur 
						0x410F467E, --  joaillier
						0x410F4682, --  franc-tenancier
						0x410F4684, --  historien 
						0x410F4688, --  armurier
						0x410F4686, --  bucheron 
						0x410F4680}; --  feronnier

			if(settings["displayClassBags"]["value"] == true)then
				vocationToShow = Random(1, 6);
			else
				vocationToShow = 1;
			end
			
			buttonBag = Turbine.UI.Control();
			buttonBag:SetParent( viewport1.map );
			buttonBag:SetPosition(posx + 248, posy + 30);
			buttonBag:SetSize( 32, 32 );
			if(PlayerDatas[i].align == 1)then
				if(settings["displayClassBags"]["value"] == true)then
					if(vocationToShow == 0)then
						buttonBag:SetBackground(0x41105F73); -- no vocation bag
					else
						buttonBag:SetBackground(BagsIcons[vocationToShow]);
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
function DisplayVault(i, posx, posy, vocationToShow)
	if(settings["nameAccount"]["account1"]["nbrAlt"] ~= 0)then
		VaultIcons = {0x4110149D, --  ecplorateur 
						0x41101482, --  joaillier
						0x4110147B, --  franc-tenancier
						0x41101481, --  historien 
						0x4110148B, --  armurier
						0x4110149C, --  bucheron 
						0x41101480}; --  feronnier


			buttonVault = Turbine.UI.Control();
			buttonVault:SetParent( viewport1.map );
			buttonVault:SetPosition(posx + 220, posy + 30);
			buttonVault:SetSize( 32, 32 );
			if(PlayerDatas[i].align == 1)then
				--buttonVault:SetBackground(VaultIcons[vocationToShow]);
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
	buttonDefineCashTotal = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineCashTotal:SetParent( AltHolicWindow );
	buttonDefineCashTotal:SetPosition(posx, posy);
	buttonDefineCashTotal:SetSize( 32, 32 );
	buttonDefineCashTotal:SetVisible(true);
	buttonDefineCashTotal:SetZOrder(30);

	buttonDefineCashTotal.MouseEnter = function()
		CreateUIShowCash();
		UIShowCash:SetVisible(true);
	end

	buttonDefineCashTotal.MouseLeave = function()
		UIShowCash:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
--function to display the XP window --
------------------------------------------------------------------------------------------
function DisplayXPWindow(posx, posy)
	buttonDefineXPTotal = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineXPTotal:SetParent( AltHolicWindow );
	buttonDefineXPTotal:SetPosition(posx, posy);
	buttonDefineXPTotal:SetSize( 32, 32 );
	buttonDefineXPTotal:SetVisible(true);
	buttonDefineXPTotal:SetZOrder(30);
	buttonDefineXPTotal:SetMouseVisible(true);
	--buttonDefineXPTotal:SetBackColor(Turbine.UI.Color.Red);

	ButtonPlusXP = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusXP:SetParent( AltHolicWindow );
	ButtonPlusXP:SetPosition(posx + 40 , posy - 5);
	ButtonPlusXP:SetSize( 180, 30 );
	ButtonPlusXP:SetVisible(false);
	ButtonPlusXP:SetZOrder(20);
	ButtonPlusXP:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabXP = Turbine.UI.Label();
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
	buttonDefineEpique = Turbine.UI.Extensions.SimpleWindow();
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

			buttonWallet = Turbine.UI.Control();
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

	buttonDefineHouseLocationPersonalFaux2 = Turbine.UI.Control();
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
function DisplayCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = 0;
	
	if(namePlayerToshow == PlayerName)then
		valToAdd = 20;
	end

	if(totalCash == 0 or totalCash == nil)then
		totalCash = PlayerAttr:GetMoney();
	end
	
	if(namePlayerToshow == "" or namePlayerToshow == nil)then
		namePlayerToshow = PlayerName;
	end

	gold = math.floor( totalCash / 100000);
	silver = math.floor( totalCash / 100) - gold * 1000;
	copper = totalCash - gold * 100000 - silver * 100;

	if(settings["displaySpentCash"]["value"] == true)then
		valToAdd = valToAdd + 45;
	else
		valToAdd = valToAdd + (-10);
	end

	if(settings["displayTotalCash"]["value"] == false)then
		valToAdd = valToAdd - 20;
	end


	if(windowToDisplay == UIShowWallet)then
		if(PlayerDatas[namePlayerToshow].bagCash > 0 and PlayerDatas[namePlayerToshow].vaultCash > 0)then
			valToAdd = 570;
		elseif(PlayerDatas[namePlayerToshow].bagCash > 0 and PlayerDatas[namePlayerToshow].vaultCash <= 0)then
			valToAdd = 490;
		elseif(PlayerDatas[namePlayerToshow].bagCash <= 0 and PlayerDatas[namePlayerToshow].vaultCash > 0)then
			valToAdd = 490;
		elseif(PlayerDatas[namePlayerToshow].bagCash <= 0 and PlayerDatas[namePlayerToshow].vaultCash <= 0)then
			valToAdd = 490;
		end
	end


	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 - 70, windowToDisplay:GetHeight() - (64 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7b);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	if(windowToDisplay == UIShowWallet)then
		if(PlayerDatas[namePlayerToshow].bagCash > 0 or PlayerDatas[namePlayerToshow].vaultCash > 0)then
			windowToDisplay.Message4=Turbine.UI.Label(); 
			windowToDisplay.Message4:SetParent(windowToDisplay); 
			windowToDisplay.Message4:SetSize(200, 30); 
			windowToDisplay.Message4:SetPosition(windowToDisplay:GetWidth()/2 - 100, windowToDisplay:GetHeight() - (88 + valToAdd)); 
			windowToDisplay.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			windowToDisplay.Message4:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			windowToDisplay.Message4:SetText( T[ "PluginSearch7" ] ); 
			windowToDisplay.Message4:SetForeColor(Turbine.UI.Color.Green);

			windowToDisplay.Message=Turbine.UI.Label(); 
			windowToDisplay.Message:SetParent(windowToDisplay); 
			windowToDisplay.Message:SetSize(250, 30); 
			windowToDisplay.Message:SetPosition(windowToDisplay:GetWidth()/2 - 125, windowToDisplay:GetHeight() - (84 + valToAdd)); 
			windowToDisplay.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			windowToDisplay.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			windowToDisplay.Message:SetText("___________________________________________________________________________________"); 
			windowToDisplay.Message:SetForeColor(Turbine.UI.Color.Green);
		end
	end

	windowToDisplay.Message1=Turbine.UI.Label(); 
	windowToDisplay.Message1:SetParent(windowToDisplay); 
	windowToDisplay.Message1:SetSize(50, 30); 
	windowToDisplay.Message1:SetPosition(windowToDisplay:GetWidth()/2 - 119, windowToDisplay:GetHeight() - (70 + valToAdd)); 
	windowToDisplay.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message1:SetText(string.format( "%.0f", gold)); 
	windowToDisplay.Message1:SetForeColor(Turbine.UI.Color.Gold);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 7, windowToDisplay:GetHeight() - (64 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7c);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message2=Turbine.UI.Label();  
	windowToDisplay.Message2:SetParent(windowToDisplay); 
	windowToDisplay.Message2:SetSize(50, 30); 
	windowToDisplay.Message2:SetPosition(windowToDisplay:GetWidth()/2 - 43, windowToDisplay:GetHeight() - (70 + valToAdd)); 
	windowToDisplay.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message2:SetText(string.format( "%.0f", silver));
	windowToDisplay.Message2:SetForeColor(Turbine.UI.Color.Silver);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 84, windowToDisplay:GetHeight() - (64 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7d);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message3=Turbine.UI.Label(); 
	windowToDisplay.Message3:SetParent(windowToDisplay); 
	windowToDisplay.Message3:SetSize(50, 30); 
	windowToDisplay.Message3:SetPosition(windowToDisplay:GetWidth()/2 + 34, windowToDisplay:GetHeight() - (70 + valToAdd)); 
	windowToDisplay.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message3:SetText(string.format( "%.0f", copper));
	windowToDisplay.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
	--- end of cash displayer
end
------------------------------------------------------------------------------------------
--function to display the cash in bag --
------------------------------------------------------------------------------------------
function DisplayBagCash(totalCash, windowToDisplay, namePlayerToshow)
	gold = math.floor( totalCash / 100000);
	silver = math.floor( totalCash / 100) - gold * 1000;
	copper = totalCash - gold * 100000 - silver * 100;
	local valToAdd = 0;

	if(settings["displaySpentCash"]["value"] == true)then
		valToAdd = 50;
	else
		valToAdd = (-10);
	end

	if(windowToDisplay == UIShowWallet)then
		valToAdd = 502;
	end

	-- gold = 0x41004641
	-- silver = 0x41007E7E
	-- copper = 0x41007E80

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 - 70, windowToDisplay:GetHeight() - (90 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7b);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message4=Turbine.UI.Label(); 
	windowToDisplay.Message4:SetParent(windowToDisplay); 
	windowToDisplay.Message4:SetSize(200, 30); 
	windowToDisplay.Message4:SetPosition(windowToDisplay:GetWidth()/2 - 100, windowToDisplay:GetHeight() - (114 + valToAdd)); 
	windowToDisplay.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message4:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
	windowToDisplay.Message4:SetText( T[ "PluginSearch3" ] ); 
	windowToDisplay.Message4:SetForeColor(Turbine.UI.Color.Red);

	windowToDisplay.Message=Turbine.UI.Label(); 
	windowToDisplay.Message:SetParent(windowToDisplay); 
	windowToDisplay.Message:SetSize(250, 30); 
	windowToDisplay.Message:SetPosition(windowToDisplay:GetWidth()/2 - 125, windowToDisplay:GetHeight() - (110 + valToAdd)); 
	windowToDisplay.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message:SetText("___________________________________________________________________________________"); 
	windowToDisplay.Message:SetForeColor(Turbine.UI.Color.Red);

	windowToDisplay.Message1=Turbine.UI.Label(); 
	windowToDisplay.Message1:SetParent(windowToDisplay); 
	windowToDisplay.Message1:SetSize(50, 30); 
	windowToDisplay.Message1:SetPosition(windowToDisplay:GetWidth()/2 - 119, windowToDisplay:GetHeight() - (96 + valToAdd)); 
	windowToDisplay.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message1:SetText(string.format( "%.0f", gold)); 
	windowToDisplay.Message1:SetForeColor(Turbine.UI.Color.Gold);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 7, windowToDisplay:GetHeight() - (90 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7c);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message2=Turbine.UI.Label();  
	windowToDisplay.Message2:SetParent(windowToDisplay); 
	windowToDisplay.Message2:SetSize(50, 30); 
	windowToDisplay.Message2:SetPosition(windowToDisplay:GetWidth()/2 - 43, windowToDisplay:GetHeight() - (96 + valToAdd)); 
	windowToDisplay.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message2:SetText(string.format( "%.0f", silver));
	windowToDisplay.Message2:SetForeColor(Turbine.UI.Color.Silver);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 84, windowToDisplay:GetHeight() - (90 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7d);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message3=Turbine.UI.Label(); 
	windowToDisplay.Message3:SetParent(windowToDisplay); 
	windowToDisplay.Message3:SetSize(50, 30); 
	windowToDisplay.Message3:SetPosition(windowToDisplay:GetWidth()/2 + 34, windowToDisplay:GetHeight() - (96 + valToAdd)); 
	windowToDisplay.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message3:SetText(string.format( "%.0f", copper));
	windowToDisplay.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
	--- end of cash displayer
end
------------------------------------------------------------------------------------------
--function to display the cash in vault --
------------------------------------------------------------------------------------------
function DisplayVaultCash(totalCash, windowToDisplay, namePlayerToshow)
	gold = math.floor( totalCash / 100000);
	silver = math.floor( totalCash / 100) - gold * 1000;
	copper = totalCash - gold * 100000 - silver * 100;
	local valToAdd = 0;

	if(settings["displaySpentCash"]["value"] == true)then
		valToAdd = 50;
	else
		valToAdd = (-10);
	end

	if(windowToDisplay == UIShowWallet)then
		valToAdd = 440;
	end

	if(PlayerDatas[namePlayerToshow].bagCash <= 0)then
		valToAdd = 480;
	end

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 - 70, windowToDisplay:GetHeight() - (110 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7b);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message4=Turbine.UI.Label(); 
	windowToDisplay.Message4:SetParent(windowToDisplay); 
	windowToDisplay.Message4:SetSize(200, 30); 
	windowToDisplay.Message4:SetPosition(windowToDisplay:GetWidth()/2 - 100, windowToDisplay:GetHeight() - (134 + valToAdd)); 
	windowToDisplay.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message4:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
	windowToDisplay.Message4:SetText( T[ "PluginSearch4" ] ); 
	windowToDisplay.Message4:SetForeColor(Turbine.UI.Color.Blue);

	windowToDisplay.Message=Turbine.UI.Label(); 
	windowToDisplay.Message:SetParent(windowToDisplay); 
	windowToDisplay.Message:SetSize(250, 30); 
	windowToDisplay.Message:SetPosition(windowToDisplay:GetWidth()/2 - 125, windowToDisplay:GetHeight() - (130 + valToAdd)); 
	windowToDisplay.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	windowToDisplay.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message:SetText("___________________________________________________________________________________"); 
	windowToDisplay.Message:SetForeColor(Turbine.UI.Color.Blue);

	windowToDisplay.Message1=Turbine.UI.Label(); 
	windowToDisplay.Message1:SetParent(windowToDisplay); 
	windowToDisplay.Message1:SetSize(50, 30); 
	windowToDisplay.Message1:SetPosition(windowToDisplay:GetWidth()/2 - 119, windowToDisplay:GetHeight() - (116 + valToAdd)); 
	windowToDisplay.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message1:SetText(string.format( "%.0f", gold)); 
	windowToDisplay.Message1:SetForeColor(Turbine.UI.Color.Gold);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 7, windowToDisplay:GetHeight() - (110 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7c);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message2=Turbine.UI.Label();  
	windowToDisplay.Message2:SetParent(windowToDisplay); 
	windowToDisplay.Message2:SetSize(50, 30); 
	windowToDisplay.Message2:SetPosition(windowToDisplay:GetWidth()/2 - 43, windowToDisplay:GetHeight() - (116 + valToAdd)); 
	windowToDisplay.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message2:SetText(string.format( "%.0f", silver));
	windowToDisplay.Message2:SetForeColor(Turbine.UI.Color.Silver);

	LabelGold = Turbine.UI.Label(); 
	LabelGold:SetParent( windowToDisplay );
	LabelGold:SetPosition(windowToDisplay:GetWidth()/2 + 84, windowToDisplay:GetHeight() - (110 + valToAdd));
	LabelGold:SetSize( 27, 21 );
	LabelGold:SetVisible(true);
	LabelGold:SetBackground(0x41007e7d);
	LabelGold:SetZOrder(-1);
	LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

	windowToDisplay.Message3=Turbine.UI.Label(); 
	windowToDisplay.Message3:SetParent(windowToDisplay); 
	windowToDisplay.Message3:SetSize(50, 30); 
	windowToDisplay.Message3:SetPosition(windowToDisplay:GetWidth()/2 + 34, windowToDisplay:GetHeight() - (116 + valToAdd)); 
	windowToDisplay.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
	windowToDisplay.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	windowToDisplay.Message3:SetText(string.format( "%.0f", copper));
	windowToDisplay.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
	--- end of cash displayer
end
------------------------------------------------------------------------------------------
-- function to display destiny points --
------------------------------------------------------------------------------------------
function DisplayDestinyPoints(windowToDisplay)
	if(windowToDisplay == UIShowWallet)then
		valToAdd = 450;
	end

	LabelDestinyPoints = Turbine.UI.Label(); 
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
	if(windowToDisplay == UIShowWallet)then
		valToAdd = 450;
	end

	LabelLotroCoins = Turbine.UI.Label(); 
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
	ButtonPlusCash = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusCash:SetParent( windowToDisplay );
	ButtonPlusCash:SetPosition(windowToDisplay:GetWidth()/2 + 70, windowToDisplay:GetHeight() - (90 + valToAdd));
	ButtonPlusCash:SetSize( 180, 30 );
	ButtonPlusCash:SetVisible(false);
	ButtonPlusCash:SetZOrder(20);
	ButtonPlusCash:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelCash = Turbine.UI.Label();
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
	currentCash = settings["sessionCash"]["cashSession"];

	local valToAdd = 0;

	if(settings["displaySpentCash"]["value"] == true)then
		valToAdd = 10;

		AltHolicWindow.Message=Turbine.UI.Label(); 
		AltHolicWindow.Message:SetParent(AltHolicWindow); 
		AltHolicWindow.Message:SetSize(300, 30); 
		AltHolicWindow.Message:SetPosition(AltHolicWindow:GetWidth()/2 - 150, AltHolicWindow:GetHeight() - (85 + valToAdd)); 
		AltHolicWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		AltHolicWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		AltHolicWindow.Message:SetText(T[ "PluginCashWindow3" ]); 

		AltHolicWindow.Message=Turbine.UI.Label(); 
		AltHolicWindow.Message:SetParent(AltHolicWindow); 
		AltHolicWindow.Message:SetSize(300, 30); 
		AltHolicWindow.Message:SetPosition(AltHolicWindow:GetWidth()/2 - 150, AltHolicWindow:GetHeight() - (78 + valToAdd)); 
		AltHolicWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		AltHolicWindow.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message:SetText("___________________________________________________________________________________"); 
		AltHolicWindow.Message:SetForeColor(Turbine.UI.Color.Blue);
	end


	if(currentCash < 0)then
		currentCash = 0;
	end

		gold = math.floor( currentCash / 100000);
		silver = math.floor( currentCash / 100) - gold * 1000;
		copper = currentCash - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 - 70, AltHolicWindow:GetHeight() - (55 + valToAdd));
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message1=Turbine.UI.Label(); 
		AltHolicWindow.Message1:SetParent(AltHolicWindow); 
		AltHolicWindow.Message1:SetSize(50, 30); 
		AltHolicWindow.Message1:SetPosition(AltHolicWindow:GetWidth()/2 - 119, AltHolicWindow:GetHeight() - (61 + valToAdd)); 
		AltHolicWindow.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message1:SetText(string.format( "%.0f", gold)); 
		AltHolicWindow.Message1:SetForeColor(Turbine.UI.Color.Gold);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 + 7, AltHolicWindow:GetHeight() - (55 + valToAdd));
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message2=Turbine.UI.Label();  
		AltHolicWindow.Message2:SetParent(AltHolicWindow); 
		AltHolicWindow.Message2:SetSize(50, 30); 
		AltHolicWindow.Message2:SetPosition(AltHolicWindow:GetWidth()/2 - 43, AltHolicWindow:GetHeight() - (61 + valToAdd)); 
		AltHolicWindow.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message2:SetText(string.format( "%.0f", silver));
		AltHolicWindow.Message2:SetForeColor(Turbine.UI.Color.Silver);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 + 84, AltHolicWindow:GetHeight() - (55 + valToAdd));
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message3=Turbine.UI.Label(); 
		AltHolicWindow.Message3:SetParent(AltHolicWindow); 
		AltHolicWindow.Message3:SetSize(50, 30); 
		AltHolicWindow.Message3:SetPosition(AltHolicWindow:GetWidth()/2 + 34, AltHolicWindow:GetHeight() - (61 + valToAdd)); 
		AltHolicWindow.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message3:SetText(string.format( "%.0f", copper));
		AltHolicWindow.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

		AltHolicWindow.Message4=Turbine.UI.Label(); 
		AltHolicWindow.Message4:SetParent(AltHolicWindow); 
		AltHolicWindow.Message4:SetSize(100, 30); 
		AltHolicWindow.Message4:SetPosition(AltHolicWindow:GetWidth()/2 - 195, AltHolicWindow:GetHeight() - (61 + valToAdd)); 
		AltHolicWindow.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message4:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		AltHolicWindow.Message4:SetText(T[ "PluginCashWindow4" ]);
		--- end of cash displayer
end
------------------------------------------------------------------------------------------
--function to display the session spent cash --
------------------------------------------------------------------------------------------
function DisplaySpentCash()
		spentCash = settings["sessionCash"]["cashSpent"];

		gold = math.floor( spentCash / 100000);
		silver = math.floor( spentCash / 100) - gold * 1000;
		copper = spentCash - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 - 70, AltHolicWindow:GetHeight() - 45);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message1=Turbine.UI.Label(); 
		AltHolicWindow.Message1:SetParent(AltHolicWindow); 
		AltHolicWindow.Message1:SetSize(50, 30); 
		AltHolicWindow.Message1:SetPosition(AltHolicWindow:GetWidth()/2 - 119, AltHolicWindow:GetHeight() - 51); 
		AltHolicWindow.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message1:SetText(string.format( "%.0f", gold)); 
		AltHolicWindow.Message1:SetForeColor(Turbine.UI.Color.Gold);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 + 7, AltHolicWindow:GetHeight() - 45);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message2=Turbine.UI.Label();  
		AltHolicWindow.Message2:SetParent(AltHolicWindow); 
		AltHolicWindow.Message2:SetSize(50, 30); 
		AltHolicWindow.Message2:SetPosition(AltHolicWindow:GetWidth()/2 - 43, AltHolicWindow:GetHeight() - 51); 
		AltHolicWindow.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message2:SetText(string.format( "%.0f", silver));
		AltHolicWindow.Message2:SetForeColor(Turbine.UI.Color.Silver);

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( AltHolicWindow );
		LabelGold:SetPosition(AltHolicWindow:GetWidth()/2 + 84, AltHolicWindow:GetHeight() - 45);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		AltHolicWindow.Message3=Turbine.UI.Label(); 
		AltHolicWindow.Message3:SetParent(AltHolicWindow); 
		AltHolicWindow.Message3:SetSize(50, 30); 
		AltHolicWindow.Message3:SetPosition(AltHolicWindow:GetWidth()/2 + 34, AltHolicWindow:GetHeight() - 51); 
		AltHolicWindow.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		AltHolicWindow.Message3:SetText(string.format( "%.0f", copper));
		AltHolicWindow.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

		AltHolicWindow.Message4=Turbine.UI.Label(); 
		AltHolicWindow.Message4:SetParent(AltHolicWindow); 
		AltHolicWindow.Message4:SetSize(100, 30); 
		AltHolicWindow.Message4:SetPosition(AltHolicWindow:GetWidth()/2 - 195, AltHolicWindow:GetHeight() - 51); 
		AltHolicWindow.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		AltHolicWindow.Message4:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		AltHolicWindow.Message4:SetText(T[ "PluginCashWindow5" ]);
		--- end of cash displayer
end
------------------------------------------------------------------------------------------
--function to display the cash for the cash window --
------------------------------------------------------------------------------------------
function DisplayCashForCashWindow(posx, posy, wichOneToDisplay, i)
		local changeColor = false;

		if(wichOneToDisplay < 0)then
			if(settings["sessionCash"]["cashSpent"] > (settings["sessionCash"]["cashSession"] - settings["sessionCash"]["cashSpent"]))then
				cashToDisplay = settings["sessionCash"]["cashSpent"] - settings["sessionCash"]["cashSession"];
				changeColor = true;
			end

			if(settings["sessionCash"]["cashSpent"] < settings["sessionCash"]["cashSession"])then
				cashToDisplay = settings["sessionCash"]["cashSession"] - settings["sessionCash"]["cashSpent"];
			end
		else
			cashToDisplay = wichOneToDisplay;
		end

		gold = math.floor( cashToDisplay / 100000);
		silver = math.floor( cashToDisplay / 100) - gold * 1000;
		copper = cashToDisplay - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx - 70, posy - 70);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message1=Turbine.UI.Label(); 
		UIShowCash.Message1:SetParent(UIShowCash); 
		UIShowCash.Message1:SetSize(30, 30); 
		UIShowCash.Message1:SetPosition(posx - 100, posy - 76); 
		UIShowCash.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message1:SetText(string.format( "%.0f", gold)); 
		--UIShowCash.Message1:SetBackColor(Turbine.UI.Color.Red); 
		if(changeColor == true)then
			UIShowCash.Message1:SetForeColor(Turbine.UI.Color.Red);
		else
			if(i == PlayerName)then
				UIShowCash.Message1:SetForeColor(Turbine.UI.Color.Lime);
		else
				UIShowCash.Message1:SetForeColor(Turbine.UI.Color.Gold);
			end
		end

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx + 7, posy - 70 );
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message2=Turbine.UI.Label();  
		UIShowCash.Message2:SetParent(UIShowCash); 
		UIShowCash.Message2:SetSize(30, 30); 
		UIShowCash.Message2:SetPosition(posx - 23, posy - 76); 
		UIShowCash.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message2:SetText(string.format( "%.0f", silver));
		--UIShowCash.Message2:SetBackColor(Turbine.UI.Color.Lime); 
		if(changeColor == true)then
			UIShowCash.Message2:SetForeColor(Turbine.UI.Color.Red);
		else
			if(i == PlayerName)then
				UIShowCash.Message2:SetForeColor(Turbine.UI.Color.Lime);
			else
				UIShowCash.Message2:SetForeColor(Turbine.UI.Color.Silver);
			end
		end

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx + 84, posy - 70);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message3=Turbine.UI.Label(); 
		UIShowCash.Message3:SetParent(UIShowCash); 
		UIShowCash.Message3:SetSize(30, 30); 
		UIShowCash.Message3:SetPosition(posx + 54, posy - 76); 
		UIShowCash.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message3:SetText(string.format( "%.0f", copper));
		--UIShowCash.Message3:SetBackColor(Turbine.UI.Color.Gold); 
		if(changeColor == true)then
			UIShowCash.Message3:SetForeColor(Turbine.UI.Color.Red);
		else
			if(i == PlayerName)then
				UIShowCash.Message3:SetForeColor(Turbine.UI.Color.Lime);
			else
				UIShowCash.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
			end
		end
		posy = posy + 20;
end
------------------------------------------------------------------------------------------
--function to display the cash for the cash window --
------------------------------------------------------------------------------------------
function DisplayDailyCashForCashWindow(posx, posy, wichOneToDisplay)
		local changeColor = false;

		if(wichOneToDisplay < 0)then
			if(settings["dailyCash"]["cashSpent"] > (settings["dailyCash"]["cashDaily"] - settings["dailyCash"]["cashSpent"]))then
				cashToDisplay = settings["dailyCash"]["cashSpent"] - settings["dailyCash"]["cashDaily"];
				changeColor = true;
			elseif(settings["dailyCash"]["cashSpent"] < settings["dailyCash"]["cashDaily"])then
				cashToDisplay = settings["dailyCash"]["cashDaily"] - settings["dailyCash"]["cashSpent"];
			end
		else
			cashToDisplay = wichOneToDisplay;
		end

		gold = math.floor( cashToDisplay / 100000);
		silver = math.floor( cashToDisplay / 100) - gold * 1000;
		copper = cashToDisplay - gold * 100000 - silver * 100;

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx - 70, posy - 70);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7b);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message1=Turbine.UI.Label(); 
		UIShowCash.Message1:SetParent(UIShowCash); 
		UIShowCash.Message1:SetSize(30, 30); 
		UIShowCash.Message1:SetPosition(posx - 100, posy - 76); 
		UIShowCash.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message1:SetText(string.format( "%.0f", gold)); 
		--UIShowCash.Message1:SetBackColor(Turbine.UI.Color.Red); 
		if(changeColor == true)then
			UIShowCash.Message1:SetForeColor(Turbine.UI.Color.Red);
		else
			UIShowCash.Message1:SetForeColor(Turbine.UI.Color.Gold);
		end

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx + 7, posy - 70 );
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7c);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message2=Turbine.UI.Label();  
		UIShowCash.Message2:SetParent(UIShowCash); 
		UIShowCash.Message2:SetSize(30, 30); 
		UIShowCash.Message2:SetPosition(posx - 23, posy - 76); 
		UIShowCash.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message2:SetText(string.format( "%.0f", silver));
		--UIShowCash.Message2:SetBackColor(Turbine.UI.Color.Lime); 
		if(changeColor == true)then
			UIShowCash.Message2:SetForeColor(Turbine.UI.Color.Red);
		else
			UIShowCash.Message2:SetForeColor(Turbine.UI.Color.Silver);
		end

		LabelGold = Turbine.UI.Label(); 
		LabelGold:SetParent( UIShowCash );
		LabelGold:SetPosition(posx + 84, posy - 70);
		LabelGold:SetSize( 27, 21 );
		LabelGold:SetVisible(true);
		LabelGold:SetBackground(0x41007e7d);
		LabelGold:SetZOrder(-1);
		LabelGold:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		UIShowCash.Message3=Turbine.UI.Label(); 
		UIShowCash.Message3:SetParent(UIShowCash); 
		UIShowCash.Message3:SetSize(30, 30); 
		UIShowCash.Message3:SetPosition(posx + 54, posy - 76); 
		UIShowCash.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
		UIShowCash.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
		UIShowCash.Message3:SetText(string.format( "%.0f", copper));
		--UIShowCash.Message3:SetBackColor(Turbine.UI.Color.Gold); 
		if(changeColor == true)then
			UIShowCash.Message3:SetForeColor(Turbine.UI.Color.Red);
		else
			UIShowCash.Message3:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));
		end
		posy = posy + 20;
end
------------------------------------------------------------------------------------------
--function to display the sex of the player in a small label and to show the reputation window --
------------------------------------------------------------------------------------------
function DisplayLabelSexe(i, posx, posy, buttonToDisplay)
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
	
	longueurName = string.len(i);
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
		if(settings["isServerWindowVisible"]["value"] == false)then
			GenerateServerNameWindow(i);
			settings["isServerWindowVisible"]["value"] = true;
			ServerNameWindow:SetVisible(true);
		else
			settings["isServerWindowVisible"]["value"] = false;
			ServerNameWindow:SetVisible(false);
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
	ButtonInfos = Turbine.UI.Extensions.SimpleWindow();
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
function DisplaySmallLabel(i, posx, posy, texte)
	recipeTrackerIsInstalled = false;
	if(i == nil)then
		i=1;
	end

	if(i == PlayerName)then
		GetDataForProfessions();
		SavePlayerProfessions();
	end

	buttonDefineHouseLocationPersonalFaux = Turbine.UI.Control();
	buttonDefineHouseLocationPersonalFaux:SetParent( viewport1.map );
	buttonDefineHouseLocationPersonalFaux:SetPosition(posx, posy);
	buttonDefineHouseLocationPersonalFaux:SetSize( 45, 45 );
	buttonDefineHouseLocationPersonalFaux:SetVisible(true);
	buttonDefineHouseLocationPersonalFaux:SetZOrder(19);

	ButtonPlusVoc[i] = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusVoc[i]:SetParent( AltHolicWindow );
	ButtonPlusVoc[i]:SetSize( 380, 420 );

	-- change the position of the popup windows 
	-- if the addon is on the rights side of the screen
	if((Turbine.UI.Display:GetWidth()/2) < tonumber(settings["windowPosition"]["xPos"]))then
		ButtonPlusVoc[i]:SetPosition(posx - 900 , (Turbine.UI.Display:GetHeight()-ButtonPlusVoc[i]:GetHeight())/2);
	else
		ButtonPlusVoc[i]:SetPosition(posx + 242 , (Turbine.UI.Display:GetHeight()-ButtonPlusVoc[i]:GetHeight())/2);
	end
	
	--ButtonPlusVoc[i]:SetPosition(((Turbine.UI.Display:GetWidth()-ButtonPlusVoc[i]:GetWidth())/2)-600,(Turbine.UI.Display:GetHeight()-ButtonPlusVoc[i]:GetHeight())/2);
	ButtonPlusVoc[i]:SetVisible(false);
	ButtonPlusVoc[i]:SetZOrder(100);
	ButtonPlusVoc[i]:SetBackground(ResourcePath .. "/Cadre_380_420.tga");

	centerLabelBVoc[i] = Turbine.UI.Label();
	centerLabelBVoc[i]:SetParent(ButtonPlusVoc[i]);
	centerLabelBVoc[i]:SetPosition( ButtonPlusVoc[i]:GetWidth()/2 - 150, 5 );
	centerLabelBVoc[i]:SetSize( 300, 30  );
	centerLabelBVoc[i]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
	centerLabelBVoc[i]:SetText( texte );
	centerLabelBVoc[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBVoc[i]:SetZOrder(101);
	centerLabelBVoc[i]:SetForeColor(Turbine.UI.Color.Gold);

	local posyStart = 60;
	local posxStart = 80;

	if(PlayerProfessions[i] ~= nil)then
		for x=1, 3 do
			centerLabelProf1[i] = Turbine.UI.Label();
			centerLabelProf1[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelProf1[i]:SetPosition( posxStart - 30, posyStart );
			centerLabelProf1[i]:SetSize( 200, 30  );
			centerLabelProf1[i]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold24);
			centerLabelProf1[i]:SetText( PlayerProfessions[i].Name[x] );
			centerLabelProf1[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelProf1[i]:SetZOrder(21);
			--centerLabelProf1[i]:SetForeColor(Turbine.UI.Color.Gold);

			centerLabelProfIcon[i] = Turbine.UI.Label();
			centerLabelProfIcon[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelProfIcon[i]:SetPosition( posxStart - 70, posyStart );
			centerLabelProfIcon[i]:SetSize( 32, 32  );
			centerLabelProfIcon[i]:SetZOrder(21);

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

			if(PlayerDatas[i].voc == 1)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[1] ); -- explorateur
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[9] ); -- explorateur
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[2] ); -- explorateur
				end
			end
			if(PlayerDatas[i].voc == 2)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[4] ); -- joaillier
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[2] ); -- joaillier
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[7] ); -- joaillier
				end
			end
			if(PlayerDatas[i].voc == 3)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[4] ); -- franc-tenancier
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[9] ); -- franc-tenancier
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[5] ); -- franc-tenancier
				end
			end
			if(PlayerDatas[i].voc == 4)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[6] ); -- historien
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[5] ); -- historien
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[3] ); -- historien
				end
			end
			if(PlayerDatas[i].voc == 5)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[1] ); -- armurier
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[10] ); -- armurier
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[3] ); -- armurier
				end
			end
			if(PlayerDatas[i].voc == 6)then
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[1] ); -- bucheron
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[10] ); -- bucheron
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[5] ); -- bucheron
				end
			end
			if(PlayerDatas[i].voc == 7)then
				centerLabelB21:SetBackground(0x4110DB15); -- ferronier
				if(x == 1)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[8] ); -- ferronier
				elseif(x == 2)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[9] ); -- ferronier
				elseif(x == 3)then
					centerLabelProfIcon[i]:SetBackground( ResourcePath .. iconsProf[2] ); -- ferronier
				end
			end

			-- current lvl profession
			split_string = Split(PlayerProfessions[i].CurrentLvl[x], "\n");

			centerLabelTier1[i] = Turbine.UI.Label();
			centerLabelTier1[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier1[i]:SetPosition( posxStart - 5, posyStart + 27 );
			centerLabelTier1[i]:SetSize( 280, 30  );
			centerLabelTier1[i]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
			centerLabelTier1[i]:SetText( split_string[1] );
			centerLabelTier1[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier1[i]:SetZOrder(21);
			centerLabelTier1[i]:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

			centerLabelTier1[i] = Turbine.UI.Label();
			centerLabelTier1[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier1[i]:SetPosition( posxStart - 5, posyStart + 42 );
			centerLabelTier1[i]:SetSize( 280, 30  );
			centerLabelTier1[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			centerLabelTier1[i]:SetText( split_string[2] );
			centerLabelTier1[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier1[i]:SetZOrder(21);
			centerLabelTier1[i]:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

			centerLabelTier1[i] = Turbine.UI.Label();
			centerLabelTier1[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier1[i]:SetPosition( posxStart - 40, posyStart + 32 );
			centerLabelTier1[i]:SetSize( 27, 17  );
			centerLabelTier1[i]:SetZOrder(21);
			centerLabelTier1[i]:SetBackground( ResourcePath .. "icon_craft_proficient.tga" );
			centerLabelTier1[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			-- current mastery profession
			split_string = Split(PlayerProfessions[i].currentMastery[x], "\n");

			centerLabelTier2[i] = Turbine.UI.Label();
			centerLabelTier2[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier2[i]:SetPosition( posxStart - 5, posyStart + 67 );
			centerLabelTier2[i]:SetSize( 280, 30  );
			centerLabelTier2[i]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
			centerLabelTier2[i]:SetText( split_string[1] );
			centerLabelTier2[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier2[i]:SetZOrder(21);
			centerLabelTier2[i]:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

			centerLabelTier2[i] = Turbine.UI.Label();
			centerLabelTier2[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier2[i]:SetPosition( posxStart - 5, posyStart + 82 );
			centerLabelTier2[i]:SetSize( 280, 30  );
			centerLabelTier2[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			centerLabelTier2[i]:SetText( split_string[2] );
			centerLabelTier2[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			centerLabelTier2[i]:SetZOrder(21);
			centerLabelTier2[i]:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

			centerLabelTier2[i] = Turbine.UI.Label();
			centerLabelTier2[i]:SetParent(ButtonPlusVoc[i]);
			centerLabelTier2[i]:SetPosition( posxStart - 40, posyStart + 72 );
			centerLabelTier2[i]:SetSize( 27, 17  );
			centerLabelTier2[i]:SetZOrder(21);
			centerLabelTier2[i]:SetBackground( ResourcePath .. "icon_craft_master.tga" );
			centerLabelTier2[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			posyStart = posyStart + 120;
		end
	else
		centerLabelProf1[i] = Turbine.UI.Label();
		centerLabelProf1[i]:SetParent(ButtonPlusVoc[i]);
		centerLabelProf1[i]:SetPosition( 25, 100 );
		centerLabelProf1[i]:SetSize( 250, 100  );
		centerLabelProf1[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		centerLabelProf1[i]:SetText( T[ "PluginStats10" ] );
		centerLabelProf1[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelProf1[i]:SetZOrder(21);
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
		releaseWindow:SetParent( buttonDefineHouseLocationPersonalFaux );
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

	buttonDefineHouseLocationPersonalFaux.MouseEnter = function()
		ButtonPlusVoc[i]:SetVisible(true);
	end

	buttonDefineHouseLocationPersonalFaux.MouseLeave = function()
		ButtonPlusVoc[i]:SetVisible(false);
	end
end
------------------------------------------------------------------------------------------
--function to display the small label for sharedStorage --
------------------------------------------------------------------------------------------
function DisplayLabelCadreForSharedStorage(posx, posy, texte, buttonToDisplay)
	ButtonPlusLab22 = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab22:SetParent( AltHolicWindow );
	ButtonPlusLab22:SetPosition(posx + 40 , posy - 5);
	ButtonPlusLab22:SetSize( 180, 30 );
	ButtonPlusLab22:SetVisible(false);
	ButtonPlusLab22:SetZOrder(20);
	ButtonPlusLab22:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLab22 = Turbine.UI.Label();
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
function DisplayLabelCadreForSearch(posx, posy, buttonToDisplay)

	ButtonPlusLab2 = Turbine.UI.Extensions.SimpleWindow();
	ButtonPlusLab2:SetParent( AltHolicWindow );
	ButtonPlusLab2:SetPosition(posx + 40 , posy - 5);
	ButtonPlusLab2:SetSize( 180, 30 );
	ButtonPlusLab2:SetVisible(false);
	ButtonPlusLab2:SetZOrder(20);
	ButtonPlusLab2:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLab2 = Turbine.UI.Label();
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
		centerLabelIsVisibleSearch:SetBackground(0x410D6DC3); -- search loupe -- serach loupe not over = 0x410D6DC4
	end

	buttonToDisplay.MouseLeave = function()
		ButtonPlusLab2:SetVisible(false);
		centerLabelIsVisibleSearch:SetBackground(0x410D6DC2); -- search loupe -- serach loupe not over = 0x410D6DC4
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
--- Display the button help ---
------------------------------------------------------------------------------------------
function DisplayButtonHelp(WindowsToDisplay, windowHeight, windowWidth, TextToDisplay)
	buttonDefineHelp = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineHelp:SetParent( WindowsToDisplay );
	buttonDefineHelp:SetPosition(windowWidth - 45, 35);
	buttonDefineHelp:SetSize( 20, 20 );
	buttonDefineHelp:SetVisible(true);
	buttonDefineHelp:SetMouseVisible(true);

	centerLabelHelp = Turbine.UI.Label();
	centerLabelHelp:SetParent(buttonDefineHelp);
	centerLabelHelp:SetPosition( 0, 0 );
	centerLabelHelp:SetSize( 20, 20  );
	centerLabelHelp:SetBackground(ResourcePath .. "Help.tga");
	centerLabelHelp:SetZOrder(-1);
	centerLabelHelp:SetMouseVisible(false);

	helpButtonLabel = Turbine.UI.Extensions.SimpleWindow();
	helpButtonLabel:SetParent( WindowsToDisplay );
	helpButtonLabel:SetPosition (windowWidth - 20, 35);
	helpButtonLabel:SetSize( 180, 30 );
	helpButtonLabel:SetZOrder(10000);
	helpButtonLabel:SetVisible(false);
	helpButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabelHelp = Turbine.UI.Label();
	centerLabelBLabelHelp:SetParent(helpButtonLabel);
	centerLabelBLabelHelp:SetPosition( 2, 2 );
	centerLabelBLabelHelp:SetSize( 176, 26  );
	centerLabelBLabelHelp:SetText( T[ "PluginLabelHelp" ] );
	centerLabelBLabelHelp:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabelHelp:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
	centerLabelBLabelHelp:SetZOrder(-1);

	buttonDefineHelp.MouseEnter = function()
		helpButtonLabel:SetVisible(true);
	end

	buttonDefineHelp.MouseLeave = function()
		helpButtonLabel:SetVisible(false);
	end

	buttonDefineHelp.MouseClick = function(sender, args)
		GenerateHelpWindow(TextToDisplay);
		HelpWindow:SetVisible(true);
		settings["isHelpWindowVisible"]["value"] = true;
	end
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
		GenerateInfosWindow(i);
		if(settings["isInfoWindowVisible"]["isInfoWindowVisible"] == false)then
			InfoWindow:SetVisible(true);
			settings["isInfoWindowVisible"]["isInfoWindowVisible"] = true;
		else
			InfoWindow:SetVisible(false);
			settings["isInfoWindowVisible"]["isInfoWindowVisible"] = false;
		end
	end
end
------------------------------------------------------------------------------------------
--- button help ---
------------------------------------------------------------------------------------------
function DisplayHelpButton(WindowsToDisplay, windowWidth, valueToDisplay, SettingsToHandle)
	buttonDefineHelp = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineHelp:SetParent( WindowsToDisplay );
	buttonDefineHelp:SetPosition(windowWidth - 40, 55);
	buttonDefineHelp:SetSize( 20, 20 );
	buttonDefineHelp:SetVisible(true);
	buttonDefineHelp:SetMouseVisible(true);

	centerLabelHelp = Turbine.UI.Label();
	centerLabelHelp:SetParent(buttonDefineHelp);
	centerLabelHelp:SetPosition( 0, 0 );
	centerLabelHelp:SetSize( 20, 20  );
	centerLabelHelp:SetBackground(ResourcePath .. "Help.tga");
	centerLabelHelp:SetZOrder(-1);
	centerLabelHelp:SetMouseVisible(false);

	helpButtonLabel = Turbine.UI.Extensions.SimpleWindow();
	helpButtonLabel:SetParent( WindowsToDisplay );
	helpButtonLabel:SetPosition (windowWidth - 20, 25);
	helpButtonLabel:SetSize( 180, 30 );
	helpButtonLabel:SetZOrder(10000);
	helpButtonLabel:SetVisible(false);
	helpButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabelHelp = Turbine.UI.Label();
	centerLabelBLabelHelp:SetParent(helpButtonLabel);
	centerLabelBLabelHelp:SetPosition( 2, 2 );
	centerLabelBLabelHelp:SetSize( 176, 26  );
	centerLabelBLabelHelp:SetText( T[ "PluginLabelHelp" ] );
	centerLabelBLabelHelp:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabelHelp:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
	centerLabelBLabelHelp:SetZOrder(-1);

	buttonDefineHelp.MouseEnter = function()
		helpButtonLabel:SetVisible(true);
	end

	buttonDefineHelp.MouseLeave = function()
		helpButtonLabel:SetVisible(false);
	end

	buttonDefineHelp.MouseClick = function(sender, args)
		GenerateHelpWindow(valueToDisplay);
		HelpWindow:SetVisible(true);
		SettingsToHandle = true;
	end
end
------------------------------------------------------------------------------------------
--- button help V2 -- posibility of chossing the location---
------------------------------------------------------------------------------------------
function DisplayHelpButtonV2(WindowsToDisplay, windowWidth, windowHeight, valueToDisplay, SettingsToHandle)
	buttonDefineHelp = Turbine.UI.Extensions.SimpleWindow();
	buttonDefineHelp:SetParent( WindowsToDisplay );
	buttonDefineHelp:SetPosition(windowWidth - 40, windowHeight);
	buttonDefineHelp:SetSize( 20, 20 );
	buttonDefineHelp:SetVisible(true);
	buttonDefineHelp:SetMouseVisible(true);

	centerLabelHelp = Turbine.UI.Label();
	centerLabelHelp:SetParent(buttonDefineHelp);
	centerLabelHelp:SetPosition( 0, 0 );
	centerLabelHelp:SetSize( 20, 20  );
	centerLabelHelp:SetBackground(ResourcePath .. "Help.tga");
	centerLabelHelp:SetZOrder(-1);
	centerLabelHelp:SetMouseVisible(false);

	helpButtonLabel = Turbine.UI.Extensions.SimpleWindow();
	helpButtonLabel:SetParent( WindowsToDisplay );
	helpButtonLabel:SetPosition (windowWidth - 20, windowHeight - 25);
	helpButtonLabel:SetSize( 180, 30 );
	helpButtonLabel:SetZOrder(10000);
	helpButtonLabel:SetVisible(false);
	helpButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabelHelp = Turbine.UI.Label();
	centerLabelBLabelHelp:SetParent(helpButtonLabel);
	centerLabelBLabelHelp:SetPosition( 2, 2 );
	centerLabelBLabelHelp:SetSize( 176, 26  );
	centerLabelBLabelHelp:SetText( T[ "PluginLabelHelp" ] );
	centerLabelBLabelHelp:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabelHelp:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
	centerLabelBLabelHelp:SetZOrder(-1);

	buttonDefineHelp.MouseEnter = function()
		helpButtonLabel:SetVisible(true);
	end

	buttonDefineHelp.MouseLeave = function()
		helpButtonLabel:SetVisible(false);
	end

	buttonDefineHelp.MouseClick = function(sender, args)
		GenerateHelpWindow(valueToDisplay);
		HelpWindow:SetVisible(true);
		SettingsToHandle = true;
	end
end