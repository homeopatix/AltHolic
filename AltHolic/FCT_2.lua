------------------------------------------------------------------------------------------
-- FCT_2 file: the optional toolbar ("bar") along the top of the screen
-- Written by Homeopatix, 8 decembre 2021
-- Reworked for AltHolic 5.06: shared tooltip/toggle helpers, data-driven artwork.
------------------------------------------------------------------------------------------
local posx = 0;
local posy = 0;
local alreadyDisplayed = 0;

local TOOLTIP_PINK = Turbine.UI.Color(.9, .1, .4, .9);
local TOOLTIP_PINK_SOFT = Turbine.UI.Color(.8, .1, .4, .9);

-- Standard 180x30 framed tooltip under a toolbar icon.
local function BarTooltip(trigger, x, y, text, backColor, zOrder)
	return AltHolicUtil.AttachFramedTooltip(trigger, AltHolicBar, x, y, 180, 30, text, {
		backColor = backColor or TOOLTIP_PINK,
		zOrder = zOrder or 20,
	});
end

local function IsFreePeoples()
	return PlayerDatas[PlayerName] ~= nil and PlayerDatas[PlayerName].align == 1;
end

local function HasAccount()
	return settings["nameAccount"]["account1"]["name"] ~= "";
end

local function HasCharacters()
	return settings["nameAccount"]["account1"]["nbrAlt"] ~= 0;
end

-- 32x32 toolbar icon at the current layout position.
local function BarIcon(texture, x, y, zOrder, controlType)
	local icon = (controlType or Turbine.UI.Label)();
	icon:SetParent(AltHolicBar);
	icon:SetPosition(x, y);
	icon:SetSize(32, 32);
	if texture ~= nil then icon:SetBackground(texture); end
	icon:SetZOrder(zOrder or 2);
	icon:SetMouseVisible(true);
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	return icon;
end

------------------------------------------------------------------------------------------
-- Layout helpers
------------------------------------------------------------------------------------------
function SetPosX(posXPassed)
	if posXPassed == 0 or posXPassed == nil then
		return (posXPassed or 0) + 220;
	end
	if settings["displayLvlMax"]["value"] == true then
		return posXPassed + 40;
	end
	return posXPassed;
end

-- The money displays are wider than an icon; reserve their extra width once.
function AddIfCashDisplayed(valor)
	if alreadyDisplayed == 1 and settings["displayBarIcon6"]["value"] == true then
		valor = valor + 160;
		alreadyDisplayed = 0;
	end
	if alreadyDisplayed == 2 and settings["displayBarIcon15"]["value"] == true then
		valor = valor + 160;
		alreadyDisplayed = 0;
	end
	return valor;
end

------------------------------------------------------------------------------------------
-- Character name (click: notes window, hover: notes preview)
------------------------------------------------------------------------------------------
function DisplayNamePlayer_Bar()
	posx = 0;
	posy = 5;

	local nameLabel = Turbine.UI.Label();
	nameLabel:SetParent(AltHolicBar);
	nameLabel:SetPosition(posx, posy);
	nameLabel:SetSize(150, 40);
	nameLabel:SetText(PlayerName);
	nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	nameLabel:SetForeColor(Turbine.UI.Color.Gold);
	nameLabel:SetZOrder(2);
	nameLabel:SetMouseVisible(true);

	local notesPreview = Turbine.UI.Extensions.SimpleWindow();
	notesPreview:SetParent(AltHolicBar);
	notesPreview:SetPosition(screenWidth / 2 - 190, screenHeight / 2 - 180);
	notesPreview:SetSize(380, 360);
	notesPreview:SetVisible(false);
	notesPreview:SetZOrder(20);

	local notesText = Turbine.UI.Lotro.TextBox();
	notesText:SetParent(notesPreview);
	notesText:SetSize(380, 360);
	notesText:SetPosition(0, 0);
	notesText:SetText(PlayerInfos[PlayerName] and PlayerInfos[PlayerName].info or "");
	notesText:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	notesText:SetForeColor(Turbine.UI.Color(0.7, 0.6, 0.2));
	notesText:SetBackColor(Turbine.UI.Color(.9, .5, .7, .5));

	nameLabel.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return InfoWindow; end,
			function() GenerateInfosWindow(PlayerName); end, "isInfoWindowVisible", "value");
	end

	if IsFreePeoples() then
		nameLabel.MouseEnter = function()
			if PlayerInfos[PlayerName] ~= nil and PlayerInfos[PlayerName].info ~= "" then
				notesPreview:SetVisible(true);
			end
		end
		nameLabel.MouseLeave = function()
			notesPreview:SetVisible(false);
		end
	end
