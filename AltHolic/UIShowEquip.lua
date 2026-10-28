------------------------------------------------------------------------------------------
-- UIshowEquip file
-- Written by Homeopatix
-- 26 january 2021
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
-- create the equipment window
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Equipment layout is data-driven so slot positions and item indices live in one place.
------------------------------------------------------------------------------------------
local EQUIPMENT_SLOT_LAYOUT = {
	Head =          { x = 305, y = 45,  index = 1 },
	Shoulder =      { x = 305, y = 87,  index = 6 },
	Back =          { x = 305, y = 129, index = 7 },
	Chest =         { x = 305, y = 171, index = 2 },
	Gloves =        { x = 305, y = 213, index = 4 },
	Legs =          { x = 305, y = 255, index = 3 },
	Boots =         { x = 305, y = 297, index = 5 },
	RangedWeapon =  { x = 305, y = 339, index = 18 },
	CraftTool =     { x = 305, y = 381, index = 19 },
	ClassE =        { x = 305, y = 423, index = 20 },
	Earring1 =      { x = 25,  y = 45,  index = 13 },
	Earring2 =      { x = 25,  y = 87,  index = 14 },
	Necklace =      { x = 25,  y = 129, index = 10 },
	Bracelet1 =     { x = 25,  y = 171, index = 8 },
	Bracelet2 =     { x = 25,  y = 213, index = 9 },
	Ring1 =         { x = 25,  y = 255, index = 11 },
	Ring2 =         { x = 25,  y = 297, index = 12 },
	Pocket =        { x = 25,  y = 339, index = 15 },
	PrimaryWeapon = { x = 25,  y = 381, index = 16 },
	Shield =        { x = 25,  y = 423, index = 17 },
};

local EQUIPMENT_SLOT_TEXTURES = {
	0x41007eed, 0x41007eee, 0x41007ee9, 0x41007ef0, 0x41007ef2,
	0x41007ef1, 0x41007ef5, 0x41007eec, 0x41007efb, 0x410e8680,
	0x41007ef6, 0x41007ef7, 0x41007eef, 0x41007ef8, 0x41007ef9,
	0x41007ef3, 0x41007ef4, 0x41007efa, 0x41007eea, 0x41007eeb
};

-- Background colour / text colour of the item name by durability (when the
-- "durability colour" option is on).
local DURABILITY_COLORS = {
	[0]  = { Turbine.UI.Color(0.9, 0.9, 0.1, 0), Turbine.UI.Color.White }, -- broken: red
	[20] = { Turbine.UI.Color(0.9, 1, 0.7, 0), Turbine.UI.Color.Black },   -- damaged: orange
	[99] = { Turbine.UI.Color(0.9, 1, 1, 0), Turbine.UI.Color.Black },     -- worn: yellow
};
local DEFAULT_NAME_COLORS = { Turbine.UI.Color(0.9, 0.3, 0.3, 0.3), Turbine.UI.Color.White };
local BADGE_BACK_COLOR = Turbine.UI.Color(0.9, 0.15, 0.15, 0.15);

-- Item score (quality and durability weighted), from Habna's TitanBar.
local function ItemScore(item)
	local qualityWeight, durabilityWeight = 4, 1;
	local quality = (item.QA ~= nil) and 10 * ((6 - item.QA) % 6) or 0;
	local durability = tonumber(item.DU) or 0;
	if durability ~= 0 then durability = 10 * ((durability % 7) + 1); end
	return math.floor((qualityWeight * quality * 7 + durabilityWeight * durability * 5) / (3.5 * (qualityWeight + durabilityWeight)));
end

local function Badge(parent, text, width, x)
	local badge = Turbine.UI.Label();
	badge:SetParent(parent);
	badge:SetSize(width, 10);
	badge:SetPosition(x, parent:GetHeight() - 10);
	badge:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
	badge:SetText(text);
	badge:SetBackColor(BADGE_BACK_COLOR);
	badge:SetMarkupEnabled(true);
	return badge;
end

