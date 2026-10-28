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

-- Rating definitions for the percentage calculator: { label, saved field, CalcStat stat,
-- penetration stat, penetration factor }. Indexed by the rows below.
local RATING_DEFINITIONS = {
	{ "Physical", "degaP", "PhyMit", "Armour", 1.0 },
	{ "Tactical", "degaT", "TacMit", "Armour", 0.2 },
	{ "Orc", "orc", "PhyMit", "Armour", 0.2 },
	{ "Fell", "orc", "PhyMit", "Armour", 0.2 },
	{ "Outgoing", "healD", "OutHeal" },
	{ "Incoming", "healR", "InHeal" },
	{ "Melee", "meleD", "PhyDmg" },
	{ "Ranged", "range", "PhyDmg" },
	{ "Tactical", "tactD", "TacDmg" },
	{ "CritHit", "critA", "CritHit" },
	{ "DevHit", "critA", "DevHit" },
	{ "Finesse", "fines", "Finesse" },
	{ "CritDef", "defeC", "CritDef" },
	{ "Resistances", "resis", "Resist", "Resist" },
	{ "Block", "bloqu", "Block", "BPE" },
	{ "Partial", "bloqu", "PartBlock", "BPE" },
	{ "Parry", "parad", "Parry", "BPE" },
	{ "Partial", "parad", "PartParry", "BPE" },
	{ "Evade", "esqui", "Evade", "BPE" },
	{ "Partial", "esqui", "PartEvade", "BPE" },
};

-- Build the { label, rating, stat, penetration, factor } list get_percentage expects.
local function BuildRatingData(data)
	local ratings = {};
	for index, definition in ipairs(RATING_DEFINITIONS) do
		ratings[index] = { definition[1], data[definition[2]], definition[3], definition[4], definition[5] };
	end
	return ratings;
end

-- Morale / power (or Beorning wrath) / armour line at the top of the window. Values for
-- the logged-in character are read live; offline characters show their saved maximum.
-- (Displaying no longer overwrites the saved morale/power values.)
local function ResourceValues(playerName, data)
	local isCurrent = (playerName == PlayerName);
	local morale = isCurrent and Player:GetMorale() or data.maxMoral;
	local power, maxPower = data.maxPower, data.maxPower;
	if isCurrent then power = Player:GetPower(); end
	return morale, power, maxPower;
end

local function AddResource(window, iconTexture, x, y, text, color, textOffset)
	local icon = Turbine.UI.Label();
	icon:SetParent(window);
	icon:SetSize(24, 25);
	icon:SetPosition(x, y);
	icon:SetBackground(iconTexture);
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	CreateStatsLabel(window, text, x + (textOffset or 40), y - 2, 300, {
			font = Turbine.UI.Lotro.Font.BookAntiquaBold22,
			color = color,
		});
end

local MORALE_COLOR = Turbine.UI.Color(0.33, 0.66, 0.33);
local POWER_COLOR = Turbine.UI.Color(0, 0.66, 0.75);
local WRATH_COLOR = Turbine.UI.Color(0.9, 0.9, 0.1, 0);
local ARMOUR_COLOR = Turbine.UI.Color(0.5, 0.4, 0.2);
local BEORNING_RACE = 114;

local function Ratio(value, maximum)
	return comma_value(Round(value or 0)) .. " / " .. comma_value(Round(maximum or 0));
end

-- Colour legend for capped ratings (matches SetTheTextColorForCapped).
local CAP_LEGEND = {
	{ "PluginStats35", Turbine.UI.Color(1, 1, 0) },
	{ "PluginStats36", Turbine.UI.Color(1, 0.7, 0) },
	{ "PluginStats37", Turbine.UI.Color.Red },
	{ "PluginStats38", Turbine.UI.Color(1, 0, 1) },
};

local function ShowNoData(window, font, width, height)
	local label = CreateStatsLabel(window, T["PluginStats10"], (window:GetWidth() - width) / 2, (window:GetHeight() - height) / 2, width, {
			height = height,
			align = Turbine.UI.ContentAlignment.MiddleCenter,
			font = font,
		});
	return label;
