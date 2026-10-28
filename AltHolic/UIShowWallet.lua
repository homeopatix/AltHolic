------------------------------------------------------------------------------------------
-- UIShowWallet file: currencies, money, coin bags, destiny points and LOTRO points
-- Written by Homeopatix, 26 january 2021; cleaned up for AltHolic 5.06.
------------------------------------------------------------------------------------------

local WINDOW_WIDTH = 400;
local BASE_HEIGHT = 610;
local LIST_HEIGHT = 400;
local ROW_HEIGHT = 38;
local UNLIMITED_QUANTITY = 9999990;

-- Hover card with the currency description.
local function CreateWalletCard(window, item)
	local card = Turbine.UI.Extensions.SimpleWindow();
	card:SetParent(window);
	card:SetPosition(130, window:GetHeight() - 450);
	card:SetSize(300, 300);
	card:SetVisible(false);
	card:SetZOrder(20);
	card:SetBackground(ResourcePath .. "/Cadre_300_300.tga");

	local function Text(text, x, y, width, height, font)
		local label = Turbine.UI.Label();
		label:SetParent(card);
		label:SetPosition(x, y);
		label:SetSize(width, height);
		label:SetFont(font or Turbine.UI.Lotro.Font.BookAntiqua18);
		label:SetText(text or "");
		label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
		label:SetZOrder(21);
		return label;
	end

	Text(item.D, 10, 50, 280, 280);
	Text(item.N, 40, 5, 260, 32);

	local icon = Turbine.UI.Label();
	icon:SetParent(card);
	icon:SetPosition(5, 5);
	icon:SetSize(32, 32);
	icon:SetBackground(tonumber(item.I));
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	icon:SetZOrder(21);

	local accountLabel = Text(item.A == "true" and T["PluginWalletWindow1"] or "", 5, 30, 180, 32,
		Turbine.UI.Lotro.Font.BookAntiquaBold19);
	accountLabel:SetForeColor(Turbine.UI.Color.Lime);

	return card;
end

local function CreateWalletRow(window, listbox, item)
	local row = Turbine.UI.Control();
	row:SetSize(WINDOW_WIDTH - 45, ROW_HEIGHT);
	row:SetMouseVisible(true);

	local slot = Turbine.UI.Control();
	slot:SetParent(row);
	slot:SetSize(32, 32);
	slot:SetPosition(10, 5);

	local icon = Turbine.UI.Control();
	icon:SetParent(slot);
	icon:SetSize(32, 32);
	icon:SetPosition(1, 1);
	icon:SetBackground(tonumber(item.I));
	icon:SetBlendMode(Turbine.UI.BlendMode.Overlay);

	local card = CreateWalletCard(window, item);
	slot.MouseEnter = function() card:SetVisible(true); end
	slot.MouseLeave = function() card:SetVisible(false); end

	local quantity = tostring(item.QUA or "");
	if (tonumber(item.MQUA) or 0) < UNLIMITED_QUANTITY then
		quantity = quantity .. " / " .. tostring(item.MQUA);
	end

	local nameLabel = Turbine.UI.Label();
	nameLabel:SetParent(row);
	nameLabel:SetSize(300, 32);
	nameLabel:SetPosition(56, 6);
	nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
	nameLabel:SetMarkupEnabled(true);
	nameLabel:SetText(rgb["gold"] .. quantity .. rgb["clear"] .. " " .. tostring(item.N or ""));
	nameLabel:SetBackColor(Turbine.UI.Color(0.9, 0.3, 0.3, 0.3));

	listbox:AddItem(row);
end

function CreateUIShowWallet(namePlayerToshow)
	AltHolicUtil.DetachControl(UIShowWallet);
	UIShowWallet = nil;

	if namePlayerToshow == PlayerName then SavePlayerWallet(); end

	local data = PlayerDatas[namePlayerToshow] or {};
	local bagCash = tonumber(data.bagCash) or 0;
	local vaultCash = tonumber(data.vaultCash) or 0;
	local coinBagSpace = ((bagCash > 0) and 40 or 0) + ((vaultCash > 0) and 40 or 0);

	local items = PlayerWallet[namePlayerToshow] or {};
	local slots = AltHolicUtil.SortedItemSlots(items);
	local windowHeight = BASE_HEIGHT + coinBagSpace;

	UIShowWallet = Turbine.UI.Lotro.GoldWindow();
	UIShowWallet:SetSize(WINDOW_WIDTH, windowHeight);
	UIShowWallet:SetText(T["PluginWalletWindow3"] .. tostring(namePlayerToshow));
	UIShowWallet:SetPosition((Turbine.UI.Display:GetWidth() - WINDOW_WIDTH) / 2, (Turbine.UI.Display:GetHeight() - windowHeight) / 2);
	UIShowWallet:SetZOrder(10);
	UIShowWallet:SetWantsKeyEvents(true);
	UIShowWallet:SetVisible(false);
	UIShowWallet.altHolicKey = namePlayerToshow;

	AltHolicUtil.CreateLabel(UIShowWallet, T["PluginText"], WINDOW_WIDTH / 2 - 75, windowHeight - 20, 150, 10, {
		align = Turbine.UI.ContentAlignment.MiddleCenter,
	});
	AltHolicUtil.CreateLabel(UIShowWallet,
		(#slots >= 1) and (T["PluginWalletWindow2"] .. " : " .. #slots) or T["PluginWalletWindow4"],
		WINDOW_WIDTH / 2 - 200, windowHeight - 90, 400, 40, {
			font = Turbine.UI.Lotro.Font.BookAntiquaBold19,
			align = Turbine.UI.ContentAlignment.MiddleCenter,
		});

	AltHolicUtil.CreateCloseButton(UIShowWallet, T["PluginCloseButton"], windowHeight - 50, function()
		settings["isShowWalletVisible"]["isShowWalletVisible"] = false;
		UIShowWallet:SetVisible(false);
	end, 300, WINDOW_WIDTH / 2 - 125);

	-- Money: wallet, coin bags, destiny points and LOTRO points.
	DisplayCash(data.cash, UIShowWallet, namePlayerToshow);
	if bagCash > 0 then DisplayBagCash(bagCash, UIShowWallet, namePlayerToshow); end
	if vaultCash > 0 then DisplayVaultCash(vaultCash, UIShowWallet, namePlayerToshow); end
	DisplayDestinyPoints(UIShowWallet);
	DisplayLotroCoins(UIShowWallet, namePlayerToshow);

	-- Currencies.
	local listbox = Turbine.UI.ListBox();
	listbox:SetParent(UIShowWallet);
	listbox:SetSize(WINDOW_WIDTH - 45, LIST_HEIGHT);
	listbox:SetPosition(10, 120 + coinBagSpace);
	listbox:SetMouseVisible(true);
	listbox:SetZOrder(20);

	for _, key in ipairs(slots) do
		CreateWalletRow(UIShowWallet, listbox, items[key]);
	end

	if (#slots * ROW_HEIGHT) > LIST_HEIGHT then
		local scrollbar = Turbine.UI.Lotro.ScrollBar();
		scrollbar:SetParent(UIShowWallet);
		scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
		scrollbar:SetPosition(WINDOW_WIDTH - 20, 120 + coinBagSpace);
		scrollbar:SetSize(10, LIST_HEIGHT);
		scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
		listbox:SetVerticalScrollBar(scrollbar);
	end

	ClosingTheWindowWallet();
	EscapeKeyHandlerForWindows(UIShowWallet, "isShowWalletVisible", "isShowWalletVisible");
end
