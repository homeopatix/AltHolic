------------------------------------------------------------------------------------------
-- UIShowStats file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowStats(namePlayerToshow)	
	
	UIShowStats=Turbine.UI.Lotro.GoldWindow(); 
	if(PlayerDatas[namePlayerToshow].align == 1)then
		UIShowStats:SetSize(600,620); 
	else
		UIShowStats:SetSize(300,130);
	end
	UIShowStats:SetText(tostring(namePlayerToshow)); 
	UIShowStats:SetPosition((Turbine.UI.Display:GetWidth()-UIShowStats:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowStats:GetHeight())/2); 
	UIShowStats:SetWantsKeyEvents(true);

	if(PlayerDatas[namePlayerToshow].align == 1)then -- free people
		if(PlayerDatas[namePlayerToshow].moral ~= nil and
			PlayerDatas[namePlayerToshow].power ~= nil and
			PlayerDatas[namePlayerToshow].armure ~= nil and
			PlayerDatas[namePlayerToshow].degaP ~= nil and
			PlayerDatas[namePlayerToshow].degaT ~= nil and
			PlayerDatas[namePlayerToshow].orc ~= nil and
			PlayerDatas[namePlayerToshow].healD ~= nil and
			PlayerDatas[namePlayerToshow].healR ~= nil and
			PlayerDatas[namePlayerToshow].meleD ~= nil and
			PlayerDatas[namePlayerToshow].range ~= nil and
			PlayerDatas[namePlayerToshow].tactD ~= nil and
			PlayerDatas[namePlayerToshow].critA ~= nil and
			PlayerDatas[namePlayerToshow].fines ~= nil and
			PlayerDatas[namePlayerToshow].defeC ~= nil and
			PlayerDatas[namePlayerToshow].resis ~= nil and
			PlayerDatas[namePlayerToshow].bloqu ~= nil and
			PlayerDatas[namePlayerToshow].parad ~= nil and
			PlayerDatas[namePlayerToshow].esqui ~= nil)then

			-- this is comming from Habna plugin Titanbar
			PlayerAttArray = {}
			PlayerAttArray[namePlayerToshow] = {}; 
			PlayerAttArray[1] = {"Physical", PlayerDatas[namePlayerToshow].degaP, "PhyMit", "Armour", 1.0};
			PlayerAttArray[2] = {"Tactical", PlayerDatas[namePlayerToshow].degaT, "TacMit", "Armour", 0.2};
			PlayerAttArray[3] = {"Orc", PlayerDatas[namePlayerToshow].orc, "PhyMit", "Armour", 0.2};
			PlayerAttArray[4] = {"Fell", PlayerDatas[namePlayerToshow].orc, "PhyMit", "Armour", 0.2};
			PlayerAttArray[5] = {"Outgoing", PlayerDatas[namePlayerToshow].healD, "OutHeal", nil, nil};
			PlayerAttArray[6] = {"Incoming", PlayerDatas[namePlayerToshow].healR, "InHeal", nil, nil};
			PlayerAttArray[7] = {"Melee", PlayerDatas[namePlayerToshow].meleD, "PhyDmg", nil, nil};
			PlayerAttArray[8] = {"Ranged", PlayerDatas[namePlayerToshow].range, "PhyDmg", nil, nil};
			PlayerAttArray[9] = {"Tactical", PlayerDatas[namePlayerToshow].tactD, "TacDmg", nil, nil};
			PlayerAttArray[10] = {"CritHit", PlayerDatas[namePlayerToshow].critA, "CritHit", nil, nil};
			PlayerAttArray[11] = {"DevHit", PlayerDatas[namePlayerToshow].critA, "DevHit", nil, nil};
			PlayerAttArray[12] = {"Finesse", PlayerDatas[namePlayerToshow].fines, "Finesse", nil, nil};
			PlayerAttArray[13] = {"CritDef", PlayerDatas[namePlayerToshow].defeC, "CritDef", nil, nil};
			PlayerAttArray[14] = {"Resistances", PlayerDatas[namePlayerToshow].resis, "Resist", "Resist", nil};
			PlayerAttArray[15] = {"Block", PlayerDatas[namePlayerToshow].bloqu, "Block", "BPE", nil};
			PlayerAttArray[16] = {"Partial", PlayerDatas[namePlayerToshow].bloqu, "PartBlock", "BPE", nil};
			PlayerAttArray[17] = {"Parry", PlayerDatas[namePlayerToshow].parad, "Parry", "BPE", nil};
			PlayerAttArray[18] = {"Partial", PlayerDatas[namePlayerToshow].parad, "PartParry", "BPE", nil};
			PlayerAttArray[19] = {"Evade", PlayerDatas[namePlayerToshow].esqui, "Evade", "BPE", nil};
			PlayerAttArray[20] = {"Partial", PlayerDatas[namePlayerToshow].esqui, "PartEvade", "BPE", nil};

			--[[
			UIShowStats.MessageStart=Turbine.UI.Label(); 
			UIShowStats.MessageStart:SetParent(UIShowStats); 
			UIShowStats.MessageStart:SetSize(150,10); 
			UIShowStats.MessageStart:SetPosition(UIShowStats:GetWidth()/2 - 75, UIShowStats:GetHeight() - 20); 
			UIShowStats.MessageStart:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageStart:SetText(T[ "PluginText" ]); 
			--]]
			UIShowStats:SetZOrder(10);
			UIShowStats:SetWantsKeyEvents(true);
			UIShowStats:SetVisible(false);

			UIShowStats.MessageGilseldah=Turbine.UI.Label(); 
			UIShowStats.MessageGilseldah:SetParent(UIShowStats); 
			UIShowStats.MessageGilseldah:SetSize(550,20); 
			UIShowStats.MessageGilseldah:SetPosition(UIShowStats:GetWidth()/2 - 275, UIShowStats:GetHeight() - 25);
			UIShowStats.MessageGilseldah:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageGilseldah:SetFont(Turbine.UI.Lotro.Font.BookAntiqua16);
			UIShowStats.MessageGilseldah:SetText(T[ "PluginCalcStatVersionText" ] .. " " .. T[ "PluginCalcStatVersion" ]); 

			local posy = 60 ;
			local posx = 30;

			-- moral
			UIShowStatsLabIcon=Turbine.UI.Label(); 
			UIShowStatsLabIcon:SetParent(UIShowStats); 
			UIShowStatsLabIcon:SetSize(24, 25); 
			UIShowStatsLabIcon:SetPosition(posx + 30, posy ); 
			UIShowStatsLabIcon:SetBackground(0x410DCFCE); -- moral
			UIShowStatsLabIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			UIShowStats.Message14a=Turbine.UI.Label(); 
			UIShowStats.Message14a:SetParent(UIShowStats); 
			UIShowStats.Message14a:SetSize(300,20); 
			UIShowStats.Message14a:SetPosition(posx + 70, posy - 2); 
			UIShowStats.Message14a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message14a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			PlayerDatas[namePlayerToshow].moral = PlayerDatas[namePlayerToshow].maxMoral;
			if(namePlayerToshow == PlayerName)then
				PlayerDatas[namePlayerToshow].moral = Player:GetMorale()-- power
			else
				PlayerDatas[namePlayerToshow].moral = PlayerDatas[namePlayerToshow].maxMoral-- power
			end
			UIShowStats.Message14a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].moral)) .. " / " .. comma_value(Round(PlayerDatas[namePlayerToshow].maxMoral))); 
			UIShowStats.Message14a:SetForeColor(Turbine.UI.Color( 0.33, 0.66, 0.33 )); -- nice green


			posx = posx + 200;
			-- power / wrath
			UIShowStatsLabIcon=Turbine.UI.Label(); 
			UIShowStatsLabIcon:SetParent(UIShowStats); 
			UIShowStatsLabIcon:SetSize(24, 25); 
			UIShowStatsLabIcon:SetPosition(posx + 30, posy ); 
			if(PlayerDatas[namePlayerToshow].rac ~= 114)then
				UIShowStatsLabIcon:SetBackground(0x410DCFCF); -- power
			else
				UIShowStatsLabIcon:SetBackground(0x4115BDFE); -- wrath
			end
			UIShowStatsLabIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			UIShowStats.Message12a=Turbine.UI.Label(); 
			UIShowStats.Message12a:SetParent(UIShowStats); 
			UIShowStats.Message12a:SetSize(300,20); 
			UIShowStats.Message12a:SetPosition(posx + 70, posy - 2); 
			UIShowStats.Message12a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message12a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			if(PlayerDatas[namePlayerToshow].rac ~= 114)then
				if(namePlayerToshow == PlayerName)then
					PlayerDatas[namePlayerToshow].power = Player:GetPower()-- power
				else
					PlayerDatas[namePlayerToshow].power = PlayerDatas[namePlayerToshow].maxPower-- power
				end
				UIShowStats.Message12a:SetForeColor(Turbine.UI.Color( 0, 0.66, 0.75)); -- nice blue
			else
				PlayerDatas[namePlayerToshow].maxPower = 100 -- wrath
				PlayerDatas[namePlayerToshow].power = 0; -- wrath
				UIShowStats.Message12a:SetForeColor(Turbine.UI.Color( 0.9, 0.9, 0.1, 0 )); -- red
			end
			UIShowStats.Message12a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].power)) .. " / " .. comma_value(Round(PlayerDatas[namePlayerToshow].maxPower))); 

			posx = posx + 200;
			-- armor
			UIShowStatsLabIcon=Turbine.UI.Label(); 
			UIShowStatsLabIcon:SetParent(UIShowStats); 
			UIShowStatsLabIcon:SetSize(24, 25); 
			UIShowStatsLabIcon:SetPosition(posx + 30, posy ); 
			UIShowStatsLabIcon:SetBackground(0x410DCFD0); -- armor
			UIShowStatsLabIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			UIShowStats.Message11a=Turbine.UI.Label(); 
			UIShowStats.Message11a:SetParent(UIShowStats); 
			UIShowStats.Message11a:SetSize(300,20); 
			UIShowStats.Message11a:SetPosition(posx + 70, posy - 2); 
			UIShowStats.Message11a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message11a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			UIShowStats.Message11a:SetText(comma_value(PlayerDatas[namePlayerToshow].armure)); 
			UIShowStats.Message11a:SetForeColor(Turbine.UI.Color( 0.5, 0.4, 0.2)); -- brown

			posy = 100;
			posx = 50;

			-- datas basic
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText( T[ "PluginStats" ] ); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;
			-- separator
			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Gold);

			posy = posy + 20;

			-- lvl
			UIShowStats.Message4=Turbine.UI.Label(); 
			UIShowStats.Message4:SetParent(UIShowStats); 
			UIShowStats.Message4:SetSize(100,20); 
			UIShowStats.Message4:SetPosition(posx - 20, posy ); 
			UIShowStats.Message4:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message4:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message4:SetText(T[ "PluginStats6" ]); 

			UIShowStats.Message4a=Turbine.UI.Label(); 
			UIShowStats.Message4a:SetParent(UIShowStats); 
			UIShowStats.Message4a:SetSize(300,20); 
			UIShowStats.Message4a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message4a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message4a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message4a:SetText(PlayerDatas[namePlayerToshow].lvl); 

			posy = posy + 20;
			-- race
			UIShowStats.Message22=Turbine.UI.Label(); 
			UIShowStats.Message22:SetParent(UIShowStats); 
			UIShowStats.Message22:SetSize(100,20); 
			UIShowStats.Message22:SetPosition(posx - 20, posy ); 
			UIShowStats.Message22:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message22:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message22:SetText(T[ "PluginStats7" ]); 

			UIShowStats.Message22a=Turbine.UI.Label(); 
			UIShowStats.Message22a:SetParent(UIShowStats); 
			UIShowStats.Message22a:SetSize(300,20); 
			UIShowStats.Message22a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message22a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message22a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);


			if(PlayerDatas[namePlayerToshow].rac == 81)then -- hobbit
				UIShowStats.Message22a:SetText(T[ "PluginRace1" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 23)then -- homme
				UIShowStats.Message22a:SetText(T[ "PluginRace2" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 65)then -- elf
				UIShowStats.Message22a:SetText(T[ "PluginRace3" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 114)then -- beornide
				UIShowStats.Message22a:SetText(T[ "PluginRace4" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 120)then -- nain hache
				UIShowStats.Message22a:SetText(T[ "PluginRace5" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 73)then -- nain
				UIShowStats.Message22a:SetText(T[ "PluginRace6" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 117)then -- haut elf
				UIShowStats.Message22a:SetText(T[ "PluginRace7" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 7)then  -- orque
				UIShowStats.Message22a:SetText(T[ "PluginRace8" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 12)then -- araignée
				UIShowStats.Message22a:SetText(T[ "PluginRace9" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 6)then  -- ourouk
				UIShowStats.Message22a:SetText(T[ "PluginRace10" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 66)then -- ouargue
				UIShowStats.Message22a:SetText(T[ "PluginRace11" ]); 
			end
			if(PlayerDatas[namePlayerToshow].rac == 125)then -- hobbit des rivieres
				UIShowStats.Message22a:SetText(T[ "PluginRace12" ]); 
			end

			posy = posy + 20;
			-- classe
			UIShowStats.Message3=Turbine.UI.Label(); 
			UIShowStats.Message3:SetParent(UIShowStats); 
			UIShowStats.Message3:SetSize(100,20); 
			UIShowStats.Message3:SetPosition(posx - 20, posy ); 
			UIShowStats.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message3:SetText(T[ "PluginStats8" ]); 

			UIShowStats.Message3a=Turbine.UI.Label(); 
			UIShowStats.Message3a:SetParent(UIShowStats); 
			UIShowStats.Message3a:SetSize(300,20); 
			UIShowStats.Message3a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message3a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message3a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
		 

			if(PlayerDatas[namePlayerToshow].cla == 162)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse1" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 31)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse2" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 214)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse3" ]);
			end	
			if(PlayerDatas[namePlayerToshow].cla == 24)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse4" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 193)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse5" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 40)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse6" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 185)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse7" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 23)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse8" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 172)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse9" ]);
			end	
			if(PlayerDatas[namePlayerToshow].cla == 194)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse10" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 71)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse11" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 128)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse12" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 127)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse13" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 179)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse14" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 52)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse15" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 126)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse16" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 215)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse17" ]);
			end
			if(PlayerDatas[namePlayerToshow].cla == 216)then
				UIShowStats.Message3a:SetText(T[ "PluginClasse18" ]);
			end

			posy = posy + 20;
			-- vocation
			UIShowStats.Message3=Turbine.UI.Label(); 
			UIShowStats.Message3:SetParent(UIShowStats); 
			UIShowStats.Message3:SetSize(100,20); 
			UIShowStats.Message3:SetPosition(posx - 20, posy ); 
			UIShowStats.Message3:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message3:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message3:SetText(T[ "PluginVocation8" ]); 

			UIShowStats.Message3a=Turbine.UI.Label(); 
			UIShowStats.Message3a:SetParent(UIShowStats); 
			UIShowStats.Message3a:SetSize(300,20); 
			UIShowStats.Message3a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message3a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message3a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
		 

			if(PlayerDatas[namePlayerToshow].voc == 1)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation1" ]);
			end
			if(PlayerDatas[namePlayerToshow].voc == 2)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation2" ]);
			end
			if(PlayerDatas[namePlayerToshow].voc == 3)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation3" ]);
			end	
			if(PlayerDatas[namePlayerToshow].voc == 4)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation4" ]);
			end
			if(PlayerDatas[namePlayerToshow].voc == 5)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation5" ]);
			end
			if(PlayerDatas[namePlayerToshow].voc == 6)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation6" ]);
			end
			if(PlayerDatas[namePlayerToshow].voc == 7)then
				UIShowStats.Message3a:SetText(T[ "PluginVocation7" ]);
			end

			posy = posy + 20;
			-- sexe
			UIShowStats.Message1=Turbine.UI.Label(); 
			UIShowStats.Message1:SetParent(UIShowStats); 
			UIShowStats.Message1:SetSize(100,20); 
			UIShowStats.Message1:SetPosition(posx - 20, posy ); 
			UIShowStats.Message1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message1:SetText(T[ "PluginStats9" ]); 

			UIShowStats.Message1a=Turbine.UI.Label(); 
			UIShowStats.Message1a:SetParent(UIShowStats); 
			UIShowStats.Message1a:SetSize(300,20); 
			UIShowStats.Message1a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message1a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message1a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			if(PlayerDatas[namePlayerToshow].sexe == "male")then
				UIShowStats.Message1a:SetText(T[ "PluginGendreText1" ]);
			else
				UIShowStats.Message1a:SetText(T[ "PluginGendreText2" ]);
			end

			posy = posy + 20;
			-- healing
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats11" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;
			-- separator
			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Gold);

			posy = posy + 20;
				-- force
				UIShowStats.Message9=Turbine.UI.Label(); 
				UIShowStats.Message9:SetParent(UIShowStats); 
				UIShowStats.Message9:SetSize(100,20); 
				UIShowStats.Message9:SetPosition(posx - 20, posy ); 
				UIShowStats.Message9:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowStats.Message9:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message9:SetText(T[ "PluginStats1" ]); 

				UIShowStats.Message9a=Turbine.UI.Label(); 
				UIShowStats.Message9a:SetParent(UIShowStats); 
				UIShowStats.Message9a:SetSize(300,20); 
				UIShowStats.Message9a:SetPosition(posx - 80, posy ); 
				UIShowStats.Message9a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
				UIShowStats.Message9a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message9a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].might))); 

				posy = posy + 20;
				-- agility
				UIShowStats.Message8=Turbine.UI.Label(); 
				UIShowStats.Message8:SetParent(UIShowStats); 
				UIShowStats.Message8:SetSize(100,20); 
				UIShowStats.Message8:SetPosition(posx - 20, posy ); 
				UIShowStats.Message8:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowStats.Message8:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message8:SetText(T[ "PluginStats2" ]); 

				UIShowStats.Message8a=Turbine.UI.Label(); 
				UIShowStats.Message8a:SetParent(UIShowStats); 
				UIShowStats.Message8a:SetSize(300,20); 
				UIShowStats.Message8a:SetPosition(posx - 80, posy ); 
				UIShowStats.Message8a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
				UIShowStats.Message8a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message8a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].agility))); 

				posy = posy + 20;
				-- vitality
				UIShowStats.Message7=Turbine.UI.Label(); 
				UIShowStats.Message7:SetParent(UIShowStats); 
				UIShowStats.Message7:SetSize(100,20); 
				UIShowStats.Message7:SetPosition(posx - 20, posy ); 
				UIShowStats.Message7:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowStats.Message7:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message7:SetText(T[ "PluginStats3" ]); 

				UIShowStats.Message7a=Turbine.UI.Label(); 
				UIShowStats.Message7a:SetParent(UIShowStats); 
				UIShowStats.Message7a:SetSize(300,20); 
				UIShowStats.Message7a:SetPosition(posx - 80, posy ); 
				UIShowStats.Message7a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
				UIShowStats.Message7a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message7a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].vitality))); 

				posy = posy + 20;
				-- will
				UIShowStats.Message6=Turbine.UI.Label(); 
				UIShowStats.Message6:SetParent(UIShowStats); 
				UIShowStats.Message6:SetSize(100,20); 
				UIShowStats.Message6:SetPosition(posx - 20, posy ); 
				UIShowStats.Message6:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowStats.Message6:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message6:SetText(T[ "PluginStats4" ]); 

				UIShowStats.Message6a=Turbine.UI.Label(); 
				UIShowStats.Message6a:SetParent(UIShowStats); 
				UIShowStats.Message6a:SetSize(300,20); 
				UIShowStats.Message6a:SetPosition(posx - 80, posy ); 
				UIShowStats.Message6a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
				UIShowStats.Message6a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message6a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].will))); 

				posy = posy + 20;
				-- fate
				UIShowStats.Message5=Turbine.UI.Label(); 
				UIShowStats.Message5:SetParent(UIShowStats); 
				UIShowStats.Message5:SetSize(100,20); 
				UIShowStats.Message5:SetPosition(posx - 20, posy ); 
				UIShowStats.Message5:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
				UIShowStats.Message5:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message5:SetText(T[ "PluginStats5" ]); 

				UIShowStats.Message5a=Turbine.UI.Label(); 
				UIShowStats.Message5a:SetParent(UIShowStats); 
				UIShowStats.Message5a:SetSize(300,20); 
				UIShowStats.Message5a:SetPosition(posx - 80, posy ); 
				UIShowStats.Message5a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
				UIShowStats.Message5a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
				UIShowStats.Message5a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].fate))); 

			posy = posy + 20;
			-- separator
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats12" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;

			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Red);

			posy = posy + 20;
			-- Critical hit chanc
			UIShowStats.Message10=Turbine.UI.Label(); 
			UIShowStats.Message10:SetParent(UIShowStats); 
			UIShowStats.Message10:SetSize(200,20); 
			UIShowStats.Message10:SetPosition(posx - 20, posy ); 
			UIShowStats.Message10:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message10:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message10:SetText(T[ "PluginStats13" ]); 

			UIShowStats.Message10a=Turbine.UI.Label(); 
			UIShowStats.Message10a:SetParent(UIShowStats); 
			UIShowStats.Message10a:SetSize(300,20); 
			UIShowStats.Message10a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message10a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message10a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[10][3], PlayerAttArray[10][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[10][4], PlayerAttArray[10][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message10a);
			UIShowStats.Message10a:SetText( value );

			posy = posy + 20;
			-- Critical dev hit 
			UIShowStats.Message100=Turbine.UI.Label(); 
			UIShowStats.Message100:SetParent(UIShowStats); 
			UIShowStats.Message100:SetSize(200,20); 
			UIShowStats.Message100:SetPosition(posx - 20, posy ); 
			UIShowStats.Message100:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message100:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message100:SetText(T[ "PluginStats34" ]); 

			UIShowStats.Message100a=Turbine.UI.Label(); 
			UIShowStats.Message100a:SetParent(UIShowStats); 
			UIShowStats.Message100a:SetSize(300,20); 
			UIShowStats.Message100a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message100a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message100a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[11][3], PlayerAttArray[11][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[11][4], PlayerAttArray[11][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message100a);
			UIShowStats.Message100a:SetText( value );

			posy = posy + 20;
			-- finesse
			UIShowStats.Message11=Turbine.UI.Label(); 
			UIShowStats.Message11:SetParent(UIShowStats); 
			UIShowStats.Message11:SetSize(200,20); 
			UIShowStats.Message11:SetPosition(posx - 20, posy ); 
			UIShowStats.Message11:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message11:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message11:SetText(T[ "PluginStats14" ]); 

			UIShowStats.Message11a=Turbine.UI.Label(); 
			UIShowStats.Message11a:SetParent(UIShowStats); 
			UIShowStats.Message11a:SetSize(300,20); 
			UIShowStats.Message11a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message11a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message11a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[12][3], PlayerAttArray[12][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[12][4], PlayerAttArray[12][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message11a);
			UIShowStats.Message11a:SetText( value );

			posy = posy + 20;
			-- maitrise physique
			UIShowStats.Message112=Turbine.UI.Label(); 
			UIShowStats.Message112:SetParent(UIShowStats); 
			UIShowStats.Message112:SetSize(200,20); 
			UIShowStats.Message112:SetPosition(posx - 20, posy ); 
			UIShowStats.Message112:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message112:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message112:SetText(T[ "PluginStats15" ]); 

			UIShowStats.Message112a=Turbine.UI.Label(); 
			UIShowStats.Message112a:SetParent(UIShowStats); 
			UIShowStats.Message112a:SetSize(300,20); 
			UIShowStats.Message112a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message112a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message112a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[7][3], PlayerAttArray[7][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[7][4], PlayerAttArray[7][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message112a);
			UIShowStats.Message112a:SetText( value );

			posy = posy + 20;
			-- maitrise tactique
			UIShowStats.Message113=Turbine.UI.Label(); 
			UIShowStats.Message113:SetParent(UIShowStats); 
			UIShowStats.Message113:SetSize(200,20); 
			UIShowStats.Message113:SetPosition(posx - 20, posy ); 
			UIShowStats.Message113:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message113:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message113:SetText(T[ "PluginStats16" ]); 

			UIShowStats.Message113a=Turbine.UI.Label(); 
			UIShowStats.Message113a:SetParent(UIShowStats); 
			UIShowStats.Message113a:SetSize(300,20); 
			UIShowStats.Message113a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message113a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message113a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[9][3], PlayerAttArray[9][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[9][4], PlayerAttArray[9][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message113a);
			UIShowStats.Message113a:SetText( value );

			posy = posy + 20;
			-- maitrise distance
			UIShowStats.Message131=Turbine.UI.Label(); 
			UIShowStats.Message131:SetParent(UIShowStats); 
			UIShowStats.Message131:SetSize(200,20); 
			UIShowStats.Message131:SetPosition(posx - 20, posy ); 
			UIShowStats.Message131:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message131:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message131:SetText(T[ "PluginStats31" ]); 

			UIShowStats.Message131a=Turbine.UI.Label(); 
			UIShowStats.Message131a:SetParent(UIShowStats); 
			UIShowStats.Message131a:SetSize(300,20); 
			UIShowStats.Message131a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message131a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message131a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[8][3], PlayerAttArray[8][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[8][4], PlayerAttArray[8][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message131a);
			UIShowStats.Message131a:SetText( value );

			posy = 98;
			posx = 350;
			-- type de dagats
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats17" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;

			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Blue);

			posy = posy + 20;
			-- maitrise physique
			UIShowStats.Message114=Turbine.UI.Label(); 
			UIShowStats.Message114:SetParent(UIShowStats); 
			UIShowStats.Message114:SetSize(200,20); 
			UIShowStats.Message114:SetPosition(posx - 20, posy ); 
			UIShowStats.Message114:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message114:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message114:SetText(T[ "PluginStats27" ]); 

			UIShowStats.Message114a=Turbine.UI.Label(); 
			UIShowStats.Message114a:SetParent(UIShowStats); 
			UIShowStats.Message114a:SetSize(300,20); 
			UIShowStats.Message114a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message114a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message114a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[1][3], PlayerAttArray[1][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[1][4], PlayerAttArray[1][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message114a);
			UIShowStats.Message114a:SetText( value );

			posy = posy + 20;
			-- maitrise tactique
			UIShowStats.Message115=Turbine.UI.Label(); 
			UIShowStats.Message115:SetParent(UIShowStats); 
			UIShowStats.Message115:SetSize(200,20); 
			UIShowStats.Message115:SetPosition(posx - 20, posy ); 
			UIShowStats.Message115:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message115:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message115:SetText(T[ "PluginStats28" ]); 

			UIShowStats.Message115a=Turbine.UI.Label(); 
			UIShowStats.Message115a:SetParent(UIShowStats); 
			UIShowStats.Message115a:SetSize(300,20); 
			UIShowStats.Message115a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message115a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message115a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[2][3], PlayerAttArray[2][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[2][4], PlayerAttArray[2][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message115a);
			UIShowStats.Message115a:SetText( value );

			posy = posy + 20;
			-- maitrise tactique
			UIShowStats.Message116=Turbine.UI.Label(); 
			UIShowStats.Message116:SetParent(UIShowStats); 
			UIShowStats.Message116:SetSize(200,20); 
			UIShowStats.Message116:SetPosition(posx - 20, posy ); 
			UIShowStats.Message116:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message116:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message116:SetText(T[ "PluginStats32" ]); 

			UIShowStats.Message116a=Turbine.UI.Label(); 
			UIShowStats.Message116a:SetParent(UIShowStats); 
			UIShowStats.Message116a:SetSize(300,20); 
			UIShowStats.Message116a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message116a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message116a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[3][3], PlayerAttArray[3][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[3][4], PlayerAttArray[3][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message116a);
			UIShowStats.Message116a:SetText( value );

			posy = posy + 20;
			-- maitrise tactique
			UIShowStats.Message117=Turbine.UI.Label(); 
			UIShowStats.Message117:SetParent(UIShowStats); 
			UIShowStats.Message117:SetSize(200,20); 
			UIShowStats.Message117:SetPosition(posx - 20, posy ); 
			UIShowStats.Message117:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message117:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message117:SetText(T[ "PluginStats33" ]); 

			UIShowStats.Message117a=Turbine.UI.Label(); 
			UIShowStats.Message117a:SetParent(UIShowStats); 
			UIShowStats.Message117a:SetSize(300,20); 
			UIShowStats.Message117a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message117a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message117a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[4][3], PlayerAttArray[4][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[4][4], PlayerAttArray[4][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message117a);
			UIShowStats.Message117a:SetText( value );

			posy = posy + 20;
			-- defense
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats18" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;

			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Blue);

			posy = posy + 20;
			-- finesse
			UIShowStats.Message16=Turbine.UI.Label(); 
			UIShowStats.Message16:SetParent(UIShowStats); 
			UIShowStats.Message16:SetSize(200,20); 
			UIShowStats.Message16:SetPosition(posx - 20, posy ); 
			UIShowStats.Message16:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message16:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message16:SetText(T[ "PluginStats19" ]); 

			UIShowStats.Message16a=Turbine.UI.Label(); 
			UIShowStats.Message16a:SetParent(UIShowStats); 
			UIShowStats.Message16a:SetSize(300,20); 
			UIShowStats.Message16a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message16a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message16a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[14][3], PlayerAttArray[14][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[14][4], PlayerAttArray[14][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message16a);
			UIShowStats.Message16a:SetText( value );

			posy = posy + 20;
			-- Critical defense chance
			UIShowStats.Message17=Turbine.UI.Label(); 
			UIShowStats.Message17:SetParent(UIShowStats); 
			UIShowStats.Message17:SetSize(200,20); 
			UIShowStats.Message17:SetPosition(posx - 20, posy ); 
			UIShowStats.Message17:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message17:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message17:SetText(T[ "PluginStats29" ]); 

			UIShowStats.Message17a=Turbine.UI.Label(); 
			UIShowStats.Message17a:SetParent(UIShowStats); 
			UIShowStats.Message17a:SetSize(300,20); 
			UIShowStats.Message17a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message17a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message17a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[13][3], PlayerAttArray[13][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[13][4], PlayerAttArray[13][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message17a);
			UIShowStats.Message17a:SetText( value );

			posy = posy + 20;
			-- echappement
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats20" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;

			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Blue);

			posy = posy + 20;
			-- block
			UIShowStats.Message18=Turbine.UI.Label(); 
			UIShowStats.Message18:SetParent(UIShowStats); 
			UIShowStats.Message18:SetSize(200,20); 
			UIShowStats.Message18:SetPosition(posx - 20, posy ); 
			UIShowStats.Message18:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message18:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message18:SetText(T[ "PluginStats21" ]); 

			UIShowStats.Message18a=Turbine.UI.Label(); 
			UIShowStats.Message18a:SetParent(UIShowStats); 
			UIShowStats.Message18a:SetSize(300,20); 
			UIShowStats.Message18a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message18a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message18a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[15][3], PlayerAttArray[15][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[15][4], PlayerAttArray[15][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message18a);
			UIShowStats.Message18a:SetText( value );

			posy = posy + 20;
			-- block partial
			UIShowStats.Message181=Turbine.UI.Label(); 
			UIShowStats.Message181:SetParent(UIShowStats); 
			UIShowStats.Message181:SetSize(200,20); 
			UIShowStats.Message181:SetPosition(posx - 20, posy ); 
			UIShowStats.Message181:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message181:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message181:SetText("    " .. T[ "PluginStats30" ]); 

			UIShowStats.Message181a=Turbine.UI.Label(); 
			UIShowStats.Message181a:SetParent(UIShowStats); 
			UIShowStats.Message181a:SetSize(300,20); 
			UIShowStats.Message181a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message181a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message181a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[16][3], PlayerAttArray[16][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[16][4], PlayerAttArray[16][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message181a);
			UIShowStats.Message181a:SetText( value );

			posy = posy + 20;
			-- pary
			UIShowStats.Message19=Turbine.UI.Label(); 
			UIShowStats.Message19:SetParent(UIShowStats); 
			UIShowStats.Message19:SetSize(200,20); 
			UIShowStats.Message19:SetPosition(posx - 20, posy ); 
			UIShowStats.Message19:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message19:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message19:SetText(T[ "PluginStats22" ]); 

			UIShowStats.Message19a=Turbine.UI.Label(); 
			UIShowStats.Message19a:SetParent(UIShowStats); 
			UIShowStats.Message19a:SetSize(300,20); 
			UIShowStats.Message19a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message19a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message19a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[17][3], PlayerAttArray[17][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[17][4], PlayerAttArray[17][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message19a);
			UIShowStats.Message19a:SetText( value );

			posy = posy + 20;
			-- pary partial
			UIShowStats.Message119=Turbine.UI.Label(); 
			UIShowStats.Message119:SetParent(UIShowStats); 
			UIShowStats.Message119:SetSize(200,20); 
			UIShowStats.Message119:SetPosition(posx - 20, posy ); 
			UIShowStats.Message119:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message119:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message119:SetText("    " .. T[ "PluginStats30" ]); 

			UIShowStats.Message119a=Turbine.UI.Label(); 
			UIShowStats.Message119a:SetParent(UIShowStats); 
			UIShowStats.Message119a:SetSize(300,20); 
			UIShowStats.Message119a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message119a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message119a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[18][3], PlayerAttArray[18][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[18][4], PlayerAttArray[18][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message119a);
			UIShowStats.Message119a:SetText( value );

			posy = posy + 20;
			-- evade
			UIShowStats.Message2=Turbine.UI.Label(); 
			UIShowStats.Message2:SetParent(UIShowStats); 
			UIShowStats.Message2:SetSize(200,20); 
			UIShowStats.Message2:SetPosition(posx - 20, posy ); 
			UIShowStats.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message2:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message2:SetText(T[ "PluginStats23" ]); 

			UIShowStats.Message2a=Turbine.UI.Label(); 
			UIShowStats.Message2a:SetParent(UIShowStats); 
			UIShowStats.Message2a:SetSize(300,20); 
			UIShowStats.Message2a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message2a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message2a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[19][3], PlayerAttArray[19][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[19][4], PlayerAttArray[19][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message2a);
			UIShowStats.Message2a:SetText( value );

			posy = posy + 20;
			-- evade partial
			UIShowStats.Message211=Turbine.UI.Label(); 
			UIShowStats.Message211:SetParent(UIShowStats); 
			UIShowStats.Message211:SetSize(200,20); 
			UIShowStats.Message211:SetPosition(posx - 20, posy ); 
			UIShowStats.Message211:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message211:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message211:SetText("    " .. T[ "PluginStats30" ]); 

			UIShowStats.Message211a=Turbine.UI.Label(); 
			UIShowStats.Message211a:SetParent(UIShowStats); 
			UIShowStats.Message211a:SetSize(300,20); 
			UIShowStats.Message211a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message211a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message211a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[20][3], PlayerAttArray[20][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[20][4], PlayerAttArray[20][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message211a);
			UIShowStats.Message211a:SetText( value );

			posy = posy + 20;
			-- healing
			UIShowStats.MessageLine1=Turbine.UI.Label(); 
			UIShowStats.MessageLine1:SetParent(UIShowStats); 
			UIShowStats.MessageLine1:SetSize(250, 30); 
			UIShowStats.MessageLine1:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine1:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine1:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine1:SetText(T[ "PluginStats24" ]); 
			UIShowStats.MessageLine1:SetForeColor(Turbine.UI.Color.White);

			posy = posy + 10;

			UIShowStats.MessageLine=Turbine.UI.Label(); 
			UIShowStats.MessageLine:SetParent(UIShowStats); 
			UIShowStats.MessageLine:SetSize(250, 30); 
			UIShowStats.MessageLine:SetPosition(posx - 25, posy); 
			UIShowStats.MessageLine:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageLine:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.MessageLine:SetText("_______________________________________________________________________"); 
			UIShowStats.MessageLine:SetForeColor(Turbine.UI.Color.Green);

			posy = posy + 20;
			-- done
			UIShowStats.Message21=Turbine.UI.Label(); 
			UIShowStats.Message21:SetParent(UIShowStats); 
			UIShowStats.Message21:SetSize(200,20); 
			UIShowStats.Message21:SetPosition(posx - 20, posy ); 
			UIShowStats.Message21:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message21:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message21:SetText(T[ "PluginStats25" ]); 

			UIShowStats.Message21a=Turbine.UI.Label(); 
			UIShowStats.Message21a:SetParent(UIShowStats); 
			UIShowStats.Message21a:SetSize(300,20); 
			UIShowStats.Message21a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message21a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message21a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[5][3], PlayerAttArray[5][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[5][4], PlayerAttArray[5][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message21a);
			UIShowStats.Message21a:SetText( value );

			posy = posy + 20;
			-- recieved
			UIShowStats.Message31=Turbine.UI.Label(); 
			UIShowStats.Message31:SetParent(UIShowStats); 
			UIShowStats.Message31:SetSize(200,20); 
			UIShowStats.Message31:SetPosition(posx - 20, posy ); 
			UIShowStats.Message31:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message31:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			UIShowStats.Message31:SetText(T[ "PluginStats26" ]); 

			UIShowStats.Message31a=Turbine.UI.Label(); 
			UIShowStats.Message31a:SetParent(UIShowStats); 
			UIShowStats.Message31a:SetSize(300,20); 
			UIShowStats.Message31a:SetPosition(posx - 80, posy ); 
			UIShowStats.Message31a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight); 
			UIShowStats.Message31a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
			local value, capped = get_percentage(PlayerAttArray[6][3], PlayerAttArray[6][2], PlayerDatas[namePlayerToshow].lvl, PlayerAttArray[6][4], PlayerAttArray[6][5], namePlayerToshow);
			SetTheTextColorForCapped(capped, UIShowStats.Message31a);
			UIShowStats.Message31a:SetText( value );

			posy = posy + 35;

			local CappedLabel=Turbine.UI.Label();
			CappedLabel:SetParent(UIShowStats);
			CappedLabel:SetSize(400,20);
			CappedLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
			CappedLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			CappedLabel:SetForeColor(Turbine.UI.Color( 1, 1, 0 ));
			CappedLabel:SetText(T[ "PluginStats35" ]);
			CappedLabel:SetPosition(UIShowStats:GetWidth()/2 - 200, posy);
        
			posy = posy + 20;

			local T2Label=Turbine.UI.Label();
			T2Label:SetParent(UIShowStats);
			T2Label:SetSize(400,20);
			T2Label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
			T2Label:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			T2Label:SetForeColor(Turbine.UI.Color( 1, 0.7, 0 ));
			T2Label:SetText(T[ "PluginStats36" ]);
			T2Label:SetPosition(UIShowStats:GetWidth()/2 - 200, posy);
        
			posy = posy + 20;

			local T2NLabel=Turbine.UI.Label();
			T2NLabel:SetParent(UIShowStats);
			T2NLabel:SetSize(400,20);
			T2NLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
			T2NLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			T2NLabel:SetForeColor(Turbine.UI.Color.Red);
			T2NLabel:SetText(T[ "PluginStats37" ]);
			T2NLabel:SetPosition(UIShowStats:GetWidth()/2 - 200, posy);
        
			posy = posy + 20;

			local T3NLabel=Turbine.UI.Label();
			T3NLabel:SetParent(UIShowStats);
			T3NLabel:SetSize(400,20);
			T3NLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
			T3NLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			T3NLabel:SetForeColor(Turbine.UI.Color( 1, 0, 1 ));
			T3NLabel:SetText(T[ "PluginStats38" ]);
			T3NLabel:SetPosition(UIShowStats:GetWidth()/2 - 200, posy);
		else
			UIShowStats.MessageNon=Turbine.UI.Label(); 
			UIShowStats.MessageNon:SetParent(UIShowStats); 
			UIShowStats.MessageNon:SetSize(500,200); 
			UIShowStats.MessageNon:SetPosition(UIShowStats:GetWidth()/2 - 250, UIShowStats:GetHeight()/2 - 100 ); 
			UIShowStats.MessageNon:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageNon:SetFont(Turbine.UI.Lotro.Font.TrajanProBold30);
			UIShowStats.MessageNon:SetText(T[ "PluginStats10" ]); 
		end
	else -- monsterplay
		if(PlayerDatas[namePlayerToshow].moral ~= nil and
			PlayerDatas[namePlayerToshow].power ~= nil)then
			UIShowStats.Message=Turbine.UI.Label(); 
			UIShowStats.Message:SetParent(UIShowStats); 
			UIShowStats.Message:SetSize(150,10); 
			UIShowStats.Message:SetPosition(UIShowStats:GetWidth()/2 - 75, UIShowStats:GetHeight() - 20); 
			UIShowStats.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.Message:SetText(T[ "PluginText" ]); 
			UIShowStats:SetZOrder(10);
			UIShowStats:SetWantsKeyEvents(true);
			UIShowStats:SetVisible(false);

			local posy = 50 ;
			local posx = 50;

			-- moral
			UIShowStatsLabIcon=Turbine.UI.Label(); 
			UIShowStatsLabIcon:SetParent(UIShowStats); 
			UIShowStatsLabIcon:SetSize(24, 25); 
			UIShowStatsLabIcon:SetPosition(posx - 10, posy ); 
			UIShowStatsLabIcon:SetBackground(0x410DCFCE); -- moral
			UIShowStatsLabIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			UIShowStats.Message14a=Turbine.UI.Label(); 
			UIShowStats.Message14a:SetParent(UIShowStats); 
			UIShowStats.Message14a:SetSize(300,20); 
			UIShowStats.Message14a:SetPosition(posx + 30, posy - 2); 
			UIShowStats.Message14a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message14a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			PlayerDatas[namePlayerToshow].moral = PlayerDatas[namePlayerToshow].maxMoral;
			if(namePlayerToshow == PlayerName)then
				PlayerDatas[namePlayerToshow].moral = Player:GetMorale()-- power
			else
				PlayerDatas[namePlayerToshow].moral = PlayerDatas[namePlayerToshow].maxMoral-- power
			end
			UIShowStats.Message14a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].moral)) .. " / " .. comma_value(Round(PlayerDatas[namePlayerToshow].maxMoral))); 
			UIShowStats.Message14a:SetForeColor(Turbine.UI.Color( 0.33, 0.66, 0.33 )); -- nice green

			posy = posy + 30;
			-- power
			UIShowStatsLabIcon=Turbine.UI.Label(); 
			UIShowStatsLabIcon:SetParent(UIShowStats); 
			UIShowStatsLabIcon:SetSize(24, 25); 
			UIShowStatsLabIcon:SetPosition(posx - 10, posy ); 
			UIShowStatsLabIcon:SetBackground(0x410DCFCF); -- power
			UIShowStatsLabIcon:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			UIShowStats.Message12a=Turbine.UI.Label(); 
			UIShowStats.Message12a:SetParent(UIShowStats); 
			UIShowStats.Message12a:SetSize(300,20); 
			UIShowStats.Message12a:SetPosition(posx + 30, posy - 2); 
			UIShowStats.Message12a:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
			UIShowStats.Message12a:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			if(namePlayerToshow == PlayerName)then
				PlayerDatas[namePlayerToshow].power = Player:GetPower()-- power
			else
				PlayerDatas[namePlayerToshow].power = PlayerDatas[namePlayerToshow].maxPower-- power
			end
			UIShowStats.Message12a:SetForeColor(Turbine.UI.Color( 0, 0.66, 0.75)); -- nice blue
			UIShowStats.Message12a:SetText(comma_value(Round(PlayerDatas[namePlayerToshow].power)) .. " / " .. comma_value(Round(PlayerDatas[namePlayerToshow].maxPower))); 
		else
			UIShowStats.MessageNon=Turbine.UI.Label(); 
			UIShowStats.MessageNon:SetParent(UIShowStats); 
			UIShowStats.MessageNon:SetSize(300,50); 
			UIShowStats.MessageNon:SetPosition(UIShowStats:GetWidth()/2 - 150, UIShowStats:GetHeight()/2 - 20); 
			UIShowStats.MessageNon:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			UIShowStats.MessageNon:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			UIShowStats.MessageNon:SetText(T[ "PluginStats10" ]); 
		end
	end

	ClosingTheWindowStats();

	EscapeKeyHandlerForWindows(UIShowStats, settings["isShowStatsVisible"]["isShowStatsVisible"]);
end