------------------------------------------------------------------------------------------
-- AltHolic Gold Tally
-- Readable account-wealth ledger with native LOTRO coin glyphs and scrolling content.
------------------------------------------------------------------------------------------

local CASH_ROW_HEIGHT = 30;
local CASH_HEADER_Y = 49;
local CASH_CONTENT_Y = 82;
local CASH_FOOTER_HEIGHT = 34;
local CASH_LIST_LEFT = 18;
local CASH_LIST_RIGHT = 36;

-- Column widths are sized to their content instead of a fixed 1230px window:
--   * name: LOTRO names are at most 20 characters; 156px of Verdana14 plus an 8px left
--     and 6px right gutter fits them.
--   * money: up to 99,999 gold per character. Digit boxes are 54/30/22px (5 gold digits
--     at ~9px each plus ~9px spare so a wide font never clips, 3 silver, 2 copper) plus
--     three 27px coin icons and 2px gaps = 197px, with a 4-5px gutter each side. The Total column gets 6 gold digits because it also
--     carries the account Grand Total.
local NAME_PADDING_LEFT = 8;
local NAME_COLUMN_WIDTH = 170;
local MONEY_PADDING = 4;
local MONEY_DIGITS = { 54, 30, 22 };
local TOTAL_DIGITS = { 62, 30, 22 };
local MONEY_ICON_WIDTH, MONEY_ICON_HEIGHT, MONEY_GAP = 27, 21, 2;

local function MoneyColumnWidth(digits)
    local width = 3 * MONEY_ICON_WIDTH + 3 * MONEY_GAP + 2 * MONEY_GAP;
    for _, digitWidth in ipairs(digits) do width = width + digitWidth; end
    return width + 2 * MONEY_PADDING + 2;
end

-- Builds the column list. The Coin Bags column (Bag of Gold/Silver/Copper Coins bought
-- from Vault-keepers, in the backpack or personal vault) only appears when at least one
-- listed character has some; the value is always included in Total either way.
local function BuildColumns(showCoinBags)
    local columns = {
        { titleKey = "PluginGoldTallyCharacter", width = NAME_COLUMN_WIDTH,
          align = Turbine.UI.ContentAlignment.MiddleLeft },
        { titleKey = "PluginGoldTallyWallet", tooltipKey = "PluginGoldTallyWalletTooltip",
          width = MoneyColumnWidth(MONEY_DIGITS), digits = MONEY_DIGITS, field = "wallet" },
    };
    if showCoinBags then
        columns[#columns + 1] = { titleKey = "PluginGoldTallyCoinBags", tooltipKey = "PluginGoldTallyCoinBagsTooltip",
            width = MoneyColumnWidth(MONEY_DIGITS), digits = MONEY_DIGITS, field = "coinBags" };
    end
    columns[#columns + 1] = { titleKey = "PluginGoldTallyTotal", tooltipKey = "PluginGoldTallyTotalTooltip",
        width = MoneyColumnWidth(TOTAL_DIGITS), digits = TOTAL_DIGITS, field = "total" };

    local x = 0;
    for _, column in ipairs(columns) do
        column.x = x;
        column.align = column.align or Turbine.UI.ContentAlignment.MiddleCenter;
        x = x + column.width;
    end
    return columns, x;
end

local GRID_COLOR = Turbine.UI.Color(0.18, 0.18, 0.18);
local HEADER_GRID_COLOR = Turbine.UI.Color(0.35, 0.35, 0.35);

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

local function CreateLedgerTooltip(parent)
    local tooltip = Turbine.UI.Window();
    tooltip:SetParent(parent);
    tooltip:SetSize(470, 46);
    tooltip:SetBackColor(Turbine.UI.Color(0.96, 0.03, 0.03, 0.03));
    tooltip:SetZOrder(200);
    tooltip:SetMouseVisible(false);
    tooltip:SetVisible(false);

    local label = Turbine.UI.Label();
    label:SetParent(tooltip);
    label:SetPosition(10, 4);
    label:SetSize(450, 38);
    label:SetFont(Turbine.UI.Lotro.Font.Verdana14);
    label:SetForeColor(Turbine.UI.Color(1, 0.94, 0.80));
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetMouseVisible(false);

    return tooltip, label;
end

local function AttachLedgerTooltip(control, tooltip, tooltipLabel, text, x, y, windowWidth)
    if control == nil then return end
    control:SetMouseVisible(true);
    control.MouseEnter = function()
        local tooltipWidth = tooltip:GetWidth();
        local left = math.max(8, math.min(x or 8, windowWidth - tooltipWidth - 8));
        tooltip:SetPosition(left, y or 78);
        tooltipLabel:SetText(text or "");
        tooltip:SetVisible(true);
    end
    control.MouseLeave = function()
        tooltip:SetVisible(false);
    end
