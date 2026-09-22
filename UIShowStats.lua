------------------------------------------------------------------------------------------
-- UIShowStats file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------

local STATS_RACE_TEXT_KEYS = {
    [81] = "PluginRace1", [23] = "PluginRace2", [65] = "PluginRace3",
    [114] = "PluginRace4", [120] = "PluginRace5", [73] = "PluginRace6",
    [117] = "PluginRace7", [7] = "PluginRace8", [12] = "PluginRace9",
    [6] = "PluginRace10", [66] = "PluginRace11", [125] = "PluginRace12",
};

local STATS_CLASS_TEXT_KEYS = {
    [162] = "PluginClasse1", [31] = "PluginClasse2", [214] = "PluginClasse3",
    [24] = "PluginClasse4", [193] = "PluginClasse5", [40] = "PluginClasse6",
    [185] = "PluginClasse7", [23] = "PluginClasse8", [172] = "PluginClasse9",
    [194] = "PluginClasse10", [71] = "PluginClasse11", [128] = "PluginClasse12",
    [127] = "PluginClasse13", [179] = "PluginClasse14", [52] = "PluginClasse15",
    [126] = "PluginClasse16", [215] = "PluginClasse17", [216] = "PluginClasse18",
};

local FREE_PEOPLE_REQUIRED_STATS = {
    "moral", "power", "armure", "degaP", "degaT", "orc", "healD", "healR",
    "meleD", "range", "tactD", "critA", "fines", "defeC", "resis", "bloqu", "parad", "esqui",
};

local function HasCharacterFields(data, fields)
    for index = 1, #fields do
        if data[fields[index]] == nil then return false; end
    end
    return true;
end

local function StatsText(key, fallback)
    return (key ~= nil and T[key]) or fallback or "-";
end

local function CreateStatsLabel(parent, text, x, y, width, options)
    options = options or {};
    return AltHolicUtil.CreateLabel(parent, text, x, y, width, options.height or 20, {
        align = options.align or Turbine.UI.ContentAlignment.MiddleLeft,
        font = options.font or Turbine.UI.Lotro.Font.BookAntiquaBold18,
        color = options.color or Turbine.UI.Color.White,
        mouseVisible = false,
    });
end

local function AddStatsPair(parent, labelText, valueText, x, y, options)
    options = options or {};
    CreateStatsLabel(parent, labelText, x - 20, y, options.labelWidth or 120, options);
    return CreateStatsLabel(parent, tostring(valueText or "-"), x - 80, y, options.valueWidth or 300, {
        align = Turbine.UI.ContentAlignment.MiddleRight,
        font = options.font or Turbine.UI.Lotro.Font.BookAntiquaBold18,
        color = options.valueColor or options.color or Turbine.UI.Color.White,
    });
end

local function AddStatsSection(parent, text, x, y, lineColor)
    CreateStatsLabel(parent, text, x - 25, y, 250, {
        height = 30,
        align = Turbine.UI.ContentAlignment.MiddleCenter,
        font = Turbine.UI.Lotro.Font.BookAntiquaBold18,
        color = Turbine.UI.Color.White,
    });
    local line = Turbine.UI.Control();
    line:SetParent(parent);
    line:SetPosition(x - 25, y + 25);
    line:SetSize(250, 2);
    line:SetBackColor(lineColor or Turbine.UI.Color.Gold);
    line:SetMouseVisible(false);
end

local function AddPercentageRows(parent, playerName, ratingData, rows, x, y)
    for _, row in ipairs(rows) do
        local labelText = row.text or T[row.labelKey] or "-";
        local rating = ratingData[row.ratingIndex];
        local value, capped = get_percentage(
            rating[3], rating[2], PlayerDatas[playerName].lvl, rating[4], rating[5], playerName
        );
        local valueLabel = AddStatsPair(parent, labelText, value, x, y, { labelWidth = 200 });
        SetTheTextColorForCapped(capped, valueLabel);
        y = y + 20;
    end
    return y;
end