end

local function BuildFreePeoplesStats(window, playerName, data)
	local ratings = BuildRatingData(data);

	CreateStatsLabel(window, T["PluginCalcStatVersionText"] .. " " .. T["PluginCalcStatVersion"],
		window:GetWidth() / 2 - 275, window:GetHeight() - 25, 550, {
			align = Turbine.UI.ContentAlignment.MiddleCenter,
			font = Turbine.UI.Lotro.Font.BookAntiqua16,
		});

	-- Morale, power (or wrath) and armour.
	local morale, power, maxPower = ResourceValues(playerName, data);
	AddResource(window, 0x410DCFCE, 60, 60, Ratio(morale, data.maxMoral), MORALE_COLOR);
	if data.rac == BEORNING_RACE then
		AddResource(window, 0x4115BDFE, 260, 60, Ratio(0, 100), WRATH_COLOR);
	else
		AddResource(window, 0x410DCFCF, 260, 60, Ratio(power, maxPower), POWER_COLOR);
	end
	AddResource(window, 0x410DCFD0, 460, 60, comma_value(data.armure), ARMOUR_COLOR);

	-- Left column: character, attributes, offence.
	local posx, posy = 50, 100;
	AddStatsSection(window, T["PluginStats"], posx, posy, Turbine.UI.Color.Gold);
	posy = posy + 30;

	AddStatsPair(window, T["PluginStats6"], data.lvl, posx, posy);
	posy = posy + 20;
	AddStatsPair(window, T["PluginStats7"], ResolveStatsRaceName(data.rac), posx, posy);
	posy = posy + 20;
	AddStatsPair(window, T["PluginStats8"], ResolveStatsClassName(data.cla), posx, posy);
	posy = posy + 20;

	CreateStatsLabel(window, T["PluginCrafting"], posx - 20, posy, 120, { height = 18 });
	CreateStatsLabel(window, ResolveStatsProfessionText(playerName), posx + 5, posy + 16, 235, {
			height = 32,
			align = Turbine.UI.ContentAlignment.TopLeft,
			font = Turbine.UI.Lotro.Font.BookAntiquaBold16,
		});
	posy = posy + 44;

	local genderText = (data.sexe == "male") and T["PluginGenderText1"] or T["PluginGenderText2"];
	AddStatsPair(window, T["PluginStats9"], genderText, posx, posy);
	posy = posy + 20;

	AddStatsSection(window, T["PluginStats11"], posx, posy, Turbine.UI.Color.Gold);
	posy = AddNumericRows(window, playerName, {
			{ labelKey = "PluginStats1", field = "might" },
			{ labelKey = "PluginStats2", field = "agility" },
			{ labelKey = "PluginStats3", field = "vitality" },
			{ labelKey = "PluginStats4", field = "will" },
			{ labelKey = "PluginStats5", field = "fate" },
		}, posx, posy + 30);

	AddStatsSection(window, T["PluginStats12"], posx, posy, Turbine.UI.Color.Red);
	AddPercentageRows(window, playerName, ratings, {
			{ labelKey = "PluginStats13", ratingIndex = 10 },
			{ labelKey = "PluginStats34", ratingIndex = 11 },
			{ labelKey = "PluginStats14", ratingIndex = 12 },
			{ labelKey = "PluginStats15", ratingIndex = 7 },
			{ labelKey = "PluginStats16", ratingIndex = 9 },
			{ labelKey = "PluginStats31", ratingIndex = 8 },
		}, posx, posy + 30);

	-- Right column: mitigations, defence, avoidance, healing.
	posx, posy = 350, 98;
	local partial = "    " .. T["PluginStats30"];
	local sections = {
		{ "PluginStats17", {
				{ labelKey = "PluginStats27", ratingIndex = 1 },
				{ labelKey = "PluginStats28", ratingIndex = 2 },
				{ labelKey = "PluginStats32", ratingIndex = 3 },
				{ labelKey = "PluginStats33", ratingIndex = 4 },
			} },
		{ "PluginStats18", {
				{ labelKey = "PluginStats19", ratingIndex = 14 },
				{ labelKey = "PluginStats29", ratingIndex = 13 },
			} },
		{ "PluginStats20", {
				{ labelKey = "PluginStats21", ratingIndex = 15 },
				{ text = partial, ratingIndex = 16 },
				{ labelKey = "PluginStats22", ratingIndex = 17 },
				{ text = partial, ratingIndex = 18 },
				{ labelKey = "PluginStats23", ratingIndex = 19 },
				{ text = partial, ratingIndex = 20 },
			} },
		{ "PluginStats24", {
				{ labelKey = "PluginStats25", ratingIndex = 5 },
				{ labelKey = "PluginStats26", ratingIndex = 6 },
			}, Turbine.UI.Color.Green },
	};
	for _, section in ipairs(sections) do
		AddStatsSection(window, T[section[1]], posx, posy, section[3] or Turbine.UI.Color.Blue);
		posy = AddPercentageRows(window, playerName, ratings, section[2], posx, posy + 30);
	end

	-- Cap colour legend.
	posy = posy + 15;
	for _, entry in ipairs(CAP_LEGEND) do
		CreateStatsLabel(window, T[entry[1]], window:GetWidth() / 2 - 200, posy, 400, {
				align = Turbine.UI.ContentAlignment.MiddleCenter,
				font = Turbine.UI.Lotro.Font.BookAntiquaBold22,
				color = entry[2],
			});
		posy = posy + 20;
	end
