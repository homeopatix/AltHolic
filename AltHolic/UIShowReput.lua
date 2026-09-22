------------------------------------------------------------------------------------------
-- UIshowReput file
-- Written by Homeopatix
-- 3 mars 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Shared reputation metadata/helpers
------------------------------------------------------------------------------------------
local GUILD_REPUTATION_PROFESSIONS = {
    [21] = {"jeweller", "jeweler"},
    [22] = {"cook"},
    [23] = {"scholar", "historian"},
    [24] = {"tailor", "taillor"},
    [25] = {"woodworker", "carpenter"},
    [26] = {"weaponsmith", "weaponcrafter"},
    [27] = {"metalsmith"},
};

local REPUTATION_VALUE_DEFAULT = {10000,10000,0,10000,20000,25000,30000,45000,60000,90000,200000};
local REPUTATION_VALUE_LEVELS = {
    [64]  = {10000,20000,25000,30000},
    [69]  = {10000,20000,20000,1},
    [70]  = {10000,15000,20000,20000,20000,20000,30000,1},
    [71]  = {4000,6000,8000,10000,12000,14000,16000,18000,20000,1},
    [79]  = {0,10000,20000,25000,30000,45000},
    [100] = {1500,4500,9000,13500,18000},
    [102] = {15000,20000,20000,20000,20000,30000,1},
    [106] = {0,2500,5000,7500,10000,15000},
};

local function GetReputationThresholds(index)
    return REPUTATION_VALUE_LEVELS[index] or REPUTATION_VALUE_DEFAULT;
end

local function CharacterHasProfession(playerName, aliases)
    if aliases == nil then return true; end
    local professions = GetSavedProfessions(playerName);
    for _, profession in ipairs(professions) do
        local name = string.lower(tostring(profession.Name or profession.Key or ""));
        for _, alias in ipairs(aliases) do
            if name == alias or string.find(name, alias, 1, true) ~= nil then
                return true;
            end
        end
    end
    return false;
end

local function ShouldDisplayReputation(playerName, index)
    return CharacterHasProfession(playerName, GUILD_REPUTATION_PROFESSIONS[index]);
end

local function GetReputationFactionCount(playerName)
	local count = 0;
	if PlayerReput[playerName] ~= nil then
		for _ in pairs(PlayerReput[playerName]) do count = count + 1; end
	end
	return count;
end

