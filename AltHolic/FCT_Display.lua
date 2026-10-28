------------------------------------------------------------------------------------------
-- FCT_Display file: building blocks for the main window rows and shared popups
-- Written by Homeopatix, 19 march 2022
-- Reworked for AltHolic 5.06: shared tooltip/toggle helpers instead of module-wide control
-- tables that kept references to every control of every previous window build.
------------------------------------------------------------------------------------------

local TOOLTIP_PINK = Turbine.UI.Color(.9, .1, .4, .9);
local TOOLTIP_PINK_SOFT = Turbine.UI.Color(.8, .1, .4, .9);

-- Character-row tooltips all appear in the same spot near the top of the main window.
local function RowTooltip(trigger, text, options)
	options = options or {};
	local x = (settings["displayServers"]["value"] == true) and 150 or 120;
	return AltHolicUtil.AttachFramedTooltip(trigger, AltHolicWindow, x, 40, 180, 30, text, {
			backColor = TOOLTIP_PINK,
			zOrder = options.zOrder or 20,
			font = options.font,
		});
end

local function IsFreePeoples(playerName)
	return PlayerDatas[playerName] ~= nil and PlayerDatas[playerName].align == 1;
end

------------------------------------------------------------------------------------------
-- Birthday easter egg (shown on Tolkien's and the original author's birthdays)
------------------------------------------------------------------------------------------
local BIRTHDAY_BACKGROUNDS = {
	0x410096C9, 0x411023FF, 0x41108565, 0x4110DC08, 0x41134C68,
	0x411C5268, 0x41008203, 0x410096A8, 0x410096CA, 0x4101DBD4,
};
local BIRTHDAY_DECORATIONS = {
	0x410E04BB, 0x410E04BE, 0x410E04C4, 0x410E04CA, 0x410E04CD, 0x410DCFBE, 0x410DCFBF,
	0x410DCFC2, 0x411130D8, 0x4116D9C6, 0x411C4113, 0x411EC9F9, 0x41104C79,
};
local BIRTHDAY_FLAGS = { 0x410040AB, 0x4110E90B, 0x4110E90C, 0x4110E90D, 0x4110E90E, 0x4110E90F, 0x4110E910 };