end

local function BuildMonsterPlayStats(window, playerName, data)
	AltHolicUtil.CreateLabel(window, T["PluginText"], window:GetWidth() / 2 - 75, window:GetHeight() - 20, 150, 10, {
			align = Turbine.UI.ContentAlignment.MiddleCenter,
		});

	local morale, power, maxPower = ResourceValues(playerName, data);
	AddResource(window, 0x410DCFCE, 40, 50, Ratio(morale, data.maxMoral), MORALE_COLOR);
	AddResource(window, 0x410DCFCF, 40, 80, Ratio(power, maxPower), POWER_COLOR);
end

function CreateUIShowStats(namePlayerToshow)
	AltHolicUtil.DetachControl(UIShowStats);

	local data = PlayerDatas[namePlayerToshow] or {};
	local freePeoples = (data.align == 1);

	UIShowStats = Turbine.UI.Lotro.GoldWindow();
	if freePeoples then
		UIShowStats:SetSize(620, 660);
	else
		UIShowStats:SetSize(300, 130);
	end
	UIShowStats:SetText(tostring(namePlayerToshow));
	UIShowStats:SetPosition((Turbine.UI.Display:GetWidth() - UIShowStats:GetWidth()) / 2,
		(Turbine.UI.Display:GetHeight() - UIShowStats:GetHeight()) / 2);
	UIShowStats:SetZOrder(10);
	UIShowStats:SetWantsKeyEvents(true);
	UIShowStats:SetVisible(false);
	UIShowStats.altHolicKey = namePlayerToshow;

	if freePeoples then
		if HasCharacterFields(data, FREE_PEOPLE_REQUIRED_STATS) then
			BuildFreePeoplesStats(UIShowStats, namePlayerToshow, data);
		else
			ShowNoData(UIShowStats, Turbine.UI.Lotro.Font.TrajanProBold30, 500, 200);
		end
	elseif data.moral ~= nil and data.power ~= nil then
			BuildMonsterPlayStats(UIShowStats, namePlayerToshow, data);
		else
			ShowNoData(UIShowStats, Turbine.UI.Lotro.Font.BookAntiquaBold22, 300, 50);
		end

		ClosingTheWindowStats();
		EscapeKeyHandlerForWindows(UIShowStats, "isShowStatsVisible", "isShowStatsVisible");
	end
