------------------------------------------------------------------------------------------
-- UI file: the main AltHolic window (account header + one row per character)
-- Written by Homeopatix, 26 january 2021
-- Reworked for AltHolic 5.06.
------------------------------------------------------------------------------------------

local ROW_HEIGHT = 45;

local function IsAccountNamed()
	return settings["nameAccount"]["account1"]["name"] ~= "";
end

-- 32x32 header button: an invisible SimpleWindow with the artwork in a child label.
local function HeaderIconButton(x, y, texture)
	local button = Turbine.UI.Extensions.SimpleWindow();
	button:SetParent(AltHolicWindow);
	button:SetPosition(x, y);
	button:SetSize(32, 32);
	button:SetVisible(true);

	local icon = Turbine.UI.Label();
	icon:SetParent(button);
	icon:SetPosition(0, 0);
	icon:SetSize(32, 32);
	icon:SetBackground(texture);
	icon:SetZOrder(-1);
	icon:SetMouseVisible(false);
	return button, icon;
end

-- 32x32 icon on a character row (inside the scrolling map).
local function RowIcon(x, y, texture, zOrder)
	local icon = Turbine.UI.Label();
	icon:SetParent(viewport1.map);
	icon:SetSize(32, 32);
	icon:SetPosition(x, y);
	if texture ~= nil then icon:SetBackground(texture); end
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	icon:SetZOrder(zOrder or 3);
	icon:SetMouseVisible(true);
	return icon;
end

------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
function CreateMainWindow(widthWind, heightWind)
	-- Dispose the previous Turbine control tree before rebuilding the main window.
	AltHolicUtil.DetachControl(AltHolicWindow);
	AltHolicWindow = nil;

	local valToAdd = (settings["displayServers"]["value"] == true) and 30 or 0;
	-- Extra width holds the 4x32px profession strip (plus the delete column when shown).
	if settings["displayDeleteIcon"]["value"] == true then
		widthWind = widthWind + 205 + valToAdd;
		valToAdd = valToAdd + 30;
	else
		widthWind = widthWind + 175 + valToAdd;
	end

	if Turbine.UI.Display:GetHeight() < heightWind then
		heightWind = Turbine.UI.Display:GetHeight() - 150;
	end

	AltHolicWindow = Turbine.UI.Lotro.GoldWindow();
	AltHolicWindow:SetSize(widthWind, heightWind);
	AltHolicWindow:SetText(T["PluginName"]);
	AltHolicWindow:SetZOrder(1);
	AltHolicWindow:SetWantsKeyEvents(true);
	AltHolicWindow:SetWantsUpdates(true);
	AltHolicWindow:SetPosition(settings["windowPosition"]["xPos"], settings["windowPosition"]["yPos"]);

	local footer = Turbine.UI.Label();
	footer:SetParent(AltHolicWindow);
	footer:SetSize(150, 10);
	footer:SetPosition(widthWind / 2 - 75, heightWind - 18);
	footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	footer:SetText(T["PluginText"]);
	DisplayInfosWindow(widthWind / 2 - 75, heightWind - 18);

	Birthday();
	UpdaterFromChat();

	if not IsAccountNamed() then
		DisplayLabel(1, 20, 40, T["PluginAddNew"], "AddNew.tga");
	end

	-- Scrolling character list: viewport1 clips, viewport1.map holds the rows.
	local mapHeight = #AltHolicUtil.GetDisplayedCharacterNames() * 46;
	local footerSpace = (settings["displaySpentCash"]["value"] == true) and 210 or 150;

	viewport1 = Turbine.UI.Control();
	viewport1:SetParent(AltHolicWindow);
	viewport1:SetSize(widthWind - 45, heightWind - footerSpace);
	viewport1:SetPosition(15, 75);

	viewport1.map = Turbine.UI.Control();
	viewport1.map:SetParent(viewport1);
	viewport1.map:SetSize(widthWind - 45, mapHeight);
	viewport1.map:SetPosition(0, 0);

	if IsAccountNamed() then
		PopulateWindow(valToAdd);
	end

	if mapHeight > viewport1:GetHeight() then
		local scrollbar = Turbine.UI.Lotro.ScrollBar();
		scrollbar:SetParent(AltHolicWindow);
		scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
		scrollbar:SetPosition(widthWind - 20, 70);
		scrollbar:SetSize(12, viewport1:GetHeight());
		scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
		scrollbar:SetMinimum(0);
		scrollbar:SetMaximum(mapHeight - viewport1:GetHeight());
		scrollbar:SetValue(0);
		scrollbar.ValueChanged = function()
			viewport1.map:SetTop(-scrollbar:GetValue());
		end
	end

	-- Money footer: logged-in character, optional account total and session figures.
	if settings["nameAccount"]["account1"]["nbrAlt"] >= 1 then
		DisplayCash(PlayerDatas[PlayerName].cash, AltHolicWindow, PlayerName);
		if settings["displayTotalCash"]["value"] == true then
			DisplayCash(AltHolicUtil.ComputeAccountCash(), AltHolicWindow);
		end
		if settings["displaySpentCash"]["value"] == true then
			DisplaySessionCash();
			DisplaySpentCash();
		end
	end

	-- Gold Tally button (bottom right).
	if IsAccountNamed() then
		HeaderIconButton(widthWind - 50, heightWind - 50, 0x41004641);
		DisplayCashWindow(widthWind - 50, heightWind - 50);
	end

	EscapeKeyHandler();
	PositionChangedWindow();
	ClosingTheWindow();

	if IsAccountNamed() then
		UpdateChecker();
	end
