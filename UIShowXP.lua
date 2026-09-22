------------------------------------------------------------------------------------------
-- UIShowXP
-- Originally written by Homeopatix
-- Refactored: table-driven character rows and local window state.
------------------------------------------------------------------------------------------

local XP_BAR_WIDTH = 350;
local XP_ROW_HEIGHT = 50;
local XP_WINDOW_WIDTH = 420;
local XP_MIN_HEIGHT = 440;
local XP_BASE_HEIGHT = 340;

local function GetXPCharacters()
    local names = {};
    local filterServers = settings["displayServers"]["value"] == true;
    local selectedServer = settings["serversToDisplay"]["value"];

    for name, data in pairs(PlayerDatas) do
        local include = true;
        if filterServers then
            include = selectedServer == T["ServerNamesAll"]
                or selectedServer == ""
                or selectedServer == data.serverName;
        end
        if include then
            names[#names + 1] = name;
        end
    end

    table.sort(names);
    return names;
end

local function GetXPProgress(data)
    local level = tonumber(data.lvl) or 1;
    local currentXP = tonumber(data.xp) or 0;

    if level >= LevelMax then
        return currentXP, 0, 100, ResourcePath .. "GreenBars.tga";
    end

    local requiredXP;
    if level > 1 then
        requiredXP = (PlayerLevelXP[level] or 0) - (PlayerLevelXP[level - 1] or 0);
    else
        requiredXP = PlayerLevelXP[level] or 0;
    end

    local percentage = 0;
    if requiredXP > 0 then
        percentage = math.max(0, math.min(100, (currentXP * 100) / requiredXP));
    end

    return currentXP, requiredXP, percentage, ResourcePath .. "BlueBars.tga";
end

local function CreateXPRow(parentList, characterName)
    local data = PlayerDatas[characterName];
    if data == nil then return; end

    local row = Turbine.UI.Control();
    row:SetSize(XP_WINDOW_WIDTH - 45, XP_ROW_HEIGHT);
    row:SetMouseVisible(true);

    local nameLabel = Turbine.UI.Label();
    nameLabel:SetParent(row);
    nameLabel:SetSize(XP_BAR_WIDTH, 30);
    nameLabel:SetPosition(10, 5);
    nameLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    nameLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold22);
    nameLabel:SetForeColor(characterName == PlayerName and Turbine.UI.Color.Lime or Turbine.UI.Color.White);
    nameLabel:SetText(characterName);
    nameLabel:SetMouseVisible(true);

    nameLabel.MouseClick = function()
        UIShowXP:SetVisible(false);
        settings["isXPWindowVisible"]["value"] = false;
        CreateUIAddNewXP(characterName);
        UIAddNewXP:SetVisible(true);
    end

    local currentXP, requiredXP, percentage, barTexture = GetXPProgress(data);
    local barY = 30;

    local border = Turbine.UI.Label();
    border:SetParent(row);
    border:SetSize(XP_BAR_WIDTH + 4, 19);
    border:SetPosition(8, barY - 2);
    border:SetBackColor(Turbine.UI.Color(1, 0.5, 0.5, 0.5));

    local background = Turbine.UI.Label();
    background:SetParent(row);
    background:SetSize(XP_BAR_WIDTH, 15);
    background:SetPosition(10, barY);
    background:SetBackColor(Turbine.UI.Color.Black);
    background:SetZOrder(10);

    local fill = Turbine.UI.Label();
    fill:SetParent(row);
    fill:SetSize(math.floor((percentage * XP_BAR_WIDTH) / 100), 15);
    fill:SetPosition(10, barY);
    fill:SetBackground(barTexture);
    fill:SetZOrder(11);

    local levelLabel = Turbine.UI.Label();
    levelLabel:SetParent(row);
    levelLabel:SetSize(100, 25);
    levelLabel:SetPosition(10, barY + 2);
    levelLabel:SetText(" " .. tostring(data.lvl or 0));
    levelLabel:SetForeColor((currentXP == 0 and (tonumber(data.lvl) or 0) < LevelMax)
        and Turbine.UI.Color.White or Turbine.UI.Color.Black);
    levelLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
    levelLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft);
    levelLabel:SetZOrder(12);

    local xpLabel = Turbine.UI.Label();
    xpLabel:SetParent(row);
    xpLabel:SetSize(XP_BAR_WIDTH, 25);
    xpLabel:SetPosition(10, barY + 2);
    if (tonumber(data.lvl) or 0) >= LevelMax then
        xpLabel:SetText("");
    else
        xpLabel:SetText(comma_value(Round(currentXP)) .. " / " .. comma_value(Round(requiredXP)));
    end
    xpLabel:SetFont(Turbine.UI.Lotro.Font.BookAntiquaBold24);
    xpLabel:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    xpLabel:SetZOrder(12);

    parentList:AddItem(row);
end

------------------------------------------------------------------------------------------
-- Create the Players XP window.
------------------------------------------------------------------------------------------
function CreateUIShowXP()
    local characters = GetXPCharacters();
    local displayHeight = Turbine.UI.Display:GetHeight();
    local desiredHeight = math.max(XP_MIN_HEIGHT, (#characters * 20) + XP_BASE_HEIGHT);
    local windowHeight = math.min(desiredHeight, displayHeight - 100);

    UIShowXP = Turbine.UI.Lotro.GoldWindow();
    UIShowXP:SetSize(XP_WINDOW_WIDTH, windowHeight);
    UIShowXP:SetText(T["PluginXPWindow"]);
    UIShowXP:SetPosition(
        (Turbine.UI.Display:GetWidth() - UIShowXP:GetWidth()) / 2,
        (displayHeight - UIShowXP:GetHeight()) / 2
    );
    UIShowXP:SetZOrder(10);
    UIShowXP:SetWantsKeyEvents(true);
    UIShowXP:SetVisible(false);

    local footer = Turbine.UI.Label();
    footer:SetParent(UIShowXP);
    footer:SetSize(150, 10);
    footer:SetPosition(UIShowXP:GetWidth() / 2 - 75, UIShowXP:GetHeight() - 20);
    footer:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    footer:SetText(T["PluginText"]);

    DisplayHelpButton(UIShowXP, XP_WINDOW_WIDTH, 4);

    local listbox = Turbine.UI.ListBox();
    listbox:SetParent(UIShowXP);
    listbox:SetSize(XP_WINDOW_WIDTH - 45, windowHeight - 140);
    listbox:SetPosition(20, 70);
    listbox:SetMouseVisible(true);
    listbox:SetZOrder(20);

    for _, characterName in ipairs(characters) do
        CreateXPRow(listbox, characterName);
    end

    local scrollbar = Turbine.UI.Lotro.ScrollBar();
    scrollbar:SetParent(UIShowXP);
    scrollbar:SetOrientation(Turbine.UI.Orientation.Vertical);
    scrollbar:SetPosition(XP_WINDOW_WIDTH - 20, 70);
    scrollbar:SetSize(10, windowHeight - 140);
    scrollbar:SetBackColor(Turbine.UI.Color(.1, .1, .2));
    scrollbar:SetMinimum(0);
    scrollbar:SetMaximum(math.max(0, (#characters * XP_ROW_HEIGHT) - listbox:GetHeight()));
    scrollbar:SetValue(0);
    listbox:SetVerticalScrollBar(scrollbar);

    EscapeKeyHandlerForWindows(UIShowXP, settings["isXPWindowVisible"]["value"]);
end
