------------------------------------------------------------------------------------------
-- AltHolic Gold Tally
-- Readable account-wealth ledger with native LOTRO coin glyphs and scrolling content.
------------------------------------------------------------------------------------------

local CASH_WINDOW_WIDTH = 1020;
local CASH_ROW_HEIGHT = 30;
local CASH_HEADER_Y = 49;
local CASH_CONTENT_Y = 82;
local CASH_FOOTER_HEIGHT = 34;
local CASH_LIST_LEFT = 18;
local CASH_LIST_RIGHT = 36;
local CASH_ROW_WIDTH = CASH_WINDOW_WIDTH - CASH_LIST_LEFT - CASH_LIST_RIGHT;

local CASH_COLUMNS = {
    { title = "Character", x = 8,   width = 160, align = Turbine.UI.ContentAlignment.MiddleLeft },
    { title = "Wallet",    x = 184, width = 180, align = Turbine.UI.ContentAlignment.MiddleCenter },
    { title = "Coin Bags", x = 376, width = 180, align = Turbine.UI.ContentAlignment.MiddleCenter },
    { title = "Vault Bags",x = 568, width = 180, align = Turbine.UI.ContentAlignment.MiddleCenter },
    { title = "Total",     x = 760, width = 198, align = Turbine.UI.ContentAlignment.MiddleCenter },
};

-- Keep a small visual gutter between ledger columns. Separators sit in the
-- middle of the gutter rather than touching either money display.
local COLUMN_BOUNDARIES = { 176, 368, 560, 752 };
local GRID_COLOR = Turbine.UI.Color(0.18, 0.18, 0.18);
local HEADER_GRID_COLOR = Turbine.UI.Color(0.35, 0.35, 0.35);

local function CashShouldShowCharacter(name)
    local data = PlayerDatas[name];
    if data == nil then return false end

    if not settings["displayServers"]["value"] then
        return true;
    end

    local filter = settings["serversToDisplay"]["value"];
    return filter == nil or filter == "" or filter == T["ServerNamesAll"] or filter == data.serverName;
end