local function BirthdayTile(parent, x, y, textures)
	local tile = Turbine.UI.Label();
	tile:SetParent(parent);
	tile:SetPosition(x, y);
	tile:SetSize(32, 32);
	tile:SetZOrder(101);
	tile:SetBackground(textures[Random(1, #textures)]);
	tile:SetBlendMode(Turbine.UI.BlendMode.Overlay);
end

local function BirthdayPanel(parent, x, y, width, height, backColor, zOrder)
	local panel = Turbine.UI.Label();
	panel:SetParent(parent);
	panel:SetPosition(x, y);
	panel:SetSize(width, height);
	panel:SetZOrder(zOrder or 101);
	panel:SetBackColor(backColor);
	return panel;
end

local function BirthdayText(parent, text, x, y, width, height, font, color)
	local label = BirthdayPanel(parent, x, y, width, height, Turbine.UI.Color(.9, .4, .4, .4), 102);
	label:SetFont(font);
	label:SetText(text or "");
	label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	label:SetForeColor(color);
	label:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	return label;
end

function DisplayBirthday(cDay, cMonth, cYear)
	-- Bottom-left, away from the character-list expand/collapse control.
	local trigger = Turbine.UI.Extensions.SimpleWindow();
	trigger:SetParent(AltHolicWindow);
	trigger:SetPosition(18, AltHolicWindow:GetHeight() - 62);
	trigger:SetSize(32, 32);
	trigger:SetVisible(true);
	trigger:SetZOrder(2000);
	trigger:SetBackground(0x410DBA89); -- heart

	local displayWidth = Turbine.UI.Display:GetWidth();
	local displayHeight = Turbine.UI.Display:GetHeight();

	local card = Turbine.UI.Extensions.SimpleWindow();
	card:SetParent(AltHolicWindow);
	card:SetSize(1024, 512);
	card:SetPosition((displayWidth - 1024) / 2, (displayHeight - 512) / 2);
	card:SetVisible(false);
	card:SetZOrder(100);
	card:SetBackground(BIRTHDAY_BACKGROUNDS[Random(1, #BIRTHDAY_BACKGROUNDS)]);

	local border = Turbine.UI.Extensions.SimpleWindow();
	border:SetParent(AltHolicWindow);
	border:SetSize(1030, 518);
	border:SetPosition((displayWidth - 1024) / 2 - 3, (displayHeight - 512) / 2 - 3);
	border:SetVisible(false);
	border:SetZOrder(99);
	border:SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));

	local centerX = card:GetWidth() / 2;
	local titleFont = (Turbine.Engine.GetLanguage() == Turbine.Language.German)
	and Turbine.UI.Lotro.Font.TrajanProBold22 or Turbine.UI.Lotro.Font.TrajanProBold25;
	BirthdayText(card, T["PluginBirthdayTitle"], centerX - 200, 50, 390, 30, titleFont, Turbine.UI.Color.Gold);
	BirthdayPanel(card, centerX - 202, 48, 394, 34, Turbine.UI.Color(.1, .3, .3, .3));

	-- Row of flags along the top edge.
	for index = 0, 31 do
		BirthdayTile(card, 1 + index * 32, 0, BIRTHDAY_FLAGS);
	end

	local monthNames = { [5] = T["PluginMonthMay"], [9] = T["PluginMonthSeptember"] };
	local dayMessages = { [22] = T["PluginBirthdayTolkien"], [23] = T["PluginBirthdayDeveloper"] };

	BirthdayText(card, cDay .. "  " .. tostring(monthNames[cMonth]) .. "  " .. cYear, centerX - 150, 150, 300, 30,
		Turbine.UI.Lotro.Font.BookAntiquaBold24, Turbine.UI.Color.Gold);
	BirthdayText(card, dayMessages[cDay], centerX - 150, 180, 300, 200,
		Turbine.UI.Lotro.Font.BookAntiquaBold22, Turbine.UI.Color.White);
	BirthdayPanel(card, centerX - 152, 148, 304, 234, Turbine.UI.Color(1, .3, .3, .3));

	-- Three rows of decorations along the bottom edge.
	for index = 0, 95 do
		BirthdayTile(card, 1 + (index % 32) * 32, 418 + math.floor(index / 32) * 32, BIRTHDAY_DECORATIONS);
	end

	trigger.MouseEnter = function()
		card:SetVisible(true);
		border:SetVisible(true);
		settings["isFestivalWindowVisible"]["value"] = true;
	end
	trigger.MouseLeave = function()
		card:SetVisible(false);
		border:SetVisible(false);
		settings["isFestivalWindowVisible"]["value"] = false;
	end
end

------------------------------------------------------------------------------------------
-- Character row buttons: backpack / vault / wallet
------------------------------------------------------------------------------------------
-- "Show random bags" option: legacy vocation bag artwork picked at random per row.
local RANDOM_BAG_ICONS = { 0x410FC45F, 0x410F467E, 0x410F4682, 0x410F4684, 0x410F4688, 0x410F4686, 0x410F4680 };

local function RowButton(texture, x, y)
	local button = Turbine.UI.Control();
	button:SetParent(viewport1.map);
	button:SetPosition(x, y);
	button:SetSize(32, 32);
	if texture ~= nil then button:SetBackground(texture); end
	button:SetMouseVisible(true);
	button:SetVisible(true);
	button:SetZOrder(10);
	button:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	return button;
end

function DisplayBag(i, posx, posy)
	if settings["nameAccount"]["account1"]["nbrAlt"] == 0 then return; end

	local texture = 0x410F4B84; -- monster play
	if IsFreePeoples(i) then
		texture = (settings["displayClassBags"]["value"] == true)
		and RANDOM_BAG_ICONS[Random(1, #RANDOM_BAG_ICONS)] or 0x410FC45F;
	end

	local button = RowButton(texture, posx + 248, posy + 30);
	button.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowBag; end, function()
				SavePlayerBags();
				CreateUIShowBag(i);
			end, "isShowBagVisible", "isShowBagVisible", i);
	end
end

function DisplayVault(i, posx, posy)
	if settings["nameAccount"]["account1"]["nbrAlt"] == 0 then return; end

	local button = RowButton(IsFreePeoples(i) and 0x410E76AE or nil, posx + 220, posy + 30);
	button.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowVault; end,
			function() CreateUIShowVault(i); end, "isShowVaultVisible", "isShowVaultVisible", i);
	end
end

function DisplayWallet(i, posx, posy)
	if settings["nameAccount"]["account1"]["nbrAlt"] == 0 then return; end

	local button = RowButton(0x411D028B, posx + 190, posy + 30);
	button.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowWallet; end,
			function() CreateUIShowWallet(i); end, "isShowWalletVisible", "isShowWalletVisible", i);
	end
end

-- Invisible click area over the class emblem: opens the equipment window.
function DisplayEquipment(posx, posy, nameToShow, alignement)
	local clickArea = Turbine.UI.Control();
	clickArea:SetParent(viewport1.map);
	clickArea:SetPosition(posx - 3, posy);
	clickArea:SetSize(32, 32);
	clickArea:SetVisible(true);
	clickArea:SetZOrder(30);

	clickArea.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowEquip; end, function()
				SavePlayerEquipment();
				CreateUIShowEquip(nameToShow, alignement);
			end, "isShowEquipmentVisible", "isShowEquipmentVisible", nameToShow);
	end
end

------------------------------------------------------------------------------------------
-- Main window header buttons: Gold Tally / XP / epic books
------------------------------------------------------------------------------------------
function DisplayCashWindow(posx, posy)
	local button = Turbine.UI.Extensions.SimpleWindow();
	button:SetParent(AltHolicWindow);
	button:SetPosition(posx, posy);
	button:SetSize(32, 32);
	button:SetVisible(true);
	button:SetZOrder(30);
	button:SetMouseVisible(true);

	-- Top-level tooltip window so it can extend past the main window's edges.
	local tooltip = Turbine.UI.Window();
	tooltip:SetSize(190, 28);
	tooltip:SetBackColor(Turbine.UI.Color(0.92, 0.03, 0.03, 0.03));
	tooltip:SetZOrder(10001);
	tooltip:SetMouseVisible(false);
	tooltip:SetVisible(false);

	local tooltipLabel = Turbine.UI.Label();
	tooltipLabel:SetParent(tooltip);
	tooltipLabel:SetPosition(6, 2);
	tooltipLabel:SetSize(178, 24);
	tooltipLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	tooltipLabel:SetForeColor(Turbine.UI.Color(1, 0.92, 0.78));
	tooltipLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	tooltipLabel:SetText(T["PluginGoldTallyOpenTooltip"]);
	tooltipLabel:SetMouseVisible(false);

	local function PositionTooltip()
		local x = AltHolicWindow:GetLeft() + posx - tooltip:GetWidth() + 32;
		local y = AltHolicWindow:GetTop() + posy - tooltip:GetHeight() - 4;
		local screenWidth = Turbine.UI.Display:GetWidth();
		if x < 0 then x = 2; end
		if x + tooltip:GetWidth() > screenWidth then x = screenWidth - tooltip:GetWidth() - 2; end
		if y < 0 then y = AltHolicWindow:GetTop() + posy + 34; end
		tooltip:SetPosition(x, y);
	end

	button.MouseEnter = function()
		PositionTooltip();
		tooltip:SetVisible(true);
	end
	button.MouseLeave = function()
		tooltip:SetVisible(false);
	end
	button.MouseClick = function()
		tooltip:SetVisible(false);
		ToggleUIShowCash();
	end
end

local function HeaderButton(posx, posy, tooltipText)
	local button = Turbine.UI.Extensions.SimpleWindow();
	button:SetParent(AltHolicWindow);
	button:SetPosition(posx, posy);
	button:SetSize(32, 32);
	button:SetVisible(true);
	button:SetZOrder(30);
	button:SetMouseVisible(true);
	AltHolicUtil.AttachFramedTooltip(button, AltHolicWindow, posx + 40, posy - 5, 180, 30, tooltipText,
		{ backColor = TOOLTIP_PINK_SOFT });
	return button;
end

function DisplayXPWindow(posx, posy)
	local button = HeaderButton(posx, posy, T["PluginXPWindow1"]);
	button.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowXP; end, CreateUIShowXP, "isXPWindowVisible", "value");
	end
end

function DisplayEpiqueWindow(i, posx, posy)
	local button = HeaderButton(posx, posy, T["PluginEpiqueWindow1"]);
	button.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowEpique; end,
			CreateUIShowEpique, "isEpiqueWindowVisible", "isEpiqueWindowVisible");
	end