end

-- One ledger: the columns plus the list box rows are added to.
local Ledger = {};
Ledger.__index = Ledger;

local function NewLedger(listBox, columns, rowWidth)
    return setmetatable({ listBox = listBox, columns = columns, rowWidth = rowWidth,
        totalColumn = columns[#columns] }, Ledger);
end

function Ledger:NewItem(height)
    local item = Turbine.UI.Control();
    item:SetSize(self.rowWidth, height or CASH_ROW_HEIGHT);
    return item;
end

function Ledger:AddMoney(parent, value, column)
    return AltHolicUtil.CreateMoneyDisplay(parent, value or 0, column.x + MONEY_PADDING, 3,
        column.width - 2 * MONEY_PADDING - 1, CASH_ROW_HEIGHT - 6, {
            font = Turbine.UI.Lotro.Font.Verdana14,
            iconWidth = MONEY_ICON_WIDTH,
            iconHeight = MONEY_ICON_HEIGHT,
            gap = MONEY_GAP,
            groupGap = MONEY_GAP,
            digitWidths = column.digits,
        });
end

function Ledger:AddCharacterRow(name, values, color)
    local item = self:NewItem(CASH_ROW_HEIGHT);
    local nameColumn = self.columns[1];
    AddCashLabel(item, name or "", nameColumn.x + NAME_PADDING_LEFT, 0, nameColumn.width - NAME_PADDING_LEFT - 6,
        color, nameColumn.align, Turbine.UI.Lotro.Font.Verdana14);

    for index = 2, #self.columns do
        local column = self.columns[index];
        self:AddMoney(item, values[column.field], column);
        AddLine(item, column.x, 0, 1, CASH_ROW_HEIGHT, GRID_COLOR);
    end
    AddHorizontalSeparator(item, CASH_ROW_HEIGHT - 1, self.rowWidth, GRID_COLOR);
    self.listBox:AddItem(item);
end

function Ledger:AddSectionTitle(text)
    local item = self:NewItem(39);
    AddCashLabel(item, text, NAME_PADDING_LEFT, 5, self.rowWidth - 16, Turbine.UI.Color.White,
        Turbine.UI.ContentAlignment.MiddleLeft, Turbine.UI.Lotro.Font.BookAntiquaBold22, 27);
    AddHorizontalSeparator(item, 36, self.rowWidth, Turbine.UI.Color(0.15, 0.25, 0.8));
    self.listBox:AddItem(item);
end

-- Label on the left, amount in the Total column.
function Ledger:AddSummaryRow(labelText, value, color, bold)
    local item = self:NewItem(CASH_ROW_HEIGHT);
    local font = bold and Turbine.UI.Lotro.Font.BookAntiquaBold19 or Turbine.UI.Lotro.Font.Verdana14;
    local label = AddCashLabel(item, labelText, NAME_PADDING_LEFT, 0, self.totalColumn.x - 16, color,
        Turbine.UI.ContentAlignment.MiddleLeft, font);
    self:AddMoney(item, value, self.totalColumn);
    AddHorizontalSeparator(item, CASH_ROW_HEIGHT - 1, self.rowWidth, GRID_COLOR);
    self.listBox:AddItem(item);
    return label;
end

function Ledger:AddSpacer(height)
    self.listBox:AddItem(self:NewItem(height or 8));
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
    local coinBags = (tonumber(data.bagCash) or 0) + (tonumber(data.vaultCash) or 0);
    return { wallet = wallet, coinBags = coinBags, total = wallet + coinBags };
end

function CreateUIShowCash()
    AltHolicUtil.DetachControl(UIShowCash);

    local names = AltHolicUtil.GetDisplayedCharacterNames();
    table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end);

    local snapshots, anyCoinBags = {}, false;
    for index, name in ipairs(names) do
        snapshots[index] = GetCharacterCashSnapshot(name);
        if snapshots[index].coinBags ~= 0 then anyCoinBags = true; end
    end
    local shared = tonumber(settings["sharedStorageCash"]["value"]) or 0;

    local columns, rowWidth = BuildColumns(anyCoinBags);
    local displayWidth = Turbine.UI.Display:GetWidth();
    local displayHeight = Turbine.UI.Display:GetHeight();
    local width = math.min(rowWidth + CASH_LIST_LEFT + CASH_LIST_RIGHT, displayWidth);
    local height = math.min(680, math.max(500, displayHeight - 80));
    local usableWidth = width - CASH_LIST_LEFT - CASH_LIST_RIGHT;

    UIShowCash = Turbine.UI.Lotro.GoldWindow();
    UIShowCash:SetSize(width, height);
    UIShowCash:SetText(T["PluginGoldTallyTitle"]);
    UIShowCash:SetPosition(
        math.max(0, math.floor((displayWidth - width) / 2)),
        math.max(0, math.floor((displayHeight - height) / 2))
    );
    UIShowCash:SetZOrder(10);
    UIShowCash:SetWantsKeyEvents(true);

    -- Header: titles, tooltips and separators.
    local ledgerTooltip, ledgerTooltipLabel = CreateLedgerTooltip(UIShowCash);
    for index, column in ipairs(columns) do
        local left = CASH_LIST_LEFT + column.x + (index == 1 and NAME_PADDING_LEFT or 0);
        local headerLabel = AddCashLabel(UIShowCash, T[column.titleKey] or column.titleKey, left, CASH_HEADER_Y,
            column.width - (index == 1 and NAME_PADDING_LEFT or 0), Turbine.UI.Color.Gold, column.align,
            Turbine.UI.Lotro.Font.BookAntiquaBold19);
        if column.tooltipKey ~= nil then
            AttachLedgerTooltip(headerLabel, ledgerTooltip, ledgerTooltipLabel, T[column.tooltipKey],
                CASH_LIST_LEFT + column.x - 120, CASH_HEADER_Y + 31, width);
        end
        if index > 1 then
            AddLine(UIShowCash, CASH_LIST_LEFT + column.x, CASH_HEADER_Y, 1, 28, HEADER_GRID_COLOR);
        end
    end
    AddLine(UIShowCash, CASH_LIST_LEFT, CASH_HEADER_Y + 27, usableWidth, 2, Turbine.UI.Color(0.15, 0.25, 0.8));

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

    local ledger = NewLedger(listBox, columns, rowWidth);

    local grandTotal = 0;
    for index, name in ipairs(names) do
        grandTotal = grandTotal + snapshots[index].total;
        local color = (name == PlayerName) and Turbine.UI.Color.Lime or Turbine.UI.Color.White;
        ledger:AddCharacterRow(name, snapshots[index], color);
    end

    if #names == 0 then
        local item = ledger:NewItem(CASH_ROW_HEIGHT);
        AddCashLabel(item, T["PluginGoldTallyNoCharacters"], NAME_PADDING_LEFT, 0, rowWidth - 16,
            Turbine.UI.Color.White, Turbine.UI.ContentAlignment.MiddleLeft, Turbine.UI.Lotro.Font.Verdana14);
        listBox:AddItem(item);
    end

    ledger:AddSpacer(10);
    -- Coin bags in Shared Storage belong to the account, not a character; only listed when there are some.
    if shared ~= 0 then
        local sharedStorageLabel = ledger:AddSummaryRow(T["PluginGoldTallySharedItems"], shared, Turbine.UI.Color.White, true);
        AttachLedgerTooltip(sharedStorageLabel, ledgerTooltip, ledgerTooltipLabel,
            T["PluginGoldTallySharedTooltip"], 20, CASH_HEADER_Y + 31, width);
        grandTotal = grandTotal + shared;
    end
    ledger:AddSummaryRow(T["PluginGoldTallyGrandTotal"], grandTotal, Turbine.UI.Color.Gold, true);

    local function AddWonSpent(title, won, spent)
        won, spent = tonumber(won) or 0, tonumber(spent) or 0;
        ledger:AddSpacer(12);
        ledger:AddSectionTitle(title);
        ledger:AddSummaryRow(T["PluginCashWindow4"], won, Turbine.UI.Color.White, false);
        ledger:AddSummaryRow(T["PluginCashWindow5"], spent, Turbine.UI.Color.White, false);
        ledger:AddSummaryRow(T["PluginCashWindow6"], won - spent, Turbine.UI.Color.White, false);
    end
    AddWonSpent(T["PluginCashWindow3"], settings["sessionCash"]["cashSession"], settings["sessionCash"]["cashSpent"]);
    AddWonSpent(T["PluginCashWindow7"], settings["dailyCash"]["cashDaily"], settings["dailyCash"]["cashSpent"]);

    AddCashLabel(UIShowCash, T["PluginText"], 0, height - 29, width,
        Turbine.UI.Color.White, Turbine.UI.ContentAlignment.MiddleCenter, Turbine.UI.Lotro.Font.Verdana12, 20);

    UIShowCash:SetVisible(false);
    -- Esc closes the Gold Tally like every other AltHolic window.
    EscapeKeyHandlerForWindows(UIShowCash);
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