------------------------------------------------------------------------------------------
-- create the repuattion window
------------------------------------------------------------------------------------------
function CreateUIShowReput(NamePlayerToShow, ShowReput)	
	local listbox;
	local listItem;
	local vscrollListBox;
	local buttonShowReput;
	local centerLabelShowReput;
	local showReputButtonLabel;
	local centerLabelBLabelShowReput;
	local ReputWindowButton;
	local LabelNameFactionNoCo;
	local windowWidth = 420;
	local windowHeight = 870;

	if(ShowReput == nil)then
		settings["ShowHideReput"]["value"] = false;
	else
		settings["ShowHideReput"]["value"] = ShowReput;
	end

	if(Turbine.UI.Display:GetHeight() < 870)then
	       	windowHeight = Turbine.UI.Display:GetHeight() - 150;
	end
	
	UIShowReput=Turbine.UI.Lotro.GoldWindow(); 
	UIShowReput:SetSize(windowWidth, windowHeight); 
	UIShowReput:SetText( "Reputation for " ..  NamePlayerToShow); 
	UIShowReput:SetPosition((Turbine.UI.Display:GetWidth()-UIShowReput:GetWidth())/2,(Turbine.UI.Display:GetHeight()-UIShowReput:GetHeight())/2); 


	listbox = Turbine.UI.ListBox();
    listbox:SetParent( UIShowReput );
    --listbox:SetBackColor( Turbine.UI.Color.Red );
	listbox:SetSize(windowWidth - 45, windowHeight - 140);
	listbox:SetPosition(20, 70);
	listbox:IsMouseVisible(true);
	listbox:SetZOrder(20);


	UIShowReput.Message=Turbine.UI.Label(); 
	UIShowReput.Message:SetParent(UIShowReput); 
	UIShowReput.Message:SetSize(150,10); 
	UIShowReput.Message:SetPosition(UIShowReput:GetWidth()/2 - 75, UIShowReput:GetHeight() - 20); 
	UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	UIShowReput.Message:SetText(T[ "PluginText" ]); 
	UIShowReput:SetZOrder(10);
	UIShowReput:SetVisible(false);
	UIShowReput:SetWantsKeyEvents(true);
	
	DisplayHelpButton(UIShowReput, windowWidth, 3);

	------------------------------------------------------------------------------------------
	--- button hide or show
	------------------------------------------------------------------------------------------
	buttonShowReput = Turbine.UI.Extensions.SimpleWindow();
	buttonShowReput:SetParent( UIShowReput );
	buttonShowReput:SetPosition(25, 35);
	buttonShowReput:SetSize( 16, 16 );
	buttonShowReput:SetVisible(true);
	buttonShowReput:SetMouseVisible(true);

	centerLabelShowReput = Turbine.UI.Label();
	centerLabelShowReput:SetParent(buttonShowReput);
	centerLabelShowReput:SetPosition( 0, 0 );
	centerLabelShowReput:SetSize( 16, 16  );
	if(settings["ShowHideReput"]["value"] == false)then
		centerLabelShowReput:SetBackground(0x41007E27); -- plus
	else
		centerLabelShowReput:SetBackground(0x41007E26); -- minus
	end
	centerLabelShowReput:SetZOrder(-1);
	centerLabelShowReput:SetMouseVisible(false);

	showReputButtonLabel = Turbine.UI.Extensions.SimpleWindow();
	showReputButtonLabel:SetParent( UIShowReput );
	showReputButtonLabel:SetPosition (50, 20);
	showReputButtonLabel:SetSize( 180, 30 );
	showReputButtonLabel:SetZOrder(10000);
	showReputButtonLabel:SetVisible(false);
	showReputButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

	centerLabelBLabelShowReput = Turbine.UI.Label();
	centerLabelBLabelShowReput:SetParent(showReputButtonLabel);
	centerLabelBLabelShowReput:SetPosition( 2, 2 );
	centerLabelBLabelShowReput:SetSize( 176, 26  );
	centerLabelBLabelShowReput:SetText( "Hide or show unknow reput" );
	centerLabelBLabelShowReput:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabelBLabelShowReput:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
	centerLabelBLabelShowReput:SetZOrder(-1);

	buttonShowReput.MouseEnter = function()
		showReputButtonLabel:SetVisible(true);
	end

	buttonShowReput.MouseLeave = function()
		showReputButtonLabel:SetVisible(false);
	end

	buttonShowReput.MouseClick = function(sender, args)
		if(settings["ShowHideReput"]["value"] == true)then
			settings["ShowHideReput"]["value"] = false;
		else
			settings["ShowHideReput"]["value"] = true;
		end
		UIShowReput:SetVisible(false);
		CreateUIShowReput(NamePlayerToShow, settings["ShowHideReput"]["value"]);
		UIShowReput:SetVisible(true);
	end
	------------------------------------------------------------------------------------------
	--- display of the reput
	------------------------------------------------------------------------------------------
	--posx = 10;
	--posy = 20;

	local posx = 10;
	local posy = 5;

	if( not PlayerReput[NamePlayerToShow])then
		LabelNameFactionNoCo=Turbine.UI.Label(); 
		LabelNameFactionNoCo:SetParent(UIShowReput); 
		LabelNameFactionNoCo:SetSize(350, 100); 
		LabelNameFactionNoCo:SetPosition(25, 350); 
		LabelNameFactionNoCo:SetText(T[ "PluginStats10" ]); 
		LabelNameFactionNoCo:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		LabelNameFactionNoCo:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		LabelNameFactionNoCo:SetForeColor(Turbine.UI.Color.White);
    else
		local LabelNameFaction = {};
		local displayedCount = 0;

		for i=1, GetReputationFactionCount(NamePlayerToShow) do 

			listItem = Turbine.UI.Control();
			listItem:SetSize( windowWidth - 45, 60 );
			listItem:SetMouseVisible(true);

			local shouldDisplayRow = true;
			if PlayerDatas[NamePlayerToShow].align == 1 and GUILD_REPUTATION_PROFESSIONS[i] ~= nil then
				shouldDisplayRow = ShouldDisplayReputation(NamePlayerToShow, i);
			end
			----
				-- debug purpose
				--if(i == 22)then
					--Write(tostring(ShowReput));
					--Write(tostring(tonumber(PlayerReput[NamePlayerToShow]["Reput" .. i].value)));
				--end

				if shouldDisplayRow then
					if(ShowReput == true or tonumber(PlayerReput[NamePlayerToShow]["Reput" .. i].value) ~= 0 or
						tonumber(PlayerReput[NamePlayerToShow]["Reput" .. i].position) == 9 or tonumber(PlayerReput[NamePlayerToShow]["Reput" .. i].position) > 0)then
						local lvlMax = false;
						local colorReput = "";
						------------------------------------------------------------------------------------------
						--- display the name
						------------------------------------------------------------------------------------------
						LabelNameFaction[i]=Turbine.UI.Label(); 
						LabelNameFaction[i]:SetParent(listItem); 
						LabelNameFaction[i]:SetSize(350, 30); 
						LabelNameFaction[i]:SetPosition(posx, posy); 
						LabelNameFaction[i]:SetText(T["reputname" .. i]); 
						LabelNameFaction[i]:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
						LabelNameFaction[i]:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
						LabelNameFaction[i]:SetForeColor(Turbine.UI.Color.Gold);
						------------------------------------------------------------------------------------------
						--- mouse click handler for editing faction
						------------------------------------------------------------------------------------------
						if(NamePlayerToShow == PlayerName)then
							LabelNameFaction[i].MouseClick = function(sender, args)
								CreateAddNewWindowReput(T["reputname" .. i], NamePlayerToShow, i);
								AltHolicAddnewWindowReput:SetVisible(true);
							end
						end

						posy = posy + 15;

						------------------------------------------------------------------------------------------
						--- reputation calculator for display
						------------------------------------------------------------------------------------------
						local reputVal = 0;
						local nextValReput = 0;
						local percentReput = 0;
						local reputationValueLevel = GetReputationThresholds(i);

						-- Historical factions use shifted positions in saved data. Preserve
						-- the established correction, but keep the threshold metadata shared.
						if i == 70 and PlayerReput[NamePlayerToShow]["Reput" .. i].position >= 7 then
							PlayerReput[NamePlayerToShow]["Reput" .. i].position = PlayerReput[NamePlayerToShow]["Reput" .. i].position - 3;
						elseif i == 102 and PlayerReput[NamePlayerToShow]["Reput" .. i].position >= 7 then
							PlayerReput[NamePlayerToShow]["Reput" .. i].position = PlayerReput[NamePlayerToShow]["Reput" .. i].position - 1;
						end


						if(PlayerReput[NamePlayerToShow]["Reput" .. i].position ~= nil)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position >= 3)then
								if(i == 100)then
									nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position];
									colorReput = ResourcePath .. "BlueBars.tga";
								else
									nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position + PlayerReput[NamePlayerToShow]["Reput" .. i].genre];
									colorReput = ResourcePath .. "BlueBars.tga";
								end
							elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].position == 2)then
								nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position];
								-- debug chasse au poulet
								if(i == 64 or i == 100)then
									colorReput = ResourcePath .. "BlueBars.tga";
								else
									colorReput = ResourcePath .. "PurpleBars.tga";
								end
							else
							-- debug The Gabil'akk�
								if(i == 100)then
									nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position]
									colorReput = ResourcePath .. "BlueBars.tga";
								-- debug The Gabil'akk�
								elseif(i == 79)then
									nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position + PlayerReput[NamePlayerToShow]["Reput" .. i].genre - 4]
									colorReput = ResourcePath .. "BlueBars.tga";
								else
									nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position];
									colorReput = ResourcePath .. "RedBars.tga";
								end
							end
						else
							PlayerReput[NamePlayerToShow]["Reput" .. i].position = 0;
						end


						if( PlayerReput[NamePlayerToShow]["Reput" .. i].value == 
						reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position + PlayerReput[NamePlayerToShow]["Reput" .. i].genre])then
							lvlMax = true;
							colorReput = ResourcePath .. "GreenBars.tga";
							nextValReput = reputationValueLevel[PlayerReput[NamePlayerToShow]["Reput" .. i].position];
						end

						if(PlayerReput[NamePlayerToShow]["Reput" .. i].value ~= nil and PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0 and nextValReput ~= nil)then
							percentReput = ((PlayerReput[NamePlayerToShow]["Reput" .. i].value) * 100) / nextValReput;
							if(percentReput > 100 )then
								percentReput = 100;
							end
						end

						if(i == 100)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position == 6)then
								lvlMax = true;
								colorReput = ResourcePath .. "GreenBars.tga";
								percentReput = 100;
							end
						else
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position == 9)then
								lvlMax = true;
								colorReput = ResourcePath .. "GreenBars.tga";
								percentReput = 100;
							end
						end

						
						------------------------------------------------------------------------------------------
						--debug
						--if(i == 100)then
						--	Write(" pourcent : " .. tostring(percentReput) .. " show : " .. tostring(PlayerReput[NamePlayerToShow]["Reput" .. i].position) .. " : " .. 
						--	tostring(PlayerReput[NamePlayerToShow]["Reput" .. i].value) .. " / " .. tostring(nextValReput));
						--end
						------------------------------------------------------------------------------------------

						------------------------------------------------------------------------------------------
						--- display part
						------------------------------------------------------------------------------------------
						UIShowReput.Message=Turbine.UI.Label(); 
						UIShowReput.Message:SetParent(listItem); 
						UIShowReput.Message:SetSize(350, 30); 
						UIShowReput.Message:SetPosition(posx + 10, posy + 2); 
						if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
							if(lvlMax == true)then
								UIShowReput.Message:SetText(T[ "reputposition" ]);
							else
								UIShowReput.Message:SetText(tostring((PlayerReput[NamePlayerToShow]["Reput" .. i].value)) .. " / " .. tostring(comma_value(nextValReput)));
							end
						else
							UIShowReput.Message:SetText("0 / 0");
						end
						UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
						UIShowReput.Message:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
						UIShowReput.Message:SetForeColor(Turbine.UI.Color.White);
						UIShowReput.Message:SetZOrder(15);

						------------------------------------------------------------------------------------------
						-- filled up box
						------------------------------------------------------------------------------------------
						local sizeOfFilling = (percentReput * 350) / 100;

						UIShowReput.Message=Turbine.UI.Label(); 
						UIShowReput.Message:SetParent(listItem); 
						UIShowReput.Message:SetSize(sizeOfFilling, 15); 
						UIShowReput.Message:SetPosition(posx + 10, posy + 10); 
						UIShowReput.Message:SetText(""); 
						UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
						--UIShowReput.Message:SetBackColor(colorReput);
						UIShowReput.Message:SetBackground(colorReput);
						UIShowReput.Message:SetZOrder(11);

						lvlMax = false;

						UIShowReput.Message=Turbine.UI.Label(); 
						UIShowReput.Message:SetParent(listItem); 
						UIShowReput.Message:SetSize(350, 15); 
						UIShowReput.Message:SetPosition(posx + 10, posy + 10); 
						UIShowReput.Message:SetText(""); 
						UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
						UIShowReput.Message:SetBackColor(Turbine.UI.Color.Black);
						UIShowReput.Message:SetZOrder(10);

						UIShowReput.Message=Turbine.UI.Label(); 
						UIShowReput.Message:SetParent(listItem); 
						UIShowReput.Message:SetSize(354, 19); 
						UIShowReput.Message:SetPosition(posx + 8, posy + 8); 
						UIShowReput.Message:SetText(""); 
						UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
						UIShowReput.Message:SetBackColor(Turbine.UI.Color( 1, 0.5, 0.5, 0.5 ));

						------------------------------------------------------------------------------------------
						-- position alignement with faction
						------------------------------------------------------------------------------------------
						local myTable = {
						T[ "reputposition1" ],
						T[ "reputposition2" ],
						T[ "reputposition3" ],
						T[ "reputposition4" ],
						T[ "reputposition5" ],
						T[ "reputposition6" ],
						T[ "reputposition7" ],
						T[ "reputposition8" ],
						T[ "reputposition9" ],
						T[ "reputposition10" ],
						T[ "reputposition11" ],
						T[ "reputposition12" ],
						T[ "reputposition13" ],
						T[ "reputposition14" ],
						T[ "reputposition15" ],
						T[ "reputposition16" ],
						T[ "reputposition17" ],
						T[ "reputposition18" ],
						T[ "reputposition19" ],
						T[ "reputposition20" ],
						T[ "reputposition21" ],
						T[ "reputposition22" ],
						T[ "reputposition23" ],
						T[ "reputposition24" ],
						T[ "reputposition25" ],
						T[ "reputposition26" ],
						T[ "reputposition27" ],
						T[ "reputposition28" ],
						T[ "reputposition29" ],
						T[ "reputposition30" ],
						T[ "reputposition31" ],
						T[ "reputposition32" ],
						T[ "reputposition33" ],
						T[ "reputposition34" ],
						T[ "reputposition35" ],
						T[ "reputposition36" ],
						T[ "reputposition37" ],
						T[ "reputposition38" ],
						T[ "reputposition39" ],
						T[ "reputposition40" ],
						T[ "reputposition41" ],
						T[ "reputposition42" ],
						T[ "reputposition43" ],
						T[ "reputposition44" ],
						T[ "reputposition45" ],
						T[ "reputposition46" ]
						}; -- etc..

						if(PlayerDatas[NamePlayerToShow].sexe ~= "male")then
							myTable = {
							T[ "reputpositionFemale1" ], -- ennemi
							T[ "reputpositionFemale2" ], -- etranger
							T[ "reputpositionFemale3" ], -- neutre
							T[ "reputpositionFemale4" ], -- connaissance
							T[ "reputpositionFemale5" ], -- amie
							T[ "reputpositionFemale6" ], -- alli�
							T[ "reputpositionFemale7" ], -- fr�re
							T[ "reputpositionFemale8" ], -- respect�
							T[ "reputpositionFemale9" ], -- honor�
							T[ "reputpositionFemale10" ], -- acclam�
							T[ "reputposition11" ], -- initier
							T[ "reputposition12" ], -- aprenti
							T[ "reputposition13" ], -- Compagnon
							T[ "reputposition14" ], -- expert 
							T[ "reputposition15" ], -- artisan
							T[ "reputposition16" ], -- maitre
							T[ "reputposition17" ], -- maitre estmet
							T[ "reputposition18" ], -- maitre ouestmet
							T[ "reputposition19" ], -- grand maitre
							T[ "reputposition20" ], -- rookie
							T[ "reputposition21" ], -- minor
							T[ "reputposition22" ], -- major
							T[ "reputposition23" ], -- all-star
							T[ "reputposition24" ], -- hall of farmer
							T[ "reputposition25" ],
							T[ "reputposition26" ],
							T[ "reputposition27" ],
							T[ "reputposition28" ],
							T[ "reputposition29" ],
							T[ "reputposition30" ],
							T[ "reputposition31" ],
							T[ "reputposition32" ],
							T[ "reputposition33" ],
							T[ "reputposition34" ],
							T[ "reputposition35" ],
							T[ "reputposition36" ],
							T[ "reputposition37" ],
							T[ "reputposition38" ],
							T[ "reputposition39" ],
							T[ "reputposition40" ],
							T[ "reputposition41" ],
							T[ "reputposition42" ],
							T[ "reputposition43" ],
							T[ "reputposition44" ],
							T[ "reputposition45" ],
							T[ "reputposition46" ]
						};
						end
				
						local textToDisplay = "";
						if(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 1)then
							textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position] ;
						elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 2)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 19];
							end
						elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 0)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 3];
							end
						elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 4)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 24];
							end
						elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 5)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 34];
							end
						elseif(PlayerReput[NamePlayerToShow]["Reput" .. i].genre == 6)then
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 40];
							end
						else
							if(PlayerReput[NamePlayerToShow]["Reput" .. i].position > 0)then
								textToDisplay = myTable[PlayerReput[NamePlayerToShow]["Reput" .. i].position + 10];
							end
						end

						UIShowReput.Message=Turbine.UI.Label(); 
						UIShowReput.Message:SetParent(listItem); 
						UIShowReput.Message:SetSize(320, 30); 
						UIShowReput.Message:SetPosition(posx + 10, posy + 17); 
						UIShowReput.Message:SetText( textToDisplay );
						UIShowReput.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
						UIShowReput.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
						UIShowReput.Message:SetForeColor(Turbine.UI.Color.White);

						--posy = posy + 40;
						posy = 5;
						listbox:AddItem(listItem);
						displayedCount = displayedCount + 1;
					end
				end
		end
		------------------------------------------------------------------------------------------
		--- scrollbar handler
		------------------------------------------------------------------------------------------
		vscrollListBox=Turbine.UI.Lotro.ScrollBar();
		vscrollListBox:SetParent(UIShowReput);
		vscrollListBox:SetOrientation(Turbine.UI.Orientation.Vertical);
		vscrollListBox:SetPosition(windowWidth-20, 70);
		vscrollListBox:SetSize(10, windowHeight - 140); -- set width to 12 since it's a "Lotro" style scrollbar and the height is set to match the control that we will be scrolling
		vscrollListBox:SetBackColor(Turbine.UI.Color(.1,.1,.2)); -- just to give it a little style
		vscrollListBox:SetMinimum(0);
		vscrollListBox:SetMaximum(math.max(0, (displayedCount * 60) - listbox:GetHeight()));
		vscrollListBox:SetValue(0); -- set the initial value
		-- set the ValueChanged event handler to take an action when our value changes, in this case, change the map position relative to the viewport
		vscrollListBox.ValueChanged=function()
			listbox:SetTop(0-vscrollListBox:GetValue());
		end

		listbox:SetVerticalScrollBar(vscrollListBox);

	end

	------------------------------------------------------------------------------------------
	--- closing window button
	------------------------------------------------------------------------------------------
	ReputWindowButton = Turbine.UI.Lotro.GoldButton();
	ReputWindowButton:SetParent( UIShowReput );
	ReputWindowButton:SetPosition(windowWidth/2 - 125, windowHeight - 50);
	ReputWindowButton:SetSize( 300, 20 );
	ReputWindowButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	ReputWindowButton:SetText( T[ "PluginCloseButton" ] );
	ReputWindowButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	ReputWindowButton:SetVisible(true);
	ReputWindowButton:SetMouseVisible(true);

	ReputWindowButton.MouseClick = function(sender, args)
		settings["isReputWindowVisible"]["isReputWindowVisible"] = false;
		UIShowReput:SetVisible(false);
	end


	ClosingTheWindowReput();

	EscapeKeyHandlerForWindows(UIShowReput, settings["isReputWindowVisible"]["isReputWindowVisible"]);

end
function GetReputationFactionCount(NamePlayerToShow)
	local nbrReput = 0;
	if(PlayerReput[NamePlayerToShow] ~= nil)then
		for i in pairs(PlayerReput[NamePlayerToShow]) do
			nbrReput = nbrReput + 1;
		end
	end
	return nbrReput;
end