end

------------------------------------------------------------------------------------------
-- Money rows (main window footer and wallet window)
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

local UNDERLINE = "___________________________________________________________________________________";

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
	line:SetText(UNDERLINE);
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

local function SavedCoinBags(playerName)
	local data = PlayerDatas[playerName] or {};
	return tonumber(data.bagCash) or 0, tonumber(data.vaultCash) or 0;
end

function DisplayCash(totalCash, windowToDisplay, namePlayerToshow)
	-- The main window calls this twice: the logged-in character's wallet (name given) and
	-- the account total (no name), which sits 20px lower.
	local isCharacterRow = (namePlayerToshow == PlayerName);
	if totalCash == nil then totalCash = PlayerAttr:GetMoney(); end
	if namePlayerToshow == nil or namePlayerToshow == "" then namePlayerToshow = PlayerName; end

	local valToAdd;
	if windowToDisplay == UIShowWallet then
		local bagCash, vaultCash = SavedCoinBags(namePlayerToshow);
		valToAdd = (bagCash > 0 and vaultCash > 0) and 570 or 490;
		if bagCash > 0 or vaultCash > 0 then
			CreateMoneySectionTitle(windowToDisplay, T["PluginSearch7"],
				windowToDisplay:GetHeight() - (88 + valToAdd), windowToDisplay:GetHeight() - (84 + valToAdd),
				Turbine.UI.Color.Green);
		end
	else
		valToAdd = isCharacterRow and 20 or 0;
		valToAdd = valToAdd + ((settings["displaySpentCash"]["value"] == true) and 45 or -10);
		if settings["displayTotalCash"]["value"] == false then valToAdd = valToAdd - 20; end
	end

	CreateMoneyRow(windowToDisplay, totalCash,
		windowToDisplay:GetHeight() - (64 + valToAdd), windowToDisplay:GetHeight() - (70 + valToAdd));
end

function DisplayBagCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = (settings["displaySpentCash"]["value"] == true) and 50 or -10;
	if windowToDisplay == UIShowWallet then valToAdd = 502; end

	CreateMoneySectionTitle(windowToDisplay, T["PluginSearch3"],
		windowToDisplay:GetHeight() - (114 + valToAdd), windowToDisplay:GetHeight() - (110 + valToAdd),
		Turbine.UI.Color.Red);
	CreateMoneyRow(windowToDisplay, totalCash,
		windowToDisplay:GetHeight() - (90 + valToAdd), windowToDisplay:GetHeight() - (96 + valToAdd));
end

function DisplayVaultCash(totalCash, windowToDisplay, namePlayerToshow)
	local valToAdd = (settings["displaySpentCash"]["value"] == true) and 50 or -10;
	if windowToDisplay == UIShowWallet then valToAdd = 440; end
	local bagCash = SavedCoinBags(namePlayerToshow);
	if bagCash <= 0 then valToAdd = 480; end

	CreateMoneySectionTitle(windowToDisplay, T["PluginSearch4"],
		windowToDisplay:GetHeight() - (134 + valToAdd), windowToDisplay:GetHeight() - (130 + valToAdd),
		Turbine.UI.Color.Blue);
	CreateMoneyRow(windowToDisplay, totalCash,
		windowToDisplay:GetHeight() - (110 + valToAdd), windowToDisplay:GetHeight() - (116 + valToAdd));
