------------------------------------------------------------------------------------------
-- UIShowSearch file
-- Written by Homeopatix
-- Refactored for AltHolic 4.89
------------------------------------------------------------------------------------------
local SEARCH_SOURCE_ORDER = {"bag", "vault", "wallet", "shared"};
local SEARCH_SOURCE_CONFIG = {
    bag = { labelKey = "PluginSearch3", storage = function() return PlayerBags; end, perCharacter = true },
    vault = { labelKey = "PluginSearch4", storage = function() return PlayerVault; end, perCharacter = true },
    wallet = { labelKey = "PluginSearch7", storage = function() return PlayerWallet; end, perCharacter = true },
    shared = { labelKey = "PluginSearch5", storage = function() return SharedStorageVault; end, perCharacter = false },
};

local function GetSearchCount(source, query)
    if source == "bag" then return ReturnNbrItemsInBag(query); end
    if source == "vault" then return ReturnNbrItemsInVault(query); end
    if source == "wallet" then return ReturnNbrItemsInWallet(query); end
    if source == "shared" then return ReturnNbrItemsInSharedStorage(query); end
    return 0, 0, 0;
end

local function GetSearchSourceLabel(source)
    local config = SEARCH_SOURCE_CONFIG[source];
    return config and T[config.labelKey] or "";
end

local function CreateSearchButton(parent, text, x, y, width)
    local button = Turbine.UI.Lotro.GoldButton();
    button:SetParent(parent);
    button:SetPosition(x, y);
    button:SetSize(width or 150, 20);
    button:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    button:SetText(text);
    button:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    button:SetVisible(true);
    button:SetMouseVisible(true);
    return button;
end

local function CreateNoResultsLabel(parent, windowWidth, message)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(windowWidth - 50, 449);
    label:SetPosition(25, 0);
    label:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
    label:SetForeColor(Turbine.UI.Color.White);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    label:SetText(message);
    label:SetVisible(true);
    return label;
end

local function CreateSectionHeader(parent, text, y, width)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(width, 20);
    label:SetPosition(10, y);
    label:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    label:SetForeColor(Turbine.UI.Color.White);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    label:SetText(text or "");
    label:SetVisible(true);
    label:SetBackColor(Turbine.UI.Color(.8, .5, .6, .5));
    return label;
end

local function CreateCharacterHeader(parent, playerName, y)
    local label = Turbine.UI.Label();
    label:SetParent(parent);
    label:SetSize(350, 34);
    label:SetPosition(10, y);
    label:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
    label:SetForeColor(Turbine.UI.Color.Gold);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetText(playerName or "");
    label:SetVisible(true);
    return label;
end

local function CreateItemVisual(parent, item, x, y)
    local slot = Turbine.UI.Control();
    slot:SetSize(32, 32);
    slot:SetParent(parent);
    slot:SetPosition(x, y);
    slot:SetVisible(true);
    slot:SetBackground(0x41000001);

    local function Layer(texture, mouseVisible, zOrder)
        local textureId = tonumber(texture);
        if textureId == nil then return nil; end
        local control = Turbine.UI.Control();
        control:SetParent(slot);
        control:SetSize(32, 32);
        control:SetPosition(1, 1);
        control:SetZOrder(zOrder or (slot:GetZOrder() + 1));
        control:SetBackground(textureId);
        control:SetBlendMode(Turbine.UI.BlendMode.Overlay);
        control:SetVisible(true);
        if mouseVisible ~= nil then control:SetMouseVisible(mouseVisible); end
        return control;
    end

    local quality = Layer(item.Q, true);
    slot.itemTmp = quality;
    Layer(item.B, false);

    local socketTexture = tonumber(item.S);
    if socketTexture == 0 then
        local qualityTier = tonumber(item.QA) or 0;
        if qualityTier >= 1 and qualityTier <= 5 then socketTexture = 0x410030C4; end
    end
    if socketTexture ~= nil and socketTexture ~= 0 then Layer(socketTexture, false); end

    local icon = Layer(item.I, true, 100);
    return slot, icon;
end