local function CreateEquippedItem(window, namePlayerToshow, slotName, item, layout)
	local posx, posy = layout.x, layout.y;
	local itemIcon = AltHolicUtil.CreateStoredItemIcon(window, item, posx, posy, { offset = 0, useStackFallback = false });

	-- The logged-in character gets the game's own item tooltip (and the level editor on click).
	local liveItem = (namePlayerToshow == PlayerName) and PlayerEquip:GetItem(layout.index) or nil;
	if liveItem ~= nil then
		local itemControl = OfflineItemInfoControl();
		itemControl:SetParent(window);
		itemControl:SetPosition(posx - 2, posy - 2);
		itemControl:SetItem(slotName, namePlayerToshow, liveItem:GetItemInfo(), item.I, item.B, 1);
		itemIcon.selectedRecipeItem = itemControl;
	else
		DisplayLabelEquipment(slotName, posx, posy, namePlayerToshow, itemIcon);
	end

	local nameLabel = Turbine.UI.Label();
	nameLabel:SetParent(window);
	nameLabel:SetSize(232, 40);
	nameLabel:SetPosition(posx + 40, posy - 2);
	nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	nameLabel:SetText(item.N);
	nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
	nameLabel:SetMarkupEnabled(true);
	nameLabel:SetZOrder(-1);

	local colors = DEFAULT_NAME_COLORS;
	if settings["displayDurabilityColor"]["value"] == true then
		colors = DURABILITY_COLORS[AltHolicUtil.WearStatePercent(item.WS)] or DEFAULT_NAME_COLORS;
	end
	nameLabel:SetBackColor(colors[1]);
	nameLabel:SetForeColor(colors[2]);

	Badge(nameLabel, tostring(ItemScore(item)), 20, nameLabel:GetWidth() - 20);

	-- Item level entered by the player (right-aligned next to the score).
	local level = tonumber(item.lvl) or 0;
	if level ~= 0 then
		if level >= 100 then
			Badge(nameLabel, tostring(item.lvl), 30, nameLabel:GetWidth() - 52);
		else
			Badge(nameLabel, tostring(item.lvl), 20, nameLabel:GetWidth() - 42);
		end
	end
end

function CreateUIShowEquip(namePlayerToshow, alignement)
	AltHolicUtil.DetachControl(UIShowEquip);

	UIShowEquip = Turbine.UI.Lotro.GoldWindow();
	UIShowEquip:SetSize(600, 500);
	UIShowEquip:SetText(T["PluginEquipement1"] .. tostring(namePlayerToshow));
	UIShowEquip:SetPosition((Turbine.UI.Display:GetWidth() - 600) / 2, (Turbine.UI.Display:GetHeight() - 500) / 2);
	UIShowEquip:SetWantsKeyEvents(true);
	UIShowEquip:SetVisible(false);
	UIShowEquip.altHolicKey = namePlayerToshow;

	local data = PlayerDatas[namePlayerToshow];
	if data ~= nil and data.align == 1 then
		UIShowEquip:SetZOrder(10);
		AltHolicUtil.CreateLabel(UIShowEquip, T["PluginText"], 225, 480, 150, 10, {
				align = Turbine.UI.ContentAlignment.MiddleCenter,
			});

		-- Empty slot frames: right column (slots 1-10) then left column (11-20).
		for index = 1, 20 do
			local frame = Turbine.UI.Label();
			frame:SetParent(UIShowEquip);
			frame:SetPosition(index <= 10 and 299 or 19, 39 + ((index - 1) % 10) * 42);
			frame:SetSize(42, 42);
			frame:SetBackground(EQUIPMENT_SLOT_TEXTURES[index]);
			frame:SetZOrder(-1);
		end

		for slotName, item in pairs(PlayerEquipement[namePlayerToshow] or {}) do
			local layout = EQUIPMENT_SLOT_LAYOUT[slotName];
			if layout ~= nil then
				if item.N ~= nil then
					CreateEquippedItem(UIShowEquip, namePlayerToshow, slotName, item, layout);
				else
					local emptyLabel = AltHolicUtil.CreateLabel(UIShowEquip, T["PluginEquipement2"],
						layout.x + 50, layout.y, 230, 38, { color = Turbine.UI.Color.Red });
					emptyLabel:SetFont(Turbine.UI.Lotro.Font.Verdana14);
				end
			end
		end
	else
		-- Monster play: no equipment, just the Eye.
		UIShowEquip:SetZOrder(1000);

		local message = AltHolicUtil.CreateLabel(UIShowEquip, T["PluginISeeYou"], 100, 450, 400, 50, {
				font = Turbine.UI.Lotro.Font.TrajanProBold36,
				color = Turbine.UI.Color.Gold,
				align = Turbine.UI.ContentAlignment.MiddleCenter,
			});

		local sauron = Turbine.UI.Extensions.SimpleWindow();
		sauron:SetParent(UIShowEquip);
		sauron:SetPosition(20, 30);
		sauron:SetSize(560, 435);
		sauron:SetBackground(ResourcePath .. "Sauron.tga");
		sauron:SetZOrder(12);
		sauron:SetVisible(true);
	end

	ClosingTheWindowEquipment();
	EscapeKeyHandlerForWindows(UIShowEquip, "isShowEquipmentVisible", "isShowEquipmentVisible");
end