end

------------------------------------------------------------------------------------------
-- Level (click: stats window)
------------------------------------------------------------------------------------------
function DisplayLvlPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;

	local level = PlayerDatas[PlayerName].lvl;
	local atCap = settings["displayLvlMax"]["value"] == true and level == LevelMax;

	local levelLabel = Turbine.UI.Label();
	levelLabel:SetParent(AltHolicBar);
	levelLabel:SetPosition(posx, posy);
	levelLabel:SetSize(32, 32);
	levelLabel:SetText(tostring(level));
	levelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	levelLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	levelLabel:SetForeColor(atCap and Turbine.UI.Color.Red or Turbine.UI.Color.Lime);
	levelLabel:SetBackground(atCap and 0x4111219A or 0x4111219B);
	levelLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	levelLabel:SetZOrder(2);
	levelLabel:SetMouseVisible(true);

	if IsFreePeoples() then
		BarTooltip(levelLabel, posx + 20, posy + 40, T["PluginStats11"], TOOLTIP_PINK, 40);
	end

	levelLabel.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowStats; end,
			function() CreateUIShowStats(PlayerName); end, "isShowStatsVisible", "isShowStatsVisible", PlayerName);
	end
end

------------------------------------------------------------------------------------------
-- XP (click: XP window)
------------------------------------------------------------------------------------------
function DisplayXPWindow_Bar()
	posx = SetPosX(posx);
	posy = 9;

	local xpButton = BarIcon(0x411A3870, posx, posy, 30);
	BarTooltip(xpButton, posx + 20, posy + 40, T["PluginXPWindow1"], TOOLTIP_PINK_SOFT);

	xpButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowXP; end, CreateUIShowXP, "isXPWindowVisible", "value");
	end
end

------------------------------------------------------------------------------------------
-- Race portrait (click: reputation window)
------------------------------------------------------------------------------------------
function DisplayRacePlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;

	local raceIcon = BarIcon(nil, posx, posy, 2);
	if HasAccount() then
		AltHolicUtil.ApplyTexture(raceIcon, AltHolicUtil.GetRaceTexture(PlayerDatas[PlayerName], true));
	end

	if IsFreePeoples() then
		BarTooltip(raceIcon, posx + 20, posy + 40, T["reputposition100"]);
		raceIcon.MouseClick = function()
			AltHolicUtil.ToggleWindow(function() return UIShowReput; end,
				function() CreateUIShowReput(PlayerName); end, "isReputWindowVisible", "isReputWindowVisible", PlayerName);
		end
	end
end

------------------------------------------------------------------------------------------
-- Class emblem (click: equipment window)
------------------------------------------------------------------------------------------
function DisplayClassPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;

	local classIcon = BarIcon(nil, posx, posy, 2, Turbine.UI.Control);
	if HasAccount() then
		AltHolicUtil.ApplyTexture(classIcon, AltHolicUtil.GetClassTexture(PlayerDatas[PlayerName], false));
	end

	if IsFreePeoples() then
		BarTooltip(classIcon, posx + 10, posy + 40, T["PluginEquipmentLabel"]);
	end

	classIcon.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowEquip; end, function()
			SavePlayerEquipment();
			CreateUIShowEquip(PlayerName, PlayerDatas[PlayerName].align);
		end, "isShowEquipmentVisible", "isShowEquipmentVisible", PlayerName);
	end