local function CreateLineDescription(parent, item, x, y)
    local container = Turbine.UI.Control();
    container:SetSize(300, 32);
    container:SetParent(parent);
    container:SetPosition(x + 45, y);
    container:SetVisible(true);
    container:SetBackColor(Turbine.UI.Color(.9, .3, .3, .3));

    local label = Turbine.UI.Label();
    label:SetParent(container);
    label:SetSize(300, 32);
    label:SetPosition(1, 1);
    label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    label:SetText(rgb["gold"] .. tostring(item.QUA or "") .. rgb["clear"] .. " " .. tostring(item.N or ""));
    label:SetBackColor(Turbine.UI.Color(.9, .3, .3, .3));
    label:SetMarkupEnabled(true);
    return container;
end

local function SortedKeysByItemName(items)
    local keys = {};
    for key, item in pairs(items or {}) do
        if item ~= nil then keys[#keys + 1] = key; end
    end
    table.sort(keys, function(a, b)
        local itemA, itemB = items[a], items[b];
        local nameA = string.lower(tostring(itemA and itemA.N or ""));
        local nameB = string.lower(tostring(itemB and itemB.N or ""));
        if nameA == nameB then return tostring(a) < tostring(b); end
        return nameA < nameB;
    end);
    return keys;
end

local function SortedCharacterNames(storage)
    local names = {};
    for name in pairs(storage or {}) do names[#names + 1] = name; end
    table.sort(names, function(a, b) return string.lower(tostring(a)) < string.lower(tostring(b)); end);
    return names;
end

local function MatchingItems(items, query)
    local matches = {};
    for _, key in ipairs(SortedKeysByItemName(items)) do
        local item = items[key];
        if item ~= nil and AltHolicUtil.MatchesSearch(item.N, query) then
            matches[#matches + 1] = { key = key, item = item };
        end
    end
    return matches;
end

local function RenderItems(parent, matches, y, mode, itemControls)
    if #matches == 0 then return y; end

    local x = 10;
    local iconsOnRow = 0;
    for _, entry in ipairs(matches) do
        local slot, icon = CreateItemVisual(parent, entry.item, x, y);
        itemControls[#itemControls + 1] = slot;

        if mode == "lines" then
            CreateLineDescription(parent, entry.item, x, y);
            y = y + 38;
        else
            DisplayLabelForIcons(entry.key, x, y, UIShowSearch, icon, entry.item.QUA, entry.item.N);
            x = x + 38;
            iconsOnRow = iconsOnRow + 1;
            if iconsOnRow >= 9 then
                x = 10;
                iconsOnRow = 0;
                y = y + 38;
            end
        end
    end

    if mode == "icons" and iconsOnRow > 0 then y = y + 38; end
    return y;
end

local function RenderCharacterSource(parent, storage, title, query, mode, y, width, itemControls)
    local renderedSection = false;
    local headerY = y;
    y = y + 30;

    for _, playerName in ipairs(SortedCharacterNames(storage)) do
        local matches = MatchingItems(storage[playerName], query);
        if #matches > 0 then
            if not renderedSection then
                CreateSectionHeader(parent, title, headerY, width);
                renderedSection = true;
            end
            CreateCharacterHeader(parent, playerName, y);
            y = y + 38;
            y = RenderItems(parent, matches, y, mode, itemControls);
        end
    end

    if renderedSection then return y + 16; end
    return headerY;
end

local function RenderSharedSource(parent, storage, title, query, mode, y, width, itemControls)
    local matches = MatchingItems(storage, query);
    if #matches == 0 then return y; end

    CreateSectionHeader(parent, title, y, width);
    y = y + 30;
    y = RenderItems(parent, matches, y, mode, itemControls);
    return y + 16;
end

local function SearchHasResults(sourceCounts, where)
    if where == "all" then
        for _, source in ipairs(SEARCH_SOURCE_ORDER) do
            if sourceCounts[source].count > 0 then return true; end
        end
        return false;
    end
    return sourceCounts[where] ~= nil and sourceCounts[where].count > 0;
end

local function BuildNoResultsMessage(where, query)
    local lines = { T["PluginSearch10"] };
    if where == "all" then
        for _, source in ipairs(SEARCH_SOURCE_ORDER) do lines[#lines + 1] = GetSearchSourceLabel(source); end
    else
        lines[#lines + 1] = GetSearchSourceLabel(where);
    end
    lines[#lines + 1] = T["PluginSearch11"];
    lines[#lines + 1] = query;
    return table.concat(lines, "\n");
end

------------------------------------------------------------------------------------------
-- create the search window
------------------------------------------------------------------------------------------
function CreateUISearch(textToSearch, where, howToDisplay)
    if textToSearch == nil or textToSearch == "" then textToSearch = "**"; end
    if where == nil or where == "" or SEARCH_SOURCE_CONFIG[where] == nil then where = "all"; end
    if howToDisplay ~= "icons" then howToDisplay = "lines"; end

    local windowWidth = 400;
    local heightWind = math.min(720, Turbine.UI.Display:GetHeight() - 150);
    local sourceCounts = {};
    local totalResults = 0;

    for _, source in ipairs(SEARCH_SOURCE_ORDER) do
        local count, headers, iconRows = GetSearchCount(source, textToSearch);
        sourceCounts[source] = { count = count or 0, headers = headers or 0, iconRows = iconRows or 0 };
        if where == "all" or where == source then totalResults = totalResults + sourceCounts[source].count; end
    end

    UIShowSearch = Turbine.UI.Lotro.GoldWindow();
    UIShowSearch:SetSize(windowWidth, heightWind);
    UIShowSearch:SetText(T["PluginSearch"]);
    UIShowSearch:SetPosition((Turbine.UI.Display:GetWidth() - windowWidth) / 2, (Turbine.UI.Display:GetHeight() - heightWind) / 2);
    UIShowSearch:SetZOrder(10);
    UIShowSearch:SetWantsKeyEvents(true);
    UIShowSearch:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(UIShowSearch);
    footer:SetSize(150, 10);
    footer:SetPosition(windowWidth / 2 - 75, heightWind - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    local textBoxLines = Turbine.UI.Lotro.TextBox();
    textBoxLines:SetParent(UIShowSearch);
    textBoxLines:SetSize(300, 30);
    textBoxLines:SetMultiline(false);
    textBoxLines:SetText(string.lower(textToSearch));
    textBoxLines:SetPosition(windowWidth / 2 - 150, 50);
    textBoxLines:SetVisible(true);
    textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    textBoxLines:SetForeColor(Turbine.UI.Color.Gold);
    textBoxLines:SetBackColor(Turbine.UI.Color(.9, .5, .7, .5));
    textBoxLines:SetMouseVisible(true);
    textBoxLines.FocusGained = function() textBoxLines:SetText(""); end

    local modeLines = Turbine.UI.Label();
    modeLines:SetParent(UIShowSearch);
    modeLines:SetSize(21, 21);
    modeLines:SetPosition(windowWidth - 40, 110);
    modeLines:SetBackground(howToDisplay == "lines" and 0x4110C76D or 0x4110C76F);
    modeLines:SetMouseVisible(true);
    modeLines:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    local modeIcons = Turbine.UI.Label();
    modeIcons:SetParent(UIShowSearch);
    modeIcons:SetSize(21, 21);
    modeIcons:SetPosition(windowWidth - 40, 141);
    modeIcons:SetBackground(howToDisplay == "lines" and 0x4110C76C or 0x4110C76A);
    modeIcons:SetMouseVisible(true);
    modeIcons:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    local function ReopenSearch(query, source, displayMode)
        if UIShowSearch ~= nil then UIShowSearch:SetVisible(false); end
        CreateUISearch(query, source, displayMode);
        UIShowSearch:SetVisible(true);
        settings["isSearchWindowVisible"]["isSearchWindowVisible"] = true;
    end

    modeLines.MouseClick = function() ReopenSearch(textToSearch, where, "lines"); end
    modeIcons.MouseClick = function() ReopenSearch(textToSearch, where, "icons"); end

    local instruction = Turbine.UI.Label();
    instruction:SetParent(UIShowSearch);
    instruction:SetSize(380, 20);
    instruction:SetPosition(10, 90);
    instruction:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
    instruction:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    instruction:SetText(T["PluginSearch9"]);

    local buttonSearch = CreateSearchButton(UIShowSearch, T["PluginSearch8"], windowWidth / 2 - 125, 160, 300);
    local buttonSearchBag = CreateSearchButton(UIShowSearch, T["PluginSearch3"], 50, 110);
    local buttonSearchVault = CreateSearchButton(UIShowSearch, T["PluginSearch4"], windowWidth - 200, 110);
    local buttonSearchWallet = CreateSearchButton(UIShowSearch, T["PluginSearch7"], 50, 135);
    local buttonSearchShared = CreateSearchButton(UIShowSearch, T["PluginSearch5"], windowWidth - 200, 135);

    local function RunSearch(source)
        local query = textBoxLines:GetText();
        if string.len(query) < 2 then query = "**"; end
        ReopenSearch(query, source, howToDisplay);
    end

    buttonSearch.MouseClick = function() RunSearch("all"); end
    buttonSearchBag.MouseClick = function() RunSearch("bag"); end
    buttonSearchVault.MouseClick = function() RunSearch("vault"); end
    buttonSearchWallet.MouseClick = function() RunSearch("wallet"); end
    buttonSearchShared.MouseClick = function() RunSearch("shared"); end

    DisplayHelpButton(UIShowSearch, windowWidth, 1);

    local buttonClose = Turbine.UI.Lotro.GoldButton();
    buttonClose:SetParent(UIShowSearch);
    buttonClose:SetPosition(windowWidth / 2 - 125, heightWind - 50);
    buttonClose:SetSize(300, 20);
    buttonClose:SetFont(Turbine.UI.Lotro.Font.Verdana16);
    buttonClose:SetText(T["PluginCloseButton"]);
    buttonClose:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    buttonClose:SetVisible(true);
    buttonClose:SetMouseVisible(true);
    buttonClose.MouseClick = function()
        settings["isSearchWindowVisible"]["isSearchWindowVisible"] = false;
        UIShowSearch:SetVisible(false);
    end

    local viewport = Turbine.UI.Control();
    viewport:SetParent(UIShowSearch);
    viewport:SetSize(windowWidth - 35, 450);
    viewport:SetPosition(10, 190);

    local content = Turbine.UI.Control();
    content:SetParent(viewport);
    content:SetPosition(0, 0);
    content:SetSize(windowWidth - 55, 1);
    viewport.map = content;

    local itemControls = {};
    local y = 10;

    if not SearchHasResults(sourceCounts, where) then
        CreateNoResultsLabel(content, windowWidth, BuildNoResultsMessage(where, textToSearch));
        y = 449;
    else
        for _, source in ipairs(SEARCH_SOURCE_ORDER) do
            if where == "all" or where == source then
                local config = SEARCH_SOURCE_CONFIG[source];
                local storage = config.storage() or {};
                if config.perCharacter then
                    y = RenderCharacterSource(content, storage, T[config.labelKey], textToSearch, howToDisplay, y, windowWidth - 35, itemControls);
                else
                    y = RenderSharedSource(content, storage, T[config.labelKey], textToSearch, howToDisplay, y, windowWidth - 35, itemControls);
                end
            end
        end
    end

    content:SetSize(windowWidth - 55, math.max(y, 1));

    if content:GetHeight() > viewport:GetHeight() then
        local vscroll = Turbine.UI.Lotro.ScrollBar();
        vscroll:SetParent(UIShowSearch);
        vscroll:SetOrientation(Turbine.UI.Orientation.Vertical);
        vscroll:SetPosition(windowWidth - 20, 190);
        vscroll:SetSize(12, viewport:GetHeight());
        vscroll:SetBackColor(Turbine.UI.Color(.1, .1, .2));
        vscroll:SetMinimum(0);
        vscroll:SetMaximum(content:GetHeight() - viewport:GetHeight());
        vscroll:SetValue(0);
        vscroll.ValueChanged = function() content:SetTop(-vscroll:GetValue()); end
    end

    local resultSummary = Turbine.UI.Label();
    resultSummary:SetParent(UIShowSearch);
    resultSummary:SetSize(200, 40);
    resultSummary:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold19);
    resultSummary:SetPosition(windowWidth / 2 - 100, heightWind - 85);
    resultSummary:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    resultSummary:SetText(T["PluginSearch1"] .. tostring(totalResults) .. " " .. T["PluginSearch6"]);

    ClosingTheWindowSearch();
    EscapeKeyHandlerForWindows(UIShowSearch, settings["isSearchWindowVisible"]["isSearchWindowVisible"]);
end

function ToggleWindow(toggleValue)
    if UIShowSearch ~= nil then UIShowSearch:SetVisible(toggleValue); end
    settings["isSearchWindowVisible"]["isSearchWindowVisible"] = toggleValue;
end
