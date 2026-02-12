------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
function CreateUIShowCrafting(namePlayerToshow)	

	if(namePlayerToshow == PlayerName)then
		GetDataForProfessions();
	end

	UIShowCrafting=Turbine.UI.Lotro.GoldWindow(); 
	if(settings["nameAccount"]["account1"]["name"] ~= "")then
		UIShowCrafting:SetSize(420, (settings["nameAccount"]["account1"]["nbrAlt"] * 20) + 320); 
	else
		UIShowCrafting:SetSize(420, 420); 
	end
	UIShowCrafting:SetText( "Crafting level for " .. namePlayerToshow ); 
	UIShowCrafting:SetPosition((Turbine.UI.Display:GetWidth()-UIShowCrafting:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowCrafting:GetHeight())/2); 

	UIShowCrafting.Message=Turbine.UI.Label(); 
	UIShowCrafting.Message:SetParent(UIShowCrafting); 
	UIShowCrafting.Message:SetSize(150,10); 
	UIShowCrafting.Message:SetPosition(UIShowCrafting:GetWidth()/2 - 75, UIShowCrafting:GetHeight() - 20); 
	UIShowCrafting.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowCrafting.Message:SetText(T[ "PluginText" ]); 
	UIShowCrafting:SetZOrder(10);
	UIShowCrafting:SetWantsKeyEvents(true);
	UIShowCrafting:SetVisible(false);

	local posyStart = 60;
	local posxStart = 80;

	if(PlayerProfessions[namePlayerToshow] ~= nil)then
			for x=1, 3 do
				ButtonPlusVoc[namePlayerToshow] = Turbine.UI.Extensions.SimpleWindow();
	
				centerLabelProf1[namePlayerToshow] = Turbine.UI.Label();
				centerLabelProf1[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelProf1[namePlayerToshow]:SetPosition( posxStart - 30, posyStart );
				centerLabelProf1[namePlayerToshow]:SetSize( 200, 30  );
				centerLabelProf1[namePlayerToshow]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold24);
				centerLabelProf1[namePlayerToshow]:SetText( PlayerProfessions[namePlayerToshow].Name[x] );
				centerLabelProf1[namePlayerToshow]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
				centerLabelProf1[namePlayerToshow]:SetZOrder(21);
				--centerLabelProf1[i]:SetForeColor(Turbine.UI.Color.Gold);

				centerLabelProfIcon[namePlayerToshow] = Turbine.UI.Label();
				centerLabelProfIcon[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelProfIcon[namePlayerToshow]:SetPosition( posxStart - 70, posyStart );
				centerLabelProfIcon[namePlayerToshow]:SetSize( 32, 32  );
				centerLabelProfIcon[namePlayerToshow]:SetZOrder(21);

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

				if(PlayerDatas[namePlayerToshow].voc == 1)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[1] ); -- explorateur
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[9] ); -- explorateur
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[2] ); -- explorateur
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 2)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[4] ); -- joaillier
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshowi]:SetBackground( ResourcePath .. iconsProf[2] ); -- joaillier
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[7] ); -- joaillier
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 3)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[4] ); -- franc-tenancier
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[9] ); -- franc-tenancier
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[5] ); -- franc-tenancier
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 4)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[6] ); -- historien
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[5] ); -- historien
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[3] ); -- historien
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 5)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[1] ); -- armurier
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[10] ); -- armurier
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[3] ); -- armurier
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 6)then
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[1] ); -- bucheron
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[10] ); -- bucheron
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[5] ); -- bucheron
					end
				end
				if(PlayerDatas[namePlayerToshow].voc == 7)then
					centerLabelB21:SetBackground(0x4110DB15); -- ferronier
					if(x == 1)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[8] ); -- ferronier
					elseif(x == 2)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[9] ); -- ferronier
					elseif(x == 3)then
						centerLabelProfIcon[namePlayerToshow]:SetBackground( ResourcePath .. iconsProf[2] ); -- ferronier
					end
				end

				centerLabelTier1[namePlayerToshow] = Turbine.UI.Label();
				centerLabelTier1[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelTier1[namePlayerToshow]:SetPosition( posxStart + 25, posyStart + 25 );
				centerLabelTier1[namePlayerToshow]:SetSize( 200, 30  );
				centerLabelTier1[namePlayerToshow]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
				centerLabelTier1[namePlayerToshow]:SetText( PlayerProfessions[namePlayerToshow].CurrentLvl[x] );
				centerLabelTier1[namePlayerToshow]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
				centerLabelTier1[namePlayerToshow]:SetZOrder(21);
				centerLabelTier1[namePlayerToshow]:SetForeColor(Turbine.UI.Color( 0.8, 0.4, 0.2));

				centerLabelTier1[namePlayerToshow] = Turbine.UI.Label();
				centerLabelTier1[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelTier1[namePlayerToshow]:SetPosition( posxStart - 15, posyStart + 32 );
				centerLabelTier1[namePlayerToshow]:SetSize( 27, 17  );
				centerLabelTier1[namePlayerToshow]:SetZOrder(21);
				centerLabelTier1[namePlayerToshow]:SetBackground( ResourcePath .. "icon_craft_proficient.tga" );
				centerLabelTier1[namePlayerToshow]:SetBlendMode( Turbine.UI.BlendMode.Overlay );


				centerLabelTier2[namePlayerToshow] = Turbine.UI.Label();
				centerLabelTier2[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelTier2[namePlayerToshow]:SetPosition( posxStart + 25, posyStart + 45 );
				centerLabelTier2[namePlayerToshow]:SetSize( 200, 30  );
				centerLabelTier2[namePlayerToshow]:SetFont(Turbine.UI.Lotro.Font.TrajanProBold16);
				centerLabelTier2[namePlayerToshow]:SetText( PlayerProfessions[namePlayerToshow].currentMastery[x] );
				centerLabelTier2[namePlayerToshow]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
				centerLabelTier2[namePlayerToshow]:SetZOrder(21);
				centerLabelTier2[namePlayerToshow]:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

				centerLabelTier2[namePlayerToshow] = Turbine.UI.Label();
				centerLabelTier2[namePlayerToshow]:SetParent(UIShowCrafting);
				centerLabelTier2[namePlayerToshow]:SetPosition( posxStart - 15, posyStart + 52 );
				centerLabelTier2[namePlayerToshow]:SetSize( 27, 17  );
				centerLabelTier2[namePlayerToshow]:SetZOrder(21);
				centerLabelTier2[namePlayerToshow]:SetBackground( ResourcePath .. "icon_craft_master.tga" );
				centerLabelTier2[namePlayerToshow]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

				posyStart = posyStart + 80;
			end
		else
			centerLabelProf1[namePlayerToshow] = Turbine.UI.Label();
			centerLabelProf1[namePlayerToshow]:SetParent(UIShowCrafting);
			centerLabelProf1[namePlayerToshow]:SetPosition( 25, 100 );
			centerLabelProf1[namePlayerToshow]:SetSize( 250, 100  );
			centerLabelProf1[namePlayerToshow]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			centerLabelProf1[namePlayerToshow]:SetText( T[ "PluginStats10" ] );
			centerLabelProf1[namePlayerToshow]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelProf1[namePlayerToshow]:SetZOrder(21);
		end

end