end

------------------------------------------------------------------------------------------
-- Server (click: choose the character's server)
------------------------------------------------------------------------------------------
function DisplayLabelServerNameForBar(x, y, buttonToDisplay)
	BarTooltip(buttonToDisplay, SetPosX(x), y, PlayerDatas[PlayerName].serverName);

	buttonToDisplay.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return ServerNameWindow; end,
			function() GenerateServerNameWindow(PlayerName); end, "isServerWindowVisible", "value");
	end
end

function DisplayServerPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	if not HasAccount() or settings["displayServers"]["value"] ~= true then return; end

	local serverIcon = BarIcon(ResourcePath .. "Server_Icon.tga", posx, posy, 3);
	local serverIndex = ReturnValueServer(PlayerName);

	if serverIndex > 0 then
		local indexLabel = Turbine.UI.Label();
		indexLabel:SetParent(AltHolicBar);
		indexLabel:SetSize(25, 20);
		indexLabel:SetPosition(posx, posy + 10);
		indexLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		indexLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		indexLabel:SetForeColor(Turbine.UI.Color.Red);
		indexLabel:SetText(tostring(serverIndex));
		indexLabel:SetZOrder(4);
		indexLabel:SetMouseVisible(true);
		DisplayLabelServerNameForBar(posx + 10, posy + 40, indexLabel);
	end

	DisplayLabelServerNameForBar(posx + 10, posy + 40, serverIcon);
end

------------------------------------------------------------------------------------------
-- Money
------------------------------------------------------------------------------------------
local BAR_MONEY_PARTS = {
	{ texture = 0x41007e7b, color = Turbine.UI.Color.Gold, iconX = 0, textX = 30 },
	{ texture = 0x41007e7c, color = Turbine.UI.Color.Silver, iconX = 70, textX = 100 },
	{ texture = 0x41007e7d, color = Turbine.UI.Color(0.8, 0.4, 0.2), iconX = 140, textX = 170 },
};

local function DisplayMoneyOnBar(value, x, y)
	local gold, silver, copper = AltHolicUtil.MoneyParts(value);
	local values = { gold, silver, copper };

	for index, part in ipairs(BAR_MONEY_PARTS) do
		local icon = Turbine.UI.Label();
		icon:SetParent(AltHolicBar);
		icon:SetPosition(x + part.iconX, y + 5);
		icon:SetSize(27, 21);
		icon:SetBackground(part.texture);
		icon:SetZOrder(-1);
		icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

		local amount = Turbine.UI.Label();
		amount:SetParent(AltHolicBar);
		amount:SetSize(50, 30);
		amount:SetPosition(x + part.textX, y);
		amount:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		amount:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
		amount:SetText(string.format("%.0f", values[index]));
		amount:SetForeColor(part.color);
	end
end

function DisplayCashForBar(totalCash, x, y)
	if totalCash == nil or totalCash == 0 then
		totalCash = PlayerAttr:GetMoney();
	end
	DisplayMoneyOnBar(totalCash, x, y);
end

function DisplayCashOfPlayer_Bar()
	posx = SetPosX(posx);
	posy = 9;
	if settings["nameAccount"]["account1"]["nbrAlt"] < 1 then return; end

	DisplayCashForBar(PlayerDatas[PlayerName].cash, posx, posy - 10);
	DisplayCashForBar(AltHolicUtil.ComputeAccountCash(), posx, posy + 10);
	alreadyDisplayed = 1;
end

function DisplaySessionCash_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;

	DisplayMoneyOnBar(math.max(0, tonumber(settings["sessionCash"]["cashSession"]) or 0), posx, posy - 10);
	DisplayMoneyOnBar(math.max(0, tonumber(settings["sessionCash"]["cashSpent"]) or 0), posx, posy + 10);
	alreadyDisplayed = 2;