end

------------------------------------------------------------------------------------------
-- Inventory events and the 30-second maintenance tick
------------------------------------------------------------------------------------------
local function VerboseSaved(textKey)
	if settings["verbose"]["value"] == true then
		Write(rgb["start"] .. T["PluginName"] .. rgb["clear"] .. " - " .. T[textKey]);
	end
end

local inventoryHandlersInstalled = false;

local function InstallInventoryEventHandlers()
	if inventoryHandlersInstalled then return; end
	inventoryHandlersInstalled = true;

	-- Opening the vault / shared storage refreshes the whole container: save and redraw.
	vaultpack.ItemsRefreshed = function()
		vaultHasBeenUpdated = true;
		SavePlayerVault();
		UpdateMainWindow();
		UpdateBar();
		VerboseSaved("PluginVaultSaved");
	end

	sspack.ItemsRefreshed = function()
		sharedStorageHasBeenUpdated = true;
		SaveSharedStorage();
		UpdateMainWindow();
		UpdateBar();
		VerboseSaved("PluginSharedStorageSaved");
	end

	-- Individual item moves arrive in bursts; write each container once per burst.
	local function SaveVaultSoon()
		vaultHasBeenUpdated = true;
		AltHolicUtil.Defer("vault", 2, function()
			SavePlayerVault();
			VerboseSaved("PluginVaultSaved");
		end);
	end
	vaultpack.ItemAdded = SaveVaultSoon;
	vaultpack.ItemRemoved = SaveVaultSoon;

	local function SaveSharedStorageSoon()
		sharedStorageHasBeenUpdated = true;
		AltHolicUtil.Defer("sharedStorage", 2, function()
			SaveSharedStorage();
			VerboseSaved("PluginSharedStorageSaved");
		end);
	end
	sspack.ItemAdded = SaveSharedStorageSoon;
	sspack.ItemRemoved = SaveSharedStorageSoon;

	local function SaveBackpackSoon()
		AltHolicUtil.Defer("backpack", 2, function()
			SavePlayerBags();
			VerboseSaved("PluginBagSaved");
		end);
	end
	backpack.ItemAdded = SaveBackpackSoon;
	backpack.ItemRemoved = SaveBackpackSoon;
end

local UPDATE_INTERVAL_SECONDS = 30;
local nextMaintenanceUpdate = 0;

function UpdateChecker()
	InstallInventoryEventHandlers();
	nextMaintenanceUpdate = (Turbine.Engine.GetLocalTime() or 0) + UPDATE_INTERVAL_SECONDS;

	AltHolicWindow.Update = function()
		local now = Turbine.Engine.GetLocalTime() or 0;
		if now < nextMaintenanceUpdate or Player:IsInCombat() then return; end

		nextMaintenanceUpdate = now + UPDATE_INTERVAL_SECONDS;
		settings["nameAccount"]["account1"]["nbrAlt"] = tablelength(PlayerDatas);
		UpdateLvl();
		UpdateCash();
		FlushPlayerDatas();
	end
end

