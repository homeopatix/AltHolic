------------------------------------------------------------------------------------------
-- Backpack, vault and shared-storage windows
-- Originally three separate ~250-line copies by Homeopatix; merged into one builder for
-- AltHolic 5.06. Lines mode lists items with names, icons mode shows a 9-wide grid.
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 430;
local ROW_HEIGHT = 60;
local ICON_SIZE = 56;
local ICON_GAP = 18;
local ICONS_PER_ROW = 5;
local MAX_LIST_HEIGHT = 540;
local MAX_CONTENT_HEIGHT = 640;

local NAME_BACK_COLOR = Turbine.UI.Color(0.9, 0.3, 0.3, 0.3);

local function CreateSlot(parent, item, x, y)
	local slot = Turbine.UI.Control();
	slot:SetParent(parent);
	slot:SetSize(ICON_SIZE + 8, ICON_SIZE + 8);
	slot:SetPosition(x, y);
	slot:SetVisible(true);
	slot:SetBackground(0x41000001);

	local icon = AltHolicUtil.CreateStoredItemIcon(slot, item, 1, 1);
	if icon ~= nil then
		icon:SetSize(ICON_SIZE, ICON_SIZE);
		icon:SetPosition(4, 4);
		icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
		icon:SetVisible(true);
	end

	return slot, icon;
end

local function CreateLineRow(listbox, item)
	local row = Turbine.UI.Control();
	row:SetSize(WINDOW_WIDTH - 55, ROW_HEIGHT);
	row:SetMouseVisible(true);

	CreateSlot(row, item, 12, 6);

	local namePanel = Turbine.UI.Control();
	namePanel:SetParent(row);
	namePanel:SetSize(300, 32);
	namePanel:SetPosition(70, 8);
	namePanel:SetBackColor(NAME_BACK_COLOR);

	local nameLabel = Turbine.UI.Label();
	nameLabel:SetParent(namePanel);
	nameLabel:SetSize(300, 32);
	nameLabel:SetPosition(1, 1);
	nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	nameLabel:SetMarkupEnabled(true);
	nameLabel:SetText(rgb["gold"] .. tostring(item.QUA or "") .. rgb["clear"] .. " " .. tostring(item.N or ""));
	nameLabel:SetBackColor(NAME_BACK_COLOR);

	listbox:AddItem(row);
end

local function AddScrollBar(window, x, y, height, contentControl, contentHeight)
	local scrollbar = Turbine.UI.Lotro.ScrollBar();
	scrollbar:SetParent(window);
	scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
	scrollbar:SetPosition(x, y);
	scrollbar:SetSize(10, height);
	scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
	scrollbar:SetMinimum(0);

	local maxValue = math.max(0, contentHeight - height);
	scrollbar:SetMaximum(maxValue);
	scrollbar:SetValue(0);
	scrollbar:SetVisible(true);
	scrollbar:SetEnabled(maxValue > 0);

	scrollbar.ValueChanged = function()
		contentControl:SetTop(-scrollbar:GetValue());
	end

	return scrollbar;
end

-- Item capacity saved alongside the items (e.g. "BSIZE" = backpack size).
local function SavedCapacity(items, slots, field)
	for index = #slots, 1, -1 do
		local item = items[slots[index]];
		if item ~= nil and item[field] ~= nil then return item[field]; end
	end
	return "";
end