local function AddCashLabel(parent, text, x, y, width, color, align, font, height)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetPosition(x, y);
    label:SetSize(width, height or CASH_ROW_HEIGHT);
    label:SetText(text or "");
    label:SetTextAlignment(align or Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetFont(font or Turbine.UI.Lotro.Font.Verdana14);
    label:SetForeColor(color or Turbine.UI.Color.White);
    label:SetMouseVisible(false);
    return label;
end

local function AddLine(parent, x, y, width, height, color)
    local line = Turbine.UI.Control();
    line:SetParent(parent);
    line:SetPosition(x, y);
    line:SetSize(width, height);
    line:SetBackColor(color or GRID_COLOR);
    line:SetMouseVisible(false);
    return line;
end

local function AddHorizontalSeparator(parent, y, width, color)
    return AddLine(parent, 0, y, width, 1, color or GRID_COLOR);
end

local function AddColumnSeparators(parent, height, color)
    for _, x in ipairs(COLUMN_BOUNDARIES) do
        AddLine(parent, x, 0, 1, height, color or GRID_COLOR);
    end
end

local function CreateCashListItem(height)
    local item = Turbine.UI.Control();
    item:SetSize(CASH_ROW_WIDTH, height or CASH_ROW_HEIGHT);
    return item;
end

local function AddMoney(parent, value, x, width, font)
    return AltHolicUtil.CreateMoneyDisplay(parent, value or 0, x + 4, 3, width - 8, CASH_ROW_HEIGHT - 6, {
        font = font or Turbine.UI.Lotro.Font.Verdana14,
        iconWidth = 27,
        iconHeight = 21,
        gap = 2,
        groupGap = 2,
        digitWidths = { 44, 34, 28 },
    });
end

local function AddListRow(listBox, name, wallet, bagCoins, vaultCoins, total, color)
    local item = CreateCashListItem(CASH_ROW_HEIGHT);
    local nameColumn = CASH_COLUMNS[1];

    AddCashLabel(item, name or "", nameColumn.x, 0, nameColumn.width, color,
        nameColumn.align, Turbine.UI.Lotro.Font.Verdana14);

    local values = { wallet, bagCoins, vaultCoins, total };
    for index = 2, #CASH_COLUMNS do
        local column = CASH_COLUMNS[index];
        AddMoney(item, values[index - 1], column.x, column.width);
    end

    AddColumnSeparators(item, CASH_ROW_HEIGHT, GRID_COLOR);
    AddHorizontalSeparator(item, CASH_ROW_HEIGHT - 1, CASH_ROW_WIDTH, GRID_COLOR);
    listBox:AddItem(item);
    return item;
end

local function AddListSectionTitle(listBox, text)
    local item = CreateCashListItem(39);
    AddCashLabel(item, text, 8, 5, 340, Turbine.UI.Color.White,
        Turbine.UI.ContentAlignment.MiddleLeft, Turbine.UI.Lotro.Font.BookAntiquaBold22, 27);
    AddHorizontalSeparator(item, 36, CASH_ROW_WIDTH, Turbine.UI.Color(0.15, 0.25, 0.8));
    listBox:AddItem(item);
end

local function AddListSummaryRow(listBox, labelText, value, color, bold)
    local item = CreateCashListItem(CASH_ROW_HEIGHT);
    local font = bold and Turbine.UI.Lotro.Font.BookAntiquaBold19 or Turbine.UI.Lotro.Font.Verdana14;
    AddCashLabel(item, labelText, 8, 0, 420, color,
        Turbine.UI.ContentAlignment.MiddleLeft, font);
    AddMoney(item, value, CASH_COLUMNS[5].x, CASH_COLUMNS[5].width,
        bold and Turbine.UI.Lotro.Font.Verdana14 or Turbine.UI.Lotro.Font.Verdana14);
    AddHorizontalSeparator(item, CASH_ROW_HEIGHT - 1, CASH_ROW_WIDTH, GRID_COLOR);
    listBox:AddItem(item);
end

local function AddListSpacer(listBox, height)
    listBox:AddItem(CreateCashListItem(height or 8));
end

local function GetCharacterCashSnapshot(name)
    local data = PlayerDatas[name] or {};

    -- Only refresh from live APIs for the logged-in character. Never substitute
    -- current-player money into an offline alt whose saved snapshot is missing.
    if name == PlayerName then
        data.cash = PlayerAttr:GetMoney();
        data.bagCash = tonumber(CalculateBagCoinValue()) or 0;
        data.vaultCash = tonumber(CalculateVaultCoinValue()) or 0;
        PlayerDatas[name] = data;
    end

    local wallet = tonumber(data.cash) or 0;
    local bagCoins = tonumber(data.bagCash) or 0;
    local vaultCoins = tonumber(data.vaultCash) or 0;
    return wallet, bagCoins, vaultCoins, wallet + bagCoins + vaultCoins;
end

function CreateUIShowCash()
    local names = {};
    for name in pairs(PlayerDatas) do
        if CashShouldShowCharacter(name) then
            table.insert(names, name);
        end
    end
    table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end);

    local displayWidth = Turbine.UI.Display:GetWidth();
    local displayHeight = Turbine.UI.Display:GetHeight();
    local width = math.min(CASH_WINDOW_WIDTH, math.max(760, displayWidth - 50));
    local height = math.min(680, math.max(500, displayHeight - 80));

    UIShowCash = Turbine.UI.Lotro.GoldWindow();
    UIShowCash:SetSize(width, height);
    UIShowCash:SetText("Gold Tally - All Characters");
    UIShowCash:SetPosition(
        math.max(0, (displayWidth - width) / 2),
        math.max(0, (displayHeight - height) / 2)
    );
    UIShowCash:SetZOrder(10);
    UIShowCash:SetWantsKeyEvents(true);

    -- If the screen forces a narrower window, scale the right-side columns evenly.
    local usableWidth = width - CASH_LIST_LEFT - CASH_LIST_RIGHT;
    local scale = usableWidth / CASH_ROW_WIDTH;
    local headerColumns = {};
    for index, column in ipairs(CASH_COLUMNS) do
        headerColumns[index] = {
            title = column.title,
            x = math.floor(column.x * scale),
            width = math.floor(column.width * scale),
            align = column.align,
        };
    end

    for _, column in ipairs(headerColumns) do
        AddCashLabel(UIShowCash, column.title, CASH_LIST_LEFT + column.x, CASH_HEADER_Y,
            column.width, Turbine.UI.Color.Gold, column.align, Turbine.UI.Lotro.Font.BookAntiquaBold19);
    end
    AddLine(UIShowCash, CASH_LIST_LEFT, CASH_HEADER_Y + 27, usableWidth, 2, Turbine.UI.Color(0.15, 0.25, 0.8));

    -- Fixed vertical header separators make the ledger columns visually distinct.
    for _, x in ipairs(COLUMN_BOUNDARIES) do
        AddLine(UIShowCash, CASH_LIST_LEFT + math.floor(x * scale), CASH_HEADER_Y, 1, 28, HEADER_GRID_COLOR);
    end

    local contentHeight = height - CASH_CONTENT_Y - CASH_FOOTER_HEIGHT - 10;
    local listBox = Turbine.UI.ListBox();
    listBox:SetParent(UIShowCash);
    listBox:SetPosition(CASH_LIST_LEFT, CASH_CONTENT_Y);
    listBox:SetSize(usableWidth, contentHeight);
    listBox:SetOrientation(Turbine.UI.Orientation.Vertical);
    listBox:SetMouseVisible(true);
    listBox:SetZOrder(20);

    local scrollBar = Turbine.UI.Lotro.ScrollBar();
    scrollBar:SetParent(UIShowCash);
    scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    scrollBar:SetPosition(width - 25, CASH_CONTENT_Y);
    scrollBar:SetSize(12, contentHeight);
    listBox:SetVerticalScrollBar(scrollBar);

    -- Rows are built at the native 906px ledger width. On very narrow displays the
    -- list is still clipped gracefully rather than shrinking the money glyphs into unreadable fragments.
    local grandTotal = 0;
    for _, name in ipairs(names) do
        local wallet, bagCoins, vaultCoins, total = GetCharacterCashSnapshot(name);
        grandTotal = grandTotal + total;
        local color = (name == PlayerName) and Turbine.UI.Color.Lime or Turbine.UI.Color.White;
        AddListRow(listBox, name, wallet, bagCoins, vaultCoins, total, color);
    end

    if #names == 0 then
        local item = CreateCashListItem(CASH_ROW_HEIGHT);
        AddCashLabel(item, "No characters match the current server filter.", 8, 0, 560,
            Turbine.UI.Color.White, Turbine.UI.ContentAlignment.MiddleLeft, Turbine.UI.Lotro.Font.Verdana14);
        listBox:AddItem(item);
    end

    AddListSpacer(listBox, 10);
    local shared = tonumber(settings["sharedStorageCash"]["value"]) or 0;
    AddListSummaryRow(listBox, "Shared Storage coin bags", shared, Turbine.UI.Color.White, true);
    grandTotal = grandTotal + shared;
    AddListSummaryRow(listBox, "Grand Total", grandTotal, Turbine.UI.Color.Gold, true);

    AddListSpacer(listBox, 12);
    AddListSectionTitle(listBox, T["PluginCashWindow3"] or "Session cash");
    local sessionWon = tonumber(settings["sessionCash"]["cashSession"]) or 0;
    local sessionSpent = tonumber(settings["sessionCash"]["cashSpent"]) or 0;
    AddListSummaryRow(listBox, T["PluginCashWindow4"] or "Won", sessionWon, Turbine.UI.Color.White, false);
    AddListSummaryRow(listBox, T["PluginCashWindow5"] or "Spent", sessionSpent, Turbine.UI.Color.White, false);
    AddListSummaryRow(listBox, T["PluginCashWindow6"] or "Total", sessionWon - sessionSpent, Turbine.UI.Color.White, false);

    AddListSpacer(listBox, 12);
    AddListSectionTitle(listBox, T["PluginCashWindow7"] or "Daily cash");
    local dailyWon = tonumber(settings["dailyCash"]["cashDaily"]) or 0;
    local dailySpent = tonumber(settings["dailyCash"]["cashSpent"]) or 0;
    AddListSummaryRow(listBox, T["PluginCashWindow4"] or "Won", dailyWon, Turbine.UI.Color.White, false);
    AddListSummaryRow(listBox, T["PluginCashWindow5"] or "Spent", dailySpent, Turbine.UI.Color.White, false);
    AddListSummaryRow(listBox, T["PluginCashWindow6"] or "Total", dailyWon - dailySpent, Turbine.UI.Color.White, false);

    AddCashLabel(UIShowCash, T["PluginText"] or "By Homeopatix", 0, height - 29, width,
        Turbine.UI.Color.White, Turbine.UI.ContentAlignment.MiddleCenter, Turbine.UI.Lotro.Font.Verdana12, 20);

    UIShowCash:SetVisible(false);
end

------------------------------------------------------------------------------------------
-- Open/close helper shared by the main window and optional toolbar. Rebuild on open so
-- current-character money and recently saved alt data are always fresh.
------------------------------------------------------------------------------------------
function ToggleUIShowCash()
    if UIShowCash ~= nil and UIShowCash:IsVisible() then
        UIShowCash:SetVisible(false);
        return;
    end
    CreateUIShowCash();
    UIShowCash:SetVisible(true);
end