------------------------------------------------------------------------------------------
-- Account header and character rows
------------------------------------------------------------------------------------------
local function PopulateHeader(posx, posy, valToAdd)
	local account = settings["nameAccount"]["account1"];

	-- Account name.
	if IsAccountNamed() then
		local accountLabel = Turbine.UI.Label();
		accountLabel:SetParent(AltHolicWindow);
		accountLabel:SetSize(280, 30);
		accountLabel:SetPosition(55 + valToAdd, 40);
		accountLabel:SetFont(string.len(account["name"]) > 10
			and Turbine.UI.Lotro.Font.TrajanProBold25 or Turbine.UI.Lotro.Font.TrajanProBold30);
		accountLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
		accountLabel:SetText(account["name"]);
		accountLabel:SetForeColor(Turbine.UI.Color(1, 0.7, 0));
	end

	-- Expand / collapse the character list (0x41007E26 = minus, 0x41007E27 = plus).
	local expandButton = Turbine.UI.Extensions.SimpleWindow();
	expandButton:SetParent(AltHolicWindow);
	expandButton:SetPosition(posx + 280 + valToAdd, posy - 3);
	expandButton:SetSize(16, 16);
	expandButton:SetVisible(true);

	local expandIcon = Turbine.UI.Label();
	expandIcon:SetParent(expandButton);
	expandIcon:SetPosition(0, 0);
	expandIcon:SetSize(16, 16);
	expandIcon:SetZOrder(-1);
	expandIcon:SetMouseVisible(false);
	if IsAccountNamed() then
		expandIcon:SetBackground(account["isVisible"] == true and 0x41007E26 or 0x41007E27);
	end

	expandButton.MouseClick = function()
		account["isVisible"] = not (account["isVisible"] == true);
		UpdateMainWindow();
	end

	-- Shared storage.
	local sharedButton = HeaderIconButton(20, posy - 10, 0x4111BE35);
	sharedButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowSharedStorage; end,
			CreateUIShowSharedStorage, "isShowSharedStorageVisible", "isShowSharedStorageVisible");
	end
	DisplayLabelCadreForSharedStorage(20, posy - 10, T["PluginSharedStorage1"], sharedButton);

	-- XP overview.
	HeaderIconButton(55, posy - 10, 0x411A3870);
	DisplayXPWindow(55, posy - 10);

	-- Epic book tracker.
	if IsAccountNamed() then
		local epicButton = HeaderIconButton(90 + valToAdd, posy - 12, 0x41139D6B);
		epicButton:SetBackColor(Turbine.UI.Color.Red);
		DisplayEpiqueWindow(12, 90 + valToAdd, 40);
	end

	-- Search (0x410D6DC2 = magnifier, highlighted on hover).
	local searchButton, searchIcon = HeaderIconButton(posx + 325 + valToAdd, posy - 10, 0x410D6DC2);
	searchButton.MouseClick = function()
		AltHolicUtil.ToggleWindow(function() return UIShowSearch; end,
			function() CreateUISearch("**", "all", "lines"); end, "isSearchWindowVisible", "isSearchWindowVisible");
	end
	DisplayLabelCadreForSearch(posx + 325 + valToAdd, posy - 10, searchButton, searchIcon);
end