local function AddNumericRows(parent, playerName, rows, x, y)
    local data = PlayerDatas[playerName];
    for _, row in ipairs(rows) do
        local value = data[row.field];
        if row.round ~= false then value = comma_value(Round(value or 0)); end
        AddStatsPair(parent, T[row.labelKey] or "-", value, x, y);
        y = y + 20;
    end
    return y;
end

local function ResolveStatsRaceName(raceId)
    return StatsText(STATS_RACE_TEXT_KEYS[raceId], "-");
end

local function ResolveStatsClassName(classId)
    return StatsText(STATS_CLASS_TEXT_KEYS[classId], "-");
end

local function ResolveStatsProfessionText(playerName)
    local names = {};
    for _, profession in ipairs(GetSavedProfessions(playerName)) do
        names[#names + 1] = profession.Name or profession.Key;
    end
    local value = AltHolicUtil.Join(names, ", ");
    return value ~= "" and value or "-";
end

function CreateUIShowStats(namePlayerToshow)	
	
	local PlayerAttArray;
	local UIShowStatsLabIcon;
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
		if HasCharacterFields(PlayerDatas[namePlayerToshow], FREE_PEOPLE_REQUIRED_STATS) then

			-- Rating definitions used by the percentage calculator.
			PlayerAttArray = {
				{"Physical", PlayerDatas[namePlayerToshow].degaP, "PhyMit", "Armour", 1.0},
				{"Tactical", PlayerDatas[namePlayerToshow].degaT, "TacMit", "Armour", 0.2},
				{"Orc", PlayerDatas[namePlayerToshow].orc, "PhyMit", "Armour", 0.2},
				{"Fell", PlayerDatas[namePlayerToshow].orc, "PhyMit", "Armour", 0.2},
				{"Outgoing", PlayerDatas[namePlayerToshow].healD, "OutHeal"},
				{"Incoming", PlayerDatas[namePlayerToshow].healR, "InHeal"},
				{"Melee", PlayerDatas[namePlayerToshow].meleD, "PhyDmg"},
				{"Ranged", PlayerDatas[namePlayerToshow].range, "PhyDmg"},
				{"Tactical", PlayerDatas[namePlayerToshow].tactD, "TacDmg"},
				{"CritHit", PlayerDatas[namePlayerToshow].critA, "CritHit"},
				{"DevHit", PlayerDatas[namePlayerToshow].critA, "DevHit"},
				{"Finesse", PlayerDatas[namePlayerToshow].fines, "Finesse"},
				{"CritDef", PlayerDatas[namePlayerToshow].defeC, "CritDef"},
				{"Resistances", PlayerDatas[namePlayerToshow].resis, "Resist", "Resist"},
				{"Block", PlayerDatas[namePlayerToshow].bloqu, "Block", "BPE"},
				{"Partial", PlayerDatas[namePlayerToshow].bloqu, "PartBlock", "BPE"},
				{"Parry", PlayerDatas[namePlayerToshow].parad, "Parry", "BPE"},
				{"Partial", PlayerDatas[namePlayerToshow].parad, "PartParry", "BPE"},
				{"Evade", PlayerDatas[namePlayerToshow].esqui, "Evade", "BPE"},
				{"Partial", PlayerDatas[namePlayerToshow].esqui, "PartEvade", "BPE"},
			};

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

			-- Basic character information
			AddStatsSection(UIShowStats, T["PluginStats"], posx, posy, Turbine.UI.Color.Gold);
			posy = posy + 30;

			AddStatsPair(UIShowStats, T["PluginStats6"], PlayerDatas[namePlayerToshow].lvl, posx, posy);
			posy = posy + 20;
			AddStatsPair(UIShowStats, T["PluginStats7"], ResolveStatsRaceName(PlayerDatas[namePlayerToshow].rac), posx, posy);
			posy = posy + 20;
			AddStatsPair(UIShowStats, T["PluginStats8"], ResolveStatsClassName(PlayerDatas[namePlayerToshow].cla), posx, posy);
			posy = posy + 20;
			AddStatsPair(UIShowStats, T["PluginCrafting"] or "Crafting", ResolveStatsProfessionText(namePlayerToshow), posx, posy);
			posy = posy + 20;
			local genderText = PlayerDatas[namePlayerToshow].sexe == "male" and T["PluginGenderText1"] or T["PluginGenderText2"];
			AddStatsPair(UIShowStats, T["PluginStats9"], genderText, posx, posy);

			posy = posy + 20;

			-- Primary attributes
			AddStatsSection(UIShowStats, T["PluginStats11"], posx, posy, Turbine.UI.Color.Gold);
			posy = posy + 30;
			posy = AddNumericRows(UIShowStats, namePlayerToshow, {
				{ labelKey = "PluginStats1", field = "might" },
				{ labelKey = "PluginStats2", field = "agility" },
				{ labelKey = "PluginStats3", field = "vitality" },
				{ labelKey = "PluginStats4", field = "will" },
				{ labelKey = "PluginStats5", field = "fate" },
			}, posx, posy);

			-- Offence
			AddStatsSection(UIShowStats, T["PluginStats12"], posx, posy, Turbine.UI.Color.Red);
			posy = posy + 30;
			posy = AddPercentageRows(UIShowStats, namePlayerToshow, PlayerAttArray, {
				{ labelKey = "PluginStats13", ratingIndex = 10 },
				{ labelKey = "PluginStats34", ratingIndex = 11 },
				{ labelKey = "PluginStats14", ratingIndex = 12 },
				{ labelKey = "PluginStats15", ratingIndex = 7 },
				{ labelKey = "PluginStats16", ratingIndex = 9 },
				{ labelKey = "PluginStats31", ratingIndex = 8 },
			}, posx, posy);

			-- Mitigations and defence are displayed in the right column.
			posy = 98;
			posx = 350;

			AddStatsSection(UIShowStats, T["PluginStats17"], posx, posy, Turbine.UI.Color.Blue);
			posy = posy + 30;
			posy = AddPercentageRows(UIShowStats, namePlayerToshow, PlayerAttArray, {
				{ labelKey = "PluginStats27", ratingIndex = 1 },
				{ labelKey = "PluginStats28", ratingIndex = 2 },
				{ labelKey = "PluginStats32", ratingIndex = 3 },
				{ labelKey = "PluginStats33", ratingIndex = 4 },
			}, posx, posy);

			AddStatsSection(UIShowStats, T["PluginStats18"], posx, posy, Turbine.UI.Color.Blue);
			posy = posy + 30;
			posy = AddPercentageRows(UIShowStats, namePlayerToshow, PlayerAttArray, {
				{ labelKey = "PluginStats19", ratingIndex = 14 },
				{ labelKey = "PluginStats29", ratingIndex = 13 },
			}, posx, posy);

			AddStatsSection(UIShowStats, T["PluginStats20"], posx, posy, Turbine.UI.Color.Blue);
			posy = posy + 30;
			posy = AddPercentageRows(UIShowStats, namePlayerToshow, PlayerAttArray, {
				{ labelKey = "PluginStats21", ratingIndex = 15 },
				{ text = "    " .. T["PluginStats30"], ratingIndex = 16 },
				{ labelKey = "PluginStats22", ratingIndex = 17 },
				{ text = "    " .. T["PluginStats30"], ratingIndex = 18 },
				{ labelKey = "PluginStats23", ratingIndex = 19 },
				{ text = "    " .. T["PluginStats30"], ratingIndex = 20 },
			}, posx, posy);

			AddStatsSection(UIShowStats, T["PluginStats24"], posx, posy, Turbine.UI.Color.Green);
			posy = posy + 30;
			posy = AddPercentageRows(UIShowStats, namePlayerToshow, PlayerAttArray, {
				{ labelKey = "PluginStats25", ratingIndex = 5 },
				{ labelKey = "PluginStats26", ratingIndex = 6 },
			}, posx, posy);

			posy = posy + 15;

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
		if PlayerDatas[namePlayerToshow].moral ~= nil and PlayerDatas[namePlayerToshow].power ~= nil then
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