end

local function CreateCounter(windowToDisplay, iconTexture, iconX, textX, valToAdd, value)
	local icon = Turbine.UI.Label();
	icon:SetParent(windowToDisplay);
	icon:SetPosition(iconX, windowToDisplay:GetHeight() - (70 + valToAdd));
	icon:SetSize(25, 25);
	icon:SetBackground(iconTexture);
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	local text = Turbine.UI.Label();
	text:SetParent(windowToDisplay);
	text:SetSize(200, 30);
	text:SetPosition(textX, windowToDisplay:GetHeight() - (72 + valToAdd));
	text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	text:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	text:SetText(comma_value(value));
	text:SetForeColor(Turbine.UI.Color.Gold);
	return icon, text;
end

function DisplayDestinyPoints(windowToDisplay)
	local valToAdd = (windowToDisplay == UIShowWallet) and 450 or 0;
	local icon = CreateCounter(windowToDisplay, 0x411020E9, windowToDisplay:GetWidth() / 2 - 102,
		windowToDisplay:GetWidth() / 2 - 72, valToAdd, PlayerAttr:GetDestinyPoints());
	icon:SetZOrder(-1);
end

function DisplayLotroCoins(windowToDisplay, namePlayerToshow)
	local valToAdd = (windowToDisplay == UIShowWallet) and 450 or 0;
	local icon = CreateCounter(windowToDisplay, 0x411045ED, windowToDisplay:GetWidth() / 2 + 40,
		windowToDisplay:GetWidth() / 2 + 75, valToAdd, tonumber(settings["lotroCoins"]["value"]) or 0);
	icon:SetZOrder(10);
	icon:SetMouseVisible(true);

	AltHolicUtil.AttachFramedTooltip(icon, windowToDisplay, windowToDisplay:GetWidth() / 2 + 70,
		windowToDisplay:GetHeight() - (90 + valToAdd), 180, 30, T["PluginWalletWindow8"],
		{ font = Turbine.UI.Lotro.Font.Verdana16, backColor = TOOLTIP_PINK });

	icon.MouseClick = function()
		UIShowWallet:SetVisible(false);
		settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
		CreateUIShowLotro(namePlayerToshow);
		settings["isLotroWindowVisible"]["value"] = true;
		UIShowLotro:SetVisible(true);
	end
end

function DisplaySessionCash()
	local currentCash = math.max(0, tonumber(settings["sessionCash"]["cashSession"]) or 0);
	local valToAdd = 0;

	if settings["displaySpentCash"]["value"] == true then
		valToAdd = 10;
		CreateMoneySectionTitle(AltHolicWindow, T["PluginCashWindow3"],
			AltHolicWindow:GetHeight() - (85 + valToAdd), AltHolicWindow:GetHeight() - (78 + valToAdd),
			Turbine.UI.Color.Blue);
	end

	CreateMoneyRow(AltHolicWindow, currentCash,
		AltHolicWindow:GetHeight() - (55 + valToAdd), AltHolicWindow:GetHeight() - (61 + valToAdd));
	CreateMoneyCaption(AltHolicWindow, T["PluginCashWindow4"], AltHolicWindow:GetHeight() - (61 + valToAdd));
end

function DisplaySpentCash()
	local spentCash = math.max(0, tonumber(settings["sessionCash"]["cashSpent"]) or 0);
	CreateMoneyRow(AltHolicWindow, spentCash, AltHolicWindow:GetHeight() - 45, AltHolicWindow:GetHeight() - 51);
	CreateMoneyCaption(AltHolicWindow, T["PluginCashWindow5"], AltHolicWindow:GetHeight() - 51);
end

------------------------------------------------------------------------------------------
-- Character row tooltips + click actions
------------------------------------------------------------------------------------------
-- Race portrait: reputation window.
function DisplayGenderLabel(i, posx, posy, buttonToDisplay)
	if not IsFreePeoples(i) then return; end
	RowTooltip(buttonToDisplay, T["reputposition100"]);
	buttonToDisplay.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowReput; end,
			function() CreateUIShowReput(i); end, "isReputWindowVisible", "isReputWindowVisible", i);
	end
end