local function PopulateCharacterRow(name, posx, posy, valToAdd)
	local data = PlayerDatas[name];
	local isCurrent = (name == PlayerName);
	local rowY = posy + 30;

	-- Level (click: stats).
	local levelLabel = RowIcon(posx - 28 + valToAdd, rowY, nil, 10);
	local atCap = settings["displayLvlMax"]["value"] == true and data.lvl == LevelMax;
	levelLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	levelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	levelLabel:SetText(tostring(data.lvl));
	levelLabel:SetForeColor(atCap and Turbine.UI.Color.Red or Turbine.UI.Color.Lime);
	levelLabel:SetBackground(atCap and 0x4111219A or 0x4111219B);
	DisplayLabelStats(name, posx - 30 + valToAdd, posy, levelLabel);

	-- Server (click: choose server).
	if settings["displayServers"]["value"] == true then
		local serverIcon = RowIcon(posx - 64 + valToAdd, rowY, ResourcePath .. "Server_Icon.tga", 3);
		local serverIndex = ReturnValueServer(name);
		if serverIndex > 0 then
			local indexLabel = Turbine.UI.Label();
			indexLabel:SetParent(viewport1.map);
			indexLabel:SetSize(25, 20);
			indexLabel:SetPosition(posx - 60 + valToAdd, posy + 40);
			indexLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
			indexLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleRight);
			indexLabel:SetForeColor(Turbine.UI.Color.Red);
			indexLabel:SetText(tostring(serverIndex));
			indexLabel:SetZOrder(4);
			indexLabel:SetMouseVisible(true);
			DisplayLabelServerName(name, posx - 22 + valToAdd, posy, indexLabel);
		end
		DisplayLabelServerName(name, posx - 22 + valToAdd, posy, serverIcon);
	end

	-- Delete.
	if settings["displayDeleteIcon"]["value"] == true then
		local deleteIcon = RowIcon(posx - 36, rowY, 0x4111D248, 3);
		DisplayLabelDelete(name, posx - 36, posy, deleteIcon);
	end

	-- Crafting professions (modern per-profession data).
	DisplayProfessionIconsOnRow(name, posx + 352 + valToAdd, rowY);

	-- Backpack / vault / wallet.
	DisplayBag(name, posx + 70 + valToAdd, posy);
	DisplayVault(name, posx + 65 + valToAdd, posy);
	DisplayWallet(name, posx + 60 + valToAdd, posy);

	-- Race portrait (click: reputations).
	local raceButton = Turbine.UI.Control();
	raceButton:SetParent(viewport1.map);
	raceButton:SetPosition(posx + 9 + valToAdd, rowY);
	raceButton:SetSize(32, 32);
	raceButton:SetVisible(true);

	local raceIcon = Turbine.UI.Label();
	raceIcon:SetParent(raceButton);
	raceIcon:SetPosition(0, 0);
	raceIcon:SetSize(32, 32);
	raceIcon:SetZOrder(-1);
	raceIcon:SetMouseVisible(false);
	raceIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	AltHolicUtil.ApplyTexture(raceIcon, AltHolicUtil.GetRaceTexture(data, isCurrent));
	DisplayGenderLabel(name, posx + valToAdd, posy, raceButton);

	-- Class emblem (an invisible click area on top opens the equipment window).
	local classButton = Turbine.UI.Control();
	classButton:SetParent(viewport1.map);
	classButton:SetPosition(posx + 47 + valToAdd, rowY);
	classButton:SetSize(32, 32);
	classButton:SetVisible(true);

	local classIcon = Turbine.UI.Control();
	classIcon:SetParent(classButton);
	classIcon:SetPosition(0, 0);
	classIcon:SetSize(32, 32);
	classIcon:SetZOrder(-1);
	classIcon:SetMouseVisible(false);
	classIcon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	AltHolicUtil.ApplyTexture(classIcon, AltHolicUtil.GetClassTexture(data, isCurrent));
	DisplayEquipment(posx + 50 + valToAdd, rowY, name, data.align);

	-- Character name (hover: notes, click: notes editor); highlighted for the logged-in one.
	local notesArea = Turbine.UI.Control();
	notesArea:SetParent(viewport1.map);
	notesArea:SetPosition(127 + valToAdd, rowY);
	notesArea:SetSize(120, 32);
	notesArea:SetVisible(true);
	notesArea:SetZOrder(100);
	DefineLabelInfo(name, (Turbine.UI.Display:GetWidth() - 380) / 2, (Turbine.UI.Display:GetHeight() - 360) / 2, notesArea);

	local nameLabel = Turbine.UI.Label();
	nameLabel:SetParent(viewport1.map);
	nameLabel:SetSize(275 + valToAdd, 32);
	nameLabel:SetPosition(127 + valToAdd, rowY);
	nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
	nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	nameLabel:SetZOrder(1);
	nameLabel:SetText(name);

	if isCurrent then
		local isMonster = AltHolicUtil.MonsterRaces[data.rac] == true;
		nameLabel:SetForeColor(isMonster and Turbine.UI.Color.Gold or Turbine.UI.Color.Lime);

		local highlight = Turbine.UI.Label();
		highlight:SetParent(viewport1.map);
		highlight:SetZOrder(-1);
		highlight:SetSize(400, 32);
		highlight:SetPosition(8, rowY);
		highlight:SetBackColor(isMonster and Turbine.UI.Color(0.9, 1, 0.1, 0.1) or Turbine.UI.Color(0.9, 0.3, 0.3, 0.3));
	else
		nameLabel:SetForeColor(Turbine.UI.Color.White);
	end
end

function PopulateWindow(valToAdd)
	-- One profession scan per window build (see RefreshCurrentPlayerProfessions).
	InvalidateCurrentPlayerProfessions();

	-- Release the profession strip controls of the previous build (they are tracked
	-- separately because the strip was the subject of several rendering fixes).
	AltHolicUtil.DetachControls(CraftingRowControls);
	CraftingRowControls = {};
	AltHolicUtil.DetachControls(CraftingHoverControls);
	CraftingHoverControls = {};

	local posx = 40;
	local posy = 50;
	PopulateHeader(posx, posy, valToAdd);

	if settings["nameAccount"]["account1"]["isVisible"] ~= true then return; end

	posy = -20;
	for _, name in ipairs(AltHolicUtil.GetDisplayedCharacterNames()) do
		PopulateCharacterRow(name, posx, posy, valToAdd);
		posy = posy + ROW_HEIGHT;
	end
end