------------------------------------------------------------------------------------------
-- spec = { items, title, countKey, emptyKey, capacityField, setting = {group, field}, rebuild }
------------------------------------------------------------------------------------------
local function BuildStorageWindow(spec)
	local items = spec.items or {};
	local slots = AltHolicUtil.SortedItemSlots(items);
	local count = #slots;
	local iconMode = settings["displayIcon"]["value"] == true;

	local rows = iconMode and math.ceil(count / ICONS_PER_ROW) or count;
	local contentHeight = rows * (ICON_SIZE + ICON_GAP) + 12;
	local viewHeight = math.min(contentHeight + 10, MAX_LIST_HEIGHT);

	local windowHeight = math.min(contentHeight + 90, MAX_CONTENT_HEIGHT) + 110;
	windowHeight = math.min(windowHeight, Turbine.UI.Display:GetHeight() - 50);

	local window = Turbine.UI.Lotro.GoldWindow();
	window:SetSize(WINDOW_WIDTH, windowHeight);
	window:SetText(spec.title);
	window:SetPosition((Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2, (Turbine.UI.Display:GetHeight() - windowHeight) / 2);
	window:SetZOrder(10);
	window:SetWantsKeyEvents(true);
	window:SetVisible(false);

	-- Lines / icons toggle (shared preference for all storage windows).
	local function SwitchMode(useIcons)
		settings["displayIcon"]["value"] = useIcons;
		local rebuilt = spec.rebuild();
		rebuilt:SetVisible(true);
	end
	AltHolicUtil.CreateDisplayModeButtons(window, WINDOW_WIDTH, 40, iconMode,
		function() SwitchMode(false); end,
		function() SwitchMode(true); end);

	AltHolicUtil.CreateLabel(window, T["PluginText"], WINDOW_WIDTH / 2 - 75, windowHeight - 20, 150, 10, {
		align = Turbine.UI.ContentAlignment.MiddleCenter,
	});

	if count >= 1 then
		AltHolicUtil.CreateLabel(window,
			T[spec.countKey] .. count .. " / " .. tostring(SavedCapacity(items, slots, spec.capacityField)),
			WINDOW_WIDTH / 2 - 150, windowHeight - 90, 300, 40, {
				font = Turbine.UI.Lotro.Font.BookAntiquaBold19,
				align = Turbine.UI.ContentAlignment.MiddleCenter,
			});
	elseif spec.emptyKey ~= nil then
		AltHolicUtil.CreateLabel(window, T[spec.emptyKey], WINDOW_WIDTH / 2 - 150, windowHeight - 110, 300, 30, {
			align = Turbine.UI.ContentAlignment.MiddleCenter,
		});
	end

	local group, field = spec.setting[1], spec.setting[2];
	AltHolicUtil.CreateCloseButton(window, T["PluginCloseButton"], windowHeight - 50, function()
		settings[group][field] = false;
		window:SetVisible(false);
	end, 300, WINDOW_WIDTH / 2 - 125);

	if not iconMode then
		local listbox = Turbine.UI.ListBox();
		listbox:SetParent(window);
		listbox:SetSize(WINDOW_WIDTH - 55, viewHeight);
		listbox:SetPosition(10, 80);
		listbox:SetMouseVisible(true);
		listbox:SetZOrder(20);

		for _, key in ipairs(slots) do
			CreateLineRow(listbox, items[key]);
		end

		local scrollbar = AddScrollBar(window, WINDOW_WIDTH - 23, 80, viewHeight, listbox, contentHeight + 10);
		listbox:SetVerticalScrollBar(scrollbar);
	else
		local viewport = Turbine.UI.Control();
		viewport:SetParent(window);
		viewport:SetSize(WINDOW_WIDTH - 25, viewHeight);
		viewport:SetPosition(10, 70);

		local map = Turbine.UI.Control();
		map:SetParent(viewport);
		map:SetSize(WINDOW_WIDTH - 45, contentHeight + 20);
		map:SetPosition(0, 0);

		for index, key in ipairs(slots) do
			local item = items[key];
			local column = (index - 1) % ICONS_PER_ROW;
			local row = math.floor((index - 1) / ICONS_PER_ROW);

			local x = 18 + column * (ICON_SIZE + ICON_GAP);
			local y = 8 + row * (ICON_SIZE + ICON_GAP);

			local _, icon = CreateSlot(map, item, x, y);
			DisplayLabelForIcons(index, x, y, window, icon, item.QUA, item.N);
		end

		local scrollbar = AddScrollBar(window, WINDOW_WIDTH - 23, 70, viewHeight, map, contentHeight + 20);
		map:SetTop(0);
	end

	window.Closing = function()
		settings[group][field] = false;
	end
	EscapeKeyHandlerForWindows(window, group, field);
	return window;
end

------------------------------------------------------------------------------------------
-- Public builders (the window objects stay global: other modules toggle them)
------------------------------------------------------------------------------------------
function CreateUIShowBag(namePlayerToshow)
	AltHolicUtil.DetachControl(UIShowBag);
	UIShowBag = BuildStorageWindow({
		items = PlayerBags[namePlayerToshow],
		title = T["PluginBag1"] .. tostring(namePlayerToshow),
		countKey = "PluginBag2",
		capacityField = "BSIZE",
		setting = { "isShowBagVisible", "isShowBagVisible" },
		rebuild = function() return CreateUIShowBag(namePlayerToshow); end,
	});
	UIShowBag.altHolicKey = namePlayerToshow;
	return UIShowBag;
end

function CreateUIShowVault(namePlayerToshow)
	AltHolicUtil.DetachControl(UIShowVault);
	UIShowVault = BuildStorageWindow({
		items = PlayerVault[namePlayerToshow],
		title = T["PluginVault1"] .. tostring(namePlayerToshow),
		countKey = "PluginVault2",
		emptyKey = "PluginVault3",
		capacityField = "VSIZE",
		setting = { "isShowVaultVisible", "isShowVaultVisible" },
		rebuild = function() return CreateUIShowVault(namePlayerToshow); end,
	});
	UIShowVault.altHolicKey = namePlayerToshow;
	return UIShowVault;
end

function CreateUIShowSharedStorage()
	AltHolicUtil.DetachControl(UIShowSharedStorage);
	UIShowSharedStorage = BuildStorageWindow({
		items = SharedStorageVault,
		title = T["PluginSharedStorage1"],
		countKey = "PluginSharedStorage2",
		emptyKey = "PluginSharedStorage3",
		capacityField = "VSIZE",
		setting = { "isShowSharedStorageVisible", "isShowSharedStorageVisible" },
		rebuild = CreateUIShowSharedStorage,
	});
	return UIShowSharedStorage;
end
