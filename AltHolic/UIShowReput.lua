------------------------------------------------------------------------------------------
-- UIshowReput file: reputation standings of one character
-- Written by Homeopatix, 3 mars 2021; reworked for AltHolic 5.06.
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 420;
local ROW_HEIGHT = 60;
local BAR_WIDTH = 350;

-- Crafting guild reputations are only listed for characters with that profession.
local GUILD_REPUTATION_PROFESSIONS = {
	[21] = { "jeweller", "jeweler" },
	[22] = { "cook" },
	[23] = { "scholar", "historian" },
	[24] = { "tailor", "taillor" },
	[25] = { "woodworker", "carpenter" },
	[26] = { "weaponsmith", "weaponcrafter" },
	[27] = { "metalsmith" },
};

-- Offset into the rank-name list for each rank ladder ("genre"; see GetReputationGenre).
local RANK_NAME_OFFSET = { [1] = 0, [2] = 19, [0] = 3, [4] = 24, [5] = 34, [6] = 40 };
local GUILD_RANK_OFFSET = 10;

local BAR_TEXTURES = {
	blue = "BlueBars.tga", purple = "PurpleBars.tga", red = "RedBars.tga", green = "GreenBars.tga",
};

local function CharacterHasProfession(playerName, aliases)
	if aliases == nil then return true; end
	for _, profession in ipairs(GetSavedProfessions(playerName)) do
		local name = string.lower(tostring(profession.Name or profession.Key or ""));
		for _, alias in ipairs(aliases) do
			if string.find(name, alias, 1, true) ~= nil then return true; end
		end
	end
	return false;
end

-- Rank names 1..46; ranks 1-10 have feminine forms in French/German.
local function BuildRankNames(isFemale)
	local names = {};
	for index = 1, 46 do
		local key = "reputposition" .. index;
		if isFemale and index <= 10 then key = "reputpositionFemale" .. index; end
		names[index] = T[key];
	end
	return names;
end

-- Progress for one faction: value text, fill percentage, bar texture and rank text.
-- The rank/threshold rules are AltHolic's original ones, kept as they were.
local function ComputeStanding(index, record, rankNames)
	local thresholds = GetReputationDisplayThresholds(index);
	local genre = GetReputationGenre(index);

	-- Historical saved-data correction for The White Company and Umbar Baharbel.
	if index == 70 and (tonumber(record.position) or 0) >= 7 then
		record.position = record.position - 3;
	elseif index == 102 and (tonumber(record.position) or 0) >= 7 then
		record.position = record.position - 1;
	end
	if record.position == nil then record.position = 0; end

	local position = tonumber(record.position) or 0;
	local value = tonumber(record.value);
	local nextValue, bar;

	if position >= 3 then
		nextValue = (index == 100) and thresholds[position] or thresholds[position + genre];
		bar = "blue";
	elseif position == 2 then
		nextValue = thresholds[position];
		bar = (index == 64 or index == 100) and "blue" or "purple";
	elseif index == 100 then
		nextValue = thresholds[position];
		bar = "blue";
	elseif index == 79 then
		nextValue = thresholds[position + genre - 4];
		bar = "blue";
	else
		nextValue = thresholds[position];
		bar = "red";
	end

	local atMax = false;
	if value ~= nil and value == thresholds[position + genre] then
		atMax = true;
		bar = "green";
		nextValue = thresholds[position];
	end

	local percent = 0;
	if value ~= nil and position > 0 and nextValue ~= nil then
		if nextValue > 0 then
			percent = math.min(100, (value * 100) / nextValue);
		elseif value > 0 then
			percent = 100;
		end
	end

	local topRank = (index == 100) and 6 or 9;
	if position == topRank then
		atMax = true;
		bar = "green";
		percent = 100;
	end

	local valueText = "0 / 0";
	if position > 0 then
		valueText = atMax and T["reputposition"] or (tostring(record.value) .. " / " .. tostring(comma_value(nextValue)));
	end

	local rankText = "";
	if genre == 1 or position > 0 then
		rankText = rankNames[position + (RANK_NAME_OFFSET[genre] or GUILD_RANK_OFFSET)] or "";
	end

	return valueText, percent, ResourcePath .. BAR_TEXTURES[bar], rankText;
end

local function Bar(parent, x, y, width, height, zOrder)
	local bar = Turbine.UI.Label();
	bar:SetParent(parent);
	bar:SetPosition(x, y);
	bar:SetSize(width, height);
	if zOrder ~= nil then bar:SetZOrder(zOrder); end
	return bar;
end

local function CreateReputationRow(listbox, playerName, index, record, rankNames)
	local row = Turbine.UI.Control();
	row:SetSize(WINDOW_WIDTH - 45, ROW_HEIGHT);
	row:SetMouseVisible(true);

	local nameLabel = AltHolicUtil.CreateLabel(row, T["reputname" .. index], 10, 5, BAR_WIDTH, 30, {
		font = Turbine.UI.Lotro.Font.BookAntiquaBold22,
		color = Turbine.UI.Color.Gold,
		align = Turbine.UI.ContentAlignment.MiddleCenter,
		mouseVisible = (playerName == PlayerName),
	});
	if playerName == PlayerName then
		nameLabel.MouseClick = function()
			CreateAddNewWindowReput(T["reputname" .. index], playerName, index);
			AltHolicAddnewWindowReput:SetVisible(true);
		end
	end

	local valueText, percent, barTexture, rankText = ComputeStanding(index, record, rankNames);

	local valueLabel = AltHolicUtil.CreateLabel(row, valueText, 20, 22, BAR_WIDTH, 30, {
		font = Turbine.UI.Lotro.Font.BookAntiquaBold18,
		align = Turbine.UI.ContentAlignment.MiddleCenter,
	});
	valueLabel:SetZOrder(15);

	Bar(row, 20, 30, (percent * BAR_WIDTH) / 100, 15, 11):SetBackground(barTexture);
	Bar(row, 20, 30, BAR_WIDTH, 15, 10):SetBackColor(Turbine.UI.Color.Black);
	Bar(row, 18, 28, BAR_WIDTH + 4, 19):SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));

	AltHolicUtil.CreateLabel(row, rankText, 20, 37, 320, 30, { font = Turbine.UI.Lotro.Font.Verdana16 });

	listbox:AddItem(row);