end

function DisplayTotalCash_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if not HasAccount() then return; end

	local cashButton = BarIcon(0x41004641, posx, posy, 2);
	local tooltip = AltHolicUtil.AttachFramedTooltip(cashButton, AltHolicBar, posx - 60, posy + 40, 190, 30,
		T["PluginGoldTallyOpenTooltip"], { font = Turbine.UI.Lotro.Font.Verdana14, backColor = TOOLTIP_PINK });

	cashButton.MouseClick = function()
		tooltip:SetVisible(false);
		ToggleUIShowCash();
	end
end

------------------------------------------------------------------------------------------
-- Wallet / vault / backpack / shared storage
------------------------------------------------------------------------------------------
function DisplayWalletButton_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if not HasCharacters() then return; end

	local walletButton = BarIcon(0x411D028B, posx, posy, 10, Turbine.UI.Control);
	BarTooltip(walletButton, posx + 20, posy + 40, T["PluginSearch7"]);

	walletButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowWallet; end,
			function() CreateUIShowWallet(PlayerName); end, "isShowWalletVisible", "isShowWalletVisible", PlayerName);
	end
end

function DisplayVaultButton_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if not HasCharacters() then return; end

	local vaultButton = BarIcon(IsFreePeoples() and 0x410E76AE or nil, posx, posy, 10, Turbine.UI.Control);
	BarTooltip(vaultButton, posx + 20, posy + 40, T["PluginSearch4"]);

	vaultButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowVault; end,
			function() CreateUIShowVault(PlayerName); end, "isShowVaultVisible", "isShowVaultVisible", PlayerName);
	end
end

-- Legacy vocation bag artwork (explorer, jeweller, yeoman, historian, armourer, woodsman,
-- tinker), selected by the saved vocation index when "class bags" is enabled.
local VOCATION_BAG_ICONS = { 0x410FC45F, 0x410F467E, 0x410F4682, 0x410F4684, 0x410F4688, 0x410F4686, 0x410F4680 };

local function BagTexture()
	local data = PlayerDatas[PlayerName];
	if data.align ~= 1 then return 0x410F4B84; end
	if settings["displayClassBags"]["value"] ~= true then return 0x410FC45F; end
	if data.voc == 0 then return 0x41105F73; end -- no vocation bag
	return VOCATION_BAG_ICONS[data.voc] or 0x410FC45F;
end

function DisplayBagButton_Bar()
	local showSize = settings["displayBarBagSize"]["value"] == true;
	posx = SetPosX(AddIfCashDisplayed(showSize and posx + 40 or posx));
	posy = 9;
	if not HasCharacters() then return; end

	local bagButton = BarIcon(BagTexture(), posx, posy, 10, Turbine.UI.Control);

	if showSize then
		local itemCount = tablelength(PlayerBags[PlayerName]);
		local bagSize = backpack:GetSize();

		local countLabel = Turbine.UI.Label();
		countLabel:SetParent(AltHolicBar);
		countLabel:SetPosition(posx - 47, posy);
		countLabel:SetSize(20, 40);
		countLabel:SetText(tostring(itemCount));
		countLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		countLabel:SetForeColor((bagSize - itemCount) <= 10 and Turbine.UI.Color.Red or Turbine.UI.Color.White);
		countLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold14);

		local sizeLabel = Turbine.UI.Label();
		sizeLabel:SetParent(AltHolicBar);
		sizeLabel:SetPosition(posx - 50, posy);
		sizeLabel:SetSize(50, 40);
		sizeLabel:SetText("/" .. bagSize);
		sizeLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
		sizeLabel:SetForeColor(Turbine.UI.Color.White);
		sizeLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold14);
	end

	BarTooltip(bagButton, posx + 20, posy + 40, T["PluginSearch3"]);

	bagButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowBag; end, function()
			SavePlayerBags();
			CreateUIShowBag(PlayerName);
		end, "isShowBagVisible", "isShowBagVisible", PlayerName);
	end