-- Delete icon: confirmation window.
function DisplayLabelDelete(i, posx, posy, buttonToDisplay)
	local nameLength = string.len(i);
	local font = Turbine.UI.Lotro.Font.Verdana20;
	if nameLength > 13 then
		font = Turbine.UI.Lotro.Font.Verdana14;
	elseif nameLength > 9 then
			font = Turbine.UI.Lotro.Font.Verdana18;
		end
		RowTooltip(buttonToDisplay, T["PluginDelete"] .. " " .. tostring(i), { font = font });

		buttonToDisplay.MouseClick = function()
			CreateToBeSurWindow(i, 1);
			ToBeSurWindow:SetVisible(true);
			settings["isToBeSurWindowVisible"]["value"] = true;
		end
	end

	-- Server icon: choose the character's server.
	function DisplayLabelServerName(i, posx, posy, buttonToDisplay)
		RowTooltip(buttonToDisplay, PlayerDatas[i].serverName);
		buttonToDisplay.MouseClick = function()
			AltHolicUtil.ToggleWindow(function() return ServerNameWindow; end,
				function() GenerateServerNameWindow(i); end, "isServerWindowVisible", "value", i);
		end
	end

	-- Level: stats window.
	function DisplayLabelStats(i, posx, posy, buttonToDisplay)
		if IsFreePeoples(i) then
			RowTooltip(buttonToDisplay, T["PluginStats11"], { zOrder = 40 });
		end
		buttonToDisplay.MouseClick = function()
			AltHolicUtil.ToggleWindow(function() return UIShowStats; end,
				function() CreateUIShowStats(i); end, "isShowStatsVisible", "isShowStatsVisible", i);
		end
	end

	-- Footer text of the main window: hovering it shows the AltHolic information window.
	function DisplayInfosWindow(posx, posy)
		local area = Turbine.UI.Extensions.SimpleWindow();
		area:SetParent(AltHolicWindow);
		area:SetPosition(posx, posy);
		area:SetSize(150, 20);
		area:SetVisible(true);
		area:SetZOrder(20);

		area.MouseEnter = function() AltHolicInfosWindow:SetVisible(true); end
		area.MouseLeave = function() AltHolicInfosWindow:SetVisible(false); end
	end

	------------------------------------------------------------------------------------------
	-- Hover label for an item shown as an icon (bag, vault, shared storage and search).
	-- The popup is positioned when it is shown, from the icon's real position inside the
	-- window, so it follows scrolled content instead of using the build-time coordinates.
	------------------------------------------------------------------------------------------
	function DisplayLabelForIcons(i, posx, posy, windowToDisplay, buttonToDisplay, texteNbr, texte)
		texte = tostring(texte or "");
		local width = math.max(150, string.len(texte) * 8);

		local popup = Turbine.UI.Extensions.SimpleWindow();
		popup:SetParent(windowToDisplay);
		popup:SetSize(width, 40);
		popup:SetVisible(false);
		popup:SetZOrder(20);
		popup:SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));

		local quantity = Turbine.UI.Label();
		quantity:SetParent(popup);
		quantity:SetPosition(2, 2);
		quantity:SetSize(width - 4, 36);
		quantity:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold18);
		quantity:SetText("  " .. tostring(texteNbr or ""));
		quantity:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		quantity:SetZOrder(21);
		quantity:SetForeColor(Turbine.UI.Color.Gold);
		quantity:SetBackColor(Turbine.UI.Color(0.95, 0.3, 0.3, 0.3));

		local name = Turbine.UI.Label();
		name:SetParent(popup);
		name:SetPosition(30, 2);
		name:SetSize(width - 34, 36);
		name:SetFont(Turbine.UI.Lotro.Font.BookAntiqua16);
		name:SetText(texte);
		name:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		name:SetZOrder(22);
		name:SetBackColor(Turbine.UI.Color(0.95, 0.3, 0.3, 0.3));

		buttonToDisplay.MouseEnter = function()
			local x, y = AltHolicUtil.GetOffsetWithin(buttonToDisplay, windowToDisplay);
			if x == nil then
				x, y = posx + 55, posy + 105;
			else
				x, y = x + 44, y + 34;
			end
			x = math.max(0, math.min(x, windowToDisplay:GetWidth() - width));
			popup:SetPosition(x, y);
			popup:SetVisible(true);
		end
		buttonToDisplay.MouseLeave = function()
			popup:SetVisible(false);
		end
	end

	------------------------------------------------------------------------------------------
	-- Small "+" buttons (add account / add epic book)
	------------------------------------------------------------------------------------------
	local function SmallButtonTooltip(trigger, parent, x, y, text)
		AltHolicUtil.AttachFramedTooltip(trigger, parent, x, y, 180, 30, text, {
				font = false, zOrder = 10000, labelZOrder = -1, backColor = Turbine.UI.Color(.6, .1, .4, .9),
			});
	end

	function DisplayLabel(val, positionLabelVert, positionLabelHori, textLabel, imageButton)
		local button = Turbine.UI.Extensions.SimpleWindow();
		button:SetParent(AltHolicWindow);
		button:SetPosition(positionLabelVert, positionLabelHori);
		button:SetSize(15, 15);
		button:SetVisible(true);

		local image = Turbine.UI.Label();
		image:SetParent(button);
		image:SetPosition(0, 0);
		image:SetSize(20, 20);
		image:SetBackground(ResourcePath .. imageButton);
		image:SetZOrder(-1);
		image:SetMouseVisible(false);

		SmallButtonTooltip(button, AltHolicWindow, positionLabelVert + 25, positionLabelHori - 5, textLabel);

		if val == 1 then
			button.MouseClick = function()
				CreateAddNewWindow();
				AltHolicWindow:SetVisible(false);
				AltHolicAddnewWindow:SetVisible(true);
			end
		end
	end

	function DisplayLabelEpique(val, positionLabelVert, positionLabelHori, textLabel, imageButton, whereToShow)
		local button = Turbine.UI.Control();
		button:SetParent(whereToShow);
		button:SetPosition(positionLabelVert, positionLabelHori);
		button:SetSize(15, 15);
		button:SetBackground(ResourcePath .. imageButton);
		button:SetZOrder(-1);
		button:SetMouseVisible(true);
		button:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		SmallButtonTooltip(button, whereToShow, positionLabelVert + 20, positionLabelHori - 25, textLabel);

		button.MouseClick = function()
			CreateAddNewWindowEpique(nil);
			AltHolicAddnewWindowEpique:SetVisible(true);
		end
	end

	------------------------------------------------------------------------------------------
	-- Profession popup (380x420 card listing up to four professions). Shared by the main
	-- character rows and the toolbar. options.iconOverlay / options.iconStretch reproduce the
	-- toolbar's original icon settings exactly; the row popup uses neither.
	------------------------------------------------------------------------------------------
	function CreateProfessionPopup(parent, professions, title, options)
		options = options or {};
		professions = professions or {};

		local popup = Turbine.UI.Extensions.SimpleWindow();
		popup:SetParent(parent);
		popup:SetSize(380, 420);
		popup:SetVisible(false);
		popup:SetZOrder(100);
		popup:SetBackground(ResourcePath .. "/Cadre_380_420.tga");

		local titleLabel = Turbine.UI.Label();
		titleLabel:SetParent(popup);
		titleLabel:SetPosition(40, 5);
		titleLabel:SetSize(300, 30);
		titleLabel:SetFont(Turbine.UI.Lotro.Font.TrajanProBold25);
		titleLabel:SetText(title or T["PluginCrafting"]);
		titleLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		titleLabel:SetZOrder(101);
		titleLabel:SetForeColor(Turbine.UI.Color.Gold);

		local function Text(text, x, y, width, height, font, color)
			local label = Turbine.UI.Label();
			label:SetParent(popup);
			label:SetPosition(x, y);
			label:SetSize(width, height);
			label:SetFont(font);
			label:SetText(text or "");
			label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
			label:SetZOrder(102);
			if color ~= nil then label:SetForeColor(color); end
			return label;
		end

		local visibleCount = math.min(#professions, 4);
		if visibleCount == 0 then
			local empty = Text(T["PluginNoCraftingData"], 40, 100, 300, 100, Turbine.UI.Lotro.Font.BookAntiquaBold22);
			empty:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
			return popup;
		end

		for index = 1, visibleCount do
			local profession = professions[index];
			local rowY = 48 + ((index - 1) * 88);

			Text(profession.Name or T["PluginUnknownProfession"], 65, rowY, 280, 24, Turbine.UI.Lotro.Font.TrajanProBold22);

			local icon = Turbine.UI.Label();
			icon:SetParent(popup);
			icon:SetPosition(25, rowY);
			icon:SetSize(32, 32);
			icon:SetZOrder(102);
			if options.iconOverlay then icon:SetBlendMode(Turbine.UI.BlendMode.Overlay); end
			local iconFile = profession.Icon or GetProfessionIconFile(profession.Key, profession.Name);
			if iconFile ~= nil then
				icon:SetBackground(ResourcePath .. iconFile);
				if options.iconStretch ~= nil then icon:SetStretchMode(options.iconStretch); end
			end

			Text(profession.CurrentLvl, 65, rowY + 23, 285, 30, Turbine.UI.Lotro.Font.BookAntiquaBold16, Turbine.UI.Color(0.8, 0.4, 0.2));
			Text(profession.CurrentMastery, 65, rowY + 50, 285, 30, Turbine.UI.Lotro.Font.BookAntiquaBold16, Turbine.UI.Color(1, 0.9, 0.5));
		end

		return popup;
	end

	------------------------------------------------------------------------------------------
	-- Profession icon strip on a character row (32x32 tiles + icons). This renderer is the
	-- result of a long debugging session; keep the control types, sizes, z-orders and
	-- stretch modes exactly as they are.
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

		DisplaySmallLabel(playerName, posx, posy, T[ "PluginCrafting" ],
			slotSize * slotCount, slotSize);
	end
	------------------------------------------------------------------------------------------
	-- Hover popup + click (crafting details window) for a character's profession strip.
	------------------------------------------------------------------------------------------
	local professionPopups = {};

	function DisplaySmallLabel(i, posx, posy, texte, triggerWidth, triggerHeight)
		if i == nil then i = PlayerName; end

		RefreshCurrentPlayerProfessions(i);
		local professions = GetSavedProfessions(i);

		-- Release the previous popup for this character before creating a new one.
		AltHolicUtil.DetachControl(professionPopups[i]);

		local hoverControl = Turbine.UI.Control();
		hoverControl:SetParent(viewport1.map);
		hoverControl:SetPosition(posx, posy);
		hoverControl:SetSize(triggerWidth or 45, triggerHeight or 45);
		hoverControl:SetVisible(true);
		hoverControl:SetZOrder(20);
		hoverControl:SetMouseVisible(true);
		-- No SetBackColor here: a Control given a back colour renders a washed-out grey panel
		-- over the icons even with alpha 0. Without one it is invisible but still gets mouse events.

		-- Tracked so PopulateWindow can detach it on the next rebuild.
		if CraftingHoverControls == nil then CraftingHoverControls = {}; end
		CraftingHoverControls[i] = hoverControl;

		local popup = CreateProfessionPopup(AltHolicWindow, professions, texte);
		professionPopups[i] = popup;

		local popupY = (Turbine.UI.Display:GetHeight() - popup:GetHeight()) / 2;
		if (Turbine.UI.Display:GetWidth() / 2) < tonumber(settings["windowPosition"]["xPos"]) then
			popup:SetPosition(posx - 900, popupY);
		else
			popup:SetPosition(posx + 242, popupY);
		end

		hoverControl.MouseEnter = function() popup:SetVisible(true); end
		hoverControl.MouseLeave = function() popup:SetVisible(false); end
		hoverControl.MouseClick = function()
			popup:SetVisible(false);
			OpenCraftingDetails(i);
		end
	end

	------------------------------------------------------------------------------------------
	-- Tooltips for the shared storage and search buttons of the main window
	------------------------------------------------------------------------------------------
	function DisplayLabelCadreForSharedStorage(posx, posy, texte, buttonToDisplay)
		AltHolicUtil.AttachFramedTooltip(buttonToDisplay, AltHolicWindow, posx + 40, posy - 5, 180, 30, texte);
	end

	function DisplayLabelCadreForSearch(posx, posy, buttonToDisplay, iconControl)
		AltHolicUtil.AttachFramedTooltip(buttonToDisplay, AltHolicWindow, posx + 40, posy - 5, 180, 30, T["PluginSearch2"], {
				onEnter = function() if iconControl ~= nil then iconControl:SetBackground(0x410D6DC3); end end,
				onLeave = function() if iconControl ~= nil then iconControl:SetBackground(0x410D6DC2); end end
			});
	end

	------------------------------------------------------------------------------------------
	-- Equipment item tooltip (offline characters; the live character uses the game tooltip)
	------------------------------------------------------------------------------------------
	-- Turbine.Gameplay.ItemQuality -> label key and colour.
	local ITEM_QUALITY_STYLE = {
		[0] = { key = "PluginQuality6", color = Turbine.UI.Color(1, 0.7, 0) },
		[1] = { key = "PluginQuality3", color = Turbine.UI.Color.Gold },
		[2] = { key = "PluginQuality2", color = Turbine.UI.Color(1, 0, 1) },
		[3] = { key = "PluginQuality4", color = Turbine.UI.Color(0, 0.66, 0.75) },
		[4] = { key = "PluginQuality5", color = Turbine.UI.Color(0.33, 0.66, 0.33) },
		[5] = { key = "PluginQuality1", color = Turbine.UI.Color(0.5, 0.5, 0.5) },
	};

	-- Slots that have no armour/DPS value worth showing.
	local NO_ARMOUR_SLOTS = {
		Bracelet1 = true, Bracelet2 = true, Earring1 = true, Earring2 = true, Ring1 = true, Ring2 = true,
		Necklace = true, CraftTool = true, ClassE = true, Pocket = true,
	};

	local function ArmourText(slotName, item)
		local armour = item.armor;
		if armour == nil or armour == 0 or armour == "" or NO_ARMOUR_SLOTS[slotName] then return ""; end
		if slotName == "PrimaryWeapon" or slotName == "RangedWeapon" then
			return "DPS : " .. tostring(armour);
		end
		if slotName == "Shield" and item.CAT ~= 33 then
			return "DPS : " .. comma_value(tostring(armour));
		end
		return T["PluginEquipement4"] .. " : " .. comma_value(tostring(armour));
	end

	local function DurabilityStyle(percent)
		if percent == -1 then return T["PluginNoDurability"], Turbine.UI.Color(0.4, 0.4, 0.4); end
		local colors = {
			[0] = Turbine.UI.Color.Red,
			[20] = Turbine.UI.Color(1, 0.7, 0),
			[99] = Turbine.UI.Color.Gold,
			[100] = Turbine.UI.Color.White,
		};
		return T["PluginDurability"] .. " : " .. tostring(percent) .. "%", colors[percent];
	end

	function DisplayLabelEquipment(i, posx, posy, namePlayerToshow, buttonToDisplay)
		local item = PlayerEquipement[namePlayerToshow][i];

		local card = Turbine.UI.Extensions.SimpleWindow();
		card:SetParent(UIShowEquip);
		card:SetPosition(posx + 120, UIShowEquip:GetHeight() - 450);
		card:SetSize(300, 300);
		card:SetVisible(false);
		card:SetZOrder(20);
		card:SetBackground(ResourcePath .. "/Cadre_300_300.tga");

		local function Line(text, x, y, width, height, zOrder)
			local label = Turbine.UI.Label();
			label:SetParent(card);
			label:SetPosition(x, y);
			label:SetSize(width, height);
			label:SetFont(Turbine.UI.Lotro.Font.BookAntiqua18);
			label:SetText(text or "");
			label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
			label:SetZOrder(zOrder or 21);
			return label;
		end

		-- Description (the API returns an "error" text for some items; hide it).
		local description = item.D;
		if description == nil or string.find(tostring(description), "error") ~= nil then description = ""; end
		local descriptionLabel = Line(T["PluginDescription"] .. " : \n" .. tostring(description), 10, 50, 280, 180);
		descriptionLabel:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft);

		-- Item icon on a slot frame.
		local frame = Turbine.UI.Label();
		frame:SetParent(card);
		frame:SetPosition(5, 5);
		frame:SetSize(40, 40);
		frame:SetBackground(0x410e8680);
		frame:SetZOrder(20);

		local background = Turbine.UI.Label();
		background:SetParent(frame);
		background:SetPosition(5, 5);
		background:SetSize(32, 32);
		background:SetBackground(tonumber(item.B));
		background:SetZOrder(20);

		local icon = Turbine.UI.Label();
		icon:SetParent(frame);
		icon:SetPosition(5, 5);
		icon:SetSize(32, 32);
		icon:SetBackground(tonumber(item.I));
		icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
		icon:SetZOrder(21);

		local nameLabel = Line(item.N, 55, 5, 245, 32);

		local level = tonumber(item.lvl) or 0;
		Line(level ~= 0 and (T["PluginEquipement3"] .. " : " .. tostring(item.lvl)) or "", 5, 230, 245, 32, 22);

		local armourLabel = Line(ArmourText(i, item), 5, 210, 245, 32, 22);
		armourLabel:SetForeColor(Turbine.UI.Color(1, 0.9, 0.5));

		-- Quality (incomparable items without an underlay are shown as legendary).
		local qualityLabel = Line("", 5, 250, 180, 32);
		local qualityStyle = ITEM_QUALITY_STYLE[item.QA];
		if item.QA == 2 and item.U == 0 then qualityStyle = ITEM_QUALITY_STYLE[1]; end
		if qualityStyle ~= nil then
			qualityLabel:SetText(T["PluginQuality"] .. " : " .. T[qualityStyle.key]);
			qualityLabel:SetForeColor(qualityStyle.color);
			nameLabel:SetForeColor(qualityStyle.color);
		end

		local durabilityText, durabilityColor = DurabilityStyle(AltHolicUtil.WearStatePercent(item.WS));
		local durabilityLabel = Line(durabilityText, 5, 270, 180, 32);
		if durabilityColor ~= nil then durabilityLabel:SetForeColor(durabilityColor); end

		buttonToDisplay.MouseEnter = function() card:SetVisible(true); end
		buttonToDisplay.MouseLeave = function() card:SetVisible(false); end
	end

	------------------------------------------------------------------------------------------
	-- Section title with underline (options windows)
	------------------------------------------------------------------------------------------
	function TitleDisplayer(windowToDisplay, posx, posy, textToDisplay, textColor, LineColor)
		local title = Turbine.UI.Label();
		title:SetParent(windowToDisplay);
		title:SetSize(300, 30);
		title:SetPosition(posx, posy - 15);
		title:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		title:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		title:SetText(textToDisplay);
		title:SetForeColor(textColor);

		local line = Turbine.UI.Label();
		line:SetParent(windowToDisplay);
		line:SetSize(300, 30);
		line:SetPosition(posx, posy - 10);
		line:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		line:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		line:SetText(UNDERLINE);
		line:SetForeColor(LineColor);
	end

	------------------------------------------------------------------------------------------
	-- Character name: hover shows the saved notes, click opens the notes editor
	------------------------------------------------------------------------------------------
	function DefineLabelInfo(i, posx, posy, buttonToDisplay)
		local preview = Turbine.UI.Extensions.SimpleWindow();
		preview:SetParent(AltHolicWindow);
		preview:SetPosition(posx, posy);
		preview:SetSize(380, 360);
		preview:SetVisible(false);
		preview:SetZOrder(20);

		local text = Turbine.UI.Lotro.TextBox();
		text:SetParent(preview);
		text:SetSize(380, 360);
		text:SetPosition(0, 0);
		text:SetText(PlayerInfos[i] and PlayerInfos[i].info or "");
		text:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		text:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
		text:SetBackColor(Turbine.UI.Color(.9, .5, .7, .5));

		if IsFreePeoples(i) then
			buttonToDisplay.MouseEnter = function()
				if PlayerInfos[i] ~= nil and PlayerInfos[i].info ~= "" then preview:SetVisible(true); end
			end
			buttonToDisplay.MouseLeave = function()
				preview:SetVisible(false);
			end
		end

		buttonToDisplay.MouseClick = function()
			AltHolicUtil.ToggleWindow(function() return InfoWindow; end,
				function() GenerateInfosWindow(i); end, "isInfoWindowVisible", "value", i);
		end
	end

	------------------------------------------------------------------------------------------
	-- "?" help button
	------------------------------------------------------------------------------------------
	local function CreateHelpButton(window, buttonX, buttonY, tooltipX, tooltipY, helpTopic)
		local helpButton = Turbine.UI.Control();
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

		local tooltip = Turbine.UI.Control();
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
		tooltipLabel:SetBackColor(TOOLTIP_PINK);
		tooltipLabel:SetZOrder(-1);

		helpButton.MouseEnter = function() tooltip:SetVisible(true); end
		helpButton.MouseLeave = function() tooltip:SetVisible(false); end
		helpButton.MouseClick = function()
			GenerateHelpWindow(helpTopic);
			HelpWindow:SetVisible(true);
			settings["isHelpWindowVisible"]["value"] = true;
		end

		return helpButton;
	end

	function DisplayHelpButton(window, windowWidth, helpTopic)
		return CreateHelpButton(window, windowWidth - 40, 55, windowWidth - 20, 25, helpTopic);
	end

	function DisplayHelpButtonV2(window, windowWidth, windowHeight, helpTopic)
		return CreateHelpButton(window, windowWidth - 40, windowHeight, windowWidth - 20, windowHeight - 25, helpTopic);
	end