end

------------------------------------------------------------------------------------------
-- create the reputation window (ShowReput = true also lists factions with no standing)
------------------------------------------------------------------------------------------
function CreateUIShowReput(NamePlayerToShow, ShowReput)
	AltHolicUtil.DetachControl(UIShowReput);

	local showAll = (ShowReput == true);
	settings["ShowHideReput"]["value"] = showAll;

	local windowHeight = math.min(870, Turbine.UI.Display:GetHeight() - 150);

	UIShowReput = Turbine.UI.Lotro.GoldWindow();
	UIShowReput:SetSize(WINDOW_WIDTH, windowHeight);
	UIShowReput:SetText(string.format(T["PluginReputationFor"], NamePlayerToShow));
	UIShowReput:SetPosition((Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2, (Turbine.UI.Display:GetHeight() - windowHeight) / 2);
	UIShowReput:SetZOrder(10);
	UIShowReput:SetWantsKeyEvents(true);
	UIShowReput:SetVisible(false);
	UIShowReput.altHolicKey = NamePlayerToShow;

	AltHolicUtil.CreateLabel(UIShowReput, T["PluginText"], WINDOW_WIDTH / 2 - 75, windowHeight - 20, 150, 10, {
		align = Turbine.UI.ContentAlignment.MiddleCenter,
	});
	DisplayHelpButton(UIShowReput, WINDOW_WIDTH, 3);

	-- "+/-" toggle: show or hide factions without any standing.
	local toggleButton = Turbine.UI.Extensions.SimpleWindow();
	toggleButton:SetParent(UIShowReput);
	toggleButton:SetPosition(25, 35);
	toggleButton:SetSize(16, 16);
	toggleButton:SetVisible(true);
	toggleButton:SetMouseVisible(true);

	local toggleIcon = Turbine.UI.Label();
	toggleIcon:SetParent(toggleButton);
	toggleIcon:SetPosition(0, 0);
	toggleIcon:SetSize(16, 16);
	toggleIcon:SetBackground(showAll and 0x41007E26 or 0x41007E27); -- minus / plus
	toggleIcon:SetZOrder(-1);
	toggleIcon:SetMouseVisible(false);

	AltHolicUtil.AttachFramedTooltip(toggleButton, UIShowReput, 50, 20, 180, 30, T["PluginReputationToggleUnknown"], {
		font = false, zOrder = 10000, labelZOrder = -1, backColor = Turbine.UI.Color(.9, .1, .4, .9),
	});

	toggleButton.MouseClick = function()
		CreateUIShowReput(NamePlayerToShow, not showAll);
		UIShowReput:SetVisible(true);
	end

	local reputations = PlayerReput[NamePlayerToShow];
	if reputations == nil then
		AltHolicUtil.CreateLabel(UIShowReput, T["PluginStats10"], 25, 350, 350, 100, {
			font = Turbine.UI.Lotro.Font.BookAntiquaBold22,
			align = Turbine.UI.ContentAlignment.MiddleCenter,
		});
	else
		local listbox = Turbine.UI.ListBox();
		listbox:SetParent(UIShowReput);
		listbox:SetSize(WINDOW_WIDTH - 45, windowHeight - 140);
		listbox:SetPosition(20, 70);
		listbox:SetMouseVisible(true);
		listbox:SetZOrder(20);

		local data = PlayerDatas[NamePlayerToShow] or {};
		local rankNames = BuildRankNames(data.sexe ~= "male");
		local filterGuilds = (data.align == 1);
		local displayed = 0;

		for index = 1, nbrFactions do
			local record = reputations["Reput" .. index];
			if record ~= nil
				and (not filterGuilds or CharacterHasProfession(NamePlayerToShow, GUILD_REPUTATION_PROFESSIONS[index]))
				and (showAll or (tonumber(record.value) or 0) ~= 0 or (tonumber(record.position) or 0) > 0) then
				CreateReputationRow(listbox, NamePlayerToShow, index, record, rankNames);
				displayed = displayed + 1;
			end
		end

		if displayed * ROW_HEIGHT > listbox:GetHeight() then
			local scrollbar = Turbine.UI.Lotro.ScrollBar();
			scrollbar:SetParent(UIShowReput);
			scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
			scrollbar:SetPosition(WINDOW_WIDTH - 20, 70);
			scrollbar:SetSize(10, windowHeight - 140);
			scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
			listbox:SetVerticalScrollBar(scrollbar);
		end
	end

	AltHolicUtil.CreateCloseButton(UIShowReput, T["PluginCloseButton"], windowHeight - 50, function()
		settings["isReputWindowVisible"]["isReputWindowVisible"] = false;
		UIShowReput:SetVisible(false);
	end, 300, WINDOW_WIDTH / 2 - 125);

	ClosingTheWindowReput();
	EscapeKeyHandlerForWindows(UIShowReput, "isReputWindowVisible", "isReputWindowVisible");
end