end

function DisplaySharedStorage_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;

	local sharedButton = BarIcon(0x4111BE35, posx, posy, 2);
	AltHolicUtil.AttachFramedTooltip(sharedButton, AltHolicBar, posx + 10, posy + 40, 180, 30, T["PluginSharedStorage1"]);

	sharedButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowSharedStorage; end,
			CreateUIShowSharedStorage, "isShowSharedStorageVisible", "isShowSharedStorageVisible");
	end
end

------------------------------------------------------------------------------------------
-- Professions (hover: profession popup; RecipeTracker click-through when installed)
------------------------------------------------------------------------------------------
function DisplayProfessions_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx - 5));
	posy = 2;

	RefreshCurrentPlayerProfessions(PlayerName);
	local professions = GetSavedProfessions(PlayerName);

	-- Up to four 32x32 profession icons in a strip. A 32x32 control with the 32x32 file
	-- texture and StretchMode(1) is the configuration proven to render (see
	-- GetProfessionSmallIconFile); do not change it.
	local drawn = 0;
	for index = 1, #professions do
		local iconFile = GetProfessionSmallIconFile(professions[index].Key, professions[index].Name);
		if iconFile ~= nil then
			local icon = Turbine.UI.Label();
			icon:SetParent(AltHolicBar);
			icon:SetPosition(posx + (drawn * 32), posy + 6);
			icon:SetSize(32, 32);
			icon:SetZOrder(5);
			icon:SetMouseVisible(false);
			icon:SetVisible(true);
			icon:SetBackground(ResourcePath .. iconFile);
			icon:SetStretchMode(1);
			drawn = drawn + 1;
			if drawn >= 4 then break; end
		end
	end

	-- The strip is 128px wide but the layout only advances 40px per element.
	posx = posx + 88;

	DisplayProfessionTooltipForBar(T["PluginCrafting"], professions);
end

function DisplayProfessionTooltipForBar(texte, professions)
	if professions == nil then
		RefreshCurrentPlayerProfessions(PlayerName);
		professions = GetSavedProfessions(PlayerName);
	end

	local hoverControl = Turbine.UI.Control();
	hoverControl:SetParent(AltHolicBar);
	hoverControl:SetPosition(posx, 2);
	hoverControl:SetSize(45, 45);
	hoverControl:SetVisible(true);
	hoverControl:SetZOrder(19);
	hoverControl:SetMouseVisible(true);

	local popup = CreateProfessionPopup(AltHolicBar, professions, texte, { iconOverlay = true, iconStretch = 2 });
	popup:SetPosition(
		(Turbine.UI.Display:GetWidth() - popup:GetWidth()) / 2,
		(Turbine.UI.Display:GetHeight() - popup:GetHeight()) / 2
	);

	if AltHolicUtil.IsPluginAvailable("RecipeTracker v2") then
		local releaseWindow = Turbine.UI.Extensions.SimpleWindow();
		releaseWindow:SetSize(45, 45);
		releaseWindow:SetParent(hoverControl);
		releaseWindow:SetPosition(0, 0);
		releaseWindow:SetOpacity(0);
		releaseWindow:SetVisible(true);

		local releaseQSBack = Turbine.UI.Control();
		releaseQSBack:SetParent(releaseWindow);
		releaseQSBack:SetZOrder(-1);
		releaseQSBack:SetSize(45, 45);

		local releaseQS = Turbine.UI.Lotro.Quickslot();
		releaseQS:SetParent(releaseQSBack);
		releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, "/recipetracker show"));
		releaseQS:SetSize(45, 45);
		releaseQS:SetPosition(0, 0);
		releaseQS:SetAllowDrop(false);
		releaseQS:SetOpacity(0);
		releaseQS:SetZOrder(-1);
	end

	hoverControl.MouseEnter = function() popup:SetVisible(true); end
	hoverControl.MouseLeave = function() popup:SetVisible(false); end
