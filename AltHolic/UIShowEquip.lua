------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------

centerLabelCash2 = {};
centerLabelCash3 = {};
centerLabelCash4 = {};
centerLabelCash5 = {};
centerLabelCash6 = {};
centerLabelCash7 = {};
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowEquip(namePlayerToshow, alignement)	
	UIShowEquip=Turbine.UI.Lotro.GoldWindow(); 
	UIShowEquip:SetSize(600,500); 
	UIShowEquip:SetText(T[ "PluginEquipement1" ] .. tostring(namePlayerToshow)); 
	UIShowEquip:SetPosition((Turbine.UI.Display:GetWidth()-UIShowEquip:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowEquip:GetHeight())/2); 

	if(PlayerDatas[namePlayerToshow].align == 1)then
		UIShowEquip.Message=Turbine.UI.Label(); 
		UIShowEquip.Message:SetParent(UIShowEquip); 
		UIShowEquip.Message:SetSize(150,10); 
		UIShowEquip.Message:SetPosition(UIShowEquip:GetWidth()/2 - 75, UIShowEquip:GetHeight() - 20); 
		UIShowEquip.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		UIShowEquip.Message:SetText(T[ "PluginText" ]); 
		UIShowEquip:SetZOrder(10);
		UIShowEquip:SetWantsKeyEvents(true);
		UIShowEquip:SetVisible(false);

			DurabilitySlots = { 
				0x41007eed, -- head
				0x41007eee, -- shoulder
				0x41007ee9, -- back
				0x41007ef0, -- chest
				0x41007ef2, -- gant
				0x41007ef1, -- legs
				0x41007ef5, -- shoes
				0x41007eec, -- distance
				0x41007efb, -- outils 
				0x410e8680, -- class
				0x41007ef6, -- oreille droite
				0x41007ef7, -- oreille gauche
				0x41007eef, -- collier
				0x41007ef8, -- bracelet droite
				0x41007ef9, -- brcelet gauche
				0x41007ef3, -- bague droite
				0x41007ef4, -- bague gauche
				0x41007efa, -- pocket
				0x41007eea, -- weapon
				0x41007eeb -- shield
			};

			Button = { };

			local posy = 40 ;
			local posx = 300;
			
			for j=1, 20 do
				Button[j] = Turbine.UI.Label(); 
				Button[j]:SetParent( UIShowEquip );
				Button[j]:SetPosition(posx-1, posy-1);
				Button[j]:SetSize( 42, 42 );
				Button[j]:SetVisible(true);
				Button[j]:SetBackground(DurabilitySlots[j]);
				Button[j]:SetZOrder(-1);

				posy = posy + 42;
				if(j == 10)then
					posx = 20;
					posy = 40;
				end
			end

			local playerLvl = PlayerDatas[namePlayerToshow].lvl;
			nbrLines = 0;
			local val = 1;
			for i in pairs(PlayerEquipement[namePlayerToshow]) do
				if(i == "Head")then posx = 305 ; posy = 45 ; val = 1;end
				if(i == "Shoulder")then posx = 305 ; posy = 87 ; val = 6;end
				if(i == "Back")then posx = 305 ; posy = 129 ; val = 7;end
				if(i == "Chest")then posx = 305 ; posy = 171 ; val = 2;end
				if(i == "Gloves")then posx = 305 ; posy = 213 ; val = 4;end
				if(i == "Legs")then posx = 305 ; posy = 255 ; val = 3;end
				if(i == "Boots")then posx = 305 ; posy = 297 ; val = 5;end
				if(i == "RangedWeapon")then posx = 305 ; posy = 339 ; val = 18;end
				if(i == "CraftTool")then posx = 305 ; posy = 381 ; val = 19;end
				if(i == "ClassE")then posx = 305 ; posy = 423 ; val = 20;end

				if(i == "Earring1")then posx = 25 ; posy = 45 ; val = 13;end
				if(i == "Earring2")then posx = 25 ; posy = 87 ; val = 14;end
				if(i == "Necklace")then posx = 25 ; posy = 129 ; val = 10;end
				if(i == "Bracelet1")then posx = 25 ; posy = 171 ; val = 8;end
				if(i == "Bracelet2")then posx = 25 ; posy = 213 ; val = 9;end
				if(i == "Ring1")then posx = 25 ; posy = 255 ; val = 11;end
				if(i == "Ring2")then posx = 25 ; posy = 297 ; val = 12;end
				if(i == "Pocket")then posx = 25 ; posy = 339 ; val = 15;end
				if(i == "PrimaryWeapon")then posx = 25 ; posy = 381 ; val = 16;end
				if(i == "Shield")then posx = 25 ; posy = 423 ; val = 17; end

				if(PlayerEquipement[namePlayerToshow][i].N ~= nil)then

					itemTmp = Turbine.UI.Control();
					itemTmp:SetParent( UIShowEquip );
					itemTmp:SetPosition(posx, posy);
					itemTmp:SetSize( 32, 32 );
					itemTmp:SetBackground(PlayerEquipement[namePlayerToshow][i].Q);
					itemTmp:SetBlendMode( Turbine.UI.BlendMode.Overlay );
					itemTmp:SetVisible( true );
					itemTmp:SetMouseVisible( true );

					itemTmp1 = Turbine.UI.Control();
					itemTmp1:SetParent( UIShowEquip );
					itemTmp1:SetPosition(posx, posy);
					itemTmp1:SetSize( 32, 32 );
					itemTmp1:SetBackground(PlayerEquipement[namePlayerToshow][i].B);
					itemTmp1:SetBlendMode( Turbine.UI.BlendMode.Overlay );
					itemTmp1:SetVisible( true );

					itemTmp3 = Turbine.UI.Control();
					itemTmp3:SetParent( UIShowEquip );
					itemTmp3:SetPosition(posx, posy);
					itemTmp3:SetSize( 32, 32 );
					itemTmp3:SetBackground(PlayerEquipement[namePlayerToshow][i].S);
					itemTmp3:SetBlendMode( Turbine.UI.BlendMode.Overlay );
					itemTmp3:SetVisible( true );

					itemTmp4 = Turbine.UI.Control();
					itemTmp4:SetParent( UIShowEquip );
					itemTmp4:SetPosition(posx, posy);
					itemTmp4:SetSize( 32, 32 );
					itemTmp4:SetBackground(PlayerEquipement[namePlayerToshow][i].I);
					itemTmp4:SetBlendMode( Turbine.UI.BlendMode.Overlay );
					itemTmp4:SetVisible( true );
					itemTmp4:SetMouseVisible(true);

					if(PlayerName == namePlayerToshow and PlayerEquip:GetItem(val) ~= nil)then
						local selectedRecipeItem = OfflineItemInfoControl();
						itemTmp4.selectedRecipeItem = selectedRecipeItem;
						selectedRecipeItem:SetParent(UIShowEquip);
						selectedRecipeItem:SetPosition(posx - 2, posy - 2);
						itemTmp4.selectedRecipeItem:SetItem(i, namePlayerToshow, PlayerEquip:GetItem(val):GetItemInfo(), PlayerEquipement[namePlayerToshow][i].I, PlayerEquipement[namePlayerToshow][i].B, 1);
						--selectedRecipeItem:SetBackColor( Turbine.UI.Color.Lime );
					else
						DisplayLabelEquipment(i,  posx, posy, namePlayerToshow, itemTmp4, PlayerEquipement[namePlayerToshow][i])
					end

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

					UIShowEquip.Message6=Turbine.UI.Label(); 
					UIShowEquip.Message6:SetParent(UIShowEquip); 
					UIShowEquip.Message6:SetSize(232, 40); 
					UIShowEquip.Message6:SetPosition(posx + 40, posy -2); 
					UIShowEquip.Message6:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
					UIShowEquip.Message6:SetText(PlayerEquipement[namePlayerToshow][i].N); 

					if(settings["displayDurabilityColor"]["value"] == true)then	
						if(wareSPoints == -1 or wareSPoints == 100)then
							UIShowEquip.Message6:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 )); -- grey
							UIShowEquip.Message6:SetForeColor(Turbine.UI.Color.White);
						elseif(wareSPoints == 0)then
							UIShowEquip.Message6:SetBackColor(Turbine.UI.Color( 0.9, 0.9, 0.1, 0 )); -- red
							UIShowEquip.Message6:SetForeColor(Turbine.UI.Color.White);
						elseif(wareSPoints == 20)then
							UIShowEquip.Message6:SetBackColor(Turbine.UI.Color( 0.9, 1, 0.7, 0 )); -- orange
							UIShowEquip.Message6:SetForeColor(Turbine.UI.Color.Black);
						elseif(wareSPoints == 99)then
							UIShowEquip.Message6:SetBackColor(Turbine.UI.Color( 0.9, 1, 1, 0 )); -- Yellow
							UIShowEquip.Message6:SetForeColor(Turbine.UI.Color.Black);
						end
					else
						UIShowEquip.Message6:SetBackColor(Turbine.UI.Color( 0.9, 0.3, 0.3, 0.3 )); -- grey
						UIShowEquip.Message6:SetForeColor(Turbine.UI.Color.White);
					end
					UIShowEquip.Message6:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
					UIShowEquip.Message6:SetMarkupEnabled(true);
					UIShowEquip.Message6:SetZOrder(-1);
					-------------------------------------------------------------------------
					-- show to score of the object
					-- took this code from TitanBar Habna plugin
					-------------------------------------------------------------------------
					Wq = 4; -- weight Quality
					Wd = 1; -- weight Durability

					local Durability = 0;
					local Quality = 0;

					if(PlayerEquipement[namePlayerToshow][i].QA ~= nil)then
						Quality = 10*((6-PlayerEquipement[namePlayerToshow][i].QA)%6);
					end

					if(PlayerEquipement[namePlayerToshow][i].DU ~= nil)then
						Durability = PlayerEquipement[namePlayerToshow][i].DU;
					else
						Durability = 0;
					end

					if Durability ~= 0 then
						Durability = 10*((Durability%7)+1);
					end

					local score = math.floor((Wq*Quality*7 + Wd*Durability*5)/(3.5*(Wq + Wd)))
					-------------------------------------------------------------------------


					UIShowEquip.Message=Turbine.UI.Label(); 
					UIShowEquip.Message:SetParent(UIShowEquip.Message6); 
					UIShowEquip.Message:SetSize(20, 10); 
					UIShowEquip.Message:SetPosition(UIShowEquip.Message6:GetWidth()- 20, UIShowEquip.Message6:GetHeight() - 10); 
					UIShowEquip.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
					UIShowEquip.Message:SetText(score); 
					UIShowEquip.Message:SetBackColor(Turbine.UI.Color( 0.9, 0.15, 0.15, 0.15 ));
					UIShowEquip.Message:SetMarkupEnabled(true);


					-- display the level
					UIShowEquip.MessageLvl=Turbine.UI.Label(); 
					UIShowEquip.MessageLvl:SetParent(UIShowEquip.Message6); 
					if(PlayerEquipement[namePlayerToshow][i].lvl ~= nil and 
							PlayerEquipement[namePlayerToshow][i].lvl ~= 0 and 
							PlayerEquipement[namePlayerToshow][i].lvl ~= "")then
							if(tonumber(PlayerEquipement[namePlayerToshow][i].lvl) >= 100)then
								UIShowEquip.MessageLvl:SetSize(30, 10); 
								UIShowEquip.MessageLvl:SetPosition(UIShowEquip.Message6:GetWidth() - 52, UIShowEquip.Message6:GetHeight() - 10);
							else
								UIShowEquip.MessageLvl:SetSize(20, 10); 
								UIShowEquip.MessageLvl:SetPosition(UIShowEquip.Message6:GetWidth() - 42, UIShowEquip.Message6:GetHeight() - 10);
							end	
					end 
					UIShowEquip.MessageLvl:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
					
					if(PlayerEquipement[namePlayerToshow][i].lvl ~= nil and 
					PlayerEquipement[namePlayerToshow][i].lvl ~= 0 and 
					PlayerEquipement[namePlayerToshow][i].lvl ~= "")then
						UIShowEquip.MessageLvl:SetText(tostring(PlayerEquipement[namePlayerToshow][i].lvl) );
						UIShowEquip.MessageLvl:SetVisible(true);
					else
						UIShowEquip.MessageLvl:SetVisible(false);
					end
					UIShowEquip.MessageLvl:SetBackColor(Turbine.UI.Color( 0.9, 0.15, 0.15, 0.15 ));
					UIShowEquip.MessageLvl:SetMarkupEnabled(true);

					nbrLines = nbrLines + 1;
				else
					UIShowEquip.Message=Turbine.UI.Label(); 
					UIShowEquip.Message:SetParent(UIShowEquip); 
					UIShowEquip.Message:SetSize(230, 38); 
					UIShowEquip.Message:SetPosition(posx + 50, posy); 
					UIShowEquip.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
					UIShowEquip.Message:SetText(T[ "PluginEquipement2" ]); 
					UIShowEquip.Message:SetForeColor(Turbine.UI.Color.Red);
				end
			end
	else
		UIShowEquip.Message2 =Turbine.UI.Label(); 
		UIShowEquip.Message2:SetParent(UIShowEquip); 
		UIShowEquip.Message2:SetSize(400,50); 
		UIShowEquip.Message2:SetPosition(UIShowEquip:GetWidth()/2 - 200, UIShowEquip:GetHeight() - 50); 
		UIShowEquip.Message2:SetFont(Turbine.UI.Lotro.Font.TrajanProBold36);
		UIShowEquip.Message2:SetForeColor(Turbine.UI.Color.Gold);
		UIShowEquip.Message2:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		UIShowEquip.Message2:SetText(T[ "PluginISeeYou" ]); 
		UIShowEquip:SetZOrder(1000);
		UIShowEquip:SetVisible(false);

		SauronWindow = Turbine.UI.Extensions.SimpleWindow();
		SauronWindow:SetParent( UIShowEquip );
		SauronWindow:SetPosition(UIShowEquip:GetWidth()/2 - 280, UIShowEquip:GetHeight()/2 - 220);
		SauronWindow:SetSize( 560, 435 );
		SauronWindow:SetBackground(ResourcePath .. "Sauron.tga");
		SauronWindow:SetZOrder(12);
		SauronWindow:SetVisible(true);
	end

	ClosingTheWindowEquipment();
	
	EscapeKeyHandlerForWindows(UIShowEquip, settings["isShowEquipmentVisible"]["isShowEquipmentVisible"]);
end