end

------------------------------------------------------------------------------------------
-- Epic books / search
------------------------------------------------------------------------------------------
function DisplayEpiqueBook_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if not HasAccount() then return; end

	local epicButton = BarIcon(0x41139D6B, posx, posy, 2);
	BarTooltip(epicButton, posx + 10, posy + 40, T["PluginEpiqueWindow1"], TOOLTIP_PINK_SOFT);

	epicButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowEpique; end,
			CreateUIShowEpique, "isEpiqueWindowVisible", "isEpiqueWindowVisible");
	end
end

function DisplayLoupe_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;

	-- 0x410D6DC2 = magnifier, 0x410D6DC3 = highlighted magnifier.
	local searchButton = BarIcon(0x410D6DC2, posx, posy, 2);
	AltHolicUtil.AttachFramedTooltip(searchButton, AltHolicBar, posx + 10, posy + 40, 180, 30, T["PluginSearch2"], {
		backColor = TOOLTIP_PINK_SOFT,
		onEnter = function() searchButton:SetBackground(0x410D6DC3); end,
		onLeave = function() searchButton:SetBackground(0x410D6DC2); end,
	});

	searchButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowSearch; end,
			function() CreateUISearch("**", "all", "lines"); end, "isSearchWindowVisible", "isSearchWindowVisible");
	end
end

------------------------------------------------------------------------------------------
-- Launch other plugins (Tokens) / toggle the AltHolic main window
------------------------------------------------------------------------------------------
local function CreateAliasButton(x, y, alias, iconFile)
	local releaseWindow = Turbine.UI.Extensions.SimpleWindow();
	releaseWindow:SetSize(40, 40);
	releaseWindow:SetParent(AltHolicBar);
	releaseWindow:SetPosition(x, y);
	releaseWindow:SetOpacity(0);
	releaseWindow:SetFadeSpeed(0.5);
	releaseWindow:SetVisible(true);
	releaseWindow:SetBackColor(Turbine.UI.Color(.6, .5, .7, .5));

	local icon = Turbine.UI.Label();
	icon:SetParent(AltHolicBar);
	icon:SetPosition(x, y);
	icon:SetSize(32, 32);
	icon:SetMouseVisible(false);
	icon:SetBackground(ResourcePath .. iconFile);
	icon:SetZOrder(50);

	if alias ~= nil then
		local releaseQSBack = Turbine.UI.Control();
		releaseQSBack:SetParent(releaseWindow);
		releaseQSBack:SetZOrder(-1);
		releaseQSBack:SetSize(40, 40);

		local releaseQS = Turbine.UI.Lotro.Quickslot();
		releaseQS:SetParent(releaseQSBack);
		releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, alias));
		releaseQS:SetSize(40, 40);
		releaseQS:SetPosition(0, 0);
		releaseQS:SetAllowDrop(false);
	end
	return releaseWindow;
end

function DisplayTokensIcon_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;
	if settings["displayTokensIcon"]["value"] == true and AltHolicUtil.IsPluginReady("Tokens", true) then
		CreateAliasButton(posx, posy, T["PluginReleaseAliasTokens"], "Tokens.tga");
	end
end

function DisplayAltHolicIcon_Bar()
	posx = SetPosX(AddIfCashDisplayed(posx));
	posy = 9;

	local launcher = CreateAliasButton(posx, posy, nil, "AltHolic.tga");
	launcher:SetMouseVisible(true);
	launcher.MouseClick = function()
		local account = settings["nameAccount"]["account1"];
		if AltHolicWindow ~= nil and AltHolicWindow:IsVisible() then
			account["isVisible"] = false;
			HideMainWindow();
		else
			account["isVisible"] = true;
			settings["isWindowVisible"]["isWindowVisible"] = true;
			UpdateMainWindow(true);
		end
	end
end
